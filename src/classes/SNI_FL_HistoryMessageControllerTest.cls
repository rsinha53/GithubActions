@isTest
global class SNI_FL_HistoryMessageControllerTest {
    @testsetup
    static void testSetupMethod(){
        Organization_Properties__c orgProps = Organization_Properties__c.getOrgDefaults();
        orgProps.OrganizationName__c = 'QA';
        Upsert orgProps;
        // Token API data
        WebserviceConfigurations__c tokenAPIWSConfig = ACET_WebserviceCalloutFramework_Test.createTokenWSConfigs('StarGateTokenAPI');
        OrgSpecificConfigurations__c tokenAPIOrgSpecificConfigs = ACET_WebserviceCalloutFramework_Test.createTokenOrgWSConfigs(tokenAPIWSConfig.Id);
        WebserviceConfigurations__c authTokenWSConfig = ACET_WebserviceCalloutFramework_Test.createAuthTokenWSConfig('StarGateTokenAPI');
        // Service API data
        WebserviceConfigurations__c wsConfig = ACET_WebserviceCalloutFramework_Test.createWSConfig('HistoricalMessagesAPI', tokenAPIWSConfig.Id);
        OrgSpecificConfigurations__c orgSpecificConfigs = ACET_WebserviceCalloutFramework_Test.createOrgWSConfigs(wsConfig.Id);
        //Account data
        Account acc = new Account();
        acc.Name = 'John Smith';
        insert acc;
		Id progrouprecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Provider Group').getRecordTypeId();
        Id ProviderRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Provider Affiliation').getRecordTypeId();
        Account ac = new Account();
        ac.Name =   'ProviderGroup xyzabc';
        ac.RecordTypeId = progrouprecordTypeId;
        insert ac;
        Account personAccount = new Account();
        personAccount.firstName = 'person firstName xyzabc';
        personAccount.lastName = 'person lastName xyzabc';
        personAccount.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Individual').getRecordTypeId();
        insert personAccount;
        Account pa = new Account();
        pa.Name =   'Provider Affiliation xyzabc';
        pa.RecordTypeId = ProviderRecordTypeId;
        pa.ParentId = ac.Id;
        insert pa;
        Program__c pgm = new Program__c();
        pgm.Program__c = 'Complex Care';
        insert pgm;
        Member_Affiliation__c Maffiliate = new Member_Affiliation__c();
        Maffiliate.Provider__c = ac.Id;
        Maffiliate.Population__c = 'Adult';
        Maffiliate.Program__c = pgm.Id;
        Maffiliate.Provider_Affiliation__c = pa.Id;
        Maffiliate.Email__c='PersonEmailxyzabcde@optum.acet.com';
        Maffiliate.Enrollment_Date__c=system.today();
        Maffiliate.Date_Of_Birth__c = System.today();
        Maffiliate.Member__c=personAccount.Id;
        Maffiliate.Historical_Message__c = true;
        Maffiliate.Status__c=true;            
        insert Maffiliate;
    }
    @isTest
    static void checkHistoricalMessagesWS(){
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new WebservicecalloutFrameworkMock(200,''));
        Account acc = [select id,name from Account limit 1];
        SNI_FL_HistoryMessageController.returningMsgWrapper retWrap = new SNI_FL_HistoryMessageController.returningMsgWrapper();
        retWrap = SNI_FL_HistoryMessageController.getsingleMsg('person', acc.Id);
        System.assertEquals('Marissa Bishop', retWrap.ListauthorName);
        retWrap = SNI_FL_HistoryMessageController.getsingleMsg('family', acc.Id);
        System.assertEquals(5, retWrap.singleMsgList.size());
		Member_Affiliation__c Maff = [select id from Member_Affiliation__c limit 1];
        retWrap = SNI_FL_HistoryMessageController.getsingleMsg('memberAffiliation', Maff.Id);
        System.assertEquals('Marissa Bishop', retWrap.ListauthorName);
        Test.stopTest();
    }
    @isTest
    static void checkHistoricalMessagesWSProvider(){
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new WebservicecalloutFrameworkMock(200,''));
        Account acc = [select id,name from Account limit 1];
        SNI_FL_HistoryMessageController.providerReturnWrapper provRetWrap = new SNI_FL_HistoryMessageController.providerReturnWrapper();
        provRetWrap = SNI_FL_HistoryMessageController.getProviderMessages(acc.Id,1);
        System.assertEquals(10, provRetWrap.providerMessages.size());
        Test.stopTest();
    }
    @isTest
    static void checkHistoricalMessagesWS204(){
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new WebservicecalloutFrameworkMock(204,''));
        Account acc = [select id,name from Account limit 1];
        SNI_FL_HistoryMessageController.returningMsgWrapper retWrap = new SNI_FL_HistoryMessageController.returningMsgWrapper();
        retWrap = SNI_FL_HistoryMessageController.getsingleMsg('person', acc.Id);
        System.debug('Testing: ' + retWrap);
        System.assertEquals(204, retWrap.statusCode);
        Test.stopTest();
    }
    @isTest
    static void checkHistoricalMessagesWS500(){
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new WebservicecalloutFrameworkMock(500,''));
        Account acc = [select id,name from Account limit 1];
        SNI_FL_HistoryMessageController.returningMsgWrapper retWrap = new SNI_FL_HistoryMessageController.returningMsgWrapper();
        retWrap = SNI_FL_HistoryMessageController.getsingleMsg('person', acc.Id);
        System.assertEquals(500, retWrap.statusCode);
        Test.stopTest();
    }
    global class WebservicecalloutFrameworkMock implements HttpCalloutMock {
        public Integer statusCode;
        public String faultCode;
        public WebservicecalloutFrameworkMock(Integer statusCode, String faultCode) {
            this.statusCode = statusCode;
            this.faultCode = faultCode;
        }
        global HTTPResponse respond(HTTPRequest request) {
            HttpResponse response = new HttpResponse();
            response.setHeader('Content-Type', 'application/json');
            String jsonString = '';
            if(request.getEndpoint().contains('message-threads')){
                if (statusCode == 200) {
                    jsonString = '{"result":{"data":[{"messageThreads":[{"teamFirstName":"Faithful Charity","teamLastName":"Sama","lastMessageDateTime":"2020-09-08 19:45:25","memberAffiliationId":"memberAffiliationId461"},{"teamFirstName":"Pacheco","teamLastName":"Pacheco","lastMessageDateTime":"2020-07-29 17:26:10","memberAffiliationId":"memberAffiliationId415"},{"teamFirstName":"Hailey","teamLastName":"Ferrell","lastMessageDateTime":"2020-07-24 16:51:02","memberAffiliationId":"memberAffiliationId350"},{"teamFirstName":"Hayden E. Yeaman ","teamLastName":"Yeaman ","lastMessageDateTime":"2020-07-23 23:52:24","memberAffiliationId":"memberAffiliationId413"},{"teamFirstName":"Carson M. ","teamLastName":"Wright","lastMessageDateTime":"2020-07-23 19:20:38","memberAffiliationId":"memberAffiliationId412"},{"teamFirstName":"Shivansh","teamLastName":"Panakanti","lastMessageDateTime":"2020-07-23 18:29:03","memberAffiliationId":"memberAffiliationId411"},{"teamFirstName":"Andy","teamLastName":"Vo","lastMessageDateTime":"2020-07-22 18:52:00","memberAffiliationId":"memberAffiliationId409"},{"teamFirstName":"Keshavi","teamLastName":"Patel","lastMessageDateTime":"2020-07-21 23:45:08","memberAffiliationId":"memberAffiliationId408"},{"teamFirstName":"Delanie","teamLastName":"Schupp","lastMessageDateTime":"2020-07-16 23:31:37","memberAffiliationId":"memberAffiliationId406"},{"teamFirstName":"Matthias","teamLastName":"Stephenson","lastMessageDateTime":"2020-07-16 22:03:47","memberAffiliationId":"memberAffiliationId405"}]}]},"status":{"messages":[{"code":"200","name":"SUCCESS","severity":"INFO","description":"Successful request."}]}}';
                } else {
                    jsonString = '{"faultCode":"'+faultCode+'","message":"Based upon the search type performed we are unable to find a unique match. Please verify the data entered or perform another search type which includes the member ID."}';
                }
            } else {
                if (statusCode == 200) {
                    jsonString = '{"result":{"data":[{"messages":[{"authorFirstName":"Marissa","authorLastName":"Bishop","messageDateTime":"2019-08-30 00:00:00","message":"That\'s great, thank you!"},{"authorFirstName":"Marissa","authorLastName":"Bishop","messageDateTime":"2019-08-30 00:00:00","message":"Can I ask when Gregory is eligible for a new wheelchair?"},{"authorFirstName":"Marissa","authorLastName":"Bishop","messageDateTime":"2019-08-30 00:00:00","message":"Thanks for all your help, Tammy!"},{"authorFirstName":"Marissa","authorLastName":"Bishop","messageDateTime":"2019-08-15 00:00:00","message":"Hi Tammy, A couple questions. 1) We got a bill from BioScrip for the pulse ox machine rental. When I called they said it wasn\'t covered by insurance. How can that be when we have oxygen at home? We need the pulse ox to monitor his oxygen sats. Is it really not covered? 2) When is Gregory able to get a bath chair? I know he was originally denied one, but now that he is getting older and bigger is it covered? Thank yoU!"},{"authorFirstName":"Tammy","authorLastName":"C","messageDateTime":"2018-07-13 00:00:00","message":"Thank you for your patience as we continue to work on the new 2.0 update for Family Link. We are hoping to launch this next week. I will keep you updated on that update. Have a great weekend."}]}]},"status":{"messages":[{"code":"200","name":"SUCCESS","severity":"INFO","description":"Successful request."}]}}';
                } else {
                    jsonString = '{"faultCode":"'+faultCode+'","message":"Based upon the search type performed we are unable to find a unique match. Please verify the data entered or perform another search type which includes the member ID."}';
                }
            }
            response.setBody(jsonString);
            response.setStatusCode(statusCode);
            response.setStatus('status');
            return response; 
        }
    }
}