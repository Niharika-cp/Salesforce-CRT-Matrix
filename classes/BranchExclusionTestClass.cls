@isTest
public class BranchExclusionTestClass {
     @Testsetup 
    public static void myTest() {
        
        copado.GlobalAPI copadoGlobalAPI = new copado.GlobalAPI();
        copado.GlobalAPI.UserLicense UL = new copado.GlobalAPI.UserLicense();
        
        UL.isCADEnabled = false; //Agile delivery license
        UL.isCCHEnabled = false; //Compliance hub license
        UL.isCCMEnabled = true; //Change management (developer) license
        UL.isCopadoEnabled = true; //Enterprise (admin / release manager) license
        //UL.isCSTEnabled = true; //Copado Selenium testing license
        UL.userId = UserInfo.getUserId();
        
        copado.GlobalAPI.LicenseOperationResult result = copadoGlobalAPI.upsertCopadoLicense(UL);
        if(result.isSuccess){
            System.debug('License assigned successfully');
        } else {
            System.debug('An error occurred during license assignment with the error message ' + result.errorString);
        }
                 copado__Git_Backup__c s = new copado__Git_Backup__c(); //Git Snapshot//
                 copado__Git_Repository__c    a = new copado__Git_Repository__c();//Git Repository//
                  copado__Org__c          b =new copado__Org__c(); //credential record//
                  copado__Environment__c  c= new copado__Environment__c();//environment record//
        a.name ='test1';
        a.copado__URI__c= 'snfjhr';
        insert a;
        system.debug(a);
        b.Name='testtt';
        insert b;
        system.debug(b);
        c.Name='tttesttt';
        c.copado__Platform__c=' Salesforce';
        system.debug(c);
                    s.Name='Test';
                    s.copado__Git_Repository__c= a.Id;
                    s.copado__Branch__c = 'dev4';
                    s.copado__Git_Snapshot_Permissions__c= 'Allow Snapshots & Commits';
                    s.copado__Org__c = b.Id;
        insert s;
         system.debug(s);
    }
    @isTest 
    public static void method(){
                
                list< copado__Git_Backup__c> bsc = new list< copado__Git_Backup__c>();
        bsc= [select id,name,copado__Branch__c,copado__Git_Repository__c,Repository_Name__c from copado__Git_Backup__c where name ='Test'];
        system.debug(bsc);
        BranchExclusion.getBranches();

}
}