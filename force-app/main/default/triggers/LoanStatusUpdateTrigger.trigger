trigger LoanStatusUpdateTrigger on Loan__c (after update) {
	// Get the first (and only) record from Trigger.new
	Loan__c loan = Trigger.new[0];
	Loan__c oldLoan = Trigger.old[0];

	// Check if Loan_Status__c has changed to 'Returned'
	if (loan.Loan_Status__c == 'Returned' && oldLoan.Loan_Status__c != 'Returned') {
    	try {
        	// Get the corresponding book record
        	Book__c book = [SELECT Id, Availability_Status__c FROM Book__c WHERE Id = :loan.Book__c LIMIT 1];

        	// Log old and new status for debugging
        	System.debug('Loan ' + loan.Id + ' status changed from ' + oldLoan.Loan_Status__c + ' to ' + loan.Loan_Status__c);
        	System.debug('Updating Book ' + book.Id + ' to Available.');

        	// Update the book's availability status
        	book.Availability_Status__c = 'Available';
        	update book;

        	System.debug('Book ' + book.Id + ' successfully updated to Available.');
    	} catch (Exception e) {
        	System.debug('Error updating book availability: ' + e.getMessage());
    	}
	}
}
