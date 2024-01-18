public class ScheduleChart {
    @AuraEnabled(cacheable=true)
    public static string scheduled(){
        String jobId = '';
        try{
        ChartObjectQuery obj = New ChartObjectQuery();
        RemoveScheduledChart ob = New RemoveScheduledChart();    
		String sch = '0 0 6 * * ? *';
        String dis = '0 3 6 * * ? *';
		jobId = System.schedule('Schedule Chart', sch, obj);
        
        System.schedule('Remove Scheduled Job', dis, ob);    
        
        system.debug(jobId);
        return jobId;
        }
        catch(exception e){
            jobId =  'Dont Allow';
            return jobId;
        }
    }
    
    Public Class MyException extends Exception {}
}