@isTest
public class ETSBE_CaseAgeControllerTest {
    
    static testMethod void validateCaseAge() {        
        
        List<Case> caseList = new List<Case>();
        
        Case caseObj = new Case();
        caseObj.Event_Type__c = 'Standard';
        caseList.add(caseObj);
        
        Interaction__c interactObj = new Interaction__c();
        
        interactObj.Interaction_Type__c = 'Phone Call';
        interactObj.Evt_Recvd_Dt_Time__c = DateTime.newInstance(2020, 03, 26, 06, 00, 00);
        interactObj.Other_Admin_Type__c = 'Attorney';
        interactObj.Originator_Type__c = 'Other Admin';
        interactObj.Contact_Name__c = 'Willow Best';
        interactObj.Originator_Name__c = 'Willow Best';
        interactObj.Customer_Admin_Type__c = 'Other Admin';
        interactObj.Originator_Email__c = 'willow@uhc.com';
            
        insert interactObj;
        
        Case caseObj1 = new Case();
        caseObj1.Event_Type__c = 'Standard';
        caseObj1.Interaction__c = interactObj.Id;
        caseObj1.Is_Cloned__c = true;
        caseList.add(caseObj1);
        
        Case caseObj2 = new Case();
        caseObj2.Event_Type__c = 'Standard';
        caseObj2.Status = 'Closed';
        caseList.add(caseObj2);
        
        insert caseList;
        
        ETSBE_CaseAgeController.calculateCaseAge(caseObj.Id);
        ETSBE_CaseAgeController.calculateCaseAge(caseObj1.Id);
        ETSBE_CaseAgeController.calculateCaseAge(caseObj2.Id);
    }

}