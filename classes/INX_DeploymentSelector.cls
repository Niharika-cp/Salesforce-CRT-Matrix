public with sharing class INX_DeploymentSelector {

    public final static List<String> lstFields = new List<String> {
        'INX_Created_Date__c',
        'INX_Id__c',
        'INX_Instance__c',
        'INX_Instance__r.Name',
        'INX_Last_Modified_Date__c',
        'INX_Type__c',
        'Name'
    };

    public static INX_Deployment__c getDeploymentByTypeNameInstance(String strType, String strName, String strInstance) {

        List<INX_Deployment__c> lstDeployment = Database.query(
            String.format(
                'SELECT {0} FROM {1} WHERE INX_Type__c = :strType AND Name = :strName AND INX_Instance__r.Name = :strInstance',
                new List<Object> {
                    String.join(lstFields, ','),
                    'INX_Deployment__c'
                }
            )
        );

        if(lstDeployment.isEmpty()) { return null; }

        return lstDeployment[0];
    }

}