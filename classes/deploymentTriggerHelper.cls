public class deploymentTriggerHelper {
    
    public static void afterUpdate(List<copado__Deployment__c> depList){
        
        system.debug('Deployment Trigger');
        //Create Promotion Id set
        Set<Id> promIdSet = new Set<Id>();
        
        for(copado__Deployment__c objDep : depList){
            system.debug('Deployment is ='+objDep);
            if(objDep.copado__Status__c == 'Completed Successfully'){
                promIdSet.add(objDep.copado__Promotion__c); 
            }
        } 
        
        system.debug('promIdSet is ='+promIdSet);
        
        //Create User Story Id set
        Set<Id> USIdSet = new Set<Id>();
        
        if(!promIdSet.isEmpty()){
            for(copado__Promoted_User_Story__c objPromUs : [select Id,	copado__User_Story__c,copado__Promotion__c from copado__Promoted_User_Story__c where copado__Promotion__c IN : promIdSet]){
                USIdSet.add(objPromUs.copado__User_Story__c);
            }
        }
        
        system.debug('USIdSet is ='+USIdSet);
        
        //Group all Promotions related to User Story
        Set<Id> allPromIdSet = new Set<Id>();
        if(!USIdSet.isEmpty()){
            for(copado__Promoted_User_Story__c objPromUs : [select Id,	copado__Promotion__c,copado__User_Story__c from copado__Promoted_User_Story__c where copado__User_Story__c IN : USIdSet]){
                allPromIdSet.add(objPromUs.copado__Promotion__c);
            }
        }
        system.debug('allPromIdSet  = '+allPromIdSet);
        system.debug('allPromIdSet size = '+allPromIdSet.size());
        
        
        map<String, integer> promMap = new map<String, integer>();
        integer count;
        
        if(!allPromIdSet.isEmpty()){
            
            for(copado__Deployment__c objDep : [SELECT Id, Name, copado__Status__c, copado__Promotion__c,copado__Promotion__r.copado__Source_Environment__r.name,copado__Promotion__r.copado__Destination_Environment__r.name FROM copado__Deployment__c where copado__Status__c='Completed Successfully'	and copado__Promotion__c IN : allPromIdSet]){
                
                String credential = objDep.copado__Promotion__r.copado__Source_Environment__r.name +' - '+ objDep.copado__Promotion__r.copado__Destination_Environment__r.name;
                system.debug('credential = '+credential);
                if(promMap.containsKey(credential)){
                    count = promMap.get(credential)+1;
                    promMap.put(credential, count);
                }
                else{
                    promMap.put(credential, 0);
                }
            }
        }
        
        system.debug('promMap is ='+promMap);
        
        Integer finalcount=0;
        for(Integer i : promMap.values()){
            finalcount+=i;
        }
        
        system.debug('finalcount is ='+finalcount);
        
        
        List<copado__User_Story__c> usList = New List<copado__User_Story__c>();
        
        if(!USIdSet.isEmpty()){
            for(copado__User_Story__c objUS : [select Id,No_of_Bug_Fixes__c from copado__User_Story__c where Id IN : USIdSet]){
                objUS.No_of_Bug_Fixes__c = finalcount;
                usList.add(objUS);
            }
        }
        
        system.debug('usList is ='+usList);
        Database.update(usList,false);
    }
    
}