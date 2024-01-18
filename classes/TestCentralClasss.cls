@isTest(seealldata=true)
public with sharing class TestCentralClasss {
     

        
       @isTest
       public static void testGetsObjectRecord(){             //Unit Test 
               
           CentralClass.getsObjectRecord(3, 'copado__User_Story__c');
           //system.assertEquals(200, CentralClass.getsObjectRecord(3, 'copado__User_Story__c').size());

           CentralClass.getsObjectRecord(6, 'copado__User_Story__c');
           //system.assertEquals(200, CentralClass.getsObjectRecord(6, 'copado__User_Story__c').size());

           CentralClass.getsObjectRecord(12, 'copado__User_Story__c');
           //system.assertEquals(200, CentralClass.getsObjectRecord(12, 'copado__User_Story__c').size());
       
           
      }

       @isTest
       Public static void testsObjectRecordDeleted(){
            
            List<Id>  recordIdList=new List<Id>();  

            For(copado__Deployment_Task__c objDepTask:[Select Id from copado__Deployment_Task__c] ){
                recordIdList.add(objDepTask.Id);
            }
            CentralClass.sObjectRecordDeleted(recordIdList, 'copado__Deployment_Task__c');

            system.assertEquals('Records get deleted...!!!',CentralClass.sObjectRecordDeleted(recordIdList, 'copado__Deployment_Task__c'));

       }


       @isTest
       Public static void testsObjectRecordHardDeleted(){
            
            List<Id>  recordIdList=new List<Id>();  

            For(copado__Deployment_Task__c objDepTask:[Select Id from copado__Deployment_Task__c ]){
                recordIdList.add(objDepTask.Id);
            }
            CentralClass.sObjectRecordHardDeleted(recordIdList, 'copado__Deployment_Task__c');

            system.assertEquals('Records get deleted...!!!',CentralClass.sObjectRecordDeleted(recordIdList, 'copado__Deployment_Task__c'));

       }


       @isTest
       Public static void testcallScheduleClass(){

                String cron='0 11 10 ? * TUE,WED,THU *' ;

                List<copado__User_Story__c>  usList=[Select Id,Name from copado__User_Story__c ];

                test.startTest();
                    CentralClass.callScheduleClass('Test Schedule', cron, 0 , 'copado__User_Story__c');
                test.stopTest();    


       }

       @isTest
       Public static void testGetuserStoryBranchRecord(){

                List<copado__User_Story__c>  usList=[Select Id,Name,Is_Deleted__c from copado__User_Story__c where Is_Deleted__c= false];
            
                CentralClass.getuserStoryBranchRecord(3);
               // system.assertEquals(200,  CentralClass.getuserStoryBranchRecord(3).size());

                CentralClass.getuserStoryBranchRecord(6);
             //   system.assertEquals(200,  CentralClass.getuserStoryBranchRecord(6).size());

                CentralClass.getuserStoryBranchRecord(12);
              //  system.assertEquals(200,  CentralClass.getuserStoryBranchRecord(12).size());
       }

       @isTest
        Public static void testGetStepObjectRecordList(){

                List<copado__Step__c>  usList=[Select Id,Name,Is_Deleted__c from copado__Step__c where Is_Deleted__c =false];
            
                CentralClass.getStepObjectRecordList(3);
               // system.assertEquals(0,  CentralClass.getStepObjectRecordList(3).size());

                CentralClass.getStepObjectRecordList(6);
               // system.assertEquals(00,  CentralClass.getStepObjectRecordList(6).size());


                CentralClass.getStepObjectRecordList(12);
             //   system.assertEquals(00,  CentralClass.getStepObjectRecordList(12).size());

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
            For(copado__User_Story__c objUS:[Select Id,Name,Is_Deleted__c from copado__User_Story__c where Is_Deleted__c=FALSE limit 5]){
                recordIdList.add(objUS.Id);
            }
        
            system.debug('RecordId User Story list'+recordIdList);
                 
                          
                         Test.setMock(HttpCalloutMock.class, new MockClassFeaturePromotion());
                          string res = CentralClass.practiceFeatureMethod(recordIdList, serverURL, repositoryId, copadoAPIKey, keepThoseBranches);
                   system.debug(res+'========response');
                    system.assertEquals('Records get deleted...!!!',CentralClass.practiceFeatureMethod(recordIdList, serverURL, repositoryId, copadoAPIKey, keepThoseBranches));
               

        }


        @isTest
        Public static void testFeatureBackup(){

                List<Id>  recordIdList=new List<Id>();  

                For(copado__User_Story__c objUs:[Select Id,Name, copado__View_in_Git__c,Is_Deleted__c from copado__User_Story__c ]){
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
            For(copado__Step__c objStep:[Select Id,Name,Is_Deleted__c,copado__Branch__c from copado__Step__c where Is_Deleted__c=FALSE LIMIT 5 ]){
                recordIdList.add(objStep.Id);
            }
           
            system.debug('RecordId Step list'+recordIdList);

            Test.setMock(HttpCalloutMock.class, new MockClassFeaturePromotion());
            string res = CentralClass.practicePromotionRecord(recordIdList, serverURL, repositoryId, copadoAPIKey, keepThoseBranches);

          //  CentralClass.practicePromotionRecord(recordIdList, serverURL, repositoryId, copadoAPIKey, keepThoseBranches);

            system.assertEquals('Records get deleted...!!!',CentralClass.practicePromotionRecord(recordIdList, serverURL, repositoryId, copadoAPIKey, keepThoseBranches));
      
    }


       @isTest
        Public static void testPromotionBackup(){

                List<Id>  recordIdList=new List<Id>();  

                For(copado__Step__c objStep:[Select Id,Name, copado__Branch__c,Is_Deleted__c from copado__Step__c ]){
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

                List<copado__User_Story__c>  usList=[Select Id,Name,copado__View_in_Git__c,Is_Deleted__c from copado__User_Story__c  where Is_Deleted__c=FALSE limit 5];

                test.startTest();
                    CentralClass.callFeatureScheduleClass('Test Feature Schedule', cron, 0, repositoryId, serverURL, copadoAPIKey, keepThoseBranches);
                test.stopTest();    


       }

       
       @isTest
       Public static void testcallPromotionScheduleClass(){

                String cron='0 11 10 ? * TUE,WED,THU *' ;
                String serverURL='git.com';
                string copadoAPIKey ='bdf1bc9ec0771f0543e73408c3efd8dd';
                string keepThoseBranches = 'testuat';
                
                string repositoryId = 'ASD9909876543GHTYU';

                List<copado__Step__c>  usList=[Select Id,Name,copado__Branch__c,Is_Deleted__c from copado__Step__c WHERE Is_Deleted__c = False Limit 5];

                test.startTest();
                    CentralClass.callPromotionScheduleClass('Test promotion Schedule', cron, 0, repositoryId, serverURL, copadoAPIKey, keepThoseBranches);
                test.stopTest();    
       }

       @isTest
       public static void testgetsObjectRecordForArchieved(){
                List<copado__User_Story__c>  usList=[Select Id,Name,Is_Deleted__c,copado__Exclude_From_CBM__c,copado__Stop_Indexing_Metadata__c,copado__Status__c from copado__User_Story__c where copado__Stop_Indexing_Metadata__c = false AND copado__Exclude_From_CBM__c = false];
                    
                CentralClass.getsObjectRecordForArchieved(3);
              //  system.assertEquals(200,  CentralClass.getsObjectRecordForArchieved(3).size());

                CentralClass.getsObjectRecordForArchieved(6);
              //  system.assertEquals(200,  CentralClass.getsObjectRecordForArchieved(6).size());

                CentralClass.getsObjectRecordForArchieved(12);
               // system.assertEquals(200,  CentralClass.getsObjectRecordForArchieved(12).size());
       }

     @isTest
       public static void testarchivedRecord(){
              
            List<Id>  recordIdList=new List<Id>();  
            For(copado__User_Story__c objUS:[Select Id,Name,Is_Deleted__c,copado__Exclude_From_CBM__c,copado__Stop_Indexing_Metadata__c,copado__Status__c from copado__User_Story__c where copado__Stop_Indexing_Metadata__c = false AND copado__Exclude_From_CBM__c = false LIMIT 5]){
                recordIdList.add(objUS.Id);
            }
            system.debug('Record Id List ====='+recordIdList);
           // List<copado__User_Story__c> UsList = [Select Id,Name,Is_Deleted__c,copado__Exclude_From_CBM__c,copado__Stop_Indexing_Metadata__c,copado__Status__c from copado__User_Story__c where copado__Stop_Indexing_Metadata__c = false AND copado__Exclude_From_CBM__c = false];
            CentralClass.archivedRecord(recordIdList);

            boolean result1 = [Select Id,Name,Is_Deleted__c,copado__Exclude_From_CBM__c,copado__Stop_Indexing_Metadata__c,copado__Status__c from copado__User_Story__c LIMIT 1].copado__Exclude_From_CBM__c;
            boolean result2 = [Select Id,Name,Is_Deleted__c,copado__Exclude_From_CBM__c,copado__Stop_Indexing_Metadata__c,copado__Status__c from copado__User_Story__c LIMIT 1].copado__Stop_Indexing_Metadata__c;

              system.assertEquals(true,  result1);
              system.assertEquals(true, result2);
       }

       @isTest
       Public static void testcallArchivedScheduleClass(){

                String cron='0 11 10 ? * TUE,WED,THU *' ;

                List<copado__User_Story__c>  usList=[Select Id,Name,LastModifiedDate,copado__Exclude_From_CBM__c,copado__Stop_Indexing_Metadata__c,copado__Status__c from copado__User_Story__c where copado__Stop_Indexing_Metadata__c = false AND copado__Exclude_From_CBM__c = false LIMIT 5];

                test.startTest();
                    CentralClass.callArchivedScheduleClass('test 1',cron,0);
                test.stopTest();    

                boolean result1 = [Select Id,Name,Is_Deleted__c,copado__Exclude_From_CBM__c,copado__Stop_Indexing_Metadata__c,copado__Status__c from copado__User_Story__c LIMIT 1].copado__Exclude_From_CBM__c;
                boolean result2 = [Select Id,Name,Is_Deleted__c,copado__Exclude_From_CBM__c,copado__Stop_Indexing_Metadata__c,copado__Status__c from copado__User_Story__c LIMIT 1].copado__Stop_Indexing_Metadata__c;
    
                  //system.assertEquals(true,  result1);
                  //system.assertEquals(true, result2);
       }


       @isTest
       public static void testfetchChildObject(){             //Unit Test 

        List<copado__User_Story__c> objUs = [select Id from copado__User_Story__c];

        List<Object_Mapping__mdt>  objMap=[select id,DeveloperName,label,ChildObjects__c from Object_Mapping__mdt where label = :'copado__User_Story__c'];
               
           CentralClass.fetchChildObject('copado__User_Story__c');
         
       }

       @isTest
       public static void testcallwrapperClassCleanup(){             //Unit Test 

        string objectName ='copado__User_Story__c';

        List<Object_Mapping__mdt>  objMap=[select id,DeveloperName,label,ChildObjects__c from Object_Mapping__mdt where label = :objectName];

         
        List<Id>  recordIdList=new List<Id>();  

        For(copado__User_Story__c objS:[Select Id from copado__User_Story__c] ){
            recordIdList.add(objS.Id);
        }
               
           CentralClass.callwrapperClassCleanup('copado__User_Story__c',recordIdList);
         
       }
}