public inherited sharing class INX_TagSelector {

    public final static List<String> lstFields = new List<String> {
        'INX_Created_Date__c',
        'INX_Description__c',
        'INX_Id__c',
        'INX_Instance__c',
        'INX_Instance__r.Name',
        'INX_Last_Modified_Date__c',
        'INX_Version__c',
        'Name'
    };

    public static INX_Tag__c getTagByName(String strName) {

        List<INX_Tag__c> lstTag = Database.query(
            String.format(
                'SELECT {0} FROM {1} WHERE Name = :strName',
                new List<Object> {
                    String.join(lstFields, ','),
                    'INX_Tag__c'
                }
            )
        );

        if(lstTag.isEmpty()) { return null; }

        return lstTag[0];
    }
}