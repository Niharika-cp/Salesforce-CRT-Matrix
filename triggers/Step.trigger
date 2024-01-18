trigger Step on copado__Step__c (after delete)
{

helper.afterdelete(trigger.old);
}