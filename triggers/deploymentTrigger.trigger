trigger deploymentTrigger on copado__Deployment__c (after update) {
    
      if(trigger.isUpdate && trigger.isAfter){
        deploymentTriggerHandler.afterUpdate(trigger.new);
    }
}