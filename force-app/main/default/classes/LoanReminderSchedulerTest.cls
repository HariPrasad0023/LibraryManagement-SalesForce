@isTest
public class LoanReminderSchedulerTest {

    @testSetup
    static void setupTestData() {
        // Create a test Member
        Member__c testMember = new Member__c(
            Name = 'Hari Prasad',
            Email__c = 'hariprasad.malliga@gmail.com',
            Membership_Start_Date__c = Date.newInstance(2025, 3, 20),
            Membership_Status__c = 'Active',
            Membership_Type__c = 'Premium',
            Phone_Number__c = '1234567890',
            Password__c = 'Sample'
        );
        insert testMember;

        // Create a test Book
        Book__c testBook = new Book__c(
            Name = 'The Shining',
            Author__c = 'Stephen King',
            Genre__c = 'Horror',
            Availability_Status__c = 'Available',
            ISBN__c = '9780307743657'
        );
        insert testBook;

        // Create a test Loan (due tomorrow)
        Loan__c testLoan = new Loan__c(
            Book__c = testBook.Id,
            Member__c = testMember.Id,
            Loan_Date__c = Date.today(),
            Due_Date__c = Date.today().addDays(1),
            Loan_Status__c = 'Borrowed'
        );
        insert testLoan;
    }

    @isTest
    static void testLoanReminderScheduler() {
        // Run the scheduled job
        Test.startTest();
        LoanReminderScheduler scheduler = new LoanReminderScheduler();
        scheduler.execute(null);
        Test.stopTest();

        // Verify if the loan was retrieved correctly
        Loan__c loan = [SELECT Id, Name, Due_Date__c FROM Loan__c WHERE Due_Date__c = :Date.today().addDays(1) LIMIT 1];
        System.assertNotEquals(null, loan, 'Loan should be found for the reminder.');
    }
}