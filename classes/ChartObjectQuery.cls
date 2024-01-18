global class ChartObjectQuery implements Schedulable{
    global static void execute(SchedulableContext sc){
        Integer users = [select count() from User];
        
        List<ChartObject__c> records = [SELECT Name from ChartObject__c ORDER BY Name ASC];
        for(ChartObject__c rec : records ){
            if(rec.Name == 'Copado Functions'){
                List<copado__Function__c> useList = [select LastModifiedById from copado__Function__c ];
                Set<Id> use = New Set<Id>();
                for(copado__Function__c us : useList){
                    use.add(us.LastModifiedById);
                }
                system.debug(use.size());
                rec.X__c = ((Double) use.size()/users)*100;
                rec.Y__c = [select count() from copado__Function__c ];
                system.debug(rec.X__c);
                system.debug(rec.Y__c);
            }
            if(rec.Name == 'Data Templates'){
                List<copado__Data_Template__c> useList = [select LastModifiedById from copado__Data_Template__c ];
                Set<Id> use = New Set<Id>();
                for(copado__Data_Template__c us : useList){
                    use.add(us.LastModifiedById);
                }
                rec.X__c = ((Double) use.size()/users)*100;
                rec.Y__c = [select count() from copado__Data_Template__c ];
                system.debug(rec.X__c);
                system.debug(rec.Y__c);
            }
            if(rec.Name == 'Deployments'){
                List<copado__Deployment__c> useList = [select LastModifiedById from copado__Deployment__c where copado__Status__c = 'Completed Successfully' ];
                Set<Id> use = New Set<Id>();
                for(copado__Deployment__c us : useList){
                    use.add(us.LastModifiedById);
                }
                rec.X__c = ((Double) use.size()/users)*100;
                rec.Y__c = [select count() from copado__Deployment__c where copado__Status__c = 'Completed Successfully' ];
                system.debug(rec.X__c);
                system.debug(rec.Y__c);
            }
            if(rec.Name == 'Exclude Completed Stories'){
                List<copado__User_Story__c> useList = [select LastModifiedById from copado__User_Story__c  where copado__Exclude_From_CBM__c = TRUE AND copado__Stop_Indexing_Metadata__c = true ];
                Set<Id> use = New Set<Id>();
                for(copado__User_Story__c us : useList){
                    use.add(us.LastModifiedById);
                }
                rec.X__c = ((Double) use.size()/users)*100;
                rec.Y__c = [select count() from copado__User_Story__c  where copado__Exclude_From_CBM__c = TRUE AND copado__Stop_Indexing_Metadata__c = true];
            	system.debug(rec.X__c);
                system.debug(rec.Y__c);
            }
            if(rec.Name == 'Org Differences'){
                List<copado__OrgDiff__c> useList = [select LastModifiedById from copado__OrgDiff__c ];
                Set<Id> use = New Set<Id>();
                for(copado__OrgDiff__c us : useList){
                    use.add(us.LastModifiedById);
                }
                rec.X__c = ((Double) use.size()/users)*100;
                rec.Y__c = [select count() from copado__OrgDiff__c];
                system.debug(rec.X__c);
                system.debug(rec.Y__c);
            }
            if(rec.Name == 'Promotions'){
                List<copado__Promotion__c> useList = [select LastModifiedById from copado__Promotion__c where copado__Status__c = 'Completed' ];
                Set<Id> use = New Set<Id>();
                for(copado__Promotion__c us : useList){
                    use.add(us.LastModifiedById);
                }
                rec.X__c = ((Double) use.size()/users)*100;
                rec.Y__c = [select count() from copado__Promotion__c where copado__Status__c = 'Completed'];
                system.debug(rec.X__c);
                system.debug(rec.Y__c);
            }
            if(rec.Name == 'Rollback Feature'){
                List<copado__Promotion__c> useList = [select LastModifiedById from copado__Promotion__c where copado__Is_Rolled_Back__c = true];
                Set<Id> use = New Set<Id>();
                for(copado__Promotion__c us : useList){
                    use.add(us.LastModifiedById);
                }
                rec.X__c = ((Double) use.size()/users)*100;
                rec.Y__c = [select count() from copado__Promotion__c where copado__Is_Rolled_Back__c = true];
                system.debug(rec.X__c);
                system.debug(rec.Y__c);
            }
            if(rec.Name == 'Snapshot Differences'){
                List<copado__Snapshot_Difference__c> useList = [select LastModifiedById from copado__Snapshot_Difference__c ];
                Set<Id> use = New Set<Id>();
                for(copado__Snapshot_Difference__c us : useList){
                    use.add(us.LastModifiedById);
                }
                rec.X__c = ((Double) use.size()/users)*100;
                rec.Y__c = [select count() from copado__Snapshot_Difference__c];
                system.debug(rec.X__c);
                system.debug(rec.Y__c);
            }
            if(rec.Name == 'Static Code Analysis'){
                List<copado__Static_Code_Analysis_Result__c> useList = [select LastModifiedById from copado__Static_Code_Analysis_Result__c ];
                Set<Id> use = New Set<Id>();
                for(copado__Static_Code_Analysis_Result__c us : useList){
                    use.add(us.LastModifiedById);
                }
                rec.X__c = ((Double) use.size()/users)*100;
                rec.Y__c = [select count() from copado__Static_Code_Analysis_Result__c];
                system.debug(rec.X__c);
                system.debug(rec.Y__c);
            }
            if(rec.Name == 'User Stories'){
                List<copado__User_Story__c> useList = [select LastModifiedById from copado__User_Story__c ];
                Set<Id> use = New Set<Id>();
                for(copado__User_Story__c us : useList){
                    use.add(us.LastModifiedById);
                }
                system.debug(use.size());
                rec.X__c = ((Double) use.size()/users)*100;
                rec.Y__c = [select count() from copado__User_Story__c];
                system.debug(rec.X__c);
                system.debug(rec.Y__c);
            }
            if(rec.Name == 'User Story Bundles'){
                List<copado__User_Story__c> useList = [select LastModifiedById from copado__User_Story__c where copado__Is_Bundle__c=true];
                Set<Id> use = New Set<Id>();
                for(copado__User_Story__c us : useList){
                    use.add(us.LastModifiedById);
                }
                rec.X__c = ((Double) use.size()/users)*100;
                rec.Y__c = [select count() from copado__User_Story__c where copado__Is_Bundle__c=true];
                system.debug(rec.X__c);
                system.debug(rec.Y__c);
            }
            if(rec.Name == 'User Story Dependencies'){
                List<copado__Team_Dependency__c> useList = [select LastModifiedById from copado__Team_Dependency__c ];
                Set<Id> use = New Set<Id>();
                for(copado__Team_Dependency__c us : useList){
                    use.add(us.LastModifiedById);
                }
                rec.X__c = ((Double) use.size()/users)*100;
                rec.Y__c = [select count() from copado__Team_Dependency__c];
                system.debug(rec.X__c);
                system.debug(rec.Y__c);
            }
        }
        update records;
    }
    @AuraEnabled(cacheable=true)
    public static string warnScheduled(){
        String empString = 'empty';
        List<CronTrigger> crtrigger = [SELECT CronJobDetail.Name FROM CronTrigger Where CronJobDetail.Name = 'Schedule Chart'];
        if(crtrigger.size()!= 0){
            for(CronTrigger cr : crtrigger){
                if(cr.CronJobDetail.Name == 'Schedule Chart'){
                    empString = cr.CronJobDetail.Name;
                }
            }
            return empString;
        }
        else return empString;
    }
    
}