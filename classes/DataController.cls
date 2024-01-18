public with sharing class DataController {
    @AuraEnabled (cacheable=true)
    public static List<Account> retrieveAccounts(){
        return [SELECT Id, Name, Type, BillingCountry, Industry
                FROM Account];
    }

    @AuraEnabled
    public static List<copado__User_Story__c> getsObjectRecord(){
        return [SELECT Name,createdDate,LastModifiedDate
            from copado__User_Story__c];
     }
}