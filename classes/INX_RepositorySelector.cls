public inherited sharing class INX_RepositorySelector {

    public final static List<String> lstFields = new List<String> {
        'Name',
        'INX_Id__c',
        'INX_Remote__c',
        'INX_Origin__c',
        'INX_Needs_Review__c',
        'INX_Main_Branch__c',
        'INX_Source_Path__c',
        'INX_Format__c',
        'INX_Is_Active__c'
    };

    public static INX_Repository__c getRepositoryByName(String strName) {

        List<INX_Repository__c> lstRepository = Database.query(
            String.format(
                'SELECT {0} FROM {1} WHERE Name = :strName',
                new List<Object> {
                    String.join(lstFields, ','),
                    'INX_Repository__c'
                }
            )
        );

        if(lstRepository.isEmpty()) { return null; }

        return lstRepository[0];
    }
}