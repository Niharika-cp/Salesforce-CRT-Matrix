public inherited sharing class INX_ActivityDomain {

    public static void handleGet() {

        String strRequestURI = RestContext.request.requestURI;

        Map<String, String> mapParams = INX_Utility.decodeParameters(RestContext.request.params);

        String uri = strRequestURI;

        String params = JSON.serializePretty(mapParams);

        if(mapParams.isEmpty()) {

            INX_Activity__c sObj = getActivity();

            INX.Activity objActivity = new INX.Activity(sObj);

            switch on objActivity.type {
                when 'package' {

                    objActivity.packageInfo = INX_PackageDomain.getPackageInfoByName(objActivity.name);
                }
                when 'tag' {

                    objActivity.tagInfo = INX_TagDomain.getTagInfoByName(objActivity.name);
                }
                when 'instance' {

                    objActivity.instanceInfo = INX_InstanceDomain.getInstanceInfoByName(objActivity.instance);
                }
                when 'repository' {

                    objActivity.repositoryInfo = INX_RepositoryDomain.getRepositoryInfoByName(objActivity.repository);
                }
                when 'deployment' {

                    objActivity.deploymentInfo = INX_DeploymentDomain.getDeploymentInfoByTypeNameInstance(objActivity.subType, objActivity.name, objActivity.instance);

                    if(
                        !(
                            'created'.equals(objActivity.action) ||
                            'updated'.equals(objActivity.action)
                        )
                    ) {
                        INX.Deployment deploymentInfo = objActivity.deploymentInfo;

                        deploymentInfo.attachments = new List<String>();

                        INX_Utility.getZipAttachments(deploymentInfo.remoteId, objActivity.activityDate.getTime(), deploymentInfo.attachments);
                    }
                }
                when 'resolution' {

                    objActivity.resolutionInfo = INX_ResolutionDomain.getResolutionInfoByHash(objActivity.repository, objActivity.hash);
                }
            }

            RestContext.response.responseBody = Blob.valueOf(JSON.serialize(objActivity, true));

        } else {

            if(mapParams.containsKey('email')) {

                String strEmail = '';
                String strAfterId = '';
                Decimal dDatetime = null;

                if(mapParams.containsKey('email')) {

                    strEmail = mapParams.get('email');

                } else {

                    throw new INX.ApplicationException(400, 'Missing parameter: email');
                }

                if(mapParams.containsKey('afterId')) {

                    strAfterId = mapParams.get('afterId');
                }

                if(mapParams.containsKey('datetime')) {

                    dDatetime = Decimal.valueOf(mapParams.get('datetime'));
                }

                List<String> lstInstanceNames = INX_AccessDomain.getInstancesForAccessType(strEmail, INX.AccessType.CANREAD);

                lstInstanceNames.add(null);

                INX.ActivityResponse objActivityResponse;

                if(dDatetime != null) {

                    objActivityResponse = getActivities(lstInstanceNames, dDatetime);

                } else if(String.isNotBlank(strAfterId)) {

                    objActivityResponse = getActivities(lstInstanceNames, strAfterId);

                } else {

                    objActivityResponse = getActivities(lstInstanceNames);
                }

                RestContext.response.responseBody = Blob.valueOf(JSON.serialize(objActivityResponse, true));

            } else {

                INX.Activity objActivity = new INX.Activity();
                objActivity.type = mapParams.get('type');
                objActivity.subType = mapParams.get('subType');
                objActivity.name = mapParams.get('name');
                objActivity.instance = mapParams.get('instance');
                objActivity.repository = mapParams.get('repository');
                objActivity.hash = mapParams.get('hash');

                Integer intLimit = null;

                if(mapParams.containsKey('limit')) {

                    intLimit = Integer.valueOf(mapParams.get('limit'));
                }

                RestContext.response.responseBody = Blob.valueOf(JSON.serialize(INX.getSObjectList(INX_ActivitySelector.getActivities(objActivity, intLimit))));
            }
        }
    }

    public static void handleBulkGet() {

        String strRequestBody = RestContext.request.requestBody.toString();

        List<String> lstPackages = (List<String>) JSON.deserialize(strRequestBody, List<String>.class);

        RestContext.response.responseBody = Blob.valueOf(JSON.serialize(INX.getSObjectList(INX_ActivitySelector.getActivitiesForPackages(lstPackages))));
    }

    public static void handleCreateUpdate() {

        String strRequestBody = RestContext.request.requestBody.toString();

        INX.Activity objActivity = (INX.Activity) JSON.deserialize(strRequestBody, INX.Activity.class);

        switch on (objActivity.type) {
			when 'package' {

                if('deleted'.equals(objActivity.action)) {

                    INX_PackageDomain.deletePackage(objActivity.name);

                } else {

                    INX_PackageDomain.createUpdate(objActivity.packageInfo);
                }
            }
			when 'tag' {

                if('deleted'.equals(objActivity.action)) {

                    INX_TagDomain.deleteTag(objActivity.name);

                } else {

                    INX_TagDomain.createUpdate(objActivity.tagInfo);
                }

            }
            when 'instance' {

                INX_InstanceDomain.createUpdate(objActivity.instanceInfo);
            }
            when 'repository' {

                INX_RepositoryDomain.createUpdate(objActivity.repositoryInfo);
            }
            when 'deployment' {

                INX_DeploymentDomain.createUpdate(objActivity.deploymentInfo);
            }
            when 'review' {

                INX_ReviewDomain.createUpdate(new INX.Review(objActivity));
            }
			when 'resolution' {

                INX_ResolutionDomain.createUpdate(objActivity.resolutionInfo);
            }
		}

        INX_Activity__c sObj = objActivity.getSObject();

        if(String.isNotBlank(objActivity.instance)) {

            INX_Instance__c sObjInstance = INX_InstanceSelector.getInstanceByName(objActivity.instance);

            sObj.INX_Instance__c = sObjInstance == null ? null : sObjInstance.Id;
        }

        if(String.isNotBlank(objActivity.repository)) {

            INX_Repository__c sObjRepository = INX_RepositorySelector.getRepositoryByName(objActivity.repository);

            sObj.INX_Repository__c = sObjRepository == null ? null : sObjRepository.Id;
        }

        if(
            (
                objActivity.type == 'package' ||
                objActivity.type == 'commit' ||
                objActivity.type == 'review' ||
                (
                    objActivity.type == 'deployment' &&
                    objActivity.subType == 'package'
                ) ||
                (
                    objActivity.type == 'promote' &&
                    objActivity.subType == 'package'
                )
            ) &&
            String.isNotBlank(objActivity.name)
        ) {

            INX_Package__c sObjPackage = INX_PackageSelector.getPackageByName(objActivity.name);

            sObj.INX_Package__c = sObjPackage == null ? null : sObjPackage.Id;
        }

        if(
            (
                objActivity.type == 'tag' ||
                (
                    objActivity.type == 'deployment' &&
                    objActivity.subType == 'tag'
                ) ||
                (
                    objActivity.type == 'promote' &&
                    objActivity.subType == 'tag'
                )
            ) &&
            String.isNotBlank(objActivity.name)
        ) {

            INX_Tag__c sObjTag = INX_TagSelector.getTagByName(objActivity.name);

            sObj.INX_Tag__c = sObjTag == null ? null : sObjTag.Id;
        }

        if(objActivity.type == 'tag' && String.isNotBlank(objActivity.source)) {

            INX_Package__c sObjPackage = INX_PackageSelector.getPackageByName(objActivity.source);

            sObj.INX_Package__c = sObjPackage == null ? null : sObjPackage.Id;
        }

        if(
            objActivity.type == 'deployment' &&
            String.isNotBlank(objActivity.subType) &&
            String.isNotBlank(objActivity.name) &&
            String.isNotBlank(objActivity.instance)
        ) {

            INX_Deployment__c sObjDeployment = INX_DeploymentSelector.getDeploymentByTypeNameInstance(objActivity.subType, objActivity.name, objActivity.instance);

            sObj.INX_Deployment__c = sObjDeployment == null ? null : sObjDeployment.Id;
        }

        upsert sObj INX_Id__c;

        objActivity.remoteId = sObj.Id;

        RestContext.response.responseBody = Blob.valueOf(JSON.serialize(objActivity, true));

        Eventbus.publish(objActivity.getEvent());
    }

    public static INX_Activity__c getActivity() {

        String strRequestURI = RestContext.request.requestURI;

        String[] strURIInfo = strRequestURI.split('/');

        String strId = strURIInfo[strURIInfo.size() - 1];

        return INX_ActivitySelector.getActivityById(strId);
    }

    public static INX.ActivityResponse getActivities(List<String> lstInstanceNames, Decimal dDatetime) {

        INX.ActivityResponse response = new INX.ActivityResponse();

        response.size = INX_ActivitySelector.getActivitiesCount(lstInstanceNames, dDatetime);
        response.activities = INX.getSObjectList(INX_ActivitySelector.getActivities(lstInstanceNames, dDatetime));

        return response;
    }

    public static INX.ActivityResponse getActivities(List<String> lstInstanceNames, String strAfterId) {

        INX.ActivityResponse response = new INX.ActivityResponse();

        response.size = INX_ActivitySelector.getActivitiesCount(lstInstanceNames, strAfterId);
        response.activities = INX.getSObjectList(INX_ActivitySelector.getActivities(lstInstanceNames, strAfterId));

        return response;
    }

    public static INX.ActivityResponse getActivities(List<String> lstInstanceNames) {

        INX.ActivityResponse response = new INX.ActivityResponse();

        response.size = INX_ActivitySelector.getActivitiesCount(lstInstanceNames);
        response.activities = INX.getSObjectList(INX_ActivitySelector.getActivities(lstInstanceNames));

        return response;
    }
}