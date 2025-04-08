global class LoanStatusUpdater implements Schedulable {
    global void execute(SchedulableContext sc) {
        updateOverdueLoans();
    }

    private void updateOverdueLoans() {
        // Fetch all Loan records where Return_Date__c is past today and Status is 'Borrowed'
        List<Loan__c> overdueLoans = [
            SELECT Id, Loan_Status__c, Return_Date__c 
            FROM Loan__c 
            WHERE Return_Date__c < TODAY AND Loan_Status__c = 'Borrowed'
        ];

        if (!overdueLoans.isEmpty()) {
            for (Loan__c loan : overdueLoans) {
                loan.Loan_Status__c = 'Overdue';
            }
            update overdueLoans; // Perform bulk update
        }
    }
}