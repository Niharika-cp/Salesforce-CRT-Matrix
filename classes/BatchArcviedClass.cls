public with sharing class BatchArcviedClass implements Database.Batchable<sObject>{
   
    Date today =System.today();
    Date LAST_N_MONTHS ;

    public string query;

    Public BatchArcviedClass(Integer n){
        LAST_N_MONTHS= today.addMonths(-n);
    }

    public Database.QueryLocator start(Database.BatchableContext BC){ 

        String query = 'SELECT Name,copado__Exclude_From_CBM__c,copado__Stop_Indexing_Metadata__c from  copado__User_Story__c WHERE copado__Exclude_From_CBM__c = false AND copado__Stop_Indexing_Metadata__c = false WITH SECURITY_ENFORCED ';
        system.debug('@@query='+query);
        List<sObject> sObjectQueryList= Database.query(query);
        System.debug('%% = '+sObjectQueryList);
        return Database.getQueryLocator(query);
}

public void execute(Database.BatchableContext BC, List<copado__User_Story__c> UsList){

    List<Copado__User_Story__C> copUSList = new List<Copado__User_Story__C>();

    if(!USList.isEmpty()){
        for(Copado__User_Story__C objUS:UsList){
                
                            objUS.copado__Exclude_From_CBM__c = true;
                            objUS.copado__Stop_Indexing_Metadata__c = true;
                            copUSList.add(objUS);
        }            
    }
    Update(copUSList);
}

public void finish(Database.BatchableContext BC){

}

}