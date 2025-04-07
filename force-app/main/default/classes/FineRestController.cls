public without sharing class FineRestController {
    
    @AuraEnabled(cacheable=true)
    public static List<Fine__c> getFinesByUser() {
        List<Fine__c> finesList = new List<Fine__c>();

        try {
            // Get the currently logged-in user
            String loggedInUserId = UserInfo.getUserId();

            if (String.isBlank(loggedInUserId)) {
                return finesList; // Return empty list instead of throwing an error
            }

            // Fetch all loans associated with the logged-in user
            List<Loan__c> loans = [
                SELECT Id FROM Loan__c WHERE User__c = :loggedInUserId
            ];

            if (loans.isEmpty()) {
                return finesList; // Return empty list instead of throwing an error
            }

            // Fetch fines for these loans
            finesList = [
                SELECT Id, Loan__c, Loan__r.Name, Fine_Amount__c, Fine_Status__c, Fine_Paid_Date__c
                FROM Fine__c
                WHERE Loan__c IN :loans
            ];

        } catch (Exception e) {
            System.debug('=== ERROR: ' + e.getMessage());
            throw new AuraHandledException('An error occurred while fetching fines');
        }

        return finesList;
    }
}