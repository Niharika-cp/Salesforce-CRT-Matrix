@isTest
public class UpdateAccountTest {
    
    @isTest
    static void testUpdateExistingAccount() {
        // Test data
        Account testAccount = new Account(Name = 'Test Account', Type = 'Prospect');
        insert testAccount;
        String newType = 'Customer';
        
        // Call the method to be tested
        UpdateAccount.updateExistingAccount(testAccount, newType);
        
        // Retrieve the account from database to verify it was updated
        Account updatedAccount = [SELECT Id, Name, Type FROM Account WHERE Id = :testAccount.Id];
        
        // Verify the account was updated with correct values
        System.assertEquals(newType, updatedAccount.Type, 'Account Type not updated');
    }
}