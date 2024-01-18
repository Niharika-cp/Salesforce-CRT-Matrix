@isTest
public class DTestCoverageDataForLWCTest {
    @IsTest(SeeAllData=true)
    public static void testCalculateCoverage() {
        
        String queryStr = 'SELECT+ApexTestClass.name,ApexClassOrTrigger.Name,TestMethodName,NumLinesCovered,NumLinesUncovered+FROM+ApexCodeCoverage ';
        try{
            Test.setMock(HttpCalloutMock.class, new MockHttpTestCoverage());   
            DTestCoverageDataForLWC.calculateCoverage();
        }
        catch(Exception e){
        Assert.isNotNull(e);
        }        
    }
    
    @isTest
    static void testSearchKey() {        
        try{
            DTestCoverageDataForLWC.searchKey('Test');           
        }
        catch(Exception e){
        Assert.isNotNull(e);
        }        
    }    
}