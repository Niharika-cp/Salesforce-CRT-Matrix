public class SharedComponentMatrixClassDup {
    public List<Wrapper> complist {get; set;}
    public List<Wrapper> complistdup {get; set;}
    
    public SharedComponentMatrixClassDup(){
        complist = new List<Wrapper>();
        complistdup = new List<Wrapper>();
        Integer days=null;
        Date fromDt=null; 
        Date toDt=null;
        days = ApexPages.currentPage().getParameters().get('days')!='null' ?Integer.Valueof(ApexPages.currentPage().getParameters().get('days')):null;
        fromDt =ApexPages.currentPage().getParameters().get('fromDt')!='null'? Date.Valueof(ApexPages.currentPage().getParameters().get('fromDt')):null;
        toDt =ApexPages.currentPage().getParameters().get('toDt')!='null'? Date.Valueof(ApexPages.currentPage().getParameters().get('toDt')):null;
        complistdup = SharedComponentMatrixClassDup.matrix(days,fromDt,toDt);
        for(Wrapper wp:complistdup){
            if(wp.usList.size()>1){
                complist.add(wp);
            }
        }       
    }
    
    @AuraEnabled(cacheable = true)
    public static List<Wrapper> matrix(Integer days, Date fromDt, Date toDt){
        List<copado__Environment__c> productionEnv = [SELECT Id, Name, copado__Type__c FROM copado__Environment__c Where copado__Type__c ='Production/Developer'];
        List<copado__user_Story__c> usList = [SELECT Name, Id, copado__Environment__c,copado__Environment__r.Name,CreatedBy.Name,copado__Metadata_Types_in_Selection__c,(Select copado__last_commit_date__c from copado__User_Story_Metadata__r) FROM copado__User_Story__c Where copado__Environment__c NOT IN: productionEnv And copado__Metadata_Types_in_Selection__c != null Order By Name Asc];
        Map<Id,copado__user_Story__c> usMap = New Map<Id,copado__user_Story__c>(usList);
        
        List<copado__User_Story_Metadata__c> usmList = New List<copado__User_Story_Metadata__c>();
        String usmquery = 'SELECT Id, Name, API_Name__c,copado__User_Story__r.Id,copado__Last_Commit_Date__c,Type__c, copado__User_Story__c, copado__Metadata_API_Name__c, copado__Status__c FROM copado__User_Story_Metadata__c Where copado__User_Story__c =:usList';    
        if(days == null && fromDt == null && toDt == null){
            usmList = Database.query(usmquery);
        }
        if(days != null){
            String day = String.valueOf(days);
            day = '-'+day;
            Integer dat = Integer.valueOf(day);
            Date dt = System.today().addDays(dat);
            System.debug(dt);
            Date tod = System.today();
            System.debug(tod);
            usmquery = usmquery+' And CreatedDate >=: dt AND CreatedDate<=: tod';
            usmList= Database.query(usmquery);
        }
        else if(days == null && fromDt != null) {
            usmquery = usmquery+' And CreatedDate >=: fromDt AND CreatedDate <=: toDt ';
            usmList = Database.query(usmquery);
        }
        
        Map<String,String> ussmMap = New Map<String,String>();
        Map<String,Id> usMetaIdMap = New Map<String,Id>();
        Map<String,List<copado__User_Story__c>> ussMap = New Map<String,List<copado__User_Story__c>>();
        Map<String,DateTime> usMetaMap = New Map<String,DateTime>();
        for(copado__user_story_metadata__c us : usmList){
            if(ussMap.get(us.API_Name__c)==null){
                ussMap.put(us.API_Name__c,new List<copado__User_Story__c>{usMap.get(us.copado__User_Story__r.Id)});
                ussmMap.put(us.API_Name__c, us.Type__c);
                usMetaMap.put(us.API_Name__c,us.copado__Last_Commit_Date__c);
               // usMetaIdMap.put(us.API_Name__c, us.Id);
            }
            else {
                List<Copado__User_Story__c> usListt = ussMap.get(us.API_Name__c);
                Set<Copado__User_Story__c> usSet = New Set<Copado__User_Story__c>(usListt);
                usSet.add(usMap.get(us.copado__User_Story__r.Id));
                List<Copado__User_Story__c> usDupList = New List<Copado__User_Story__c>(usSet);
                ussMap.put(us.API_Name__c,usDupList);
                usMetaMap.put(us.API_Name__c,us.copado__Last_Commit_Date__c);
                //usMetaIdMap.put(us.API_Name__c, us.Id);
            }
        }
        /*Map<List<Copado__user_story__c>, string> revMap = New Map<List<Copado__user_story__c>, string>();
for (String key : ussMap.keySet()) {
List<Copado__user_story__c> value = ussMap.get(key);
revMap.put(value, key);
}*/		
      
        List<Wrapper> wrpList = new List<Wrapper>();
        for (String sc : ussMap.keySet()) {
            Wrapper wrp = new Wrapper();
            wrp.component = sc;
            wrp.typer = ussmMap.get(sc);
            wrp.usList = new List<UserStoryWrapper>();

            for (copado__User_Story__c us : ussMap.get(sc)) {
                DateTime latestCommitDate = null;
                if (us.copado__User_Story_Metadata__r != null) {
                    for (copado__User_Story_Metadata__c metadata : us.copado__User_Story_Metadata__r) {
                        DateTime commitDate = metadata.copado__Last_Commit_Date__c;
                        if (commitDate != null && (latestCommitDate == null || commitDate > latestCommitDate)) {
                            latestCommitDate = commitDate;
                        }
                    }
                }
                UserStoryWrapper usw = new UserStoryWrapper(us, latestCommitDate);
                wrp.usList.add(usw);
            }
            wrpList.add(wrp);
        }
        List<Wrapper> wrpDupList = checkDups(wrpList);
        system.debug('wrpDupList=='+wrpDupList);
        return wrpDupList;
    }
            
    public class Wrapper {
        @AuraEnabled public String component {get;set;}
        @AuraEnabled public String typer {get;set;}
        @AuraEnabled public List<UserStoryWrapper> usList {get;set;}
        
        public Wrapper(){
            usList = new List<UserStoryWrapper>();
        }
    }

    public class UserStoryWrapper {
        @AuraEnabled public copado__User_Story__c userStory {get;set;}
        @AuraEnabled public DateTime lastCommitDate {get;set;}
        @AuraEnabled public String environmentName {get;set;}
        @AuraEnabled public String ownerName {get;set;}
        
        public UserStoryWrapper(copado__User_Story__c userStory, DateTime lastCommitDate){
            this.userStory = userStory;
            this.lastCommitDate = lastCommitDate;
            this.environmentName = userStory.copado__Environment__r.Name;
            this.ownerName = userStory.CreatedBy.Name;
        }
    }
    
   /* public class uswrapper{
        @AuraEnabled public copado__user_story__c usList{get;set;}
        @AuraEnabled public Datetime lastCommit{get;set;}
    }*/
    
    @AuraEnabled
    public static List<Wrapper> searchKey(String searchKey, Integer days, DateTime fromDt, DateTime toDt){
        List<copado__Environment__c> productionEnv = [SELECT Id, Name, copado__Type__c FROM copado__Environment__c Where copado__Type__c ='Production/Developer'];
        List<copado__user_Story__c> usList = [SELECT Name, Id, copado__Environment__c,copado__Environment__r.Name,CreatedBy.Name,copado__Metadata_Types_in_Selection__c,(Select copado__last_commit_date__c from copado__User_Story_Metadata__r) FROM copado__User_Story__c Where copado__Environment__c NOT IN: productionEnv And copado__Metadata_Types_in_Selection__c != null Order By Name Asc];
        Map<Id,copado__user_Story__c> usMap = New Map<Id,copado__user_Story__c>(usList);
        List<copado__User_Story_Metadata__c> usmList= new List<copado__User_Story_Metadata__c>();
        String usmquery;
        if(searchKey != null){
            usmquery = 'SELECT Id, Name, API_Name__c,copado__User_Story__r.Id, copado__Last_Commit_Date__c ,Type__c, copado__User_Story__c, copado__Metadata_API_Name__c, copado__Status__c FROM copado__User_Story_Metadata__c Where copado__User_Story__c =:usList And API_Name__c LIKE \'%' +searchKey+'%\'';
        }
        else{
             usmquery = 'SELECT Id, Name, API_Name__c,copado__User_Story__r.Id, copado__Last_Commit_Date__c ,Type__c, copado__User_Story__c, copado__Metadata_API_Name__c, copado__Status__c FROM copado__User_Story_Metadata__c Where copado__User_Story__c =:usList ';
        }
        System.debug(usmquery);
        if(days != null) {
            String day = String.valueOf(days);
            day = '-'+day;
            Integer dat = Integer.valueOf(day);
            Date dt = System.today().addDays(dat);
            System.debug(dt);
            Date tod = System.today();
            System.debug(tod);
            usmquery = usmquery+' And CreatedDate >=: dt AND CreatedDate<=: tod';
            system.debug(usmquery);
            usmList= Database.query(usmquery);
        }
        else if(days == null && fromDt != null) {
            usmquery = usmquery+' And CreatedDate >=: fromDt AND CreatedDate <=: toDt ';
            system.debug(usmquery);
            usmList = Database.query(usmquery);
        }
        else {
            system.debug(usmquery);
            usmList = Database.query(usmquery);
        }
        
        Map<String,String> ussmMap = New Map<String,String>();
        Map<String,Datetime> usMetaMap = New Map<String,Datetime>();
        Map<String,List<copado__User_Story__c>> ussMap = New Map<String,List<copado__User_Story__c>>();
        for(copado__user_story_metadata__c us : usmList){
            if(ussMap.get(us.API_Name__c)==null){
                ussMap.put(us.API_Name__c,new List<copado__User_Story__c>{usMap.get(us.copado__User_Story__r.Id)});
                ussmMap.put(us.API_Name__c, us.Type__c);
                usMetaMap.put(us.API_Name__c, us.copado__Last_Commit_Date__c);
            }
            else {
                List<Copado__User_Story__c> usListt = ussMap.get(us.API_Name__c);
                Set<Copado__User_Story__c> usSet = New Set<Copado__User_Story__c>(usListt);
                usSet.add(usMap.get(us.copado__User_Story__r.Id));
                List<Copado__User_Story__c> usDupList = New List<Copado__User_Story__c>(usSet);
                ussMap.put(us.API_Name__c,usDupList);
                usMetaMap.put(us.API_Name__c,us.copado__Last_Commit_Date__c);
            }
        }
        /*Map<List<Copado__user_story__c>, string> revMap = New Map<List<Copado__user_story__c>, string>();
for (String key : ussMap.keySet()) {
List<Copado__user_story__c> value = ussMap.get(key);
revMap.put(value, key);
}*/
        List<Wrapper> wrpList = New List<Wrapper>();
        for(String sc : ussMap.keySet()){
            Wrapper wrp = New Wrapper();
            wrp.component = sc;
            wrp.typer = ussmMap.get(sc);
            wrp.usList = new List<UserStoryWrapper>();
            // Iterate over each user story to set the latest commit date
            for(copado__User_Story__c us : ussMap.get(sc)){
                DateTime latestCommitDate = null;
                if(us.copado__User_Story_Metadata__r != null){
                    for(copado__User_Story_Metadata__c metadata : us.copado__User_Story_Metadata__r){
                        DateTime commitDate = metadata.copado__Last_Commit_Date__c;
                        if(commitDate != null && (latestCommitDate == null || commitDate > latestCommitDate)){
                            latestCommitDate = commitDate;
                        }
                    }
                }
                UserStoryWrapper usw = new UserStoryWrapper(us, latestCommitDate);
                wrp.usList.add(usw);
            }
            wrpList.add(wrp);
        }
        List<Wrapper> wrpDupList = checkDups(wrpList);
        return wrpDupList;
        
    }
    
    public static List<Wrapper> checkDups(List<Wrapper>wrpList){
        List<Wrapper> wrpDupList = New List<Wrapper>();
        for(Wrapper wp:wrpList){
            if(wp.usList.size()>1){
                wrpDupList.add(wp);
            }
        }
        return wrpDupList;
    }
}
/*
public class Wrapper {
@AuraEnabled public string component{get;set;}
@AuraEnabled  public string typer{get;set;}
@AuraEnabled public List<copado__user_story__c> usm{get;set;}
}
public class NameComparator implements Comparator<Wrapper> {
public Integer compare(Wrapper wrp1, Wrapper wrp2) {
return wrp1.component.compareTo(wrp2.component);
}
}*/

/*Map<String,String>sourceCred = New Map<String,String>();
Map<String,copado__User_Story_Metadata__c> ustoryMetMap = New Map<String,copado__User_Story_Metadata__c>();
for(copado__User_Story_Metadata__c usmet : usmList){
ustoryMetMap.put(usmet.copado__User_Story__r.Id,usmet);
}
for(copado__user_Story__c cou : usList){
sourceCred.put(cou.Id, cou.copado__Environment__r.Name);
}*/

/* Map<String,String> apiName = New Map<String,String>();
for(copado__User_Story_Metadata__c usmet : usmList){
apiName.put(usmet.copado__User_Story__c,usmet.API_Name__c);
}

List<Wrapper> wrpList = new List<Wrapper>();
for(copado__User_Story__c us : usList){
Wrapper wrp = New Wrapper();
if(ustoryMetMap.get(us.Id) != null){
wrp.component = ustoryMetMap.get(us.Id).API_Name__c;
wrp.userstory = Url.getOrgDomainUrl().toExternalForm() + us.Id;
wrp.source = us.copado__Environment__r.Name;
wrp.owner = us.CreatedBy.Name;
wrp.typer = ustoryMetMap.get(us.Id).Type__c;
wrpList.add(wrp);
}
}*/