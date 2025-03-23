import { LightningElement, track } from 'lwc';

export default class LibraryHome extends LightningElement {
    @track books = [];
    @track loans = [];
    @track fines = [];
    @track errorMessage = '';

    async handleBooksClick() {
        console.log('Fetching books...');

        try {
            const response = await fetch('/services/apexrest/books/', {
                method: 'GET',
                headers: { 'Content-Type': 'application/json' }
            });

            const data = await response.json();
            console.log('Books API Response:', data);

            if (Array.isArray(data)) {
                this.books = data;
            } else {
                console.error('Unexpected response format:', data);
            }
        } catch (error) {
            console.error('Error fetching books:', error);
        }
    }

    async handleLoansClick() {
        console.log('Fetching loans...');

        const sessionToken = localStorage.getItem('sessionToken');

        if (!sessionToken) {
            console.error('Session token not found. Please log in.');
            return;
        }

        // ✅ Creating the request body with sessionToken
        const requestBody = {
            sessionToken: sessionToken
        };

        try {
            const response = await fetch('/services/apexrest/loanUpdate/', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json'
                },
                body: JSON.stringify(requestBody) // ✅ Sending the request body
            });

            const data = await response.json();
            console.log('Loans API Response:', data);

            if (data.error) {
                console.error('Error fetching loans:', data.error);
                this.errorMessage = data.error;
                return;
            }

            this.loans = data;
        } catch (error) {
            console.error('Error fetching loans:', error);
            this.errorMessage = 'Failed to retrieve loans. Please try again.';
        }
    }

    // Fetch Fines
    async handleFinesClick() {
        console.log('📢 Fetching fines...');

        const sessionToken = localStorage.getItem('sessionToken');

        if (!sessionToken) {
            console.error('❌ Session token not found. Please log in.');
            this.errorMessage = 'Session token is missing. Please log in.';
            return;
        }

        // ✅ Creating the request body with sessionToken
        const requestBody = { sessionToken: sessionToken };

        try {
            const response = await fetch('/services/apexrest/fines/', {
                method: 'POST',
                headers: { 'Content-Type': 'application/json' },
                body: JSON.stringify(requestBody)
            });

            if (!response.ok) {
                console.error(`❌ HTTP Error: ${response.status} ${response.statusText}`);
                this.errorMessage = `Error: ${response.statusText} (${response.status})`;
                return;
            }

            const data = await response.json();
            console.log('✅ Fines API Response:', data);

            if (data.error) {
                console.error('❌ Error fetching fines:', data.error);
                this.errorMessage = data.error;
                return;
            }

            // ✅ Directly assign the fines to `this.fines` just like loans
            this.fines = data.fines;

            console.log('✅ Processed fines:', this.fines);
            this.errorMessage = ''; // Clear previous error message if successful

        } catch (error) {
            console.error('❌ Error fetching fines:', error);
            this.errorMessage = 'Failed to retrieve fines. Please check your network and try again.';
        }
    }



}
