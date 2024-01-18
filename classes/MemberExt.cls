public  with sharing class MemberExt {
    
    public List<AuditLog__c> auditList {get;set;}
    private ApexPages.StandardSetController standardController;
    private Set<Id> auditIds = new Set<Id>();
    
    public MemberExt(ApexPages.StandardSetController standardController){
        
        this.standardController = standardController;
        auditList = new List<AuditLog__c>();
        
        for (AuditLog__c auditObj : (List<AuditLog__c>)standardController.getSelected()){ 
            auditIds.add(auditObj.Id);
            
        }
        
        auditList = [SELECT Id, Name, Action__c,Deletion_Type__c,CreatedDate FROM AuditLog__c WHERE ID IN: auditIds WITH SECURITY_ENFORCED];
        
    }
    
}