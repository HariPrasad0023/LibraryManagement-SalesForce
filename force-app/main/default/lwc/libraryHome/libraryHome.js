import { LightningElement, wire, track } from 'lwc'; 
import getBooks from '@salesforce/apex/BookRestController.getBooks';
import getLoansByUser from '@salesforce/apex/LoanUpdateController.getLoansByUser';
import getFinesByUser from '@salesforce/apex/FineRestController.getFinesByUser';

export default class BookList extends LightningElement {
    @track books = [];
    @track loans = [];
    @track fines = [];

    @track showBooks = false; // The reactive property
    @track showLoans = false;
    @track showFines = false;
    @track errorMessage = '';

    // Columns for Book DataTable
    bookColumns = [
        { label: 'Title', fieldName: 'Name' },
        { label: 'Genre', fieldName: 'Genre__c' },
        { label: 'Availability Status', fieldName: 'Availability_Status__c' }
    ];

    // Columns for Loan DataTable
    loanColumns = [
        { label: 'Book Name', fieldName: 'BookName' },
        { label: 'Loan Date', fieldName: 'Loan_Date__c' },
        { label: 'Due Date', fieldName: 'Due_Date__c' },
        { label: 'Return Date', fieldName: 'Return_Date__c' },
        { label: 'Status', fieldName: 'Loan_Status__c' }
    ];

    // Columns for Fine DataTable
    fineColumns = [
        { label: 'Fine Name', fieldName: 'FineName' },
        { label: 'Fine Amount', fieldName: 'FineAmount' },
        { label: 'Fine Status', fieldName: 'FineStatus' },
        { label: 'Fine Paid Date', fieldName: 'FinePaidDate' }
    ];

    // Handle Book Button Click
    async handleBooksClick() {
        // Trigger the @wire call by setting the showBooks property to true
        this.showBooks = true;
        this.showLoans = false;
        this.showFines = false;
    }

    @wire(getBooks, {trigger : '$showBooks'})
    wiredBooks({ error, data }) {
        if (data) {
            // Successfully fetched books
            // console.log('✅ Books fetched successfully:', JSON.stringify(data));
            this.books = data;
            this.errorMessage = ''; // Clear any previous error message
        } else if (error) {
            // Error occurred
            console.error('❌ Error fetching books:', error);
            this.errorMessage = `Error: ${error.body.message}`;
        }
    }

    async handleLoansClick() {
        // Trigger the @wire call by setting the showLoans property to true
        this.showLoans = true;
        this.showBooks = false;
        this.showFines = false;
    }

    // Use the @wire decorator to call the Apex method
    @wire(getLoansByUser, {trigger : '$showLoans'})
    wiredLoans({ error, data }) {
        if (data) {
            // If data is returned, update the loans and userId
            // Flatten the response
            this.loans = data.map(loan => ({
                ...loan, 
                BookName: loan.Book__r ? loan.Book__r.Name : 'N/A', // Flatten the field
                Return_Date__c : loan.Return_Date__c ? loan.Return_Date__c : 'Not Returned Yet' // Default value
            }));
            this.userId = data.userId;
            this.errorMessage = ''; // Clear any previous error messages
        } else if (error) {
            // If an error occurs, update the errorMessage
            this.errorMessage = error.body.message;
            this.loans = []; // Clear the loans data
            this.userId = ''; // Clear the userId
        }
    }

    async handleFinesClick() {
        // Trigger the @wire call by setting the showFines property to true
         this.showFines = true;
        this.showBooks = false;
        this.showLoans = false;
    }

    @wire(getFinesByUser, { trigger: '$showFines' })
    wiredFines({ error, data }) {
        if (data) {
            try {
                // console.log('Raw response:', JSON.stringify(data));
    
                this.fines = data.map(fine => ({
                    Id: fine.Id,
                    LoanId: fine.Loan__c,
                    FineAmount: fine.Fine_Amount__c ?? 0, // Ensure default value if null
                    FineStatus: fine.Fine_Status__c ?? 'Unknown', // Default status if missing
                    FinePaidDate: fine.Fine_Paid_Date__c || 'N/A',
                    FineName: fine?.Loan__r?.Loan_Name__c || 'N/A'
                }));
    
                // console.log('Final fines array:', JSON.stringify(this.fines));
                this.errorMessage = ''; // Clear previous errors
            } catch (err) {
                console.error('Error processing fines:', err);
                this.errorMessage = 'Error processing fine data';
                this.fines = [];
            }
        } else if (error) {
            console.error('Error fetching fines:', JSON.stringify(error));
            this.errorMessage = error.body?.message || 'An error occurred while fetching fines';
            this.fines = [];
        }
    }       
}
