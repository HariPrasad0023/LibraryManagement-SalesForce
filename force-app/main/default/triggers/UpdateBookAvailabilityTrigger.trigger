trigger UpdateBookAvailabilityTrigger on Loan__c (after insert, after update) {
	// Fetch the newly created loan record
	Loan__c loan = Trigger.new[0];

	// Check if the loan status is 'Borrowed'
	if (loan.Loan_Status__c == 'Borrowed' || loan.Loan_Status__c == 'Overdue') {
    	try {
        	// Retrieve the associated book record
        	Book__c book = [SELECT Id, Availability_Status__c FROM Book__c WHERE Id = :loan.Book__c LIMIT 1];

        	// Log previous status
        	System.debug('Book ID: ' + book.Id + ' | Previous Status: ' + book.Availability_Status__c);
       	 
        	// Update book status to "Borrowed"
        	book.Availability_Status__c = 'Borrowed';
        	update book;

        	// Log update confirmation
        	System.debug('Book ID: ' + book.Id + ' | Updated Status: Borrowed');
    	} catch (Exception e) {
        	System.debug('Error updating book availability: ' + e.getMessage());
    	}
	}
}