@isTest 
public class ACETLGT_Covid19ControllerTest {
    static testMethod void getCovidVaccineDetailsTest() {
        
		 String subjectFName = 'ELIZABETH';
       	 String subjectLName = 'YENO';
         String subjectDOB = '12/07/1979'; 
        Interaction__c intr = TestDataFactory.createInteraction();
        case ca = TestDataFactory.createCase();
        ca.Interaction__c = intr.Id;
        ca.Surrogate_Key__c = '1256789';
        ca.Topic__c = 'Member Overview';
        ca.Type__c = 'Issue Resolved';
        ca.Subtype__c = 'Adoption';
        update ca;
        Test.startTest();
         ACETLGT_LastCallController.getLastCalldetails('1256789');
         List<String> covidDetails1=ACETLGT_Covid19Controller.getCovidVaccineDetails(subjectFName, subjectLName, subjectDOB);
         List<String> covidDetails2=ACETLGT_Covid19Controller.getCovidVaccineDetails(null, null, null);
         Test.stopTest();
         System.assertNotEquals(null, covidDetails1);
          System.assertEquals(null, covidDetails2);
        
        
    }

}