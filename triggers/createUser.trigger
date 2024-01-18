trigger createUser on User (before insert) {
    Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator'];
    for(User T : trigger.new){
        if(UserInfo.getProfileId() != p.Id){
            t.adderror('Only System Administrators can create new users.');
        }
    }

}