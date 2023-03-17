@isTest
public class ACET_ViewPaymentControllerTest {

    @testSetup
    static void setupData() {

        Organization_Properties__c orgProps = Organization_Properties__c.getOrgDefaults();
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
        webConifTokenApi.RecordTypeText__c  = 'Token_API';
        INSERT webConifTokenApi;

        webConifTokenApi = new WebserviceConfigurations__c ();
        webConifTokenApi.EndpointPath__c = '/oauth/token';
        webConifTokenApi.GrantType__c  = 'client_credentials';
        webConifTokenApi.Headers__c  = '[{"key":"Authorization","value":"Bearer <:AUTH_TOKEN:>"},{"key":"Content-Type","value":"application/json"}]';
        webConifTokenApi.JSONBodyWithMergeFields__c  = '';
        webConifTokenApi.Method__c  = 'POST';
        webConifTokenApi.Name  = 'PaymentCheckSearch';
        webConifTokenApi.RecordTypeText__c  = 'Token_API';
        INSERT webConifTokenApi;

    }

    static testMethod void testSearchPayment(){

        Map<String, ACET_SAECalloutResult> returnData = new Map<String, ACET_SAECalloutResult>();
        ACET_ViewPaymentsRequest.PaymentDetailsParams requestObject = new ACET_ViewPaymentsRequest.PaymentDetailsParams();
       
        requestObject.seriesDesignator = 'PHS';
        requestObject.checkNumber = '258012123A';
        requestObject.remitNumber = '';
        requestObject.nextKey = '';
        returnData = ACET_ViewPaymentController.searchPayment(requestObject);
        System.assertNotEquals(null, returnData);  

        requestObject.seriesDesignator = 'PHS';
        requestObject.checkNumber = '258014123V';
        requestObject.remitNumber = '';
        requestObject.nextKey = '';
        returnData = ACET_ViewPaymentController.searchPayment(requestObject);
        System.assertNotEquals(null, returnData); 

        requestObject.seriesDesignator = 'PHS';
        requestObject.checkNumber = '25801.4123';
        requestObject.remitNumber = '';
        requestObject.nextKey = '';
        returnData = ACET_ViewPaymentController.searchPayment(requestObject);
        System.assertNotEquals(null, returnData); 

        requestObject.seriesDesignator = 'PHS';
        requestObject.checkNumber = '258014';
        requestObject.remitNumber = '';
        requestObject.nextKey = '';
        returnData = ACET_ViewPaymentController.searchPayment(requestObject);
        System.assertNotEquals(null, returnData); 

        requestObject.seriesDesignator = 'PHS';
        requestObject.checkNumber = '';
        requestObject.remitNumber = '';
        requestObject.nextKey = '';
        returnData = ACET_ViewPaymentController.searchPayment(requestObject); 
        System.assertNotEquals(null, returnData); 

    }

    static testMethod void testGetCheckSearchData(){
        ACET_SAECalloutResult returnData = new ACET_SAECalloutResult(); 
        ACET_ViewPaymentsRequest.PaymentDetailsParams requestObject = new ACET_ViewPaymentsRequest.PaymentDetailsParams();
        requestObject.seriesDesignator = 'PHS';
        requestObject.checkNumber = '258012123A';
        requestObject.remitNumber = '';
        requestObject.nextKey = '';
        returnData = ACET_ViewPaymentsCheckSearchWS.getCheckSearchData(requestObject);
        System.assertNotEquals(null, returnData); 
    }

    static testMethod void testDTOData(){
    
        ACET_ViewPaymentController.PaymentWrapper PaymentWrapper = new ACET_ViewPaymentController.PaymentWrapper();
        PaymentWrapper.paymentType = 'TOPS';
        PaymentWrapper.platformType = 'VCP';
        System.assertNotEquals(null, PaymentWrapper); 

        ACET_ViewPaymentController.Meta meta = new ACET_ViewPaymentController.Meta();
        meta.sourceSystem = 'TOPS';
        meta.securityToken = 'TOPS';

        ACET_ViewPaymentController.PagingState pagingState = new ACET_ViewPaymentController.PagingState();
        pagingState.moreData = 'false';
        pagingState.nextKey = '0160';

        ACET_ViewPaymentController.Data data = new ACET_ViewPaymentController.Data();
        data.searchType = 'TOPS';
        data.seriesDesignator = 'TW';
        data.checkNumber = '1234567890';
        data.accountNumber = '';
        data.policyNumber = '';
        data.subscriberId = '';
        data.firstName = '';
        data.lastName = '';
        data.draftStatus = '';
        data.draftStatus = '';
        data.pagingState = pagingState;

        ACET_ViewPaymentController.RequestBody RequestBody = new ACET_ViewPaymentController.RequestBody();
        RequestBody.meta = meta;
        RequestBody.data = data; 
        System.assertNotEquals(null, RequestBody); 
    
    }
    static testMethod void testgetEpay(){
        ACET_ViewPaymentController.getAllSeriesDesignator();
    }

}