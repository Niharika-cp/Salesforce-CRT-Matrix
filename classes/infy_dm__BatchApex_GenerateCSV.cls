/*
This file is generated and isn't the actual source code for this
managed global class.
This read-only file shows the class's global constructors,
methods, variables, and properties.
To enable code to compile, all methods return null.
*/
global class BatchApex_GenerateCSV implements Database.Batchable<SObject>, Database.Stateful {
    global String csvContent;
    global List<Exception> exceptions;
    global String finalstr;
    global String getJobID;
    global String getJobName;
    global Set<String> getnewfailedRecords;
    global String getObjectName;
    global String hostname;
    global String query;
    global BatchApex_GenerateCSV(String jobId, Set<String> newfailedRecords, String ObjectName, String JobName) {

    }
    global void execute(Database.BatchableContext BC, List<SObject> scope) {

    }
    global void finish(Database.BatchableContext BC) {

    }
    global Database.QueryLocator start(Database.BatchableContext BC) {
        return null;
    }
}
