@RestResource(urlMapping='/loans/*')
global with sharing class LoanRestController {

    // POST : Add a new Loan
    @HttpPost
    global static String addLoan(Id memberId, Id bookId, Date loanDate, Date dueDate) {
        
        // Create a new Loan record
        Loan__c newLoan = new Loan__c(
            Member__c = memberId,
            Book__c = bookId,
            Loan_Date__c = loanDate,
            Due_Date__c = dueDate,
            Loan_Status__c = 'Borrowed', // Default status
            OwnerId = UserInfo.getUserId()
        );
        
        // Insert the Loan record
        insert newLoan;

        // Return the ID of the newly created Loan
        return newLoan.Id;
    }

    // GET : Fetch loans by Member ID
    @HttpGet
    global static List<Loan__c> getLoansByMember() {
        RestRequest req = RestContext.request;
        // Retrieve the Member ID from the query parameter
        String memberId = req.params.get('email');  // Ensure this matches the query parameter
        
        // Query the loans related to the specified Member ID
        List<Loan__c> loans = [SELECT Id, Loan_Name__c, Loan_Status__c, Member__c FROM Loan__c WHERE Member__r.Email__c = :memberId];
        
        return loans;
    }

    // PUT : Update Loan Status to 'Returned'
    @HttpPut
    global static String updateLoanStatusToReturned(String loanId) {
        try {
            // Fetch the loan record by Id
            Loan__c loanToUpdate = [SELECT Id, Loan_Status__c FROM Loan__c WHERE Id = :loanId LIMIT 1];

            // Set today as the return date
            loanToUpdate.Return_Date__c = Date.today();

            // Check if loan exists and update status
            if (loanToUpdate != null) {
                loanToUpdate.Loan_Status__c = 'Returned'; // Update status to Returned
                update loanToUpdate;

                // Return success message
                return 'Loan status updated to Returned for Loan ID: ' + loanToUpdate.Id;
            } else {
                // Return error if loan not found
                return 'Loan record not found for ID: ' + loanId;
            }
        } catch (Exception e) {
            // Catch any unexpected errors
            return 'An error occurred while updating the loan status: ' + e.getMessage();
        }
    }
}