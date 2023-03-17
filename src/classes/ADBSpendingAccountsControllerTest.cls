@isTest
private class ADBSpendingAccountsControllerTest {
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
        Map<String, Object> results = ADBSpendingAccountsController.fetchFinancialOverviews('12345678', 'JOE', 'ROOT', '24680', '1990-12-30', true, '');
        Test.startTest();
        StaticResourceCalloutMock mock = new StaticResourceCalloutMock();
        mock.setStaticResource('ADBFinancialOverViewResponse');
        mock.setStatusCode(200);
        // Set the mock callout mode
        Test.setMock(HttpCalloutMock.class, mock);
        results = ADBSpendingAccountsController.fetchFinancialOverviews('12345678', 'JOE', 'ROOT', '24680', '1990-12-30',true,'');
        Test.stopTest();
    }
    
	@isTest static void testFinancialOverviewsWithSSN() {
        Map<String, Object> results = ADBSpendingAccountsController.fetchFinancialOverviews('12345678', 'JOE', 'ROOT', '24680', '1990-12-30', true, '999-88-7777');
        Test.startTest();
        StaticResourceCalloutMock mock = new StaticResourceCalloutMock();
        mock.setStaticResource('ADBFinancialOverViewResponse');
        mock.setStatusCode(200);
        // Set the mock callout mode
        Test.setMock(HttpCalloutMock.class, mock);
        results = ADBSpendingAccountsController.fetchFinancialOverviews('12345678', 'JOE', 'ROOT', '24680', '1990-12-30',true,'999-88-7777');
        Test.stopTest();
    }
    
    @isTest static void testfetchUserDetails() {
        Boolean checkAccess;
        Test.startTest();
        StaticResourceCalloutMock mock = new StaticResourceCalloutMock();
        mock.setStaticResource('ADBSecurityAccessServiceResponse');
        mock.setStatusCode(200);
        // Set the mock callout mode
        Test.setMock(HttpCalloutMock.class, mock);
        checkAccess = ADBSpendingAccountsController.fetchUserDetails('12345678');
        Test.stopTest();
    }


    @isTest static void coverADBTransactionsWrapperFunction(){
        test.startTest();
        
        ADBTransactionsWrapper.TransactionList transLsWrap = new ADBTransactionsWrapper.TransactionList();
        transLsWrap.amount = '202.41';
        transLsWrap.description='Consumer';
        transLsWrap.processedDate='2019-10-31';
        transLsWrap.status='PROCCESSED';
        transLsWrap.type_Z='PAYMENT';
        
        ADBTransactionsWrapper.TransactionData transWrap = new ADBTransactionsWrapper.TransactionData();
        transWrap.ssn = '348040554';
        transWrap.firstName = 'VIJAYA BHASKER';
        transWrap.lastName = 'LOKA';
        transWrap.accountCode = '7';
        transWrap.accountNumber = null;
        transWrap.accountType = 'HSA';
        transWrap.investedBalance = null;
        transWrap.accountError = null;
        transWrap.transList = null;
        test.stopTest(); 
    }
    
    @isTest static void coverADBFinancialOverviewWrapperFunction() {
        Test.startTest();
        ADBFinancialOverViewResponseWrapper.AccountFunding accFund = new ADBFinancialOverViewResponseWrapper.AccountFunding();
         accFund.benefitAmount = '500.00';
		 accFund.carryOverAmount = '0.00';
		 accFund.carryOverBalanceAmount = '0.00';
		 accFund.carryOverIndicator = '0';
		 accFund.employeeContributionAmount = '0.00';
		 accFund.employeeContributionIndicator = 'false';
		 accFund.employeeElectedAmount = '0.00';
		 accFund.employerContributionAmount = '500.00';
		 accFund.employerContributionIndicator = 'true';
		 accFund.employerContributionLessIncentiveAmount = '500.00';
		 accFund.incentiveIndicator = 'false';
		 accFund.legacyFundingAmount = '0.00';
		 accFund.prefundAmount = '0.00';
		 accFund.prefundIndicator = 'false';
		 accFund.totalRefunds = '0.00';
         accFund.filingStatus = null;
         accFund.contributionLimit = null;
          
         ADBFinancialOverViewResponseWrapper.Accounts acc = new ADBFinancialOverViewResponseWrapper.Accounts();
         acc.accountCode = '7';
		 acc.accountNumber = null;
		 acc.accountType = 'FSA DC';
		 acc.investedBalance = null;
		 acc.transactions = null;
		 acc.accountError = null;
        
        ADBFinancialOverViewResponseWrapper.Faro fro = new ADBFinancialOverViewResponseWrapper.Faro();
         fro.memberDetail = null;
		 fro.accounts = null;
         fro.error = 'Error Getting Result For Notional Account (FSA DC)';
        
        ADBFinancialOverViewResponseWrapper.SplitDeductible spd = new ADBFinancialOverViewResponseWrapper.SplitDeductible();
        spd.accessPointRemainingAmount = '0.00';
        spd.appliedAmount = '0.00';
        spd.appliedToAccessPoint = '0.00';
        spd.deductibleTypeCode = 'Individual';
        spd.firstName = 'BOB';
        spd.hraAccessibleIndicator = 'false';
        spd.lastName = 'DORAISINGH';
        spd.phiIndicator = 'false';
        spd.remainingBalanceAmount = '500.00';
        
        
        ADBFinancialOverViewResponseWrapper.AccountDeductible ad = new ADBFinancialOverViewResponseWrapper.AccountDeductible();
        ad.familyAccessPoint = '0.00';
        ad.hraIncentiveAmount = '0.00';
        ad.individualAccessPoint = '0.00';
        ad.individualMaxReimbursementAmount = '0.00';
        ad.individualMaxReimbursementIndicator = 'false';
        ad.splitDeductibleIndicator = 'false';
        ad.splitDeductible = null;
        
        
        ADBFinancialOverViewResponseWrapper.Transactions tr = new ADBFinancialOverViewResponseWrapper.Transactions();
        tr.amount = '165.0';
        tr.description = 'Consumer';
        tr.processedDate = '2019-10-01';
        tr.status = 'PROCCESSED';
        tr.type_Z = 'PAYMENT';
        
        ADBFinancialOverViewResponseWrapper.MemberDetail md = new ADBFinancialOverViewResponseWrapper.MemberDetail();
        md.ssn = '348040554';
        md.firstName = 'VIJAYA BHASKER';
        md.lastName = 'LOKA';
         
        ADBFinancialOverViewResponseWrapper.AccountBalance ab = new ADBFinancialOverViewResponseWrapper.AccountBalance();
        ab.claimAmount = '0.00';
        ab.claimPaidAmount = '0.00';
        ab.currentBalanceAmount = '500.00';
        ab.paidAmount = '0.00';
        ab.totalBalance = '500.00';
        
        ADBFinancialOverViewResponseWrapper.FilingStatus fs = new ADBFinancialOverViewResponseWrapper.FilingStatus();
        fs.currentYearFilingStatus = null;
        fs.priorYearFilingStatus = null;
        
		ADBFinancialOverViewResponseWrapper.ContributionLimit cl = new ADBFinancialOverViewResponseWrapper.ContributionLimit();
        cl.currentYearContributionLimit = null;
        cl.priorYearContributionLimit = null;
        
        ADBFinancialOverViewResponseWrapper.PlanBenefitSet pb = new ADBFinancialOverViewResponseWrapper.PlanBenefitSet();
        pb.nonEmbeddedFamilyStatusIndicator = 'NONE';
        pb.physicianSharedSavingsIndicator = 'D';
        pb.planBenefitLevel = null;
        
        ADBFinancialOverViewResponseWrapper.AccountEFT eft = new ADBFinancialOverViewResponseWrapper.AccountEFT();
        eft.eftIndicator = 'true';
        eft.eftDisposition = 'false';
        eft.minimumCheckAmount = '0.00';
        eft.withdrawalFrequencyIndicator = 'true';
        Test.stopTest();
    }
		
	@isTest static void testCAMS() {
        test.startTest();
        String val = ADBSpendingAccountsController.getCAMSUrl('27975714'); 
        test.stopTest(); 
    }

    @isTest static void testCAMSUrl() {
        test.startTest();
        String camsUrl = ADBSpendingAccountsController.getCAMSUrlStatic();
        test.stopTest();
    }
}