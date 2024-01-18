public with sharing class newFreezeUserApxClass {
    public newFreezeUserApxClass() {

    }

    @AuraEnabled(cacheable=true)
    public static List<Profile> FetchActiveProfiles(){
        try {
            return [SELECT Id, Name FROM Profile where Name <> 'System Administrator'];
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    @AuraEnabled(cacheable=true)
    public static List<User> FetchAllUser(){
        try {
            return [SELECT Id, Name FROM User WHERE IsActive = TRUE];
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    @AuraEnabled
   public static List<User> searchKey(String searchKey ){

            try {
                List<User> userList = new List<User>();
                
                for(User userObj:[SELECT Id, Name FROM User WHERE IsActive = TRUE]){
                    
                    if (userObj.Name != null && userObj.Name.toLowerCase().contains(searchKey.toLowerCase())) {
                        // Add the account to the matching accounts list if its name contains the nameText parameter
                        userList.add(userObj);
                    }
                }

                return userList;
                
            } catch (Exception e) {
                throw new AuraHandledException(e.getMessage());
            }
     }
     
}