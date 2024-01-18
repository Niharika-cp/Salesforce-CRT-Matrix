public class ListViewButtonDemo {
    public List<AuditLog__c> auditLog{get;set;}
    
    public List<AuditLog__c> getauditLog() {
            return [SELECT Name, Action__c, Deletion_Type__c FROM AuditLog__c ];
    }
}