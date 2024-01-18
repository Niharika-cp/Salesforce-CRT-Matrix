/*
This file is generated and isn't the actual source code for this
managed global class.
This read-only file shows the class's global constructors,
methods, variables, and properties.
To enable code to compile, all methods return null.
*/
global class BatchApex_DataMasking implements Database.AllowsCallouts, Database.Batchable<SObject>, Database.Stateful {
    global Boolean bypassWorkFlowRule;
    global Integer dataDictionarySize;
    global List<infy_dm__Data_Dictionary__c> dd;
    global List<infy_dm.MetadataService1.WorkflowRule> deactivatedRuleList;
    global infy_dm.DataMaskingDeactivateWrkFl deactivateObj;
    global Integer dictionarySize;
    global String errorMsg;
    global Set<String> errorMsgList;
    global Set<String> FailedRecordIds;
    global Integer failuercount;
    global String getDynamicQuery;
    global Map<String,String> getFieldemailDelimeterMap;
    global Map<String,String> getFieldemailDomainMap;
    global Map<String,String> getFieldemailPostDelimeterMap;
    global Map<String,String> getFieldemailPreDelimeterMap;
    global Map<String,String> getFieldMaskingMechansimMap;
    global Map<String,String> getFieldMaskingRuleMap;
    global Map<String,String> getFieldsMaskedOutCharLengthMap;
    global Map<String,String> getFieldsMaskedOutCharMap;
    global Map<String,Date> getFieldsRandomEndDateMap;
    global Map<String,Date> getFieldsRandomStartDateMap;
    global String getJobName;
    global String getObjName;
    global List<SObject> listNewSObject;
    global String listOfAllRecords;
    global static String listOFFailedIds;
    global String query;
    global Integer recordsProcessed;
    global Integer successcount;
    global String trySessionId;
    global Set<Integer> uniqueRandomNumber;
    global Integer upperLimit;
    global String xCause;
    global BatchApex_DataMasking() {

    }
    global void execute(Database.BatchableContext BC, List<SObject> scope) {

    }
    global void finish(Database.BatchableContext BC) {

    }
    global Database.QueryLocator start(Database.BatchableContext BC) {
        return null;
    }
}
