public class CreateAccount {

    public static Account createNewAccount(String accName, String accType) {
        Account newAccount = new Account(Name = accName, Type = accType);
        insert newAccount;
        return newAccount;
    }
}