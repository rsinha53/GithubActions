@istest(seealldata=false)
public class SNICaseCreationControllerTest {
    // US2526182: SNI Core - Select Policy when creating a new case - Vishal Yelisetti|4/30/2020
    @testsetup
    static void prepareTestData() {
        
        // Creating and Inserting Family Account
        Id recordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Family').getRecordTypeId();
        Account ac = new Account();
        ac.Member_ID__c = '453543543';
        ac.Policy_ID__c = '0070145';
        ac.Name =   'SampleTEstFLAcc1';
        ac.RecordTypeId = recordTypeId;
        ac.UHG_Restriction__c = 'No';
        ac.Onshore_Restriction__c = 'No';
        insert ac;
        
        // Creating and Inserting PersonAccount
        Id personAccRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Individual').getRecordTypeId();
        Account pa =new account();
        pa.PersonBirthdate = date.valueOf(ACETUtility.formatDateFutureDate('6/17/1979'));
        pa.firstName = 'paLastSample1'; 
        pa.lastName = 'paFirstSample1'; 
        pa.RecordTypeId = personAccRecordTypeId;
        insert pa;
        
        //Creating ACR with Person and Family
        account pa1 = [select id,personcontactid from account where id =: pa.id];
        AccountContactRelation acr = new AccountContactRelation();
        acr.ContactId = pa1.personcontactid;            
        acr.Accountid = ac.id;
        acr.Relationship__c = 'Child/Other';
        insert acr;
        
        //Inserting the Case for Contacted created
        Case case1 = new Case();
        case1.Status = 'Open';
        case1.Topic__c ='Claims';
        case1.ContactId = acr.ContactId;
        insert case1;
        system.runAs(new user(Id = userinfo.getUserId())){
            //Creating test User
            Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator']; 
            User u = new User(Alias = 'standt', Email='admin@testorg.com', 
                              EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
                              LocaleSidKey='en_US', ProfileId = p.Id, 
                              TimeZoneSidKey='America/Los_Angeles', UserName='admin@acettest.com');
            Insert u;
		}
        TestDataFactory.createInteraction();
        TestDataFactory.createInteraction();
    }
    
    @isTest
    static void verifyMemberIdSize() {
        
        Test.startTest();
        Case parentCase = [ SELECT caseid__c FROM Case LIMIT 1 ];
        List<String> memberid = SNICaseCreationController.getMemberIDs(parentCase.Id);
        System.assertEquals(2, memberid.size());
        Test.stopTest();
        
    }
    
    @isTest
    static void verifySingularMemberId() {
        
        Test.startTest();
        Account expectedAC = [ SELECT Member_ID__c, Policy_ID__c FROM Account LIMIT 1 ];
        Case parentCase = [ SELECT caseid__c FROM Case LIMIT 1 ];
        List<String> memberid = SNICaseCreationController.getMemberIDs(parentCase.Id);
        System.assertEquals('--None--', memberid.get(0));
        List<string> str = memberid.get(1).split(' - ');
        System.assertEquals(String.valueOf(expectedAC.Member_ID__c), str.get(0));
        System.assertEquals(String.valueOf(expectedAC.Policy_ID__c), str.get(1));
        Test.stopTest();
        
    } 
    
    @isTest
    static void verifyGroupID() {
        
        Test.startTest();
        Account expectedAC = [ SELECT Policy_ID__c FROM Account LIMIT 1 ];
        Case parentCase = [ SELECT caseid__c FROM Case LIMIT 1 ];
        List<String> memberid = SNICaseCreationController.getMemberIDs(parentCase.Id);
        List<string> str = memberid.get(1).split(' - ');
        Account acc = SNICaseCreationController.getGroupId(str.get(0), str.get(1));
        System.assertEquals(String.valueOf(expectedAC.Policy_ID__c), acc.Policy_ID__c);
        Test.stopTest();
        
    }
    @isTest
    static void GetAvailableRecordTypeAccountTest() {
        User u = [SELECT Id FROM User WHERE Email='admin@testorg.com']; 
        System.runAs(u) {
            Test.startTest();
            Id ecmRecordId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('ECM').getRecordTypeId();
            Map<String,String> recordType = SNICaseCreationController.GetAvailableRecordTypeAccount();
            System.assertEquals(recordType.get(ecmRecordId), 'ECM');
            Test.stopTest();
        }
        
    }
    @isTest
    static void getParentCaseFieldsTest() {
        User u = [SELECT Id FROM User WHERE Email='admin@testorg.com'];
        System.runAs(u) {
            Test.startTest();
            Case parentCase = [ SELECT caseid__c,Topic__c FROM Case LIMIT 1 ];
            List<String> caseValues = SNICaseCreationController.getParentCaseFields(parentCase.Id);
            //System.assertNotEquals(String.valueOf(caseValues[0]), 'Claims');
            SNICaseCreationController.getAccountInfo(parentCase.Id);
            Test.stopTest();
        }
    }
    static testMethod void test_getTTSFilterMapKeyStr(){
        User u = [SELECT Id FROM User WHERE Email='admin@testorg.com'];
        System.runAs(u) {
            test.startTest();
            list<string> testList = new list<String>();
            list<string> keylist = SNICaseCreationController.getTTSFilterMapKeyStr('View Member Eligibility');
            list<string> keylist2 = SNICaseCreationController.getTTSFilterMapValueStr('View Member Eligibility','View Member Eligibility');
            System.debug('Test Result::: '+ keylist);
            System.assertEquals(testList, keylist);
            test.stopTest();
        } 
    }
    
    static testMethod void test_saveTTSCase(){
        User u = [SELECT Id FROM User WHERE Email='admin@testorg.com'];
        System.runAs(u) {
            List<Interaction__c> lstInteractions = [SELECT Id FROM Interaction__c LIMIT 2];
            String caseString = '{"providerNotFound":false,"noProviderToSearch":true,"isOtherSearch":false,"Interaction":"'+lstInteractions[0].Id+'","OriginatorName":"undefined undefined","OriginatorType":"Provider","OriginatorRelationship":"Provider","OriginatorContactName":"rythjthjtyj","OriginatorPhone":"0112223334","OriginatorEmail":"example@abc.com","SubjectName":"AMANDA ADAM","SubjectDOB":"06/08/1977","SubjectType":"Member","SubjectId":"956876492","SubjectGroupId":"706577","AddInfoTopic":"View Member Eligibility","Status":"Closed","AddInfoOrginSubType":"Verify Eligibility","AddInfoOrginType":"Issue Resolved","AutoDoc":"<div></div>","AutoDocCaseItems":"caseitem1::caseitem1|caseitem2::caseitem2"}';
            String caseString2 = '{"providerNotFound":false,"noProviderToSearch":true,"isOtherSearch":false,"Interaction":"'+lstInteractions[0].Id+'","OriginatorName":"undefined undefined","OriginatorType":"Provider","OriginatorRelationship":"Provider","OriginatorContactName":"rythjthjtyj","OriginatorPhone":"0112223334","OriginatorEmail":"example@abc.com","SubjectName":"AMANDA ADAM","SubjectDOB":"06-08-1977","SubjectType":"Member","SubjectId":"956876492","SubjectGroupId":"706577","MisdirectReason":"","AddInfoTopic":"View Member Eligibility","Status":"Open","AddInfoOrginSubType":"","AddInfoOrginType":"System Unavailable","CaseCreationFrom":"Member_Snapshot_Policies","PolicyCount":"0","AutoDoc":"<div></div>"}';
            String caseStringMnf = '{"providerNotFound":false,"noProviderToSearch":true,"isOtherSearch":false,"mnf":"mnf","providerId":"","TaxId":"Commercial","noMemberToSearch":false,"Interaction":"'+lstInteractions[0].Id+'","OriginatorType":"Member","OriginatorRelationship":"","OriginatorContactName":"rythjthjtyj","OriginatorPhone":"556-758-7687","OriginatorEmail":"","SubjectName":"WEFWE CASCASC","SubjectDOB":"06/08/1977","SubjectType":"Member","SubjectId":"--","SubjectGroupId":"--","OriginatorName":"undefined CASCASC","AddInfoTopic":"Member Not Found","Status":"Closed","AddInfoOrginType":"Issue Resolved","AddInfoOrginSubType":"","ttsType":"Issue Resolved","ttsSubType":"COB Investigation Initiate","AutoDoc":"<div></div>","AutoDocCaseItems":"caseitem1::caseitem1|caseitem2::caseitem2"}';
            test.startTest();
            String caseId = SNICaseCreationController.saveTTSCase(caseString, true);
            String caseId2 = SNICaseCreationController.saveTTSCase(caseString2, true);
            String caseIdMnf = SNICaseCreationController.saveTTSCase(caseStringMnf, true);
            test.stopTest();
        }
    }
    static testMethod void test_saveTTSCase2(){
        User u = [SELECT Id FROM User WHERE Email='admin@testorg.com'];
        System.runAs(u) {
            List<Interaction__c> lstInteractions = [SELECT Id FROM Interaction__c LIMIT 2];
            String caseStringProviderNF = '{"Interaction":"'+lstInteractions[0].Id+'","Status":"Closed","OriginatorName":" WQEFWEGFWGFFGWFGE","OriginatorType":"Provider","OriginatorContactName":"sdvsdv","SubjectName":" WQEFWEGFWGFFGWFGE","SubjectType":"Member","SubjectDOB":"--","SubjectId":"--","SubjectGroupId":"--","TaxId":"4345544444","noProviderToSearch":false,"providerNotFound":true,"noMemberToSearch":true,"mnf":"","isOtherSearch":false,"AddInfoTopic":"Provider Not Found","AddInfoOrginType":"Issue Resolved","AddInfoOrginSubType":"","ttsType":"Issue Resolved","ttsSubType":"","AutoDoc":"<div></div>"}';
            String caseStringOther = '{"providerNotFound":false,"noProviderToSearch":false,"isOtherSearch":true,"mnf":"mnf","providerId":"88989898999","TaxId":"1212322233","noMemberToSearch":false,"Interaction":"'+lstInteractions[0].Id+'","OriginatorName":"SDGSDG SARMA","OriginatorType":"Other","OriginatorRelationship":"Internal/UHG Employee","OriginatorContactName":"SDGSDG SARMA","OriginatorPhone":"234-234-2342","OriginatorEmail":"--","SubjectName":"AMANDA ADAM","SubjectDOB":"06/08/1977","SubjectType":"Member","SubjectId":"956876492","SubjectGroupId":"706577","AddInfoTopic":"View Member Eligibility","Status":"Closed","PolicyCount":2,"CaseCreationFrom":"Member_Snapshot_Policies","AddInfoOrginType":"Issue Resolved","AddInfoOrginSubType":"COB Investigation Initiated","ttsType":"Issue Resolved","ttsSubType":"COB Investigation Initiated","AutoDoc":"<div></div>"}'; 
            test.startTest();
            String caseIdPnf = SNICaseCreationController.saveTTSCase(caseStringProviderNF, true);
            String caseIdOther = SNICaseCreationController.saveTTSCase(caseStringOther, false);
            test.stopTest();
        }
    }
    static testMethod void test_saveTTSCase3(){
        User u = [SELECT Id FROM User WHERE Email='admin@testorg.com'];
        System.runAs(u) {
            List<Interaction__c> lstInteractions = [SELECT Id FROM Interaction__c LIMIT 2];
            String caseStringMemberFromIO = '{"Interaction":"'+lstInteractions[0].Id+'","providerNotFound":false,"noProviderToSearch":false,"isOtherSearch":false,"mnf":"mnf","noMemberToSearch":false,"OriginatorName":"LARRY MARCUS","OriginatorType":"Provider","OriginatorRelationship":"","OriginatorContactName":"sdvsdv","OriginatorPhone":"203-384-3975","OriginatorEmail":"--","SubjectName":"AMANDA ADAM","SubjectDOB":"06/08/1977","SubjectType":"Member","SubjectId":"956876492","SubjectGroupId":"706577","memberContactId":"","AddInfoTopic":"View Member Eligibility","Status":"Closed","PolicyCount":2,"CaseCreationFrom":"Member_Snapshot_Policies","AddInfoOrginType":"Issue Routed","AddInfoOrginSubType":"Eligibility Investigation Initiated","ttsType":"Issue Routed","ttsSubType":"Eligibility Investigation Initiated","AutoDoc":"<div></div>"}';
            String caseStringProviderOnly = '{"Interaction":"'+lstInteractions[0].Id+'","providerId":"000006798","TaxId":"061330992","noProviderToSearch":false,"providerNotFound":false,"noMemberToSearch":true,"mnf":"","OriginatorName":"LARRY M MARCUS  ","OriginatorType":"Provider","OriginatorContactName":"sdvsdv","SubjectName":"LARRY MARCUS","SubjectType":"Provider","SubjectDOB":"--","SubjectId":"--","SubjectGroupId":"--","AddInfoTopic":"Provider Details","Status":"Closed","AddInfoOrginType":"Issue Resolved","AddInfoOrginSubType":"Details Provided","ttsType":"Issue Resolved","ttsSubType":"Details Provided","AutoDoc":"<div></div>"}';
            test.startTest();
            String caseIdMemberFromIO = SNICaseCreationController.saveTTSCase(caseStringMemberFromIO, true);
            String caseIdProviderOnly = SNICaseCreationController.saveTTSCase(caseStringProviderOnly, true);
            test.stopTest();
        }
        
    }
    @isTest
    static void verifyRestrictions() {
        User u = [SELECT Id FROM User WHERE Email='admin@testorg.com'];
        u.Agent_Type__c = 'Offshore';
        u.UHG_Access__c = 'No';
        update u;
        System.runAs(u) {
            Test.startTest();
            Account expectedAC = [ SELECT Member_ID__c, Policy_ID__c FROM Account LIMIT 1 ];
            expectedAC.UHG_Restriction__c = 'Yes';
            update expectedAC;
            Case parentCase = [ SELECT caseid__c FROM Case LIMIT 1 ];
            List<String> memberid = SNICaseCreationController.getMemberIDs(parentCase.Id);
            System.assertEquals(1, memberid.size());
            expectedAC.UHG_Restriction__c = 'No';
            update expectedAC;
            List<String> memberid2 = SNICaseCreationController.getMemberIDs(parentCase.Id);
            System.assertEquals(2, memberid2.size());
            expectedAC.Onshore_Restriction__c = 'Yes';
            update expectedAC;
            List<String> memberid3 = SNICaseCreationController.getMemberIDs(parentCase.Id);
            System.assertEquals(1, memberid3.size());
            Test.stopTest();
        }
    }
}