public with sharing class SharedCompoMatrixClass {
    public SharedCompoMatrixClass() {

    }
    @AuraEnabled(cacheable=true)
    public static List<AccountWithContactsWrapper> getAccountsAndContacts() {
        List<AccountWithContactsWrapper> result = new List<AccountWithContactsWrapper>();
        
        // Your logic to query accounts and related contacts
        List<Account> accounts = [SELECT Id, Name, (SELECT Id, Name,MobilePhone,Email FROM Contacts) FROM Account ];
        
        for (Account acc : accounts) {
            AccountWithContactsWrapper wrapper = new AccountWithContactsWrapper();
            wrapper.account = acc;
            wrapper.contacts = acc.Contacts;
            result.add(wrapper);
        }
        
        return result;
    }
    
    public class AccountWithContactsWrapper {
        @AuraEnabled public Account account;
        @AuraEnabled public List<Contact> contacts;
    }
}