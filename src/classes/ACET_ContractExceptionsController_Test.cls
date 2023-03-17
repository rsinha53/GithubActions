@isTest
public class ACET_ContractExceptionsController_Test {
    @testSetup static void setupCS(){
        Organization_Properties__c orgProps = Organization_Properties__c.getOrgDefaults();
        orgProps.OrganizationName__c = 'slayerdev';
        Upsert orgProps;
        
        WebserviceConfigurations__c  webConRelatedDocuments = new WebserviceConfigurations__c ();
        webConRelatedDocuments.GrantType__c  = 'client_credentials';
        webConRelatedDocuments.Headers__c  = '[{"key":"Authorization","value":"Bearer <:AUTH_TOKEN:>"},{"key":"Content-Type","value":"application/json"},{"key":"actor","value":"ACET"}]';
        webConRelatedDocuments.AuthorizationToken__c  = 'SELECT AuthorizationToken__c FROM WebserviceConfigurations__c WHERE Name = \'LinkServiceTokenAPIToken\'';
        webConRelatedDocuments.Method__c  = 'GET';
        webConRelatedDocuments.Name  = 'LinkFacilityContractExceptions';
        webConRelatedDocuments.Timeout__c = 10000;
        RecordType recTypeWebExtendedServiceAPI = [SELECT Id FROM RecordType WHERE DeveloperName = 'Service_API' and SObjectType = 'WebserviceConfigurations__c'];
        webConRelatedDocuments.RecordTypeId  = recTypeWebExtendedServiceAPI.id;
          
        insert webConRelatedDocuments;
        
        OrgSpecificConfigurations__c orgSpecServicenAPI = new OrgSpecificConfigurations__c();
        RecordType recTypeOrgServiceAPI = [SELECT Id FROM RecordType WHERE DeveloperName = 'ServiceAPI' and SObjectType = 'OrgSpecificConfigurations__c'];
        orgSpecServicenAPI.RecordTypeId  = recTypeOrgServiceAPI.Id;
        orgSpecServicenAPI.EndpointDomain__c = 'https://gateway-stage.optum.com/elink-extended/api/networkStatus/v3.';
        orgSpecServicenAPI.ClientId__c = 'test';
        orgSpecServicenAPI.ClientSecret__c = 'a723ef27-493b-4afa-2d43-43542cc87rf3';
        orgSpecServicenAPI.EnableMock__c=true;
        orgSpecServicenAPI.Name='slayerdev';
        orgSpecServicenAPI.WebserviceConfigurations__c = webConRelatedDocuments.Id;
        insert orgSpecServicenAPI; 
        
        List<Mock_Response_Details__c> mockResponseRecList = new List<Mock_Response_Details__c>();
        Mock_Response_Details__c mockResponseRec=new Mock_Response_Details__c();
        mockResponseRec.Status_Code__c='200';
        mockResponseRec.FileName__c='ContractExceptions';
        mockResponseRec.SearchParameter__c='ContractExceptions';
        mockResponseRec.WebserviceConfigurations__c = webConRelatedDocuments.id;
        mockResponseRecList.add(mockResponseRec);
        
        //insert mockResponseRecList;
    }
    static testMethod void testParse() {
        Test.startTest();
        String requestBody='{}';
        ACET_ContractExceptions_Json2Apex.parse(requestBody);
        Test.stopTest();
    }
    static testMethod void testgetContractExceptions() {
        ACET_ContractExceptionsController a = new ACET_ContractExceptionsController();
        ACET_ContractExceptionsController.getContractExceptions('000287049','351611050','134565534');
    }
}