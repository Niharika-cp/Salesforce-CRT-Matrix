@isTest
public with sharing class testDeploymentRecord {
    

    
    @istest
    static void createDeploymentData(){                                             //creating all object Data

        system.debug('Creating createDeploymentData');

        copado__Org__c objCredential = new copado__Org__c (Name='Test Credential',	copado__Org_Type__c='Sandbox' ,copado__Disable_Validation__c=true);
        insert objCredential;
        

        copado__Deployment__c objDeployment = new 	copado__Deployment__c(Name='TestDeployment',copado__From_Org__c=objCredential.Id);
    // Database.insert(objDeployment,false);
       insert objDeployment;

        system.debug('Deployment Record'+objDeployment);
    }



}