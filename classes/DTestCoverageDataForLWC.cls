/**
* This class provides functionality to  show data  and calculates test coverage percentage for Apex classes
*/
public class DTestCoverageDataForLWC{
    // Define the Tooling API endpoint for querying Apex code coverage data
    // Define a global list of TestCoveragePercent
    public Static List<TestCoveragePercent> myGlobalList = new List<TestCoveragePercent>();
    public static String TOOLINGAPI_ENDPOINT =  URL.getSalesforceBaseUrl().toExternalForm()+'/services/data/v56.0/tooling/';
    /*
* This method calculates the test coverage percentage for each Apex class
* bearer - the user's session ID to authenticate the Tooling API request
* @return a list of TestCoveragePercent objects containing the coverage percentage for each Apex class
*/
    @AuraEnabled(cacheable=true)
    public static List<TestCoveragePercent> calculateCoverage(){
        // Define the SOQL query to retrieve Apex code coverage data
        String queryStr = 'SELECT+ApexTestClass.name,ApexClassOrTrigger.Name,TestMethodName,NumLinesCovered,NumLinesUncovered+FROM+ApexCodeCoverage';
        // Send a Tooling API query request to retrieve the code coverage data
        TestCoverageWrapperClass objts = sendToolingQueryRequest(queryStr);
        // Create a list to store TestCoveragePercent object Data
        List<TestCoveragePercent> objList = New List<TestCoveragePercent>();
        // Loop through the retrieved Apex code coverage data and calculate the coverage percentage for each class
        for(TestCoverageWrapperClass.Records s : objts.records){
            // Create a new TestCoveragePercent object for the current Apex class
            TestCoveragePercent n = new TestCoveragePercent();
            n.name = s.ApexClassOrTrigger.Name;           
            n.testNam= s.ApexTestClass.name;
            n.testmth= s.TestMethodName;
            n.numCov=s.NumLinesCovered;
            n.numUncov=s.NumLinesUncovered;
            decimal total =(s.NumLinesCovered+s.NumLinesUncovered);
            // Calculate the coverage percentage for the current Apex class
            if(total!=0){
                double per =s.NumLinesCovered/total;
                n.covPer = per;
                
            }
            else{
                n.covPer = 0;
                
            }
            
            // Add the TestCoveragePercent object to the list
            objList.add(n);
        }
      // Debug the list of TestCoveragePercent objects
        system.debug('Object List==='+objList);
        
        myGlobalList.addAll(objList);
        
        system.debug('myGlobalList List==='+myGlobalList);
        // Return the list of TestCoveragePercent objects
        return objList;
    }
    /** 
* This method sends a Tooling API query request to retrieve Apex code coverage data
*  queryStr - the SOQL query string to retrieve the code coverage data
* @return a TestCoverageWrapper object containing the retrieved code coverage data
*/   
    @AuraEnabled(cacheable=true)
    public static TestCoverageWrapperClass sendToolingQueryRequest(String queryStr){
        // Create a new HTTP request object for the Tooling API query request
        HttpRequest req = new HttpRequest();
        req.setEndpoint(TOOLINGAPI_ENDPOINT+'query/?q='+queryStr);
        // Set the authorization header using the user's session ID
//if(!Test.isRunningTest()){
         req.setHeader('Authorization', 'Bearer ' + UtilsGetSessionId.getSessionIdFromVFPage(Page.GetSessionId));
       /* }
    else {
        req.setHeader('Authorization', 'Bearer ' + UserInfo.getSessionId().subString(15));
    }  */      // Set the HTTP request method to GET
        req.setMethod('GET');
        // Create a new HTTP object to send the Tooling API query request
        Http http = new Http();
        HTTPResponse res = new HTTPResponse();
        // Send the Tooling API query request and retrieve the HTTP response
        res = http.send(req);
        if(res.getStatusCode() == 200){
      TestCoverageWrapperClass objts = (TestCoverageWrapperClass) JSON.deserialize(res.getbody() ,TestCoverageWrapperClass.class);
            return objts;
        }
        else {
            system.debug(res.getStatus());
            system.debug(res.getStatusCode());
            return null;
        }
        
    }
    
    @AuraEnabled
    public static List<TestCoveragePercent> searchKey(String searchKey ){
        try {
            List<TestCoveragePercent> matchingtcps = new List<TestCoveragePercent>();
            calculateCoverage();
            system.debug('Global List======'+myGlobalList);
            for(TestCoveragePercent tcp:myGlobalList){
                if (tcp.Name != null && tcp.Name.toLowerCase().contains(searchKey.toLowerCase())) {
                    // Add the account to the matching accounts list if its name contains the nameText parameter
                    matchingtcps.add(tcp);
                }
            }
            
            return matchingtcps;
            
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }
    
    public class TestCoveragePercent {
        @AuraEnabled     public String name;
        @AuraEnabled     public String testNam;
        @AuraEnabled     public String testmth;
        @AuraEnabled    public Integer numUncov;
        @AuraEnabled    public Integer numCov;
        @AuraEnabled  public Decimal covPer;
    }
    
}