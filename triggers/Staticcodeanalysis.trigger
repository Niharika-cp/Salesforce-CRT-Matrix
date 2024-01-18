trigger Staticcodeanalysis on copado__Static_Code_Analysis_Result__c (after delete)
{

helper.afterdelete(trigger.old);
}