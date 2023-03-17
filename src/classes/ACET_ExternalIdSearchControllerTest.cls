@isTest
public class ACET_ExternalIdSearchControllerTest {
 
    @testSetup static void testSetupMethod() {
        Organization_Properties__c orgProps = Organization_Properties__c.getOrgDefaults();
        orgProps.OrganizationName__c = 'QA';
        Upsert orgProps;

        // Token API data
        WebserviceConfigurations__c tokenAPIWSConfig = ACET_WebserviceCalloutFramework_Test.createTokenWSConfigs('LinkTokenAPI');
        OrgSpecificConfigurations__c tokenAPIOrgSpecificConfigs = ACET_WebserviceCalloutFramework_Test.createTokenOrgWSConfigs(tokenAPIWSConfig.Id);
        WebserviceConfigurations__c starTokenAPIWSConfig = ACET_WebserviceCalloutFramework_Test.createTokenWSConfigs('StarGateTokenAPI');
        OrgSpecificConfigurations__c starTokenAPIOrgSpecificConfigs = ACET_WebserviceCalloutFramework_Test.createTokenOrgWSConfigs(starTokenAPIWSConfig.Id);

        // Service API data
        WebserviceConfigurations__c orswsConfig = ACET_WebserviceCalloutFramework_Test.createWSConfig('ORSSelectIssue', starTokenAPIWSConfig.Id);
        OrgSpecificConfigurations__c orsorgSpecificConfigs = ACET_WebserviceCalloutFramework_Test.createOrgWSConfigs(orswsConfig.Id);
        WebserviceConfigurations__c claDetailwsConfig = ACET_WebserviceCalloutFramework_Test.createWSConfig('LinkClaimDetail', tokenAPIWSConfig.Id);
        OrgSpecificConfigurations__c claDetailorgSpecificConfigs = ACET_WebserviceCalloutFramework_Test.createOrgWSConfigs(claDetailwsConfig.Id);
        WebserviceConfigurations__c claimActwsConfig = ACET_WebserviceCalloutFramework_Test.createWSConfig('LinkClaimAction', tokenAPIWSConfig.Id);
        OrgSpecificConfigurations__c claimActorgSpecificConfigs = ACET_WebserviceCalloutFramework_Test.createOrgWSConfigs(claimActwsConfig.Id);
        WebserviceConfigurations__c orsUpdatewsConfig = ACET_WebserviceCalloutFramework_Test.createWSConfig('OrsUpdateIssueMicroService', starTokenAPIWSConfig.Id);
        OrgSpecificConfigurations__c orsUpdateorgSpecificConfigs = ACET_WebserviceCalloutFramework_Test.createOrgWSConfigs(orsUpdatewsConfig.Id);
        WebserviceConfigurations__c orsReadwsConfig = ACET_WebserviceCalloutFramework_Test.createWSConfig('ORSReadIssueMicroService', starTokenAPIWSConfig.Id);
        OrgSpecificConfigurations__c orsReadorgSpecificConfigs = ACET_WebserviceCalloutFramework_Test.createOrgWSConfigs(orsReadwsConfig.Id);
        WebserviceConfigurations__c facetwsConfig = ACET_WebserviceCalloutFramework_Test.createWSConfig('FacetsGetCases', starTokenAPIWSConfig.Id);
        OrgSpecificConfigurations__c facetorgSpecificConfigs = ACET_WebserviceCalloutFramework_Test.createOrgWSConfigs(facetwsConfig.Id);
    }

  
    @isTest static void testGetORSIssueDetails() {

        List < ISL_Webservice_Config__c > wsConfigs = new List < ISL_Webservice_Config__c > ();
        wsConfigs.add(new ISL_Webservice_Config__c(Name = 'SNIAPIAccessToken', Value__c = 'zwdsk9VPXJASohgqS2zqXD0UxD9MEa5g'));
        wsConfigs.add(new ISL_Webservice_Config__c(Name = 'dev_ORSReadIssue', Value__c = 'https://gateway-stage.optum.com/api/STAGE/cdm/constmgmt/eaipxdomain-rid/issues/v1/Read'));
        wsConfigs.add(new ISL_Webservice_Config__c(Name = 'dev_ORSReadIssueMicroService', Value__c = 'https://gateway-stage.optum.com/api/STAGE/cdm/constmgmt/eaipxdomain-rid/issues/v1/Read'));
        wsConfigs.add(new ISL_Webservice_Config__c(Name = 'dev_ORSEAIPToken', Value__c = 'zwdsk9VPXJASohgqS2zqXD0UxD9MEa5g'));
        wsConfigs.add(new ISL_Webservice_Config__c(Name = 'EAIPLoginFlowHeaderAccept', Value__c = 'application/json'));
        wsConfigs.add(new ISL_Webservice_Config__c(Name = 'EAIPLoginFlowHttpHeaderActor', Value__c = 'ACET'));
        wsConfigs.add(new ISL_Webservice_Config__c(Name = 'EAIPLoginFlowHttpHeaderContentType', Value__c = 'application/json'));
        wsConfigs.add(new ISL_Webservice_Config__c(Name = 'EAIPLoginFlowHttpMethod', Value__c = 'EAIPLoginFlowHttpMethod'));
        Insert wsConfigs;

        Test.startTest();
        StaticResource responseReadJSON = [SELECT Body FROM StaticResource WHERE Name = 'ACET_ORSReadIssueMockResponse'];
        Test.setMock(HttpCalloutMock.class, new ACET_ORSMockResponse(responseReadJSON.Body.toString(), 200));
        ACET_ExternalIdSearchController.fetchexternalIdDatabyORS('ORS', 'ORS');    
        
        StaticResource responseSelectJSON = [SELECT Body FROM StaticResource WHERE Name = 'ACET_SelectIssueMockResponse'];
        Test.setMock(HttpCalloutMock.class, new ACET_ORSMockResponse(responseSelectJSON.Body.toString(), 200));
        ACET_ExternalIdSearchController.fetchexternalIdData('ORS', 'ALTERNATE_ID',system.today(), system.today(), '673', 'JR2');
        Test.stopTest();
        
    }
    
    // with searchtype as CLAIM_ID
     @isTest static void testGetORSIssueDetails2() {

        List < ISL_Webservice_Config__c > wsConfigs = new List < ISL_Webservice_Config__c > ();
        wsConfigs.add(new ISL_Webservice_Config__c(Name = 'SNIAPIAccessToken', Value__c = 'zwdsk9VPXJASohgqS2zqXD0UxD9MEa5g'));
        wsConfigs.add(new ISL_Webservice_Config__c(Name = 'dev_ORSReadIssue', Value__c = 'https://gateway-stage.optum.com/api/STAGE/cdm/constmgmt/eaipxdomain-rid/issues/v1/Read'));
        wsConfigs.add(new ISL_Webservice_Config__c(Name = 'dev_ORSReadIssueMicroService', Value__c = 'https://gateway-stage.optum.com/api/STAGE/cdm/constmgmt/eaipxdomain-rid/issues/v1/Read'));
        wsConfigs.add(new ISL_Webservice_Config__c(Name = 'dev_ORSEAIPToken', Value__c = 'zwdsk9VPXJASohgqS2zqXD0UxD9MEa5g'));
        wsConfigs.add(new ISL_Webservice_Config__c(Name = 'EAIPLoginFlowHeaderAccept', Value__c = 'application/json'));
        wsConfigs.add(new ISL_Webservice_Config__c(Name = 'EAIPLoginFlowHttpHeaderActor', Value__c = 'ACET'));
        wsConfigs.add(new ISL_Webservice_Config__c(Name = 'EAIPLoginFlowHttpHeaderContentType', Value__c = 'application/json'));
        wsConfigs.add(new ISL_Webservice_Config__c(Name = 'EAIPLoginFlowHttpMethod', Value__c = 'EAIPLoginFlowHttpMethod'));
        Insert wsConfigs;

        Test.startTest();
        StaticResource responseSelectJSON = [SELECT Body FROM StaticResource WHERE Name = 'ACET_SelectIssueMockResponse'];
        Test.setMock(HttpCalloutMock.class, new ACET_ORSMockResponse(responseSelectJSON.Body.toString(), 200));
        ACET_ExternalIdSearchController.fetchexternalIdData('CLAIM_ID', 'ALTERNATE_ID',system.today(), system.today(), '673', 'JR2');
        Test.stopTest();
        
    }
    
    // with searchtype as ASSOCIATE_ID
	 @isTest static void testGetORSIssueDetails3() {

        List < ISL_Webservice_Config__c > wsConfigs = new List < ISL_Webservice_Config__c > ();
        wsConfigs.add(new ISL_Webservice_Config__c(Name = 'SNIAPIAccessToken', Value__c = 'zwdsk9VPXJASohgqS2zqXD0UxD9MEa5g'));
        wsConfigs.add(new ISL_Webservice_Config__c(Name = 'dev_ORSReadIssue', Value__c = 'https://gateway-stage.optum.com/api/STAGE/cdm/constmgmt/eaipxdomain-rid/issues/v1/Read'));
        wsConfigs.add(new ISL_Webservice_Config__c(Name = 'dev_ORSReadIssueMicroService', Value__c = 'https://gateway-stage.optum.com/api/STAGE/cdm/constmgmt/eaipxdomain-rid/issues/v1/Read'));
        wsConfigs.add(new ISL_Webservice_Config__c(Name = 'dev_ORSEAIPToken', Value__c = 'zwdsk9VPXJASohgqS2zqXD0UxD9MEa5g'));
        wsConfigs.add(new ISL_Webservice_Config__c(Name = 'EAIPLoginFlowHeaderAccept', Value__c = 'application/json'));
        wsConfigs.add(new ISL_Webservice_Config__c(Name = 'EAIPLoginFlowHttpHeaderActor', Value__c = 'ACET'));
        wsConfigs.add(new ISL_Webservice_Config__c(Name = 'EAIPLoginFlowHttpHeaderContentType', Value__c = 'application/json'));
        wsConfigs.add(new ISL_Webservice_Config__c(Name = 'EAIPLoginFlowHttpMethod', Value__c = 'EAIPLoginFlowHttpMethod'));
        Insert wsConfigs;

        Test.startTest();
        StaticResource responseSelectJSON = [SELECT Body FROM StaticResource WHERE Name = 'ACET_SelectIssueMockResponse'];
        Test.setMock(HttpCalloutMock.class, new ACET_ORSMockResponse(responseSelectJSON.Body.toString(), 200));
        ACET_ExternalIdSearchController.fetchexternalIdData('ASSOCIATE_ID', 'ALTERNATE_ID',system.today(), system.today(), '673', 'JR2');
        Test.stopTest();
        
    }
    
    @isTest static void getOfficeOptionsTest() {
        Test.startTest();
        List<String> officeOptions = ACET_ExternalIdSearchController.getOfficeOptions();
        
        Test.stopTest();
    }
    
    @isTest static void getDepartmentOptionsTest() {
        Test.startTest();
        ACET_External__mdt external = [SELECT Office__c from ACET_External__mdt LIMIT 1];
        List<String> departmentOptions = ACET_ExternalIdSearchController.getDepartmentOptions(external.Office__c);
        
        Test.stopTest();
    }
    
    @isTest static void getTeamOptionsTest() {
        Test.startTest();
        ACET_External__mdt external = [SELECT Office__c, Department__c from ACET_External__mdt LIMIT 1];
        List<String> teamOptions = ACET_ExternalIdSearchController.getTeamOptions(external.Office__c, external.Department__c);
        
        Test.stopTest();
    }
    
     @isTest static void getAssociateOptionsTest() {
        Test.startTest();
        ACET_External__mdt external = [SELECT Office__c, Department__c,Team__c from ACET_External__mdt LIMIT 1];
        List<ACET_SelectAssociateWS.SelectAssociateOutput> teamOptions = ACET_ExternalIdSearchController.getAssociateOptions(external.Office__c, external.Department__c, external.Team__c);
        
        Test.stopTest();
    }
    

}