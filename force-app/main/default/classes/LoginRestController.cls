@RestResource(urlMapping='/login/*')
global without sharing class LoginRestController {

    @HttpPost
    global static String login() {
        try {
            RestRequest req = RestContext.request;
            String requestBody = req.requestBody.toString();
            Map<String, Object> data = (Map<String, Object>) JSON.deserializeUntyped(requestBody);
    
            String email = (String) data.get('email');
            String password = (String) data.get('password');
    
            if (String.isBlank(email) || String.isBlank(password)) {
                return JSON.serialize(new Map<String, Object>{
                    'success' => false,
                    'message' => 'Email and Password are required.'
                });
            }
    
            // Hash the incoming password for comparison
            String hashedInputPassword = EncodingUtil.base64Encode(Crypto.generateDigest('SHA-256', Blob.valueOf(password)));
    
            // Find the member with this email
            List<Member__c> members = [SELECT Id, Password__c FROM Member__c WHERE Email__c = :email LIMIT 1];
    
            if (members.isEmpty()) {
                return JSON.serialize(new Map<String, Object>{
                    'success' => false,
                    'message' => 'Invalid email or password.'
                });
            }
    
            // Compare hashed input with stored hashed password
            Member__c member = members[0];
            if (member.Password__c != hashedInputPassword) {
                return JSON.serialize(new Map<String, Object>{
                    'success' => false,
                    'message' => 'Invalid email or password.'
                });
            }
    
            // Generate a session token (basic example)
            String rawToken = String.valueOf(System.now().getTime()) + Math.random();
            Blob hash = Crypto.generateDigest('SHA-256', Blob.valueOf(rawToken));
            String sessionToken = EncodingUtil.base64Encode(hash);

            // Store session token in Member__c (Create a new field `Session_Token__c`)
            member.Session_Token__c = sessionToken;
            update member;
    
            return JSON.serialize(new Map<String, Object>{
                'success' => true,
                'message' => 'Login successful!',
                'memberId' => member.Id,
                'sessionToken' => sessionToken
            });
    
        } catch (Exception e) {
            return JSON.serialize(new Map<String, Object>{
                'success' => false,
                'message' => 'Error: ' + e.getMessage()
            });
        }
    }
    
}
