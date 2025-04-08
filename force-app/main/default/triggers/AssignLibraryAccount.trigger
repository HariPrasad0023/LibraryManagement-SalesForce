trigger AssignLibraryAccount on Member__c (before insert, before update) {
    for (Member__c member : Trigger.new) { 
        if (member.Membership_Type__c != null) {
            // Fetch the corresponding Account in a single query
            Account acc;
            try {
                acc = [
                    SELECT Id FROM Account 
                    WHERE Name = :member.Membership_Type__c + ' Library Account' 
                    LIMIT 1
                ];
            } catch (Exception e) {
                System.debug('No matching account found for Subscription Type: ' + member.Membership_Type__c);
                continue;
            }

            if (acc != null) {
                member.Account__c = acc.Id;
            }
        }
    }
}