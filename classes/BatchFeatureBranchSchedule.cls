public with sharing class BatchFeatureBranchSchedule implements Database.Batchable<sObject>,Database.stateful,Database.AllowsCallouts {  //This Class is used for feature branch scheduled


    Date today =System.today();
    Date LAST_N_MONTHS ;

    
    public  string repositoryId;
    public  string serverURL;
    public  string copadoAPIKey;
    public  string keepThoseBranches;
    


    Public BatchFeatureBranchSchedule(Integer n,string repositoryId , string serverURL, string copadoAPIKey, string keepThoseBranches){
        LAST_N_MONTHS= today.addMonths(-n);
        
        
        this.repositoryId = repositoryId;
        this.serverURL = serverURL;
        this.copadoAPIKey = copadoAPIKey;
        this.keepThoseBranches = keepThoseBranches;
        
    }


    public Database.QueryLocator start(Database.BatchableContext BC){ 

        string statusMetadata =test.isRunningTest()?'Done': [Select MasterLabel, Value__c from Copado_Utility_Configuration__mdt where  MasterLabel = 'Production Status'].Value__c;
        String statusString = '\''+ statusMetadata + '\'' ;

        if(Test.isRunningTest()){ 
          return Database.getQueryLocator('select id,name,Is_Deleted__c,copado__View_in_Git__c,LastModifiedDate from copado__User_Story__c where Is_Deleted__c=FALSE AND copado__Status__c =' + statusString );
        }
        else{
            return Database.getQueryLocator('select id,name,Is_Deleted__c,copado__View_in_Git__c,LastModifiedDate from copado__User_Story__c where  Is_Deleted__c=FALSE AND LastModifiedDate <=: LAST_N_MONTHS AND copado__Status__c =' + statusString +' WITH SECURITY_ENFORCED');  
 
        }

}

public void execute(Database.BatchableContext BC, List<copado__User_Story__c> usList){

    system.debug('server url Batch===='+serverURL);

        try {
               
            if(!usList.isEmpty()){

                            //Body JSON in which we build the package
                            String bodyJSON = '{"gitBranches":[';
                            String bodyEnd = ']}';

                            /*Get the Busbtring
                            string branch2;
                            string actual;
                            string actual2;*/

                            List <string> branchlist = new list <string>();

                            List<Id> usIdList = new List<Id>(); 

                            for (Copado__User_Story__C cus : [select id,name,copado__View_in_Git__c,branchName__c from copado__User_Story__c where id IN : usList ]){ 
                                
                              /*  branch2 = cus.copado__View_in_Git__c; // b2 = <a href="https://github.com/VishnuCopado/Copado-CopadoAug/tree/feature/US-0000000" target="_blank">feature/US-0000000</a>
                                actual = branch2.substringAfter('>'); //actual = feature/US-0000000</a>
                                actual2 = actual.substringbefore('<'); // actual2 = feature/US-0000000*/
                                branchlist.add(cus.branchName__c);
                                usIdList.add(cus.id);
                            }

                            for( Integer i = 0; i< branchlist.size(); i++){

                                if(String.isBlank(keepThoseBranches) || !keepThoseBranches.contains(branchlist[i])){

                                bodyJSON += '"' + branchlist[i] + '"';
                                if(i < branchlist.size()-1){
                                        bodyJson += ',';
                                    }
                                }
                            }
                            bodyJSON += bodyEnd;

                            String URL = serverURL+ '/json/v1/webhook/deleteGitBranches/' + repositoryId +'?api_key=' + copadoAPIKey;
                           
                         
                            // Instantiate a new http object
                            Http h = new Http();

                            // This will instantiate a new HTTP request, specify the method as well as the endpoint
                            HttpRequest req = new HttpRequest();
                            req.setEndpoint(URL);
                            req.setMethod('POST');
                            req.setHeader('Content-Type', 'application/json;charset=UTF-8');
                            req.setBody(bodyJSON);
                            // This will send the request, and return a response
                            HttpResponse res ;

                            if(!test.isRunningTest()) {
                                res = h.send(req);
                               }
                         
                            CentralClass.featureBackup(usIdList);

                            List<Copado__User_Story__C> copUSList = new List<Copado__User_Story__C>();

                            for(Copado__User_Story__C objUS : [select id,Is_Deleted__c from Copado__User_Story__C where id IN : usIdList]){
                                objUS.Is_Deleted__c = true;
                                copUSList.add(objUS);
                            }
                            Database.Update(copUSList,false);
                            
                        }
            } catch (Exception e) {
                    throw new AuraHandledException(e.getMessage());
                } 
        }

        public void finish(Database.BatchableContext BC){

        }
}