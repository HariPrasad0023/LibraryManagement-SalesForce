global class OverdueLoanReminderScheduler implements Schedulable {

	global void execute(SchedulableContext sc) {
    	// Query overdue loans
    	List<Loan__c> overdueLoans = [SELECT Id, Due_Date__c, Member__r.Email__c
                                  	FROM Loan__c
                                  	WHERE Loan_Status__c = 'Overdue'];

    	if (!overdueLoans.isEmpty()) {
        	for (Loan__c loan : overdueLoans) {
            	System.debug('Reminder: Overdue Book Loan ID: ' + loan.Id);
            	System.debug('Due Date: ' + loan.Due_Date__c);
            	System.debug('Member Email: ' + loan.Member__r.Email__c);
            	System.debug('Message: Dear Member, your book is overdue. Please return it ASAP to avoid additional fines.');
        	}
    	} else {
        	System.debug('No overdue loans found.');
    	}
	}
}