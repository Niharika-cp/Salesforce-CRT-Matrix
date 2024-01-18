public with sharing class CentralClass {
    
    // Fetch All Object Record 
        @AuraEnabled
                public static List<sObject> getsObjectRecord(Integer months,string objectName){
                    
                    Map<String, Schema.SObjectType> schemaMap = Schema.getGlobalDescribe();
                    
                    Map<String, Schema.SObjectField> fieldMap = schemaMap.get(objectName).getDescribe().fields.getMap();
            
                    String commaSepratedFields = '';

                    string statusMetadata = [Select MasterLabel, Value__c from Copado_Utility_Configuration__mdt where  MasterLabel = 'Production Status'].Value__c;
                    String statusString = '\''+ statusMetadata + '\'' ;

                    for(String fieldName : fieldMap.keyset()){
                        if(commaSepratedFields == null || commaSepratedFields == ''){
                            commaSepratedFields = fieldName;
                        }else{
                            commaSepratedFields = commaSepratedFields + ', ' + fieldName;
                        }
                    }
                  
                    try {
                        Date today =System.today();
                        Date LAST_N_MONTHS;
                                    if(months == 3){
                                                LAST_N_MONTHS = today.addMonths(-3);
                                    }
                                    else{
                                         if(months == 6){
                                                LAST_N_MONTHS = today.addMonths(-6);
                                            
                                         }
                                         else{
                                            if(months == 12){
                                                   LAST_N_MONTHS = today.addMonths(-12);
                                            }
                                       }    
                                    }      
                                    string query ;

                                    if(Test.isRunningTest()){
                                      //  query = 'SELECT ' +  commaSepratedFields +  ' from ' + objectName + ' WITH SECURITY_ENFORCED';
                                      query = 'SELECT Name,createdDate,LastModifiedDate from ' + objectName + ' WITH SECURITY_ENFORCED ';
                                    }
                                    else {
                                        if(objectName == 'copado__User_Story__c'){
                                            query = 'SELECT Name,createdDate,LastModifiedDate,copado__Exclude_From_CBM__c,copado__Stop_Indexing_Metadata__c,copado__Status__c from ' + objectName + '  WHERE copado__Exclude_From_CBM__c = false AND copado__Stop_Indexing_Metadata__c = false AND copado__Status__c =' + statusString +' WITH SECURITY_ENFORCED'; 

                                        }
                                        else{
                                        //query = 'SELECT ' +  commaSepratedFields +  ' from ' + objectName + 'WHERE LastModifiedDate <=: LAST_N_MONTHS WITH SECURITY_ENFORCED'; 
                                        query = 'SELECT Name,createdDate,LastModifiedDate from ' + objectName + ' WHERE LastModifiedDate <=: LAST_N_MONTHS  WITH SECURITY_ENFORCED';
                                    }
                                }
                                 
                                    List<sObject> objList  = Database.Query(query);

                                   return objList ;
                                  
    
                    } catch (Exception e) {
                        throw new AuraHandledException(e.getMessage());
                    }
                }

    //Delete Record
        @AuraEnabled
        public static string sObjectRecordDeleted(List<Id> sObjectRecordIdList,string objectName){
          
          try {
                if(!sObjectRecordIdList.isEmpty()){

                    string query = 'select id from ' +objectName+ ' where Id IN : sObjectRecordIdList';

                    List<sObject> objList  = Database.Query(query);
                  
                    softRecordBackup(sObjectRecordIdList,objectName);

                    Database.delete (objList,false);
                    
                    return 'Records get deleted...!!!';
                }
                else{
                    return 'Something went wrong';
                }
            } catch (Exception e) {
                throw new AuraHandledException(e.getMessage());
            }
        }

        //Records Backup for Soft Delete

        public static void softRecordBackup(List<Id> sObjectRecordIdList,string objectName){

             List<AuditLog__c> auditLogList = new List<AuditLog__c>();

             List<RecordType> rtList = [SELECT Id, Name, DeveloperName,sobjecttype FROM RecordType where Sobjecttype='AuditLog__c'  AND  DeveloperName = 'Record_Type'];
                    try{

                        if(!sObjectRecordIdList.isEmpty()){

                                    string query = 'select id,Name from ' +objectName+ ' where Id IN : sObjectRecordIdList';

        
                                    List<sObject> objList  = Database.Query(query);

                                        for( sObject obj : objList){
                                            
                                            AuditLog__c objAudit = new AuditLog__c();

                                            String name = (String)obj.get('Name');
                                            
                                            objAudit.Name = name;
                                            objAudit.RecordTypeid=rtlist[0].id;

                                            objAudit.Deletion_Type__c = 'Soft Delete';
                                            objAudit.Action__c = 'Deleted Records ' +name;
                                            auditLogList.add(objAudit);
                                        }
                                        
                                        Database.insert(auditLogList,false);
                            }
                    } 
                    catch(Exception e) {
                        System.debug( e.getmessage());
                    }

                }
      
    
    
    //Hard Delete Record
        @AuraEnabled
        public static string sObjectRecordHardDeleted(List<Id> sObjectRecordIdList,string objectName){
            try {
                if(!sObjectRecordIdList.isEmpty()){

                    string query = 'select id from ' +objectName+ ' where Id IN : sObjectRecordIdList';

                    List<sObject> objList  = Database.Query(query);

                    hardRecordBackup(sObjectRecordIdList,objectName);

                    Database.delete (objList,false);

                    DataBase.emptyRecycleBin(objList); 

                    return 'Records get deleted...!!!';
                }
                else{
                    return 'There is no records are selected';
                }
            } catch (Exception e) {
                throw new AuraHandledException(e.getMessage());
            }
        }
    


        //Records Backup for Hard Delete

        public static void hardRecordBackup(List<Id> sObjectRecordIdList,string objectName){

             List<AuditLog__c> auditLogList = new List<AuditLog__c>();

             List<RecordType> rtList = [SELECT Id, Name, DeveloperName,sobjecttype FROM RecordType where sobjecttype='AuditLog__c'  AND  DeveloperName = 'Record_Type'];

                    try{

                        if(!sObjectRecordIdList.isEmpty()){

                                    string query = 'select id,Name from ' +objectName+ ' where Id IN : sObjectRecordIdList';
        
                                    List<sObject> objList  = Database.Query(query);

                                        for( sObject obj : objList){
                                            
                                            AuditLog__c objAudit = new AuditLog__c();

                                            String name = (String)obj.get('Name');
                                            
                                            objAudit.Name = name;
                                            objAudit.RecordTypeid=rtlist[0].id;

                                           // system.debug(' Record Type Id ===='+objAudit.RecordTypeid);
                                            objAudit.Deletion_Type__c = 'Hard Delete';
                                            objAudit.Action__c = 'Deleted Records ' +name;
                                            auditLogList.add(objAudit);
                                            
                                        }
                                        
                                        Database.insert(auditLogList,false);
                            }
                    } 
                    catch(Exception e) {
                        System.debug( e.getmessage());
                    }

                }
    
    //Scheduled Job
        @AuraEnabled
        public static void callScheduleClass(String jobName,String cron,Integer month,string objectName){
           
            try {
                ScheduledSixMonthBatchClass objmonthDelSchClass=New ScheduledSixMonthBatchClass(month,objectName);
               
                system.schedule(jobName, cron, objmonthDelSchClass);
                
            } catch (Exception e) {
                throw new AuraHandledException(e.getMessage());
            }
        }


//Feature Branch and Promotion Branch Cleanup

   @AuraEnabled
   public static List<copado__User_Story__c> getuserStoryBranchRecord(Integer months){
    try {
                Date today =System.today();
                Date LAST_N_MONTHS;
              
                            if(months == 3){
                                        LAST_N_MONTHS = today.addMonths(-3);
                            }
                            else{
                                if(months == 6){
                                        LAST_N_MONTHS = today.addMonths(-6);
                                    
                                }
                                else{
                                    if(months == 12){
                                           LAST_N_MONTHS = today.addMonths(-12);
                                    }
                               }    
                            }     

                            String query;

                            string statusMetadata = [Select MasterLabel, Value__c from Copado_Utility_Configuration__mdt where  MasterLabel = 'Production Status'].Value__c;
                            String statusString = '\''+ statusMetadata + '\'' ;
                            
                            
                           // List<copado__User_Story__c> USList ;
                            
                            if(Test.isRunningTest()){
                                query = 'select id,name,copado__Release__c,BranchName__c,Is_Deleted__c,Project_Name__c,Environment_Name__c,Release_Name__c,copado__Exclude_From_CBM__c,copado__Stop_Indexing_Metadata__c,copado__Status__c from copado__User_Story__c WHERE Is_Deleted__c = false AND BranchName__c<>null AND copado__Exclude_From_CBM__c = false AND copado__Stop_Indexing_Metadata__c = false AND copado__Status__c =' + statusString +' WITH SECURITY_ENFORCED';
                                
                            }
                            else{
                                query = 'select id,name,copado__Release__c,BranchName__c,Is_Deleted__c,LastModifiedDate,Project_Name__c,Environment_Name__c,Release_Name__c,copado__Exclude_From_CBM__c,copado__Stop_Indexing_Metadata__c,copado__Status__c from copado__User_Story__c WHERE Is_Deleted__c = false AND BranchName__c<>null AND copado__Exclude_From_CBM__c = false AND copado__Stop_Indexing_Metadata__c = false AND copado__Status__c =' + statusString +'  AND LastModifiedDate <=: LAST_N_MONTHS  WITH SECURITY_ENFORCED';
                                
                            }

                            List<copado__User_Story__c> usList  = Database.Query(query);
                          
                             return usList ;
                                  
            } catch (Exception e) {
                throw new AuraHandledException(e.getMessage());
            }
}
   
       //Fetch Step Object Record 
        @AuraEnabled
                public static List<copado__Step__c> getStepObjectRecordList(Integer months){
                    
                  
                    try {
                     Date today =System.today();
                        Date LAST_N_MONTHS;
                                        
                                    if(months == 3){
                                                LAST_N_MONTHS = today.addMonths(-3);
                                            
                                    }
                                    else{
                                         if(months == 6){
                                                LAST_N_MONTHS = today.addMonths(-6);
                                            
                                         }
                                         else{
                                            if(months == 12){
                                                   LAST_N_MONTHS = today.addMonths(-12);
                                            }
                                       }    
                                    }  

                                  
                                    List<copado__Step__c> stepPromotionRecordList ;
                                    
                                    if(Test.isRunningTest()){
                                        stepPromotionRecordList = [Select Id,Name,copado__Status__c,copado__CheckOnly__c,copado__Branch__c,copado__Deployment__c,Is_Deleted__c from copado__Step__c WHERE copado__Branch__c  LIKE 'promotion%' AND  Is_Deleted__c = false AND copado__Branch__c<>null WITH SECURITY_ENFORCED];
                                    }
                                    else{
                                        stepPromotionRecordList = [Select Id,Name,LastModifiedDate,copado__Status__c,copado__CheckOnly__c,copado__Branch__c,copado__Deployment__c,Is_Deleted__c from copado__Step__c WHERE copado__Branch__c LIKE 'promotion%' AND Is_Deleted__c = false AND copado__Branch__c<>null  AND LastModifiedDate <=: LAST_N_MONTHS  WITH SECURITY_ENFORCED];
                                    }
                                    
                                    return stepPromotionRecordList;
                    } catch (Exception e) {
                        throw new AuraHandledException(e.getMessage());
                    }
                }

  

//Feature Cleanup Method Start
    @AuraEnabled
        public static string practiceFeatureMethod(List<Id> recordIdList,string serverURL,string repositoryId, string copadoAPIKey,List<string> keepThoseBranches){
            system.debug('recordIdList =='+recordIdList);
            system.debug('serverURL =='+serverURL);
            system.debug('repositoryId =='+repositoryId);
            system.debug('copadoAPIKey =='+copadoAPIKey);
           
            try {
               
                if(!recordIdList.isEmpty()){

                                //Body JSON in which we build the package
                                String bodyJSON = '{"gitBranches":[';
                                String bodyEnd = ']}';

                                //Get the Busbtring
                                string branch2;
                                string actual;
                                string actual2;

                                List <string> branchlist = new list <string>();
                                
                                for (Copado__User_Story__C cus : [select id,name,copado__View_in_Git__c from copado__User_Story__c where id IN : recordIdList  WITH SECURITY_ENFORCED]){ 
                                    
                                    branch2 = cus.copado__View_in_Git__c; // b2 = <a href="https://github.com/VishnuCopado/Copado-CopadoAug/tree/feature/US-0000000" target="_blank">feature/US-0000000</a>
                                    actual = branch2.substringAfter('>'); //actual = feature/US-0000000</a>
                                    actual2 = actual.substringbefore('<'); // actual2 = feature/US-0000000
                                    branchlist.add(actual2);
                                }

                                for( Integer i = 0; i< branchlist.size(); i++){

                                    if(!keepThoseBranches.contains(branchlist[i])){

                                    bodyJSON += '"' + branchlist[i] + '"';
                                    if(i < branchlist.size()-1){
                                            bodyJson += ',';
                                        }
                                    }
                                }
                                bodyJSON += bodyEnd;
                               System.debug('&&Body of JSON :- '+bodyJSON);

                                String URL = serverURL+ '/json/v1/webhook/deleteGitBranches/' + repositoryId +'?api_key=' + copadoAPIKey;
                               system.debug('URL=='+URL);
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

                                featureBackup(recordIdList);

                                List<Copado__User_Story__C> copUSList = new List<Copado__User_Story__C>();

                                for(Copado__User_Story__C objUS : [select id,Is_Deleted__c from Copado__User_Story__C where id IN : recordIdList]){
                                    objUS.Is_Deleted__c = true;
                                    copUSList.add(objUS);
                                }
                                Update(copUSList);

                                return 'Records get deleted...!!!';

                }
                else{
                    return 'There is no records are selected';
                }

            } catch (Exception e) {
                throw new AuraHandledException(e.getMessage());
            } 
        }

////PROMOTION Cleanup Method Start
        @AuraEnabled
        public static string practicePromotionRecord(List<Id> recordIdList,string serverURL,String repositoryId,string copadoAPIKey,List<String> keepThoseBranches){
           
            try {
                if(!recordIdList.isEmpty()){
                                        //This will set the timeframe of the branch creation. We want to delete validation and unsuccessful promotions older than three months. 
                                        //Date someDaysAgo = Date.today().addDays(-90); //Variable Input provide from use

                                        //This will prevent to remove any Org branch. Set the branches name according to the branches of your repository.
                                        // List<String> keepThoseBranches = new List<String>{'master', 'stage','test','preprod','dev','uat','int'}; //Variable Input provide from user

                                        //String repositoryId = 'a0q8d000000ADYMAA4'; //Variable Input provide from user 
                                        //String copadoURL = 'https://api.backend.copado.com'; //Variable input provide from user
                                        //String copadoAPIKey =  '5cfad51e160d71ca9357a573b296b692'; //Variable Input provide from user.  

                                        Set<Id> oldDeployments = new Set<Id>(); //Set of old Deployments. Will be filled and used by the script.


                                        //This will query the steps associated with branches. All Validation steps and unsuccessful git promotions. 
                                        String bodyJSON = '{"gitBranches":[';

                                        String bodyEnd = ']}';

                                        List<copado__Step__c> oldsteps = [SELECT 
                                                                                Id, 
                                                                                Name,
                                                                                copado__Branch__c,
                                                                                copado__Deployment__c,  
                                                                                copado__Deployment__r.Name,                               
                                                                                copado__Status__c, 
                                                                                copado__CheckOnly__c,
                                                                                Is_Deleted__c   
                                                                        FROM 
                                                                                copado__Step__c  where id IN : recordIdList  WITH SECURITY_ENFORCED];                    
                                                                                                      
                                                                        

                                        // LIMIT 10 You can set a limit here if required

                                        //This will get the branch names and add to JSON String

                                        Set<String> oldPromotionBranchNames = new Set<String>();

                                 for( Integer i = 0; i< oldsteps.size(); i++){

                                        if(!keepThoseBranches.contains(oldsteps[i].copado__Branch__c)){

                                                oldPromotionBranchNames.add(oldsteps[i].copado__Branch__c);
                                                oldDeployments.add(oldsteps[i].copado__Deployment__c);


                                                bodyJSON += '"' + oldsteps[i].copado__Branch__c + '"';

                                                if(i < oldsteps.size()-1){

                                                    bodyJson += ',';

                                                }
                                        }

                                    }

                                    bodyJSON += bodyEnd;
                                        System.debug('&&Body of JSON :- '+bodyJSON);

                                      //  System.debug('body json'+bodyJSON);

                                        //This will set the Endpoint URL

                                        String URL = serverURL +'/json/v1/webhook/deleteGitBranches/' + repositoryId +'?api_key=' + copadoAPIKey;

                                      //  System.debug('**URL- '+URL);

                                        //This will launch the Webhook

                                        // Instantiate a new http object

                                        Http h = new Http();

                                        // This will instantiate a new HTTP request, specify the method as well as the endpoint

                                        HttpRequest req = new HttpRequest();

                                        req.setEndpoint(URL);

                                        req.setMethod('POST');

                                        req.setHeader('Content-Type', 'application/json;charset=UTF-8');

                                        req.setBody(bodyJSON);

                                        // This will send the request, and return a response

                                      //  HttpResponse res = h.send(req);

                                    HttpResponse res ;
                                       if(!test.isRunningTest()) {
                                            res = h.send(req);
                                        }

                                        PromotionBackup(recordIdList);

                                        List<copado__Step__c> copStepList = new List<copado__Step__c>();

                                        for(copado__Step__c objstep : [select Id,Name,Is_Deleted__c from copado__Step__c where id IN : recordIdList]){
                                            objstep.Is_Deleted__c = true;
                                            copStepList.add(objstep);
                                        }
                                        Update(copStepList);

                                        return 'Records get deleted...!!!';


                                    }
                                    else{
                                        return 'There is no records are selected';
                                    }

            } catch (Exception e) {
                throw new AuraHandledException(e.getMessage());
            }
        }
       
        
    public static void featureBackup(List<Id> recordIdList){
                String branch2;
                String actual;
                List<AuditLog__c> auditLogList = new List<AuditLog__c>();

                List<RecordType> rtList = [SELECT Id, Name, DeveloperName,sobjecttype FROM RecordType where Sobjecttype='AuditLog__c'  AND  DeveloperName = 'Branch_Type'];

                try{
                    for(copado__User_Story__c objUS : [select id, Name, copado__View_in_Git__c from copado__User_Story__c where Id IN :recordIdList]){
                        
                        AuditLog__c objAudit = new AuditLog__c();
                        branch2 = objUS.copado__View_in_Git__c;// b2 = <a href="https://github.com/VishnuCopado/Copado-CopadoAug/tree/feature/US-0000000" target="_blank">feature/US-0000000</a>
                        actual = branch2.substringAfter('>'); //actual = feature/US-0000000</a>
                        objAudit.Name = actual.substringbefore('<');

                        objAudit.RecordTypeid=rtlist[0].id;
                        objAudit.Action__c = 'Deleted Branch ' +objUS.Name;
                        objAudit.Deletion_Type__c = 'Hard Delete';
                        auditLogList.add(objAudit);
                        
                    }
                    
                    Database.insert(auditLogList,false);
                } 
                catch(Exception e) {
                    throw new AuraHandledException(e.getMessage());
                }
            }


    public static void PromotionBackup(List<Id> recordIdList){
                
                List<AuditLog__c> auditLogList = new List<AuditLog__c>();

                List<RecordType> rtList = [SELECT Id, Name, DeveloperName,sobjecttype FROM RecordType where Sobjecttype='AuditLog__c'  AND  DeveloperName = 'Branch_Type'];

                try{
                    for(copado__Step__c objstep : [Select Id,Name,copado__Branch__c,Is_Deleted__c from copado__Step__c where Id IN :recordIdList]){
                        
                        AuditLog__c objAudit = new AuditLog__c();
                        objAudit.Name = objstep.copado__Branch__c;
                        objAudit.RecordTypeid=rtlist[0].id;
                        objAudit.Action__c = 'Deleted Branch ' +objstep.Name;
                        objAudit.Deletion_Type__c = 'Hard Delete';
                        auditLogList.add(objAudit);
                        
                    }
                    
                    Database.insert(auditLogList,false);
                } 
                catch(Exception e) {
                    throw new AuraHandledException(e.getMessage());
                }
        }


        //Scheduled feature Branch 
        @AuraEnabled
        public static void callFeatureScheduleClass(String jobName,String cron,Integer month,string repositoryId , string serverURL, string copadoAPIKey, string keepThoseBranches){
          
            try {
                ScheduledFeatureBranchClass objSchFeature=New ScheduledFeatureBranchClass(month,repositoryId,serverURL,copadoAPIKey,keepThoseBranches);
                system.schedule(jobName, cron, objSchFeature);
                
            } catch (Exception e) {
                throw new AuraHandledException(e.getMessage());
            }
        }


        @AuraEnabled
        public static void callPromotionScheduleClass(String jobName,String cron,Integer month,string repositoryId , string serverURL, string copadoAPIKey, string keepThoseBranches){
          
            try {
                ScheduledPromotionBranchClass objSchPromotion=New ScheduledPromotionBranchClass(month,repositoryId,serverURL,copadoAPIKey,keepThoseBranches);
                system.schedule(jobName, cron, objSchPromotion);
        
            } catch (Exception e) {
                throw new AuraHandledException(e.getMessage());
            }
        }


        @AuraEnabled
        public static List<copado__User_Story__c> getsObjectRecordForArchieved(Integer months){
            try {
                Date today =System.today();
                Date LAST_N_MONTHS;
                            if(months == 3){
                                        LAST_N_MONTHS = today.addMonths(-3);
                                    
                            }
                            else{
                                 if(months == 6){
                                        LAST_N_MONTHS = today.addMonths(-6);
                                    
                                 }
                                 else{
                                    if(months == 12){
                                           LAST_N_MONTHS = today.addMonths(-12);
                                    }
                               }    
                            }      
                            string query ;

                            string statusMetadata = [Select MasterLabel, Value__c from Copado_Utility_Configuration__mdt where  MasterLabel = 'Production Status'].Value__c;
                            String statusString = '\''+ statusMetadata + '\'' ;
                           
                            if(Test.isRunningTest()){
                              //  query = 'SELECT ' +  commaSepratedFields +  ' from ' + objectName + ' WITH SECURITY_ENFORCED';
                              query = 'SELECT Name,createdDate,LastModifiedDate,copado__Status__c,copado__Exclude_From_CBM__c,copado__Stop_Indexing_Metadata__c from  copado__User_Story__c WHERE copado__Exclude_From_CBM__c = false AND copado__Stop_Indexing_Metadata__c = false AND copado__Status__c =' + statusString +' WITH SECURITY_ENFORCED ';
                            }
                            else {
                                //query = 'SELECT ' +  commaSepratedFields +  ' from ' + objectName + 'WHERE LastModifiedDate <=: LAST_N_MONTHS WITH SECURITY_ENFORCED'; 
                                query = 'SELECT Name,createdDate,LastModifiedDate,copado__Status__c,copado__Exclude_From_CBM__c,copado__Stop_Indexing_Metadata__c from  copado__User_Story__c  WHERE  LastModifiedDate <=: LAST_N_MONTHS AND copado__Exclude_From_CBM__c = false AND copado__Stop_Indexing_Metadata__c = false AND copado__Status__c =' + statusString +' WITH SECURITY_ENFORCED';
                            }
                           
                            List<copado__User_Story__c> objUSList  = Database.Query(query);

                           return objUSList ;
                          

            } catch (Exception e) {
                throw new AuraHandledException(e.getMessage());
            }
        }


        @AuraEnabled
        public static List<copado__User_Story__c> getsObjectRecordForUnArchieved(Integer months){
            try {
                Date today =System.today();
                Date LAST_N_MONTHS;
                            if(months == 3){
                                        LAST_N_MONTHS = today.addMonths(-3);
                                    
                            }
                            else{
                                 if(months == 6){
                                        LAST_N_MONTHS = today.addMonths(-6);
                                    
                                 }
                                 else{
                                    if(months == 12){
                                           LAST_N_MONTHS = today.addMonths(-12);
                                    }
                               }    
                            }      
                            string query ;

                            string statusMetadata = [Select MasterLabel, Value__c from Copado_Utility_Configuration__mdt where  MasterLabel = 'Production Status'].Value__c;
                            String statusString = '\''+ statusMetadata + '\'' ;
                           
                            if(Test.isRunningTest()){
                              //  query = 'SELECT ' +  commaSepratedFields +  ' from ' + objectName + ' WITH SECURITY_ENFORCED';
                              query = 'SELECT Name,createdDate,LastModifiedDate,copado__Status__c,copado__Exclude_From_CBM__c,copado__Stop_Indexing_Metadata__c from  copado__User_Story__c WHERE copado__Exclude_From_CBM__c = true AND copado__Stop_Indexing_Metadata__c = true AND copado__Status__c =' + statusString +' WITH SECURITY_ENFORCED ';
                            }
                            else {
                                //query = 'SELECT ' +  commaSepratedFields +  ' from ' + objectName + 'WHERE LastModifiedDate <=: LAST_N_MONTHS WITH SECURITY_ENFORCED'; 
                                query = 'SELECT Name,createdDate,LastModifiedDate,copado__Status__c,copado__Exclude_From_CBM__c,copado__Stop_Indexing_Metadata__c from  copado__User_Story__c  WHERE  LastModifiedDate <=: LAST_N_MONTHS AND copado__Exclude_From_CBM__c = true AND copado__Stop_Indexing_Metadata__c = true AND copado__Status__c =' + statusString +' WITH SECURITY_ENFORCED';
                            }
                           
                            List<copado__User_Story__c> objUSList  = Database.Query(query);

                           return objUSList ;
                          

            } catch (Exception e) {
                throw new AuraHandledException(e.getMessage());
            }
        }



        @AuraEnabled
        public static void archivedRecord(List<Id> recordIdList){
            try {
                List<Copado__User_Story__C> copUSList = new List<Copado__User_Story__C>();

                for(Copado__User_Story__C objUS : [select id,copado__Exclude_From_CBM__c,copado__Stop_Indexing_Metadata__c from Copado__User_Story__C where id IN : recordIdList]){
                    objUS.copado__Exclude_From_CBM__c = true;
                    objUS.copado__Stop_Indexing_Metadata__c = true;
                    copUSList.add(objUS);
                }
                Update(copUSList);
 
            } catch (Exception e) {
                throw new AuraHandledException(e.getMessage());
            }
        }

        @AuraEnabled
        public static void unArchivedRecord(List<Id> recordIdList){
            try {
                List<Copado__User_Story__C> copUSList = new List<Copado__User_Story__C>();

                for(Copado__User_Story__C objUS : [select id,copado__Exclude_From_CBM__c,copado__Stop_Indexing_Metadata__c from Copado__User_Story__C where id IN : recordIdList]){
                    objUS.copado__Exclude_From_CBM__c = false;
                    objUS.copado__Stop_Indexing_Metadata__c = false;
                    copUSList.add(objUS);
                }
                Update(copUSList);
 
            } catch (Exception e) {
                throw new AuraHandledException(e.getMessage());
            }
        }


        @AuraEnabled
        public static List<sObject> getSelectedParentrecords(string objectName,List<Id> recordIdList){
            String query = 'SELECT Name,createdDate,LastModifiedDate from ' + objectName + ' where Id IN : recordIdList';
            if(objectName == 'Copado__User_Story__c'){
                query = 'SELECT Name,createdDate,LastModifiedDate,copado__Status__c from ' + objectName + ' where Id IN : recordIdList';
            }
            List<sObject> objList  = Database.Query(query);
            return objList;//testing one
        }

        @AuraEnabled
        public static List<wrapperClassCleanup> callwrapperClassCleanup(string objectName,List<Id> recordIdList){
            
            List<string> childObjectList =  new List<string>();

            for(Object_Mapping__mdt objMap: [select id,DeveloperName,label,ChildObjects__c from Object_Mapping__mdt where label = :objectName]){
                 
                childObjectList = objMap.ChildObjects__c<>'NA'? objmap.ChildObjects__c.split(','): new List<String>();
            }

                List<wrapperClassCleanup> wrapList = new List<wrapperClassCleanup>();
                
                string objectNameCon = objectName.replace('__c', '__r');
                
                List<sObject> sObjListTotal = New List<sObject>();

                for(string childName : childObjectList){
            
                    String query = 'SELECT Id,Name,' + objectNameCon + '.Name from ' + childName + ' where ' +  objectName + ' IN : recordIdList WITH SECURITY_ENFORCED ';
                    
                    List<sObject> sObjList = Database.Query(query);
                   
                    sObjListTotal.addAll(sObjList);

                }          

                for(sObject objS:sObjListTotal){
                    wrapperClassCleanup objWCC = New wrapperClassCleanup(objS.Id, string.valueOf(objS.get('Name')), string.valueOf(objS.getSobject(objectNameCon).get('Name')), objectName, string.valueOf(objS.Id.getsobjecttype()));
                   
                    wrapList.add(objWCC);
                }
              
                return wrapList;
        }

        @AuraEnabled
        public static void callArchivedScheduleClass(String jobName,String cron,Integer month){
            
            try {
                scheduledClassArchvied objArchSchClass=New scheduledClassArchvied(month);
                
                system.schedule(jobName, cron, objArchSchClass);
                
            } catch (Exception e) {
                throw new AuraHandledException(e.getMessage());
            }
        }

        @AuraEnabled
        public static void callUnArchivedScheduleClass(String jobName,String cron,Integer month){
            
            try {
                scheduledClassUnArchvied objArchSchClass=New scheduledClassUnArchvied(month);
                
                system.schedule(jobName, cron, objArchSchClass);
                
            } catch (Exception e) {
                throw new AuraHandledException(e.getMessage());
            }
        }

        @AuraEnabled
        public static List<string> fetchChildObject(string objectName){
            try {
                List<string> childObjectList =  new List<string>();

                for(Object_Mapping__mdt objMap: [select id,DeveloperName,label,ChildObjects__c from Object_Mapping__mdt where label = :objectName]){
                 
                    childObjectList = objMap.ChildObjects__c<>'NA'? objmap.ChildObjects__c.split(','): new List<String>();
                }
    
                return childObjectList ;

            } catch (Exception e) {
                throw new AuraHandledException(e.getMessage());
            }
        }

        @AuraEnabled
        public static List<Copado__User_Story__c> getSelectedUSBranches(List<Id> recordIdList){
            return [select id,name,copado__Release__c,BranchName__c,Is_Deleted__c,Project_Name__c,Environment_Name__c,Release_Name__c,copado__Exclude_From_CBM__c,copado__Stop_Indexing_Metadata__c,copado__Status__c from Copado__User_Story__c where ID IN :recordIdList];
        }

        @AuraEnabled
        public static List<copado__Step__c> getSelectedPromoBranches(List<Id> recordIdList){
            return [Select Id,Name,copado__Status__c,copado__CheckOnly__c,copado__Branch__c,copado__Deployment__c,Is_Deleted__c from copado__Step__c where ID IN :recordIdList];
        }

        @AuraEnabled
        public static List<Copado__User_Story__c> getSelectedArchRecord(List<Id> recordIdList){
            return [SELECT Name,createdDate,LastModifiedDate,copado__Exclude_From_CBM__c,copado__Stop_Indexing_Metadata__c,copado__Status__c from  Copado__User_Story__c WHERE ID IN :recordIdList];
        }

        @AuraEnabled
        public static List<Copado__User_Story__c> getSelectedUnArchRecord(List<Id> recordIdList){
            return [SELECT Name,createdDate,LastModifiedDate,copado__Exclude_From_CBM__c,copado__Stop_Indexing_Metadata__c,copado__Status__c from  Copado__User_Story__c WHERE ID IN :recordIdList];
        }
       
        
    }