@RestResource (urlMapping='/infinit/v1/checkexisting')
global class INX_CheckExistingService {

    @HttpGet
    global static void doGet() {

        INX_ServiceMapper.routeRequest();
    }
}