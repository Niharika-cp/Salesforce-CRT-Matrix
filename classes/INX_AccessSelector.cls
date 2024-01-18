public inherited sharing class INX_AccessSelector {

    public final static List<String> lstFields = new List<String> {
        'INX_Can_Commit__c',
        'INX_Can_Deploy__c',
        'INX_Email__c',
        'INX_Instance__c',
        'INX_Can_Manage__c',
        'INX_Can_Promote__c',
        'INX_Can_Read__c',
        'INX_Is_Locked__c',
        'LastModifiedDate'
    };

    public static List<INX_Access__c> getAccessesByEmail(String strEmail) {

        return Database.query(
            String.format(
                'SELECT {0} FROM {1} WHERE INX_Email__c = :strEmail ORDER BY INX_Instance__c NULLS FIRST',
                new List<Object> {
                    String.join(lstFields, ','),
                    'INX_Access__c'
                }
            )
        );
    }

    public static INX_Access__c getAccess(String strEmail, String strInstance) {

        return Database.query(
            String.format(
                'SELECT {0} FROM {1} WHERE INX_Email__c = :strEmail AND INX_Instance__c = :strInstance',
                new List<Object> {
                    String.join(lstFields, ','),
                    'INX_Access__c'
                }
            )
        );
    }

    public static List<INX_Access__c> getWorkspaceAccesses() {

        return Database.query(
            String.format(
                'SELECT {0} FROM {1} WHERE INX_Instance__c = null ORDER BY INX_Email__c',
                new List<Object> {
                    String.join(lstFields, ','),
                    'INX_Access__c'
                }
            )
        );
    }

    public static List<INX_Access__c> getInstanceAccesses(String strInstance) {

        return Database.query(
            String.format(
                'SELECT {0} FROM {1} WHERE INX_Instance__c = :strInstance',
                new List<Object> {
                    String.join(lstFields, ','),
                    'INX_Access__c'
                }
            )
        );
    }
}