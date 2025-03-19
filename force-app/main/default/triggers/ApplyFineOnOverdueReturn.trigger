trigger ApplyFineOnOverdueReturn on Loan__c (after update) {
	// Get the updated loan record
	Loan__c loan = Trigger.new[0];
	Loan__c oldLoan = Trigger.old[0];

	// Check if loan status changed from Overdue -> Returned
	if (oldLoan.Loan_Status__c == 'Overdue' && loan.Loan_Status__c == 'Returned') {
    	try {
        	// Calculate overdue days
        	Integer overdueDays = loan.Return_Date__c.daysBetween(loan.Due_Date__c);
        	if (overdueDays > 0) {
            	Decimal fineAmount = overdueDays * 5; // Fine rate: $5 per day

            	// Log fine calculation
            	System.debug('Fine Applied: ' + fineAmount + ' for ' + overdueDays + ' overdue days');

            	// Create Fine record
            	Fine__c fine = new Fine__c(
                	Member__c = loan.Member__c, // Associate fine with the member
                	Loan__c = loan.Id, // Associate fine with the loan
                	Fine_Amount__c = fineAmount,
                	Fine_Status__c = 'Unpaid'
            	);

            	insert fine;
            	System.debug('Fine record inserted successfully');
        	}
    	} catch (Exception e) {
        	System.debug('Error while applying fine: ' + e.getMessage());
    	}
	}
}
