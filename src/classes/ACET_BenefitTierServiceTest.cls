@isTest
public class ACET_BenefitTierServiceTest {
    @testSetup static void testSetupMethod() {
        List<ISL_Webservice_Config__c> lstofWebServiceConfigs = new List<ISL_Webservice_Config__c>();
        lstofWebServiceConfigs.add(new ISL_Webservice_Config__c(Name='dev_BenefitSummary',Value__c = 'https://api-gateway-stage.linkhealth.com/rlink-extended/api'));
        lstofWebServiceConfigs.add(new ISL_Webservice_Config__c(Name='dev_BenefitDetail',Value__c = 'https://api-gateway-stage.linkhealth.com/rlink-extended/api'));
        insert lstofWebServiceConfigs;

         Organization_Properties__c orgProps = Organization_Properties__c.getOrgDefaults();
        orgProps.OrganizationName__c = 'QA';
        Upsert orgProps;
        // Token API data
        WebserviceConfigurations__c tokenAPIWSConfig = ACET_WebserviceCalloutFramework_Test.createTokenWSConfigs('LinkServiceTokenAPI');
        OrgSpecificConfigurations__c tokenAPIOrgSpecificConfigs = ACET_WebserviceCalloutFramework_Test.createTokenOrgWSConfigs(tokenAPIWSConfig.Id);
        //WebserviceConfigurations__c authTokenWSConfig = ACET_WebserviceCalloutFramework_Test.createAuthTokenWSConfig('StarGateTokenAPI');

        // Service API data
        WebserviceConfigurations__c wsConfig = ACET_WebserviceCalloutFramework_Test.createWSConfig('LinkB360BenefitDetail', tokenAPIWSConfig.Id);
        OrgSpecificConfigurations__c orgSpecificConfigs = ACET_WebserviceCalloutFramework_Test.createOrgWSConfigs(wsConfig.Id);

         WebserviceConfigurations__c wsConfig2 = ACET_WebserviceCalloutFramework_Test.createWSConfig('LinkB360BenefitSummary', tokenAPIWSConfig.Id);
        OrgSpecificConfigurations__c orgSpecificConfigs2 = ACET_WebserviceCalloutFramework_Test.createOrgWSConfigs(wsConfig2.Id);

        WebserviceConfigurations__c wsConfig3 = ACET_WebserviceCalloutFramework_Test.createWSConfig('LinkBenefitSummary', tokenAPIWSConfig.Id);
        OrgSpecificConfigurations__c orgSpecificConfigs3 = ACET_WebserviceCalloutFramework_Test.createOrgWSConfigs(wsConfig3.Id);

        WebserviceConfigurations__c wsConfig4 = ACET_WebserviceCalloutFramework_Test.createWSConfig('LinkBenefitSearch', tokenAPIWSConfig.Id);
        OrgSpecificConfigurations__c orgSpecificConfigs4 = ACET_WebserviceCalloutFramework_Test.createOrgWSConfigs(wsConfig4.Id);

        WebserviceConfigurations__c wsConfig5 = ACET_WebserviceCalloutFramework_Test.createWSConfig('LinkBenefitLanguage', tokenAPIWSConfig.Id);
        OrgSpecificConfigurations__c orgSpecificConfigs5 = ACET_WebserviceCalloutFramework_Test.createOrgWSConfigs(wsConfig5.Id);

    }
    public static testmethod void successScenarioForBenfitSummary(){ 
        Test.setMock(HttpCalloutMock.class, new SAEHttpCalloutMock.BenfitSummarySuccessResponse());
        Test.startTest();
        //ACET_BenefitTierService.getBenefitStatus('test_231231231231231231231231');
        SAE_PoliciesCtrl.getTierStatus('test_231231231231231231231231','CS');
        Test.setMock(HttpCalloutMock.class, new SAEHttpCalloutMock.BenfitDetailSuccessResponse());
        ACET_BenefitTierService.getBenefitDetailInfo('test_231231231231231231231231','bf801770-ac77-11ea-be01-11a16443667b#0706284_ACIS012#20191224T080438701#UNET',false);
        Test.stopTest();
        
    }
    
    public static testmethod void failScenarioForBenfitSummary(){
        Test.setMock(HttpCalloutMock.class, new ACET_ViewPCPReferralMockResponse(400,true));
        Test.startTest();
        ACET_BenefitTierService.getBenefitStatus('test_231231231231231231231231','CO');
        ACET_BenefitTierService.getBenefitDetailInfo('test_231231231231231231231231','bf801770-ac77-11ea-be01-11a16443667b#0706284_ACIS012#20191224T080438701#UNET',false);
        string json= '';
        json = '{\"TestAMissingObject\": { \"TestAMissingArray\": [ { \"TestAMissingProperty\": \"Some Value\" } ] } }';
		ACET_BenefitSummaryResponse objJSON2Apex = new ACET_BenefitSummaryResponse(System.JSON.createParser(json));
		System.assert(objJSON2Apex != null);
		System.assert(objJSON2Apex.newBenefits == null);
		System.assert(objJSON2Apex.benefits == null);

		json = '{\"TestAMissingObject\": { \"TestAMissingArray\": [ { \"TestAMissingProperty\": \"Some Value\" } ] } }';
		ACET_BenefitSummaryResponse.Children objChildren = new ACET_BenefitSummaryResponse.Children(System.JSON.createParser(json));
		System.assert(objChildren != null);
		System.assert(objChildren.categoryName == null);
		System.assert(objChildren.benefitId == null);

		json = '{\"TestAMissingObject\": { \"TestAMissingArray\": [ { \"TestAMissingProperty\": \"Some Value\" } ] } }';
		ACET_BenefitSummaryResponse.Benefits objBenefits = new ACET_BenefitSummaryResponse.Benefits(System.JSON.createParser(json));
		System.assert(objBenefits != null);
		System.assert(objBenefits.categoryName == null);
		System.assert(objBenefits.children == null);
        
        json = '{\"TestAMissingObject\": { \"TestAMissingArray\": [ { \"TestAMissingProperty\": \"Some Value\" } ] } }';
		ACET_BenefitDetailSummaryResponse objACET_BenefitDetailSummaryResponse = new ACET_BenefitDetailSummaryResponse(System.JSON.createParser(json));
		System.assert(objACET_BenefitDetailSummaryResponse != null);
		System.assert(objACET_BenefitDetailSummaryResponse.newBenefits == null);
		System.assert(objACET_BenefitDetailSummaryResponse.benefit == null);

		json = '{\"TestAMissingObject\": { \"TestAMissingArray\": [ { \"TestAMissingProperty\": \"Some Value\" } ] } }';
		ACET_BenefitDetailSummaryResponse.Benefit objBenefit = new ACET_BenefitDetailSummaryResponse.Benefit(System.JSON.createParser(json));
		System.assert(objBenefit != null);
		System.assert(objBenefit.benefitName == null);
		System.assert(objBenefit.benefitDetails == null);
		System.assert(objBenefit.benefitNetworkSection == null);

		json = '{\"TestAMissingObject\": { \"TestAMissingArray\": [ { \"TestAMissingProperty\": \"Some Value\" } ] } }';
		ACET_BenefitDetailSummaryResponse.BenefitNetworkSection objBenefitNetworkSection = new ACET_BenefitDetailSummaryResponse.BenefitNetworkSection(System.JSON.createParser(json));
		System.assert(objBenefitNetworkSection != null);
		System.assert(objBenefitNetworkSection.costs == null);
		System.assert(objBenefitNetworkSection.networkStatus == null);
        
        Test.stopTest();
    }
 
    public static testmethod void successScenarioForBenfitDetail(){
        Test.setMock(HttpCalloutMock.class, new SAEHttpCalloutMock.BenfitDetailSuccessResponse());
        Test.startTest();
        ACET_BenefitTierService.getBenefitDetailInfo('test_231231231231231231231231','bf801770-ac77-11ea-be01-11a16443667b#0706284_ACIS012#20191224T080438701#UNET',false);
        ACET_BenefitTierService.processBenefitDetail('test_231231231231231231231231','bf801770-ac77-11ea-be01-11a16443667b#0706284_ACIS012#20191224T080438701#UNET',false,'CS');
        Test.stopTest();
    }

    public static testmethod void Test_getBenefitSummary(){
        StaticResourceCalloutMock mock = new StaticResourceCalloutMock();
        mock.setStaticResource('BenefitSummary_Policy2_kQHObZ5zambqH4Z');
        mock.setStatusCode(200);
        mock.setHeader('Content-Type', 'application/json');
        Test.setMock(HttpCalloutMock.class, mock);
        Test.startTest();
        	ACET_BenefitDetailsHelper.getBenefitSummary('Policy1_kQHObZ5zambqH4Z');
        Test.stopTest();
    }

    public static testmethod void Test_searchBenefit(){
        StaticResourceCalloutMock mock = new StaticResourceCalloutMock();
        mock.setStaticResource('LinkBenefitSearch_foot');
        mock.setStatusCode(200);
        mock.setHeader('Content-Type', 'application/json');
        Test.setMock(HttpCalloutMock.class, mock);
        Test.startTest();
        	ACET_BenefitDetailsHelper.searchBenefit('Policy1_kQHObZ5zambqH4Z','foot');
        Test.stopTest();
    }

    public static testmethod void Test_getBenefitLanguage(){
        StaticResourceCalloutMock mock = new StaticResourceCalloutMock();
        mock.setStaticResource('LinkBenefitLanguageDetailsMock');
        mock.setStatusCode(200);
        mock.setHeader('Content-Type', 'application/json');
        Test.setMock(HttpCalloutMock.class, mock);
        Test.startTest();
        	ACET_BenefitDetailsHelper.getBenefitLanguage('Policy1_kQHObZ5zambqH4Z','23');
        Test.stopTest();
    }
    //OON_RembersementController test
    @isTest
    static void testGetBenefitId(){
        StaticResourceCalloutMock mock = new StaticResourceCalloutMock();
        mock.setStaticResource('LinkBenefitSearch_out');
        mock.setStatusCode(200);
        mock.setHeader('Content-Type', 'application/json');
        Test.setMock(HttpCalloutMock.class, mock);

        Test.startTest();
        ACET_OONReimbursementController.getBenefitId('12345');
        Test.stopTest();
    }
     //OON_RembersementController test
    @isTest
    static void testGetENIReimbursement(){
        StaticResourceCalloutMock mock = new StaticResourceCalloutMock();
        mock.setStaticResource('LinkBenefitLanguageDetailsMock');
        mock.setStatusCode(200);
        mock.setHeader('Content-Type', 'application/json');
        Test.setMock(HttpCalloutMock.class, mock);
        Test.startTest();
        	ACET_OONReimbursementController.getENIReimbursement('12345','12345');
        Test.stopTest();
    }

}