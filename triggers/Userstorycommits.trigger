trigger Userstorycommits on copado__User_Story_Commit__c (after delete)
{

helper.afterdelete(trigger.old);
}