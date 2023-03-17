@isTest
private class SAE_AddMembersToSearchCtrl_Test {

    @testSetup static void setup() {
        ISL_Webservice_Config__c configObj = SAETestDataFactory.insertISLWebserviceConfig(
            'dev_ISLOAuthEndpoint',
            'ISLOAuthEndpoint',
            true,
            true,
            'ISLOAuthEndpoint',
            0,
            false,
            '',
            'https://api-stg.optum.com:8443'
        );            
    }
    
    static testMethod void searchMember() {
        Test.startTest();
        
        Test.setMock(HttpCalloutMock.class, new SAE_AddMembersToSearchCtrl_Test.SAEProviderSearchResponseMock());
        SAEProviderSearch.SearchResultWrapper response = SAE_AddMembersToSearchCtrl.findMembers('956876492', '6/8/1977', '', '', '', 'MemberIDDateOfBirth', '87726','','','','');
        
        List<State__mdt> states = SAE_AddMembersToSearchCtrl.getStateValues();

        Test.stopTest();
    }
    
    public class SAEProviderSearchResponseMock Implements HttpCalloutMock {
        public HTTPresponse respond(HttpRequest req){
            System.assertEquals('https://api-gateway-stage.linkhealth.com/elink-services/api/eligibility', req.getEndpoint());
            System.assertEquals('GET', req.getMethod());
            
            StaticResource responseJSONSR = null;
            responseJSONSR = [SELECT Body FROM StaticResource WHERE Name = 'SAEEligibilityResponseMock_Vinay'];
            HttpResponse res = new HttpResponse();
            res.setHeader('Content-Type', 'application/json');
            res.setBody(responseJSONSR.Body.toString());
            res.setStatusCode(200);
            return res;
        }
    }
    
    //Find Individual Service (Member Standalone Search) - Success
    static testMethod void findIndividualsSuccess() {
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new SAEHttpCalloutMock.SAEMemberStandaloneSearchWebServiceMock());
        SAEProviderSearch.SearchResultWrapper response = SAE_AddMembersToSearchCtrl.findMembers('962027284', '', '', '', '', '','','','','','');
        System.assertNotEquals(null, response);
        Test.stopTest();
    }
    
    static testMethod void testStandaloneWrapper() {
        Test.startTest();
        SAEMemberStandaloneSearchJSON2Apex.Pagination pagination = new SAEMemberStandaloneSearchJSON2Apex.Pagination();
        pagination.pageNumber = '1';
        pagination.pageSize = '1';
        pagination.recordCount = '1';
        pagination.totalCount = '1';
        pagination.totalPages = '1';
        pagination.moreRecords = '1';
        
        SAEMemberStandaloneSearchJSON2Apex.Address address = new SAEMemberStandaloneSearchJSON2Apex.Address();
        address.typeCode = '123';
        address.addressLine1 = 'NY';
        address.addressLine2 = 'Road1';
        address.city = 'BY';
        address.postalCode = '234';
        address.stateCode = '11';
        address.countryCode = '45';
        address.countryDescription = 'Desc';
        
        SAEMemberStandaloneSearchJSON2Apex.Telephone tp = new SAEMemberStandaloneSearchJSON2Apex.Telephone();
        tp.phoneType = 'T2';
        tp.phoneNumber = '1234567890';
        
        SAEMemberStandaloneSearchJSON2Apex.Identifiers identifier = new SAEMemberStandaloneSearchJSON2Apex.Identifiers();
        identifier.id = '1234567';
        identifier.type_Z = 'Ty';
        identifier.sourceSysCode = 'CS';
        
        SAEMemberStandaloneSearchJSON2Apex.Name name = new SAEMemberStandaloneSearchJSON2Apex.Name();
        name.firstName = 'Alex';
        name.lastName = 'Freeze';
        name.middleName = 'Middle';
        name.nameSuffix = 'MR';
        
        SAEMemberStandaloneSearchJSON2Apex.Individuals individual = new SAEMemberStandaloneSearchJSON2Apex.Individuals();
        individual.individualIdentifier = '121212';
        individual.Name = name;
        individual.birthDate = '20-10-1990';
        individual.genderCode = 'M';
        individual.socialSecurityNumber = '7262726';
        individual.address = address;
        individual.telephone = new List<SAEMemberStandaloneSearchJSON2Apex.Telephone> {tp};
        individual.identifiers = new List<SAEMemberStandaloneSearchJSON2Apex.Identifiers> {identifier};
            
        SAEMemberStandaloneSearchJSON2Apex.FindIndividualsResponse iResponse = new SAEMemberStandaloneSearchJSON2Apex.FindIndividualsResponse();
        iResponse.individuals = new List<SAEMemberStandaloneSearchJSON2Apex.Individuals> {individual};
        iResponse.Pagination = pagination;
        
        SAEMemberStandaloneSearchJSON2Apex wrapper = new SAEMemberStandaloneSearchJSON2Apex();
        wrapper.findIndividualsResponse = iResponse;
        
        Test.stopTest();        
    }
    
    static testMethod void test_getErrorMessage() {
        Test.startTest();
        String message = SAEMemberStandaloneSearchWebService.getErrorMessage('CLD200');
        System.assertNotEquals(null, message);
        Test.stopTest();
    }
}