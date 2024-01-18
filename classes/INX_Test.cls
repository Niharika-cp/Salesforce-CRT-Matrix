@isTest
public with sharing class INX_Test {

    public static testMethod void testAboutService() {

        Blob response;

        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();

        req.resourcePath = '/services/apexrest/infinit/v1/about';
        req.httpMethod = 'GET';

        RestContext.request = req;
        RestContext.response = res;

        Test.startTest();

            INX_AboutService.doGet();

            response = Blob.valueOf(JSON.serialize(new INX.About(), true));

            System.assertEquals(response, RestContext.response.responseBody);

        Test.stopTest();
    }

    public static testMethod void testCheckExistingService() {

        Blob response;

        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();

        req.resourcePath = '/services/apexrest/infinit/v1/checkexisting';
        req.httpMethod = 'GET';

        RestContext.request = req;
        RestContext.response = res;

        Test.startTest();

            INX_CheckExistingService.doGet();

            response = Blob.valueOf(JSON.serialize(new INX.Error[] {
                new INX.Error(400, 'Missing parameter: type')
            }, true));

            System.assertEquals(response, RestContext.response.responseBody);

            String parameters = 'type=package;name=CRM-1';

            req.addParameter('q', EncodingUtil.base64Encode(Blob.valueOf(parameters)));

            INX_CheckExistingService.doGet();

            response = Blob.valueOf(JSON.serialize(new INX.Error[] {
                new INX.Error(404, 'Not found')
            }, true));

            System.assertEquals(response, RestContext.response.responseBody);

            parameters = 'type=deployment;subType=package;name=CRM-1;instance=DEV1';

            req.addParameter('q', EncodingUtil.base64Encode(Blob.valueOf(parameters)));

            INX_CheckExistingService.doGet();

            System.assertEquals(response, RestContext.response.responseBody);

        Test.stopTest();
    }

    public static testMethod void testAccessService() {

        Blob response;

        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();

        INX_Instance__c sObj = new INX_Instance__c(
            Name = 'DEV',
            INX_Id__c = INX_Utility.getUUID()
        );
        insert sObj;

        sObj = new INX_Instance__c(
            Name = 'QA',
            INX_Id__c = INX_Utility.getUUID()
        );
        insert sObj;

        INX.Access obj = new INX.Access();
        obj.isLocked = false;
        obj.email = 'abc@xyz.com';
        obj.canRead = false;
        obj.canPromote = false;
        obj.canManage = true;
        obj.canDeploy = false;
        obj.canCommit = false;

        req.resourcePath = '/services/apexrest/infinit/v1/access';
        req.httpMethod = 'POST';
        req.requestBody = Blob.valueOf(JSON.serialize(obj, true));

        RestContext.request = req;
        RestContext.response = res;

        Test.startTest();

            INX_AccessService.doPost();

            response = Blob.valueOf(JSON.serialize(obj, true));

            System.assertEquals(response, RestContext.response.responseBody);

            obj.email = 'abc2@xyz.com';
            obj.canManage = false;

            req.requestBody = Blob.valueOf(JSON.serialize(obj, true));

            INX_AccessService.doPost();

            response = Blob.valueOf(JSON.serialize(obj, true));

            System.assertEquals(response, RestContext.response.responseBody);

            obj.email = 'abc2@xyz.com';
            obj.instance = 'DEV';
            obj.canRead = true;

            req.requestBody = Blob.valueOf(JSON.serialize(obj, true));

            INX_AccessService.doPost();

            response = Blob.valueOf(JSON.serialize(obj, true));

            System.assertEquals(response, RestContext.response.responseBody);

            req.httpMethod = 'GET';
            req.addParameter('email', 'abc@xyz.com');

            INX_AccessService.doGet();

            System.assertEquals(
                3,
                (
                    (INX.AccessResponse) JSON.deserialize(
                        RestContext.response.responseBody.toString(),
                        INX.AccessResponse.class
                    )
                ).accesses.size()
            );

            req.addParameter('email', 'abc2@xyz.com');

            INX_AccessService.doGet();

            System.assertEquals(
                3,
                (
                    (INX.AccessResponse) JSON.deserialize(
                        RestContext.response.responseBody.toString(),
                        INX.AccessResponse.class
                    )
                ).accesses.size()
            );

            req.addParameter('instance', 'DEV');

            INX_AccessService.doGet();

            System.assertEquals(
                1,
                (
                    (INX.AccessResponse) JSON.deserialize(
                        RestContext.response.responseBody.toString(),
                        INX.AccessResponse.class
                    )
                ).accesses.size()
            );

            req.addParameter('email', '');

            INX_AccessService.doGet();

            System.assertEquals(
                2,
                (
                    (INX.AccessResponse) JSON.deserialize(
                        RestContext.response.responseBody.toString(),
                        INX.AccessResponse.class
                    )
                ).accesses.size()
            );

            req.httpMethod = 'DELETE';
            req.addParameter('email', 'abc2@xyz.com');

            INX_AccessService.doDelete();

            req.addParameter('instance', '');

            INX_AccessService.doDelete();

        Test.stopTest();
    }

    public static testMethod void testActivityServiceForInstance() {

        Blob response;

        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();

        INX_Instance__c sObjInstance = new INX_Instance__c(
            Name = 'QA',
            INX_Id__c = INX_Utility.getUUID()
        );
        insert sObjInstance;

        INX_Repository__c sObjRepository = new INX_Repository__c(
            Name = 'SFDC',
            INX_Id__c = INX_Utility.getUUID()
        );
        insert sObjRepository;

        INX.Activity obj = new INX.Activity();
        obj.action = 'added';
        obj.activityDate = System.now();
        obj.id = INX_Utility.getUUID();
        obj.instance = 'DEV';
        obj.message = 'instance {{action}}';
        obj.type = 'instance';
        obj.email = 'abc@xyz.com';
        obj.closeBranch = false;

        obj.instanceInfo = new INX.Instance();
        obj.instanceInfo.id = INX_Utility.getUUID();
        obj.instanceInfo.name = 'DEV';
        obj.instanceInfo.endPoint = 'login.salesforce.com';
        obj.instanceInfo.version = '51.0';
        obj.instanceInfo.isActive = true;
        obj.instanceInfo.shareCredentials = false;
        obj.instanceInfo.parent = 'QA';
        obj.instanceInfo.repository = 'SFDC';

        req.resourcePath = '/services/apexrest/infinit/v1/activity';
        req.httpMethod = 'POST';
        req.requestBody = Blob.valueOf(JSON.serialize(obj, true));

        RestContext.request = req;
        RestContext.response = res;

        Test.startTest();

            INX_ActivityService.doPost();

            req.resourcePath = '/services/apexrest/infinit/v1/activity/' + obj.id;
            req.requestURI = '/services/apexrest/infinit/v1/activity/' + obj.id;
            req.httpMethod = 'GET';

            INX_ActivityService.doGet();

        Test.stopTest();
    }

    public static testMethod void testActivityServiceForPackage() {

        Blob response;

        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();

        INX_Instance__c sObjInstance = new INX_Instance__c(
            Name = 'DEV',
            INX_Id__c = INX_Utility.getUUID()
        );
        insert sObjInstance;

        INX_Access__c sObjAccess = new INX_Access__c(
            INX_Email__c = 'abc@xyz.com',
            INX_Can_Manage__c = true,
            INX_Id__c = 'abc@xyz.com'
        );
        insert sObjAccess;

        INX.Activity obj = new INX.Activity();
        obj.action = 'created';
        obj.activityDate = System.now();
        obj.id = INX_Utility.getUUID();
        obj.instance = 'DEV';
        obj.message = 'package {{action}} for instance #{{instance}}instance {{action}}';
        obj.name = 'CRM-1';
        obj.type = 'package';
        obj.subType = 'package';
        obj.email = 'abc@xyz.com';
        obj.closeBranch = false;

        obj.packageInfo = new INX.PackageInfo();
        obj.packageInfo.id = INX_Utility.getUUID();
        obj.packageInfo.name = 'CRM-1';
        obj.packageInfo.instance = 'DEV';
        obj.packageInfo.version = '51.0';

        req.resourcePath = '/services/apexrest/infinit/v1/activity';
        req.httpMethod = 'POST';
        req.requestBody = Blob.valueOf(JSON.serialize(obj, true));

        RestContext.request = req;
        RestContext.response = res;

        Test.startTest();

            INX_ActivityService.doPost();

            req.resourcePath = '/services/apexrest/infinit/v1/activity/' + obj.id;
            req.requestURI = '/services/apexrest/infinit/v1/activity/' + obj.id;
            req.httpMethod = 'GET';

            INX_ActivityService.doGet();

            req.resourcePath = '/services/apexrest/infinit/v1/activity';
            req.requestURI = '/services/apexrest/infinit/v1/activity';
            req.httpMethod = 'GET';
            req.addParameter('email', 'abc@xyz.com');

            INX_ActivityService.doGet();

            obj.action = 'deleted';
            obj.activityDate = System.now();
            obj.id = INX_Utility.getUUID();

            req.resourcePath = '/services/apexrest/infinit/v1/activity';
            req.httpMethod = 'POST';
            req.requestBody = Blob.valueOf(JSON.serialize(obj, true));

            INX_ActivityService.doPost();

        Test.stopTest();
    }

    public static testMethod void testActivityServiceForTag() {

        Blob response;

        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();

        INX_Instance__c sObjInstance = new INX_Instance__c(
            Name = 'DEV',
            INX_Id__c = INX_Utility.getUUID()
        );
        insert sObjInstance;

        INX_Access__c sObjAccess = new INX_Access__c(
            INX_Email__c = 'abc@xyz.com',
            INX_Can_Manage__c = true,
            INX_Id__c = 'abc@xyz.com'
        );
        insert sObjAccess;

        INX_Package__c sObjPackage = new INX_Package__c(
            Name = 'CRM-1',
            INX_Id__c = INX_Utility.getUUID(),
            INX_Instance__c = sObjInstance.Id
        );
        insert sObjPackage;

        INX.Activity obj = new INX.Activity();
        obj.action = 'created';
        obj.activityDate = System.now();
        obj.id = INX_Utility.getUUID();
        obj.instance = 'DEV';
        obj.message = 'tag {{action}} for instance #{{instance}}';
        obj.name = 'APR-RELEASE';
        obj.type = 'tag';
        obj.subType = 'package';
        obj.email = 'abc@xyz.com';
        obj.closeBranch = false;

        obj.tagInfo = new INX.Tag();
        obj.tagInfo.id = INX_Utility.getUUID();
        obj.tagInfo.name = 'APR-RELEASE';
        obj.tagInfo.instance = 'DEV';
        obj.tagInfo.version = '51.0';

        obj.tagInfo.links = new List<INX.TagLink>();

        req.resourcePath = '/services/apexrest/infinit/v1/activity';
        req.httpMethod = 'POST';
        req.requestBody = Blob.valueOf(JSON.serialize(obj, true));

        RestContext.request = req;
        RestContext.response = res;

        Test.startTest();

            INX_ActivityService.doPost();

            req.resourcePath = '/services/apexrest/infinit/v1/activity/' + obj.id;
            req.requestURI = '/services/apexrest/infinit/v1/activity/' + obj.id;
            req.httpMethod = 'GET';

            INX_ActivityService.doGet();

            obj.action = 'added';
            obj.message = 'tag updated, {{action}} package #{{source}}';
            obj.source = 'CRM-1';
            obj.activityDate = System.now();
            obj.id = INX_Utility.getUUID();

            INX.TagLink objLink = new INX.TagLink();
            objLink.packageName = 'CRM-1';
            objLink.tag = 'APR-RELEASE';
            objLink.id = INX_Utility.getUUID();
            obj.tagInfo.links.add(objLink);

            req.resourcePath = '/services/apexrest/infinit/v1/activity';
            req.httpMethod = 'POST';
            req.requestBody = Blob.valueOf(JSON.serialize(obj, true));

            INX_ActivityService.doPost();

            obj.action = 'removed';
            obj.message = 'tag updated, {{action}} package #{{source}}';
            obj.source = 'CRM-1';
            obj.activityDate = System.now();
            obj.id = INX_Utility.getUUID();

            obj.tagInfo.links = new List<INX.TagLink>();

            req.resourcePath = '/services/apexrest/infinit/v1/activity';
            req.httpMethod = 'POST';
            req.requestBody = Blob.valueOf(JSON.serialize(obj, true));

            INX_ActivityService.doPost();

            obj.action = 'added';
            obj.message = 'tag updated, {{action}} package #{{source}}';
            obj.source = 'CRM-1';
            obj.activityDate = System.now();
            obj.id = INX_Utility.getUUID();

            obj.tagInfo.links.add(objLink);

            req.resourcePath = '/services/apexrest/infinit/v1/activity';
            req.httpMethod = 'POST';
            req.requestBody = Blob.valueOf(JSON.serialize(obj, true));

            INX_ActivityService.doPost();

            req.resourcePath = '/services/apexrest/infinit/v1/activity';
            req.requestURI = '/services/apexrest/infinit/v1/activity';
            req.httpMethod = 'GET';
            req.addParameter('type', 'tag');

            INX_ActivityService.doGet();

            obj.action = 'deleted';
            obj.activityDate = System.now();
            obj.id = INX_Utility.getUUID();

            req.resourcePath = '/services/apexrest/infinit/v1/activity';
            req.httpMethod = 'POST';
            req.requestBody = Blob.valueOf(JSON.serialize(obj, true));

            INX_ActivityService.doPost();

            req.resourcePath = '/services/apexrest/infinit/v1/bulk';
            req.httpMethod = 'POST';
            req.requestBody = Blob.valueOf(JSON.serialize(new List<String>{ 'CRM-1' }, true));

            INX_BulkService.doPost();

        Test.stopTest();
    }

    public static testMethod void testActivityServiceForRepository() {

        Blob response;

        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();

        INX.Activity obj = new INX.Activity();
        obj.action = 'added';
        obj.activityDate = System.now();
        obj.id = INX_Utility.getUUID();
        obj.message = 'repository {{action}}';
        obj.type = 'repository';
        obj.repository = 'SFDC';
        obj.email = 'abc@xyz.com';
        obj.closeBranch = false;

        obj.repositoryInfo = new INX.Repository();
        obj.repositoryInfo.id = INX_Utility.getUUID();
        obj.repositoryInfo.name = 'SFDC';
        obj.repositoryInfo.isActive = true;

        req.resourcePath = '/services/apexrest/infinit/v1/activity';
        req.httpMethod = 'POST';
        req.requestBody = Blob.valueOf(JSON.serialize(obj, true));

        RestContext.request = req;
        RestContext.response = res;

        Test.startTest();

            INX_ActivityService.doPost();

            req.resourcePath = '/services/apexrest/infinit/v1/activity/' + obj.id;
            req.requestURI = '/services/apexrest/infinit/v1/activity/' + obj.id;
            req.httpMethod = 'GET';

            INX_ActivityService.doGet();

        Test.stopTest();
    }

    public static testMethod void testActivityServiceForDeployment() {

        Blob response;

        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();

        INX_Instance__c sObjInstance = new INX_Instance__c(
            Name = 'QA',
            INX_Id__c = INX_Utility.getUUID()
        );
        insert sObjInstance;

        INX_Package__c sObjPackage = new INX_Package__c(
            Name = 'CRM-1',
            INX_Id__c = INX_Utility.getUUID(),
            INX_Instance__c = sObjInstance.Id
        );
        insert sObjPackage;

        INX_Access__c sObjAccess = new INX_Access__c(
            INX_Email__c = 'abc@xyz.com',
            INX_Can_Manage__c = false,
            INX_Id__c = 'abc@xyz.com'
        );
        insert sObjAccess;

        sObjAccess = new INX_Access__c(
            INX_Email__c = 'abc@xyz.com',
            INX_Instance__c = sObjInstance.Id,
            INX_Can_Read__c = true,
            INX_Id__c = 'abc@xyz.com-QA'
        );
        insert sObjAccess;

        INX.Activity obj = new INX.Activity();
        obj.action = 'created';
        obj.activityDate = System.now();
        obj.id = INX_Utility.getUUID();
        obj.message = '{{subType}} deployment plan {{action}} for instance #{{instance}}';
        obj.type = 'deployment';
        obj.subType = 'package';
        obj.name = 'CRM-1';
        obj.instance = 'QA';
        obj.email = 'abc@xyz.com';
        obj.closeBranch = false;

        obj.deploymentInfo = new INX.Deployment();
        obj.deploymentInfo.id = INX_Utility.getUUID();
        obj.deploymentInfo.name = 'CRM-1';
        obj.deploymentInfo.instance = 'QA';
        obj.deploymentInfo.type = 'package';

        obj.deploymentInfo.deploymentDetails = new INX.DeploymentDetails();

        req.resourcePath = '/services/apexrest/infinit/v1/activity';
        req.httpMethod = 'POST';
        req.requestBody = Blob.valueOf(JSON.serialize(obj, true));

        RestContext.request = req;
        RestContext.response = res;

        Test.startTest();

            INX_ActivityService.doPost();

            req.resourcePath = '/services/apexrest/infinit/v1/activity/' + obj.id;
            req.requestURI = '/services/apexrest/infinit/v1/activity/' + obj.id;
            req.httpMethod = 'GET';

            INX_ActivityService.doGet();

            obj.action = 'deployment succeeded';
            obj.activityDate = System.now();
            obj.id = INX_Utility.getUUID();
            obj.message = '{{subType}} {{action}} for instance #{{instance}}, sourced from #{{source}}';

            req.resourcePath = '/services/apexrest/infinit/v1/activity';
            req.httpMethod = 'POST';
            req.requestBody = Blob.valueOf(JSON.serialize(obj, true));

            INX_ActivityService.doPost();

            req.resourcePath = '/services/apexrest/infinit/v1/activity/' + obj.id;
            req.requestURI = '/services/apexrest/infinit/v1/activity/' + obj.id;
            req.httpMethod = 'GET';

            INX_ActivityService.doGet();

            req.resourcePath = '/services/apexrest/infinit/v1/activity';
            req.requestURI = '/services/apexrest/infinit/v1/activity';
            req.httpMethod = 'GET';
            req.addParameter('email', 'abc@xyz.com');
            req.addParameter('afterId', obj.id);

            INX_ActivityService.doGet();

        Test.stopTest();
    }

    public static testMethod void testActivityServiceForReview() {

        Blob response;

        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();

        INX_Repository__c sObj = new INX_Repository__c(
            Name = 'SFDC',
            INX_Id__c = INX_Utility.getUUID()
        );
        insert sObj;

        INX.Activity obj = new INX.Activity();
        obj.action = 'approved';
        obj.activityDate = System.now();
        obj.id = INX_Utility.getUUID();
        obj.message = 'commit {{action}}';
        obj.type = 'review';
        obj.subType = 'package';
        obj.name = 'CRM-1';
        obj.repository = 'SFDC';
        obj.email = 'abc@xyz.com';
        obj.hash = INX_Utility.getUUID();
        obj.closeBranch = false;

        req.resourcePath = '/services/apexrest/infinit/v1/activity';
        req.httpMethod = 'POST';
        req.requestBody = Blob.valueOf(JSON.serialize(obj, true));

        RestContext.request = req;
        RestContext.response = res;

        Test.startTest();

            INX_ActivityService.doPost();

            req.resourcePath = '/services/apexrest/infinit/v1/activity/' + obj.id;
            req.requestURI = '/services/apexrest/infinit/v1/activity/' + obj.id;
            req.httpMethod = 'GET';

            INX_ActivityService.doGet();

        Test.stopTest();
    }

    public static testMethod void testActivityServiceForResolution() {

        Blob response;

        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();

        INX_Repository__c sObj = new INX_Repository__c(
            Name = 'SFDC',
            INX_Id__c = INX_Utility.getUUID()
        );
        insert sObj;

        INX.Activity obj = new INX.Activity();
        obj.action = 'created';
        obj.activityDate = System.now();
        obj.id = INX_Utility.getUUID();
        obj.message = 'resolution {{action}} for src/classes/xyz.cls';
        obj.type = 'resolution';
        obj.repository = 'SFDC';
        obj.email = 'abc@xyz.com';
        obj.hash = INX_Utility.getUUID();
        obj.closeBranch = false;

        obj.resolutionInfo = new INX.Resolution();
        obj.resolutionInfo.id = obj.repository + '-' + obj.hash;
        obj.resolutionInfo.hash = obj.hash;
        obj.resolutionInfo.repository = obj.repository;
        obj.resolutionInfo.email = obj.email;
        obj.resolutionInfo.filePath = 'src/classes/xyz.cls';

        req.resourcePath = '/services/apexrest/infinit/v1/activity';
        req.httpMethod = 'POST';
        req.requestBody = Blob.valueOf(JSON.serialize(obj, true));

        RestContext.request = req;
        RestContext.response = res;

        Test.startTest();

            INX_ActivityService.doPost();

            req.resourcePath = '/services/apexrest/infinit/v1/activity/' + obj.id;
            req.requestURI = '/services/apexrest/infinit/v1/activity/' + obj.id;
            req.httpMethod = 'GET';

            INX_ActivityService.doGet();

        Test.stopTest();
    }
}