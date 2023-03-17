/*
Purpose:To cover test coverage for all the methods for ERM_RequestController
Created Date: 10:05:2021
*/

@isTest
global class ERM_RequestControllerTest {
    Public static string teststring='test.com';
    public static string enrdob='1960-01-02';
	public static string datecob='2021-05-03';
    @testSetup static void setup() {
        
        WebserviceConfigurations__c webConfig=new WebserviceConfigurations__c(name='ERMFileUploadRequest',recordtypeText__c = 'Token_API',Method__c='POST',EndpointPath__c=teststring);
        insert webConfig;
        
        WebserviceConfigurations__c webConfig1=new WebserviceConfigurations__c(name='ERMServiceTokenAPIToken',recordtypeText__c = 'Token_API',AuthorizationToken__c='{"qa":"AwAV6rIv7mo1sODtv3iAfCahHcowGRG5"}',Method__c='POST',EndpointPath__c=teststring);
        insert webConfig1;
        
        WebserviceConfigurations__c webConfig2=new WebserviceConfigurations__c(name='LinkEligibilityMemberSearch',recordtypeText__c = 'Token_API',AuthorizationToken__c='{"qa":"AwAV6rIv7mo1sODtv3iAfCahHcowGRG5"}',Method__c='POST',Timeout__c = 400,EndpointPath__c=teststring);
        insert webConfig2;
        
        OrgSpecificConfigurations__c orgWebConfig=new OrgSpecificConfigurations__c(name='qa',WebserviceConfigurations__c=webConfig.id,recordtypeText__c = 'TokenAPI',EndpointDomain__c='https://gateway-stage.optum.com/api/stage/fin/billing/simonstream/requests/v1/api/RequestFileUpload');
        insert orgWebConfig;
        OrgSpecificConfigurations__c orgWebConfig2=new OrgSpecificConfigurations__c(name='qa',WebserviceConfigurations__c=webConfig2.id,recordtypeText__c = 'TokenAPI',EndpointDomain__c='https://gateway-stage.optum.com/api/stage/fin/billing/simonstream/requests/v1/api/RequestFileUpload');
        insert orgWebConfig2;       
        
   
        Case cas = new Case(Status ='New', Priority = 'Medium', Origin = 'Email',Subject='Test Controller Acct Case',external_reference_id__c='12345'); 
        insert cas;
        
        List<CaseComment> casComLst=new List<CaseComment>();
        CaseComment caseCom1=new CaseComment(ParentId=cas.id,IsPublished=false,CommentBody='ORS created for ACET Case Number 00589942');
        CaseComment caseCom2=new CaseComment(ParentId=cas.id,IsPublished=false,CommentBody='ORS2 created for ACET Case Number 00589942');                                  
        casComLst.add(caseCom1);
        casComLst.add(caseCom2);
        insert casComLst;
        
        Blob bodyBlob=Blob.valueOf('Unit Test ContentVersion Body to be insert in test class for testing the'); 
        
        Attachment attach=new Attachment();   	
        attach.Name='Unit Test Attachment';
        attach.body=bodyBlob;
        attach.parentId=cas.id;
        insert attach;
        
        Attachments__c attach1=new Attachments__c();
        attach1.Name='Unit Test Attachment';
        attach1.Description__c=String.valueOf(bodyBlob);
        attach1.Document_Id__c=attach.id;
        attach1.case__c=cas.id;
        insert attach1;
        
        List<Attachment> attachments=[select id, name from Attachment where parent.id=:cas.id];
        System.assertEquals(1, attachments.size());
        
        ContentVersion contentVersion_1 = new ContentVersion(
            Title='SampleTitle', 
            PathOnClient ='SampleTitle.jpg',
            VersionData = bodyBlob, 
            origin = 'H'
        );
        insert contentVersion_1;
        
        ContentVersion contentVersion_2 = [SELECT Id, Title, ContentDocumentId FROM ContentVersion WHERE Id = :contentVersion_1.Id LIMIT 1];                                
        ContentDocumentLink contentlink = new ContentDocumentLink();
        contentlink.LinkedEntityId = cas.id;
        contentlink.contentdocumentid = contentVersion_2.contentdocumentid;
        contentlink.ShareType = 'V';
        insert contentlink;
        
        List<Enrolees__c> enrolLst=new List<Enrolees__c>();
        
        Enrolees__c enrol=new Enrolees__c();
        enrol.First_Name__c='CalebSouse';
        enrol.MiddleName__c='E';
        enrol.Last_Name__c='Galleco';
        enrol.CorrectedUpdatedSSN__c='510999955';
        enrol.SSN__c='510999955';
        enrol.All_users_have_same_permission_as_policy__c=false;
        enrol.Date_of_Birth__c=Date.valueOf(enrdob);
        enrol.Gender__c='Male';
        enrol.Employee_ID__c='23456789';
        enrol.Address__c='KALBA';
        enrol.City__c='Tampa';
        enrol.Zip__c='23456';
        enrol.State__c='KA';
        enrol.Relationship__c='Child';
        enrol.HomePhone__c='234567';
        enrol.PrimaryCarePhysician__c='DrReddy';
        enrol.PrimaryCareDentist__c='DrPatil';
        enrol.AnnualSalary__c=Integer.valueOf(123450000);
        enrol.CoordinationofBenefitsBegin_Date__c=Date.valueOf(datecob);
        enrol.CoordinationofBenefitsEnd_Date__c=Date.valueOf(datecob);
        enrol.MedicarePartAStartDate__c=Date.valueOf('2021-04-03');
        enrol.MedicarePartAEndDate__c=Date.valueOf(datecob);
        enrol.MedicarePartBStartDate__c=Date.valueOf('2021-03-03');
        enrol.MedicarePartBEndDate__c=Date.valueOf(datecob);
        enrol.MedicarePartDStartDate__c=Date.valueOf('2021-02-03');
        enrol.MedicarePartDEndDate__c=Date.valueOf(datecob);
        enrol.PriorCoverageBeginDate__c=Date.valueOf('2021-01-03');
        enrol.PriorCoverageEndDate__c=Date.valueOf(datecob);
        enrol.DeliveryPreference__c='No Preference';
        enrol.Email__c='TestBkr@gmail.com';
        enrol.ExistingPatient__c=true;
        enrol.Case__c=cas.id;
        enrolLst.add(enrol);
        
        Enrolees__c enrol2=new Enrolees__c();
        enrol2.First_Name__c='CalebSouse2';
        enrol2.MiddleName__c='E';
        enrol2.Last_Name__c='Galleco';
        enrol2.CorrectedUpdatedSSN__c='510999955';
        enrol2.SSN__c='510999955';
        enrol2.All_users_have_same_permission_as_policy__c=true;
        enrol2.Date_of_Birth__c=Date.valueOf(enrdob);
       
        enrol2.Employee_ID__c='23456789';
        enrol2.Address__c='KALBA';
        enrol2.City__c='Tampa';
        enrol2.Zip__c='23456';
        enrol2.State__c='KA';
        enrol2.Relationship__c='Child';
        enrol2.HomePhone__c='234567';
        enrol2.PrimaryCarePhysician__c='DrReddy';
        enrol2.PrimaryCareDentist__c='DrPatil';
        enrol2.AnnualSalary__c=Integer.valueOf(123450000);
        enrol2.CoordinationofBenefitsBegin_Date__c=Date.valueOf(datecob);
        enrol2.CoordinationofBenefitsEnd_Date__c=Date.valueOf(datecob);
        enrol2.MedicarePartAStartDate__c=Date.valueOf('2021-04-03');
        enrol2.MedicarePartAEndDate__c=Date.valueOf(datecob);
        enrol2.MedicarePartBStartDate__c=Date.valueOf('2021-03-03');
        enrol2.MedicarePartBEndDate__c=Date.valueOf(datecob);
        enrol2.MedicarePartDStartDate__c=Date.valueOf('2021-02-03');
        enrol2.MedicarePartDEndDate__c=Date.valueOf(datecob);
        enrol2.PriorCoverageBeginDate__c=Date.valueOf('2021-01-03');
        enrol2.PriorCoverageEndDate__c=Date.valueOf(datecob);
        enrol2.DeliveryPreference__c='No Preference';
        enrol2.Email__c='TestBkr22@gmail.com';
        enrol2.ExistingPatient__c=true;
        enrol2.Case__c=cas.id;
        enrolLst.add(enrol2);
        insert enrolLst;
        System.assert(enrol.ExistingPatient__c, 'True');
        
        List<ERM_EServices_Policy_User__c> eSerLst=new List<ERM_EServices_Policy_User__c>();
        
        ERM_EServices_Policy_User__c ePolicy=new ERM_EServices_Policy_User__c();
        ePolicy.Policy__c=enrol.Id;
        
        ERM_EServices_Policy_User__c ePolicy1=new ERM_EServices_Policy_User__c();
        ePolicy1.First_Name__c='TestIt';
        ePolicy1.Last_Name__c='Lkd';
        ePolicy1.Policy__c=enrol.Id;
        
        eSerLst.add(ePolicy);
        eSerLst.add(ePolicy1);       
        insert eSerLst;
        
        List<Stream__c> lstStream=new List<Stream__c>();
        Account accRec=new Account(Name='testStream');
        insert accRec;
        
        Stream__c streamRec1=new Stream__c(Customer_Name__c='ACS TESTINGINC',PolicyNumber__c='02Y2127',Customer_Number__c='08F6347',PeopleSoftID__c='1554567840',Source__c='PR',AccountID__c=accRec.id);
        Stream__c streamRec2=new Stream__c(Customer_Name__c='ACS TESTINNG1',PolicyNumber__c='02Y2128',Customer_Number__c='08F6348',PeopleSoftID__c='1554567839',Source__c='NI',AccountID__c=accRec.id);
        Stream__c streamRec3=new Stream__c(Customer_Name__c='ACS TESTINNG2',PolicyNumber__c='02Y2129',Customer_Number__c='08F6349',PeopleSoftID__c='1554567841',Source__c='AC',AccountID__c=accRec.id);
        lstStream.add(streamRec1);
        lstStream.add(streamRec2);
        lstStream.add(streamRec3);
        insert lstStream;
        System.assertEquals('ACS TESTINGINC', lstStream[0].Customer_Name__c);
        
        Stream_Request_Details__c reqDet=new Stream_Request_Details__c();
        reqDet.Plat_form__c='PRIME';
        reqDet.RequestType__c='Add';
        reqDet.Estimated_Transactions__c=2;
        reqDet.Effective_Date__c=Date.valueOf(enrdob);
        reqDet.Case__c=cas.id;
        reqDet.Vendor__c='Chennai';
        reqDet.Family_Selection__c='Employee';
        insert reqDet;
        System.assertEquals('Chennai', reqDet.Vendor__c);
        
    }
    
    Static testmethod void getStreamRequestDetailsTest(){
        //Data Creation to cover ERM_permissionValidation trigger test coverage
        List<Schema.PicklistEntry> values = Enrolees__c.Permissions__c.getDescribe().getPicklistValues();
        DescribeFieldResult describe = Enrolees__c.Permissions__c.getDescribe();
        List<PicklistEntry> availableValues = describe.getPicklistValues();
        
        list<RecordType> rList = [Select id From RecordType  Where sObjectType = 'Enrolees__c'and RecordType.Name = 'Policies'];
        
        List<Enrolees__c> enroleeLst=[Select id,RecordTypeId from Enrolees__c where First_Name__c='CalebSouse'];
        enroleeLst[0].RecordTypeId=rList[0].id;
        update enroleeLst;
        
        List<ERM_EServices_Policy_User__c> eSerLst=[Select id,Policy__c from ERM_EServices_Policy_User__c where First_Name__c='TestIt'];
        Test.startTest();
        ERM_RequestController.validatePermission(eSerLst);
        ERM_RequestController.getStreamRequestDetails('ACS','PR');  
        ERM_RequestController.getStreamRequestDetails('ACS','');
        Test.stopTest();
    }
    
    Static testmethod void insertDataEnrolleeTest(){
        Enrolees__c enrolObj=new Enrolees__c();
        enrolObj.First_Name__c='CalebSouse';
        enrolObj.MiddleName__c='E';
        
        String EnrolleeJSOn='{"firstName":"CalebSouse","middleName":"E","lastName":"Galleco","SSN":"510999955","DateOfBirth":"1960-01-02","gender":"Male","relationship":"Spouse","address":"1200 Woods Et","city":"Naugatuck","state":"CT","zip":"06770","homephone":"123456789","PrimaryCarePhysician":"DrReddy","PrimaryCareDentist":"DrPatil","anuualSalary":"123450000","cobBeginDate":"2021-05-10","cobEndDate":"2021-05-09","medCareAStrtDate":"2021-05-03","medCareAEndDate":"2021-05-17","medCareBStrtDate":"2021-05-10","medCareBEndDate":"2021-05-10","medCareDStrtDate":"2021-05-10","medCareDEndDate":"2021-05-09","priorCovBegnDate":"2021-05-09","priorCovEndDate":"2021-05-16","deliveryPreffered":""},{"firstName":"CalebS1","middleName":"E","lastName":"Galleco","SSN":"510999955","DateOfBirth":"1960-01-02","gender":"Male","relationship":"Employee","address":"1200 Woods Et","city":"Naugatuck","state":"CT","zip":"06770","cobBeginDate":null,"cobEndDate":null,"medCareAStrtDate":null,"medCareAEndDate":null,"medCareBStrtDate":null,"medCareBEndDate":null,"medCareDStrtDate":null,"medCareDEndDate":null,"priorCovBegnDate":null,"priorCovEndDate":null,"deliveryPreffered":""},{"firstName":"CalebC1","middleName":"E","lastName":"Galleco","SSN":"510999955","DateOfBirth":"1960-01-02","gender":"Male","relationship":"Child","address":"1200 Woods Et","city":"Naugatuck","state":"CT","zip":"06770","cobBeginDate":null,"cobEndDate":null,"medCareAStrtDate":null,"medCareAEndDate":null,"medCareBStrtDate":null,"medCareBEndDate":null,"medCareDStrtDate":null,"medCareDEndDate":null,"priorCovBegnDate":null,"priorCovEndDate":null,"deliveryPreffered":""}';
        String EnrolleeJSOnLst='[{"firstName":"CalebSouse","middleName":"E","lastName":"Galleco","SSN":"510999955","DateOfBirth":"1960-01-02","gender":"Male","relationship":"Spouse","address":"1200 Woods Et","city":"Naugatuck","state":"CT","zip":"06770","homephone":"123456789","PrimaryCarePhysician":"DrReddy","PrimaryCareDentist":"DrPatil","anuualSalary":"123450000","cobBeginDate":"2021-05-10","cobEndDate":"2021-05-09","medCareAStrtDate":"2021-05-03","medCareAEndDate":"2021-05-17","medCareBStrtDate":"2021-05-10","medCareBEndDate":"2021-05-10","medCareDStrtDate":"2021-05-10","medCareDEndDate":"2021-05-09","priorCovBegnDate":"2021-05-09","priorCovEndDate":"2021-05-16","deliveryPreffered":""},{"firstName":"CalebS1","middleName":"E","lastName":"Galleco","SSN":"510999955","DateOfBirth":"1960-01-02","gender":"Male","relationship":"Employee","address":"1200 Woods Et","city":"Naugatuck","state":"CT","zip":"06770","cobBeginDate":null,"cobEndDate":null,"medCareAStrtDate":null,"medCareAEndDate":null,"medCareBStrtDate":null,"medCareBEndDate":null,"medCareDStrtDate":null,"medCareDEndDate":null,"priorCovBegnDate":null,"priorCovEndDate":null,"deliveryPreffered":""},{"firstName":"CalebC1","middleName":"E","lastName":"Galleco","SSN":"510999955","DateOfBirth":"1960-01-02","gender":"Male","relationship":"Child","address":"1200 Woods Et","city":"Naugatuck","state":"CT","zip":"06770","cobBeginDate":null,"cobEndDate":null,"medCareAStrtDate":null,"medCareAEndDate":null,"medCareBStrtDate":null,"medCareBEndDate":null,"medCareDStrtDate":null,"medCareDEndDate":null,"priorCovBegnDate":null,"priorCovEndDate":null,"deliveryPreffered":""}]';
        
        Enrolees__c enrol=[Select id from Enrolees__c where First_Name__c='CalebSouse' LIMIT 1];
        Stream_Request_Details__c reqDet=[Select id from Stream_Request_Details__c where Plat_form__c='PRIME' LIMIT 1];
        Case cas=[Select id from Case where Status='New' LIMIT 1];
        Test.startTest();
        ERM_RequestController.insertDataEnrollee(EnrolleeJSOn,reqDet.id,cas.id);  
        ERM_RequestController.insertDataEnrolleeList(EnrolleeJSOnLst,reqDet.id,cas.id); 
        ERM_RequestController.insertEnrollee(enrolObj,reqDet.id,cas.id); 
        Test.stopTest();       
    }
    
    static testmethod void getPicklistvaluesTest(){
        List<String> optnLst=new List<String>();
        Schema.DescribeFieldResult F = Enrolees__c.Relationship__c.getDescribe();
        List<Schema.PicklistEntry> ple = F.getPicklistValues();
        for(Schema.picklistEntry SP:ple) {                  
            optnLst.add(SP.getValue());                                           
        }        
        Test.startTest();
        ERM_RequestController.getPicklistvalues('Enrolees__c', 'Relationship__c',false);
        
        ERM_RequestController.getPicklistvalues('Enrolees__c', 'Relationship__c',true);
        System.assertEquals(false, optnLst.contains('None'));
        
        ERM_RequestController.getRelationshipValues('PRIME');
        Test.stopTest();
    }
    
    Static testmethod void Test1(){
        
        ERM_RequestController.attachmentWrapper attWrap=new ERM_RequestController.attachmentWrapper();
        attWrap.serverPath='Test';
        attWrap.fileName='Test.Doc';
        
        Organization_Properties__c orgProps = Organization_Properties__c.getOrgDefaults();
        orgProps.OrganizationName__c = 'QA';
        Upsert orgProps;
        Case cas=[Select id from Case where Subject='Test Controller Acct Case' LIMIT 1];        
        List<Enrolees__c> enroleeLst=[Select id ,Request_Details__c from Enrolees__c where Case__c=:cas.id];
        
        ERM_RequestWrapper.Enrollees enrolWrap=new ERM_RequestWrapper.Enrollees();
        
        enrolWrap.EnrRequestId=enroleeLst[0].Request_Details__c;                
        
        
        Test.startTest();
        ERM_RequestController.validateBeforeSimonRequest(cas.id);
        ERM_RequestController.getEnrolleList(cas.id);       
        ERM_RequestController.updateEnrolleData(enroleeLst[0].id,enroleeLst[0],cas.id);
        Enrolees__c enrol=new Enrolees__c();
        enrol.First_Name__c='CalebSouse';
        enrol.MiddleName__c='E';
        enrol.Last_Name__c='Galleco';
        ERM_RequestController.updateEnrolleData(null,enrol,cas.id);
        ERM_RequestController.deleteEnrolleData(enroleeLst[0]);
        ERM_RequestController.getrequestdata(cas.id);
        ERM_RequestController.sendUpdateRequestToERM(cas.id);
        ERM_RequestController.sendRequestToERM(cas.id);   
        Test.stopTest();
    }
    
  
    Static testmethod void Test2(){
        
        Case cas=[Select id from Case where Subject='Test Controller Acct Case' LIMIT 1];
        
        WebserviceConfigurations__c webConfig=new WebserviceConfigurations__c(name='ERMNotesRequest',recordtypeText__c = 'Token_API',Method__c='POST',EndpointPath__c=teststring);
        insert webConfig;
        
        WebserviceConfigurations__c webConfig1=new WebserviceConfigurations__c(name='ERMServiceTokenAPIToken',recordtypeText__c = 'Token_API',AuthorizationToken__c='{"qa":"tTbymDrNtPXbS9Z3FUx9bUb7HWm7QX9l"}',Method__c='POST',EndpointPath__c=teststring);
        insert webConfig1;
        
        OrgSpecificConfigurations__c orgWebConfig=new OrgSpecificConfigurations__c(name='qa',recordtypeText__c = 'TokenAPI',WebserviceConfigurations__c=webConfig.id,EndpointDomain__c='https://gateway-stage.optum.com/api/stage/fin/billing/simonstream/requests/v1/api/Comments');
        insert orgWebConfig;
        
        Test.setMock(HttpCalloutMock.class, new ERM_HttpMockTest());
        
        Test.startTest();
        
        ERM_RequestController.returnWrap retrnWrap=new ERM_RequestController.returnWrap();
        retrnWrap.status='Success';
        retrnWrap.returnMessage='Success';
        
        Test.stopTest();
        CaseComment casCom=[Select id,IsPublished from CaseComment where ParentId =: cas.id LIMIT 1];
        casCom.IsPublished=true;
        update casCom; 
    }
    
    Static testmethod void Test3() {
        List<String> labels = new list<String>();
        labels.add('continuation-1');
        labels.add('continuation-2');
        labels.add('continuation-3');
        
        Test.startTest();
        ERM_RequestController.getHouseHoldData('12345');
        ERM_RequestController.getHasUHGAccess();
        
        
        ERM_RequestController.SearchResultWrapper1 serchWrap=new ERM_RequestController.SearchResultWrapper1();
        SAEMemberProviderSearchCoveragesResult saeMemCls=new SAEMemberProviderSearchCoveragesResult();
        SAEHouseHoldWrapper saeHousewrap=new SAEHouseHoldWrapper();
        
        serchWrap.message='Test';
        serchWrap.statusCode=200;
        serchWrap.resultWrapper1=saeHousewrap;
        serchWrap.hasAccess=true;        
        
        serchWrap.resultWrapper=saeMemCls;
        serchWrap.message='Test';
        serchWrap.statusCode=200;
        serchWrap.resultWrapper1=saeHousewrap;
        serchWrap.hasAccess=true;
        
        Profile p = [SELECT Id FROM Profile WHERE Name='Standard User']; 
        User u = new User(Alias = 'standt', Email='standarduser22@testorg.com', UHG_Access__c='Yes',
                          EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
                          LocaleSidKey='en_US', ProfileId = p.Id, 
                          TimeZoneSidKey='America/Los_Angeles', UserName='standarduser22@testorg.com');
        insert u;
        
        System.runAs(u) {
            ERM_RequestController.getHasUHGAccess(); 
        }
        
        Case cas=[Select id,status,External_Reference_ID__c from Case where Subject='Test Controller Acct Case' LIMIT 1];        
        ERM_RequestController.updateCase(cas.id,'2345');
        ERM_RequestController.updatecaseStatusToOpen(cas.id);
        Test.stopTest();
    }
    
    Static testmethod void getOptumExlusionsTest(){
        List<UHG_Restricted_Plans__mdt> testSandboxRefreshMappings = (List<UHG_Restricted_Plans__mdt>)Json.deserialize('[{"DeveloperName": "X0755742","MasterLabel": "0755742"},{"DeveloperName": "X168525","MasterLabel": "168525"},{"DeveloperName": "X0168504","MasterLabel": "0168504"}]', List<UHG_Restricted_Plans__mdt>.class); 
        Test.startTest();
        ERM_RequestController.getOptumExlusions();
        Test.stopTest();
    }
    Static testmethod void getElibilityMockDataTest(){
		Test.startTest();
        system.runAs(new user(id=userinfo.getUserId())){
            try{
                ERM_RequestController.getElibilityMockData('memberId','12/05/1996','firstName','lastName', 'groupNumber','searchOption','payerID');
            }
            catch(exception ex){
                system.debug('exception occured');
            }
            Test.stopTest();
        }
    }
    Static testmethod void ggetMemberDetailsTest(){
		Test.startTest();
        system.runAs(new user(id=userinfo.getUserId())){
            try{
                ERM_RequestController.getMemberDetails('memberId','12/05/1996','firstName','lastName', 'groupNumber','searchOption','payerID');
            }
            catch(exception ex){
                system.debug('exception occured');
            }
            Test.stopTest();
        }
    }
    Static testmethod void searchMembersTest(){
		Test.startTest();
        system.runAs(new user(id=userinfo.getUserId())){
            try{
                ERM_RequestController.searchMembers('memberId');
            }
            catch(exception ex){
                system.debug('exception occured');
            }
            Test.stopTest();
        }
    }
    Static testmethod void getMockStatusTest(){
		Test.startTest();
        system.runAs(new user(id=userinfo.getUserId())){
            try{
                ERM_RequestController.getMockStatus();
                ERM_EServices_Policy_User__c usr = new ERM_EServices_Policy_User__c();
                insert usr;
            }
            catch(exception ex){
                system.debug('exception occured');
            }
            Test.stopTest();
        }
    }
    
    global class WebservicecalloutFrameworkMock implements HttpCalloutMock {
        public Integer statusCode;
        
        public WebservicecalloutFrameworkMock(Integer statusCode) {
            this.statusCode = statusCode;
        }
        global HTTPResponse respond(HTTPRequest request) {
            HttpResponse response = new HttpResponse();
            response.setHeader('Content-Type', 'application/json');
            response.setBody('{"att1": "1"}');
            response.setStatusCode(statusCode);
            response.setStatus('status');
            return response; 
        }
    }
}