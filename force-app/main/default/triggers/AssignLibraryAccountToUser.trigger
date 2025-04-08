trigger AssignLibraryAccountToUser on User (after insert) { 
    Id communityProfileId = '00egK000000tTsbQAE'; // Community User Profile ID
    
    User newUser = Trigger.new[0]; // Directly access the single User record

    if (newUser.ProfileId == communityProfileId) { // Ensure it's a Community User
        try {
            // Determine the correct Library Account based on Membership Type
            String accountName = newUser.Membership_Type__c + ' Library Account';
            Account acc = [
                SELECT Id FROM Account 
                WHERE Name = :accountName 
                LIMIT 1
            ];

            if (acc != null && newUser.ContactId != null) {
                // Fetch the Contact associated with this User
                Contact userContact = [
                    SELECT Id, AccountId 
                    FROM Contact 
                    WHERE Id = :newUser.ContactId 
                    LIMIT 1
                ];
                
                if (userContact != null) {
                    userContact.AccountId = acc.Id; // Assign the correct Library Account
                    update userContact; // Update the Contact record
                }
            }
        } catch (Exception e) {
            System.debug('Error: ' + e.getMessage());
        }
    }
}