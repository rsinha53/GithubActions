@isTest
public class ACETSNIWorkOrderICUELetterControllerTest {
    @testSetup static void testSetupMethod() {
        system.runAs(new user(id = userinfo.getUserId())){
            User userObj=  TestDataFactory.getUser('System Administrator');
            userObj.Username='tUserAuth@testorg.acet';
            userObj.FederationIdentifier='tUser';
            INSERT userObj; 
        }
        workOrder workOrderObj = new workOrder();
        workOrderObj.HSC_Unique_ID__c='156627064';
        workOrderObj.Xref_ID__c='625871210';
        workOrderObj.Status_Detail__c    = 'Prior Authorization Received';
        workOrderObj.Host_System_Date_and_Time__c = datetime.now();
        workOrderObj.Service_Reference__c = '123123123123';
        INSERT workOrderObj;
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


    static testmethod void findICUELetters_200(){
        Test.startTest();
        WorkOrder workOrderObj =[select Id,HSC_Unique_ID__c,Xref_ID__c from WorkOrder limit 1].get(0);
        ICUEDocRequest icueRequest = new ICUEDocRequest();
        icueRequest.indexName ='u_icue_nextgen';
        List<ICUEDocRequest.FilterClauses> FilterClausesLst = new List<ICUEDocRequest.FilterClauses>();
        ICUEDocRequest.FilterClauses FilterClauses = new ICUEDocRequest.FilterClauses();
        FilterClauses.type_Z = 'equal';
        FilterClauses.name = 'u_ntfy_nbr';
        FilterClauses.value = '123123123123';
        FilterClausesLst.add(FilterClauses);
        ICUEDocRequest.Criteria Criteria = new ICUEDocRequest.Criteria();
        Criteria.filterClauses = FilterClausesLst;
        icueRequest.Criteria = Criteria;
        ACET_ICUELetterWS icueService = new ACET_ICUELetterWS('CHS',icueRequest);
        Test.setMock(HttpCalloutMock.class, new SAEHttpCalloutMock.ACET_ECAALetterEndPointService200());
        ACETSNIWorkOrderICUELetterController.getSearchParamValue(workOrderObj.Id,'Service_Reference__c');
        ACETSNIWorkOrderICUELetterController.findICUELetter('123123123123','ICUE Letter');
        Test.stopTest();
    }
}