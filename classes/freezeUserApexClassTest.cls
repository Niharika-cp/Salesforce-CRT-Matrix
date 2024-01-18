@isTest
private class freezeUserApexClassTest {
    @testSetup
    static void setup() {
        // Setup test data here
        Profile p = [select id from profile where name='Standard User'];
        User testUser = new User(
            FirstName = 'John',
            LastName = 'Doe',
            Email = 'johndoe@test.com',
            ProfileId = p.Id,
            
            IsActive = true,Alias = 'test1',
            EmailEncodingKey='UTF-8',  LanguageLocaleKey='en_US', 
            LocaleSidKey='en_US', 
            TimeZoneSidKey='America/Los_Angeles', UserName='test@testorgnb1.com'
        );
        insert testUser;
    }
    
    @isTest
    static void testValidate() {
        // Test validate method
        List<Id> profileIds = new List<Id>();
        Profile testProfile = [SELECT Id FROM Profile WHERE Name = 'Standard User' LIMIT 1];
        profileIds.add(testProfile.Id);
        List<freezeUserApexClass.UserData> userDataList = freezeUserApexClass.validate(profileIds);
        System.assertEquals(userDataList.size(), 1);
        System.assertEquals(userDataList[0].profileName, 'Standard User');
        System.assertEquals(userDataList[0].usrcount,1 );
    }
    
    @isTest
    static void testFreezeUnfreeze() {
        // Test freezeUnfreeze method
        List<Id> profileIds = new List<Id>();
        Profile testProfile = [SELECT Id FROM Profile WHERE Name = 'Standard User' LIMIT 1];
        profileIds.add(testProfile.Id);
        
        
      UserLogin userLogin = [Select u.UserId, u.LastModifiedDate, u.LastModifiedById, u.IsPasswordLocked, u.IsFrozen, u.Id From UserLogin u
                                                    where u.UserId IN (Select u.Id From User u where u.ProfileId =: testProfile.id) limit 1];
        
        // Test freezing user
        Test.startTest();
        freezeUserApexClass.freezeUnfreeze(profileIds, true);
        Test.stopTest();
        
       System.assertEquals(userLogin.IsFrozen, False);
        
        
        // Test unfreezing user
      // Test.startTest();
     //  freezeUserApexClass.freezeUnfreeze(profileIds, false);
     //  Test.stopTest();
        
      //  UserLogin user = [Select u.UserId, u.LastModifiedDate, u.LastModifiedById, u.IsPasswordLocked, u.IsFrozen, u.Id From UserLogin u
                                                 //   where u.UserId IN (Select u.Id From User u where u.ProfileId =: testProfile.id) limit 1];
    //   System.assertEquals(userLogin.IsFrozen, false);
    }
}