@isTest
public class SharedComponentEmailGenerationTest {

    @isTest static void testSendEmailWithSingleRecipient() {
        String s1 = SharedComponentEmailGeneration.sendEmail('test@example.com',null, null, null);
        Assert.areEqual(s1,'Success');
    }

    @isTest static void testSendEmailWithMultipleRecipients() {
        String s2 = SharedComponentEmailGeneration.sendEmail('primary@example.com,cc1@example.com,cc2@example.com',null, null, null);
        Assert.areEqual(s2,'Success');
    }

    @isTest static void testScheduleEmail() {
        String s3 = SharedComponentEmailGeneration.scheduleEmail('test@example.com', '0 0 1 * * ?', 'TestJob',null, null, null);
        Assert.areEqual(s3,'Success');
    }
}