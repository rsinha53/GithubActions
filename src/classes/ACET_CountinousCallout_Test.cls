@isTest
public class ACET_CountinousCallout_Test {
    
    @testSetup static void setupCS(){
        Organization_Properties__c orgProps = Organization_Properties__c.getOrgDefaults();
        orgProps.OrganizationName__c = 'slayerdev';
        Upsert orgProps;
        
        List<WebserviceConfigurations__c> wcList = new List<WebserviceConfigurations__c>();
        
        WebserviceConfigurations__c  webConRelatedDocuments = new WebserviceConfigurations__c ();
        webConRelatedDocuments.GrantType__c  = 'client_credentials';
        webConRelatedDocuments.Headers__c  = '[{"key":"Authorization","value":"Bearer <:AUTH_TOKEN:>"},{"key":"Content-Type","value":"application/json"},{"key":"actor","value":"ACET"}]';
        webConRelatedDocuments.AuthorizationToken__c  = 'SELECT AuthorizationToken__c FROM WebserviceConfigurations__c WHERE Name = \'LinkServiceTokenAPIToken\'';
        webConRelatedDocuments.Method__c  = 'GET';
        //webConRelatedDocuments.TokenAPI__c  = webConifTokenApi.id;
        webConRelatedDocuments.Name  = 'LinkRelatedDocuments';
        webConRelatedDocuments.Timeout__c = 10000;
        RecordType recTypeWebExtendedServiceAPI = [SELECT Id FROM RecordType WHERE DeveloperName = 'Service_API' and SObjectType = 'WebserviceConfigurations__c'];
        webConRelatedDocuments.RecordTypeId  = recTypeWebExtendedServiceAPI.id;
        webConRelatedDocuments.RecordTypeText__c = 'Service_API';
        wcList.add(webConRelatedDocuments);
        
        WebserviceConfigurations__c  wc = new WebserviceConfigurations__c ();
        wc.GrantType__c  = 'client_credentials';
        wc.Headers__c  = '[{"key":"Authorization","value":"Bearer <:AUTH_TOKEN:>"},{"key":"Content-Type","value":"application/json"},{"key":"actor","value":"ACET"}]';
        wc.AuthorizationToken__c  = 'SELECT AuthorizationToken__c FROM WebserviceConfigurations__c WHERE Name = \'LinkServiceTokenAPIToken\'';
        wc.Method__c  = 'GET';
        wc.Name  = 'DOC360GLobalURL';
        wc.Timeout__c = 10000;
        wc.RecordTypeText__c = 'Service_API';
        wc.RecordTypeId  = recTypeWebExtendedServiceAPI.id;
        
        wcList.add(wc);
        
        insert wcList;
        
        List<Mock_Response_Details__c> mockResponseRecList = new List<Mock_Response_Details__c>();
        Mock_Response_Details__c mockResponseRec=new Mock_Response_Details__c();
        mockResponseRec.Status_Code__c='200';
        mockResponseRec.FileName__c='u_cosmos_pra';
        mockResponseRec.SearchParameter__c='u_cosmos_pra';
        mockResponseRec.WebserviceConfigurations__c = webConRelatedDocuments.id;
        mockResponseRecList.add(mockResponseRec);
        
        Mock_Response_Details__c mockResponseRec1=new Mock_Response_Details__c();
        mockResponseRec1.Status_Code__c='200';
        mockResponseRec1.FileName__c='u_cosmos_pra_ub';
        mockResponseRec1.SearchParameter__c='u_cosmos_pra_ub';
        mockResponseRec1.WebserviceConfigurations__c = webConRelatedDocuments.id;
        mockResponseRecList.add(mockResponseRec1);
        
        Mock_Response_Details__c mockResponseRec2=new Mock_Response_Details__c();
        mockResponseRec2.Status_Code__c='400';
        mockResponseRec2.FileName__c='u_cos_clmltr_mem_doc';
        mockResponseRec2.SearchParameter__c='u_cos_clmltr_mem_doc';
        mockResponseRec2.WebserviceConfigurations__c = webConRelatedDocuments.id;
        mockResponseRecList.add(mockResponseRec2);
       // insert mockResponseRecList;
        
        Mock_Response_Details__c mockResponseImages=new Mock_Response_Details__c();
        mockResponseImages.Status_Code__c='200';
        mockResponseImages.FileName__c='u_keyed_claim_7863109999';
        mockResponseImages.SearchParameter__c='u_keyed_claim';
        mockResponseImages.WebserviceConfigurations__c = webConRelatedDocuments.id;
        mockResponseRecList.add(mockResponseImages);
        
        Mock_Response_Details__c mockResponseAttach=new Mock_Response_Details__c();
        mockResponseAttach.Status_Code__c='200';
        mockResponseAttach.FileName__c='u_prov_attch_7863109999';
        mockResponseAttach.SearchParameter__c='u_prov_attch_';
        mockResponseAttach.WebserviceConfigurations__c = webConRelatedDocuments.id;
        mockResponseRecList.add(mockResponseAttach);

        Mock_Response_Details__c mockResponseLetter=new Mock_Response_Details__c();
        mockResponseLetter.Status_Code__c='200';
        mockResponseLetter.FileName__c='u_mli_elgs';
        mockResponseLetter.SearchParameter__c='u_mli_elgs';
        mockResponseLetter.WebserviceConfigurations__c = webConRelatedDocuments.id;
        mockResponseRecList.add(mockResponseLetter);
        
        Mock_Response_Details__c mockResponseMemEOB=new Mock_Response_Details__c();
        mockResponseMemEOB.Status_Code__c='200';
        mockResponseMemEOB.FileName__c='u_mber_eob';
        mockResponseMemEOB.SearchParameter__c='u_mber_eob';
        mockResponseMemEOB.WebserviceConfigurations__c = webConRelatedDocuments.id;
        mockResponseRecList.add(mockResponseMemEOB);
        
        Mock_Response_Details__c mockResponseMemEOB1=new Mock_Response_Details__c();
        mockResponseMemEOB1.Status_Code__c='200';
        mockResponseMemEOB1.FileName__c='u_prov_attch_7840302400';
        mockResponseMemEOB1.SearchParameter__c='u_eps_prov_eob';
        mockResponseMemEOB1.WebserviceConfigurations__c = webConRelatedDocuments.id;
        mockResponseRecList.add(mockResponseMemEOB1);
        insert mockResponseRecList;
        
        OrgSpecificConfigurations__c orgConfig = new OrgSpecificConfigurations__c();
        orgConfig.Name = 'slayerdev';
        orgConfig.WebserviceConfigurations__c = webConRelatedDocuments.id;
        orgConfig.EnableMock__c = true;
        orgConfig.EndpointDomain__c='https://gateway-stage.optum.com/api/ecs/doc360/document-results/v1/search';
        orgConfig.RecordTypeText__c  = 'ServiceAPI'; 
        insert orgConfig;
        
        //Abhishek
        OrgSpecificConfigurations__c orgConfig2 = new OrgSpecificConfigurations__c();
        orgConfig2.Name = 'slayerdev';
        orgConfig2.WebserviceConfigurations__c = wcList[1].id;
        orgConfig2.EnableMock__c = true;
        orgConfig2.EndpointDomain__c='https://gateway-stage.optum.com/api/ecs/doc360/document-results/v1/search';
        orgConfig2.Static_Data__c = '{"user":"acet_doc360","appId":"dcf8d285-11b8-406e-b60c-f2a68fa5f979"}';
        orgConfig2.RecordTypeText__c  = 'ServiceAPI';
        insert orgConfig2;
        
        
        
        WebserviceConfigurations__c  webConRelatedDocumentsMock = new WebserviceConfigurations__c ();
        webConRelatedDocumentsMock.GrantType__c  = 'client_credentials';
        webConRelatedDocumentsMock.Headers__c  = '[{"key":"Authorization","value":"Bearer <:AUTH_TOKEN:>"},{"key":"Content-Type","value":"application/json"},{"key":"actor","value":"ACET"}]';
        webConRelatedDocumentsMock.AuthorizationToken__c  = 'SELECT AuthorizationToken__c FROM WebserviceConfigurations__c WHERE Name = LinkServiceTokenAPIToken';
        webConRelatedDocumentsMock.Method__c  = 'POST';
        //webConRelatedDocuments.TokenAPI__c  = webConifTokenApi.id;
        webConRelatedDocumentsMock.Name  = 'LinkRelatedDocumentsMock';
        webConRelatedDocumentsMock.Timeout__c = 10000;
       // RecordType recTypeWebExtendedServiceAPIMock = [SELECT Id FROM RecordType WHERE DeveloperName = 'Service_API' and SObjectType = 'WebserviceConfigurations__c'];
        webConRelatedDocumentsMock.RecordTypeId  = recTypeWebExtendedServiceAPI.id;
        webConRelatedDocumentsMock.RecordTypeText__c  = 'Service_API'; 
        insert webConRelatedDocumentsMock;
        
        OrgSpecificConfigurations__c orgConfigMock = new OrgSpecificConfigurations__c();
        orgConfigMock.Name = 'slayerdev';
        orgConfigMock.WebserviceConfigurations__c = webConRelatedDocumentsMock.id;
        orgConfigMock.EnableMock__c = false;
        orgConfigMock.EndpointDomain__c='https://gateway-stage.optum.com/api/ecs/doc360/document-results/v1/search';
        orgConfigMock.RecordTypeText__c  = 'ServiceAPI'; 
        insert orgConfigMock;
        
        
    }   
    
    
    public static testmethod void testStartRequest() {
        ACET_CountinousCallout ac = new ACET_CountinousCallout();
        object inputParams = JSON.deserializeUntyped('{}');
        string serviceCalloutInput = '[{'
            +'"serviceName": "LinkRelatedDocuments",'
            +'"docClass": "u_cosmos_pra",'
            +'"inputParam": "'+inputParams+'",'
            +'"createJSONBody": true,'
            +'"outputFormat": "Claim Documents"'
            +'},{'
            +'"serviceName": "LinkRelatedDocuments",'
            +'"docClass": "u_cosmos_pra_ub",'
            +'"inputParam": "'+inputParams+'",'
            +'"createJSONBody": true,'
            +'"outputFormat": "Claim Documents"'
            +'}]';
        
        Object response=ACET_CountinousCallout.startRequest(serviceCalloutInput);
        System.assertNotEquals(response, null);
    }
   
   
     
    @isTest
    public static void testClaimImages() {
        ACET_CountinousCallout ac = new ACET_CountinousCallout();
        object inputParams = JSON.deserializeUntyped('{}');
        string serviceCalloutInput = '[{'
            +'"serviceName": "LinkRelatedDocuments",'
            +'"docClass": "u_keyed_claim",'
            +'"inputParam": "'+inputParams+'",'
            +'"createJSONBody": true,'
            +'"outputFormat": "Claim Documents"'
            +'}]';

        Object response=ACET_CountinousCallout.startRequest(serviceCalloutInput);
        System.assertNotEquals(response, null);
    }
    @isTest
    public static void testException() {
        ACET_CountinousCallout ac = new ACET_CountinousCallout();
        object inputParams = JSON.deserializeUntyped('{}');
        string serviceCalloutInput = '[{'
            +'"serviceName": "LinkRelatedDocuments",'
            +'"docClass": "u_cos_clmltr_mem_doc",'
            +'"inputParam": "'+inputParams+'",'
            +'"createJSONBody": true,'
            +'"outputFormat": "Claim Documents",'
            +'"docName":"Claim Documents"'
            +'}]';
        
        Object response=ACET_CountinousCallout.startRequest(serviceCalloutInput);
        System.assertNotEquals(response, null);
    }
    
     @isTest
    public static void testEmpty() {
        ACET_CountinousCallout ac = new ACET_CountinousCallout();
        object inputParams = JSON.deserializeUntyped('{}');
        string serviceCalloutInput = '[{'
            +'"serviceName": "LinkRelatedDocuments",'
            +'"docClass": "u_eps_prov_eob",'
            +'"inputParam": "'+inputParams+'",'
            +'"createJSONBody": true,'
            +'"outputFormat": "Claim Documents"'
            +'}]';
        
        Object response=ACET_CountinousCallout.startRequest(serviceCalloutInput);
        System.assertNotEquals(response, null);
    }
    
    @isTest
    public static void testClaimLetter() {
        ACET_CountinousCallout ac = new ACET_CountinousCallout();
        object inputParams = JSON.deserializeUntyped('{}');
        string serviceCalloutInput = '[{'
            +'"serviceName": "LinkRelatedDocuments",'
            +'"docClass": "u_mli_elgs",'
            +'"inputParam": "'+inputParams+'",'
            +'"createJSONBody": true,'
            +'"outputFormat": "Claim Documents"'
            +'}]';
        
        Object response=ACET_CountinousCallout.startRequest(serviceCalloutInput);
        System.assertNotEquals(response, null);
    } 
    
     @isTest
    public static void testgetMemberEOBInfo() {
        ACET_CountinousCallout ac = new ACET_CountinousCallout();
        object inputParams = JSON.deserializeUntyped('{}');
        string serviceCalloutInput = '[{'
            +'"serviceName": "LinkRelatedDocuments",'
            +'"docClass": "u_mber_eob",'
            +'"inputParam": "'+inputParams+'",'
            +'"createJSONBody": true,'
            +'"outputFormat": "Claim Documents"'
            +'}]';

        Object response=ACET_CountinousCallout.startRequest(serviceCalloutInput);
        System.assertNotEquals(response, null);
    }

     @isTest
    public static void testgetAttachmentInfo() {
        ACET_CountinousCallout ac = new ACET_CountinousCallout();
        object inputParams = JSON.deserializeUntyped('{}');
        string serviceCalloutInput = '[{'
            +'"serviceName": "LinkRelatedDocuments",'
            +'"docClass": "u_prov_attch",'
            +'"inputParam": "'+inputParams+'",'
            +'"createJSONBody": true,'
            +'"outputFormat": "Claim Documents"'
            +'}]';

        Object response=ACET_CountinousCallout.startRequest(serviceCalloutInput);
        System.assertNotEquals(response, null);
    }

    @isTest
    public static void testgetClaimNotOnFileDoc() {
        ACET_CountinousCallout ac = new ACET_CountinousCallout();
        object inputParams = JSON.deserializeUntyped('{}');
        string serviceCalloutInput = '[{'
            +'"serviceName": "LinkRelatedDocuments",'
            +'"docClass": "u_prov_attch",'
            +'"inputParam": "'+inputParams+'",'
            +'"createJSONBody": true,'
            +'"outputFormat": "Claim Documents"'
            +'}]';

        Object response=ACET_CountinousCallout.getClaimNotOnFileDoc(serviceCalloutInput,true);
        System.assertNotEquals(response, null);
    }

    @isTest
    public static void MockCallout(){
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new SAEHttpCalloutMock.ACETContinuation());
        ACET_CountinousCallout ac = new ACET_CountinousCallout();
        object inputParams = JSON.deserializeUntyped('{}');
        string serviceCalloutInput = '[{'
            +'"serviceName": "LinkRelatedDocumentsMock",'
            +'"docClass": "u_edi_claim",'
            +'"inputParam": "'+inputParams+'",'
            +'"createJSONBody": true,'
            +'"outputFormat": "Claim Documents"'
            +'}]';
        
        Object response=ACET_CountinousCallout.startRequest(serviceCalloutInput);
        //System.assertNotEquals(response, null);
        Test.stopTest();
    }
    @isTest
    public static void getClaimRelatedDocumentWSTest(){
        Test.startTest();
        ACET_ClaimRelatedDocumentWS a = new ACET_ClaimRelatedDocumentWS();
        string docInput = '{"FirstDateofService":"2020-10-01T00:00:00.000Z","LastDateofService":"2020-10-01T00:00:00.000Z","MemberID":"929394959","TIN":"061330992","ClaimNumber":"18A9027070123","FirstName":"JENNIFER","LastName":"PEREZ","receivedDate":"2020-01-23T00:00:00.000Z","selectedmemberInfoDetails":{"claimno":"18A9027070123","platform":"FACETS - CSP","policyNbr":"IAQHP","ptntDob":"03/26/1989","ptntFn":"JENNIFER","ptntLn":"PEREZ","receivedDate":"01/23/2020","sbmtMembrId":"--"},"policyNumber":"523119ONEX","platform":"FACETS - CSP","PatientFullName":"JENNIFER PEREZ","icn":"18A9027070123","dccflnNbr":""}';
        a.getClaimRelatedDocumentWS('u_mli_elgs',docInput);
        a.getClaimRelatedDocumentWS('u_cos_clmltr_mem_doc',docInput);
        Test.stopTest();
    } 
   @isTest
    public static void generateDoc360URLTest(){
        Test.startTest();
        string docInput = '{"DocID":"00c7166f-f079-4cca-909f-661c4fd3d4b2|u_prov_attch_2020-12_v1","feildMap":{"docClass":"u_prov_attch","u_lst_dos_dt":"2020-03-11T00:00:00.000Z","u_fst_dos_dt":"2020-03-11T00:00:00.000Z","u_clm_nbr":"CD42253657","u_tin":"411801204","u_tkt_nbr":"PIQ-2821859"},"PageCount":"4","ReceivedDate":"12/03/2020","Type":"Electronically Only-Medical Record Attachment"}';
        ACET_CountinousCallout a = new ACET_CountinousCallout();
        ACET_CountinousCallout.generateDoc360URL(docInput);
        ACET_webServiceUtils.generateDoc360URL(docInput);
        Test.stopTest();
    } 
}