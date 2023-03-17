@isTest
private class ADBFinancialOverViewWebServiceTest {
    @testSetup
    static void setupTestData() {
        ACETOrgNameToSwivelEndpointMap__c sample = new ACETOrgNameToSwivelEndpointMap__c();
        sample.Name = 'ADBCAMSUrl';
        sample.Swivel_Endpoint__c = 'https://sample.com';
        insert sample;
        // create test data for custom setting
        ACETOrgNameToSwivelEndpointMap__c url = new ACETOrgNameToSwivelEndpointMap__c();
        url.Name = 'dev_CAMSWrapURL';
        url.Swivel_Endpoint__c = 'https://sample.com';
        insert url;
        List<WebserviceConfigurations__c> configs = new List<WebserviceConfigurations__c>{
            new WebserviceConfigurations__c(Name = 'ADBUserSecurityAccessAPIDetails',recordtypeText__c = 'Token_API',Method__c = 'POST',Timeout__c = 10000),
                new WebserviceConfigurations__c(Name = 'ADBFinancialOverView',recordtypeText__c = 'Token_API',Method__c = 'POST',Timeout__c = 10000)
                };                
                    insert configs;
        List<OrgSpecificConfigurations__c> orgConfigs = new List<OrgSpecificConfigurations__c>{
            new OrgSpecificConfigurations__c(WebserviceConfigurations__c = configs[0].Id,recordtypeText__c = 'TokenAPI',Name = 'QA',EndpointDomain__c = 'https://gateway-stage.optum.com/api/test/cdm/cust/service-engine-ldapt-user/v1/'),
                new OrgSpecificConfigurations__c(WebserviceConfigurations__c = configs[1].Id,recordtypeText__c = 'TokenAPI',Name = 'QA',EndpointDomain__c = 'https://gateway-stage.optum.com/api/test/fin/finances/accounts/v1')
                };
                    insert orgConfigs;
        Organization_Properties__c property = new Organization_Properties__c(OrganizationName__c = 'QA');
        insert property;
        
        ACETOrgInstanceURLToOrgNameMap__c urlinstance = new ACETOrgInstanceURLToOrgNameMap__c();
        urlinstance.Name = 'QA201';
        urlinstance.Org_Name__c = 'dev';
        insert urlinstance;
        
        ACETWrapEncryptionKey__c encryptKey = new ACETWrapEncryptionKey__c();
            encryptKey.name ='dev_CAMSEncryptionKey';
            encryptKey.Algorithm_Name__c = 'AES256';
            encryptKey.Key__c= 'tbC2KA36qE1psxs9mozyfOmy7GdrI3I9';
            insert encryptKey;
    }
	

    @isTest static void testFinancialOverviews() {
        Test.startTest();
        StaticResourceCalloutMock mock = new StaticResourceCalloutMock();
        mock.setStaticResource('ADBFinancialOverViewResponse');
        mock.setStatusCode(200);
        // Set the mock callout mode
        Test.setMock(HttpCalloutMock.class, mock);
        Map<String, Object> results = ADBFinancialOverViewWebService.getFinancialOverview('12345678', 'JOE', 'ROOT', '24680', '1990-12-30',true,'');
        Test.stopTest();
    }
    
    @isTest static void testFinancialOverviewsWithSSN() {
        Test.startTest();
        StaticResourceCalloutMock mock = new StaticResourceCalloutMock();
        mock.setStaticResource('ADBFinancialOverViewResponse');
        mock.setStatusCode(200);
        // Set the mock callout mode
        Test.setMock(HttpCalloutMock.class, mock); 
        Map<String, Object> results = ADBFinancialOverViewWebService.getFinancialOverview('12345678', 'JOE', 'ROOT', '24680', '1990-12-30',true,'999-88-7777');
        Test.stopTest();
    }
    
	@isTest static void testfetchUserDetails() {
        Test.startTest();
        StaticResourceCalloutMock mock = new StaticResourceCalloutMock();
        mock.setStaticResource('ADBSecurityAccessServiceResponse');
        mock.setStatusCode(200);
        // Set the mock callout mode
        Test.setMock(HttpCalloutMock.class, mock);
        List<String> userAccessresponse = ADBFinancialOverViewWebService.getUserAccessDetails('12345678');
        Test.stopTest();
    } 
    
    @isTest static void testcleanDate1() {
        Test.startTest();
    	String convertedDate = ADBFinancialOverViewWebService.cleanDate('1/1/1990');   
        Test.stopTest();
    }
    
    @isTest static void testcleanDate() {
        Test.startTest();
    	String convertedDate = ADBFinancialOverViewWebService.cleanDate('12/30/1990');   
        Test.stopTest();
    }
    
    @isTest static void coverADBTransactionsWrapper() {
        Test.startTest();
        ADBTransactionsWrapper atw = new ADBTransactionsWrapper();
        
    	List<ADBTransactionsWrapper.TransactionList> transList = new List<ADBTransactionsWrapper.TransactionList>();
        ADBTransactionsWrapper.TransactionList transct = new ADBTransactionsWrapper.TransactionList();
        transct.amount = '';
        transct.description = '';
        transct.processedDate = '';
        transct.status = '';
        transct.type_Z  = '';
        transList.add(transct);
        
        ADBTransactionsWrapper.TransactionData transData = new ADBTransactionsWrapper.TransactionData();
        transData.ssn = '';
        transData.accountCode = '';
        transData.accountError = '';
        transData.accountNumber = '';
        transData.accountType = '';
        transData.acctPlanYearGracePeriodExpirationDate = '';
        transData.allowCoordPayOver = '';
        transData.carryoverIndicator = '';
        transData.coordinatedPayment = '';
        transData.disableOverrideFromPortal = '';
        transData.firstName = '';
        transData.investedBalance = '';
        transData.lastName = '';
        transData.preFunded = '';
        transData.spendingCardType = '';
        transData.transList = transList;
        Test.stopTest();
    }
    
}