trigger Userstory on copado__User_Story__c (after delete)
{

helper.afterdelete(trigger.old);
}