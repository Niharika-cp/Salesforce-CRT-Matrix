@isTest
public class TestDuplicateNameValidator {

    @isTest
    static void testDuplicateNameValidation() {
        // creating test data for creation of User Story
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

        //CREATE PIPELINE
        copado__Deployment_Flow__c objPipeline = new copado__Deployment_Flow__c(Name= 'Test Pipeline Name',copado__Active__c = true,copado__Platform__c ='Salesforce'/*,copado__Deployment_Automation__c =objDep1.Id*/);
        insert objPipeline;
        
        //CREATE PIPELINE CONNECTIONS
        copado__Deployment_Flow_Step__c objPipConn = new copado__Deployment_Flow_Step__c(copado__Deployment_Flow__c = objPipeline.Id,	copado__Source_Environment__c=objEnvi1.Id, 	copado__Destination_Environment__c=objEnvi2.Id,	copado__Branch__c='trndev1');
        insert objPipConn;
        
        //CREATE PROJECT
        
        copado__Project__c objProject= new copado__Project__c(Name='Test Project Name',copado__Deployment_Flow__c=objPipeline.Id);
        insert objProject;
        
         // for Copado User Story Object
        List<copado__User_Story__c> USList = new List<copado__User_Story__c>();
        
        for(Integer i=0 ; i<20; i++){
            copado__User_Story__c objUS  = new copado__User_Story__c(copado__User_Story_Title__c = 'Test User Story'+i,Is_Deleted__c=false,copado__Exclude_From_CBM__c = false, copado__Stop_Indexing_Metadata__c = false,copado__Status__c='Done');
            USList.add(objUS);
        }
        Database.insert(USList,false);
        system.debug(' User Story List'+USList);
        system.debug(' User Story List Size'+USList.size());
        //fetch one user story object record
        copado__User_Story__c objcopUs = [select id,copado__User_Story_Title__c,Is_Deleted__c from copado__User_Story__c where copado__User_Story_Title__c = 'Test User Story1'];
        
        system.debug('copData'+objcopUs);




        
        //create a test user story record;
        List<Copado__user_story__C> existingUS = [SELECT Id, Name FROM Copado__user_story__C LIMIT 1];
        System.debug('existingUS ++++'+existingUS);
        // Create a test record
        copado__Deployment_Task__c testRecord = new copado__Deployment_Task__c(Name = 'TestRecord');
        insert testRecord;

        // Attempt to create a new record with the same name (should fail)
        copado__Deployment_Task__c duplicateRecord = new copado__Deployment_Task__c(Name = 'TestRecord');
        try {
            insert duplicateRecord;
            System.assert(false, 'Inserting a record with a duplicate name should have thrown an exception.');
        } catch (DmlException e) {
            // Expected exception due to the duplicate name
            System.assertEquals(1, e.getNumDml());
            System.assertEquals('A record with this name already exists. Please choose a different name.', e.getDmlMessage(0));
        }

        // Attempt to update the existing record with the same name (should fail)
        testRecord.Name = 'UpdatedTestRecord';
        try {
            update testRecord;
            System.assert(false, 'Updating a record with a duplicate name should have thrown an exception.');
        } catch (DmlException e) {
            // Expected exception due to the duplicate name
            System.assertEquals(1, e.getNumDml());
            System.assertEquals('A record with this name already exists. Please choose a different name.', e.getDmlMessage(0));
        }

        // Update the existing record with a different name (should succeed)
        testRecord.Name = 'UniqueName';
        update testRecord;
    }
}