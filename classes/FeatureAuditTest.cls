@isTest
private class FeatureAuditTest {
    @testSetup
    static void testSetup(){
    List<ChartObject__c> coList = New List<ChartObject__c>();
    ChartObject__C co1 = New ChartObject__c();
    co1.Name = 'Automation Template';
    co1.X__c = 20;
    co1.Y__c = 30;
    coList.add(co1);
    ChartObject__C co2 = New ChartObject__c();
    co2.Name = 'Copado Functions';
    co2.X__c = 0;
    co2.Y__c = 0;
    coList.add(co2);
        ChartObject__C co3 = New ChartObject__c();
    co3.Name = 'Data Templates';
    co3.X__c = 0;
    co3.Y__c = 0;
    coList.add(co3);
        ChartObject__C co4 = New ChartObject__c();
    co4.Name = 'Deployments';
    co4.X__c = 0;
    co4.Y__c = 0;
    coList.add(co4);
        ChartObject__C co5 = New ChartObject__c();
    co5.Name = 'Exclude Completed Stories';
    co5.X__c = 0;
    co5.Y__c = 0;
    coList.add(co5);
        ChartObject__C co6 = New ChartObject__c();
    co6.Name = 'Org Differences';
    co6.X__c = 0;
    co6.Y__c = 0;
    coList.add(co6);
        ChartObject__C co7 = New ChartObject__c();
    co7.Name = 'Promotions';
    co7.X__c = 0;
    co7.Y__c = 0;
    coList.add(co7);
        ChartObject__C co8 = New ChartObject__c();
    co8.Name = 'Rollback Feature';
    co8.X__c = 0;
    co8.Y__c = 0;
    coList.add(co8);
        ChartObject__C co9 = New ChartObject__c();
    co9.Name = 'Snapshot Differences';
    co9.X__c = 0;
    co9.Y__c = 0;
    coList.add(co9);
        ChartObject__C co10 = New ChartObject__c();
    co10.Name = 'Static Code Analysis';
    co10.X__c = 0;
    co10.Y__c = 0;
    coList.add(co10);
        ChartObject__C co11 = New ChartObject__c();
    co11.Name = 'User Stories';
    co11.X__c = 0;
    co11.Y__c = 0;
    coList.add(co11);
        ChartObject__C co12 = New ChartObject__c();
    co12.Name = 'User Story Bundles';
    co12.X__c = 0;
    co12.Y__c = 0;
    coList.add(co12);
        ChartObject__C co13 = New ChartObject__c();
    co13.Name = 'User Story Dependencies';
    co13.X__c = 0;
    co13.Y__c = 0;
    coList.add(co13);
    insert coList;
        copado.GlobalAPI copadoGlobalAPI = new copado.GlobalAPI();
        copado.GlobalAPI.UserLicense UL = new copado.GlobalAPI.UserLicense();
        UL.isCADEnabled = false;
        UL.isCCHEnabled = false;
        UL.isCCMEnabled = true;
        UL.isCopadoEnabled = true;
        UL.isCSTEnabled = false;
        UL.userId = userInfo.getUserId();
        copado.GlobalAPI.LicenseOperationResult result = copadoGlobalAPI.upsertCopadoLicense(UL);
        if(result.isSuccess){
            System.debug('License assigned successfully');
        }
        else {
            System.debug('An error occurred during license assignment with the error message ' + result.errorString);
        }
        
        /*copado.GlobalAPI copadoGlobalAPI = new copado.GlobalAPI();
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
        */
        copado__Function__c cf = New copado__Function__c();
        cf.Name = 'Test Function';
        cf.copado__API_Name__c = 'Run_Checkmarx_QIF_1';
        insert cf;
        
        copado__Data_Template__c cd = New copado__Data_Template__c();
        cd.Name = 'Test Data Template';
        insert cd;
        
        copado__Deployment__c cdo = New copado__Deployment__c();
        cdo.Name = 'Test Deployment';
        insert cdo;
        
        copado__User_Story__c cu = New copado__User_Story__c();
        cu.copado__User_Story_Title__c = 'Test UserStory';
        cu.copado__Exclude_From_CBM__c = TRUE;
        cu.copado__Stop_Indexing_Metadata__c = true;
        cu.copado__Is_Bundle__c=true;
        insert cu;
        
        copado__Environment__c objEnvi1 = new copado__Environment__c(Name='TRNDEV1',copado__Platform__c='Salesforce');
        insert objEnvi1;
        
        copado__Environment__c objEnvi2 = new copado__Environment__c(Name='TRNQA',copado__Platform__c='Salesforce');
        insert objEnvi2;
        
        copado__Org__c objCredential1 = new copado__Org__c (Name='TRNDEV1',	copado__Org_Type__c='Sandbox' ,copado__Disable_Validation__c=true,copado__Environment__c = objEnvi1.Id);
        insert objCredential1;
        
        copado__Org__c objCredential2 = new copado__Org__c (Name='TRNQA',	copado__Org_Type__c='Sandbox' ,copado__Disable_Validation__c=true,copado__Environment__c = objEnvi2.Id);
        insert objCredential2;
        
        copado__OrgDiff__c cod = New copado__OrgDiff__c();
        cod.Name = 'Test Org';
        cod.copado__From_Org__c = objCredential1.Id;
        cod.copado__To_Org__c = objCredential2.Id;
        insert cod;
        
        //Create Pipeline
        copado__Deployment_Flow__c objPipeline = new copado__Deployment_Flow__c(Name= 'Test Pipeline Name',copado__Active__c = true,copado__Platform__c ='Salesforce'/*,copado__Deployment_Automation__c =objDep1.Id*/);
        insert objPipeline;
        
        //CREATE PIPELINE CONNECTIONS
        copado__Deployment_Flow_Step__c objPipConn = new copado__Deployment_Flow_Step__c(copado__Deployment_Flow__c = objPipeline.Id,	copado__Source_Environment__c=objEnvi1.Id, 	copado__Destination_Environment__c=objEnvi2.Id,	copado__Branch__c='trndev1');
        insert objPipConn;
        
        //CREATE PROJECT
        copado__Project__c objProject= new copado__Project__c(Name='Test Project Name',copado__Deployment_Flow__c=objPipeline.Id);
        insert objProject;
        
        copado__Promotion__c cp = New copado__Promotion__c();
        cp.copado__Is_Rolled_Back__c = true;
        cp.copado__Status__c = 'Completed';
        cp.copado__Project__c = objProject.Id;
        cp.copado__Source_Environment__c = objEnvi1.Id;
        cp.copado__Destination_Environment__c = objEnvi2.Id;
        insert cp;
        
        copado__Snapshot_Difference__c cs = New copado__Snapshot_Difference__c();
        cs.Name = 'Test Snapshot';
        insert cs;
        
        copado__Static_Code_Analysis_Result__c csc = New copado__Static_Code_Analysis_Result__c();
        csc.copado__Details__c = 'Test Static Code';
        insert csc;
        
        copado__Team_Dependency__c ct = New copado__Team_Dependency__c();
        ct.copado__Provider_User_Story__c = cu.Id;
        ct.copado__Dependent_User_Story__c = cu.Id;
        insert ct;
        
        copado__Deployment__c objDep1 = New copado__Deployment__c(Name='depName1',copado__From_Org__c=objCredential1.Id, copado__Status__c = 'Completed Successfully');
        insert objDep1;
        
        }
    
    @isTest
    static void fAT1(){
        Test.startTest();
        Map<String,ChartObject__c> check1 = ChartWire.getName();
        ChartObject__c cobj = check1.get('x0');
        //ChartObject__c fetchedData = [SELECT Name from ChartObject__c ORDER BY Name ASC LIMIT 1];
        System.assert(cobj.Name == 'Automation Template');
        Test.stopTest();
    }
    @isTest
    static void fAT2(){
        Test.startTest();
        List<ChartObject__c> check1 = ChartWire.getEmpty();
        ChartObject__c fetchedData = [SELECT Name,X__c, Y__c from ChartObject__c Where X__c = 0 AND Y__c =0 ORDER BY Name ASC Limit 1];
        System.assert(check1[0].Name == fetchedData.Name);
        Test.stopTest();
    }
    @isTest
    static void fAT3(){
        Test.startTest();
        ChartObjectQuery coq = New ChartObjectQuery();
        string sch = '0 0 6 * * ? *';
        System.schedule('TestJob', sch, coq);
        CronTrigger crt = [SELECT CronJobDetail.Name FROM CronTrigger Where CronJobDetail.Name = 'TestJob' LIMIT 1];
        system.assert(crt.CronJobDetail.Name == 'TestJob');
        Test.stopTest();
    }
    @isTest
    static void fAT4(){
        Test.startTest();
        ChartObjectQuery obj = New ChartObjectQuery();
        String sch = '0 0 6 * * ? *';
        System.schedule('Schedule Chart', sch, obj);
        String chk2 = ChartObjectQuery.warnScheduled();
        CronTrigger crt = [SELECT Id, CronJobDetail.Name FROM CronTrigger Where CronJobDetail.Name = 'Schedule Chart' LIMIT 1];
        if( crt != null){
            System.assert(chk2 != 'empty');
        }
        /*String chk1 = ChartObjectQuery.warnScheduled();
        System.assert(chk1=='empty');
        Test.stopTest();*/
    }
    @isTest
    static void fAT5(){
        Test.startTest();
        String jobid = ScheduleChart.scheduled();
        CronTrigger crt = [SELECT Id, CronJobDetail.Name FROM CronTrigger Where CronJobDetail.Name = 'Schedule Chart' LIMIT 1];
        if( crt != null){
            System.assert(jobid == crt.Id);
        }
        String jobid2 = ScheduleChart.scheduled();
        System.assert(jobid2 == 'Dont Allow');
        Test.stopTest();
        }
    /*@isTest
    static void fAT6(){
        //Before running, ensure that RemoveScheduledChart is already scheduled. Else, it will not have code coverage.
        Test.startTest();
        RemoveScheduledChart coq = New RemoveScheduledChart();
        string sch = '0 3 6 * * ? *';
        System.schedule('TestJob1', sch, coq);
        Test.stopTest();
    }*/
    
    
}