public class SFDCCodeValidatorNew {

    public void tempfunction() {
        system.debug('############'+selectedCode);
        //return null;
    }

    //code coverage
    public Map<Id,List<Object>> classCoveredLinesMap;
    public Map<Id,List<Object>> classUnCoveredLinesMap;
    public static final String TOOLINGAPI_ENDPOINT;
    static{
        TOOLINGAPI_ENDPOINT = 'https://'+URL.getSalesforceBaseUrl().getHost().trim().split('\\.')[1]+'.salesforce.com/services/data/v32.0/tooling/'; 
    }
    public boolean showCodingStd{get;set;}
    public boolean showValidationResult{get;set;}
    public boolean showSelectedClassTrg{get;set;}
    public list<String> allStandards{get;set;}
    public string selectedCode{get;set;}  
    
    public list<CodeWrapper> allCodeWrapper{get;set;}
    public list<ClassTrigWrapper> allClassTrigWrapper{get;set;}
    public list<String> getCodeList(){
        list<String> codeNameList=new list<String>();
        for(ApexClass ac : [Select Name From ApexClass Limit 500]){
            codeNameList.add(ac.Name);
        }
        for(ApexTrigger at : [Select Name From ApexTrigger Limit 500]){
            codeNameList.add(at.Name);
        }
        return codeNameList;        
    }    
    public SFDCCodeValidatorNew(){        
        showCodingStd=true;
        allCodeWrapper=new list<CodeWrapper>();
        classCoveredLinesMap = new Map<Id,List<Object>>();
        classUnCoveredLinesMap = new Map<Id,List<Object>>();
        String codingStd='1. There shouldn\'t be any SOQL,DML,futute callout inside loop.'+'\n'+
        '2. System debug statements should be removed.'+'\n'+
        '3. Code coverage should be more than 75% for each component.'+'\n'+
        '4. Each object can have upto one trigger.'+'\n'+
        '5. Code should properly handles more than one record at a time'+'\n'+
        '6. Proper Exception Handling with user friendly error message'+'\n'+
        '7. Use the Limits Apex Methods to avoid hitting Governor Limits'+'\n'+
        '8. Use custome setting and custom label to avoid hardcoding in the Apex code'+'\n'+
        '9. Put recursive checks to avoid multiple calls to method in a trigger'+'\n'+
        '10. Avoid writing SOQL inside constructor'+'\n'+
        '11. Use Database Methods with exception handling in DML operations'+'\n'+
        '12. Use Limit with SOQL Query'+'\n'+
        '13. Use utility class to write common method and trigger code'+'\n'+
        '14. Avoid writing multiple return statement in a method'+'\n'+
        '15. Avoid writing soql for RecordType & Email Template. Use Dynamic Apex to retrieve the same'+'\n'+
        '16. Use collections and streamlining SOQL queries to avoid hitting governor limits.';
        allStandards = new list<String>();
        allStandards = codingStd.split('\n');        
        
    }
    public void validateCode(){
        showCodingStd=false;
        showValidationResult=true;
        showSelectedClassTrg=true;
        getValuesAsMap(fetchCodeCoverageAggregate());
        allClassTrigWrapper=new list<ClassTrigWrapper>();
        set<String> allcodeName=new set<String>();
        
        if(allCodeWrapper!=null && !allCodeWrapper.isEmpty()){
            for(CodeWrapper each:allCodeWrapper){
               if(each.codeName!=null && each.codeName!=''){
                   allcodeName.add(each.codeName);
               }
            }        
        }
        list<sObject> allCodes=new list<sObject>();
        if(allcodeName!=null && !allcodeName.isEmpty()){
            for(ApexClass eachClass:[Select Id,Name,IsValid,Status,Body From ApexClass WHERE Name IN:allcodeName  Limit 400]){
                allCodes.add((sObject)eachClass);    
            }
            for(ApexTrigger eachTgr:[Select Id,Name,IsValid,Status,Body From ApexTrigger WHERE Name IN: allcodeName Limit 400]){
                allCodes.add((sObject)eachTgr);    
            } 
        }
        
        if(allCodes!=null && !allCodes.isEmpty()){
            for(sObject eObj:allCodes){
                string codeBody=(string)eObj.get('Body');
                list<String> bodyParts=new list<String>();
                
                //spliting by lines
                bodyParts=codeBody.split('\n');
                //Counting SOQL,SOQL without Limit & hardcodings
                Integer soqlcounter=0;
                Integer soqllimitCounter=0;
                Integer hardCodCount=0;
                
                //Soql,hardcodingings and debug Counter***********************************
                for(String part:bodyParts){
                    if(part!=null && part.contains('\'') && !part.contains('system.debug') ){
                        for(string quotep:part.split('\'')){
                            hardCodCount=hardCodCount+1;
                        }
                        hardCodCount=hardCodCount-1;                        
                    }
                    if(part!=null && (part.contains(' FROM ') || part.contains(' from ') || part.contains(' From '))){
                        if(part.contains(' Limit') || part.contains(' limit') || part.contains(' LIMIT')){
                            soqllimitCounter=soqllimitCounter+1;        
                        }
                        soqlcounter=soqlcounter+1;
                    }       
                }
                //getting code coverage***********************
                string codeCvg='';
                if(classUnCoveredLinesMap.get((Id)eObj.get('Id')).size()>0){
                    codeCvg=String.ValueOf(classCoveredLinesMap.get((Id)eObj.get('Id')).size()/(classCoveredLinesMap.get((Id)eObj.get('Id')).size()+classUnCoveredLinesMap.get((Id)eObj.get('Id')).size()))+'';
                }
                else{
                    codeCvg='0';
                }
                
                //Finging SOQL,DML,Future inside loop****************
                list<integer> forIndex=new list<integer>(); 
                Integer fCount=0;
                for(string eBody:bodyParts){
                    
                    if(eBody.contains('for (') || eBody.contains('for(')){
                    forIndex.add(fCount);   
                    }
                    fCount++;

                }
                Integer soqlInsideFor=0;
                Integer dmlInsideFor=0;
                Integer futureInsideFor=0;
                for(Integer eachFor:forIndex){
                    string initialString=bodyParts[eachFor]+'\n'+bodyParts[eachFor+1];
                    Integer startF=codeBody.IndexOf(initialString);
                    system.debug('@@@@@@@@startF'+startF);
                    Integer openBrkt=0;
                    Integer closeBrkt=0;
                    Integer closingbrktIndex=0;
                    for(Integer i=startF;i>0;i++){
                        if(codeBody.substring(i,i+1).contains('}')){
                        closeBrkt=closeBrkt+1;
                        }
                        if(codeBody.substring(i,i+1).contains('{')){
                        openBrkt=openBrkt+1;
                        }
                        if(openBrkt==closeBrkt && closeBrkt!=0 && openBrkt!=0){
                        system.debug('@@@@@openBrktcloseBrkt'+openBrkt+closeBrkt);
                        closingbrktIndex=i+1;
                        break;
                        }

                    }
                    system.debug('@@@@@closingbrktIndex'+closingbrktIndex);
                    String subForSrtingNnew=codeBody.substring(startF, closingbrktIndex);
                    system.debug('@@@@@subForSrtingNnew'+subForSrtingNnew);
                    if(subForSrtingNnew.contains('Select') && subForSrtingNnew.contains('From')){
                        soqlInsideFor=soqlInsideFor+1;
                    }
                    if(subForSrtingNnew.contains('Insert') || subForSrtingNnew.contains('Update') || subForSrtingNnew.contains('Delete')){
                        dmlInsideFor=dmlInsideFor+1;
                    }
                    if(subForSrtingNnew.contains('@Future')){
                        futureInsideFor=futureInsideFor+1;
                    }
                }
                
                
                //Creating Wrapper Element****************************************
                ClassTrigWrapper ctwr = new ClassTrigWrapper(eObj,codeCvg,soqlcounter,dmlInsideFor,soqlInsideFor,soqllimitCounter,futureInsideFor,bodyParts.size(),hardCodCount/2);    
                allClassTrigWrapper.add(ctwr);
            }            
        }      
    }
    public void removeSelectedCode(){
        
        showSelectedClassTrg=true;
        list<CodeWrapper> tempWrapper=new list<CodeWrapper>();
        if(allCodeWrapper!=null && !allCodeWrapper.isEmpty()){
            for(CodeWrapper co:allCodeWrapper){
                if(!co.isRemoved){
                    tempWrapper.add(co);                        
                }
            }
            if(tempWrapper!=null && !tempWrapper.isEmpty()){
                allCodeWrapper.clear();
                allCodeWrapper.addAll(tempWrapper);                
            }
            else{
                allCodeWrapper.clear();
                showSelectedClassTrg=false;
                showValidationResult=false;
                    
            }
        }    
    }
    public void addCode(){
        showCodingStd=false;        
        showSelectedClassTrg=true;
        if(selectedCode!=null && selectedCode!=''){
            
            CodeWrapper cw=new CodeWrapper(selectedCode);
            allCodeWrapper.add(cw);
            selectedCode='';
        }
            
    }    
    public class CodeWrapper{
        public string codeName{get;set;}
        public boolean isRemoved{get;set;}     
        
        public CodeWrapper(string codeNameTemp){
            codeName= codeNameTemp;            
            isRemoved=false;   
        }
                
    }
    public class ClassTrigWrapper{
        public sobject eachCode{get;set;}
        public String codeName{get;set;}
        public Id codeId{get;set;}
        public String codeStatus{get;set;}
        public String coverage{get;set;}
        public Integer totalSoqlCount{get;set;}
        public Integer dmlLoopCount{get;set;}        
        public Integer soqlLoop{get;set;}
        public Integer soqlLimit{get;set;}
        public Integer futureLoop{get;set;}
        public Integer lineCounter{get;set;}      
        public Integer countHard{get;set;}                 
        public classTrigWrapper(sobject eachCodeObj,String newcoverage,
                            Integer newtotalSoqlCount,Integer newdmlLoopCount,
                            Integer newsoqlLoop,Integer newsoqlLimit,Integer newfutureLoop,Integer newlineCounter,Integer countH){
            eachCode=eachCodeObj;
            codeName=(string)eachCodeObj.get('Name');
            codeId=(Id)eachCodeObj.get('Id');
            codeStatus=(string)eachCodeObj.get('Status');
            
            coverage = newcoverage;
            totalSoqlCount = newtotalSoqlCount;
            dmlLoopCount = newdmlLoopCount;            
            soqlLoop = newsoqlLoop;
            soqlLimit = newsoqlLimit;
            futureLoop = newfutureLoop;
            lineCounter = newlineCounter;          
            countHard=countH;                
        
        } 
                
    }
    public String fetchCodeCoverageAggregate(){
        return sendToolingQueryRequest('SELECT+ApexClassOrTriggerId,Coverage,LastModifiedDate+FROM+ApexCodeCoverageAggregate');
    }
    //Method to send query request to tooling api endpoint
    private String sendToolingQueryRequest(String queryStr){
        HttpRequest req = new HttpRequest();
        req.setEndpoint(TOOLINGAPI_ENDPOINT+'query/?q='+queryStr);
        //Set authorization by using current users session Id
        req.setHeader('Authorization', 'Bearer ' + UserInfo.getSessionID());
        req.setHeader('Content-Type', 'application/json');        
        req.setMethod('GET');
        req.setTimeout(120000);
        Http http = new Http();
        HTTPResponse res = new HTTPResponse();
        if(!test.isRunningTest()){
            res = http.send(req);
        }
        else if(test.isRunningTest()){
            //res = (HTTPResponse )JSON.deserializeUntyped('{"size":17,"totalSize":17,"done":true,"queryLocator":null,"entityTypeName":"ApexCodeCoverage","records":[{"attributes":{"type":"ApexCodeCoverage","url":"/services/data/v32.0/tooling/sobjects/ApexCodeCoverage/71490000005QLyiAAG"},"ApexTestClassId":"01p90000000Dnu0AAC","ApexClassOrTriggerId":"01p90000000DntzAAC"},{"attributes":{"type":"ApexCodeCoverage","url":"/services/data/v32.0/tooling/sobjects/ApexCodeCoverage/71490000005QLz7AAG"},"ApexTestClassId":"01p90000000Dnu2AAC","ApexClassOrTriggerId":"01p90000000Dnu1AAC"},{"attributes":{"type":"ApexCodeCoverage","url":"/services/data/v32.0/tooling/sobjects/ApexCodeCoverage/71490000005QLynAAG"},"ApexTestClassId":"01p90000000Dnu4AAC","ApexClassOrTriggerId":"01p90000000Dnu3AAC"},{"attributes":{"type":"ApexCodeCoverage","url":"/services/data/v32.0/tooling/sobjects/ApexCodeCoverage/71490000005QLysAAG"},"ApexTestClassId":"01p90000000Dnu6AAC","ApexClassOrTriggerId":"01p90000000Dnu5AAC"},{"attributes":{"type":"ApexCodeCoverage","url":"/services/data/v32.0/tooling/sobjects/ApexCodeCoverage/71490000005QLzHAAW"},"ApexTestClassId":"01p90000000Dnu8AAC","ApexClassOrTriggerId":"01p90000000Dnu7AAC"},{"attributes":{"type":"ApexCodeCoverage","url":"/services/data/v32.0/tooling/sobjects/ApexCodeCoverage/71490000005QLzIAAW"},"ApexTestClassId":"01p90000000Dnu8AAC","ApexClassOrTriggerId":"01p90000000Dnu7AAC"},{"attributes":{"type":"ApexCodeCoverage","url":"/services/data/v32.0/tooling/sobjects/ApexCodeCoverage/71490000005QLzJAAW"},"ApexTestClassId":"01p90000000Dnu8AAC","ApexClassOrTriggerId":"01q90000000DAVZAA4"},{"attributes":{"type":"ApexCodeCoverage","url":"/services/data/v32.0/tooling/sobjects/ApexCodeCoverage/71490000005QLzKAAW"},"ApexTestClassId":"01p90000000Dnu8AAC","ApexClassOrTriggerId":"01p90000005QzqiAAC"},{"attributes":{"type":"ApexCodeCoverage","url":"/services/data/v32.0/tooling/sobjects/ApexCodeCoverage/71490000005QLzLAAW"},"ApexTestClassId":"01p90000000Dnu8AAC","ApexClassOrTriggerId":"01p90000005QzqiAAC"},{"attributes":{"type":"ApexCodeCoverage","url":"/services/data/v32.0/tooling/sobjects/ApexCodeCoverage/71490000005QLzMAAW"},"ApexTestClassId":"01p90000000Dnu8AAC","ApexClassOrTriggerId":"01q90000000DAVZAA4"},{"attributes":{"type":"ApexCodeCoverage","url":"/services/data/v32.0/tooling/sobjects/ApexCodeCoverage/71490000005QLzCAAW"},"ApexTestClassId":"01p90000000E7M4AAK","ApexClassOrTriggerId":"01p90000000E7M4AAK"},{"attributes":{"type":"ApexCodeCoverage","url":"/services/data/v32.0/tooling/sobjects/ApexCodeCoverage/71490000005QRlvAAG"},"ApexTestClassId":"01p90000002rtDFAAY","ApexClassOrTriggerId":"01p90000002rtDCAAY"},{"attributes":{"type":"ApexCodeCoverage","url":"/services/data/v32.0/tooling/sobjects/ApexCodeCoverage/71490000005QRlwAAG"},"ApexTestClassId":"01p90000002rtDFAAY","ApexClassOrTriggerId":"01p90000002rtDEAAY"},{"attributes":{"type":"ApexCodeCoverage","url":"/services/data/v32.0/tooling/sobjects/ApexCodeCoverage/71490000005QRlxAAG"},"ApexTestClassId":"01p90000002rtDFAAY","ApexClassOrTriggerId":"01p90000002rtDDAAY"},{"attributes":{"type":"ApexCodeCoverage","url":"/services/data/v32.0/tooling/sobjects/ApexCodeCoverage/71490000005QLz2AAG"},"ApexTestClassId":"01p90000004ARNXAA4","ApexClassOrTriggerId":"01p90000004ARNWAA4"},{"attributes":{"type":"ApexCodeCoverage","url":"/services/data/v32.0/tooling/sobjects/ApexCodeCoverage/71490000005QLyxAAG"},"ApexTestClassId":"01p90000006ESo8AAG","ApexClassOrTriggerId":"01p90000006ESo6AAG"},{"attributes":{"type":"ApexCodeCoverage","url":"/services/data/v32.0/tooling/sobjects/ApexCodeCoverage/71490000005Qlq6AAC"},"ApexTestClassId":"01p90000006FA1CAAW","ApexClassOrTriggerId":"01p90000006ESnmAAG"}]}');
        }
        
        return res.getBody();
    }
    //Method to convert JSON to Object to populate Wrapper List
    private void getValuesAsMap(String jStr){
        if(String.isBlank(jStr))
            return;
        //Convert to Map
        system.debug('@@jStr'+jStr);
        Map<String,Object> resultMap= (Map<String,Object>)JSON.deserializeUntyped(jStr);
        String entityType = (String)resultMap.get('entityTypeName');
        List<Object> resultRecords = (List<Object>)resultMap.get('records');
        if(entityType != 'ApexOrgWideCoverage'){
            for(Object obj : resultRecords){
                Map<String,Object> elementMap = (Map<String,Object>) obj;
                system.debug('@@elementMap'+elementMap);
                prepareElement(elementMap,entityType);
            }
        }        
    }
    public void prepareElement(Map<String,Object> mapObj,String entity){
        if(entity == 'ApexCodeCoverageAggregate'){
            Id elementId = String.valueOf(mapObj.get('ApexClassOrTriggerId')); 
            
            
            Map<String,Object> coverageObj = (MAP<String,Object>) mapObj.get('Coverage');
            List<Object> covered = (List<Object>)coverageObj.get('coveredLines');
            List<Object> unCovered = (List<Object>)coverageObj.get('uncoveredLines');

            system.debug('@@covered'+covered.size()+'@@unCovered'+unCovered.size());
            system.debug('@@covered'+covered+'@@unCovered'+unCovered);
            classCoveredLinesMap.put(elementId, covered);
            classUnCoveredLinesMap.put(elementId, unCovered);
                    
        }        
    }
    public static List<gaugeData> getData() {
          List<gaugeData> data = new List<gaugeData>();
          data.add(new gaugeData('Score',8 ));
          return data;
     }

    public class gaugeData {
        public String name { get; set; }
        public Integer size { get; set; }

        public gaugeData(String name, Integer data) {
            this.name = name;
            this.size = data;
        }
    } 
            
}