@isTest
class ACETLGT_CaseActionsControllerTest {
    @testSetup
    static void setupTestData() {
        Contact cont = TestDataFactory.createContact();
        Interaction__c interaction = new Interaction__c();
        interaction.Contact_Name__c = 'Text Iname';
        interaction.Originator__c = cont.id;
        interaction.Originator_Type__c = 'Member';
        interaction.Interaction_Type__c = 'Phone Call';
        
        insert interaction;
        
        list<Alert__c> alerts = new list<Alert__c>();
        Alert__c alert = new Alert__c();
        alert.Benefit_Bundle_Option_ID__c = '123456789';
        alert.Effective_Date__c = Date.today().addDays(-5);
        alert.End_Date__c = Date.today().addDays(5);
        alert.Type__c = 'Member Group';
        alert.Alert_Comments__c = 'Alert Comments';
        alert.Alert_Title__c = 'Alert Title';
        alerts.add(alert);
        
        Alert__c memalert = new Alert__c();
        
        memalert.ID_Number__c = '123456789';
        memalert.Effective_Date__c = Date.today().addDays(-5);
        memalert.End_Date__c = Date.today().addDays(5);
        memalert.Type__c = 'Member';
        memalert.Alert_Comments__c = 'Alert Comments';
        memalert.Alert_Title__c = 'Alert Title';
        alerts.add(memalert);
        
        Alert__c grpalert = new Alert__c();
        
        grpalert.Group_Number__c = '1234567';
        grpalert.Effective_Date__c = Date.today().addDays(-5);
        grpalert.End_Date__c = Date.today().addDays(5);
        grpalert.Type__c = 'Group';
        grpalert.Alert_Comments__c = 'Alert Comments';
        grpalert.Alert_Title__c = 'Alert Title';
        alerts.add(grpalert);
        insert alerts;
        
        
        
        ACETOrgInstanceURLToOrgNameMap__c setting = new ACETOrgInstanceURLToOrgNameMap__c();
        setting.Org_Name__c = 'qa';
        setting.Name = 'oxfdlight';
        insert setting;
        
        ACETOrgInstanceURLToOrgNameMap__c setting1 = new ACETOrgInstanceURLToOrgNameMap__c();
        setting1.Org_Name__c = 'qa';
        setting1.Name = 'fullcopy';
        insert setting1;
        
        ACETOrgNameToSwivelEndpointMap__c swive = new ACETOrgNameToSwivelEndpointMap__c();
        swive.Swivel_Endpoint__c = '/idp/login?app=0sp0j000000CaSP&RelayState=https://icuealpha.uhc.com/icue/pcpReferralSSOLogin.uhg?';
        swive.Name = 'qa_ICUEPCPReferral';
        insert swive;
        
        ACETWrapEncryptionKey__c encKey = new ACETWrapEncryptionKey__c();
        encKey.Name = 'qa_ICUEEncryptionKey';
        encKey.Key__c = 'JYbyFR9zdZFrGRzgaJtCTyLpFkIXFOs4';
        insert encKey;
        
        List<Call_Topic_Access__c> accesses = new List<Call_Topic_Access__c>();
        Call_Topic_Access__c ctAccess = new Call_Topic_Access__c();
        ctAccess.Call_Topic__c = 'Create PCP Referral';
        ctAccess.Limit_To_Roles__c = 'Accounts Payable - Agent;Resolution Specialist - Agent';
        accesses.add(ctAccess);
        
        ctAccess = new Call_Topic_Access__c();
        ctAccess.Call_Topic__c = 'View Claims';
        accesses.add(ctAccess);
        insert accesses;
        
        TTS_Access__c access = new TTS_Access__c();
        access.Topic__c = 'View Claims';
        access.Limit_To_Profiles__c = 'System Administrator;Provider Claims;SNI Member;SNI_ECM_Back_Office_Agent';
        access.Type__c = 'Accumulator Inquiry';
        insert access;
    }

    @isTest static void testCreateCase() {
        Interaction__c interaction = [SELECT Id, Originator__c, Contact_Name__c, Originator_Type__c, Interaction_Type__c
                                     FROM Interaction__c LIMIT 1];
        String autoDocCaseInfo = 'key1;12345::val1|key2;12345::val2';
        ACETLGT_HighlightPanelInfo info = new ACETLGT_HighlightPanelInfo();
        info.originatorID = interaction.Originator__c;
		Case parentCase = new Case();
        insert parentCase;

        try{        
            Case newCase = ACETLGT_CaseActionsController.createCase(interaction.Id, interaction.Originator__c, '', 'View Claims',
                                                                    'Accumulator Inquiry', 'Accumulator Rebuild',false,false,false,'', 'abcdefgh', 'comments', 'autodocData', autoDocCaseInfo,'Test', 'caseDataWrapper', info,parentCase.Id);
            System.assert(newCase.Status == 'Open');            
        }
        catch(Exception ex){
            System.debug('Profile Error: '+ex.getMessage());
        }
    }
    
    @isTest static void testGetAllMemberAlerts() {
        Interaction__c interaction = [SELECT Id, Originator__c, Contact_Name__c, Originator_Type__c, Interaction_Type__c
                                     FROM Interaction__c LIMIT 1];
        Alert__c alert = [SELECT Id FROM Alert__c LIMIT 1];
        Id [] fixedSearchResults = new Id[]{alert.Id};
        Test.setFixedSearchResults(fixedSearchResults);
        ACETLGT_CaseActionsController.getAllMemberAlerts('123456789', '12345678', interaction.Id, '123456789');
    }
    
    @isTest static void testGetOptumExlusions() {
        System.assert(ACETLGT_CaseActionsController.getOptumExlusions() != null);
    }

    /*@isTest static void testPCPCreateURL() {
        System.assert(ACETLGT_CaseActionsController.PCPCreateURL('12345678') != null);
    }*/
    
    @isTest
    Static void getTaskRecordTypeTest(){
        ACETLGT_caseActionsController.getTaskRecordType('motion');
        ACETLGT_caseActionsController.getTaskRecordType('ACET');
        ACETLGT_caseActionsController.isSNIUser();
        case testcase = testDataFactory.createCase();
        ACETLGT_caseActionsController.addFilesToCase(testcase.Id,'autoDoc');
        ACETLGT_caseActionsController.addCaseItems(testcase.Id,'caseItems');
        
        ACETOrgInstanceURLToOrgNameMap__c custSetting = new ACETOrgInstanceURLToOrgNameMap__c();
        custSetting.Name = 'motion';
        custSetting.Org_Name__c = 'motion';
        insert custSetting;
        
        ACETOrgInstanceURLToOrgNameMap__c custSetting1 = new ACETOrgInstanceURLToOrgNameMap__c();
        custSetting1.Name = 'fullcopy';
        custSetting1.Org_Name__c = 'fullcopy';
        insert custSetting1;
        
        ACETOrgNameToSwivelEndpointMap__c custSetting2 = new ACETOrgNameToSwivelEndpointMap__c();
        custSetting2.Name='motion_ICUEPCPReferral';
        custSetting2.Swivel_Endpoint__c='https://basics.uhc.com/basicscompmgmt	';
        custSetting2.ACET_Common_Name__c='BASICS';
        Insert custSetting2;
        
        ACETWrapEncryptionKey__c custSetting3 = new ACETWrapEncryptionKey__c();
        custSetting3.name = 'motion_ICUEEncryptionKey';
        custSetting3.Algorithm_Name__c = 'motion';
        custSetting3.Key__c = 'JYbyFR9zdZFrGRzgaJtCTyLpFkIXFOs4';
        insert custSetting3;
        
        //ACETLGT_caseActionsController.PCPCreateURL('131881');
    }
    
    @isTest static void testButtonAccessPCP() {
    	System.assert('true'.equalsIgnoreCase(ACETLGT_CaseActionsController.buttonAccessPCP('Resolution Specialist - Agent')));
	}
    
    
    @isTest static void testUtilMethods() {
        System.assert(ACETLGT_CaseActionsController.getProfileUser() != null);
        System.assert(!ACETLGT_CaseActionsController.getTTSFilterMapKeyStr('View Claims').isEmpty());
        System.assert(!ACETLGT_CaseActionsController.getTTSFilterMapValueStr('View Claims', 'Accumulator Inquiry').isEmpty());
        System.assert(ACETLGT_CaseActionsController.getTTSFilterTopicStr('View Claims') != null);
    }
    @isTest static void testDermURL(){
        
    	System.assert(ACETLGT_CaseActionsController.getDermURL()!=null);   
    }
    @isTest static void testConsoleURL(){
       
        System.assert(ACETLGT_CaseActionsController.getConsoleURL()!=null);  
    }
     @isTest static void testEZCommURL(){
        ACETOrgNameToSwivelEndpointMap__c eZCommWrapURLMap = ACETTestDataUtility.createORGNameToSwivelData('dev_EZCommWrapURL', 'https://ezcomm-admin-dev.optum.com/?agentId={0}&widget={1}&contextId={2}&productType={3}&bookOfBusiness={4}&recipient={5}');
        insert eZCommWrapURLMap;
        
        ACETWrapEncryptionKey__c eZCommEncryptionKey = new ACETWrapEncryptionKey__c(Name='dev_EZCommEncryptionKey', Key__c='WnZr4u7x!A%D*G-K', Algorithm_Name__c='AES128');
        insert eZCommEncryptionKey;
        ACETEZCommConfig__c configParam = new ACETEZCommConfig__c(Name='EZCommAndDCHConfig',ContextId__c='11',IdType__c = 'Subscriber Id',ProductType__c = 'Medical',RecipientType__c = 'Member');
        insert configParam;
        RecordType newRecord = [SELECT Id FROM RecordType WHERE Name = 'Person Account' and SObjectType = 'Account'];
        Account accountTest = new Account();
        accountTest.FirstName = 'Test Contact FN';
        accountTest.LastName = 'Test Contact LN';
        accountTest.EID__c = 'TestEID1';
        accountTest.Tax_Id__c = 'TstTaxID1';
        accountTest.RecordTypeId = newRecord.Id;
        insert accountTest;
        Account acc = [SELECT Id,personcontactid from Account where Id=:accountTest.Id];
        Contact contact = [SELECT Id,LastName,FirstName,AccountId from Contact where Id=:acc.personcontactid];
        Profile p = [SELECT Id FROM Profile WHERE Name='ACET Member'];
        User thisUser = [Select Id From User Where Id =:UserInfo.getUserId()];
        user u;
        System.runAs(thisUser){
        u= new User(Alias = 'standt', Email='standarduser@testorg.com', 
                          EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US',
                          LocaleSidKey='en_US', ProfileId = p.Id, FederationIdentifier = 'TestFed',
                          TimeZoneSidKey='America/Los_Angeles', UserName='testtets@testorg.com', UHG_Access__c='No');
       
            Test.startTest();
            ACETLGT_HighlightPanelInfo hgltInfo = new ACETLGT_HighlightPanelInfo();
            hgltInfo.MemberDOB = '6/30/1995';
            hgltInfo.MemberId = '123456789';
            hgltInfo.GroupNumber = '12345';
            hgltInfo.subjectID = contact.Id;
            String eZCommURL = ACETLGT_CaseActionsController.getEZCommURL('EZCOMM', 'OX',hgltInfo,'testFirstName','testLastName','6/30/1995','12345','123456789',false);
            System.debug('EZComm URL' + eZCommURL);
            Test.stopTest();
         }
     }
}