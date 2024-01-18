public class ClassC {
public static void createAccounts() {
        List<Account> accounts = new List<Account>();
        for (Integer i = 1; i <= 10; i++) {
            Account acc = new Account();
            acc.Name = 'Test Account ' + i;
            accounts.add(acc);
        }
        insert accounts;
        System.debug('Created ' + accounts.size() + ' accounts');
    }
    public static void deleteAccounts() {
        List<Account> accounts = [SELECT Id FROM Account LIMIT 10]; 
        delete accounts;
        System.debug('Deleted ' + accounts.size() + ' accounts');
    }
}