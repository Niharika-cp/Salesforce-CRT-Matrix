public with sharing class BatchPromotionBranchSchedule implements Database.Batchable<sObject>,Database.stateful,Database.AllowsCallouts {   // This class is used for Scheduling Promotion record cleanup


    Date today =System.today();
    Date LAST_N_MONTHS ;
    
    public string repositoryId;
    public string serverURL;
    public string copadoAPIKey;
    public string keepThoseBranches;


    public BatchPromotionBranchSchedule(Integer n,string repositoryId , string serverURL, string copadoAPIKey, string keepThoseBranches) {

        LAST_N_MONTHS= today.addMonths(-n);
        
        this.repositoryId = repositoryId;
        this.serverURL = serverURL; 
        this.copadoAPIKey = copadoAPIKey;
        this.keepThoseBranches = keepThoseBranches;
        
    }


    public Database.QueryLocator start(Database.BatchableContext bc){ 
        
        if(Test.isRunningTest()){
            
             return Database.getQueryLocator(
                        'SELECT Id, Name, copado__Status__c, copado__CheckOnly__c, copado__Branch__c, copado__Order__c, copado__Deployment__c, Is_Deleted__c ' +
                        'FROM copado__Step__c ' +
                        'WHERE copado__Branch__c LIKE \'promotion%\' AND Is_Deleted__c = false AND copado__Branch__c <> null ' 
                        
                    );        
        }
        else{
             return Database.getQueryLocator(
            'SELECT Id, Name, copado__Status__c,LastModifiedDate, copado__CheckOnly__c, copado__Branch__c, copado__Order__c, copado__Deployment__c, Is_Deleted__c ' +
            'FROM copado__Step__c ' +
            'WHERE copado__Branch__c LIKE \'promotion%\' AND Is_Deleted__c = false AND copado__Branch__c <> null AND LastModifiedDate <=: LAST_N_MONTHS' +
            'WITH SECURITY_ENFORCED'
        );
     }

}

public void execute(Database.BatchableContext bc, List<copado__Step__c> stepList){

    
        try {
               
            if(!stepList.isEmpty()){

                Set<Id> oldDeployments = new Set<Id>(); //Set of old Deployments. Will be filled and used by the script.

                //This will query the steps associated with branches. All Validation steps and unsuccessful git promotions. 
                String bodyJSON = '{"gitBranches":[';

                String bodyEnd = ']}';             
                                                        
               List<copado__Step__c> oldsteps = new List<copado__Step__c>();

               List<Id> promoIdList = new List<Id>(); 

               for(copado__Step__c objStep : [SELECT Id, Name,copado__Branch__c,Is_Deleted__c,copado__Deployment__r.Name,copado__Deployment__c,copado__CheckOnly__c,copado__Status__c  FROM copado__Step__c  where id IN : stepList ]){
                    oldsteps.add(objStep);
                    promoIdList.add(objStep.Id);
               }                            
               
                // LIMIT 10 You can set a limit here if required

                //This will get the branch names and add to JSON String

                Set<String> oldPromotionBranchNames = new Set<String>();

         for( Integer i = 0; i< oldsteps.size(); i++){

                if(String.isBlank(keepThoseBranches) || !keepThoseBranches.contains(oldsteps[i].copado__Branch__c)){

                        oldPromotionBranchNames.add(oldsteps[i].copado__Branch__c);
                        oldDeployments.add(oldsteps[i].copado__Deployment__c);


                        bodyJSON += '"' + oldsteps[i].copado__Branch__c + '"';

                        if(i < oldsteps.size()-1){

                            bodyJson += ',';

                        }
                }

            }

                bodyJSON += bodyEnd;

                //This will set the Endpoint URL

                String url = serverURL +'/json/v1/webhook/deleteGitBranches/' + repositoryId +'?api_key=' + copadoAPIKey;

                //This will launch the Webhook

                // Instantiate a new http object

                Http h = new Http();

                // This will instantiate a new HTTP request, specify the method as well as the endpoint

                HttpRequest req = new HttpRequest();

                req.setEndpoint(url);

                req.setMethod('POST');

                req.setHeader('Content-Type', 'application/json;charset=UTF-8');

                req.setBody(bodyJSON);

                // This will send the request, and return a response

                HttpResponse res;
                if(!test.isRunningTest()) {
                    res = h.send(req);
                   }

                CentralClass.PromotionBackup(promoIdList);

               List<copado__Step__c> copStepList = new List<copado__Step__c>();

                for(copado__Step__c objStep : [select Id,Name,Is_Deleted__c,copado__Branch__c from copado__Step__c where id IN : promoIdList]){
                    objStep.Is_Deleted__c = true;
                    copStepList.add(objStep);
                }
                Update(copStepList);

      
         }
    } catch (Exception e) {
        throw new AuraHandledException(e.getMessage());
        } 
}

        public void finish(Database.BatchableContext bc){
        
        }
}