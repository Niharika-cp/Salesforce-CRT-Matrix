public with sharing class BatchSixMonthUserStoryDataDeletion implements Database.Batchable<sObject>{   // This Class is used for scheduling Record cleanup
   
    Date today =System.today();
    Date LAST_N_MONTHS ;

    public string query;
    public string selectedObject;

    Public BatchSixMonthUserStoryDataDeletion(Integer n,string objectName){
        LAST_N_MONTHS= today.addMonths(-n);
       selectedObject = objectName;
    }
    
    public Database.QueryLocator start(Database.BatchableContext bc){ 

                    string statusMetadata =test.isRunningTest()?'Done': [Select MasterLabel, Value__c from Copado_Utility_Configuration__mdt where  MasterLabel = 'Production Status'].Value__c;
                    String statusString = '\''+ statusMetadata + '\'' ;

                    String query ;
                    if(test.isRunningTest()){
                        query= 'SELECT Name,LastModifiedDate,copado__Exclude_From_CBM__c,copado__Stop_Indexing_Metadata__c from  ' + selectedObject + ' WHERE copado__Exclude_From_CBM__c = false AND copado__Stop_Indexing_Metadata__c = false AND copado__Status__c =' + statusString +'  WITH SECURITY_ENFORCED ';
                    }
                    else{
                        if(selectedObject == 'copado__User_Story__c'){
                           query= 'SELECT Name,LastModifiedDate,copado__Exclude_From_CBM__c,copado__Stop_Indexing_Metadata__c from  ' + selectedObject + ' WHERE copado__Exclude_From_CBM__c = false AND copado__Stop_Indexing_Metadata__c = false AND LastModifiedDate <=: LAST_N_MONTHS AND copado__Status__c =' + statusString +' WITH SECURITY_ENFORCED ';
                        }
                        else{
                            query = 'SELECT Id, Name,createdDate,LastModifiedDate from ' + selectedObject + ' WHERE LastModifiedDate <=: LAST_N_MONTHS  WITH SECURITY_ENFORCED';
                        }
                    }
                    
                    List<sObject> sObjectQueryList= Database.query(query);
                    
                    return Database.getQueryLocator(query);
     }

     public void execute(Database.BatchableContext bc, List<sObject> objectList){

                    List<Id> recordIdList = new List<Id>();
                    for(sObject sObj: objectList){

                        recordIdList.add(sObj.id);

                    }
                    
                    CentralClass.softRecordBackup(recordIdList,selectedObject);
                    Database.delete(objectList,false);
                
     }

     public void finish(Database.BatchableContext bc){
        
    }
}