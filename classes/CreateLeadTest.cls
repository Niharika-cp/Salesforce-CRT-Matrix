@isTest private class CreateLeadTest {    
 @isTest     static void testCreateNewLead() {   
       // Test data setup        
        Test.startTest();     
            CreateLead.createNewLead();        
             Test.stopTest();         // Verify the lead creation  
                    Lead createdLead = [SELECT Id, FirstName, LastName, Company, Status FROM Lead WHERE FirstName = 'Test' AND LastName = 'Lead' LIMIT 1];       
                      System.assertEquals('Test', createdLead.FirstName);   
                            System.assertEquals('Lead', createdLead.LastName);     
                                System.assertEquals('Test Company', createdLead.Company);
                     System.assertEquals('Open - Contracted', createdLead.Status);   
   } }