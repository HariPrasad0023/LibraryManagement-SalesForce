@RestResource(urlMapping='/loans/*')
global without sharing class LoanRestController {

    // POST : Add a new Loan
    @HttpPost
    global static String addLoan(Id memberId, Id bookId, Date loanDate, Date dueDate) {
        
        Loan__c newLoan = new Loan__c(
            Member__c = memberId,
            Book__c = bookId,
            Loan_Date__c = loanDate,
            Due_Date__c = dueDate,
            Loan_Status__c = 'Borrowed', 
            OwnerId = UserInfo.getUserId()
        );
        
        insert newLoan;
        return newLoan.Id;
    }
      
    
    // PUT : Update Loan Status to 'Returned'
    @HttpPut
    global static String updateLoanStatusToReturned(String loanId) {
        try {
            Loan__c loanToUpdate = [SELECT Id, Loan_Status__c FROM Loan__c WHERE Id = :loanId LIMIT 1];

            loanToUpdate.Return_Date__c = Date.today();

            if (loanToUpdate != null) {
                loanToUpdate.Loan_Status__c = 'Returned';
                update loanToUpdate;

                return 'Loan status updated to Returned for Loan ID: ' + loanToUpdate.Id;
            } else {
                return 'Loan record not found for ID: ' + loanId;
            }
        } catch (Exception e) {
            return 'An error occurred while updating the loan status: ' + e.getMessage();
        }
    }
}