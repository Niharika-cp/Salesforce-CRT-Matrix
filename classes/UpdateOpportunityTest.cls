@isTest
private class UpdateOpportunityTest {
 
    @isTest
    static void testUpdateOpportunityStage() {
        // Test data setup
        Opportunity testOpportunity = new Opportunity(
            Name = 'Test Opportunity',
            StageName = 'Prospecting',
            CloseDate = Date.today() + 10
        );
        insert testOpportunity;
 
        // Test method
        Test.startTest();
        UpdateOpportunity.updateOpportunityStage(testOpportunity.Id, 'Qualification');
        Test.stopTest();
 
        // Verify the opportunity update
        Opportunity updatedOpportunity = [SELECT Id, StageName FROM Opportunity WHERE Id = :testOpportunity.Id LIMIT 1];
        System.assertEquals('Qualification', updatedOpportunity.StageName);
    }
}