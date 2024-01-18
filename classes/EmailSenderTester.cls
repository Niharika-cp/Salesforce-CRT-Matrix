public class EmailSenderTester {
	public static void sendEmail() {
        
        String toAddress = 'vishnu.r@cloudfulfcrum.com';
		String subject = 'Hello from Salesforce';
		String body = 'This is a test email sent from Salesforce Apex.';

        // Create a new SingleEmailMessage object
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();

        // Set the recipient's email address (To address)
        mail.setToAddresses(new String[] {toAddress});

        // Set the email subject
        mail.setSubject(subject);

        // Set the email body
        mail.setPlainTextBody(body);
        
        // Send the email
        Messaging.SendEmailResult[] results = Messaging.sendEmail(new Messaging.SingleEmailMessage[]{ mail });

        // Check if the email was sent successfully
        if (results[0].isSuccess()) {
            System.debug('Email sent successfully.');
        } else {
            System.debug('Email sending failed: ' + results[0].getErrors()[0].getMessage());
        }
    }
}