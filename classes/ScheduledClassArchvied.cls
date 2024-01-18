public with sharing class ScheduledClassArchvied implements schedulable{         //This class is used for scheduling archival record
 
    public integer freq;
    
    
    Public ScheduledClassArchvied( integer n){
        freq=n;
    }

    public void execute(SchedulableContext sc){

        Database.executeBatch(New BatchArchviedClass(freq));
    }
}