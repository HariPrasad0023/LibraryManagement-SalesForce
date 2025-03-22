@RestResource(urlMapping='/login/*')
global without sharing class LoginRestController {

    // Wrapper Class for JSON Response
    global class LoginResponse {
        public Boolean success { get; set; }
        public String message { get; set; }
        public String memberId { get; set; }
        public String sessionToken { get; set; }

        public LoginResponse(Boolean success, String message, String memberId, String sessionToken) {
            this.success = success;
            this.message = message;
            this.memberId = memberId;
            this.sessionToken = sessionToken;
        }
    }

    @HttpPost
    global static LoginResponse login() {
        try {
            RestRequest req = RestContext.request;
            String requestBody = req.requestBody.toString();
            Map<String, Object> data = (Map<String, Object>) JSON.deserializeUntyped(requestBody);
    
            String email = (String) data.get('email');
            String password = (String) data.get('password');
    
            if (String.isBlank(email) || String.isBlank(password)) {
                return new LoginResponse(false, 'Email and Password are required.', null, null);
            }
    
            // Hash the incoming password for comparison
            String hashedInputPassword = EncodingUtil.base64Encode(Crypto.generateDigest('SHA-256', Blob.valueOf(password)));
    
            // Find the member with this email
            List<Member__c> members = [SELECT Id, Password__c FROM Member__c WHERE Email__c = :email LIMIT 1];
    
            if (members.isEmpty()) {
                return new LoginResponse(false, 'Invalid email or password.', null, null);
            }
    
            // Compare hashed input with stored hashed password
            Member__c member = members[0];
            if (member.Password__c != hashedInputPassword) {
                return new LoginResponse(false, 'Invalid email or password.', null, null);
            }
    
            // Generate a session token (basic example)
            String rawToken = String.valueOf(System.now().getTime()) + Math.random();
            Blob hash = Crypto.generateDigest('SHA-256', Blob.valueOf(rawToken));
            String sessionToken = EncodingUtil.base64Encode(hash);

            // Store session token in Member__c (Ensure `Session_Token__c` field exists)
            member.Session_Token__c = sessionToken;
            update member;
    
            return new LoginResponse(true, 'Login successful!', member.Id, sessionToken);
    
        } catch (Exception e) {
            return new LoginResponse(false, 'Error: ' + e.getMessage(), null, null);
        }
    }
}