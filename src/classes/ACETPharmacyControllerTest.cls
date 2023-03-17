@isTest(SeeAllData=false)
public  class ACETPharmacyControllerTest 
{   
    static testMethod void ACETPharmacyControllerTest1() {
        ACETOrgNameToSwivelEndpointMap__c ISETURLTemplate = ACETTestDataUtility.createORGNameToSwivelData('dev_ISETWrap', '/idp/login?app=0sp21000000CaSt&RelayState=http://iset-dev.uhc.com/HAPortlet/acet_token.jsp?applicationSource=ACET&carrierID=UHCOXFD01&memberID={0}&firstName={1}&lastName={2}&dob={3}&gender={4}');
        insert ISETURLTemplate;
        
        ACETWrapEncryptionKey__c ISETEncryptionKey = new ACETWrapEncryptionKey__c(Name='dev_ISETEncryptionKey', Key__c='tbC2KA36qE1psxs9mozyfOmy7GdrI3I9', Algorithm_Name__c='AES256');
        insert ISETEncryptionKey;
        
        RecordType newRecord = [SELECT Id FROM RecordType WHERE Name = 'Person Account' and SObjectType = 'Account'];
        
        Account accountTest = new Account();
        accountTest.FirstName = 'Test Contact FN1';
        accountTest.LastName = 'Test Contact LN1';
        accountTest.EID__c = 'TestEID1';
        accountTest.EID__pc = 'TestEID1';
        accountTest.RecordTypeId = newRecord.Id;
        insert accountTest;

    Account acc = [SELECT Id,personcontactid from Account where Id=:accountTest.Id];
        Contact oContact = [SELECT Id,LastName,FirstName,EID__c,AccountId from Contact where Id=:acc.personcontactid];
        oContact.Tax_ID__c = 'TstTaxID1';
        oContact.NPI__c = 'TestNPI1';

        Interaction__c oInteraction = ACETTestDataUtility.CreateInteraction(oContact.Id, 'Phone', 'Member', oContact.LastName);
        insert oInteraction;
        
        Test.startTest();
        
        PageReference ACETPP = Page.ACETPharmacyPage;
        ACETPP.getParameters().put('interactionId', oInteraction.Id);
        ACETPP.getParameters().put('contactId', oContact.Id);
        ACETPP.getParameters().put('sourceOriginator', 'Phone Call');
        ACETPP.getParameters().put('additionalInfo', '{"Relationship":"Self","Product":"Gated INN only","OriginatorRelationship":"Self","MemberId":"36781823800","LastName":"Baker","isMember":" true","GroupNumber":"1118476","Gender":"M","FirstName":"Wayne","EndDate":"12/31/9999","EffectiveDate":"1/1/2015","DOB":"11/7/1966","BenefitPlanId":"M000000010"}');
        ACETPP.getParameters().put('memberId', '36781823800');
        ACETPP.getParameters().put('SRK', '');
        ACETPP.getParameters().put('callTopic', 'Pharmacy Inquiry');
        Test.setCurrentPageReference(ACETPP);
        
        ACETPharmacyController ACETPPCtrl = new ACETPharmacyController();
        ACETPPCtrl.wrapper.CaseRecordTypeLabel = 'ECM';
        ACETPPCtrl.csrfNumber = 'csrfNumber2';
        ACETPPCtrl.selectedValue = 'Yes';
        ACETPPCtrl.wrapper.isSystemUnavailable = false;
        ACETPPCtrl.SaveAndClose();
        ACETPPCtrl.ChangeDateFormatForOIL('12/01/2020');
        
        Test.stopTest();
    }
    
    static testMethod void ACETPharmacyControllerTest2() {
        ACETOrgNameToSwivelEndpointMap__c ISETURLTemplate = ACETTestDataUtility.createORGNameToSwivelData('dev_ISETWrap', '/idp/login?app=0sp21000000CaSt&RelayState=http://iset-dev.uhc.com/HAPortlet/acet_token.jsp?applicationSource=ACET&carrierID=UHCOXFD01&memberID={0}&firstName={1}&lastName={2}&dob={3}&gender={4}');
        insert ISETURLTemplate;
        
        ACETWrapEncryptionKey__c ISETEncryptionKey = new ACETWrapEncryptionKey__c(Name='dev_ISETEncryptionKey', Key__c='tbC2KA36qE1psxs9mozyfOmy7GdrI3I9', Algorithm_Name__c='AES256');
        insert ISETEncryptionKey;
        
        RecordType newRecord = [SELECT Id FROM RecordType WHERE Name = 'Person Account' and SObjectType = 'Account'];
        
        Account accountTest = new Account();
        accountTest.FirstName = 'Test Contact FN1';
        accountTest.LastName = 'Test Contact LN1';
        accountTest.EID__c = 'TestEID1';
        accountTest.EID__pc = 'TestEID1';
        accountTest.RecordTypeId = newRecord.Id;
        insert accountTest;

    Account acc = [SELECT Id,personcontactid from Account where Id=:accountTest.Id];
        Contact oContact = [SELECT Id,LastName,FirstName,EID__c,AccountId from Contact where Id=:acc.personcontactid];
        oContact.Tax_ID__c = 'TstTaxID1';
        oContact.NPI__c = 'TestNPI1';
        
        Interaction__c oInteraction = ACETTestDataUtility.CreateInteraction(oContact.Id, 'Phone', 'Member', oContact.LastName);
        insert oInteraction;
        
        Test.startTest();
        
        PageReference ACETPP = Page.ACETPharmacyPage;
        ACETPP.getParameters().put('interactionId', oInteraction.Id);
        ACETPP.getParameters().put('contactId', oContact.Id);
        ACETPP.getParameters().put('sourceOriginator', 'Phone Call');
        ACETPP.getParameters().put('additionalInfo', '{"Relationship":"Self","Product":"Gated INN only","OriginatorRelationship":"Self","MemberId":"36781823800","LastName":"Baker","isMember":" true","GroupNumber":"1118476","Gender":"M","FirstName":"Wayne","EndDate":"12/31/9999","EffectiveDate":"1/1/2015","DOB":"11/7/1966","BenefitPlanId":"M000000010"}');
        ACETPP.getParameters().put('memberId', '36781823800');
        ACETPP.getParameters().put('SRK', '');
        ACETPP.getParameters().put('callTopic', 'Pharmacy Inquiry');
       
        Test.setCurrentPageReference(ACETPP);
        
        ACETPharmacyController ACETPPCtrl = new ACETPharmacyController();
        ACETPPCtrl.csrfNumber = 'csrfNumber2';
        ACETPPCtrl.selectedValue = 'No';
        ACETPPCtrl.benefitPlanId ='12345';
        ACETPPCtrl.wrapper.CaseRecordTypeLabel = 'ECM';
        ACETPPCtrl.wrapper.isSystemUnavailable = true;
        ACETPPCtrl.SaveAndClose();
        ACETPPCtrl.showSA =true;
        ACETPPCtrl.showSaMethodCon();
        ACETPPCtrl.getPharmacyInquiryCallTypes();
        ACETPPCtrl.getCSRFURL();
        ACETPPCtrl.ChangeDateFormatForOIL('12/11/2020');
        
        Test.stopTest();
    }
}