global class LoanReminderScheduler implements Schedulable {

    global void execute(SchedulableContext sc) {

        System.debug('Entered LoanReminderScheduler.');
        List<Loan__c> loansToRemind = [SELECT Id, Name, Due_Date__c, User__r.Username
                                       FROM Loan__c
                                       WHERE Due_Date__c = :Date.today().addDays(1)];

        if (!loansToRemind.isEmpty()) {
            List<Messaging.SingleEmailMessage> emailMessages = new List<Messaging.SingleEmailMessage>();
            for (Loan__c loan : loansToRemind) {
                String memberEmail = loan.User__r.Username;

                // Creating email content
                String subject = 'Reminder: Your Book Loan is Due Tomorrow';
                String body = 'Dear Member,\n\n'
                            + 'This is a reminder that your book loan with ID ' + loan.Name + ' is due tomorrow, '
                            + loan.Due_Date__c.format() + '.\n\n'
                            + 'Please return the book on time to avoid fines.\n\n'
                            + 'Thank you for using our library service.\n\n'
                            + 'Best regards,\n'
                            + 'Library Management Team';

                // Creating and sending the email
                Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
                email.setToAddresses(new String[] { memberEmail });
                email.setSubject(subject);
                email.setPlainTextBody(body);
                emailMessages.add(email);
            }

            // Sending all emails
            if (!emailMessages.isEmpty()) {
                Messaging.sendEmail(emailMessages);
            }
        } else {
            System.debug('No loans found that are due tomorrow.');
        }
    }
}