trigger SetDefaultStatus on Job_Application__c (before insert) {
	for (Job_Application__c job : Trigger.new) {
        if (job.Status__c == null) { // If no status is provided
            job.Status__c = 'Pending Review'; // Default status
        }
    }
}