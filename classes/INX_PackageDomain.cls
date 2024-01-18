public inherited sharing class INX_PackageDomain {

    public static void createUpdate(INX.PackageInfo objPackageInfo) {

        if(objPackageInfo == null) { return; }

        INX_Package__c sObj = objPackageInfo.getSObject();

        INX_Instance__c sObjInstance = INX_InstanceSelector.getInstanceByName(objPackageInfo.instance);

        sObj.INX_Instance__c = sObjInstance == null ? null : sObjInstance.Id;

        upsert sObj INX_Id__c;

        objPackageInfo.remoteId = sObj.Id;

        List<INX.AttachmentDetails> lstAttachmentDetails = new List<INX.AttachmentDetails> {
            new INX.AttachmentDetails(
                objPackageInfo.packageDetails,
                'Package details',
                'Detailing types, component, permission, objects and fields selected.'
            )
        };

        INX_Utility.processAttachments(sObj, lstAttachmentDetails);

        objPackageInfo.packageDetails = null;
    }

    public static void deletePackage(String strName) {

        INX_Package__c sObj = INX_PackageSelector.getPackageByName(strName);

        if(sObj != null) {

            delete sObj;
        }
    }

    public static INX_Package__c getPackageByName(String strName) {

        return INX_PackageSelector.getPackageByName(strName);
    }

    public static INX.PackageInfo getPackageInfoByName(String strName) {

        INX_Package__c sObj = getPackageByName(strName);

        INX.PackageInfo objPackage = null;

        if(sObj != null) {

            objPackage = new INX.PackageInfo(sObj);

            List<INX.AttachmentDetails> lstAttachmentDetails = new List<INX.AttachmentDetails> {
                new INX.AttachmentDetails('Package details')
            };

            INX_Utility.getFromAttachments(objPackage, sObj, lstAttachmentDetails);
        }

        return objPackage;
    }
}