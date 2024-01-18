@isTest
public class ChartWireTest {
    @isTest
    static void testGetNameMethod(){
        Integer ex = 0;
        List<ChartObject__c> objList = New List<ChartObject__c>();
        try{
        Map<String,ChartObject__c> check = ChartWire.getName();
        if(check.size()!=null){
            objList = check.values();
        }
        }
        catch(exception e){
            System.debug('This Test Class is to check whether exception is raised or not');
            ex=1;
        }
        finally{
            Assert.areEqual(objList.size(), 0);
            Assert.areEqual(ex, 1);
        }
    }
    @isTest
    static void testGetEmptyMethod(){
        Integer ex2 = 0;
        List<ChartObject__c> checkList = New List<ChartObject__c>();
        try{
        checkList = ChartWire.getEmpty();
        if(checkList.size()!=null){
            
        }
        }
        catch(exception e){
           System.debug('This Test Class is to check whether exception is raised or not');
            ex2=1; 
        }
        finally{
            Assert.areEqual(checkList.size(), 0);
            Assert.areEqual(ex2, 1);
            
        }
    }
}