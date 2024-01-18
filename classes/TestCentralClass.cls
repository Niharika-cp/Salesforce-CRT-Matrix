@isTest
public with sharing class TestCentralClass {
    
     @testSetup
    static void createObjectData(){                                             //creating all object Data
        
        copado.GlobalAPI copadoGlobalAPI = new copado.GlobalAPI();
        copado.GlobalAPI.UserLicense UL = new copado.GlobalAPI.UserLicense();
        
        UL.isCADEnabled = false; //Agile delivery license
        UL.isCCHEnabled = false; //Compliance hub license
        UL.isCCMEnabled = true; //Change management (developer) license
        UL.isCopadoEnabled = true; //Enterprise (admin / release manager) license
        //UL.isCSTEnabled = true; //Copado Selenium testing license
        UL.userId = UserInfo.getUserId();
        
        copado.GlobalAPI.LicenseOperationResult result = copadoGlobalAPI.upsertCopadoLicense(UL);
        if(result.isSuccess){
            System.debug('License assigned successfully');
        } else {
            System.debug('An error occurred during license assignment with the error message ' + result.errorString);
        }
        
        // CREATE ENVIRONMENT
         copado__Environment__c objEnvi1 = new copado__Environment__c(Name='TRNDEV1',copado__Platform__c='Salesforce');
        insert objEnvi1;
        
        copado__Environment__c objEnvi2 = new copado__Environment__c(Name='TRNQA',copado__Platform__c='Salesforce');
        insert objEnvi2;
        
        
        //CREATE CREDENTIAL
        copado__Org__c objCredential1 = new copado__Org__c (Name='TRNDEV1',	copado__Org_Type__c='Sandbox' ,copado__Disable_Validation__c=true,copado__Environment__c = objEnvi1.Id);
        insert objCredential1;
        
        copado__Org__c objCredential2 = new copado__Org__c (Name='TRNQA',	copado__Org_Type__c='Sandbox' ,copado__Disable_Validation__c=true,copado__Environment__c = objEnvi2.Id);
        insert objCredential2;
        
                
        copado__Deployment__c objDep1 = New copado__Deployment__c(Name='depName1',copado__From_Org__c=objCredential1.Id);
        insert objDep1;
      
        
        copado__Deployment__c objDep2 = New copado__Deployment__c(Name='depName2',copado__From_Org__c=objCredential1.Id,copado__Status__c='Draft');
        insert objDep2;
        
        //CREATE PIPELINE
        copado__Deployment_Flow__c objPipeline = new copado__Deployment_Flow__c(Name= 'Test Pipeline Name',copado__Active__c = true,copado__Platform__c ='Salesforce'/*,copado__Deployment_Automation__c =objDep1.Id*/);
        insert objPipeline;
        
        //CREATE PIPELINE CONNECTIONS
        copado__Deployment_Flow_Step__c objPipConn = new copado__Deployment_Flow_Step__c(copado__Deployment_Flow__c = objPipeline.Id,	copado__Source_Environment__c=objEnvi1.Id, 	copado__Destination_Environment__c=objEnvi2.Id,	copado__Branch__c='trndev1');
        insert objPipConn;
        
        //CREATE STEP
        List<copado__Step__c> stepList=new List<copado__Step__c>();
        
        for(Integer i=0 ; i<20; i++){
            copado__Step__c objStep= new copado__Step__c(Name='promotion 1'+i,copado__Deployment__c=objDep1.Id,copado__Order__c=1,copado__Branch__c ='promotion',copado__Status__c='In progress',copado__CheckOnly__c=true,Is_Deleted__c = false);
            stepList.add(objStep);
        }
        Database.insert(stepList,false);
        
        //CREATE PROJECT
        
        copado__Project__c objProject= new copado__Project__c(Name='Test Project Name',copado__Deployment_Flow__c=objPipeline.Id);
        insert objProject;
        
        
         // for Copado User Story Object
        List<copado__User_Story__c> USList = new List<copado__User_Story__c>();
        
        for(Integer i=0 ; i<20; i++){
            copado__User_Story__c objUS  = new copado__User_Story__c(copado__User_Story_Title__c = 'Test User Story'+i,
                                                                     Is_Deleted__c=false,
                                                                     copado__Exclude_From_CBM__c = false, 
                                                                     copado__Stop_Indexing_Metadata__c = false,
                                                                     copado__Status__c='Done');
            USList.add(objUS);
        }
        Database.insert(USList,false);
        
        
         // for Copado User Story Object
        List<copado__User_Story__c> USListUnarch = new List<copado__User_Story__c>();
        
        for(Integer i=0 ; i<20; i++){
            copado__User_Story__c objUSUnarch  = new copado__User_Story__c(copado__User_Story_Title__c = 'Test US'+i,
                                                                     Is_Deleted__c=false,
                                                                     copado__Exclude_From_CBM__c = true, 
                                                                     copado__Stop_Indexing_Metadata__c = true,
                                                                     copado__Status__c='Done');
            USListUnarch.add(objUSUnarch);
        }
        Database.insert(USListUnarch,false);
       
        //fetch one user story object record
        copado__User_Story__c objcopUs = [select id,copado__User_Story_Title__c,Is_Deleted__c from copado__User_Story__c where copado__User_Story_Title__c = 'Test User Story1'];
        
        //fetch one user story object record
        copado__User_Story__c objcopUsArch = [select id,copado__User_Story_Title__c,Is_Deleted__c from copado__User_Story__c where copado__User_Story_Title__c = 'Test US1'];
        
        //for Copado User Story Task Object
        List<copado__User_Story_Task__c> USTaskList = new List<copado__User_Story_Task__c>();
        
        for(Integer i=0 ; i<20; i++){
            copado__User_Story_Task__c objUSTask = new copado__User_Story_Task__c(copado__User_Story__c = objcopUs.id);
            USTaskList.add(objUSTask);
        }
        Database.insert(USTaskList,false);
        
        // for copado Deployment Task object
        List<copado__Deployment_Task__c> deployTaskList = new List<copado__Deployment_Task__c>();
        
        for(Integer i=0 ; i<20; i++){
            copado__Deployment_Task__c objDeployTask = new copado__Deployment_Task__c(Name = 'Test Deployment Task'+i,	copado__Type__c = 'Manual Task',copado__User_Story__c = objcopUs.id);
            deployTaskList.add(objDeployTask);
        }
        Database.insert(deployTaskList,false);
        
        // for user story Metadata Object
        List<copado__User_Story_Metadata__c> metadataList = new List<copado__User_Story_Metadata__c>();
        
        for(Integer i=0 ; i<20; i++){
            copado__User_Story_Metadata__c objUSMetadata = new copado__User_Story_Metadata__c(Name = 'Test Metadata'+i,copado__User_Story__c = objcopUs.id);
            metadataList.add(objUSMetadata);
        }
        Database.insert(metadataList,false);
        
        // for copado__Pull_Request__c object
        List<copado__Pull_Request__c> pullRequestList = new List<copado__Pull_Request__c>();
        
        for(Integer i=0 ; i<20; i++){
            copado__Pull_Request__c objPullRequest = new copado__Pull_Request__c(Name = 'Test Pull Request'+i,copado__User_Story__c = objcopUs.id);
            pullRequestList.add(objPullRequest);
        }
        Database.insert(pullRequestList,false);
        
        // for copado__User_Story_Data_Commit__c object
        
        //for data template object
        copado__Data_Template__c objDataTemplate = new copado__Data_Template__c(Name = 'Test Data Template',copado__Active__c = true);
        Database.insert(objDataTemplate,false);
        
        // for Data Set Object    
        copado__Data_Set__c objDataSet = new copado__Data_Set__c(Name='Test Data Set',copado__Data_Template__c = objDataTemplate.Id);
        Database.insert(objDataSet,false);
        
        List<copado__User_Story_Data_Commit__c> USDataCommitList = new List<copado__User_Story_Data_Commit__c>();
        
        for(Integer i=0 ; i<20; i++){
            copado__User_Story_Data_Commit__c objUSdataCommit = new copado__User_Story_Data_Commit__c(copado__User_Story__c = objcopUs.id,copado__Data_Set__c = objDataSet.Id,	copado__Commit_Message__c ='Just for testing');
            USDataCommitList.add(objUSdataCommit);
        }
        Database.insert(USDataCommitList,false);
        
        
        system.debug(' copado__User_Story_Data_Commit__c object List'+USDataCommitList);
        system.debug(' copado__User_Story_Data_Commit__c object List size '+USDataCommitList.size());
        
        //   for copado__Static_Code_Analysis_Result__c  object
        
        List<copado__Static_Code_Analysis_Result__c> SCAList = new List<copado__Static_Code_Analysis_Result__c>();
        
        for(Integer i=0 ; i<20; i++){
            copado__Static_Code_Analysis_Result__c objSCAresult = new copado__Static_Code_Analysis_Result__c(copado__User_Story__c = objcopUs.id);
            SCAList.add(objSCAresult);
        }
        Database.insert(SCAList,false);
    }
    
    @isTest
    public static void testGetsObjectRecord(){             //Unit Test 
        
        CentralClass.getsObjectRecord(3, 'copado__User_Story__c');
        system.assertEquals(40, CentralClass.getsObjectRecord(3, 'copado__User_Story__c').size());
        
        CentralClass.getsObjectRecord(6, 'copado__User_Story__c');
        system.assertEquals(40, CentralClass.getsObjectRecord(6, 'copado__User_Story__c').size());
        
        CentralClass.getsObjectRecord(12, 'copado__User_Story__c');
        system.assertEquals(40, CentralClass.getsObjectRecord(12, 'copado__User_Story__c').size());
    }
    
    @isTest
    Public static void testsObjectRecordDeleted(){
        
        List<Id>  recordIdList=new List<Id>();  
        
        For(copado__Deployment_Task__c objDepTask:[Select Id from copado__Deployment_Task__c ]){
            recordIdList.add(objDepTask.Id);
        }
        CentralClass.sObjectRecordDeleted(recordIdList, 'copado__Deployment_Task__c');
        
        system.assertEquals('Records get deleted...!!!',CentralClass.sObjectRecordDeleted(recordIdList, 'copado__Deployment_Task__c'));
        
    }
    
    
    @isTest
    Public static void testsObjectRecordHardDeleted(){
        
        List<Id>  recordIdList=new List<Id>();  
        
        For(copado__Deployment_Task__c objDepTask:[Select Id from copado__Deployment_Task__c where Name LIKE '%Test Deployment Task%']){
            recordIdList.add(objDepTask.Id);
        }
        CentralClass.sObjectRecordHardDeleted(recordIdList, 'copado__Deployment_Task__c');
        
        system.assertEquals('Records get deleted...!!!',CentralClass.sObjectRecordDeleted(recordIdList, 'copado__Deployment_Task__c'));
        
    }
    
    
    @isTest
    Public static void testcallScheduleClass(){
        
        String cron='0 11 10 ? * TUE,WED,THU *' ;
        
        List<copado__User_Story__c>  usList=[Select Id,Name from copado__User_Story__c where Name Like 'Test User Story%'];
        
        test.startTest();
        CentralClass.callScheduleClass('Test Schedule', cron, 0 , 'copado__User_Story__c');
        test.stopTest();    
    }
    
    @isTest
    Public static void testGetuserStoryBranchRecord(){
        
        List<copado__User_Story__c>  usList=[Select Id,Name,Is_Deleted__c,BranchName__c,copado__Status__c from copado__User_Story__c ];
        
        CentralClass.getuserStoryBranchRecord(3);
        system.assertEquals(0,  CentralClass.getuserStoryBranchRecord(3).size());
        
        CentralClass.getuserStoryBranchRecord(6);
        system.assertEquals(0,  CentralClass.getuserStoryBranchRecord(6).size());
        
        CentralClass.getuserStoryBranchRecord(12);
        system.assertEquals(0,  CentralClass.getuserStoryBranchRecord(12).size());
    }
    
    @isTest
    Public static void testGetStepObjectRecordList(){
        
       List<copado__Step__c> stepList=[Select Id from copado__Step__c ];
        
        CentralClass.getStepObjectRecordList(3);
        system.assertEquals(20,  CentralClass.getStepObjectRecordList(3).size());
        
        CentralClass.getStepObjectRecordList(6);
        system.assertEquals(20,  CentralClass.getStepObjectRecordList(6).size());
        
        CentralClass.getStepObjectRecordList(12);
        system.assertEquals(20,  CentralClass.getStepObjectRecordList(12).size());
        
    }
    
    
    
    @isTest
    Public static void testPracticeFeatureMethod(){
        
        String serverURL='git.com';
        string copadoAPIKey ='bdf1bc9ec0771f0543e73408c3efd8dd';
        List<string> keepThoseBranches = new List<string>();
        keepThoseBranches.add('testuat');
        keepThoseBranches.add('testprod');
        string repositoryId = 'ASD9909876543GHTYU';
        
        List<Id>  recordIdList=new List<Id>();  
        
        //Fetching the data from copado__User_Story__c and Id's in recordIdList
        For(copado__User_Story__c objUS:[Select Id,Name,Is_Deleted__c from copado__User_Story__c]){
            recordIdList.add(objUS.Id);
        }
        // Calling Apex controller method and sending parameter
        system.assertEquals('Records get deleted...!!!',CentralClass.practiceFeatureMethod(recordIdList, serverURL, repositoryId, copadoAPIKey, keepThoseBranches));
  }
    
    
    @isTest
    Public static void testFeatureBackup(){
        
        List<Id>  recordIdList=new List<Id>();  
        
        For(copado__User_Story__c objUs:[Select Id,Name, copado__View_in_Git__c from copado__User_Story__c ]){
            recordIdList.add(objUs.Id);
        }
        CentralClass.featureBackup(recordIdList);
        
    }
    
    
    @isTest
    Public static void testPracticePromotionRecord(){
        
        String serverURL='git.com';
        string copadoAPIKey ='bdf1bc9ec0771f0543e73408c3efd8dd';
        List<string> keepThoseBranches = new List<string>();
        keepThoseBranches.add('testuat');
        keepThoseBranches.add('testprod');
        string repositoryId = 'ASD9909876543GHTYU';
        
        List<Id>  recordIdList=new List<Id>();  
        
        //Fetching the data from copado__Step__c and Id's in recordIdList
        For(copado__Step__c objStep:[Select Id,Name,Is_Deleted__c from copado__Step__c]){
            recordIdList.add(objStep.Id);
        }
        // Calling Apex controller method and sending parameter
        CentralClass.practicePromotionRecord(recordIdList, serverURL, repositoryId, copadoAPIKey, keepThoseBranches);
        
        system.assertEquals('Records get deleted...!!!',CentralClass.practicePromotionRecord(recordIdList, serverURL, repositoryId, copadoAPIKey, keepThoseBranches));
 }
    
    
    @isTest
    Public static void testPromotionBackup(){
        
        List<Id>  recordIdList=new List<Id>();  
        
        //Fetching the data from copado__Step__c and Id's in recordIdList
        For(copado__Step__c objStep:[Select Id,Name, copado__Branch__c from copado__Step__c ]){
            recordIdList.add(objStep.Id);
        }
        CentralClass.PromotionBackup(recordIdList);
    }
    
    
    @isTest
    Public static void testcallFeatureScheduleClass(){
        
        String cron='0 11 10 ? * TUE,WED,THU *' ;
        String serverURL='git.com';
        string copadoAPIKey ='bdf1bc9ec0771f0543e73408c3efd8dd';
        string keepThoseBranches = 'testuat';
        string repositoryId = 'ASD9909876543GHTYU';
        
        List<copado__User_Story__c>  usList=[Select Id,Name,copado__View_in_Git__c,Is_Deleted__c from copado__User_Story__c];
        
        test.startTest();
        CentralClass.callFeatureScheduleClass('Test Feature Schedule', cron, 0, repositoryId, serverURL, copadoAPIKey, keepThoseBranches);
        test.stopTest();   
    }
    
    
     @isTest
        Public static void testcallPromotionScheduleClass(){
        
        // Initializing the parameter and send this parameter in apex controller method    
        String cron='0 11 10 ? * TUE,WED,THU *' ;
        String serverURL='git.com';
        string copadoAPIKey ='bdf1bc9ec0771f0543e73408c3efd8dd';
        string keepThoseBranches = 'testuat';
        string repositoryId = 'ASD9909876543GHTYU';
        
        List<copado__Step__c>  usList=[Select Id,Name,copado__Status__c,copado__CheckOnly__c,copado__Branch__c,copado__Deployment__c from copado__Step__c];
        
        // Call Apex Controller Method
        test.startTest();
        CentralClass.callPromotionScheduleClass('Test Feature Schedule', cron, 0, repositoryId, serverURL, copadoAPIKey, keepThoseBranches);
        test.stopTest();    
        }
    
    @isTest
    public static void testgetsObjectRecordForArchieved(){
        
        //fetching records from copado__User_Story__c
        List<copado__User_Story__c>  usList=[Select Id,Name,BranchName__c,Is_Deleted__c,copado__Exclude_From_CBM__c,copado__Stop_Indexing_Metadata__c,copado__Status__c from copado__User_Story__c where Name Like 'Test User Story%'];
        
        //Call Apex Controller Method
        CentralClass.getsObjectRecordForArchieved(3);
        system.assertEquals(00,  CentralClass.getsObjectRecordForArchieved(3).size());
        
        CentralClass.getsObjectRecordForArchieved(6);
        system.assertEquals(0,  CentralClass.getsObjectRecordForArchieved(6).size());
        
        CentralClass.getsObjectRecordForArchieved(12);
        system.assertEquals(0,  CentralClass.getsObjectRecordForArchieved(12).size());
    }
    
    @isTest
    public static void testgetsObjectRecordForUnArchieved(){
        
        //fetching records from copado__User_Story__c
        List<copado__User_Story__c>  usList=[Select Id,Name,BranchName__c,Is_Deleted__c,copado__Exclude_From_CBM__c,copado__Stop_Indexing_Metadata__c,copado__Status__c from copado__User_Story__c where Name Like 'Test US%'];
        
        //Call Apex Controller Method
        CentralClass.getsObjectRecordForUnArchieved(3);
        system.assertEquals(0,  CentralClass.getsObjectRecordForUnArchieved(3).size());
        
        CentralClass.getsObjectRecordForUnArchieved(6);
        system.assertEquals(0,  CentralClass.getsObjectRecordForUnArchieved(6).size());
        
        CentralClass.getsObjectRecordForUnArchieved(12);
        system.assertEquals(0,  CentralClass.getsObjectRecordForUnArchieved(12).size());
    }
    
       @isTest
        public static void testarchivedRecord(){
        
        List<Id>  recordIdList=new List<Id>();  
        
        For(copado__User_Story__c objUSList:[Select Id,Name,Is_Deleted__c,copado__Exclude_From_CBM__c,copado__Stop_Indexing_Metadata__c,copado__Status__c from copado__User_Story__c where copado__Exclude_From_CBM__c = false AND copado__Stop_Indexing_Metadata__c =false]){
        
        recordIdList.add(objUSList.Id);
        }
        
        test.startTest();
            CentralClass.archivedRecord(recordIdList);
        test.stopTest();
            
        // Verify that the fields were updated
        List<Copado__User_Story__C> updatedUsList = [SELECT Id, copado__Exclude_From_CBM__c,copado__Stop_Indexing_Metadata__c FROM Copado__User_Story__C WHERE Id IN :recordIdList];
        for(Copado__User_Story__C us : updatedUsList) {
            System.assertEquals(true, us.copado__Exclude_From_CBM__c);
            System.assertEquals(true, us.copado__Stop_Indexing_Metadata__c);
        }
    }
        
@isTest
        public static void testunArchivedRecord(){
        
        List<Id>  recordIdList=new List<Id>();  
        
        For(copado__User_Story__c objUSList:[Select Id,Name,Is_Deleted__c,copado__Exclude_From_CBM__c,copado__Stop_Indexing_Metadata__c,copado__Status__c from copado__User_Story__c where copado__Exclude_From_CBM__c = true AND copado__Stop_Indexing_Metadata__c =true]){
        
            recordIdList.add(objUSList.Id);
        }
        
        test.startTest();
            CentralClass.unArchivedRecord(recordIdList);
        test.stopTest();
            
        // Verify that the fields were updated
        List<Copado__User_Story__C> updatedUsList = [SELECT Id, copado__Exclude_From_CBM__c,copado__Stop_Indexing_Metadata__c FROM Copado__User_Story__C WHERE Id IN :recordIdList];
        for(Copado__User_Story__C us : updatedUsList) {
            System.assertEquals(false, us.copado__Exclude_From_CBM__c);
            System.assertEquals(false, us.copado__Stop_Indexing_Metadata__c);
        }
    }

    @isTest
    static void testCallwrapperClassCleanup() {

        // Verify the data was inserted
        List<Object_Mapping__mdt> insertedMetadata = [SELECT Id, DeveloperName, label, ChildObjects__c FROM Object_Mapping__mdt where label = 'copado__User_Story__c'];
        

        //Adding all the Id in another List
            List<Id> recordIdList = new List<Id>();
        
            for(Object_Mapping__mdt metadata : insertedMetadata){
                    recordIdList.add(metadata.Id);
            }
        
        // Call the Apex method with test data      
            test.startTest();
                  CentralClass.callwrapperClassCleanup('copado__User_Story__c', recordIdList);
            test.stopTest();
              
        // Assert the results
        System.assertEquals(1, recordIdList.size());
        
    }

    @isTest
    Public static void testcallArchivedScheduleClass(){
        
        String cron='0 11 10 ? * TUE,WED,THU *' ;
        
        List<copado__User_Story__c>  usList=[Select Id,Name from copado__User_Story__c];
        
        test.startTest();
        CentralClass.callArchivedScheduleClass('Test Schedule', cron, 0 );
        test.stopTest(); 
    }
    
    @isTest
    Public static void testcallUnArchivedScheduleClass(){
        
        String cron='0 11 10 ? * TUE,WED,THU *' ;
        
        List<copado__User_Story__c>  usList=[Select Id,Name from copado__User_Story__c];
        
        test.startTest();
        CentralClass.callUnArchivedScheduleClass('Test Schedule', cron, 0 );
        test.stopTest(); 
    }
    
    @isTest
    public static void testFetchChildObject() {
        
        // Verify the data was inserted
        List<Object_Mapping__mdt> insertedMetadata = [SELECT DeveloperName, label, ChildObjects__c FROM Object_Mapping__mdt];
        
        test.startTest();
               CentralClass.fetchChildObject('copado__User_Story__c');
        test.stopTest();
        System.assertEquals(13, insertedMetadata.size());
       
    }
    
    @isTest
    Public static void testgetSelectedUSBranches(){
        
        List<Id>  recordIdList=new List<Id>();  
        
        For(copado__Deployment_Task__c objDepTask:[Select Id from copado__Deployment_Task__c ]){
            recordIdList.add(objDepTask.Id);
        }
        CentralClass.getSelectedUSBranches(recordIdList);
        
        system.assertEquals(0,CentralClass.getSelectedUSBranches(recordIdList).size());
        
    }
    
     @isTest
    Public static void testgetSelectedPromoBranches(){
        
        List<Id>  recordIdList=new List<Id>();  
        
        For(copado__Step__c objStep:[Select Id from copado__Step__c ]){
            recordIdList.add(objStep.Id);
        }
        CentralClass.getSelectedPromoBranches(recordIdList);
        
        system.assertEquals(20,CentralClass.getSelectedPromoBranches(recordIdList).size());
        
    }
    
     @isTest
    Public static void testgetSelectedArchRecord(){
        
        List<Id>  recordIdList=new List<Id>();  
        
        For(Copado__User_Story__c objUS:[Select Id from Copado__User_Story__c ]){
            recordIdList.add(objUS.Id);
        }
        CentralClass.getSelectedArchRecord(recordIdList);
        
        system.assertEquals(40,CentralClass.getSelectedArchRecord(recordIdList).size());
        
    }
    
    @isTest
    Public static void testgetSelectedParentrecords(){
        
        List<Id>  recordIdList=new List<Id>();  
        
        For(Copado__User_Story__c objUS:[Select Id from Copado__User_Story__c]){
            recordIdList.add(objUS.Id);
        }
        CentralClass.getSelectedParentrecords('copado__User_Story__c',recordIdList);
        
        system.assertEquals(40,CentralClass.getSelectedParentrecords('copado__User_Story__c',recordIdList).size());
        
    }
    
    @isTest
    Public static void testgetSelectedUnArchRecord(){
        
        List<Id>  recordIdList=new List<Id>();  
        
        For(Copado__User_Story__c objUS:[Select Id from Copado__User_Story__c ]){
            recordIdList.add(objUS.Id);
        }
        CentralClass.getSelectedUnArchRecord(recordIdList);
        
        system.assertEquals(40,CentralClass.getSelectedUnArchRecord(recordIdList).size());
        
    }
 }