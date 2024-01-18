trigger Userstorytask on copado__User_Story_Task__c (after delete)
{

helper.afterdelete(trigger.old);
}