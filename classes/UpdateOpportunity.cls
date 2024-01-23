public class UpdateOpportunity {
    public static void updateOpportunityStage(String opportunityId, String newStage) {
        Opportunity oppToUpdate = [SELECT Id, StageName FROM Opportunity WHERE Id = :opportunityId LIMIT 1];
        if (oppToUpdate != null) {
            oppToUpdate.StageName = newStage;
            update oppToUpdate;
        }
    }
}