public class SAE_PoliciesCtrl {

    @AuraEnabled
    public static Map<String, Object> getMemberPolicyNetworkInfo(String transactionId){
        System.debug('transactionId::'+transactionId);
        Map<String, Object> response = new Map<String, Object>();
        Map < String, ACETOrgInstanceURLToOrgNameMap__c > OrgInstance2OrgNameMap = ACETOrgInstanceURLToOrgNameMap__c.getAll();
        String orgName = Test.isRunningTest() ? 'dev' : ACETUtility.GetOrgName(OrgInstance2OrgNameMap);
        Map < String, ISL_Webservice_Config__c > islWebserviceData = ISL_Webservice_Config__c.getAll();
        String endPoint = islWebserviceData.get(orgName + '_NetworkStatusServiceEndPoint') != null ?islWebserviceData.get(orgName + '_NetworkStatusServiceEndPoint').Value__c:'';
        String requestParameters = '?transactionId=' + transactionId;
        HttpResponse httpResponse = SAEWebservice.makeCallout(requestParameters, endPoint, 'GET');
        String responseBody = httpResponse.getBody();
        Integer statusCode = httpResponse.getStatusCode();
        response.put('statusCode', statusCode);

        if(statusCode == 200) {
            ACET_NetworkStatusResult networkAttributes = ACET_NetworkStatusResult.parse(responseBody);
            response.put('success', true);
            response.put('statusCode',statusCode); //US3076045 - Avish
            if (networkAttributes.attributes.networkStatus != null && networkAttributes.attributes.networkStatus.containsignorecase('Tier 1')) {
                //response.put('networkStatus', 'In-Network');
                response.put('networkStatus', 'Tier 1');
            } else if (networkAttributes.attributes.networkStatus != null && networkAttributes.attributes.networkStatus.containsignorecase('In-Network')) {
                response.put('networkStatus', 'In-Network');
            }else if (networkAttributes.attributes.networkStatus != null && networkAttributes.attributes.networkStatus.containsignorecase('Out-of-Network')) {
                response.put('networkStatus', 'Out-of-Network');
            } else {
                response.put('networkStatus', networkAttributes.attributes.networkStatus);
            }
            response.put('success', true);
        } else if(statusCode == 400) {
            response.put('',httpResponse.getStatus());
        } else if(statusCode == 500) {
            response.put('',httpResponse.getStatus());
        } else if(statusCode == 404) {
            response.put('',httpResponse.getStatus());
        } else {
            response.put('success', false);
            response.put('',httpResponse.getStatus());
        }
        return response;
    }

    @AuraEnabled
    public static Map<String, Object> getMemberPolicyNetworkInfo(String transactionId, String transID){
        System.debug('transactionIdnetworkstatus::'+transactionId);
        HttpResponse httpResponse = new HttpResponse();

        Boolean isStaticResponseChecked = false;
        isStaticResponseChecked = SAEUtils.getMockStatus();
        /*** US3076045 - Avish **/
        Map < String, String > requestParamsMap = new Map < String, String > ();
        requestParamsMap.put('transactionId', String.isNotBlank(transactionId) ? transactionId : '');
        ACET_WebserviceCalloutFramework wsCallOutFW = new ACET_WebserviceCalloutFramework();
        wsCallOutFW.serviceName = 'LinkExtendedNetworkStatus';
        wsCallOutFW.requestParamsMap = requestParamsMap;
        wsCallOutFW.encodeURLParameters = true;
        httpResponse = wsCallOutFW.getResponse();
        //US3076045 - Ends

            string searchParm = transactionId.remove('-').remove('%').substring(0, 23);
        if(isStaticResponseChecked && !Test.isRunningTest() && string.isNotBlank(httpResponse.getbody()) ){
                Map<String, Object> networkMap = (Map<String, Object>)JSON.deserializeUntyped(httpResponse.getbody());
            if(networkMap.get(searchParm) != NULL) httpResponse.setBody(JSON.serialize(networkMap.get(searchParm)));
            else httpResponse.setStatusCode(999);
        }

        Map<String, Object> response = new Map<String, Object>();

        String responseBody = httpResponse.getBody();
        Integer statusCode = httpResponse.getStatusCode();

        if(statusCode == 200) {
            ACET_NetworkStatusResult networkAttributes = ACET_NetworkStatusResult.parse(responseBody);
            response.put('success', true);
            response.put('statusCode',statusCode); //US3076045 - Avish
            if (networkAttributes.attributes.networkStatus != null && networkAttributes.attributes.networkStatus.containsignorecase('Tier 1')) {
                response.put('networkStatus', 'Tier 1');
            } else if (networkAttributes.attributes.networkStatus != null && networkAttributes.attributes.networkStatus.containsignorecase('In-Network')) {
                response.put('networkStatus', 'In-Network');
            }else if (networkAttributes.attributes.networkStatus != null && networkAttributes.attributes.networkStatus.containsignorecase('Out-of-Network')) {
                response.put('networkStatus', 'Out-of-Network');
            } else {
                response.put('networkStatus', networkAttributes.attributes.networkStatus);
            }
            response.put('success', true);
        } else if(statusCode == 400) {
            response.put('',httpResponse.getStatus());
        } else if(statusCode == 500) {
            response.put('',httpResponse.getStatus());
        } else if(statusCode == 404) {
            response.put('',httpResponse.getStatus());
        } else {
            response.put('success', false);
            response.put('',httpResponse.getStatus());
        }
        return response;
    }

    @AuraEnabled
    public static List<UHG_Restricted_Plans__mdt> getOptumExlusions() {
        List<UHG_Restricted_Plans__mdt> mapOptumExlusions = new List<UHG_Restricted_Plans__mdt>();
        try {
            mapOptumExlusions = [SELECT DeveloperName,MasterLabel FROM UHG_Restricted_Plans__mdt];

        } catch(Exception e) {
            System.debug(LoggingLevel.ERROR,e.getMessage());
        }
        return mapOptumExlusions;
    }

    //US2644766 - PCP Indicator UI and  Implementation - Durga [08/06/2020]
    @AuraEnabled
    public static string getPCPURL(){
        string strRedirectURL = '';
        Map<String, ACETOrgNameToSwivelEndpointMap__c> WSConfigurations = ACETOrgNameToSwivelEndpointMap__c.getAll();
        if(WSConfigurations.get('PCPRedirectURL') != NULL){
            strRedirectURL = WSConfigurations.get('PCPRedirectURL').Swivel_Endpoint__c;
        }
        return strRedirectURL;
    }

    @AuraEnabled
    public static ExtendedResultWrapper getExtendedResult(String transactionId){

        ACETWSCalloutResult response = (new ACET_ExtendedServiceController().extendedServiceCallout(transactionId));
        ExtendedResultWrapper extWrap=new ExtendedResultWrapper();
        extWrap.extendedResultObject=  (ACET_ExtendedServiceController.ExtendedServiceWrapper)response.Response;
        extWrap.message=response.Message;
        extWrap.statusCode=response.statusCode;
        return extWrap;
    }
    public class ExtendedResultWrapper{
        @AuraEnabled public ACET_ExtendedServiceController.ExtendedServiceWrapper extendedResultObject {get;set;}
        @AuraEnabled public string message {get;set;}
        @AuraEnabled public integer statusCode {get;set;}
    }

    //US2973232 - This will be covered by ACET_BenefitTierServiceTest
    @AuraEnabled
    public static ACET_BenefitTierService.benefitTierResponseWrapper getTierStatus(String transactionId,string sourceCode){
        return ACET_BenefitTierService.getBenefitStatus(transactionId,sourceCode);
    }
    //US3221778 - This will be covered by ACET_ProviderStatusCtrlTest
    @AuraEnabled
    public static ProviderStatusWrapper getProviderCardStatus(String providerId, String taxId, String addressSeq, String marketType, String marketSite, String insTypeCode, string ipaValue){
        // US3299151 - Thanish - 16th Mar 2021
        ProviderStatusWrapper retWrapper = new ProviderStatusWrapper();
        System.debug('@@ SAE_PoliciesCtrl: getProviderCardStatus: ipaValue: ' + ipaValue);
        if(string.isNotBlank(ipaValue)){
            //ipaValue= ipaValue.remove('(').remove(')').remove(',');
            //List<string> lstOfstrings = ipaValue.split(' ');
            //ipaValue = lstOfstrings.get(lstOfstrings.indexof('IPA')+1);
            ipaValue = ACET_ProviderStatusCtrl.processIPAString(ipaValue);
            ACET_ProviderContractService providerContractService = new ACET_ProviderContractService();
            ACETWSCalloutResult calloutResult = providerContractService.getEAndIContracts(providerId, taxId, addressSeq, marketType, marketSite, insTypeCode, true);
            retWrapper.statusCode=calloutResult.statusCode;
            if(calloutResult.Success){
                ACET_EAndIContractsResponse contractResponse = (ACET_EAndIContractsResponse) calloutResult.Response;
                if(contractResponse.employerandindividual != null && !contractResponse.employerandindividual.isEmpty() && string.isNotBlank(ipaValue)){
                    List<ACET_EAndIContractsResponse.Employerandindividual> returnList = ACET_ProviderStatusCtrl.processIPAResults(contractResponse.employerandindividual,ipaValue);
                    if(!returnList.isEmpty()){
                        retWrapper.isFound=true;
                    }
                    }
                }
            }
        return retWrapper;
        }

    // US3299151 - Thanish - 16th Mar 2021
    public class ProviderStatusWrapper{
        @AuraEnabled public Boolean isFound;
        @AuraEnabled public Integer statusCode;

        public ProviderStatusWrapper(){
            isFound=false; statusCode=200;
        }
    }

    @AuraEnabled
    public static SAEPolicyDetailsController.RCEDResponseWrap call_RCED_API(String subscriberId, String policyNumber, String sourceCode){
       return SAEPolicyDetailsController.call_RCED(subscriberId,policyNumber,sourceCode);
    }
}