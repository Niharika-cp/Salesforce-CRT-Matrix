public inherited sharing class INX_InstanceDomain {

    public static void createUpdate(INX.Instance objInstance) {

        if(objInstance == null) { return; }

        INX_Instance__c sObj = objInstance.getSObject();

        if(String.isNotBlank(objInstance.repository)) {

            INX_Repository__c sObjRepository = INX_RepositorySelector.getRepositoryByName(objInstance.repository);

            sObj.INX_Repository__c = sObjRepository == null ? null : sObjRepository.Id;
        }

        if(String.isNotBlank(objInstance.parent)) {

            INX_Instance__c sObjInstance = INX_InstanceSelector.getInstanceByName(objInstance.parent);

            sObj.INX_Parent__c = sObjInstance == null ? null : sObjInstance.Id;
        }

        upsert sObj INX_Id__c;

        objInstance.remoteId = sObj.Id;
    }

    public static INX_Instance__c getInstanceByName(String strName) {

        return INX_InstanceSelector.getInstanceByName(strName);
    }

    public static INX.Instance getInstanceInfoByName(String strName) {

        INX_Instance__c sObj = getInstanceByName(strName);

        INX.Instance objInstance = null;

        if(sObj != null) {

            objInstance = new INX.Instance(sObj);
        }

        return objInstance;
    }
}