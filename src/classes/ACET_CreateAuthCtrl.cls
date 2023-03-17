public with sharing class ACET_CreateAuthCtrl {
    
    @AuraEnabled
    public static ACET_CreateAuthCtrl.ACET_SRNResponseWrap createSRN(String authData){

        ACETWSCalloutResult calloutResult = new ACETWSCalloutResult();
        ACET_CreateAuthWS wbService = new ACET_CreateAuthWS();
        ACET_CreateAuthCtrl.ACET_SRNResponseWrap returnResponse = new ACET_CreateAuthCtrl.ACET_SRNResponseWrap();
        calloutResult = wbService.createAuth(authData);
        if (calloutResult.Success != null && calloutResult.Success){
            returnResponse = (ACET_CreateAuthCtrl.ACET_SRNResponseWrap)calloutResult.Response;
        }
        return returnResponse;
    }

    // US3587913	Create Auth : Call new API for Case Provider Search - Member Mappings
    // New method for the newly created web service class.
    @AuraEnabled
    public static ACET_CreateAuthCtrl.ACET_SRNResponseWrap createAuthorization(String authData, ACET_CreateAuthorizationRequest.CaseDetails caseDetails){

        ACETWSCalloutResult calloutResult = new ACETWSCalloutResult();
        ACET_CreateAuthorizationWebService wbService = new ACET_CreateAuthorizationWebService();
        ACET_CreateAuthCtrl.ACET_SRNResponseWrap returnResponse = new ACET_CreateAuthCtrl.ACET_SRNResponseWrap();
        calloutResult = wbService.createAuth(authData, caseDetails);
        if (calloutResult.Success != null && calloutResult.Success){
            returnResponse = (ACET_CreateAuthCtrl.ACET_SRNResponseWrap)calloutResult.Response;
        }
        return returnResponse;
    }

    // US3587915	Create Auth : Call new API for Case Provider Search Provider  Mappings - Sarma- 03rd June 2021
    @AuraEnabled
    public static ACET_CaseProviderSearchResponseWrapper callCaseProviderSearch(List<ACET_CaseProvidersReq.HscProvider> providerDetails , ACET_CaseProvidersReq.Member memberDetails){
        ACET_CaseProviderSearchResponseWrapper responseWrapper = new ACET_CaseProviderSearchResponseWrapper();
        ACETWSCalloutResult calloutResult = new ACETWSCalloutResult();
        calloutResult = ACET_CaseProvidersWS.getProvidersData(providerDetails,memberDetails);
        responseWrapper.statusCode = calloutResult.statusCode;
        responseWrapper.response = (ACET_CreateAuthorizationRequest)calloutResult.Response;
        responseWrapper.success = calloutResult.success;
        return responseWrapper;
    }


    public class InvocationContext
    {
        @Auraenabled Public String clientID {set;get;}
        @Auraenabled Public String locationID {set;get;}
        @Auraenabled Public String userID {set;get;}
        @Auraenabled Public String userIDType {set;get;}
        @Auraenabled Public String clientCorrelationID {set;get;}
        @Auraenabled Public String serviceCorrelationID {set;get;}
    }
    public class MetadataValue
    {
        @Auraenabled Public String clientGroup {set;get;}
        @Auraenabled Public String clientBusiness {set;get;}
        @Auraenabled Public String clientLocation {set;get;}
        @Auraenabled Public String clientNPI {set;get;}
        @Auraenabled Public String caseSubmissionTransactionID {set;get;}
    }
    public class ACET_SRNResponseWrap
    {
        
        @Auraenabled Public InvocationContext invocationContext {set;get;}
        @Auraenabled Public MetadataValue metadata {set;get;}
        @Auraenabled Public String responseCode {set;get;}
        @Auraenabled Public String primaryServiceReferenceNum {set;get;}
        @Auraenabled Public List<String> disclaimerText {set;get;}
        @Auraenabled public String returnDecisionValueType {set;get;}
        @Auraenabled public String redirectUrl {set;get;}
        @Auraenabled public String responseType {set;get;}//this value contain 'TTAP' or 'Case Submit' or 'Validation Errors' or 'validationAPI' // US3068301
    }


    public class ACET_CaseProviderSearchResponseWrapper{
        @Auraenabled Public Integer statusCode {set;get;}
        @Auraenabled Public Boolean success {set;get;}
        @Auraenabled Public ACET_CreateAuthorizationRequest response {set;get;}
    }

}