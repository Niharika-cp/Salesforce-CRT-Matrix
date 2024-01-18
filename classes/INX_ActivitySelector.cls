public inherited sharing class INX_ActivitySelector {

    public final static List<String> lstFields = new List<String> {
        'INX_Action__c',
        'INX_Activity_Date__c',
        'INX_Activity_Timestamp__c',
        'INX_Id__c',
        'INX_Instance__c',
        'INX_Instance__r.Name',
        'INX_Repository__c',
        'INX_Repository__r.Name',
        'INX_Branch__c',
        'INX_Source_Branch__c',
        'INX_Close_Branch__c',
        'INX_Hash__c',
        'INX_Source__c',
        'INX_Message__c',
        'INX_Name__c',
        'INX_Sub_Type__c',
        'INX_Type__c',
        'INX_Email__c',
        'INX_Needs_Review__c',
        'INX_Package_Directory__c',
        'INX_Resolution__c'
    };

    public static INX_Activity__c getActivityById(String strId) {

        return Database.query(
            String.format(
                'SELECT {0} FROM {1} WHERE INX_Id__c = :strId',
                new List<Object> {
                    String.join(lstFields, ','),
                    'INX_Activity__c'
                }
            )
        );
    }

    public static List<INX_Activity__c> getActivities(List<String> lstInstanceNames, String strAfterId) {

        INX_Activity__c sObj = getActivityById(strAfterId);

        Decimal lastActivityDate = sObj.INX_Activity_Timestamp__c;

        return getActivities(lstInstanceNames, lastActivityDate);
    }

    public static List<INX_Activity__c> getActivities(List<String> lstInstanceNames, Decimal dDatetime) {

        return Database.query(
            String.format(
                'SELECT {0} FROM {1} WHERE INX_Instance__r.Name IN :lstInstanceNames AND INX_Activity_Timestamp__c >= :dDatetime ORDER BY INX_Activity_Timestamp__c LIMIT 1000',
                new List<Object> {
                    String.join(lstFields, ','),
                    'INX_Activity__c'
                }
            )
        );
    }

    public static List<INX_Activity__c> getActivities(List<String> lstInstanceNames) {

        return Database.query(
            String.format(
                'SELECT {0} FROM {1} WHERE INX_Instance__r.Name IN :lstInstanceNames ORDER BY INX_Activity_Timestamp__c LIMIT 1000',
                new List<Object> {
                    String.join(lstFields, ','),
                    'INX_Activity__c'
                }
            )
        );
    }

    public static List<INX_Activity__c> getActivities(INX.Activity objActivity, Integer intLimit) {

        String type = objActivity.type;
        String subType = objActivity.subType;
        String name = objActivity.name;
        String instance = objActivity.instance;
        String repository = objActivity.repository;
        String hash = objActivity.hash;

        List<String> lstConditions = new List<String>();

        List<String> lstTypes = new List<String>();
        lstTypes.add(type);

        if('package'.equals(type)) {
            lstTypes.add('commit');
            lstTypes.add('promote');
            lstTypes.add('review');
        }

        if(String.isNotBlank(type)) {
            lstConditions.add('INX_Type__c IN :lstTypes');
        }

        if(String.isNotBlank(subType)) {
            lstConditions.add('INX_Sub_Type__c = :subType');
        }

        if(String.isNotBlank(name)) {
            lstConditions.add('INX_Name__c = :name');
        }

        if(String.isNotBlank(instance)) {
            lstConditions.add('INX_Instance__r.Name = :instance');
        }

        if(String.isNotBlank(repository)) {
            lstConditions.add('INX_Repository__r.Name = :repository');
        }

        if(String.isNotBlank(hash)) {
            lstConditions.add('INX_Hash__c = :hash');
        }

        String query = String.format(
            'SELECT {0} FROM {1} WHERE (' + String.join(lstConditions, ' AND ') + ')',
            new List<Object> {
                String.join(lstFields, ','),
                'INX_Activity__c'
            }
        );

        query += ' ORDER BY INX_Activity_Timestamp__c';

        if(intLimit != null) {
            query += ' LIMIT ' + intLimit;
        }

        return Database.query(query);
    }

    public static List<INX_Activity__c> getActivitiesForPackages(List<String> lstPackages) {

        List<String> lstConditions = new List<String>();

        List<String> lstTypes = new List<String>();
        lstTypes.add('package');
        lstTypes.add('commit');
        lstTypes.add('promote');
        lstTypes.add('review');

        lstConditions.add('INX_Type__c IN :lstTypes');
        lstConditions.add('INX_Name__c IN :lstPackages');

        String query = String.format(
            'SELECT {0} FROM {1} WHERE (' + String.join(lstConditions, ' AND ') + ')',
            new List<Object> {
                String.join(lstFields, ','),
                'INX_Activity__c'
            }
        );

        query += ' ORDER BY INX_Activity_Timestamp__c';

        return Database.query(query);
    }

    public static Integer getActivitiesCount(List<String> lstInstanceNames, String strAfterId) {

        INX_Activity__c sObj = getActivityById(strAfterId);

        Decimal lastActivityDate = sObj.INX_Activity_Timestamp__c;

        return getActivitiesCount(lstInstanceNames, lastActivityDate);
    }

    public static Integer getActivitiesCount(List<String> lstInstanceNames, Decimal dDatetime) {

        AggregateResult results = Database.query(
            String.format(
                'SELECT count(Id) result FROM {0} WHERE INX_Instance__r.Name IN :lstInstanceNames AND INX_Activity_Timestamp__c >= :dDatetime',
                new List<Object> {
                    'INX_Activity__c'
                }
            )
        );

        return Integer.valueOf(results.get('result'));
    }

    public static Integer getActivitiesCount(List<String> lstInstanceNames) {

        AggregateResult results = Database.query(
            String.format(
                'SELECT count(Id) result FROM {0} WHERE INX_Instance__r.Name IN :lstInstanceNames',
                new List<Object> {
                    'INX_Activity__c'
                }
            )
        );

        return Integer.valueOf(results.get('result'));
    }
}