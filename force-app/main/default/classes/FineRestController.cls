public without sharing class FineRestController {

    @AuraEnabled(cacheable=true)
    public static List<Fine__c> getFinesByUser() {
        List<Fine__c> finesList = new List<Fine__c>();

        try {
            // Get the currently logged-in user
            String loggedInUserId = UserInfo.getUserId();

            if (String.isBlank(loggedInUserId)) {
                throw new AuraHandledException('User not logged in');
            }

            // Fetch loans associated with the logged-in User
            List<Loan__c> loans = [
                SELECT Id
                FROM Loan__c
                WHERE User__c = :loggedInUserId
            ];

            if (loans.isEmpty()) {
                throw new AuraHandledException('No loans found for this user');
            }

            // Get all fines related to those loans
            finesList = [
                SELECT Id, Loan__r.Loan_Name__c, Fine_Amount__c, Fine_Status__c, Fine_Paid_Date__c
                FROM Fine__c
                WHERE Loan__c IN :loans
            ];

        } catch (Exception e) {
            System.debug('=== ERROR: ' + e.getMessage());
            throw new AuraHandledException(e.getMessage());
        }

        return finesList;
    }
}