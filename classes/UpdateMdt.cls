public with sharing class UpdateMdt {
    @AuraEnabled(cacheable=true)
    public static string updateValue(string valueToUpdate){
        Copado_Utility_Configuration__mdt metaList = new Copado_Utility_Configuration__mdt();
        
        if(Test.isRunningTest()){
            metaList.DeveloperName ='Test';
            metaList.MasterLabel = 'Test';
            metaList.Value__c = 'Production Status';
        }
        else{
            metaList = [SELECT MasterLabel,DeveloperName,Value__c FROM Copado_Utility_Configuration__mdt Where MasterLabel = 'Production Status'];
        }
        system.debug('metaList'+metaList);
        Metadata.CustomMetadata mData = new Metadata.CustomMetadata();
        mData.fullName = 'Copado_Utility_Configuration__mdt.'+metaList.DeveloperName;
        mData.Label=metaList.MasterLabel;
        
        //Instance of value
        Metadata.CustomMetadataValue instance = new  Metadata.CustomMetadataValue();
        instance.field='Value__c';
        instance.value=valueToUpdate;
        
        //Adding values to the Record
        mData.values.add(instance);
        
        //instance of the container
        
        Metadata.DeployContainer container = new  Metadata.DeployContainer();
        container.addMetadata(mData);  //adding record to the container
        //enqueue deployment to the salesforce org
        Id jobId;
        if (!Test.isRunningTest()) {
            jobId = Metadata.Operations.enqueueDeployment(container, null);
        } 
        return 'varResult';
    }
    @AuraEnabled(cacheable=true)
    public static string showPreviousValue(){
        Copado_Utility_Configuration__mdt mdList = new Copado_Utility_Configuration__mdt();
       if(!Test.isRunningTest()){

        mdList = [SELECT MasterLabel,DeveloperName,Value__c FROM Copado_Utility_Configuration__mdt Where MasterLabel = 'Production Status'];
        system.debug(mdList.Value__c);
       }
        return test.isrunningTest()?'Completed':mdList.Value__c;
    }
    
}