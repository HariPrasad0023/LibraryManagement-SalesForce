@RestResource(urlMapping='/members/*')
global with sharing class MemberRestController {

    // POST : Add a new Member
    @HttpPost
    global static String addMember() {
        System.debug('Inside addMember API'); // ✅ Log Entry Point
    
        try {
            // Get JSON body
            RestRequest req = RestContext.request;
            String requestBody = req.requestBody.toString();
            System.debug('Raw JSON Body: ' + requestBody);
    
            // Parse JSON into a Map
            Map<String, Object> data = (Map<String, Object>) JSON.deserializeUntyped(requestBody);
            System.debug('Parsed JSON Data: ' + data);
    
            // Extract fields
            String memberName = (String) data.get('memberName');
            String email = (String) data.get('email');
            String membershipStatus = (String) data.get('membershipStatus');
            String membershipType = (String) data.get('membershipType');
            String phoneNumber = (String) data.get('phoneNumber');
            // Hash the password
            String password = (String) data.get('password');
            password = EncodingUtil.base64Encode(Crypto.generateDigest('SHA-256', Blob.valueOf(password)));
    
            // Convert Date properly
            String membershipStartDateStr = (String) data.get('membershipStartDate');
            Date membershipStartDate = null;
            if (!String.isBlank(membershipStartDateStr)) {
                try {
                    membershipStartDate = Date.valueOf(membershipStartDateStr);
                } catch (Exception e) {
                    System.debug('Error parsing date: ' + e.getMessage());
                    return 'Error: Invalid date format. Use YYYY-MM-DD';
                }
            }
    
            // Debug extracted values
            System.debug('Extracted Values:');
            System.debug('Member Name: ' + memberName);
            System.debug('Email: ' + email);
            System.debug('Phone Number: ' + phoneNumber);
            System.debug('Membership Start Date: ' + membershipStartDate);
    
            // Validate required fields before inserting
            if (String.isBlank(email) || String.isBlank(phoneNumber)) {
                System.debug('Error: Missing required fields!');
                return 'Error: Missing required fields (Email and Phone Number are required).';
            }
    
            // Create new Member record
            Member__c newMember = new Member__c(
                Name = memberName,
                Email__c = email,
                Membership_Start_Date__c = membershipStartDate,
                Membership_Status__c = membershipStatus,
                Membership_Type__c = membershipType,
                Phone_Number__c = phoneNumber,
                Password__c = password
            );
    
            insert newMember;
    
            System.debug('Member record inserted successfully with ID: ' + newMember.Id);
            return 'Member record inserted successfully with ID: ' + newMember.Id;    
        } catch (Exception e) {
            System.debug('Error while adding member: ' + e.getMessage());
            return 'Error: ' + e.getMessage();
        }
    }    

    // GET : Fetch all members
    @HttpGet
    global static List<Member__c> getAllMembers() {
        try {
            System.debug('Inside getAllMembers API');

            // Query all Member records
            List<Member__c> members = [SELECT Id, Name, Email__c, Phone_Number__c, Membership_Status__c, Membership_Type__c, Membership_Start_Date__c FROM Member__c];
            return members;
        } catch (Exception e) {
            throw new AuraHandledException('Error retrieving members: ' + e.getMessage());
        }
    }
}