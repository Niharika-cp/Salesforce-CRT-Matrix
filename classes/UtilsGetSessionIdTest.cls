@isTest
private class UtilsGetSessionIdTest {
    
    @isTest
    static void testGetSessionIdFromVFPage() {
        PageReference page = New PageReference('https://cloudfulcrum--copadodev--c.sandbox.vf.force.com/apex/GetSessionId');
        String s = UtilsGetSessionId.getSessionIdFromVFPage(page);
		String check = UserInfo.getSessionId().subString(15);
        Assert.areEqual(s.subString(0,5), check.subString(0,5));
    }
}