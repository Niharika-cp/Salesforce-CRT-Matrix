global class snow_updatedescription{

    Public static void updatedescription(id crid){
        Change_Request__c cr = [SELECT Id,Name,Impact__c,Category__c,Description__c,justification__c,Risk__c,
                                    Priority__c,Risk_Impact_Analysis__c,Short_Description__c,Type__c,Implementation_Plan__c,Release_LookUp__c,
                                    Backout_Plan__c,Test_Plan__c,Planned_End_Date__c,Planned_Start_Date__c,Actual_Start_Date__c,Actual_End_Date__c,System_ID__c
                                    FROM Change_Request__c  Where id =:crid];

        String combinedDescription;
        String lineBreak = '\\r\\n';
            if (cr != null) {
                    Id rel_id = cr.Release_LookUp__c;
                    List<String> userStoryDescriptions = new List<String>();
                                        
                        List<copado__User_Story__c> cusList = [SELECT Id, Name,Jira_Key__c, copado__User_Story_Title__c, copado__Release__c
                                        FROM copado__User_Story__c WHERE copado__Release__c = :rel_id];
                                        
                        for (copado__User_Story__c cus : cusList) {
                            String userStoryDescription = cus.Jira_Key__c + ' - ' + cus.copado__User_Story_Title__c;
                            system.debug('userStoryDescription ====='+userStoryDescription);
                            userStoryDescriptions.add(userStoryDescription);
                            }
                            cr.description__C=null;
                        for(String ud : userStoryDescriptions){
                            cr.Description__c = cr.Description__c!=null? cr.Description__c+'<br>'+ud:ud;
                            system.debug('cr.description__C===='+cr.description__C);
                        }    

                                        
                            // Combine userStoryDescriptions into a single description
                           //combinedDescription = 
                            System.debug('userStoryDescriptions ========='+userStoryDescriptions);
                            // Update the Description__c field of the Change Request
                            //cr.Description__c = combinedDescription;
                            update cr;
                } 
    }
}