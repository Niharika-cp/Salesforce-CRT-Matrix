trigger Userstorydatacommits on copado__User_Story_Data_Commit__c (after delete)
{

helper.afterdelete(trigger.old);
}