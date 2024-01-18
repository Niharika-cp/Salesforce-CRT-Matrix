public inherited sharing class INX_Domain {

    public static void handleAbout() {

        RestContext.response.responseBody = Blob.valueOf(JSON.serialize(new INX.About(), true));
    }

    public static void handleCheckExisting() {

        Map<String, String> mapParams = INX_Utility.decodeParameters(RestContext.request.params);

        if(!mapParams.containsKey('type')) {
            throw new INX.ApplicationException(400, 'Missing parameter: type');
        }
        if(!mapParams.containsKey('name')) {
            throw new INX.ApplicationException(400, 'Missing parameter: name');
        }

        String type = mapParams.get('type');
        String name = mapParams.get('name');
        String subType = mapParams.get('subType');
        String instance = mapParams.get('instance');

        List<String> lstConditions = new List<String>();

        if(String.isNotBlank(name)) {
            lstConditions.add('Name = :name');
        }

        if(String.isNotBlank(subType)) {
            lstConditions.add('INX_Type__c = :subType');
        }

        if(String.isNotBlank(instance)) {
            lstConditions.add('INX_Instance__r.Name = :instance');
        }

        if(!INX.TABLEMAPPING.containsKey(type)) {
            throw new INX.ApplicationException(400, String.format('Type not supported: {0}', new List<Object> {type}));
        }

        String strSObjectName = INX.TABLEMAPPING.get(type);

        try {
            SObject sObj = Database.query(
                String.format(
                    'SELECT Id, INX_Id__c, Name FROM {0} WHERE ' + String.join(lstConditions, ' AND '),
                    new List<Object> {strSObjectName}
                )
            );
            RestContext.response.responseBody = Blob.valueOf(JSON.serialize(sObj, true));

        } catch (QueryException ex) {
            throw new INX.ApplicationException(404, 'Not found', ex);
        }
    }
}