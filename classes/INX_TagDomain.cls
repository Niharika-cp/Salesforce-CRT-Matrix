public inherited sharing class INX_TagDomain {

    public static void createUpdate(INX.Tag objTag) {

        if(objTag == null) { return; }

        INX_Tag__c sObj = objTag.getSObject();

        INX_Instance__c sObjInstance = INX_InstanceSelector.getInstanceByName(objTag.instance);

        sObj.INX_Instance__c = sObjInstance == null ? null : sObjInstance.Id;

        upsert sObj INX_Id__c;

        objTag.remoteId = sObj.Id;

        Map<String, INX.TagLink> mapTagLinksCurrent = new Map<String, INX.TagLink>();

        for(INX_Tag_Link__c sObjLink : INX_Tag_LinkSelector.getPackagesForTag(objTag.name)) {

            INX.TagLink obj = new INX.TagLink(sObjLink);

            mapTagLinksCurrent.put(obj.packageName, obj);
        }

        Map<String, INX.TagLink> mapTagLinksIncoming = new Map<String, INX.TagLink>();

        for(INX.TagLink obj : objTag.links) {

            mapTagLinksIncoming.put(obj.packageName, obj);
        }

        Set<String> packagesToAdd = new Set<String>(mapTagLinksIncoming.keySet());
        packagesToAdd.removeAll(mapTagLinksCurrent.keySet());

        Set<String> packagesToRemove = new Set<String>(mapTagLinksCurrent.keySet());
        packagesToRemove.removeAll(mapTagLinksIncoming.keySet());

        List<INX_Package__c> lstPackage = INX_PackageSelector.getPackagesByName(packagesToAdd);

        Map<String, INX_Package__c> mapPackage = new Map<String, INX_Package__c>();

        for(INX_Package__c sObjPackage : lstPackage) {

            mapPackage.put(sObjPackage.Name, sObjPackage);
        }

        List<INX_Tag_Link__c> lstCreateLink = new List<INX_Tag_Link__c>();
        List<INX_Tag_Link__c> lstDeleteLink = new List<INX_Tag_Link__c>();

        for(INX.TagLink obj : objTag.links) {

            if(packagesToAdd.contains(obj.packageName)) {

                INX_Package__c sObjPackage = mapPackage.get(obj.packageName);

                if(sObjPackage != null) {

                    INX_Tag_Link__c sObjLink = obj.getSObject();

                    sObjLink.INX_Tag__c = sObj.Id;
                    sObjLink.INX_Package__c = sObjPackage.Id;

                    if(String.isNotBlank(sObjLink.INX_Package__c)) {

                        lstCreateLink.add(sObjLink);
                    }
                }
            }
        }

        for(String strPackageName : packagesToRemove) {

            INX.TagLink obj = mapTagLinksCurrent.get(strPackageName);

            INX_Tag_Link__c sObjLink = obj.getSObject();

            lstDeleteLink.add(sObjLink);
        }

        if(!lstCreateLink.isEmpty()) {

            insert lstCreateLink;
        }

        if(!lstDeleteLink.isEmpty()) {

            delete lstDeleteLink;
        }
    }

    public static void deleteTag(String strName) {

        INX_Tag__c sObj = INX_TagSelector.getTagByName(strName);

        if(sObj != null) {

            delete sObj;
        }
    }

    public static INX_Tag__c getTagByName(String strName) {

        return INX_TagSelector.getTagByName(strName);
    }

    public static INX.Tag getTagInfoByName(String strName) {

        INX.Tag objTag = new INX.Tag(getTagByName(strName));

        objTag.links = new List<INX.TagLink>();

        for(INX_Tag_Link__c sObj : INX_Tag_LinkSelector.getPackagesForTag(objTag.name)) {

            objTag.links.add(new INX.TagLink(sObj));
        }

        return objTag;
    }
}