trigger Deploymenttask on copado__Deployment_Task__c (after delete)
{

helper.afterdelete(trigger.old);
}