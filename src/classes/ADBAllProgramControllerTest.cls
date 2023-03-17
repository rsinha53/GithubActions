@isTest public class ADBAllProgramControllerTest {
    @testSetup static void setup() {
        WebserviceConfigurations__c configAllProgram= new WebserviceConfigurations__c(Name = 'ADBMemberProgramsAPIEndpoint', Method__c = 'POST', Timeout__c = 10000,recordtypeText__c = 'Token_API');
        insert configAllProgram;
        OrgSpecificConfigurations__c orgAllProgram = new OrgSpecificConfigurations__c(WebserviceConfigurations__c = configAllProgram.Id, Name = 'QA',recordtypeText__c = 'TokenAPI', EndpointDomain__c = 'https://gateway-stage.optum.com');
        insert orgAllProgram;
        Organization_Properties__c property = new Organization_Properties__c(OrganizationName__c = 'QA');
        insert property;
    }
    
    @isTest static void testADBAllProgramController (){
        String firstName='NEIL';
        String lastName='WARREN';
        String XrefId='33496774';
        String XrefPartitionId='274';
        test.startTest();
        StaticResourceCalloutMock mock = new StaticResourceCalloutMock();
        mock.setStaticResource('ADBMemberProgramService');
        mock.setStatusCode(200);
        // Set the mock callout mode
        Test.setMock(HttpCalloutMock.class, mock);
        ADBMemberProgramsServiceResponseWrapper getPrgrmDtls = ADBAllProgramController.getMemberProgramsAPIDetails(firstName, lastName, XrefId, XrefPartitionId);
        test.stopTest();
    }

    @isTest static void testADBAllProgramController2 (){
        String firstName='BETHEL';
        String lastName='WILLIAMS';
        String XrefId='33496774';
        String XrefPartitionId='274';
        test.startTest();
        StaticResourceCalloutMock mock = new StaticResourceCalloutMock();
        mock.setStaticResource('ADBMemberProgramsMockResponseBETHEL');
        mock.setStatusCode(200);
        // Set the mock callout mode
        Test.setMock(HttpCalloutMock.class, mock);
        ADBMemberProgramsServiceResponseWrapper getPrgrmDtls = ADBAllProgramController.getMemberProgramsAPIDetails(firstName, lastName, XrefId, XrefPartitionId);
        test.stopTest();
    }
    
    @isTest static void testSubmitAllProgramsDisposition(){
        String programICUESSOURL='test';
        String nbastatus='Accept';
        String userId = 'skollur6';
        test.startTest();
        ADBAllProgramController.submitAllProgramsDisposition(programICUESSOURL, nbastatus, userId);
        test.stopTest();
    }
    
    @isTest static void testSubmitAllProgramsDisposition1(){
        String programICUESSOURL='test';
        String nbastatus='Maybe_Later';
        String userId = 'skollur6';
        test.startTest();
        ADBAllProgramController.submitAllProgramsDisposition(programICUESSOURL, nbastatus, userId);
        test.stopTest();
    }
    
    @isTest static void testSubmitAllProgramsDisposition2(){
        String programICUESSOURL='test';
        String nbastatus='Not_Appropriate';
        String userId = 'skollur6';
        test.startTest();
        ADBAllProgramController.submitAllProgramsDisposition(programICUESSOURL, nbastatus, userId);
        test.stopTest();
    }
    
    @isTest static void  testADBMemberProgramsServiceResponseWrapper(){
        test.startTest();
       	String val = '{"availableProgramsResponse":{"availableProgramsResponseTypeList":[{"programName":"AccessSupport","programType":"HealthCareDecisionSupport(HCDS)","programPhone":"Default866-244-3125","isAcceptingReferrals":true,"hoursOfOperation":"Mon-Fri7:30am-6:30pmCST","iCUEProgram":"NONICUE","programVendor":"Optum","programStatus":"","memberProgramId":"","programICUESSOURL":"cdbXrefID=33496774&applicationId=ACET&isOffers=true&landingPage=LAUNCH_PROG_REFERRAL&popProductID=MP97&programCategoryType=null&icuePrograms=NONICUE"}],"responseHeader":{"serviceCallStatus":"Success","serviceCallStatusCode":200,"serviceName":"MemberPrograms"},"statusMessage":{"messageType":"Success","statusMessage":"Success","statusMessageCode":200,"statusMessageLevel":"Success"}}}';
		ADBMemberProgramsServiceResponseWrapper.parse(val);
    	test.stopTest();
    }

    @isTest static void  testADBMemberProgramsServiceResponseWrapper2(){
        test.startTest();
        String val = '{"availableProgramsResponse":{"availableProgramsResponseTypeList":{"programName":"UHC NurseLine","programType":"Health Care Decision Support (HCDS)","programPhone":"651-123-4567","isAcceptingReferrals":true,"hoursOfOperation":"24/7","iCUEProgram":"NONICUE","programVendor":"Optum","programStatus":"","memberProgramId":"","programICUESSOURL":"cdbXrefID=11111111&applicationId=ACET&isOffers=true&landingPage=LAUNCH_PROG_REFERRAL&popProductID=MP248&programCategoryType=null&icuePrograms=NONICUE","programDescription":"NurseLine sold for UHC  business only.","ownerName":"","ownerPhone":"","ownerEmail":""},"responseHeader":{"serviceCallStatus":"Success","serviceCallStatusCode":200,"serviceName":"MemberPrograms"},"statusMessage":{"messageType":"Success","statusMessage":"Success","statusMessageCode":200,"statusMessageLevel":"Success"}}}';
        val = val.replace('"availableProgramsResponse"', '"singleAvailableProgramsResponse"');
        val = val.replace('"availableProgramsResponseTypeList"', '"singleAvailableProgramsResponseList"');
        ADBMemberProgramsServiceResponseWrapper.parse(val);
        test.stopTest();
    }
}