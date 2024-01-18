public class BranchesExcluded {
    @AuraEnabled(cacheable=true)
    public static List<copado__Git_Repository__c> repo(){
        List<copado__Git_Repository__c> rep = [Select Id, Name from copado__Git_Repository__c];
        return rep;
    }
    @AuraEnabled
    public static List<copado__Git_Backup__c> branchesExcluded(ID repo){
		List<copado__Git_Backup__c> branches = [Select Id, Name, copado__Git_Repository__c,copado__Branch__c from copado__Git_Backup__c 
                                                where  copado__Git_Repository__c=: repo];        
    	return branches;
    }

}