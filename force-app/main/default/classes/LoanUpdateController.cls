public without sharing class LoanUpdateController {

    @AuraEnabled(cacheable=true)
    public static List<Loan__c> getLoansByUser() {
        List<Loan__c> loans = new List<Loan__c>();

        try {
            // ✅ Get the currently logged-in User
            String loggedInUserId = UserInfo.getUserId();
            
            if (String.isBlank(loggedInUserId)) {
                throw new AuraHandledException('User not logged in');
            }

            System.debug('=== Logged-In User ID: ' + loggedInUserId);

            // ✅ Fetch loans associated with the logged-in User
            loans = [
                SELECT Id, Loan_Status__c, Loan_Date__c, Due_Date__c, Return_Date__c, 
                       Book__c, Book__r.Name  
                FROM Loan__c 
                WHERE User__c = :loggedInUserId
            ];

            System.debug('=== Retrieved Loans: ' + loans);

        } catch (Exception e) {
            System.debug('=== ERROR: ' + e.getMessage());
            throw new AuraHandledException('Error fetching loans: ' + e.getMessage());
        }

        return loans;
    }
}