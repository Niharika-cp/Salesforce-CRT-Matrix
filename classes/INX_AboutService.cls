@RestResource (urlMapping='/infinit/v1/about/*')
global class INX_AboutService {

    @HttpGet
    global static void doGet() {

        INX_ServiceMapper.routeRequest();

    }
}