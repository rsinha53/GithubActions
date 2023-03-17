/*
ACETCPMCaseRouteControllerTest
Testing Class Name:  ACETCPMCaseRouteController
Author: Ganesh Medisetti
Date: 08/17/2020
Description: This is test class and used to get test coverage for ACETCPMCaseRouteController. 
Initial: Ganesh Medisetti
*/
@isTest
public class ACETCPMCaseRouteControllerTest {
	@isTest 
    public static void testFetchCsIdNBaseUrl() {
        Case cs = new Case(subject = 'Text');
        insert cs;
        Project_Submission_Detail__c sbd = new Project_Submission_Detail__c(case__c = cs.id);
        insert sbd;
		ACETCPMCaseRouteController.fetchCsIdNBaseUrl(string.valueOf(sbd.id));
        Project_Details__c projDetails = new Project_Details__c(Parent_Case__c = cs.id);
        insert projDetails;
        Claim_Impact_Report_Form__c cirf = new Claim_Impact_Report_Form__c(Project_Details__c = projDetails.Id);
        insert cirf;
        ACETCPMCaseRouteController.fetchCsIdNBaseUrl(cirf.id);
    }
}