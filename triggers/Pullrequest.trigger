trigger Pullrequest on copado__Pull_Request__c (after delete)
{

helper.afterdelete(trigger.old);
}