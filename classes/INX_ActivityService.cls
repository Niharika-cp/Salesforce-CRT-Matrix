@RestResource (urlMapping='/infinit/v1/activity/*')
global class INX_ActivityService {

    @HttpGet
    global static void doGet() {

        INX_ServiceMapper.routeRequest();
    }

    @HttpPost
    global static void doPost() {

        INX_ServiceMapper.routeRequest();
    }
}