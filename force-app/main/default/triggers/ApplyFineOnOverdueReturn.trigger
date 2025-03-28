trigger ApplyFineOnOverdueReturn on Loan__c (after update) {
    List<Fine__c> finesToInsert = new List<Fine__c>();

    System.debug('Triggered ApplyFineOnOverdueReturn');

    for (Loan__c loan : Trigger.new) {
        Loan__c oldLoan = Trigger.oldMap.get(loan.Id);

        // Ensure status changed from Overdue → Returned
        if (oldLoan != null && oldLoan.Loan_Status__c == 'Overdue' && loan.Loan_Status__c == 'Returned') {
            System.debug('Processing fine for Loan ID: ' + loan.Id);

            // Ensure Return Date is not null
            if (loan.Return_Date__c != null && loan.Due_Date__c != null) {
                Integer overdueDays = Math.max(0, loan.Due_Date__c.daysBetween(loan.Return_Date__c));
                System.debug('Overdue Days Calculated: ' + overdueDays);

                if (overdueDays > 0) {
                    Decimal fineAmount = overdueDays * 5; // $5 per day fine
                    System.debug('Fine Applied: ' + fineAmount + ' for ' + overdueDays + ' overdue days');

                    Fine__c fine = new Fine__c(
                        User__c = loan.User__c,
                        Loan__c = loan.Id, 
                        Fine_Amount__c = fineAmount, 
                        Fine_Status__c = 'Unpaid'
                    );

                    finesToInsert.add(fine);
                }
            } else {
                System.debug('Skipping fine calculation due to null Return Date.');
            }
        }
    }

    // Insert fines outside the loop
    if (!finesToInsert.isEmpty()) {
        insert finesToInsert;
        System.debug('Fine records inserted successfully.');
    }
}