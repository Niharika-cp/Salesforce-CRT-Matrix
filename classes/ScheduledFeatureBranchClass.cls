public with sharing class ScheduledFeatureBranchClass implements schedulable{    //  This class is used to scheduled a feature branch cleanup

    public  integer freq;
    public  string repositoryId;
    public  string serverURL;
    public  string copadoAPIKey;
    public  string keepThoseBranches;

    

    public ScheduledFeatureBranchClass( integer n,string repositoryId , string serverURL, string copadoAPIKey, string keepThoseBranches) {

        this.freq=n;
       
        this.repositoryId = repositoryId;
        this.serverURL = serverURL;
        this.copadoAPIKey = copadoAPIKey;
        this.keepThoseBranches = keepThoseBranches;
       
    }

    public void execute(SchedulableContext sc){
        

        Database.executeBatch(New BatchFeatureBranchSchedule(freq,repositoryId,serverURL,copadoAPIKey,keepThoseBranches),2000);


    }
}