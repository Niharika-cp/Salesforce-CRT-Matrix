public inherited sharing class INX_ResolutionDomain {

    public static void createUpdate(INX.Resolution objResolutionInfo) {

        if(objResolutionInfo == null) { return; }

        INX_Resolution__c sObj = objResolutionInfo.getSObject();

        INX_Repository__c sObjRepository = INX_RepositorySelector.getRepositoryByName(objResolutionInfo.repository);

        sObj.INX_Repository__c = sObjRepository.Id;

        upsert sObj INX_Id__c;

        objResolutionInfo.remoteId = sObj.Id;

        List<INX.AttachmentDetails> lstAttachmentDetails = new List<INX.AttachmentDetails> {
            new INX.AttachmentDetails(
                objResolutionInfo.hunkDetails,
                'Resolution details',
                'Detailing resolution Hunk.'
            )
        };

        INX_Utility.processAttachments(sObj, lstAttachmentDetails);

        objResolutionInfo.hunkDetails = null;
    }

    public static INX_Resolution__c getResolutionByHash(String strRepository, String strHash) {

        return INX_ResolutionSelector.getResolutionByHash(strRepository, strHash);
    }

    public static INX.Resolution getResolutionInfoByHash(String strRepository, String strHash) {

        INX_Resolution__c sObj = getResolutionByHash(strRepository, strHash);

        INX.Resolution objResolution = null;

        if(sObj != null) {

            objResolution = new INX.Resolution(sObj);

            List<INX.AttachmentDetails> lstAttachmentDetails = new List<INX.AttachmentDetails> {
                new INX.AttachmentDetails('Resolution details')
            };

            INX_Utility.getFromAttachments(objResolution, sObj, lstAttachmentDetails);
        }

        return objResolution;
    }
}