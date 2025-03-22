trigger LoanStatusUpdateTrigger on Loan__c (after update) {
    // Get the updated loan record
    Loan__c loan = Trigger.new[0];  
    Loan__c oldLoan = Trigger.oldMap.get(loan.Id);
    
    // Check if Loan Status changed to 'Returned'
    if (loan.Loan_Status__c == 'Returned' && oldLoan.Loan_Status__c != 'Returned') {
        try {
            System.debug('Loan ID: ' + loan.Id + ' status changed to Returned.');

            // Update the Book's Availability Status
            Book__c book = [SELECT Id, Availability_Status__c FROM Book__c WHERE Id = :loan.Book__c LIMIT 1];
            book.Availability_Status__c = 'Available';
            update book;
            
            System.debug('Book ID: ' + book.Id + ' updated to Available.');
            
        } catch (Exception e) {
            System.debug('Error in LoanStatusUpdateTrigger: ' + e.getMessage());
        }
    }
}