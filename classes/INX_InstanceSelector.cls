public inherited sharing class INX_InstanceSelector {

    public final static List<String> lstFields = new List<String> {
        'Name',
        'INX_Endpoint__c',
        'INX_Id__c',
        'INX_Is_Active__c',
        'INX_OrgId__c',
        'INX_Version__c',
        'INX_Username__c',
        'INX_Credentials__c',
        'INX_Share_Credentials__c',
        'INX_Parent__c',
        'INX_Parent__r.Name',
        'INX_Repository__c',
        'INX_Repository__r.Name',
        'INX_Branch__c',
        'INX_Deployment_Settings__c',
        'INX_Promote_Settings__c',
        'INX_Jira_Settings__c'
    };

    public static List<INX_Instance__c> getInstances() {

        return Database.query(
            String.format(
                'SELECT {0} FROM {1} ORDER BY Name',
                new List<Object> {
                    String.join(lstFields, ','),
                    'INX_Instance__c'
                }
            )
        );
    }

    public static INX_Instance__c getInstanceByName(String strName) {

        List<INX_Instance__c> lstInstance = Database.query(
            String.format(
                'SELECT {0} FROM {1} WHERE Name = :strName',
                new List<Object> {
                    String.join(lstFields, ','),
                    'INX_Instance__c'
                }
            )
        );

        if(lstInstance.isEmpty()) { return null; }

        return lstInstance[0];
    }
}