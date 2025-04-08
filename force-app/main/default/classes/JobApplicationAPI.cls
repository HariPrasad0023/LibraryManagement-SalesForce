@RestResource(urlMapping='/jobapplications/*')
global with sharing class JobApplicationAPI {
    
    @HttpGet
    global static List<Job_Application__c> getJobApplications() {
        return [SELECT Id, Candidate_Name__c, Email__c, Status__c FROM Job_Application__c];
    }
}