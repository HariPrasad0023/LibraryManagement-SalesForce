@RestResource(urlMapping='/members/*')
global with sharing class MemberRestController {

    // POST : Add a new Member
    @HttpPost
    global static String addMember(String memberName, String email, Date membershipStartDate, String membershipStatus, String membershipType, String phoneNumber) {

        // Debug: Log the incoming request data
        System.debug('Incoming Request: ');
        System.debug('Member Name: ' + memberName);
        System.debug('Email: ' + email);
        System.debug('Membership Start Date: ' + membershipStartDate);
        System.debug('Membership Status: ' + membershipStatus);
        System.debug('Membership Type: ' + membershipType);
        System.debug('Phone Number: ' + phoneNumber);

        try {
            // Create a new Member record
            Member__c newMember = new Member__c(
                Name = memberName,
                Email__c = email,
                Membership_Start_Date__c = membershipStartDate,
                Membership_Status__c = membershipStatus,
                Membership_Type__c = membershipType,
                Phone_Number__c = phoneNumber,
                OwnerId = UserInfo.getUserId() // Automatically set the OwnerId to the current user
            );

            // Debug: Log the new Member record before inserting
            System.debug('New Member Record: ' + newMember);

            // Insert the new Member record
            insert newMember;

            // Debug: Log success message
            System.debug('Member record inserted successfully with ID: ' + newMember.Id);

            // Return the ID of the newly created Member record
            return newMember.Id;
        } catch (Exception e) {
            // Debug: Log error message
            System.debug('Error while adding member: ' + e.getMessage());
            return 'Error: ' + e.getMessage();
        }
    }

    // GET : Fetch all members
    @HttpGet
    global static List<Member__c> getAllMembers() {
        try {
            // Query all Member records
            List<Member__c> members = [SELECT Id, Name, Email__c, Phone_Number__c, Membership_Status__c, Membership_Type__c, Membership_Start_Date__c FROM Member__c];
            return members;
        } catch (Exception e) {
            // Handle exception and return an error message
            throw new AuraHandledException('Error retrieving members: ' + e.getMessage());
        }
    }
}
