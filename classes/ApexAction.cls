public class ApexAction {
    //Create parameter
    public static void tetsflow()
    {
Map<String, Object> Params = new Map<String, Object>();
Params.put('recordid','a1d52000002IqvBAAS');

//create instance of Interview
Flow.Interview.Sends_notification_once_deployment_is_completed stage = new Flow.Interview.Sends_notification_once_deployment_is_completed(Params);

//Invoke start method
stage.start();

//get value from Flow
string stageName=(string)stage.getvariableValue('GetUserStoryName');
system.debug(stageName);

    }
}