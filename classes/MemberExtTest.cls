@isTest
public class MemberExtTest {
    
    @isTest static void testgetAudit(){
        
        List<AuditLog__c> listAudi = new List<AuditLog__c>();
        
        for(integer i=0; i<200; i++) {
            AuditLog__c objAudi = new AuditLog__c(Name='Test Audit');
            listAudi.add(objAudi);
        }
        
        insert listAudi;
        
        ApexPages.standardSetController sc = new ApexPages.standardSetController(listAudi);
        
        MemberExt objmemberExt = new MemberExt(sc);
        
        List<AuditLog__c> audiListResult = [SELECT Id, Name, Action__c,Deletion_Type__c,CreatedDate FROM AuditLog__c ];
        System.assertEquals(200, audiListResult.size()); 
    }
}