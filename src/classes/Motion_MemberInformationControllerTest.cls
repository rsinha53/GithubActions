@isTest
global class Motion_MemberInformationControllerTest {
    
    @TestSetup 
    private static void testSetupMethod() {
        Organization_Properties__c orgProps = Organization_Properties__c.getOrgDefaults();
        orgProps.OrganizationName__c = 'QA';
        Upsert orgProps;
        
        // Token API data
        WebserviceConfigurations__c tokenAPIWSConfig = ACET_WebserviceCalloutFramework_Test.createTokenWSConfigs('MotionAccessTokenAPI');
        OrgSpecificConfigurations__c tokenAPIOrgSpecificConfigs = ACET_WebserviceCalloutFramework_Test.createTokenOrgWSConfigs(tokenAPIWSConfig.Id);
        WebserviceConfigurations__c authTokenWSConfig = ACET_WebserviceCalloutFramework_Test.createAuthTokenWSConfig('MotionAccessTokenAPI');

        // Service API data
        WebserviceConfigurations__c wsbasicConfig = ACET_WebserviceCalloutFramework_Test.createWSConfig('Motion_DERM_BasicSearchAPI', tokenAPIWSConfig.Id);
        OrgSpecificConfigurations__c orgSpecificBConfigs = ACET_WebserviceCalloutFramework_Test.createOrgWSConfigs(wsbasicConfig.Id);
        
        WebserviceConfigurations__c wsadvConfig = ACET_WebserviceCalloutFramework_Test.createWSConfig('Motion_DERM_AdvancedSearchAPI', tokenAPIWSConfig.Id);
        OrgSpecificConfigurations__c orgSpecificAConfigs = ACET_WebserviceCalloutFramework_Test.createOrgWSConfigs(wsadvConfig.Id);

        WebserviceConfigurations__c wsdetailConfig = ACET_WebserviceCalloutFramework_Test.createWSConfig('Motion_DERM_MemberDetailAPI', tokenAPIWSConfig.Id);
        OrgSpecificConfigurations__c orgSpecificDConfigs = ACET_WebserviceCalloutFramework_Test.createOrgWSConfigs(wsdetailConfig.Id);

        WebserviceConfigurations__c wsplanConfig = ACET_WebserviceCalloutFramework_Test.createWSConfig('Motion_DERM_PlanWaiverAPI', tokenAPIWSConfig.Id);
        OrgSpecificConfigurations__c orgSpecificPConfigs = ACET_WebserviceCalloutFramework_Test.createOrgWSConfigs(wsplanConfig.Id);
        
        WebserviceConfigurations__c wsconsConfig = ACET_WebserviceCalloutFramework_Test.createWSConfig('Motion_CONSOLE_API', tokenAPIWSConfig.Id);
        OrgSpecificConfigurations__c orgSpecificCConfigs = ACET_WebserviceCalloutFramework_Test.createOrgWSConfigs(wsconsConfig.Id);
        
        
    }

    @istest()
    static void fetchMemberInformationMT(){        
       Account acetAcc = new Account(FirstName = 'Arron', LastName = 'Abbott', Motion_Registered_Member_ID__c = '12350', Motion_Eligible_Member_ID__c = '454850');
       insert acetAcc;
       
	   Interaction__c intrec= TestDataFactory.createInteraction();
       Test.startTest(); 
       Test.setMock(HttpCalloutMock.class, new Motion_MemberInfoMockTest());
       Motion_MemberInformationController.featchMemberInformation('12345','454848','Mary','John','mary.john@gmail.com','','',false);
       Motion_MemberInformationController.getThirdparty('Mary','John','mary.john@gmail.com','','','','','','','');
       Motion_MemberInformationController.searchAndCreateMotionPersonAccount('12345','454848','Mary','John','mary.john@gmail.com','','','');
       Motion_MemberInformationController.searchAndCreateMotionPersonAccount('12350','454850','','','','','','');        
       Test.stopTest();
    }
    
    @isTest
    private static void memberDetailMedicalwaiverServiceTest(){
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new newMock(200));
        Motion_MemberInformationController.featchMemberInformation('4534554','','','','','','',false);
        
        Test.setMock(HttpCalloutMock.class, new newMock(401));
        Motion_MemberInformationController.featchMemberInformation('4534554','','','','','','',false);
        Test.stopTest();
    }
    
    @istest()
    static void fetchMemberPlanWaiver(){
       Account acetAcc = new Account(FirstName = 'Arron', LastName = 'Abbott', Motion_Registered_Member_ID__c = '12350', Motion_Eligible_Member_ID__c = '454850');
       insert acetAcc;
       
	   Interaction__c intrec= TestDataFactory.createInteraction();
       Test.startTest(); 
       Test.setMock(HttpCalloutMock.class, new Motion_MemberInfoMockTest());
                
       MOTION_CreatePersonAccountInteractions.createAccount('Mary','John','1980-01-01T00:00:00','mary.john@gmail.com','Phone Call','12350','','');
       MOTION_CreatePersonAccountInteractions.createAccount('Mary','John','1980-01-01T00:00:00','mary.john@gmail.com','Phone Call','','454850','');
       Test.stopTest();
    }
    
    @istest()
    static void test1(){
		MotionMemberDetailWrapper.HighlightsPanel wrapper1 = new MotionMemberDetailWrapper.HighlightsPanel();
		
		Account motionAccount = new Account(FirstName = 'Mary', LastName = 'Abbott', Contact_Type__pc = 'Phone Call');
        insert motionAccount;            
        Account motionAcc = [SELECT Id, PersonContactId, Name FROM Account WHERE Id=: motionAccount.Id];

        Interaction__c intRecord = new Interaction__c(Originator__c = motionAcc.PersonContactId, Originator_Name__c = motionAcc.Name);
        insert intRecord;
        Interaction__c intRec = [SELECT Id, Name, Third_Party__c, Originator__c FROM Interaction__c LIMIT 1];
        
        Third_Party__c tpRecord = new Third_Party__c(First_Name__c = 'Witty', LastName__c = 'Andrew', FullName__c = 'Witty Andrew', Phone_Number__c = '979-347-6123', Other_Originator__c = 'Provider');
        insert tpRecord;
        Third_Party__c tpRec = [SELECT Id, FullName__c FROM Third_Party__c LIMIT 1];   
        
        Third_Party_Originator__c tpOrigRecord = new Third_Party_Originator__c(Subject__c = motionAcc.PersonContactId, Third_Party__c = tpRec.Id);
        insert tpOrigRecord;
		
        Test.startTest();
		//Motion_MemberInformationController.searchAndCreateMotionPersonAccount('12345','454848','Mary','John','mary.john@gmail.com','','','');
		Motion_MemberInformationController.setMemInteractions(intRec.Id, motionAcc.PersonContactId);
		Motion_MemberInformationController.setTPInteractions(intRec.Id, motionAcc.PersonContactId, 'Witty Andrew');
        Test.stopTest();
    } 
	
	@istest()
    static void prepareHighlightTest(){        
        String xyz = '{"Id":"a0I050000012XGLEA2","Name":"INT-1229118", "Originator__r":{"Name":"st9611 modelaccount","LastName":"modelaccount"}}';
        Motion_MemberInformationController.prepareHighlightsInfo(xyz,'','' );
		Motion_MemberInformationController.getUser();
		Motion_MemberInformationController.getorg();
        Motion_MemberInformationController.setDermInquiryInformations();
        Motion_MemberInformationController.setConsoleInquiryInformations();
    }
    
    global class newMock implements HttpCalloutMock {
        public Integer statusCode;
        
        public newMock(Integer statusCode) {
            this.statusCode = statusCode;
        }
        global HTTPResponse respond(HTTPRequest request) {
            HttpResponse response = new HttpResponse();
            response.setHeader('Content-Type', 'application/json');
            response.setBody('{"PageDetails":{"Total":31,"Offset":1,"Limit":25,"TotalPages":2,"LastPage":false},"data":[{"Status":"Expired","Type":"Medical","StartDate":"2020-12-01T00:00:00","EndDate":"2020-12-27T00:00:00","EnteredBy":"BoriserwinHokat1","DateEntered":"2021-01-19T02:32:10.7193657","ClientAdminNotes":"test"}]}');
            
            response.setStatusCode(statusCode);
            response.setStatus('status');
            return response; 
        }
    }
        
    global class MotionAPIServiceFrameworkMock implements HttpCalloutMock {
        public Integer statusCode;
        
        public MotionAPIServiceFrameworkMock(Integer statusCode) {
            this.statusCode = statusCode;
        }
        global HTTPResponse respond(HTTPRequest request) {
            HttpResponse response = new HttpResponse();
            response.setHeader('Content-Type', 'application/json');
            response.setBody('{"firstName": "dev"}');
            response.setStatusCode(statusCode);
            response.setStatus('status');
            return response; 
        }
    }
    
}