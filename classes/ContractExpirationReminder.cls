global class ContractExpirationReminder implements Schedulable {
    
    global void execute(SchedulableContext sc) {
        // Get the current date
   /*     Date currentDate = Date.today();
        
        // Calculate the target dates (90, 60, and 30 days before contract expiration)
        Date date90DaysBefore = currentDate.addDays(-90);
        Date date60DaysBefore = currentDate.addDays(-60);
        Date date30DaysBefore = currentDate.addDays(-30);
        
        // Query for contracts expiring on each target date
        List<Contract> contracts90DaysBefore = [SELECT Id, Name, EndDate FROM Contract WHERE EndDate = :date90DaysBefore];
        System.debug('contracts90DaysBefore==> '+contracts90DaysBefore);
        List<Contract> contracts60DaysBefore = [SELECT Id, Name, EndDate FROM Contract WHERE EndDate = :date60DaysBefore];
        List<Contract> contracts30DaysBefore = [SELECT Id, Name, EndDate FROM Contract WHERE EndDate = :date30DaysBefore];
        
        // Call the method to send email for each set of contracts
        sendReminderEmails(contracts90DaysBefore, '90');
        sendReminderEmails(contracts60DaysBefore, '60');
        sendReminderEmails(contracts30DaysBefore, '30');		*/
    }
    
 /*   private void sendReminderEmails(List<Contract> contracts, String daysBefore) {
        for (Contract contract : contracts) {
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
            mail.setToAddresses(new String[] {'dipali24lingayat@gmail.com'});
            mail.setSubject('Contract Expiration Reminder - ' + daysBefore + ' days');
            mail.setPlainTextBody('Dear User, your contract ' + contract.Name + ' is expiring in ' + daysBefore + ' days on ' + contract.EndDate);
            Messaging.sendEmail(new Messaging.SingleEmailMessage[] {mail});
        }
    }		*/
}