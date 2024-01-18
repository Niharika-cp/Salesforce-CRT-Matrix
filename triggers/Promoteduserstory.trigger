trigger Promoteduserstory on copado__Promoted_User_Story__c (after delete)
{

helper.afterdelete(trigger.old);
}