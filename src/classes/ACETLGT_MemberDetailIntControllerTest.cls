@IsTest
public class ACETLGT_MemberDetailIntControllerTest {
    private static final String memId = '97451064500';
    private static final String policyId = '1004278';
    private static final String firstName = 'test';
    private static final String lastName = 'test';
    private static final String dob = '1/1/2020';
    private static final Integer statusCode200 = 200;
    private static final String status200 = 'OK';
    private static final Integer statusCode400 = 400;
    private static final String status400 = 'Bad Request';
	@IsTest
    Public static void LightningMemberSearchMethod1()
    {
        //String result=LightningForgotPasswordController.forgotPassword('test@test.test', 'http://www.checkemailfake');
        User memberAgent = TestDataFactory.getUser('ACET Member'); 
    	System.runAs(memberAgent){
        
        Test.startTest();
        RecordType newRecord = [SELECT Id FROM RecordType WHERE Name = 'Person Account' and SObjectType = 'Account'];
        
        Account accountTest = new Account();
        accountTest.FirstName = 'Test Contact FN';
        accountTest.LastName = 'Test Contact LN';
        accountTest.EID__c = 'TestEID1';
        accountTest.EID__pc = 'TestEID1';
        accountTest.Tax_Id__c = 'TstTaxID1';
        accountTest.RecordTypeId = newRecord.Id;
        insert accountTest;
    	Account acc = [SELECT Id,personcontactid from Account where Id=:accountTest.Id];
        Contact oContact = [SELECT Id,LastName,FirstName,EID__c,AccountId from Contact where Id=:acc.personcontactid];

        Interaction__c oInteraction = ACETTestDataUtility.CreateInteraction(oContact.Id, 'Phone', 'Member', oContact.LastName);
        insert oInteraction;
        String highlightPanelDetails = '{"SitusState":"MN","relationShipCode":"MN","subjectRelationCode":"MN","State":"MN","originatorDOB":"12/11/2019","accumAsOfDate":"12/11/2019","benefitBundleOptionId":"1738484","EffectiveDate":"10/1/2018","EndDate":"12/31/9999","GroupNumber":"1168520","image":"active","MemberDOB":"8/27/1979","MemberId":"97161070000","SubscriberId":"97161070000","memberStatus":"ACTIVE","Network":"FREEDOM_CHOICEPLUS","onshoreCode":"01","onshoreValue":"No","subjectID":"'+oContact.Id+'","subjectName":"LORINA ONORATI","originatorID":"'+oContact.Id+'"}';
        ACETLGT_HighlightPanelInfo hlg = new ACETLGT_HighlightPanelInfo();
        
        ACETLGT_MemberDetailIntController mdc = new ACETLGT_MemberDetailIntController();
        ACETLGT_MemberDetailIntController.queryInteraction(oInteraction.id);
        mdc.interaction = oInteraction;
        mdc.interactionId = oInteraction.id;
            
        ACETLGT_HighlightPanelInfo hlgset = ACETLGT_MemberDetailIntController.prepareHighlightPanelWrapper(highlightPanelDetails,oInteraction.id );
        hlg.originatorName = hlgset.originatorName;
        hlg.originatorRel = hlgset.originatorRel;
        hlg.subjectName = hlgset.subjectName;
        hlg.originatorID = hlgset.originatorID;
        hlg.subjectID = hlgset.subjectID;
        hlg.MemberId = hlgset.MemberId;
        hlg.SubscriberId = hlgset.SubscriberId;
        hlg.memberStatus = hlgset.memberStatus;
        hlg.MemberDOB= hlgset.MemberDOB;
        hlg.GroupNumber = hlgset.GroupNumber;
        hlg.Network = hlgset.Network;
        hlg.EffectiveDate = hlgset.EffectiveDate;
        hlg.EndDate = hlgset.EndDate;
        hlg.benefitBundleOptionId = hlgset.benefitBundleOptionId;
        hlg.image = hlgset.image;
        hlg.accumAsOfDate = hlgset.accumAsOfDate;
        hlg.onshoreValue = hlgset.onshoreValue;
        hlg.onshoreCode = hlgset.onshoreCode;
        hlg.Name = hlgset.Name;
        hlg.EmployerName = hlgset.EmployerName;
        hlg.ZIP = hlgset.ZIP;
        hlg.PhoneNumber = hlgset.PhoneNumber;
        hlg.IsMemberNotfound = hlgset.IsMemberNotfound;
        hlg.originatorDOB =  hlgset.originatorDOB; 
        hlg.SitusState =  hlgset.SitusState; 
        hlg.relationShipCode =  hlgset.relationShipCode; 
        hlg.subjectRelationCode =  hlgset.subjectRelationCode; 
        hlg.State = hlgset.State;
        String highlightPanelDetails2; 
        ACETLGT_MemberDetailIntController.prepareHighlightPanelWrapper(highlightPanelDetails2,oInteraction.id );
        
            Test.stopTest();
        }
    }
	 @IsTest
      Public static void LightningMemberSearchMethod2()
    {
         RecordType newRecord = [SELECT Id FROM RecordType WHERE Name = 'Person Account' and SObjectType = 'Account'];
        
        Account accountTest = new Account();
        accountTest.FirstName = 'Test Contact FN';
        accountTest.LastName = 'Test Contact LN';
        accountTest.EID__c = 'TestEID1';
        accountTest.EID__pc = 'TestEID1';
        accountTest.Tax_Id__c = 'TstTaxID1';
        accountTest.RecordTypeId = newRecord.Id;
        insert accountTest;
    	Account acc = [SELECT Id,personcontactid from Account where Id=:accountTest.Id];
        Contact oContact = [SELECT Id,LastName,FirstName,EID__c,AccountId from Contact where Id=:acc.personcontactid];

        Interaction__c oInteraction = ACETTestDataUtility.CreateInteraction(oContact.Id, 'Phone', 'Member', oContact.LastName);
        insert oInteraction;
       ACETLGT_MemberDetailIntController.createFamilyaccountstree('[{"accountid":"0010300000Gq5YKAAZ","Age":"53","DOB":"1/1/1968","EID":"541846918","FamilyId":"541846918","FirstName":"Alexm","fullName":"Alexm  Acevedo ","Gender":"M","groupNumber":"1373301","LastName":"Acevedo","memberStatus":"ACTIVE","MiddleInitial":"","Relationship":"Self","selected":false,"SFrecId":"0030300000EhMAvAAN","subscriberIndividualId":"74828442400","suffix":""}]');
        ACETLGT_MemberDetailIntController.getEligibility('97451064500','1004278','test','test','1/1/2020');
        ACETLGT_MemberDetailIntController.queryInteraction(oInteraction.Id,'');
        
    }
    @isTest
     static void acetlgt_EligibilityService(){
        Test.startTest();
        String responseJSON = '{"result":{"data":[{"initialCallDate":null,"memberExists":false,"children":null,"caregiverName":null,"policyID":"1004278","memberID":"97451064500","familyLinkID":null,"agreedtoPAFS":null,"assignedTo":null,"accountTypes":null,"localMarket":null,"employeeId":null,"lob":null,"serviceGroup":null,"containmentGroup1":null,"containmentGroup2":null,"finaloverflowGroup":null,"sniEligibility":"not eligible","rank":null,"routingThreshold":null,"referralThreshold":null,"advisorFullName":null}]},"status":{"messages":[{"code":"200","name":"SUCCESS","severity":"INFO","description":"No data found."}]}}';
        MockHttpCalloutResponseGenerator.MockHttpResponse oilResponse = new MockHttpCalloutResponseGenerator.MockHttpResponse(statusCode200, status200, responseJSON );
        OILResponse.TokenExpired = false;
        MockHttpCalloutResponseGenerator mockHttpRes = new MockHttpCalloutResponseGenerator(null, oilResponse);
        Test.setMock(HttpCalloutMock.class, mockHttpRes); 
        ACETLGT_MemberDetailIntController.getEligibility(memId,policyId,firstName,lastName,dob);
        Test.stopTest();
    }
     @isTest
     static void acetlgt_EligibilityService_1(){
        Test.startTest();
        String responseJSON = '';
        MockHttpCalloutResponseGenerator.MockHttpResponse oilResponse = new MockHttpCalloutResponseGenerator.MockHttpResponse(statusCode200, status200, responseJSON );
        OILResponse.TokenExpired = false;
        MockHttpCalloutResponseGenerator mockHttpRes = new MockHttpCalloutResponseGenerator(null, oilResponse);
        Test.setMock(HttpCalloutMock.class, mockHttpRes); 
       	ACETLGT_MemberDetailIntController.getEligibility(memId,policyId,firstName,lastName,dob);
        Test.stopTest();
    }
    @isTest
    static void acetlgt_EligibilityService_2(){
        Test.startTest();
        String responseJSON = '';
        MockHttpCalloutResponseGenerator.MockHttpResponse oilResponse = new MockHttpCalloutResponseGenerator.MockHttpResponse(statusCode400, status400, responseJSON );
        OILResponse.TokenExpired = false;
        MockHttpCalloutResponseGenerator mockHttpRes = new MockHttpCalloutResponseGenerator(null, oilResponse);
        Test.setMock(HttpCalloutMock.class, mockHttpRes); 
        ACETLGT_MemberDetailIntController.getEligibility(memId,policyId,firstName,lastName,dob);
        Test.stopTest();
    }
}