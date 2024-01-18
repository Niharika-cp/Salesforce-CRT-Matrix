public inherited sharing class INX_ServiceMapper {

    public static void routeRequest() {

        String strResource = getResource();

        System.debug(strResource);

        RestContext.response.headers.put('Content-Type', 'application/json');

        try {
            switch on strResource {
                when 'about[GET][v1]' {
                    INX_Domain.handleAbout();
                }
                when 'checkexisting[GET][v1]' {
                    INX_Domain.handleCheckExisting();
                }
                when 'access[GET][v1]' {
                    INX_AccessDomain.handleGet();
                }
                when 'access[POST][v1]' {
                    INX_AccessDomain.handleCreateUpdate();
                }
                when 'access[DELETE][v1]' {
                    INX_AccessDomain.handleDelete();
                }
                when 'activity[GET][v1]' {
                    INX_ActivityDomain.handleGet();
                }
                when 'activity[POST][v1]' {
                    INX_ActivityDomain.handleCreateUpdate();
                }
                when 'bulk[POST][v1]' {
                    INX_ActivityDomain.handleBulkGet();
                }
                when else {
                    throw new INX.ApplicationException(400, 'Unsupported request');
                }
            }
        } catch (INX.ApplicationException ex) {
            returnError(ex.errorCode, ex);
        } catch (Exception ex) {
            returnError(ex);
        }
    }

    public static String getResource() {

        String strResourcePath = RestContext.request.resourcePath.replace('/services/apexrest/infinit/', ''),
        strHttpMethod = RestContext.request.httpMethod;

        String[] resourceInfo = strResourcePath.split('/');
        String version = resourceInfo[0];
        String strResource = resourceInfo[1];

        return strResource + '[' + strHttpMethod + ']' + '[' + version + ']';
    }

    public static void returnError(Integer errorCode, Exception ex) {

        RestContext.response.statusCode = errorCode;
        getResponseBody(ex);
    }

    public static void returnError(Exception ex) {

        RestContext.response.statusCode = 500;
        getResponseBody(ex);
    }

    public static void getResponseBody(Exception ex) {
        RestContext.response.responseBody = Blob.valueOf(
            JSON.serialize(
                new INX.Error[] {
                    new INX.Error(RestContext.response.statusCode, ex.getMessage())
                },
                true
            )
        );
    }
}