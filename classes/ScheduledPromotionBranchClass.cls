public with sharing class ScheduledPromotionBranchClass implements schedulable{          //  This class is used to scheduled a promotion branch cleanup
 
    public integer freq;
    public string repositoryId;
    public string serverURL;
    public string copadoAPIKey;
    public string keepThoseBranches; 

    public ScheduledPromotionBranchClass(integer n,string repositoryId , string serverURL, string copadoAPIKey, string keepThoseBranches) {
        freq=n;
       
        this.repositoryId = repositoryId;
        this.serverURL = serverURL;
        this.copadoAPIKey = copadoAPIKey;
        this.keepThoseBranches = keepThoseBranches;
    }

    public void execute(SchedulableContext sc){

        Database.executeBatch(New BatchPromotionBranchSchedule(freq,repositoryId,serverURL,copadoAPIKey,keepThoseBranches),2000);
    }
}