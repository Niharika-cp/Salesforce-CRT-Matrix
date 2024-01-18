/* Author - Sai Teja
 **  Description : The SharedComponentEmailGeneration offers two main functionalities: sending an immediate email report and scheduling periodic email reports based on a specified cron expression. 
This class is likely utilized in a Salesforce Lightning component (SharedComponentMatrix). 
It Creates an email message with the generated PDF attached and sends it to the specified recipient(s).
*/

public class SharedComponentEmailGeneration {
    @AuraEnabled
    public static String sendEmail(string emailIds,Integer days, Date fromDt, Date toDt){
        PageReference pageRef = new PageReference('/apex/sharedComponentPage_v2?days='+days+'&fromDt='+fromDt+'&toDt='+toDt);
        Blob pdfBlob;
        String dt = '';
        try {
            pdfBlob = pageRef.getContentAsPDF();
        } catch (VisualforceException e) {
            // Handle any exceptions here
            pdfBlob = Blob.valueOf('Error generating PDF: ' + e.getMessage());
        }
        
        // Create an EmailMessage with the PDF as an attachment
        Messaging.EmailFileAttachment pdfAttachment = new Messaging.EmailFileAttachment();
        pdfAttachment.setFileName('Shared-Components_Report'+System.Today()+'.pdf');
        pdfAttachment.setBody(pdfBlob);
        
        // Create an Email
        Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
        email.setSubject('Shared Component Report');
        String primaryEmail;
        if(emailIds.contains(',')){
            primaryEmail = emailIds.substringBefore(',');
            String ccEmails = emailIds.substringAfter(',');
            if(ccEmails!=''){
                List<String>ccList = New List<String>();
                While(ccEmails.contains(',')){
                    String cc1 = ccEmails.substringBefore(',');
                    ccList.add(cc1);
                    ccEmails = ccEmails.substringAfter(',');
                }
                ccList.add(ccEmails);
                List<String> ccEmailsList = New List<String>(ccList);
                email.setCcAddresses(ccEmailsList);
                System.debug(ccEmailsList);
            }
        }
        else {
            primaryEmail = emailIds;      
        }
        email.toAddresses = new String[]{primaryEmail};
            System.debug(email.toAddresses);
        System.debug(email.getCcAddresses());
        email.setHTMLBody('Team, Here\'s the Shared Component Report generated.<br>Please find the attachment below for the report.<br><br>Regards.');
        
        // Attach the PDF to the email
        email.setFileAttachments(new Messaging.EmailFileAttachment[]{pdfAttachment});
        
        // Send the email
        Messaging.SendEmailResult[] results = Messaging.sendEmail(new Messaging.SingleEmailMessage[]{email});
        system.debug('Email Sent');
        // Check for email send results and handle any errors
        if (results[0].isSuccess()) {
            System.debug('Email sent successfully');
            dt = 'Success';
        } else {
            System.debug('Email send failed: ' + results[0].getErrors()[0].getMessage());
            dt = 'Fail';
        }
        return dt;
    }
    @AuraEnabled
    public static String scheduleEmail(String emailIds, String cronExp,String jobName,Integer days, Date fromDt, Date toDt){
        System.schedule(jobName,cronExp,new SharedComponentScheduleClass(emailIds,days,fromDt,toDt));
        return 'Success';
    }
}