@isTest
global class MockHttpTestCoverage implements HttpCalloutMock {
    global HTTPResponse respond(HTTPRequest req) {
        // Optionally, only send a mock response for a specific endpoint
        // and method.
        System.assertEquals('GET', req.getMethod());
        
        // Create a fake response
        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'application/json;charset=UTF-8');
        res.setStatusCode(200);
        res.setBody('{ "size" : 1, "totalSize" : 1, "done" : true, "queryLocator" : null, "entityTypeName" : "ApexCodeCoverage", "records" : [ { "attributes" : { "type" : "ApexCodeCoverage", "url" : "/services/data/v56.0/tooling/sobjects/ApexCodeCoverage/7145200001dEXu4AAG" }, "ApexTestClass" : { "attributes" : { "type" : "ApexClass", "url" : "/services/data/v56.0/tooling/sobjects/ApexClass/01p5200000BlnRfAAJ" }, "Name" : "cmlConvertRecordsToCSVQueueableTest" }, "ApexClassOrTrigger" : { "attributes" : { "type" : "Name", "url" : "/services/data/v56.0/tooling/sobjects/ApexClass/01p5200000BlnReAAJ" }, "Name" : "cmlConvertRecordsToCSVQueueable" }, "NumLinesCovered" : 78, "NumLinesUncovered" : 93 } ] }');
        return res;
    }
}