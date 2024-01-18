public class SharedComponentController {
    
    public Map<String, List<copado__user_Story__c>> compmap {get; set;}
    
    public SharedComponentController(){
        Compmap = new Map<String, List<copado__user_Story__c>>();
        List<copado__Environment__c> productionEnv = [SELECT Id, Name, copado__Type__c FROM copado__Environment__c Where copado__Type__c ='Production/Developer'];
        Map<id,copado__user_Story__c> usListmap = new Map<id,copado__user_Story__c>([SELECT Name, Id, copado__Environment__c,copado__Environment__r.Name,CreatedBy.Name,copado__Metadata_Types_in_Selection__c FROM copado__User_Story__c Where copado__Environment__c NOT IN: productionEnv And copado__Metadata_Types_in_Selection__c != null Order By Name Asc]);
         //usListmap =  [SELECT Name, Id, copado__Environment__c,copado__Environment__r.Name,CreatedBy.Name,copado__Metadata_Types_in_Selection__c FROM copado__User_Story__c Where copado__Environment__c NOT IN: productionEnv And copado__Metadata_Types_in_Selection__c != null Order By Name Asc];
        List<copado__User_Story_Metadata__c> usmList= [SELECT Id, Name, API_Name__c,copado__User_Story__r.Id, Type__c, copado__User_Story__c, copado__Metadata_API_Name__c, copado__Status__c FROM copado__User_Story_Metadata__c Where copado__User_Story__c =:usListmap.values() ];
        //looping through the userstory metadata records
        for(copado__User_Story_Metadata__c usmeta:usmList){
            if(compmap.get(usmeta.API_Name__c)!=null){
                List<copado__user_Story__c> ustlist = compmap.get(usmeta.API_Name__c);
                
            }
            
        }
        
    }

}