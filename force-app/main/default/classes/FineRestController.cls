@RestResource(urlMapping='/fines/*')
global with sharing class FineRestController {

    @HttpGet
    global static String getFinesByMember() {  // Change return type to String
        try {
            RestRequest req = RestContext.request;
            String sessionToken = req.params.get('SessionToken');

            if (String.isBlank(sessionToken)) {
                RestContext.response.statusCode = 400;  
                return JSON.serialize(new Map<String, Object>{
                    'success' => false,
                    'message' => 'SessionToken is required'
                });
            }

            List<Member__c> members = [SELECT Id FROM Member__c WHERE Session_Token__c = :sessionToken LIMIT 1];

            if (members.isEmpty()) {
                RestContext.response.statusCode = 401;  
                return JSON.serialize(new Map<String, Object>{
                    'success' => false,
                    'message' => 'Invalid session token'
                });
            }

            Member__c member = members[0];
            List<Fine__c> fines = [SELECT Id, Loan__c, Member__c, Fine_Amount__c, Fine_Status__c, Fine_Paid_Date__c 
                                   FROM Fine__c WHERE Member__c = :member.Id];

            return JSON.serialize(new Map<String, Object>{  
                'success' => true,
                'fines' => fines
            });

        } catch (Exception e) {
            RestContext.response.statusCode = 500;  
            return JSON.serialize(new Map<String, Object>{
                'success' => false,
                'message' => 'Error: ' + e.getMessage()
            });
        }
    }
}
