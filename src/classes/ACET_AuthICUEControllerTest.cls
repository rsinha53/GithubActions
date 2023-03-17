@isTest
public class ACET_AuthICUEControllerTest {
      @testSetup static void testSetupMethod() {
        Organization_Properties__c orgProps = Organization_Properties__c.getOrgDefaults();
        orgProps.OrganizationName__c = 'QA';
        Upsert orgProps;
        // Token API data
        WebserviceConfigurations__c tokenAPIWSConfig = ACET_WebserviceCalloutFramework_Test.createTokenWSConfigs('StarGateTokenAPI');
        OrgSpecificConfigurations__c tokenAPIOrgSpecificConfigs = ACET_WebserviceCalloutFramework_Test.createTokenOrgWSConfigs(tokenAPIWSConfig.Id);
        //WebserviceConfigurations__c authTokenWSConfig = ACET_WebserviceCalloutFramework_Test.createAuthTokenWSConfig('StarGateTokenAPI');

        // Service API data
        WebserviceConfigurations__c wsConfig = ACET_WebserviceCalloutFramework_Test.createWSConfig('ICUEFindLetters', tokenAPIWSConfig.Id);
        OrgSpecificConfigurations__c orgSpecificConfigs = ACET_WebserviceCalloutFramework_Test.createOrgWSConfigs(wsConfig.Id);

        WebserviceConfigurations__c wsConfig1 = ACET_WebserviceCalloutFramework_Test.createWSConfig('ICUEGetLetters', tokenAPIWSConfig.Id);
        OrgSpecificConfigurations__c orgSpecificConfigs1 = ACET_WebserviceCalloutFramework_Test.createOrgWSConfigs(wsConfig1.Id);


        List<ISL_Webservice_Config__c> lstofWebServiceConfigs = new List<ISL_Webservice_Config__c>();
        lstofWebServiceConfigs.add(new ISL_Webservice_Config__c(Name='dev_ICUELetterFind',Value__c = 'https://api-gateway-stage.linkhealth.com/rlink-extended/api'));
        lstofWebServiceConfigs.add(new ISL_Webservice_Config__c(Name='dev_ICUELetterGet',Value__c = 'https://api-gateway-stage.linkhealth.com/rlink-extended/api'));
       lstofWebServiceConfigs.add(new ISL_Webservice_Config__c(Name='SNIAPIAccessToken',Value__c = 'sjhjsdhfkjsdhfkjhsdfsdf'));
          
        insert lstofWebServiceConfigs;
    }


    static testmethod void testfindICUE(){
        
        Test.startTest();
         Cache.Org.put('local.WebserviceFramework.StarGateTokenAPIToken', 'abc');
        datetime dtimeExp = datetime.now();
        datetime dtimeExpiry = dtimeExp.addSeconds(300);
        string dtimeExpiryStr = string.valueof(dtimeExpiry);
        Cache.Org.put('local.WebserviceFramework.StarGateTokenAPITokenExpiry', dtimeExpiryStr);
        Test.setMock(HttpCalloutMock.class, new SAEHttpCalloutMock.ACET_ECAALetterEndPointService200());
        ACET_AuthICUEController.findICUE('123123123123');
        //ACET_AuthICUEController.getICUEDoc();
        ACET_AuthICUEController ac= new ACET_AuthICUEController();
       //ac.getdoc360Value();
         Test.setMock(HttpCalloutMock.class, new ACET_ViewPCPReferralMockResponse(400,true));
         ACET_AuthICUEController.findICUE('123123123123');
         Test.setMock(HttpCalloutMock.class, new ACET_ViewPCPReferralMockResponse(800,true));
         ACET_AuthICUEController.findICUE('123123123123');
        // For Exception
        Test.setMock(HttpCalloutMock.class, new SAEHttpCalloutMock.SAERCEDAPIWSMock200());
         ACET_AuthICUEController.findICUE('123123123123');
        

        Test.stopTest();
    }

    public static testMethod void testGetICUELetterContent () {
        Test.startTest();
        ACET_AuthICUEController ac= new ACET_AuthICUEController();
        Test.setMock(HttpCalloutMock.class, new ACET_WebserviceCalloutFramework_Test.WebservicecalloutFrameworkMock(200));
        Cache.Org.put('local.WebserviceFramework.StarGateTokenAPIToken', 'abc');
        datetime dtimeExp = datetime.now();
        datetime dtimeExpiry = dtimeExp.addSeconds(300);
        string dtimeExpiryStr = string.valueof(dtimeExpiry);
        Cache.Org.put('local.WebserviceFramework.StarGateTokenAPITokenExpiry', dtimeExpiryStr);
        pageReference pager = page.ACET_Doc360Iframe;
        Test.setCurrentPage(pager);
        apexPages.Currentpage().getParameters().put('DocId','abc');
        ac.getdoc360Value();
        Test.stopTest();
    }
     public static testMethod void testCHSGetICUELetterContent() {
        Test.startTest();
        ACET_AuthICUEController ac= new ACET_AuthICUEController();
        Test.setMock(HttpCalloutMock.class, new ACET_WebserviceCalloutFramework_Test.WebservicecalloutFrameworkMock(200));
        Cache.Org.put('local.WebserviceFramework.StarGateTokenAPIToken', 'abc');
        datetime dtimeExp = datetime.now();
        datetime dtimeExpiry = dtimeExp.addSeconds(300);
        string dtimeExpiryStr = string.valueof(dtimeExpiry);
        Cache.Org.put('local.WebserviceFramework.StarGateTokenAPITokenExpiry', dtimeExpiryStr);
        pageReference pager = page.ACET_Doc360Iframe;
        Test.setCurrentPage(pager);
        apexPages.Currentpage().getParameters().put('DocId','abc');
        apexpages.currentpage().getparameters().put('indexName','u_icue_nextgen');
        apexpages.currentpage().getparameters().put('businessFlow','CHS');
        ac.getdoc360Value();
        Test.stopTest();
    }
}