trigger SetMembershipStartDate on User (before insert) {
    for (User newUser : Trigger.new) {
        if (newUser.Membership_Start_Date__c == null) {
            newUser.Membership_Start_Date__c = Date.today();
        }
    }
}