@isTest
public class CreateAccountTest {
    
    @isTest
    static void testCreateNewAccount() {
        // Test data
        String accName = 'Test Account';
        String accType = 'Prospect';
        
        // Call the method to be tested
        Account createdAccount = CreateAccount.createNewAccount(accName, accType);
        
        // Retrieve the account from database to verify it was created
        Account retrievedAccount = [SELECT Id, Name, Type FROM Account WHERE Id = :createdAccount.Id];
        
        // Verify the account was created with correct values
        System.assertEquals(accName, retrievedAccount.Name, 'Account Name mismatch');
        System.assertEquals(accType, retrievedAccount.Type, 'Account Type mismatch');
    }
}