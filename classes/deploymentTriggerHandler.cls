public class deploymentTriggerHandler {
   
        public static void afterUpdate(List<copado__Deployment__c> depList){
      
        			deploymentTriggerHelper.afterUpdate(depList);
       
    }

}