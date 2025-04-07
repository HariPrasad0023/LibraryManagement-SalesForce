import { LightningElement, wire, track } from 'lwc'; 
import getBooks from '@salesforce/apex/BookRestController.getBooks';
import getLoansByUser from '@salesforce/apex/LoanUpdateController.getLoansByUser';
import getFinesByUser from '@salesforce/apex/FineRestController.getFinesByUser';

export default class BookList extends LightningElement {
    @track books = [];
    @track loans = [];
    @track fines = [];

    @track showBooks = false;
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
        { label: 'Loan Name', fieldName: 'FineName' },
        { label: 'Fine Amount', fieldName: 'FineAmount' },
        { label: 'Fine Status', fieldName: 'FineStatus' },
        { label: 'Fine Paid Date', fieldName: 'FinePaidDate' }
    ];

    // Handle Book Button Click
    handleBooksClick() {
        this.showBooks = true;
        this.showLoans = false;
        this.showFines = false;
        this.errorMessage = '';
        this.loans = [];
        this.fines = [];
    }

    @wire(getBooks, { trigger: '$showBooks' })
    wiredBooks({ error, data }) {
        if (data) {
            this.books = data;
            this.errorMessage = '';
        } else if (error) {
            console.error('❌ Error fetching books:', error);
            this.errorMessage = "An error occurred while fetching books.";
        }
    }

    // Handle Loan Button Click
    handleLoansClick() {
        this.showLoans = true;
        this.showBooks = false;
        this.showFines = false;
        this.errorMessage = '';
        this.books = [];
        this.fines = [];
    }

    @wire(getLoansByUser, { trigger: '$showLoans' })
    wiredLoans({ error, data }) {
        if (data) {
            this.loans = data.map(loan => ({
                ...loan, 
                BookName: loan.Book__r ? loan.Book__r.Name : 'N/A',
                Return_Date__c: loan.Return_Date__c ? loan.Return_Date__c : 'Not Returned Yet'
            }));
            this.errorMessage = '';
        } else if (error) {
            console.error('❌ Error fetching loans:', error);

            if (error.body?.message?.includes("You do not have access to the Apex class")) {
                this.errorMessage = "Please login to access this information.";
            } else {
                this.errorMessage = "An error occurred while fetching loans.";
            }

            this.loans = [];
        }
    }

    // Handle Fine Button Click
    handleFinesClick() {
        this.showFines = true;
        this.showBooks = false;
        this.showLoans = false;
        this.errorMessage = '';
        this.books = [];
        this.loans = [];
    }

    @wire(getFinesByUser, { trigger: '$showFines' })
    wiredFines({ error, data }) {
        if (data) {
            try {
                this.fines = data.map(fine => ({
                    Id: fine.Id,
                    LoanId: fine.Loan__c,
                    FineAmount: fine.Fine_Amount__c ?? 0,
                    FineStatus: fine.Fine_Status__c ?? 'Unknown',
                    FinePaidDate: fine.Fine_Paid_Date__c || 'N/A',
                    FineName: fine.Loan__r?.Name || 'N/A' // Extract Loan Name properly
                }));
                this.errorMessage = '';
            } catch (err) {
                console.error('❌ Error processing fines:', err);
                this.errorMessage = 'Error processing fine data.';
                this.fines = [];
            }
        } else if (error) {
            console.error('❌ Error fetching fines:', error);

            if (error.body?.message?.includes("You do not have access to the Apex class")) {
                this.errorMessage = "Please login to access this information.";
            } else {
                this.errorMessage = "An error occurred while fetching fines.";
            }

            this.fines = [];
        }
    }
}