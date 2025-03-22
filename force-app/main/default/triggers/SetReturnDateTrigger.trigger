trigger SetReturnDateTrigger on Loan__c (before update) {
    for (Loan__c loan : Trigger.new) {
        if (loan.Loan_Status__c == 'Returned' && loan.Return_Date__c == null) {
            loan.Return_Date__c = Date.today();
            System.debug('Return Date was null. Updated to today: ' + Date.today());
        }
    }
}