@isTest
public with sharing class TestClassForSME {

    
     @testSetup
    static void createObjectData(){                                             //creating all object Data
        
        copado.GlobalAPI copadoGlobalAPI = new copado.GlobalAPI();
        copado.GlobalAPI.UserLicense UL = new copado.GlobalAPI.UserLicense();
        
        UL.isCADEnabled = false; //Agile delivery license
        UL.isCCHEnabled = false; //Compliance hub license
        UL.isCCMEnabled = true; //Change management (developer) license
        UL.isCopadoEnabled = true; //Enterprise (admin / release manager) license
        //UL.isCSTEnabled = true; //Copado Selenium testing license
        UL.userId = UserInfo.getUserId();
        
        copado.GlobalAPI.LicenseOperationResult result = copadoGlobalAPI.upsertCopadoLicense(UL);
        if(result.isSuccess){
            System.debug('License assigned successfully');
        } else {
            System.debug('An error occurred during license assignment with the error message ' + result.errorString);
        }
        
        // CREATE ENVIRONMENT
         copado__Environment__c objEnvi1 = new copado__Environment__c(Name='TRNDEV1',copado__Platform__c='Salesforce');
        insert objEnvi1;
        
        copado__Environment__c objEnvi2 = new copado__Environment__c(Name='TRNQA',copado__Platform__c='Salesforce');
        insert objEnvi2;
        
        
        //CREATE CREDENTIAL
        copado__Org__c objCredential1 = new copado__Org__c (Name='TRNDEV1',	copado__Org_Type__c='Sandbox' ,copado__Disable_Validation__c=true,copado__Environment__c = objEnvi1.Id);
        insert objCredential1;
        
        copado__Org__c objCredential2 = new copado__Org__c (Name='TRNQA',	copado__Org_Type__c='Sandbox' ,copado__Disable_Validation__c=true,copado__Environment__c = objEnvi2.Id);
        insert objCredential2;
        
        
        /*CREATE PROMOTION
        copado__Promotion__c objPromotion = new copado__Promotion__c(copado__Source_Environment__c=objEnvi1.Id,copado__Source_Org_Credential__c=objCredential1.Id,copado__Destination_Org_Credential__c=objCredential2.Id,copado__Destination_Environment__c=objEnvi2.Id);
        insert objPromotion;*/
        
        
        //CREATE DEPLOYMENT
       // String depName1 = 'Deploy1 - '+objPromotion.Name+' => TRNQA';
        //string depName2 = 'Deploy2 - '+objPromotion.Name+' => TRNQA (2)';
        
        copado__Deployment__c objDep1 = New copado__Deployment__c(Name='depName1',copado__From_Org__c=objCredential1.Id);
        insert objDep1;
      
        
        copado__Deployment__c objDep2 = New copado__Deployment__c(Name='depName2',copado__From_Org__c=objCredential1.Id,copado__Status__c='Draft');
        insert objDep2;
        
        
        
        //CREATE PIPELINE
        copado__Deployment_Flow__c objPipeline = new copado__Deployment_Flow__c(Name= 'Test Pipeline Name',copado__Active__c = true,copado__Platform__c ='Salesforce'/*,copado__Deployment_Automation__c =objDep1.Id*/);
        insert objPipeline;
        
        //CREATE PIPELINE CONNECTIONS
        copado__Deployment_Flow_Step__c objPipConn = new copado__Deployment_Flow_Step__c(copado__Deployment_Flow__c = objPipeline.Id,	copado__Source_Environment__c=objEnvi1.Id, 	copado__Destination_Environment__c=objEnvi2.Id,	copado__Branch__c='trndev1');
        insert objPipConn;
        
        //CREATE STEP
        List<copado__Step__c> stepList=new List<copado__Step__c>();
        
        for(Integer i=0 ; i<20; i++){
            copado__Step__c objStep= new copado__Step__c(Name='promotion 1'+i,copado__Deployment__c=objDep1.Id,copado__Order__c=1,copado__Branch__c ='promotion',copado__Status__c='In progress',copado__CheckOnly__c=true,Is_Deleted__c = false);
            stepList.add(objStep);
        }
        Database.insert(stepList,false);
        
        system.debug('stepList  object List'+stepList);
        system.debug('stepList  object List Size'+stepList.Size());
        
        //CREATE PROJECT
        
        copado__Project__c objProject= new copado__Project__c(Name='Test Project Name',copado__Deployment_Flow__c=objPipeline.Id);
        insert objProject;
        
         //CREATE Deployment Job
      
        copado__Deployment_Job__c objDJ= new copado__Deployment_Job__c(copado__Step__c=stepList[0].Id,copado__Destination_Org__c=objCredential2.Id);
        insert objDJ;
    }
    
     @isTest
    Public static void testGetStepObjectRecordList(){
        
       List<copado__Step__c> stepList=[Select Id from copado__Step__c ];
        
        CentralClass.getStepObjectRecordList(3);
        system.assertEquals(20,  CentralClass.getStepObjectRecordList(3).size());
        
        CentralClass.getStepObjectRecordList(6);
        system.assertEquals(20,  CentralClass.getStepObjectRecordList(6).size());
        
        
        CentralClass.getStepObjectRecordList(12);
        system.assertEquals(20,  CentralClass.getStepObjectRecordList(12).size());
        
    }
}