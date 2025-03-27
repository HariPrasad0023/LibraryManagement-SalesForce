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
        { label: 'Book Name', fieldName: 'Book__r.Name' },
        { label: 'Loan Date', fieldName: 'Loan_Date__c' },
        { label: 'Due Date', fieldName: 'Due_Date__c' },
        { label: 'Return Date', fieldName: 'Return_Date__c' },
        { label: 'Status', fieldName: 'Loan_Status__c' }
    ];

    // Columns for Fine DataTable
    fineColumns = [
        { label: 'Fine Name', fieldName: 'Loan__r.Loan_Name__c' },
        { label: 'Fine Amount', fieldName: 'Fine_Amount__c' },
        { label: 'Fine Status', fieldName: 'Fine_Status__c' }
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
            console.log('✅ Books fetched successfully:', JSON.stringify(data));
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
            this.loans = data.loans;
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

    // Wire service to call the Apex method
    @wire(getFinesByUser, { trigger : '$showFines' })
    wiredFines({ error, data }) {
        if (data) {
            // Check if there's an error in the returned data
            if (data.error) {
                this.errorMessage = data.error;  // Set error message if there was an issue
                this.fines = [];  // Clear fines if error exists
            } else {
                this.fines = data.fines;  // Set fines data to be displayed
                this.errorMessage = '';  // Clear any previous error messages
            }
        } else if (error) {
            this.errorMessage = error.body.message;  // Handle the error response
            this.fines = [];  // Clear fines if there's an error
        }
    }
}
