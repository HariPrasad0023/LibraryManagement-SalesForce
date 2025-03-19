@RestResource(urlMapping='/books/*')
global with sharing class BookRestController {

    @HttpGet
    global static List<Book__c> getBooks() {
        String requestUrl = RestContext.request.requestURI;

        if (requestUrl.contains('available')) {
            // Fetch only available books
            return [SELECT Id, Name, Genre__c, Availability_Status__c 
                    FROM Book__c 
                    WHERE Availability_Status__c = 'Available'];
        } else {
            // Fetch all books
            return [SELECT Id, Name, Genre__c, Availability_Status__c 
                    FROM Book__c];
        }
    }

    // POST : Add a New Book
    @HttpPost
    global static String addNewBook(String bookName, String author, String genre, String availabilityStatus, String isbn) {

        try {
            // Create the Book__c object with the provided fields
            Book__c newBook = new Book__c(
                Name = bookName,                           
                Author__c = author,                        
                Genre__c = genre,                          
                Availability_Status__c = availabilityStatus,  
                ISBN__c = isbn                             
            );

            // Insert the new Book record
            insert newBook;

            // Return success message with the ID of the newly created Book record
            return 'New Book created with ID: ' + newBook.Id;
        } catch (Exception e) {
            // Return error message if something goes wrong
            return 'Error while adding the book: ' + e.getMessage();
        }
    }

}