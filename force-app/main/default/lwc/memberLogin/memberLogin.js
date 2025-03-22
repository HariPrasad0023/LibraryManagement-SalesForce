import { LightningElement, track } from 'lwc';

export default class MemberLogin extends LightningElement {
    @track email = '';
    @track password = '';
    @track errorMessage = '';

    handleEmailChange(event) {
        this.email = event.target.value;
        // console.log('Email input changed:', this.email);
    }

    handlePasswordChange(event) {
        this.password = event.target.value;
        // console.log('Password input changed:', this.password);
    }

    handleLogin() {
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

        fetch('/services/apexrest/login/', {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json'
            },
            body: JSON.stringify(requestBody)
        })
            .then(response => {
                console.log('Raw Response:', response);
                if (!response.ok) {
                    throw new Error(`HTTP error! Status: ${response.status}`);
                }
                return response.json();
            })
            .then(data => {
                console.log('Login successful:', data);

                // Store values in sessionStorage
                sessionStorage.setItem('sessionToken', data.sessionToken);
                sessionStorage.setItem('memberId', data.memberId);

                // Retrieve and print stored values
                console.log('Stored sessionToken:', sessionStorage.getItem('sessionToken'));
                console.log('Stored memberId:', sessionStorage.getItem('memberId'));

                this.errorMessage = 'Login successful! Redirecting...';
                console.log(this.errorMessage);

            })
            .catch(error => {
                console.error('Fetch Error:', error);
                this.errorMessage = 'Error logging in. Please try again.';
            });
    }
}
