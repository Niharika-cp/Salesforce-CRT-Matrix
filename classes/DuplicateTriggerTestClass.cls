@isTest
private class DuplicateTriggerTestClass {
     public static testmethod void DuplicateTrigger()
    {
        Resource__c res = new Resource__c(Email__c = 'niharikathumma2000@gmail.com',Mobile__c = '9391511111');
        insert res;
        
         Resource__c res2 = new Resource__c (Email__c = 'niharikathumma2001@gmail.com',Mobile__c = '9391511110');
            insert res2;
    }
}