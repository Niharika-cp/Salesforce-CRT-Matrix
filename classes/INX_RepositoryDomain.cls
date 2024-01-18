public inherited sharing class INX_RepositoryDomain {

    public static void createUpdate(INX.Repository objRepository) {

        if(objRepository == null) { return; }

        INX_Repository__c sObj = objRepository.getSObject();

        upsert sObj INX_Id__c;

        objRepository.remoteId = sObj.Id;

    }

    public static INX_Repository__c getRepositoryByName(String strName) {

        return INX_RepositorySelector.getRepositoryByName(strName);

    }

    public static INX.Repository getRepositoryInfoByName(String strName) {

        return new INX.Repository(getRepositoryByName(strName));

    }
}