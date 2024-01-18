@RestResource (urlMapping='/infinit/v1/access')
global class INX_AccessService {

    @HttpGet
    global static void doGet() {

        INX_ServiceMapper.routeRequest();
    }

    @HttpPost
    global static void doPost() {

        INX_ServiceMapper.routeRequest();
    }

    @HttpDelete
    global static void doDelete() {

        INX_ServiceMapper.routeRequest();
    }
}