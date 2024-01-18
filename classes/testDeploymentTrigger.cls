@isTest
public class testDeploymentTrigger {
    
    @testSetup
    static void createObjectData(){
        
        copado__User_Story__c objUS  = new copado__User_Story__c(copado__User_Story_Title__c = 'Test User Story',No_of_Bug_Fixes__c=0);
        insert objUS;
        
        
        copado__Environment__c objEnvi1 = new copado__Environment__c(Name='TRNDEV1',copado__Platform__c='Salesforce');
        insert objEnvi1;
        
        copado__Environment__c objEnvi2 = new copado__Environment__c(Name='TRNQA',copado__Platform__c='Salesforce');
        insert objEnvi2;
        
        
        copado__Org__c objCredential1 = new copado__Org__c (Name='TRNDEV1',	copado__Org_Type__c='Sandbox' ,copado__Disable_Validation__c=true,copado__Environment__c = objEnvi1.Id);
        insert objCredential1;
        
        copado__Org__c objCredential2 = new copado__Org__c (Name='TRNQA',	copado__Org_Type__c='Sandbox' ,copado__Disable_Validation__c=true,copado__Environment__c = objEnvi2.Id);
        insert objCredential2;
        
        
        copado__Promotion__c objPromotion = new copado__Promotion__c(copado__Source_Environment__c=objEnvi1.Id,copado__Source_Org_Credential__c=objCredential1.Id,copado__Destination_Org_Credential__c=objCredential2.Id,copado__Destination_Environment__c=objEnvi2.Id);
        insert objPromotion;
        
        
        copado__Promoted_User_Story__c objPromUS = New copado__Promoted_User_Story__c(Name='Promoted User Story',copado__User_Story__c=objUS.Id,copado__Promotion__c=objPromotion.Id);
        insert objPromUS;
        
        
        String depName1 = 'Deploy - '+objPromotion.Name+' => TRNQA';
        String depName2 = 'Deploy - '+objPromotion.Name+' => TRNQA (2)';
        
        copado__Deployment__c objDep1 = New copado__Deployment__c(Name=depName1,copado__From_Org__c=objCredential1.Id,copado__Status__c='Draft');
        insert objDep1;
        objDep1.copado__Status__c='Completed Successfully';
        update objDep1;
        
        copado__Deployment__c objDep2 = New copado__Deployment__c(Name=depName2,copado__From_Org__c=objCredential1.Id,copado__Status__c='Draft');
        insert objDep2;
    }
    
    @isTest
    public Static void testBugFixesCount(){
        
        copado__Deployment__c objDep = [SELECT Id, Name, copado__Status__c, copado__Promotion__c,copado__Promotion__r.copado__Source_Environment__r.name,copado__Promotion__r.copado__Destination_Environment__r.name FROM copado__Deployment__c where copado__Status__c='Draft'];
        system.debug('objDep ==='+objDep);
        objDep.copado__Status__c = 'Completed Successfully';
        update objDep;
        
        Decimal Count = [Select Id, Name,No_of_Bug_Fixes__c from copado__User_Story__c ].No_of_Bug_Fixes__c;
        system.assertEquals(1, Count);
    }    
}