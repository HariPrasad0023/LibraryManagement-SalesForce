@RestResource(urlMapping='/loanUpdate/*')
global without sharing class LoanUpdateController {

    @HttpPost
    global static List<Loan__c> getLoansByMember() {
        RestRequest req = RestContext.request;
        RestResponse res = RestContext.response;

        try {
            // ✅ Parse request body
            String requestBody = req.requestBody.toString();
            Map<String, Object> requestData = (Map<String, Object>) JSON.deserializeUntyped(requestBody);

            // ✅ Extract sessionToken from request body
            String sessionToken = (String) requestData.get('sessionToken');

            if (String.isEmpty(sessionToken)) {
                res.responseBody = Blob.valueOf('{"error": "Session token is required"}');
                res.statusCode = 400;
                return null;
            }

            System.debug('=== Extracted Session Token: ' + sessionToken);

            // ✅ Fetch the member with the session token
            List<Member__c> members = [SELECT Id FROM Member__c WHERE Session_Token__c = :sessionToken LIMIT 1];

            if (members.isEmpty()) {
                System.debug('=== Invalid Session Token: ' + sessionToken);
                res.responseBody = Blob.valueOf('{"error": "Invalid session token"}');
                res.statusCode = 401;
                return null;
            }

            Member__c member = members[0];
            System.debug('=== Found Member ID: ' + member.Id);

            // ✅ Fetch the loans related to the member
            List<Loan__c> loans = [SELECT Id, Loan_Status__c, Loan_Date__c, Due_Date__c, Return_Date__c, 
                                   Book__c, Book__r.Name  
                                   FROM Loan__c WHERE Member__c = :member.Id];

            System.debug('=== Retrieved Loans: ' + loans);

            return loans;

        } catch (Exception e) {
            System.debug('=== ERROR: ' + e.getMessage());

            res.responseBody = Blob.valueOf('{"error": "' + e.getMessage() + '"}');
            res.statusCode = 500;
            return null;
        }
    }
}