/* @AuraEnabled(cacheable=true)
    public static List<Account> getAccounts(String searchKey, String sortBy, String sortDirection) {        
        String query = 'SELECT Id, Name,Phone,Type FROM Account';            
        if (String.isNotEmpty(searchKey)) {
            String key = '%' + searchKey + '%';
            query += ' WHERE Name LIKE :key';
        }
        if (String.isNotEmpty(sortBy) && String.isNotEmpty(sortDirection)){
            query += ' ORDER BY ' + sortBy + ' ' + sortDirection;
        }        
        return Database.query(query);
    }
   @AuraEnabled public static Map<Id,ApexClass> allApexClass;{allApexClass = new Map<Id,ApexClass>();}

    @AuraEnabled(cacheable=true)
    public static List<sObject> getAccounts(String searchKey, String sortBy, String sortDirection){
        system.debug(' In Apex Controller');
        try {
                    string query = ' SELECT ApexTestClass.Name,TestMethodName,NumLinesCovered,NumLinesUncovered FROM ApexCodeCoverage ';
                    if (String.isNotEmpty(searchKey)) {
                        String key = '%' + searchKey + '%';
                        query += ' WHERE Name LIKE :key';
                    }
                    if (String.isNotEmpty(sortBy) && String.isNotEmpty(sortDirection)){
                        query += ' ORDER BY ' + sortBy + ' ' + sortDirection;
                    }   
                    system.debug(' In Apex Controller Query=====>>>'+Database.query(query));
                    return Database.query(query);

        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }
     
*/



public with sharing class DtestCoverageClass {
   

    public static Integer totalCodeCoverage {get; set;}
    static final String TOOLINGAPI_ENDPOINT;
    private static Set<Id> testClasses;{testClasses = new Set<Id>();}
    private static Map<Id,List<Id>> classTestClassMap;{classTestClassMap = new Map<Id,List<Id>>();}
    private static Map<Id,DateTime> lastModifiedMap;{lastModifiedMap = new Map<Id,DateTime>();}
    private static Map<Id,List<Object>> classCoveredLinesMap;{classCoveredLinesMap = new Map<Id,List<Object>>();}
    private static Map<Id,List<Object>> classUnCoveredLinesMap;{classUnCoveredLinesMap = new Map<Id,List<Object>>();}
    private static Map<Id,ApexClass> allApexClass;{allApexClass = new Map<Id,ApexClass>();}
    public static Map<String,List<ObjWrapper>> mapAll {get; set;} {mapAll=new Map<String,List<ObjWrapper>>();}
    static{
        
        TOOLINGAPI_ENDPOINT = 'https://cloudfulcrum--trnprod.sandbox.my.salesforce.com/services/data/v56.0/tooling/query/'; 
    }
    
    //Wrapper Class for showing Data
    public class ObjWrapper{
    @AuraEnabled    public string name{get; set;}
    @AuraEnabled    public id id{get; set;}
    @AuraEnabled    public string relatedObject{get; set;}
    @AuraEnabled    public Boolean isActive{get;set;}
    @AuraEnabled    public string description {get;set;}
    @AuraEnabled    public string errorMessage {get;set;}
    @AuraEnabled    public DateTime modifiedDate{get; set;}
    @AuraEnabled    public string elementType{get; set;}
    @AuraEnabled    public integer coveredLines{get; set;}
    @AuraEnabled    public integer unCoveredLines{get; set;}
    @AuraEnabled    public integer coveragePercent{get; set;}
    @AuraEnabled    public List<integer>  coveredLineList{get; set;}
    @AuraEnabled    public List<integer>  unCoveredLineList{get; set;}
    @AuraEnabled    public Boolean active{get; set;}
    @AuraEnabled   public Map<Id,String> testClassInfo{get; set;}
        ObjWrapper(string elementName,Id elementId, String obj, Map<String,Object> Metadata, String element, List<Object> cLines, List<Object> uLines,List<Id> tests,DateTime LastModDate){
            name = elementName;
            id = elementId;
            relatedObject = obj;
            if(Metadata!=null){
                isActive = (Boolean) Metadata.get('active');
                description = (String) Metadata.get('description');
                if (Metadata.get('errorMessage') != null)
                errorMessage = (String) Metadata.get('errorMessage');
            }
            elementType = element;
            if(cLines!=null){
                coveredLines = cLines.size();
            }
            if(uLines!=null){
                unCoveredLines = uLines.size();
            }
            if(cLines!=null && uLines!=null){
                if((coveredLines+unCoveredLines)!=0){
                    coveragePercent = coveredLines*100/(coveredLines+unCoveredLines);
                }
                else
                   coveragePercent = 0; 
            }
            else{
                coveragePercent = 0; 
                coveredLines = 0;
                unCoveredLines = 0;
            }
            if(tests!=null && tests.size()>0){
                if(testClassInfo==null){
                    testClassInfo=new Map<Id,String>() ;
                }
                for(Id testId: tests){
                    system.debug('@@allApexClass'+allApexClass+'@@testId'+tests);
                    testClassInfo.put(testId,allApexClass.get(testId).Name);
                }
            }
            modifiedDate = LastModDate;
        }
    }
    
    //Constructor
    @AuraEnabled
    public static void DtestCoverageClass(String searchKey, String sortBy, String sortDirection){
        system.debug('In DtestCoverageClass Class');
        mapAll.put('Apex Class',new List<ObjWrapper>());
        mapAll.put('Apex Trigger',new List<ObjWrapper>());
        
        allApexClass = new Map<Id,ApexClass>([SELECT Id,ApiVersion,IsValid,Status,Name FROM ApexClass Limit 1000]);

        getValuesAsMap(fetchCodeCoverage());
        getValuesAsMap(fetchCodeCoverageAggregate());
        getValuesAsMap(fetchWorkflow());
        getValuesAsMap(fetchValidationRule());
        getValuesAsMap(fetchOrgCoverage());
        
        
        for(ApexClass aClass: allApexClass.values()){
            if(!testClasses.contains(aClass.Id)){
                mapAll.get('Apex Class').add(new ObjWrapper(aClass.Name,aClass.Id,null,null,'Apex Class',classCoveredLinesMap.get(aClass.Id),classUnCoveredLinesMap.get(aClass.Id),classTestClassMap.get(aClass.Id),lastModifiedMap.get(aClass.Id)));
            }
        }
        for(ApexTrigger aTrigger: [SELECT Id,ApiVersion,IsValid,Status,Name,TableEnumOrId FROM ApexTrigger]){
            mapAll.get('Apex Trigger').add(new ObjWrapper(aTrigger.Name,aTrigger.Id,aTrigger.TableEnumOrId,null,'Apex Trigger',classCoveredLinesMap.get(aTrigger.Id),classUnCoveredLinesMap.get(aTrigger.Id),classTestClassMap.get(aTrigger.Id),lastModifiedMap.get(aTrigger.Id)));
        }

        string query;
        if (String.isNotEmpty(searchKey)) {
            String key = '%' + searchKey + '%';
            query += ' WHERE Name LIKE :key';
        }
        if (String.isNotEmpty(sortBy) && String.isNotEmpty(sortDirection)){
            query += ' ORDER BY ' + sortBy + ' ' + sortDirection;
        }   
    }


    @AuraEnabled(cacheable=true)
    public static String fetchCodeCoverage(){
        return sendToolingQueryRequest('SELECT+ApexTestClassId,ApexClassOrTriggerId+FROM+ApexCodeCoverage');
    }
    
    @AuraEnabled(cacheable=true)
    public static String fetchCodeCoverageAggregate(){
        return sendToolingQueryRequest('SELECT+ApexClassOrTriggerId,Coverage,LastModifiedDate+FROM+ApexCodeCoverageAggregate');
    }
    
    @AuraEnabled(cacheable=true)
    public static String fetchWorkflow(){
        return sendToolingQueryRequest('SELECT+FullName,Id,LastModifiedDate,Metadata,Name,NamespacePrefix,TableEnumOrId+FROM+WorkflowRule');
    }
    
    @AuraEnabled(cacheable=true)
    public static String fetchValidationRule(){
        return sendToolingQueryRequest('SELECT+FullName,Id,LastModifiedDate,Metadata,NamespacePrefix,TableEnumOrId,ValidationName+FROM+ValidationRule');
    }
    
    @AuraEnabled(cacheable=true)
    public static String fetchOrgCoverage(){  
        return sendToolingQueryRequest('SELECT+PercentCovered,LastModifiedDate+FROM+ApexOrgWideCoverage');
    }
    
    //Method to send query request to tooling api endpoint
    @AuraEnabled(cacheable=true)
    public static string sendToolingQueryRequest(String queryStr){
        HttpRequest req = new HttpRequest();
        req.setEndpoint(TOOLINGAPI_ENDPOINT+'query/?q='+queryStr);
        //Set authorization by using current users session Id
        req.setHeader('Authorization', 'Bearer ' + UserInfo.getSessionID());
        req.setHeader('Content-Type', 'application/json');        
        req.setMethod('GET');
        req.setTimeout(120000);
        Http http = new Http();
        HTTPResponse res = new HTTPResponse();
        
            res = http.send(req);
    
        if(res.getStatusCode() == 200){
            
            //String reqresponse = res.getBody().replace('{"size":124,"totalSize":124,"done":true,"queryLocator":null,"entityTypeName":"ApexClass","records":', '');
                 
            //system.debug('response===='+res.getBody());
            ObjWrapper objts = (ObjWrapper) JSON.deserialize(res.getbody() ,ObjWrapper.class);
            String str = objts.toString();
                 //system.debug('disp==========='+objts);
             return str;
             }
             else {
                 system.debug(res.getStatus());
                 system.debug(res.getStatusCode());
                 return null;
             }
    }
    
    //For Fetching Data from converted object
    @AuraEnabled(cacheable=true) 
    public static void prepareElement(Map<String,Object> mapObj,String entity){
        if(entity == 'ApexCodeCoverageAggregate'){
            Id elementId = String.valueOf(mapObj.get('ApexClassOrTriggerId')); 
            String lastDateString = String.valueOf(mapObj.get('LastModifiedDate')).substring(0,19).replace('T',' '); 
            DateTime lastDate = DateTime.valueOf(lastDateString);
            lastModifiedMap.put(elementId,lastDate);
            Map<String,Object> coverageObj = (MAP<String,Object>) mapObj.get('Coverage');
            List<Object> covered = (List<Object>)coverageObj.get('coveredLines');
            List<Object> unCovered = (List<Object>)coverageObj.get('uncoveredLines');

            system.debug('@@covered'+covered.size()+'@@unCovered'+unCovered.size());
            system.debug('@@covered'+covered+'@@unCovered'+unCovered);
            if(classCoveredLinesMap.get(elementId)==null){
                classCoveredLinesMap.put(elementId, covered);
            }
            
            if(classUnCoveredLinesMap.get(elementId)==null){
                classUnCoveredLinesMap.put(elementId, unCovered);
            }
        }
        else if(entity == 'ApexCodeCoverage'){
            Id testClassId = String.valueOf(mapObj.get('ApexTestClassId'));
            testClasses.add(testClassId);
            Id elementId = String.valueOf(mapObj.get('ApexClassOrTriggerId')); 
            if(classTestClassMap.get(elementId)==null){
                List<Id> idList= new List<Id>();
                classTestClassMap.put(elementId, idList);
                classTestClassMap.get(elementId).add(testClassId);
            }
            else{
                classTestClassMap.get(elementId).add(testClassId);
            }
        }
        else if(entity == 'WorkflowRule' ){
            Id elementId = String.valueOf(mapObj.get('Id')); 
            String obj = String.valueOf(mapObj.get('TableEnumOrId')); 
            String label = String.valueOf(mapObj.get('Name')); 
            Map<String,Object> meta = (Map<String,Object>) mapObj.get('Metadata');
            if(mapAll.get('WorkflowRule')==null){
                List<ObjWrapper> oWrap = new List<ObjWrapper>();
                oWrap.add(new ObjWrapper(label,elementId,geLabel(obj),meta,entity,null,null,null,null));
                mapAll.put('WorkflowRule', oWrap);
            }
            else{
                mapAll.get('WorkflowRule').add(new ObjWrapper(label,elementId,geLabel(obj),meta,entity,null,null,null,null));
            }
        } 
        else if(entity == 'ValidationFormula'){
            Id elementId = String.valueOf(mapObj.get('Id')); 
            String obj = String.valueOf(mapObj.get('TableEnumOrId'));
            String label = String.valueOf(mapObj.get('ValidationName')); 
            Map<String,Object> meta = (Map<String,Object>) mapObj.get('Metadata');
            
            if(entity == 'ValidationFormula'){
                if(mapAll.get('ValidationFormula')==null){
                    List<ObjWrapper> oWrap = new List<ObjWrapper>();
                    oWrap.add(new ObjWrapper(label,elementId,obj,meta,entity,null,null,null,null));
                    mapAll.put('ValidationFormula', oWrap);
                }
                else{
                    mapAll.get('ValidationFormula').add(new ObjWrapper(label,elementId,obj,meta,entity,null,null,null,null));
                }
            }
        }      
    }
    
    @TestVisible public static string geLabel (String name) {
        Map<String,Schema.SObjectType> globalDescribe = Schema.getGlobalDescribe(); 
        system.debug('@@globalDescribe '+globalDescribe );
        Schema.SObjectType objType = globalDescribe.get(name); 
        system.debug('@@objType '+objType );
        Schema.DescribeSObjectResult objDescribe = objType.getDescribe();   
        system.debug('@@objDescribe '+objDescribe );    
        String objLabel = objDescribe.getLabel();   
        system.debug('@@objLabel '+objLabel );
        return objLabel; 
    }
    
    //Method to convert JSON to Object to populate Wrapper List
    @TestVisible public static void getValuesAsMap(String jStr){
        if(String.isBlank(jStr))
            return;
        //Convert to Map
        system.debug('@@jStr'+jStr);
        Map<String,Object> resultMap= (Map<String,Object>)JSON.deserializeUntyped(jStr);
        String entityType = (String)resultMap.get('entityTypeName');
        List<Object> resultRecords = (List<Object>)resultMap.get('records');
        if(entityType == 'ApexOrgWideCoverage'){
            Map<String,Object> obj = (Map<String,Object>)resultRecords[0];
            totalCodeCoverage = Integer.valueOf(obj.get('PercentCovered'));
            system.debug('@@totalCodeCoverage '+totalCodeCoverage );
        }
        else {
            for(Object obj : resultRecords){
                Map<String,Object> elementMap = (Map<String,Object>) obj;
                system.debug('@@elementMap'+elementMap);
                prepareElement(elementMap,entityType);
            }
        }
    }

}