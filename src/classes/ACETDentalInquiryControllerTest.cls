@isTest(seeAllData = false)
public with sharing class ACETDentalInquiryControllerTest 
{
    /*  static testMethod void DentalInquiryControllerTestsave()
      {  
        PageReference ACETDentalInquiry = Page.ACETDentalInquiry;
        Test.setCurrentPage(ACETDentalInquiry);
        Test.startTest();
            Account accountRec = ACETTestDataUtility.createAccount('test Account');
            insert accountRec;
            
            Contact contactRec = ACETTestDataUtility.createContact(accountRec.Id,'Test','Contact');
            insert contactRec;
            
            ACETDentalInquiryController  DentalInquirycontroller = new ACETDentalInquiryController();
          //  DentalInquirycontroller.getDentalInquiryCallTypes();
            ACETCallTopicsDataWrapper acetCallTopicDW = new ACETCallTopicsDataWrapper();
            acetCallTopicDW.saveCase();
        Test.stopTest();
        system.AssertNotEquals(acetCallTopicDW.caseObj.id,null);
       } */
   
      static testMethod void DentalInquiryControllerTestsaveClose()
      { 
        PageReference ACETDentalInquiry = Page.ACETDentalInquiry;
        Test.setCurrentPage(ACETDentalInquiry);
        Test.startTest();
            /*Account accountRec = ACETTestDataUtility.createAccount('test Account');
            insert accountRec;
            
            Contact contactRec = ACETTestDataUtility.createContact(accountRec.Id,'Test','Contact');
            insert contactRec;*/
            
             RecordType newRecord = [SELECT Id FROM RecordType WHERE Name = 'Person Account' and SObjectType = 'Account'];
        
        Account accountTest = new Account();
        accountTest.FirstName = 'Test Contact FN1';
        accountTest.LastName = 'Test Contact LN1';
        accountTest.EID__c = 'TestEID1';
        accountTest.EID__pc = 'TestEID1';
        accountTest.RecordTypeId = newRecord.Id;
        insert accountTest;

    Account accountRec = [SELECT Id,personcontactid from Account where Id=:accountTest.Id];
        Contact contactRec = [SELECT Id,Name,LastName,FirstName,EID__c,AccountId from Contact where Id=:accountRec.personcontactid];
        
            
            Interaction__c inter = ACETProviderUtility.CreateInteraction(contactRec.Id,'Phone','',ContactRec.name);
            inter.Highlight_Panel_GroupInfo__c='{"UHCBS":"YES","ServiceTeam":"National Accounts","RiskManagement":"Audit","RenewalDate":"4/6/2018","RelationshipType":null,"RatingMethod":"","GroupStatus":"Active","groupSName":"37E9769CORG1","GroupName":"37E9769C - 37E9769CORG1","EffectiveStartDate":"4/6/2017"}';
            insert inter;
            
             apexpages.currentpage().getparameters().put('interactionId',inter.id);
             apexpages.currentpage().getparameters().put('contactId',contactRec.id);
             System.assertEquals( inter.id,ApexPages.currentPage().getParameters().get('interactionId'));
            
            ACETDentalInquiryController  DentalInquirycontroller = new ACETDentalInquiryController();
           // DentalInquirycontroller.getDentalInquiryCallTypes();
            ACETCallTopicsDataWrapper acetCallTopicDW = new ACETCallTopicsDataWrapper();
            acetCallTopicDW.saveAndClose();
        Test.stopTest();
        system.AssertNotEquals(acetCallTopicDW.caseObj.id,null);
        system.AssertEquals(acetCallTopicDW.caseObj.status,'Closed');
       }
    
      static testMethod void DentalInquiryControllerTestCancel()
      {  
        
        
         /*   Account accountRec = ACETTestDataUtility.createAccount('test Account');
            insert accountRec;
            
            Contact contactRec = ACETTestDataUtility.createContact(accountRec.Id,'Test','Contact');
            insert contactRec;*/
            
             RecordType newRecord = [SELECT Id FROM RecordType WHERE Name = 'Person Account' and SObjectType = 'Account'];
        
        Account accountTest = new Account();
        accountTest.FirstName = 'Test Contact FN1';
        accountTest.LastName = 'Test Contact LN1';
        accountTest.EID__c = 'TestEID1';
        accountTest.EID__pc = 'TestEID1';
        accountTest.RecordTypeId = newRecord.Id;
        insert accountTest;

    Account accountRec = [SELECT Id,personcontactid from Account where Id=:accountTest.Id];
        Contact contactRec = [SELECT Id,LastName,FirstName,EID__c,AccountId from Contact where Id=:accountRec.personcontactid];
        
            
            Interaction__c inter = ACETProviderUtility.CreateInteraction(contactRec.Id,'Phone','','Testcontact');
            inter.Highlight_Panel_GroupInfo__c='{"UHCBS":"YES","ServiceTeam":"National Accounts","RiskManagement":"Audit","RenewalDate":"4/6/2018","RelationshipType":null,"RatingMethod":"","GroupStatus":"Active","groupSName":"37E9769CORG1","GroupName":"37E9769C - 37E9769CORG1","EffectiveStartDate":"4/6/2017"}';
            insert inter;
            system.debug('testinggggg'+inter);
            Test.startTest();
            PageReference ACETDentalInquiry = Page.ACETDentalInquiry;
            Test.setCurrentPage(ACETDentalInquiry);            
            
            apexpages.currentpage().getparameters().put('interactionId',inter.id);
            apexpages.currentpage().getparameters().put('contactId',contactRec.id);
             System.assertEquals( inter.id,ApexPages.currentPage().getParameters().get('interactionId'));
              
            ACETCaseActionsController employerBrokercancel= new ACETCaseActionsController(); 
            
            pageReference pageRef = employerBrokercancel.cancel();
            Test.stopTest();        
      }
      
       static testMethod void testSwivelToFACETS()
       {
          ACETOrgInstanceURLToOrgNameMap__c orgInstance = new ACETOrgInstanceURLToOrgNameMap__c();
          orgInstance = ACETTestDataUtility.createOrgInstanceToOrgNameData('testURL','dev');
          insert orgInstance ;
          
          ACETOrgNameToSwivelEndpointMap__c swivelEndPoint = new ACETOrgNameToSwivelEndpointMap__c();
          swivelEndPoint = ACETTestDataUtility.createORGNameToSwivelData('dev_FACETS','https://custhspprod.tzghosting.net/vpn/index.html');
          insert swivelEndPoint ;
          
          ACETUtility.GetOrgName();
          ACETUtility.GetSwivelEndpointByOrgName('dev','FACETS');
      }
    
}