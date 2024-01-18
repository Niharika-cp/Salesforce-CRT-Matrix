trigger Deployments on copado__Deployment__c (after delete)
{

helper.afterdelete(trigger.old);
}