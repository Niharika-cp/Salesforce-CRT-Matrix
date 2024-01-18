public inherited sharing class INX_DeploymentDomain {

    public static void createUpdate(INX.Deployment objDeployment) {

        if(objDeployment == null) { return; }

        INX_Deployment__c sObj = objDeployment.getSObject();

        INX_Instance__c sObjInstance = INX_InstanceSelector.getInstanceByName(objDeployment.instance);

        sObj.INX_Instance__c = sObjInstance == null ? null : sObjInstance.Id;

        upsert sObj INX_Id__c;

        objDeployment.remoteId = sObj.Id;

        List<INX.AttachmentDetails> lstAttachmentDetails = new List<INX.AttachmentDetails> {
            new INX.AttachmentDetails(
                objDeployment.deploymentDetails,
                'Deployment details',
                'Detailing deploy options selected.'
            )
        };

        INX_Utility.processAttachments(sObj, lstAttachmentDetails);

    }

    public static INX_Deployment__c getDeploymentByTypeNameInstance(String strSubType, String strName, String strInstance) {

        return INX_DeploymentSelector.getDeploymentByTypeNameInstance(strSubType, strName, strInstance);

    }

    public static INX.Deployment getDeploymentInfoByTypeNameInstance(String strSubType, String strName, String strInstance) {

        INX_Deployment__c sObj = getDeploymentByTypeNameInstance(strSubType, strName, strInstance);

        INX.Deployment objDeployment = new INX.Deployment(sObj);

        List<INX.AttachmentDetails> lstAttachmentDetails = new List<INX.AttachmentDetails> {
            new INX.AttachmentDetails('Deployment details')
        };

        INX_Utility.getFromAttachments(objDeployment, sObj, lstAttachmentDetails);

        return objDeployment;

    }
}