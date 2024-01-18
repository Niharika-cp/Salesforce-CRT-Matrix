public with sharing class ReleaseMilestoneController {
    @AuraEnabled(cacheable=true)
    public static List<Release_Milestone__c> getMilestones() {
            return [SELECT Id, Start_Date__c, End_Date__c,
                    Release__r.Name, Environment__r.Name
                    FROM Release_Milestone__c
                    ORDER BY Release__r.Name, Environment__r.Name];
    }
}