@isTest(SeeAllData=false)
public  class ACETCirrusLandingPageCtrlTest
{   
    static testMethod void ACETCirrusLandingPageCtrlTest1() {
        
        
        ACETOrgNameToSwivelEndpointMap__c CirrusURLTemplate = ACETTestDataUtility.createORGNameToSwivelData('dev_CIRRUSWrapURL','/idp/login?app=0spm0000000008y&RelayState=https://cirrus-dev.optum.com/pingfederatesso.uhg?externalIDType=SC&landingPage={2}&encryptedData=affiliationExternalID={0}&memGroup={1}');
        insert CirrusURLTemplate;
        ACETOrgNameToSwivelEndpointMap__c CirrusURLTemplate1 = ACETTestDataUtility.createORGNameToSwivelData('d1_CIRRUSWrapURL','/idp/login?app=0spm0000000008y&RelayState=https://cirrus-dev.optum.com/pingfederatesso.uhg?externalIDType=SC&landingPage={2}&encryptedData=affiliationExternalID={0}&memGroup={1}');
        insert CirrusURLTemplate1;
        ACETOrgNameToSwivelEndpointMap__c CirrusURLTemplate2 = ACETTestDataUtility.createORGNameToSwivelData('qa_CIRRUSWrapURL','/idp/login?app=0spm0000000008y&RelayState=https://cirrus-dev.optum.com/pingfederatesso.uhg?externalIDType=SC&landingPage={2}&encryptedData=affiliationExternalID={0}&memGroup={1}');
        insert CirrusURLTemplate2;
        ACETOrgNameToSwivelEndpointMap__c CirrusURLTemplate3 = ACETTestDataUtility.createORGNameToSwivelData('prd_CIRRUSWrapURL','/idp/login?app=0spm0000000008y&RelayState=https://cirrus-dev.optum.com/pingfederatesso.uhg?externalIDType=SC&landingPage={2}&encryptedData=affiliationExternalID={0}&memGroup={1}');
        insert CirrusURLTemplate3;
        ACETWrapEncryptionKey__c CirrusEncryptionKey= new ACETWrapEncryptionKey__c(Name='dev_CirrusEncryptionKey', Key__c='tbC2KA36qE1psxs9mozyfOmy7GdrI3I9', Algorithm_Name__c='AES256');
        insert CirrusEncryptionKey;
        ACETWrapEncryptionKey__c CirrusEncryptionKey1= new ACETWrapEncryptionKey__c(Name='d1_CirrusEncryptionKey', Key__c='tbC2KA36qE1psxs9mozyfOmy7GdrI3I9', Algorithm_Name__c='AES256');
        insert CirrusEncryptionKey1;
        ACETWrapEncryptionKey__c CirrusEncryptionKey2= new ACETWrapEncryptionKey__c(Name='qa_CirrusEncryptionKey', Key__c='tbC2KA36qE1psxs9mozyfOmy7GdrI3I9', Algorithm_Name__c='AES256');
        insert CirrusEncryptionKey2;
        ACETWrapEncryptionKey__c CirrusEncryptionKey3= new ACETWrapEncryptionKey__c(Name='prd_CirrusEncryptionKey', Key__c='tbC2KA36qE1psxs9mozyfOmy7GdrI3I9', Algorithm_Name__c='AES256');
        insert CirrusEncryptionKey3;
        
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
        
        PageReference ACETPP = Page.ACETPlanBenefitSearchRedesign;
        ACETPP.getParameters().put('interactionId', oInteraction.Id);
        ACETPP.getParameters().put('contactId', oContact.Id);
        ACETPP.getParameters().put('sourceOriginator', 'Phone Call');
        ACETPP.getParameters().put('additionalInfo', '{"Relationship":"Self","Product":"Gated INN only","OriginatorRelationship":"Self","MemberId":"36781823800","LastName":"Baker","isMember":" true","GroupNumber":"1118476","Gender":"M","FirstName":"Wayne","EndDate":"12/31/9999","EffectiveDate":"1/1/2015","DOB":"11/7/1966","BenefitPlanId":"M000000010"}');
        ACETPP.getParameters().put('MemberId', '36781823800');
        Test.setCurrentPageReference(ACETPP);
        ACETCirrusLandingPageCtrl ACETPPCtrl = new ACETCirrusLandingPageCtrl();
        ACETPPCtrl.setGroupId('1234567');
        ACETPPCtrl.setMemberId('12345678900');
        ACETPPCtrl.getMemberId();
        ACETPPCtrl.getGroupId();
        
        //ACETPPCtrl.CIRRUSURL = '/idp/login?app=0spm0000000008y&RelayState=https://cirrus-dev.optum.com/pingfederatesso.uhg?landingPage=memberDetail&encryptedData=memberID={0}';
        
        Test.stopTest();
    }
}