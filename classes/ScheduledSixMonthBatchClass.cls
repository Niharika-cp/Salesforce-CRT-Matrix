public with sharing class ScheduledSixMonthBatchClass implements schedulable{            //  This class is used to scheduled a record cleanup
 
    public integer freq;
    public string objects;
    
    Public ScheduledSixMonthBatchClass( integer n,string objectName){
        freq=n;
       
        objects=objectName;
    }

    public void execute(SchedulableContext sc){

        Database.executeBatch(New BatchSixMonthUserStoryDataDeletion(freq,objects));
    }
}