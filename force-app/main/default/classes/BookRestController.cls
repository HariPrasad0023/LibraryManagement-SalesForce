public without sharing class BookRestController {

    @AuraEnabled(cacheable=true)
    public static List<Book__c> getBooks() {
        // Adding comment to invoke CI/CD pipeline

        try {
            List<Book__c> booksList = [SELECT Id, Name, Genre__c, Availability_Status__c FROM Book__c];
            return booksList.isEmpty() ? new List<Book__c>() : booksList;
        } catch (Exception e) {
            System.debug('=== ERROR: ' + e.getMessage());
            return new List<Book__c>(); // Return empty list instead of throwing an error
        }

        // Emulated an sandbox and production environment and checking the workflow was executed accordingly
        // Adding this to check the sandbox deployment
    }
}