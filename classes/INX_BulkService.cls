@RestResource (urlMapping='/infinit/v1/bulk')
global class INX_BulkService {

    @HttpPost
    global static void doPost() {

        INX_ServiceMapper.routeRequest();
    }
}