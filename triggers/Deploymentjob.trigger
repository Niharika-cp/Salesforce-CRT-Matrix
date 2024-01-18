trigger Deploymentjob on copado__Deployment_Job__c (after delete)
{

helper.afterdelete(trigger.old);
}