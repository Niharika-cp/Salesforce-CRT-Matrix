@isTest
private class UpdateMdtTest {
    @isTest 
    private static void methodTest(){
        Test.startTest();
        String st = UpdateMdt.updateValue('Completed');
        Test.stopTest();
        List<Copado_Utility_Configuration__mdt> metaList = [SELECT MasterLabel,DeveloperName,Value__c 
                                                                  FROM Copado_Utility_Configuration__mdt 
                                                                  where Value__c='Completed' AND MasterLabel='Production Status'];
        system.assertEquals('varResult', st);
    }
    @isTest
    private static void mtd(){
        String valueFromMethod = UpdateMdt.showPreviousValue();
       /*String[] sampleValues = new String[]{'Draft','Backlog','Backburner','Awaiting Approval','Approved','Rejected','In Progress',
                                               'Ready for testing','Completed','Cancelled','TO DO','DONE'};*/
         //Copado_Utility_Configuration__mdt mdList = [SELECT MasterLabel,DeveloperName,Value__c  FROM Copado_Utility_Configuration__mdt Where MasterLabel = 'Production Status'];
        //system.assertEquals(valueFromMethod,mdList.Value__c);
    }
}