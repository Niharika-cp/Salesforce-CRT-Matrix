public inherited sharing class INX_PackageSelector {

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

    public static INX_Package__c getPackageByName(String strName) {

        List<INX_Package__c> lstPackage = Database.query(
            String.format(
                'SELECT {0} FROM {1} WHERE Name = :strName',
                new List<Object> {
                    String.join(lstFields, ','),
                    'INX_Package__c'
                }
            )
        );

        if(lstPackage.isEmpty()) { return null; }

        return lstPackage[0];
    }

    public static List<INX_Package__c> getPackagesByName(Set<String> setNames) {

        return Database.query(
            String.format(
                'SELECT {0} FROM {1} WHERE Name IN :setNames',
                new List<Object> {
                    String.join(lstFields, ','),
                    'INX_Package__c'
                }
            )
        );
    }
}