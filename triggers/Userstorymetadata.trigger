trigger Userstorymetadata on copado__User_Story_Metadata__c (after delete)
{

helper.afterdelete(trigger.old);
}