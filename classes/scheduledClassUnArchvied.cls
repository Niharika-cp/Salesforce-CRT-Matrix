public with sharing class scheduledClassUnArchvied implements schedulable {
    public integer freq;
    
    
    Public scheduledClassUnArchvied( integer n){
        freq=n;
    }

    public void execute(SchedulableContext sc){

        Database.executeBatch(New BatchUnArchviedClass(freq));
    }
}