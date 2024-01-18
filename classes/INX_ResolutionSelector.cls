public inherited sharing class INX_ResolutionSelector {

    public final static List<String> lstFields = new List<String> {
        'INX_Email__c',
        'INX_File_Path__c',
        'INX_Hash__c',
        'INX_Id__c',
        'INX_Repository__c',
        'INX_Repository__r.Name'
    };

    public static INX_Resolution__c getResolutionByHash(String strRepository, String strHash) {

        List<INX_Resolution__c> lstResolution = Database.query(
            String.format(
                'SELECT {0} FROM {1} WHERE INX_Repository__c = :strRepository AND INX_Hash__c = :strHash',
                new List<Object> {
                    String.join(lstFields, ','),
                    'INX_Resolution__c'
                }
            )
        );

        if(lstResolution.isEmpty()) { return null; }

        return lstResolution[0];
    }
}