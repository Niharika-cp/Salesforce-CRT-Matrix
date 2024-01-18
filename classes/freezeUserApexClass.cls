public with sharing class freezeUserApexClass {
    

        @AuraEnabled
        public static List<UserData> validate( List<Id> profileId){
            system.debug('profileName ='+profileId);
            
            Map<String, List<user>> prusrlist = new Map<String, List<user>>();
            List<UserData> userDataList = new List<UserData>();
            for(User u:[SELECT Id, Name,IsActive, ProfileId,Profile.Name FROM User WHERE ProfileId IN :profileId And IsActive = true]){
                List<user> usrcnt = new List<user>();
                if(prusrlist.containsKey(u.Profile.Name)){
                    usrcnt = prusrlist.get(u.Profile.Name);
                    
                }
                usrcnt.add(u);
                prusrlist.put(u.Profile.Name,usrcnt);

            }
            for (String prfl : prusrlist.keySet()) {
                UserData ud = new UserData();
                ud.profileName = prfl;
                ud.usrcount = prusrlist.get(prfl).size();
                userDataList.add(ud);
            }
            return userDataList;
      }
            
        

        @AuraEnabled
        public static void freezeUnfreeze(List<Id> profileId, Boolean freeze){
            Integer countProcessed = 0;

            for(Profile p:[select Id, Name from Profile where Id IN: profileId]){
                system.debug('Profile Size======  '+p);


                if(p.Name == 'System Administrator'){
                    p.addError('System Administrator Profile cannot be processed.');
                    system.debug('System Administrator Profile cannot be processed.');
                }else{
                        for(List<UserLogin> uls : [Select u.UserId, u.LastModifiedDate, u.LastModifiedById, u.IsPasswordLocked, u.IsFrozen, u.Id From UserLogin u
                                                    where u.UserId IN (Select u.Id From User u where u.ProfileId =: p.id)])
                        {
                            for(UserLogin u : uls){
                                u.IsFrozen = freeze;
                            }
                            update uls;
                            countProcessed += uls.size();                               
                        }
                        
                    }
            }
        }


        public class UserData {
            @AuraEnabled public String userName;
            @AuraEnabled public String profileName;
            @AuraEnabled public Boolean isActive;
            @AuraEnabled public Integer usrcount;
        }

        }