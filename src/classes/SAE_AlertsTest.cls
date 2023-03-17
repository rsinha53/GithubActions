@isTest
public class SAE_AlertsTest {
	  static testMethod void misdirectCtrlMethod1(){
        test.startTest();
          Alert__c alert = new Alert__c();
          alert.Alert_Comments__c = 'Test Comments';
          alert.ID_Number__c = '9898988898';
          alert.Group_Number__c = '34234243';
          alert.Type__c = 'Provider';
          alert.Effective_Date__c = system.today();
          alert.End_Date__c = system.today() + 1;
          alert.Alert_Title__c = 'Test Title';
          insert alert;
          
          Interaction__c inter = new Interaction__c();
          inter.Group_ID__c = '3434234';
          inter.Contact_Name__c = 'Test Name';
          insert inter;
          
          Interaction_Alert__C intAlert = new Interaction_Alert__C();
          intAlert.Interaction__c = inter.Id;
          intAlert.Alert__c = alert.id;
          insert intAlert;
          
          list<Alert__c> ia = new list<Alert__c>();
          ia.add(alert);
		        
          SAE_AlertsCtrl.getAlertsData();
          SAE_AlertsCtrl.createInteractionAlert(ia, inter.Id);
          
        test.stopTest();
    }

    static testMethod void test_Alerts_SOSL(){
        test.startTest();
        Alert__c alert = new Alert__c();
        alert.Alert_Comments__c = 'Test Comments';
        alert.ID_Number__c = '9898988898';
        alert.Group_Number__c = '34234243';
        alert.Type__c = 'Provider';
        alert.Effective_Date__c = system.today();
        alert.End_Date__c = system.today() + 1;
        alert.Alert_Title__c = 'Test Title';
        insert alert;

        Interaction__c inter = new Interaction__c();
        inter.Group_ID__c = '3434234';
        inter.Contact_Name__c = 'Test Name';
        insert inter;

        Id [] fixedSearchResults= new Id[1];
        fixedSearchResults[0] = alert.Id;
        Test.setFixedSearchResults(fixedSearchResults);
        SAE_AlertsCtrl.getAlertsIO('34234243','9898988898');
        SAE_AlertsCtrl.policyAlerts('34234212243','989833988898','9898988898','34121234243');
        SAE_AlertsCtrl.snapshotAlerts('34234212243','989833988898','989893388898','34121234243','23232','3232','34234243');

        test.stopTest();
      }
}