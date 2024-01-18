public inherited sharing class INX_ReviewDomain {

    public static void createUpdate(INX.Review objReviewInfo) {

        INX_Review__c sObj = objReviewInfo.getSObject();

        INX_Repository__c sObjRepository = INX_RepositorySelector.getRepositoryByName(objReviewInfo.repository);

        sObj.INX_Repository__c = sObjRepository.Id;

        upsert sObj INX_Id__c;

        objReviewInfo.remoteId = sObj.Id;
    }
}