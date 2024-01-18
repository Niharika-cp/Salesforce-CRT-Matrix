public inherited sharing class INX_Tag_LinkSelector {

    public final static List<String> lstFields = new List<String> {
        'INX_Created_Date__c',
        'INX_Id__c',
        'INX_Package__c',
        'INX_Package__r.Name',
        'INX_Tag__c',
        'INX_Tag__r.Name'
    };

    public static List<INX_Tag_Link__c> getPackagesForTag(String strTag) {

        return Database.query(
            String.format(
                'SELECT {0} FROM {1} WHERE INX_Tag__r.Name = :strTag ORDER BY INX_Created_Date__c',
                new List<Object> {
                    String.join(lstFields, ','),
                    'INX_Tag_Link__c'
                }
            )
        );
    }
}