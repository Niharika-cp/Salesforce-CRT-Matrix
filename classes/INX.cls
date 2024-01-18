public inherited sharing class INX {

    public static final Map<String, String> TABLEMAPPING = new Map<String, String> {
        'instance' => 'INX_Instance__c',
        'package' => 'INX_Package__c',
        'repository' => 'INX_Repository__c',
        'tag' => 'INX_Tag__c',
        'deployment' => 'INX_Deployment__c'
    };

    public enum AccessType { CANREAD, CANCOMMIT, CANPROMTE, CANDEPLOY, CANMANAGE }

    public class About {

        public String application = 'Infinit - track. build. compare.';
    }

    public class Activity {

        public String action;
        public Datetime activityDate;
        public String branch;
        public Boolean closeBranch;
        public String email;
        public String hash;
        public String id;
        public String instance;
        public String message;
        public String name;
	    public Boolean needsReview;
	    public String packageDirectory;
        public String remoteId;
        public String repository;
	    public String resolution;
        public String source;
        public String sourceBranch;
        public String subType;
        public String type;
        public Instance instanceInfo;
        public PackageInfo packageInfo;
        public Repository repositoryInfo;
        public Deployment deploymentInfo;
        public Tag tagInfo;
        public Resolution resolutionInfo;

        public Activity() { }

        public Activity(INX_Activity__c sObj) {

            this.action = sObj.INX_Action__c;
            this.activityDate = Datetime.newInstance((Long) sObj.INX_Activity_Timestamp__c);
            this.branch = sObj.INX_Branch__c;
            this.closeBranch = sObj.INX_Close_Branch__c;
            this.email = sObj.INX_Email__c;
            this.hash = sObj.INX_Hash__c;
            this.id = sObj.INX_Id__c;
            this.instance = sObj.INX_Instance__r.Name;
            this.message = sObj.INX_Message__c;
            this.name = sObj.INX_Name__c;
            this.needsReview = sObj.INX_Needs_Review__c;
            this.packageDirectory = sObj.INX_Package_Directory__c;
            this.remoteId = sObj.Id;
            this.repository = sObj.INX_Repository__r.Name;
            this.resolution = sObj.INX_Resolution__c;
            this.source = sObj.INX_Source__c;
            this.sourceBranch = sObj.INX_Source_Branch__c;
            this.subType = sObj.INX_Sub_Type__c;
            this.type = sObj.INX_Type__c;
        }

        public INX_Activity__c getSObject() {

            INX_Activity__c sObj = new INX_Activity__c();
            sObj.INX_Action__c = this.action;
            sObj.INX_Activity_Date__c = this.activityDate;
            sObj.INX_Activity_Timestamp__c = this.activityDate.getTime();
            sObj.INX_Branch__c = this.branch;
            sObj.INX_Close_Branch__c = this.closeBranch;
            sObj.INX_Email__c = this.email;
            sObj.INX_Hash__c = this.hash;
            sObj.INX_Id__c = this.id;
            sObj.INX_Message__c = this.message;
            sObj.INX_Name__c = this.name;
            sObj.INX_Needs_Review__c = this.needsReview;
            sObj.INX_Package_Directory__c = this.packageDirectory;
            sObj.INX_Resolution__c = this.resolution;
            sObj.INX_Source__c = this.source;
            sObj.INX_Source_Branch__c = this.sourceBranch;
            sObj.INX_Sub_Type__c = this.subType;
            sObj.INX_Type__c = this.type;
            sObj.Name = this.id;
            return sObj;
        }

        public INX_ActivityEvent__e getEvent() {

            INX_ActivityEvent__e sObj = new INX_ActivityEvent__e();
            sObj.INX_Action__c = this.action;
            sObj.INX_Activity_Timestamp__c = this.activityDate.getTime();
            sObj.INX_Branch__c = this.branch;
            sObj.INX_Close_Branch__c = this.closeBranch;
            sObj.INX_Email__c = this.email;
            sObj.INX_Hash__c = this.hash;
            sObj.INX_Id__c = this.id;
            sObj.INX_Message__c = this.message;
            sObj.INX_Name__c = this.name;
            sObj.INX_Needs_Review__c = this.needsReview;
            sObj.INX_Package_Directory__c = this.packageDirectory;
            sObj.INX_Resolution__c = this.resolution;
            sObj.INX_Source__c = this.source;
            sObj.INX_Source_Branch__c = this.sourceBranch;
            sObj.INX_Sub_Type__c = this.subType;
            sObj.INX_Type__c = this.type;
            return sObj;
        }
    }

    public class Instance {

        public String id;
        public String remoteId;
        public String name;
        public String endPoint;
        public String username;
        public String orgId;
        public String version;
        public String credentials;
        public Boolean shareCredentials;
        public String parent;
        public String repository;
        public String branch;
        public Boolean isActive;
        public String deploymentSettingsJSON;
        public String promoteSettingsJSON;
        public String jiraSettingsJSON;

        public Instance() { }

        public Instance(INX_Instance__c sObj) {

            this.endPoint = sObj.INX_Endpoint__c;
            this.username = sObj.INX_Username__c;
            this.id = sObj.INX_Id__c;
            this.remoteId = sObj.Id;
            this.isActive = sObj.INX_Is_Active__c;
            this.orgId = sObj.INX_OrgId__c;
            this.name = sObj.Name;
            this.version = sObj.INX_Version__c;
            this.credentials = sObj.INX_Credentials__c;
            this.shareCredentials = sObj.INX_Share_Credentials__c;
            this.parent = sObj.INX_Parent__r.Name;
            this.repository = sObj.INX_Repository__r.Name;
            this.branch = sObj.INX_Branch__c;
            this.deploymentSettingsJSON = sObj.INX_Deployment_Settings__c;
            this.promoteSettingsJSON = sObj.INX_Promote_Settings__c;
            this.jiraSettingsJSON = sObj.INX_Jira_Settings__c;
        }

        public INX_Instance__c getSObject() {

            INX_Instance__c sObj = new INX_Instance__c();
            sObj.INX_Endpoint__c = this.endPoint;
            sObj.INX_Username__c = this.username;
            sObj.INX_Id__c = this.id;
            sObj.INX_OrgId__c = this.orgId;
            sObj.Name = this.name;
            sObj.INX_Version__c = this.version;
            sObj.INX_Credentials__c = this.credentials;
            sObj.INX_Share_Credentials__c = this.shareCredentials;
            sObj.INX_Branch__c = this.branch;
            sObj.INX_Is_Active__c = this.isActive;
            sObj.INX_Deployment_Settings__c = this.deploymentSettingsJSON;
            sObj.INX_Promote_Settings__c = this.promoteSettingsJSON;
            sObj.INX_Jira_Settings__c = this.jiraSettingsJSON;
            return sObj;
        }
    }

    public class Repository {

        public String id;
        public String remote;
        public String remoteId;
        public String origin;
        public String needsReview;
        public String mainBranch;
        public String name;
        public String sourcePath;
        public String format;
        public Boolean isActive;

        public Repository() { }

        public Repository(INX_Repository__c sObj) {

            this.id = sObj.INX_Id__c;
            this.remote = sObj.INX_Remote__c;
            this.remoteId = sObj.Id;
            this.name = sObj.Name;
            this.sourcePath = sObj.INX_Source_Path__c;
            this.origin = sObj.INX_Origin__c;
            this.needsReview = sObj.INX_Needs_Review__c;
            this.mainBranch = sObj.INX_Main_Branch__c;
            this.format = sObj.INX_Format__c;
            this.isActive = sObj.INX_Is_Active__c;
        }

        public INX_Repository__c getSObject() {

            INX_Repository__c sObj = new INX_Repository__c();
            sObj.INX_Id__c = this.id;
            sObj.INX_Is_Active__c = this.isActive;
            sObj.INX_Remote__c = this.remote;
            sObj.INX_Main_Branch__c = this.mainBranch;
            sObj.INX_Origin__c = this.origin;
            sObj.INX_Needs_Review__c = this.needsReview;
            sObj.INX_Source_Path__c = this.sourcePath;
            sObj.INX_Format__c = this.format;
            sObj.Name = this.name;
            return sObj;
        }
    }

    public class Review {

        public String id;
        public String remoteId;
        public String hash;
        public String repository;
        public String email;
        public String status;

        public Review() { }

        public Review(INX_Review__c sObj) {

            this.id = sObj.INX_Id__c;
            this.hash = sObj.INX_Hash__c;
            this.repository = sObj.INX_Repository__r.Name;
            this.email = sObj.INX_Email__c;
            this.status = sObj.INX_Status__c;
        }

        public Review(Activity objActivity) {

            this.id = objActivity.repository + '-' + objActivity.hash;
            this.hash = objActivity.hash;
            this.repository = objActivity.repository;
            this.email = objActivity.email;
            this.status = 'approved'.equals(objActivity.action) ? 'APPROVED' : 'NEEDSWORK';
        }

        public INX_Review__c getSObject() {

            INX_Review__c sObj = new INX_Review__c();
            sObj.INX_Id__c = this.id;
            sObj.INX_Hash__c = this.hash;
            sObj.INX_Email__c = this.email;
            sObj.INX_Status__c = this.status;
            return sObj;
        }
    }

    public class Resolution {

        public String id;
        public String remoteId;
        public String hash;
        public String repository;
        public String email;
        public String filePath;
        public Hunk hunkDetails;

        public Resolution() { }

        public Resolution(INX_Resolution__c sObj) {

            this.id = sObj.INX_Id__c;
            this.hash = sObj.INX_Hash__c;
            this.repository = sObj.INX_Repository__r.Name;
            this.email = sObj.INX_Email__c;
            this.filePath = sObj.INX_File_Path__c;
        }

        public INX_Resolution__c getSObject() {

            INX_Resolution__c sObj = new INX_Resolution__c();
            sObj.INX_Id__c = this.id;
            sObj.INX_Hash__c = this.hash;
            sObj.INX_Email__c = this.email;
            sObj.INX_File_Path__c = this.filePath;
            return sObj;
        }
    }

    public class Access {

        public String email;
        public String instance;
        public Boolean canRead;
        public Boolean canCommit;
        public Boolean canPromote;
        public Boolean canDeploy;
        public Boolean canManage;
        public Boolean isLocked;

        public Access() { }

        public Access(INX_Access__c sObj) {

            this.email = sObj.INX_Email__c;
            this.instance = sObj.INX_Instance__c;
            this.canRead = sObj.INX_Can_Read__c;
            this.canCommit = sObj.INX_Can_Commit__c;
            this.canPromote = sObj.INX_Can_Promote__c;
            this.canDeploy = sObj.INX_Can_Deploy__c;
            this.canManage = sObj.INX_Can_Manage__c;
            this.isLocked = sObj.INX_Is_Locked__c;
        }

        public INX_Access__c getSObject() {

            INX_Access__c sObj = new INX_Access__c();
            sObj.INX_Email__c = this.email;
            sObj.INX_Instance__c = this.instance;
            sObj.INX_Can_Read__c = this.canRead;
            sObj.INX_Can_Commit__c = this.canCommit;
            sObj.INX_Can_Promote__c = this.canPromote;
            sObj.INX_Can_Deploy__c = this.canDeploy;
            sObj.INX_Can_Manage__c = this.canManage;
            sObj.INX_Id__c = (String.isBlank(this.instance) ? this.email : (this.email + '-' + this.instance));
            return sObj;
        }
    }

    public class PackageInfo implements Comparable {

        public DateTime createdDate;
        public String description;
        public String id;
        public String remoteId;
        public String instance;
        public DateTime lastModifiedDate;
        public String name;
        public String version;
        public Boolean isPost;
        public PackageWrapper packageDetails;

        public PackageInfo() { }

        public PackageInfo(INX.Activity obj) {

            this.name = obj.source;
            this.isPost = 'added (post deployment)'.equals(obj.action) ? true : false;
        }

        public PackageInfo(INX_Package__c sObj) {

            this.createdDate = sObj.INX_Created_Date__c;
            this.description = sObj.INX_Description__c;
            this.id = sObj.INX_Id__c;
            this.remoteId = sObj.Id;
            this.instance = sObj.INX_Instance__r.Name;
            this.lastModifiedDate = sObj.INX_Last_Modified_Date__c;
            this.name = sObj.Name;
            this.version = sObj.INX_Version__c;
        }

        public INX_Package__c getSObject() {

            INX_Package__c sObj = new INX_Package__c();
            sObj.INX_Created_Date__c = this.createdDate;
            sObj.INX_Description__c = this.description;
            sObj.INX_Id__c = this.id;
            sObj.INX_Last_Modified_Date__c = this.lastModifiedDate;
            sObj.Name = this.name;
            sObj.INX_Version__c = this.version;
            return sObj;
        }

        public Integer compareTo(Object compareTo) {

            PackageInfo compareToPackage = (PackageInfo) compareTo;

            return this.name.compareTo(compareToPackage.name);
        }
    }

    public class Tag {

        public DateTime createdDate;
        public String description;
        public String id;
        public String remoteId;
        public String instance;
        public DateTime lastModifiedDate;
        public String name;
        public String version;
        public TagLink[] links;

        public Tag() { }

        public Tag(INX_Tag__c sObj) {

            this.createdDate = sObj.INX_Created_Date__c;
            this.description = sObj.INX_Description__c;
            this.id = sObj.INX_Id__c;
            this.remoteId = sObj.Id;
            this.instance = sObj.INX_Instance__r.Name;
            this.lastModifiedDate = sObj.INX_Last_Modified_Date__c;
            this.name = sObj.Name;
            this.version = sObj.INX_Version__c;
        }

        public INX_Tag__c getSObject() {

            INX_Tag__c sObj = new INX_Tag__c();
            sObj.INX_Created_Date__c = this.createdDate;
            sObj.INX_Description__c = this.description;
            sObj.INX_Id__c = this.id;
            sObj.INX_Last_Modified_Date__c = this.lastModifiedDate;
            sObj.Name = this.name;
            sObj.INX_Version__c = this.version;
            return sObj;
        }
    }

    public class TagLink {

        public String id;
        public String remoteId;
        public String tag;
        public String tagName;
        public String packageName;
        public DateTime createdDate;

        public TagLink() { }

        public TagLink(INX_Tag_Link__c sObj) {

            this.id = sObj.INX_Id__c;
            this.remoteId = sObj.Id;
            this.tag = sObj.INX_Tag__r.Name;
            this.packageName = sObj.INX_Package__r.Name;
            this.createdDate = sObj.INX_Created_Date__c;
        }

        public INX_Tag_Link__c getSObject() {

            INX_Tag_Link__c sObj = new INX_Tag_Link__c();
            sObj.Id = this.remoteId;
            sObj.INX_Id__c = this.id;
            sObj.INX_Created_Date__c = this.createdDate;
            return sObj;
        }
    }

    public class Deployment {

        public DateTime createdDate;
        public String id;
        public String remoteId;
        public String instance;
        public DateTime lastModifiedDate;
        public String name;
        public String type;
        public DeploymentDetails deploymentDetails;
        public String[] attachments;

        public Deployment() { }

        public Deployment(INX_Deployment__c sObj) {

            this.createdDate = sObj.INX_Created_Date__c;
            this.id = sObj.INX_Id__c;
            this.remoteId = sObj.Id;
            this.instance = sObj.INX_Instance__r.Name;
            this.lastModifiedDate = sObj.INX_Last_Modified_Date__c;
            this.name = sObj.Name;
            this.type = sObj.INX_Type__c;
        }

        public INX_Deployment__c getSObject() {

            INX_Deployment__c sObj = new INX_Deployment__c();
            sObj.INX_Created_Date__c = this.createdDate;
            sObj.INX_Id__c = this.id;
            sObj.INX_Last_Modified_Date__c = this.lastModifiedDate;
            sObj.Name = this.name;
            sObj.INX_Type__c = this.type;
            return sObj;
        }
    }

    public class DeploymentDetails {

        public Boolean ignoreWarnings;
        public Boolean purgeOnDelete;
        public Boolean rollbackOnError;
        public Boolean allowMissingFiles;
        public Boolean autoUpdatePackage;
        public String testLevel;
        public Boolean allOrNone;
        public String[] runTests;
	    public Boolean reviewRequired;
	    public Boolean autoBackPromote;
	    public Boolean skipDeployment;
	    public Boolean isRestricted;
    }

    public class PackageWrapper {

        public TypesWrapper[] types;
        public TypesWrapper[] destructivePre;
        public TypesWrapper[] destructive;
        public Permission[] permissions;
        public QueryModel[] queriesPre;
        public QueryModel[] queries;
        public ApexScript[] scriptsPre;
        public ApexScript[] scripts;
        public ManualTask[] tasksPre;
        public ManualTask[] tasks;
        public String version;
    }

    public class Hunk {

        public List<Change> leading;
        public List<List<Change>> trailing;
        public List<List<Change>> conflicts;
        public List<Change> patch;
        public String hash;
        public String filePath;
    }

    public class Change {

        public String content;
        public Boolean add;
        public Boolean del;
    }

    public class TypesWrapper {

        public String name;
        public String parent;
        public String directory;
        public Boolean hasFolders;
        public Boolean metaFile;
        public String suffix;
        public TypesWrapper parentType;
        public ComponentWrapper[] members;
    }

    public class ComponentWrapper {

        public String fileName;
        public String fullName;
        public String namespacePrefix;
        public String type;
	    public Boolean manuallyAdded;
    }

    public class Permission {

        public String name;
        public String member;
        public String section;
        public String part;
        public String source;
        public String target;
        public Boolean isMissingTarget;
        public Boolean isMissingSource;
    }

    public class QueryModel {

        public String fullName;
        public String id;
        public String name;
        public String label;
        public String externalId;
        public CustomField[] fields;
        public ChildRelationships[] related;
        public String clause;
        public String operation;
        public Integer batchSize;
        public Integer x;
        public Integer y;
    }

    public class ApexScript {

        public String title;
        public String content;
    }

    public class ManualTask {

        public String title;
        public String content;

    }

    public class CustomField {

        public String name;
        public String label;
        public String type;
        public String defaultValue;
        public String inlineHelpText;
        public Boolean custom;
        public String[] referenceTo;
        public Boolean calculated;
        public Boolean externalId;
        public Boolean pullRelated;
        public Boolean locked;
        public String unique;
        public Boolean createable;
        public Boolean updateable;
        public Boolean maskData;
        public Boolean encryptData;
        public Boolean addAlias;
        public Boolean scrambleData;
        public Boolean skipComparison;
        public Boolean ignore;
        public String referenceField;
        public String referenceObject;
        public Integer order;
        public QueryModel query;
    }

    public class ChildRelationships {

        public String childSObject;
        public String field;
        public String externalId;
        public Boolean locked;
        public Integer order;
        public QueryModel query;
    }

    public class Error {

        public Integer errorCode;
        public String message;

        public Error(Integer errorCode, string message) {
            this.errorCode = errorCode;
            this.message = message;
        }
    }

    public class ApplicationException extends Exception {

        public Integer errorCode;

        public ApplicationException(Integer errorCode, String error) {
            setMessage(error);
            this.errorCode = errorCode;
        }

        public ApplicationException(Integer errorCode, String error, Exception ex) {
            setMessage(error);
            this.errorCode = errorCode;
            this.initCause(ex);
        }
    }

    public class ActivityResponse {

        public Activity[] activities;
        public Integer size;
    }

    public class AccessResponse {

        public Access[] accesses;
        public Long lastModifiedDate;
    }

    public class AttachmentDetails {

        public Object obj;
        public String json;
        public String name;
        public String description;

        public AttachmentDetails(Object obj, String strName, String strDescription) {

            this.obj = obj;
            this.name = strName;
            this.description = strDescription;
        }

        public AttachmentDetails(String strName) {

            this.name = strName;
        }
    }

    public static INX_Access__c getCanManageAccessSettings() {

        INX_Access__c sObj = new INX_Access__c();
        sObj.INX_Can_Read__c = true;
        sObj.INX_Can_Commit__c = true;
        sObj.INX_Can_Promote__c = true;
        sObj.INX_Can_Deploy__c = true;
        sObj.INX_Can_Manage__c = true;
        sObj.INX_Is_Locked__c = true;
        return sObj;
    }

    public static INX_Access__c getNoAccessSettings() {

        INX_Access__c sObj = new INX_Access__c();
        sObj.INX_Can_Read__c = false;
        sObj.INX_Can_Commit__c = false;
        sObj.INX_Can_Promote__c = false;
        sObj.INX_Can_Deploy__c = false;
        sObj.INX_Can_Manage__c = false;
        return sObj;
    }

    public static List<Access> getSObjectList(List<INX_Access__c> lstSObject) {

        List<Access> lstAccess = new List<Access>();
        for(INX_Access__c sObj : lstSObject) {
            lstAccess.add(new Access(sObj));
        }
        return lstAccess;
    }

    public static List<Activity> getSObjectList(List<INX_Activity__c> lstSObject) {

        List<Activity> lstActivity = new List<Activity>();
        for(INX_Activity__c sObj : lstSObject) {
            lstActivity.add(new Activity(sObj));
        }
        return lstActivity;
    }
}