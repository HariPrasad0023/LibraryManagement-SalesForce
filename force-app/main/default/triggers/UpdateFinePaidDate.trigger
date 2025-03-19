trigger UpdateFinePaidDate on Fine__c (before update) {
	Fine__c fine = Trigger.new[0];  // Get the single updated record
	Fine__c oldFine = Trigger.oldMap.get(fine.Id);

	if (oldFine.Fine_Status__c == 'Unpaid' && fine.Fine_Status__c == 'Paid') {
    	fine.Fine_Paid_Date__c = Date.today();
    	System.debug('Fine ID: ' + fine.Id + ' marked as Paid. Updating Fine Paid Date: ' + Date.today());
	}
}