public without sharing class BookRestController {

    @AuraEnabled(cacheable=true)
    public static List<Book__c> getBooks() {
            // Fetch and return books
            return [SELECT Id, Name, Genre__c, Availability_Status__c FROM Book__c];
    }
}
