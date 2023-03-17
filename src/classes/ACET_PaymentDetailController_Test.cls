@isTest
public class ACET_PaymentDetailController_Test {
    @testSetup static void setupCS(){
        Organization_Properties__c orgProps = Organization_Properties__c.getOrgDefaults();
        orgProps.OrganizationName__c = 'slayerdev';
        Upsert orgProps;

        WebserviceConfigurations__c  webConRelatedDocuments = new WebserviceConfigurations__c ();
        webConRelatedDocuments.GrantType__c  = 'client_credentials';
        webConRelatedDocuments.Headers__c  = '[{"key":"Authorization","value":"Bearer <:AUTH_TOKEN:>"},{"key":"Content-Type","value":"application/json"},{"key":"actor","value":"ACET"}]';
        webConRelatedDocuments.Method__c  = 'GET';
        webConRelatedDocuments.Name  = 'LinkPaymentDetail';
        webConRelatedDocuments.Timeout__c = 10000;
        RecordType recTypeWebExtendedServiceAPI = [SELECT Id FROM RecordType WHERE DeveloperName = 'Service_API' and SObjectType = 'WebserviceConfigurations__c'];
        webConRelatedDocuments.RecordTypeId  = recTypeWebExtendedServiceAPI.id;
        insert webConRelatedDocuments;
        
        WebserviceConfigurations__c  webConDoc360 = new WebserviceConfigurations__c ();
        webConDoc360.GrantType__c  = 'client_credentials';
        webConDoc360.Headers__c  = '[{"key":"Authorization","value":"Bearer <:AUTH_TOKEN:>"},{"key":"Content-Type","value":"application/json"},{"key":"actor","value":"ACET"}]';
        webConDoc360.Method__c  = 'GET';
        webConDoc360.Name  = 'LinkClaimPaymentImage';
        webConDoc360.Timeout__c = 10000;
        webConDoc360.RecordTypeId  = recTypeWebExtendedServiceAPI.id;
        insert webConDoc360;

        WebserviceConfigurations__c  ws = new WebserviceConfigurations__c();
        ws.Name = 'DOC360GlobalURL';
        ws.GrantType__c  = 'client_credentials';
        ws.Headers__c  = '[{"key":"Authorization","value":"Bearer <:AUTH_TOKEN:>"},{"key":"Content-Type","value":"application/json"},{"key":"actor","value":"ACET"}]';
        ws.Method__c  = 'GET';
        ws.Timeout__c = 10000;
        ws.RecordTypeId  = recTypeWebExtendedServiceAPI.id;
        insert ws;

        List<Mock_Response_Details__c> mockResponseRecList = new List<Mock_Response_Details__c>();
        Mock_Response_Details__c mockResponseRec=new Mock_Response_Details__c();
        mockResponseRec.Status_Code__c='200';
        mockResponseRec.SearchParameter__c='claimPayment_966gg5cc-5d87-4635-8636-be1fb97e318e-1602184890468';
        mockResponseRec.FileName__c='claimPayment_7840302400';
        mockResponseRec.WebserviceConfigurations__c = webConRelatedDocuments.id;
        mockResponseRecList.add(mockResponseRec);

        Mock_Response_Details__c mockResponseRec1=new Mock_Response_Details__c();
        mockResponseRec1.Status_Code__c='999';
        mockResponseRec1.SearchParameter__c='claimPayment_ced04fy9-a363-4c89-85fd-c3b626ffa4fd-1602186803810';
        mockResponseRec1.FileName__c='claimPayment_7863109999';
        mockResponseRec1.WebserviceConfigurations__c = webConRelatedDocuments.id;
        mockResponseRecList.add(mockResponseRec1);

        Mock_Response_Details__c mockResponseRec2=new Mock_Response_Details__c();
        mockResponseRec2.Status_Code__c='200';
        mockResponseRec2.SearchParameter__c='claimPayment_ced04fy9-a363-4c89-85fd-c3b626ffa4fd-1602186803811';
        mockResponseRec2.FileName__c='claimPayment_7840302400';
        mockResponseRec2.WebserviceConfigurations__c = webConRelatedDocuments.id;
        mockResponseRecList.add(mockResponseRec2);
        
        Mock_Response_Details__c mockResponseRec3=new Mock_Response_Details__c();
        mockResponseRec3.Status_Code__c='200';
        mockResponseRec3.SearchParameter__c='LinkClaimPaymentImage';
        mockResponseRec3.FileName__c='LinkClaimPaymentImage';
        mockResponseRec3.WebserviceConfigurations__c = webConDoc360.id;
        mockResponseRecList.add(mockResponseRec3);

        insert mockResponseRecList;

        List<OrgSpecificConfigurations__c> orgConfigList = new List<OrgSpecificConfigurations__c>();
        OrgSpecificConfigurations__c orgConfig = new OrgSpecificConfigurations__c();
        orgConfig.Name = 'slayerdev';
        orgConfig.WebserviceConfigurations__c = webConRelatedDocuments.id;
        orgConfig.EnableMock__c = true;
        orgConfig.EndpointDomain__c='https://api-gateway-stage.linkhealth.com/clink-api/api/claim/summary/v1.0';
        orgConfig.RecordTypeText__c  = 'ServiceAPI'; 
        orgConfigList.add(orgConfig);
        
        OrgSpecificConfigurations__c orgConfig2 = new OrgSpecificConfigurations__c();
        orgConfig2.Name = 'slayerdev';
        orgConfig2.WebserviceConfigurations__c = webConDoc360.id;
        orgConfig2.EnableMock__c = true;
        orgConfig2.EndpointDomain__c='https://api-gateway-stage.linkhealth.com/clink-api/api/claim/summary/v1.0';
        orgConfig2.RecordTypeText__c  = 'ServiceAPI'; 
        orgConfigList.add(orgConfig2);

        OrgSpecificConfigurations__c orgConfig3 = new OrgSpecificConfigurations__c();
        orgConfig3.Name = 'slayerdev';
        orgConfig3.WebserviceConfigurations__c = ws.id;
        orgConfig3.EnableMock__c = true;
        orgConfig3.Static_Data__c='{"user":"acet_doc360","appId":"dcf8d285-11b8-406e-b60c-f2a68fa5f979"}';
        orgConfig3.EndpointDomain__c='https://api-gateway-stage.linkhealth.com/clink-api/api/claim/summary/v1.0';
        orgConfig3.RecordTypeText__c  = 'ServiceAPI'; 
        orgConfigList.add(orgConfig3);

        insert orgConfigList;

        // US3678785
        orgProps = Organization_Properties__c.getOrgDefaults();
        orgProps.OrganizationName__c = 'QA';
        UPSERT orgProps;

        RecordType recTypeTokenAPI = [SELECT Id FROM RecordType WHERE DeveloperName = 'Token_API' and SObjectType = 'WebserviceConfigurations__c'];

        WebserviceConfigurations__c  webConifTokenApi = new WebserviceConfigurations__c ();
        webConifTokenApi.EndpointPath__c = '/oauth/token';
        webConifTokenApi.GrantType__c  = 'client_credentials';
        webConifTokenApi.Headers__c  = '[{"key":"Authorization","value":"Bearer <:AUTH_TOKEN:>"},{"key":"Content-Type","value":"application/json"}]';
        webConifTokenApi.JSONBodyWithMergeFields__c  = '';
        webConifTokenApi.Method__c  = 'POST';
        webConifTokenApi.Name  = 'PaymentReadSearch';
        webConifTokenApi.RecordTypeId  = recTypeTokenAPI.Id;
        webConifTokenApi.RecordTypeText__c = 'Token_API';
        INSERT webConifTokenApi;

        webConifTokenApi = new WebserviceConfigurations__c ();
        webConifTokenApi.EndpointPath__c = '/oauth/token';
        webConifTokenApi.GrantType__c  = 'client_credentials';
        webConifTokenApi.Headers__c  = '[{"key":"Authorization","value":"Bearer <:AUTH_TOKEN:>"},{"key":"Content-Type","value":"application/json"}]';
        webConifTokenApi.JSONBodyWithMergeFields__c  = '';
        webConifTokenApi.Method__c  = 'POST';
        webConifTokenApi.Name  = 'PaymentCheckSearch';
        webConifTokenApi.RecordTypeText__c = 'Token_API';
        INSERT webConifTokenApi;

    }
    
    @isTest
    public static void getPaymentDetailsTest() {
        Test.startTest();
        ACET_PaymentDetailController a = new ACET_PaymentDetailController();
        String taxid = '741777515';
        String PayerID = '87726';
        string transactionID1 ='966gg5cc-5d87-4635-8636-be1fb97e318e-1602184890468';
        string transactionID2 = 'ced04fy9-a363-4c89-85fd-c3b626ffa4fd-1602186803810';
        string transactionID3 = 'ced04fy9-a363-4c89-85fd-c3b626ffa4fd-1602186803811';
        String PaymentNo1 = 'PR36747000';
        String PaymentNo2 = 'QW46747000';
        ACET_PaymentDetailController.paymentDetailCard result1 = ACET_PaymentDetailController.getPaymentDetails(taxid,PayerID,transactionID1,PaymentNo1);
        ACET_PaymentDetailController.paymentDetailCard result2 = ACET_PaymentDetailController.getPaymentDetails(taxid,PayerID,transactionID2,PaymentNo1);
        ACET_PaymentDetailController.paymentDetailCard result3 = ACET_PaymentDetailController.getPaymentDetails(taxid,PayerID,transactionID3,PaymentNo2);
        System.assertNotEquals(result1, null);
        System.assertNotEquals(result2, null);
        System.assertNotEquals(result3, null);
        Test.stopTest();
    }
    @isTest
    public static void getPaymentDetailsForPTITest() {
        Test.startTest();
        ACET_PaymentDetailController a = new ACET_PaymentDetailController();
        ACET_PaymentDetailController.PaymentInput PaymentInput=new ACET_PaymentDetailController.PaymentInput();
        PaymentInput.providerId='000006798';
        PaymentInput.transactionId='966gg5cc-5d87-4635-8636-be1fb97e318e-1602184890468';
        PaymentInput.PaymentNo='PR36747000';
        PaymentInput.isClaim=true;
        PaymentInput.adTaxId='061330992';
        PaymentInput.payerId='87726';
        ACET_PaymentDetailController.getPaymentDetailsForPTI(PaymentInput);
        Test.stopTest();
    }
    static testMethod void ACET_TimelyFillingJSON2ApexTest(){
        Test.startTest();
        List<ACET_PaymentDetailController_Json2Apex.payments> wrapper = new List<ACET_PaymentDetailController_Json2Apex.payments>();
        ACET_PaymentDetailController_Json2Apex.payments payments = new  ACET_PaymentDetailController_Json2Apex.payments();
        payments.paymentIssueDt='06/21/2019';
        payments.checkNbr='36747000';
        payments.checkAmt='177059.68';
        List<ACET_PaymentDetailController_Json2Apex.payments> paymentsResultList = new List<ACET_PaymentDetailController_Json2Apex.payments>();
        ACET_PaymentDetailController_Json2Apex.parse('{}');
        Test.stopTest();
    }
    
    static testMethod void getPaymentStatusImageTest(){
        try
        {
        Test.startTest();
        String URL='';
        ACET_PaymentDetailController.PaymentImageImputWrapper p = new ACET_PaymentDetailController.PaymentImageImputWrapper();
        p.checkStatus='Check Cashed';
        p.checkNbr='1234';
        p.checkEFTIndicator='p';
        p.paperCheck=true;
        p.memberId='123456';
        p.tin='12345';
        p.clNum='12345';
        URL=ACET_PaymentDetailController.getPaymentStatusImage(p);
        system.assertNotEquals('', URL);

        p.docClass='u_cosmos_pra_ub';
        p.paperCheck=false;
        URL=ACET_PaymentDetailController.getPaymentStatusImage(p);
        system.debug('URL@@'+URL);
        system.assertNotEquals(null, URL);

        p.docClass='u_unet_gflx_eob';
        URL=ACET_PaymentDetailController.getPaymentStatusImage(p);
        system.assertNotEquals(null, URL);
        Test.stopTest();
        }catch(exception e)
        {

        }
    }

    static testMethod void testSearchPayment(){

        Map<String, ACET_SAECalloutResult> returnData = new Map<String, ACET_SAECalloutResult>();
        ACET_ViewPaymentsRequest.PaymentDetailsParams requestObject = new ACET_ViewPaymentsRequest.PaymentDetailsParams();

        requestObject.seriesDesignator = 'PHS';
        requestObject.checkNumber = '258012123A';
        requestObject.remitNumber = '';
        requestObject.nextKey = '';
        returnData = ACET_PaymentDetailController.searchPayment(requestObject);
        System.assertNotEquals(null, returnData);

    }

}