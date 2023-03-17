@isTest
public class ACET_TimelyFillingController_Test {
    @testSetup static void setupCS(){
        Organization_Properties__c orgProps = Organization_Properties__c.getOrgDefaults();
        orgProps.OrganizationName__c = 'slayerdev';
        Upsert orgProps;
        
        
    
        WebserviceConfigurations__c  webConifTokenApi = new WebserviceConfigurations__c ();
        webConifTokenApi.GrantType__c  = 'client_credentials';
        webConifTokenApi.Headers__c  = '[{"key":"Content-Type","value":"application/x-www-form-urlencoded"}]';
        webConifTokenApi.JSONBodyWithMergeFields__c  = '';
        webConifTokenApi.Method__c  = 'POST';
        webConifTokenApi.Name  = 'LinkServiceTokenAPI';
        RecordType recTypeTokenAPI = [SELECT Id FROM RecordType WHERE DeveloperName = 'Token_API' and SObjectType = 'WebserviceConfigurations__c'];
        webConifTokenApi.RecordTypeId  = recTypeTokenAPI.Id;
        webConifTokenApi.IsCachedToken__c=true;
        insert webConifTokenApi;
        
        OrgSpecificConfigurations__c orgSpecTokenAPI = new OrgSpecificConfigurations__c();
        RecordType recTypeOrgTokenAPI = [SELECT Id FROM RecordType WHERE DeveloperName = 'TokenAPI' and SObjectType = 'OrgSpecificConfigurations__c'];
        orgSpecTokenAPI.RecordTypeId  = recTypeOrgTokenAPI.Id;
        orgSpecTokenAPI.EndpointDomain__c = 'https://gateway-stage.optum.com/oauth/token';
        orgSpecTokenAPI.ClientId__c = 'test';
        orgSpecTokenAPI.ClientSecret__c = 'a723ef27-493b-4afa-2d43-43542cc87rf3';
        orgSpecTokenAPI.EnableMock__c=true;
         orgSpecTokenAPI.Name='slayerdev';
        orgSpecTokenAPI.WebserviceConfigurations__c = webConifTokenApi.Id;
        insert orgSpecTokenAPI; 
        
        WebserviceConfigurations__c  webConifExtendedServiceAPI = new WebserviceConfigurations__c ();
        webConifExtendedServiceAPI.GrantType__c  = 'client_credentials';
        webConifExtendedServiceAPI.Headers__c  = '[{"key":"Authorization","value":"Bearer <:AUTH_TOKEN:>"},{"key":"Content-Type","value":"application/json"},{"key":"actor","value":"ACET"}]';
        webConifExtendedServiceAPI.AuthorizationToken__c  = 'SELECT AuthorizationToken__c FROM WebserviceConfigurations__c WHERE Name = LinkServiceTokenAPIToken';
        webConifExtendedServiceAPI.Method__c  = 'GET';
        webConifExtendedServiceAPI.TokenAPI__c  = webConifTokenApi.id;
        webConifExtendedServiceAPI.Name  = 'LinkTimelyFiling';
        webConifExtendedServiceAPI.Timeout__c = 10000;
        RecordType recTypeWebExtendedServiceAPI = [SELECT Id FROM RecordType WHERE DeveloperName = 'Service_API' and SObjectType = 'WebserviceConfigurations__c'];
        webConifExtendedServiceAPI.RecordTypeId  = recTypeWebExtendedServiceAPI.id;
        insert webConifExtendedServiceAPI;
        
        
        OrgSpecificConfigurations__c orgSpecServicenAPI = new OrgSpecificConfigurations__c();
        RecordType recTypeOrgServiceAPI = [SELECT Id FROM RecordType WHERE DeveloperName = 'ServiceAPI' and SObjectType = 'OrgSpecificConfigurations__c'];
        orgSpecServicenAPI.RecordTypeId  = recTypeOrgServiceAPI.Id;
        orgSpecServicenAPI.EndpointDomain__c = 'https://gateway-stage.optum.com/elink-extended/api/networkStatus/v3.';
        orgSpecServicenAPI.ClientId__c = 'test';
        orgSpecServicenAPI.ClientSecret__c = 'a723ef27-493b-4afa-2d43-43542cc87rf3';
        orgSpecServicenAPI.EnableMock__c=true;
        orgSpecServicenAPI.Name='slayerdev';
        orgSpecServicenAPI.WebserviceConfigurations__c = webConifExtendedServiceAPI.Id;
        insert orgSpecServicenAPI; 
        
        
        Cache.Org.put('local.WebserviceFramework.LinkServiceTokenAPIToken', 'Test123');
        datetime dtimeExp = datetime.now();
         datetime dtimeExpiry = dtimeExp.addSeconds(200);
          string dtimeExpiryStr = string.valueof(dtimeExpiry);
        Cache.Org.put('local.WebserviceFramework.LinkServiceTokenAPITokenExpiry', dtimeExpiryStr);
        
        Mock_Response_Details__c mockResponseRec=new Mock_Response_Details__c();
        mockResponseRec.Status_Code__c='200';
        mockResponseRec.FileName__c='contractDetail_EI_tax_id_64713231';
        mockResponseRec.SearchParameter__c='contractDetail_EI_tax_id_64713231';
        mockResponseRec.SearchParameter__c='contractDetail_EI_tax_id_64713231';
        mockResponseRec.WebserviceConfigurations__c =webConifExtendedServiceAPI.id;
        insert mockResponseRec;
        
        
        WebserviceConfigurations__c  webConifContIdServiceAPI = new WebserviceConfigurations__c ();
        webConifContIdServiceAPI.GrantType__c  = 'client_credentials';
        webConifContIdServiceAPI.Headers__c  = '[{"key":"Authorization","value":"Bearer <:AUTH_TOKEN:>"},{"key":"Content-Type","value":"application/json"},{"key":"actor","value":"ACET"}]';
        webConifContIdServiceAPI.AuthorizationToken__c  = 'SELECT AuthorizationToken__c FROM WebserviceConfigurations__c WHERE Name = LinkServiceTokenAPIToken';
        webConifContIdServiceAPI.Method__c  = 'GET';
        webConifContIdServiceAPI.TokenAPI__c  = webConifTokenApi.id;
        webConifContIdServiceAPI.Name  = 'LinkContractorID';
        webConifContIdServiceAPI.Timeout__c = 10000;
        RecordType recTypeContIdServiceAPI = [SELECT Id FROM RecordType WHERE DeveloperName = 'Service_API' and SObjectType = 'WebserviceConfigurations__c'];
        webConifContIdServiceAPI.RecordTypeId  = recTypeContIdServiceAPI.id;
        insert webConifContIdServiceAPI;
        
        
        OrgSpecificConfigurations__c orgSpecContIdnAPI = new OrgSpecificConfigurations__c();
        RecordType recTypeOrgContIdAPI = [SELECT Id FROM RecordType WHERE DeveloperName = 'ServiceAPI' and SObjectType = 'OrgSpecificConfigurations__c'];
        orgSpecContIdnAPI.RecordTypeId  = recTypeOrgContIdAPI.Id;
        orgSpecContIdnAPI.EndpointDomain__c = 'https://gateway-stage.optum.com/elink-extended/api/networkStatus/v3.';
        orgSpecContIdnAPI.ClientId__c = 'test';
        orgSpecContIdnAPI.ClientSecret__c = 'a723ef27-493b-4afa-2d43-43542cc87rf3';
        orgSpecContIdnAPI.EnableMock__c=true;
        orgSpecContIdnAPI.Name='slayerdev';
        orgSpecContIdnAPI.WebserviceConfigurations__c = webConifContIdServiceAPI.Id;
        insert orgSpecContIdnAPI; 
        
        Mock_Response_Details__c mockResponseContId=new Mock_Response_Details__c();
        mockResponseContId.Status_Code__c='200';
        mockResponseContId.FileName__c='contractSummary_E_and_I';
        mockResponseContId.SearchParameter__c='contractSummary_E_and_I';
        mockResponseContId.SearchParameter__c='contractSummary_E_and_I';
        mockResponseContId.WebserviceConfigurations__c =webConifContIdServiceAPI.id;
        insert mockResponseContId;
        
        
    }
    @isTest
    public static void getTimelyFillingDetailsTest() {
        Test.startTest();
        ACET_TimelyFillingController a = new ACET_TimelyFillingController();
        ACET_TimelyFillingController.timelyFillingInputs input=new ACET_TimelyFillingController.timelyFillingInputs();
        input.controctorID = '64713231';
        String contractorID = '64713231';
        String firstSerDate = '01/01/2020';
        string platform ='UNET';
        string claimno='741777515';
        ACET_TimelyFillingController.getTimelyFillingDetails(contractorID,firstSerDate,platform,claimno);
     	ACET_TimelyFillingController.getTimelyFillingDetails(contractorID+'11111',firstSerDate,platform,claimno);
       ACET_TimelyFillingController.getTimelyFillingDetails('','','','');
        Test.stopTest();
    }
    @isTest
    public static void getControctorDetailsTest() {
        Test.startTest();
        string prov_id='003043211';
        string  tax_id_nbr='741777515';
        string  mkt_typ_cd='50';
        string  mkt_nbr='0006445';
        string  prdct_ofr_cd='Q';
        ACET_TimelyFillingController.getControctorDetails(tax_id_nbr,prov_id,mkt_typ_cd,mkt_nbr,prdct_ofr_cd);
        Test.stopTest();
    }
     static testMethod void ACET_TimelyFillingJSON2ApexTest(){
         Test.startTest();
         ACET_TimelyFillingJSON2Apex wrapper = new ACET_TimelyFillingJSON2Apex();
         ACET_TimelyFillingJSON2Apex.EmployerandindividualContractDetail claim = new  ACET_TimelyFillingJSON2Apex.EmployerandindividualContractDetail();
         claim.prov_id = '11234124';
         claim.tax_id_nbr = '11234124';
         claim.pnc_contr_id = '55555555';
         List< ACET_TimelyFillingJSON2Apex.EmployerandindividualContractDetail> claimSearchResultList = new List< ACET_TimelyFillingJSON2Apex.EmployerandindividualContractDetail>();
         wrapper.EmployerandindividualContractDetail = claimSearchResultList;
         ACET_TimelyFillingJSON2Apex.parse('{}');
         Test.stopTest();
     }
    
    static testMethod void ACET_TimelyFilling_Contractor_JSON2ApexTest(){
         Test.startTest();
         ACET_TimelyFilling_Contractor_JSON2Apex wrapper = new ACET_TimelyFilling_Contractor_JSON2Apex();
         ACET_TimelyFilling_Contractor_JSON2Apex.Employerandindividual claim = new  ACET_TimelyFilling_Contractor_JSON2Apex.Employerandindividual();
         claim.prov_id = '11234124';
         claim.tax_id_nbr = '11234124';
         claim.pnc_contr_id = '55555555';
         List< ACET_TimelyFilling_Contractor_JSON2Apex.Employerandindividual> claimSearchResultList = new List< ACET_TimelyFilling_Contractor_JSON2Apex.Employerandindividual>();
         wrapper.Employerandindividual = claimSearchResultList;
         ACET_TimelyFilling_Contractor_JSON2Apex.parse('{}');
         Test.stopTest();
     }
    
    static testMethod void getErrorCodeTest(){
         Test.startTest();
        
        ACET_TimelyFillingWS.getErrorResponse(400,'{"faultCode": "LCLM_S_302"}');
        ACET_TimelyFillingWS.getErrorResponse(401,'{"faultCode": "LCLM_S_302"}');
        ACET_TimelyFillingWS.getErrorResponse(404,'{"faultCode": "LCLM_S_302"}');
        ACET_TimelyFillingWS.getErrorResponse(500,'{"faultCode": "LCLM_S_302"}');
        ACET_TimelyFillingWS.getErrorResponse(503,'{"faultCode": "LCLM_S_302"}');
        ACET_TimelyFillingWS.getErrorResponse(999,'{"faultCode": "LCLM_S_302"}');
         Test.stopTest();
     }

}