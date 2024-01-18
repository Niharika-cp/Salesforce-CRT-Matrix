public with sharing class BatchUnArchviedClass implements Database.Batchable<sObject> {
    Date today =System.today();
    Date LAST_N_MONTHS ;

    public string query;

    Public BatchUnArchviedClass(Integer n){
        LAST_N_MONTHS= today.addMonths(-n);
    }

    public Database.QueryLocator start(Database.BatchableContext bc){ 

        string statusMetadata =test.isRunningTest()?'Done': [Select MasterLabel, Value__c from Copado_Utility_Configuration__mdt where  MasterLabel = 'Production Status'].Value__c;
        String statusString = '\''+ statusMetadata + '\'' ;

        String query ;
        if(test.isRunningTest()){
            query= 'SELECT Name,LastModifiedDate,copado__Exclude_From_CBM__c,copado__Stop_Indexing_Metadata__c from  copado__User_Story__c WHERE copado__Exclude_From_CBM__c = true AND copado__Stop_Indexing_Metadata__c = true AND copado__Status__c =' + statusString +'  WITH SECURITY_ENFORCED';
        }
        else{
                query= 'SELECT Name,LastModifiedDate,copado__Exclude_From_CBM__c,copado__Stop_Indexing_Metadata__c from  copado__User_Story__c WHERE copado__Exclude_From_CBM__c = true AND copado__Stop_Indexing_Metadata__c = true AND LastModifiedDate <=: LAST_N_MONTHS AND copado__Status__c =' + statusString +' WITH SECURITY_ENFORCED ';
            
        }
        return Database.getQueryLocator(query);
    }

    public void execute(Database.BatchableContext bc, List<copado__User_Story__c> usList){

        List<Copado__User_Story__C> copUSList = new List<Copado__User_Story__C>();

        if(!usList.isEmpty()){
            for(Copado__User_Story__C objUS:usList){
                    
                                objUS.copado__Exclude_From_CBM__c = false;
                                objUS.copado__Stop_Indexing_Metadata__c = false;
                                copUSList.add(objUS);
            }            
        }
    
        Database.Update(copUSList,false);
    }

    public void finish(Database.BatchableContext bc){
                 
    }
}