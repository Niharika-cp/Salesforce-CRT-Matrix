/*@isTest
private class TestPracticeUserFreezeApex{
    @isTest
    private static void getResults(){
        Test.startTest();
        PracticeUserFreezeApex.getResults('a','a','a',null);
        PracticeUserFreezeApex.getResults('a','a','a',new List<String>{'a'});
        Test.stopTest();
    }
    @isTest
    private static void TestPracticeUserFreezeApex(){
        PracticeUserFreezeApex obj = new PracticeUserFreezeApex();
    }
    @isTest
    private static void SObjectResult(){
        PracticeUserFreezeApex.SObjectResult obj = new PracticeUserFreezeApex.SObjectResult('a','001x00000000000AAA');
        obj = new PracticeUserFreezeApex.SObjectResult('',(Id)null);
        obj = new PracticeUserFreezeApex.SObjectResult();
    }
}*/
@isTest
private class PracticeUserFreezeApexTest {

    @isTest
    static void testGetResults() {
        // Create test records
        Account testAccount1 = new Account(Name='Test Account 1');
        Account testAccount2 = new Account(Name='Test Account 2');
        insert new List<Account>{testAccount1, testAccount2};

        // Call the getResults method with test data
        List<PracticeUserFreezeApex.SObjectResult> results = PracticeUserFreezeApex.getResults('Account', 'Name', 'Test', new List<String>{testAccount1.Id});

        // Verify the expected results were returned
        System.assertEquals(1, results.size());
        System.assertEquals(testAccount2.Name, results[0].recName);
        System.assertEquals(testAccount2.Id, results[0].recId);
    }
}