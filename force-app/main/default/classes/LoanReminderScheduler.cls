global class LoanReminderScheduler implements Schedulable {

	global void execute(SchedulableContext sc) {
    	List<Loan__c> loansToRemind = [SELECT Id, Due_Date__c, Member__r.Email__c
                                   	FROM Loan__c
                                   	WHERE Due_Date__c = :Date.today().addDays(1)];

    	if (!loansToRemind.isEmpty()) {
        	for (Loan__c loan : loansToRemind) {
            	System.debug('Reminder: Book Loan ID: ' + loan.Id);
            	System.debug('Due Date: ' + loan.Due_Date__c);
            	System.debug('Member Email: ' + loan.Member__r.Email__c);
            	System.debug('Message: Dear Member, your book is due tomorrow. Please return it on time to avoid fines.');
        	}
    	} else {
        	System.debug('No loans found that are due tomorrow.');
    	}
	}
}