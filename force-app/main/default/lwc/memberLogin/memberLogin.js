import { LightningElement, track } from 'lwc';

export default class MemberLogin extends LightningElement {
    @track email = '';
    @track password = '';
    @track errorMessage = '';
    @track isLoggedIn = false;

    handleEmailChange(event) {
        this.email = event.target.value.trim();
        console.log('Captured Email:', this.email);
    }

    handlePasswordChange(event) {
        this.password = event.target.value;
        console.log('Captured Password:', this.password);
    }

    async handleLogin() {
        console.log('Login button clicked!');
        this.errorMessage = ''; // Clear previous errors

        if (!this.email || !this.password) {
            this.errorMessage = 'Email and Password are required!';
            console.error(this.errorMessage);
            return;
        }

        const requestBody = {
            email: this.email,
            password: this.password
        };

        console.log('Sending request to API:', requestBody);

        try {
            const response = await fetch('/services/apexrest/login/', {
                method: 'POST',
                headers: { 'Content-Type': 'application/json' },
                body: JSON.stringify(requestBody)
            });

            const text = await response.text();
            console.log('Raw JSON Response as Text:', text);

            if (!text) {
                throw new Error('Empty response from server');
            }

            const data = JSON.parse(text);
            console.log('Parsed Data Object:', data);

            if (data.success) {
                console.log('Login successful:', data);
                localStorage.setItem('sessionToken', data.sessionToken);
                localStorage.setItem('memberId', data.memberId);
                this.isLoggedIn = true;
            } else {
                console.error('Login failed:', data.message);
                this.errorMessage = data.message || 'Login failed!';
            }
        } catch (error) {
            console.error('Error:', error);
            this.errorMessage = 'Error logging in. Please try again.';
        }
    }
}