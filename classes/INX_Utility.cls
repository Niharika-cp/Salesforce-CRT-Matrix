public inherited sharing class INX_Utility {

    public static Map<String, String> decodeParameters(Map<String, String> mapParams) {

        if(mapParams.containsKey('q')) {

            String csv = EncodingUtil.base64Decode(mapParams.get('q')).toString();

            for(String nvp : csv.split(';')) {

                List<String> nvpSplit = nvp.split('=');
                mapParams.put(nvpSplit[0], nvpSplit[1]);
            }
        }

        return mapParams;
    }

    public static Long getMax(Long timestamp, DateTime dt) {

        if(timestamp == null) {
            return dt.getTime();
        }

        if(dt.getTime() > timestamp) {
            return dt.getTime();
        }

        return timestamp;
    }

    public static void processAttachments(SObject sObjParent, List<INX.AttachmentDetails> lstAttachmentDetails) {

        Map<String, INX.AttachmentDetails> mapAttachmentDetailsByName = getMapAttachmentDetails(lstAttachmentDetails);

        Map<String, Attachment> mapAttachmentByName = getAttachments(sObjParent, mapAttachmentDetailsByName.keySet());

        List<Attachment> lstInsert = new List<Attachment>();
        List<Attachment> lstUpdate = new List<Attachment>();
        List<Attachment> lstDelete = new List<Attachment>();

        for(INX.AttachmentDetails obj : lstAttachmentDetails) {

            if(mapAttachmentByName.containsKey(obj.name)) {

                if(obj.obj == null) {

                    lstDelete.add(mapAttachmentByName.get(obj.name));

                } else {

                    Attachment objAttachment = mapAttachmentByName.get(obj.name);
                    objAttachment.Body = Blob.valueOf(JSON.serialize(obj.obj, true));
                    lstUpdate.add(objAttachment);
                }
            } else {

                if(obj.obj != null) {

                    lstInsert.add(
                        new Attachment(
                            Body = Blob.valueOf(JSON.serialize(obj.obj, true)),
                            Name = obj.name,
                            ContentType = 'json',
                            ParentID = sObjParent.Id,
                            Description = obj.description
                        )
                    );
                }
            }
        }

        if(!lstInsert.isEmpty()) {
            insert lstInsert;
        }

        if(!lstUpdate.isEmpty()) {
            update lstUpdate;
        }

        if(!lstDelete.isEmpty()) {
            delete lstDelete;
        }
    }

    public static void getFromAttachments(INX.PackageInfo obj, SObject sObj, List<INX.AttachmentDetails> lstAttachmentDetails) {

        Map<String, INX.AttachmentDetails> mapAttachmentDetailsByName = getMapAttachmentDetails(lstAttachmentDetails);

        Map<String, Attachment> mapAttachmentByName = getAttachments(sObj, mapAttachmentDetailsByName.keySet());

        if(mapAttachmentByName.containsKey('Package details')) {

            obj.packageDetails = (INX.PackageWrapper) JSON.deserialize(mapAttachmentByName.get('Package details').Body.toString(), INX.PackageWrapper.class);
        }
    }

    public static void getFromAttachments(INX.Deployment obj, SObject sObj, List<INX.AttachmentDetails> lstAttachmentDetails) {

        Map<String, INX.AttachmentDetails> mapAttachmentDetailsByName = getMapAttachmentDetails(lstAttachmentDetails);

        Map<String, Attachment> mapAttachmentByName = getAttachments(sObj, mapAttachmentDetailsByName.keySet());

        if(mapAttachmentByName.containsKey('Deployment details')) {

            obj.deploymentDetails = (INX.DeploymentDetails) JSON.deserialize(mapAttachmentByName.get('Deployment details').Body.toString(), INX.DeploymentDetails.class);
        }
    }

    public static void getFromAttachments(INX.Resolution obj, SObject sObj, List<INX.AttachmentDetails> lstAttachmentDetails) {

        Map<String, INX.AttachmentDetails> mapAttachmentDetailsByName = getMapAttachmentDetails(lstAttachmentDetails);

        Map<String, Attachment> mapAttachmentByName = getAttachments(sObj, mapAttachmentDetailsByName.keySet());

        if(mapAttachmentByName.containsKey('Resolution details')) {

            obj.hunkDetails = (INX.Hunk) JSON.deserialize(mapAttachmentByName.get('Resolution details').Body.toString(), INX.Hunk.class);
        }
    }

    public static void getZipAttachments(String recordId, Long timeStamp, List<String> lstAttachmentId) {

        String filename = String.valueOf(timeStamp) + '.zip';

        for(Attachment sObjAttachment : [
            SELECT
                Id
            FROM Attachment
            WHERE
                ParentId = :recordId AND
                Name = :filename
        ]) {
            lstAttachmentId.add(sObjAttachment.Id);
        }
    }

    public static Map<String, Attachment> getAttachments(SObject sObjParent, Set<String> setName) {

        Map<String, Attachment> mapAttachmentByName = new Map<String, Attachment>();

        for(Attachment sObj : [
            SELECT
                ParentID,
                Name,
                Body
            FROM Attachment
            WHERE
                ParentID = :sObjParent.Id AND
                Name IN :setName
        ]) {

            mapAttachmentByName.put(sObj.Name, sObj);
        }

        return mapAttachmentByName;
    }

    public static Map<String, INX.AttachmentDetails> getMapAttachmentDetails(List<INX.AttachmentDetails> lstAttachmentDetails) {

        Map<String, INX.AttachmentDetails> mapAttachmentDetailsByName = new Map<String, INX.AttachmentDetails>();

        for(INX.AttachmentDetails objAttachmentDetails : lstAttachmentDetails) {

            mapAttachmentDetailsByName.put(objAttachmentDetails.name, objAttachmentDetails);
        }

        return mapAttachmentDetailsByName;
    }

    public static String getUUID() {

        Blob b = Crypto.GenerateAESKey(128);
        String h = EncodingUtil.ConvertTohex(b);
        return h.SubString(0,8)+ '-' + h.SubString(8,12) + '-' + h.SubString(12,16) + '-' + h.SubString(16,20) + '-' + h.substring(20);
    }
}