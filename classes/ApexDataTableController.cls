public class ApexDataTableController {

    public List<account> accList{get;set;}  
    public List<contact> conList{get;set;}  
      
    //default constructor to get account and contact records  
    public ApexDataTableController(){  
        accList = [select Id, Name, Owner.Name, Rating, Phone, AccountNumber, Website From Account Where Name != null AND Rating != null  
                   AND Phone != null AND AccountNumber != null AND Website != null LIMIT 3];  
        conList = [select Id, FirstName, LastName, Owner.Name, Account.Name, AccountId, Email, Phone From Contact Where FirstName != null AND LastName != null  
                   AND AccountId != null AND Email != null AND Phone != null LIMIT 3];  
    }  
}