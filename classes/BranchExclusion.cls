public with sharing class BranchExclusion {
    @AuraEnabled(cacheable=true)
    public static List<copado__Git_Backup__c> getBranches(){
        Map<String,copado__Git_Backup__c> branchmap = new Map<String,copado__Git_Backup__c>();
        List<copado__Git_Backup__c> blist = new List<copado__Git_Backup__c>();
        try{
            blist = [select id,name,copado__Branch__c,copado__Git_Repository__r.name,Repository_Name__c from copado__Git_Backup__c];
            for(copado__Git_Backup__c cgb : blist){
                branchmap.put(cgb.Repository_Name__c+cgb.copado__Branch__c,cgb);
            }
            return branchmap.values();
         }
         catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }

    }    
}