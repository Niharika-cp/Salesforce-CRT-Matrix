/* Author - Sai Teja
 **  Description : The SharedComponentScheduleClass in Salesforce Apex is an implementation of the Schedulable interface, designed to be scheduled to run at specified intervals. 
This class is likely utilized in a Salesforce Apex class (SharedComponentEmailGeneration). 
This class acts as a bridge between scheduled jobs and the functionality provided by the SharedComponentEmailGeneration class.
*/


public class SharedComponentScheduleClass implements schedulable {
    public String emailIds;
    public Integer days;
    public Date fromDt;
    public Date toDt;
    
    public SharedComponentScheduleClass(string emailIds,Integer days, Date fromDt, Date toDt){
        this.emailIds = emailIds;
        this.days = days;
        this.fromDt = fromDt;
        this.toDt=toDt;
    }
    public void execute(schedulableContext sc){
        System.debug(this.emailIds);
        SharedComponentEmailGeneration.sendEmail(this.emailIds,this.days,this.fromDt,this.toDt);
    }
}