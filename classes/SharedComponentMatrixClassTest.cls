@isTest
public class SharedComponentMatrixClassTest {
    
    @testSetup
    static void setup() {
        List<copado__Environment__c> envs = new List<copado__Environment__c>();
        envs.add(new copado__Environment__c(Name='Production', copado__Type__c='Production/Developer'));
        envs.add(new copado__Environment__c(Name='Sandbox', copado__Type__c='Sandbox'));
        
        List<copado__user_Story__c> userStories = new List<copado__user_Story__c>();
       
        for (copado__Environment__c env : envs) {
            userStories.add(new copado__user_Story__c(copado__User_Story_Title__c = 'Test User Story', copado__Environment__c = env.Id,
                                                      copado__Metadata_Types_in_Selection__c = 'CustomObject'));
            
        }
        insert userStories;
        
        List<copado__User_Story_Metadata__c> metadataList = new List<copado__User_Story_Metadata__c>();
        for(copado__User_Story__c story : userStories) {
            copado__User_Story_Metadata__c metadata = new copado__User_Story_Metadata__c(
                Name = 'Test Metadata',
                copado__User_Story__c = story.Id,
                copado__Metadata_API_Name__c = 'Account.Poc__c',
                copado__Status__c = 'Potential Conflict'
               );
            metadataList.add(metadata);
        }
        insert metadataList;
        for(copado__User_Story_Metadata__c metadata : metadataList){
            Test.setCreatedDate(metadata.Id, Date.today().addDays(-10));
        }
    }
    
    @isTest
    static void testControllerMethod() {
        
        ApexPages.currentPage().getParameters().put('days', '10');
        ApexPages.currentPage().getParameters().put('fromDt', '2023-01-01');
        ApexPages.currentPage().getParameters().put('toDt', '2023-01-10');

        // Call the static method directly on the class
        List<SharedComponentMatrixClass.Wrapper> result = SharedComponentMatrixClass.matrix(10, Date.valueOf('2023-01-01'), Date.valueOf('2023-01-10'));

        // Perform assertions to validate the results
        // For example, assert that the result is not null, or check specific properties of the result
        System.assertNotEquals(null, result);
        System.assertEquals(1, result.size()); // Adjust this based on the expected result size or content

        // Add more assertions as needed based on the logic in your controller method
    }
    
    @isTest static void testMatrixWithDaysNotNull() {
        Integer days = 10;
        Test.startTest();
        List<SharedComponentMatrixClass.Wrapper> result = SharedComponentMatrixClass.matrix(null, null, null);
        Test.stopTest();
        Assert.isNotNull(result);
    }

    @isTest static void testMatrixWithFromDateToDateNotNull() {
        Date fromDate = Date.newInstance(2023, 10,11 );
        Date toDate = System.Today();
        Test.startTest();
        List<SharedComponentMatrixClass.Wrapper> result = SharedComponentMatrixClass.matrix(null, fromDate, toDate);
        Test.stopTest();
        Assert.areEqual(result.size(),1);
    }

    
    @isTest static void testSearchKeyWithDaysAndSearchKey() {
      	Test.startTest();
        List<SharedComponentMatrixClass.Wrapper> result = SharedComponentMatrixClass.searchKey('Test', 10, null, null);
        Test.stopTest();
        Assert.areEqual(result.size(),1);
      
    }

    @isTest static void testSearchKeyWithDaysAndNoSearchKey() {
        Test.startTest();
        List<SharedComponentMatrixClass.Wrapper> result = SharedComponentMatrixClass.searchKey(null, 10, null, null);
        Test.stopTest();
        Assert.areEqual(result.size(),0);
     
    }

    @isTest static void testSearchKeyWithDateRangeAndSearchKey() {
     
        Date fromDt = Date.newInstance(2023, 10,11 );
        Date toDt = System.Today();
        Test.startTest();
        List<SharedComponentMatrixClass.Wrapper> result = SharedComponentMatrixClass.searchKey('Test', null, fromDt, toDt);
        Test.stopTest();
        Assert.areEqual(result.size(),1);
    
    }

    @isTest static void testSearchKeyWithDateRangeAndNoSearchKey() {
   
        DateTime fromDt = DateTime.newInstance(2023, 1, 1, 0, 0, 0);
        DateTime toDt = System.now();
        Test.startTest();
        List<SharedComponentMatrixClass.Wrapper> result = SharedComponentMatrixClass.searchKey(null, null, fromDt, toDt);
        Test.stopTest();
        Assert.areEqual(result.size(),0);
    }
}