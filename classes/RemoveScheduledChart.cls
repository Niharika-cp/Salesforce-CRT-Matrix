global class RemoveScheduledChart implements schedulable {
    public void execute(schedulableContext sc){
        CronTrigger crtrigger = [SELECT CronJobDetail.Id , CronJobDetail.Name FROM CronTrigger Where CronJobDetail.Name = 'Schedule Chart' LIMIT 1];
        
        //then use the active job id and abort it
        if(crtrigger!=null){
            system.abortJob(crtrigger.Id);
        }
    }
    
    
    
}