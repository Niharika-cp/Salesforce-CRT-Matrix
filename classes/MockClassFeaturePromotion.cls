@isTest
global class MockClassFeaturePromotion implements HttpCalloutMock {
    // Implement this interface method
    global HTTPResponse respond(HTTPRequest req) {
        // Optionally, only send a mock response for a specific endpoint
        // and method.
      //  System.assertEquals('https://app-api.copado.com/json/v1/webhook/deleteGitBranches/a1R52000004XdgBEAS?api_key=bdf1bc9ec0771f0543e73408c3efd8dd', req.getEndpoint());
       // System.assertEquals('POST', req.getMethod());
        
        // Create a fake response
        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'application/json;charset=UTF-8');
       // res.setBody('{"gitBranches":["feature/US-0000013"]}');
        res.setStatusCode(200);
        return res;
    }
}