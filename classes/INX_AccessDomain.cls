public inherited sharing class INX_AccessDomain {

    public static void handleGet() {

        INX.AccessResponse objAccessResponse = new INX.AccessResponse();

        Map<String, String> mapParams = INX_Utility.decodeParameters(RestContext.request.params);

        String strEmail = '';
        String strInstance = '';

        if(mapParams.containsKey('email')) {
            strEmail = mapParams.get('email');
        }

        if(mapParams.containsKey('instance')) {
            strInstance = mapParams.get('instance');
        }

        if(String.isBlank(strEmail) && String.isBlank(strInstance)) {
            throw new INX.ApplicationException(400, 'You must pass email, instance or both as parameters');
        }

        List<INX_Instance__c> lstInstance = INX_InstanceSelector.getInstances();

        List<String> lstInstanceNames = new List<String>();
        for(INX_Instance__c sObj: lstInstance) {
            lstInstanceNames.add(sObj.Name);
        }

        List<INX_Access__c> lstFinalAccess = new List<INX_Access__c>();

        if(String.isBlank(strEmail)) {

            List<INX_Access__c> lstAccess = INX_AccessSelector.getWorkspaceAccesses();

            List<String> lstEmail = new List<String>();
            Map<String, INX_Access__c> mapWorkspaceAccessbyEmail = new Map<String, INX_Access__c>();

            for(INX_Access__c sObj : lstAccess) {

                lstEmail.add(sObj.INX_Email__c);
                mapWorkspaceAccessbyEmail.put(sObj.INX_Email__c, sObj);
            }

            Map<String, INX_Access__c> mapInstanceAccessbyEmail = new Map<String, INX_Access__c>();

            for(INX_Access__c sObj : INX_AccessSelector.getInstanceAccesses(strInstance)) {

                mapInstanceAccessbyEmail.put(sObj.INX_Email__c, sObj);
            }

            for(String strEmailAddress : lstEmail) {

                INX_Access__c sObjWorkspaceAccess = mapWorkspaceAccessbyEmail.get(strEmailAddress);
                INX_Access__c sObjInstanceAccess;

                if(sObjWorkspaceAccess.INX_Can_Manage__c) {

                    sObjInstanceAccess = INX.getCanManageAccessSettings();
                    sObjInstanceAccess.INX_Email__c = strEmailAddress;
                    sObjInstanceAccess.INX_Instance__c = strInstance;
                    lstFinalAccess.add(sObjInstanceAccess);

                } else {

                    if(mapInstanceAccessbyEmail.containsKey(strEmailAddress)) {

                        sObjInstanceAccess = mapInstanceAccessbyEmail.get(strEmailAddress);
                        lstFinalAccess.add(sObjInstanceAccess);

                    } else {

                        sObjInstanceAccess = INX.getNoAccessSettings();
                        sObjInstanceAccess.INX_Email__c = strEmailAddress;
                        sObjInstanceAccess.INX_Instance__c = strInstance;
                        lstFinalAccess.add(sObjInstanceAccess);
                    }
                }
            }

        } else {

            List<INX_Access__c> lstAccess = INX_AccessSelector.getAccessesByEmail(strEmail);

            if(lstAccess.isEmpty()) {

                throw new INX.ApplicationException(400, 'No access');

            } else {

                INX_Access__c sObjWorkspaceAccess = lstAccess[0];
                INX_Access__c sObjInstanceAccess;

                if(String.isNotBlank(sObjWorkspaceAccess.INX_Instance__c)) {
                    throw new INX.ApplicationException(400, 'No access');
                }

                objAccessResponse.lastModifiedDate = INX_Utility.getMax(objAccessResponse.lastModifiedDate, sObjWorkspaceAccess.LastModifiedDate);

                if(sObjWorkspaceAccess.INX_Can_Manage__c) {

                    if(String.isNotBlank(strInstance)) {

                        if(lstInstanceNames.contains(strInstance)) {

                            sObjInstanceAccess = INX.getCanManageAccessSettings();
                            sObjInstanceAccess.INX_Email__c = strEmail;
                            sObjInstanceAccess.INX_Instance__c = strInstance;
                            lstFinalAccess.add(sObjInstanceAccess);

                        } else {
                            throw new INX.ApplicationException(400, 'Can\'t find an instance with this name');
                        }

                    } else {

                        lstFinalAccess.add(lstAccess[0]);

                        for(String strInstanceName : lstInstanceNames) {
                            sObjInstanceAccess = INX.getCanManageAccessSettings();
                            sObjInstanceAccess.INX_Email__c = strEmail;
                            sObjInstanceAccess.INX_Instance__c = strInstanceName;
                            lstFinalAccess.add(sObjInstanceAccess);
                        }
                    }

                } else {

                    Map<String, INX_Access__c> mapAccessByInstance = new Map<String, INX_Access__c>();

                    for(INX_Access__c sObj : lstAccess) {

                        if(String.isNotBlank(sObj.INX_Instance__c)) {
                            mapAccessByInstance.put(sObj.INX_Instance__c, sObj);
                        }
                    }

                    if(String.isNotBlank(strInstance)) {

                        if(lstInstanceNames.contains(strInstance)) {

                            if(mapAccessByInstance.containsKey(strInstance)) {

                                INX_Access__c sObjAccess = mapAccessByInstance.get(strInstance);

                                objAccessResponse.lastModifiedDate = INX_Utility.getMax(objAccessResponse.lastModifiedDate, sObjAccess.LastModifiedDate);

                                lstFinalAccess.add(sObjAccess);

                            } else {

                                sObjInstanceAccess = INX.getNoAccessSettings();
                                sObjInstanceAccess.INX_Email__c = strEmail;
                                sObjInstanceAccess.INX_Instance__c = strInstance;
                                lstFinalAccess.add(sObjInstanceAccess);
                            }

                        } else {
                            throw new INX.ApplicationException(400, 'Can\'t find an instance with this name');
                        }

                    } else {

                        lstFinalAccess.add(lstAccess[0]);

                        for(String strInstanceName : lstInstanceNames) {

                            if(mapAccessByInstance.containsKey(strInstanceName)) {

                                INX_Access__c sObjAccess = mapAccessByInstance.get(strInstanceName);

                                objAccessResponse.lastModifiedDate = INX_Utility.getMax(objAccessResponse.lastModifiedDate, sObjAccess.LastModifiedDate);

                                lstFinalAccess.add(sObjAccess);

                            } else {

                                sObjInstanceAccess = INX.getNoAccessSettings();
                                sObjInstanceAccess.INX_Email__c = strEmail;
                                sObjInstanceAccess.INX_Instance__c = strInstanceName;
                                lstFinalAccess.add(sObjInstanceAccess);
                            }
                        }
                    }
                }
            }
        }

        objAccessResponse.accesses = INX.getSObjectList(lstFinalAccess);

        RestContext.response.responseBody = Blob.valueOf(JSON.serialize(objAccessResponse, true));

    }

    public static void handleCreateUpdate() {

        String strRequestBody = RestContext.request.requestBody.toString();

        INX.Access objAccess = (INX.Access) JSON.deserialize(strRequestBody, INX.Access.class);

        INX_Access__c sObj = objAccess.getSObject();
        sObj.INX_Id__c = String.isBlank(sObj.INX_Instance__c) ? sObj.INX_Email__c : (sObj.INX_Email__c + '-' + sObj.INX_Instance__c);

        upsert sObj INX_Id__c;

        RestContext.response.responseBody = Blob.valueOf(JSON.serialize(new INX.Access(sObj), true));

        INX.Activity objActivity = new INX.Activity();
        objActivity.id = INX_Utility.getUUID();
        objActivity.type = 'access';
        objActivity.email = sObj.INX_Email__c;
        objActivity.instance = sObj.INX_Instance__c;
        objActivity.activityDate = System.now();

        Eventbus.publish(objActivity.getEvent());
    }

    public static void handleDelete() {

        Map<String, String> mapParams = INX_Utility.decodeParameters(RestContext.request.params);

        String strEmail = '';
        String strInstance = null;

        if(mapParams.containsKey('email')) {
            strEmail = mapParams.get('email');
        } else {
            throw new INX.ApplicationException(400, 'Missing parameter: email');
        }

        if(mapParams.containsKey('instance')) {
            strInstance = mapParams.get('instance');
        }

        delete INX_AccessSelector.getAccess(strEmail, strInstance);

    }

    public static List<String> getInstancesForAccessType(String strEmail, INX.AccessType accessType) {

        List<INX_Access__c> lstAccess = INX_AccessSelector.getAccessesByEmail(strEmail);
        List<INX_Instance__c> lstInstance = INX_InstanceSelector.getInstances();

        List<String> lstInstanceNames = new List<String>();
        List<String> lstFinalInstanceNames = new List<String>();

        for(INX_Instance__c sObj: lstInstance) {
            lstInstanceNames.add(sObj.Name);
        }

        if(lstAccess.isEmpty()) {

            throw new INX.ApplicationException(400, 'No access');

        } else {

            INX_Access__c sObjWorkspaceAccess = lstAccess[0];
            INX_Access__c sObjInstanceAccess;

            if(String.isNotBlank(sObjWorkspaceAccess.INX_Instance__c)) {
                throw new INX.ApplicationException(400, 'No access');
            }

            if(sObjWorkspaceAccess.INX_Can_Manage__c) {

                lstFinalInstanceNames.addAll(lstInstanceNames);

            } else {

                Map<String, INX_Access__c> mapAccessByInstance = new Map<String, INX_Access__c>();

                for(INX_Access__c sObj : lstAccess) {

                    if(String.isNotBlank(sObj.INX_Instance__c)) {
                        mapAccessByInstance.put(sObj.INX_Instance__c, sObj);
                    }
                }

                for(String strInstanceName : lstInstanceNames) {

                    if(mapAccessByInstance.containsKey(strInstanceName)) {

                        INX_Access__c sObj = mapAccessByInstance.get(strInstanceName);

                        if(
                            ( accessType == INX.AccessType.CANREAD && sObj.INX_Can_Read__c ) ||
                            ( accessType == INX.AccessType.CANCOMMIT && sObj.INX_Can_Commit__c ) ||
                            ( accessType == INX.AccessType.CANDEPLOY && sObj.INX_Can_Deploy__c ) ||
                            ( accessType == INX.AccessType.CANMANAGE && sObj.INX_Can_Manage__c ) ||
                            ( accessType == INX.AccessType.CANPROMTE && sObj.INX_Can_Promote__c )
                        ) {
                            lstFinalInstanceNames.add(strInstanceName);
                        }
                    }
                }
            }
        }

        return lstFinalInstanceNames;

    }
}