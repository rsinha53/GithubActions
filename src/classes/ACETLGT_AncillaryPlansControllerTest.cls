/**
 * @description       : Test Class for Ancillary Plans 
 * @author            : Hasara
 * @group             : Styx
 * @last modified on  : 08-06-2021
**/
@isTest(seeAllData=false)
public class ACETLGT_AncillaryPlansControllerTest {
    @testSetup static void setup() {
        Test.startTest();
        
         List<ISL_Webservice_Config__c> webConfigList=new List<ISL_Webservice_Config__c>();
        ISL_Webservice_Config__c topsConfig2 = new ISL_Webservice_Config__c();
        topsConfig2.Name = 'qa_StargateOAuthEndpoint';
        topsConfig2.ACET_Common_Name__c = 'StargateOAuthEndpoint';
        topsConfig2.Value__c = '/auth/oauth/v2/token';
        webConfigList.add(topsConfig2);
       
        Organization_Properties__c orgProps = Organization_Properties__c.getOrgDefaults();
        orgProps.OrganizationName__c = 'QA';
        upsert orgProps;
        
        // Token API data
        WebserviceConfigurations__c starTokenAPIWSConfig = ACET_WebserviceCalloutFramework_Test.createTokenWSConfigs('StarGateTokenAPI');
        OrgSpecificConfigurations__c starTokenAPIOrgSpecificConfigs = ACET_WebserviceCalloutFramework_Test.createTokenOrgWSConfigs(starTokenAPIWSConfig.Id);
        starTokenAPIOrgSpecificConfigs.EnableErrorLog__c = true;
        update starTokenAPIOrgSpecificConfigs;
        // Service API data
        WebserviceConfigurations__c orswsConfig = ACET_WebserviceCalloutFramework_Test.createWSConfig('ACETAncillarySearchEndpoint', starTokenAPIWSConfig.Id);
        OrgSpecificConfigurations__c orsorgSpecificConfigs = ACET_WebserviceCalloutFramework_Test.createOrgWSConfigs(orswsConfig.Id);
        orsorgSpecificConfigs.EnableErrorLog__c = true;
        update orsorgSpecificConfigs;
        
        test.stopTest();
    }
    
    @isTest static void getAncillaryPlansDataTest(){ 
        StaticResource sr= [select id,body from StaticResource Where Name = 'ACETAncillaryPlanMockResponse'];
        String samplebody = sr.body.toString();
        Test.setMock(HttpCalloutMock.class, new ACET_ORSMockResponse(samplebody, 200));
        test.startTest();
        ACETLGT_AncillaryPlansController.AncillaryData data = new ACETLGT_AncillaryPlansController.AncillaryData();
        data.groupNumber = '1000987';
                data.benefitBundleOptionId = '7927703';
                data.identifier = '721728127';
                data.membersearch = true;
                data.asofdate = '04/01/2021';
                data.effectivedate = '01/01/2019';
                data.enddate = '12/31/9999';
        ACETLGT_AncillaryPlansController.getAncillaryPlansData(JSON.serialize(data));
        
        test.stopTest();
    }
    
    @isTest static void getAncillaryPlansDataTestexception(){ 
        StaticResource sr= [select id,body from StaticResource Where Name = 'ACETAncillaryPlanExMockResponse'];
        String samplebody = sr.body.toString();
        Test.setMock(HttpCalloutMock.class, new ACET_ORSMockResponse(samplebody, 200));
        
        test.startTest();
        ACETLGT_AncillaryPlansController.AncillaryData data = new ACETLGT_AncillaryPlansController.AncillaryData();
        data.groupNumber = '1000987';
                data.benefitBundleOptionId = '7927703';
                data.identifier = '721728127';
                data.membersearch = true;
                data.asofdate = '04/01/2021';
                data.effectivedate = '01/01/2019';
                data.enddate = '12/31/9999';
        ACETLGT_AncillaryPlansController.getAncillaryPlansData(JSON.serialize(data));
        
        test.stopTest();
    }
}