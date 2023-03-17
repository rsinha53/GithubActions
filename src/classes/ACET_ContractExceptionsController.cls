public class ACET_ContractExceptionsController {
    static string COMMON_ERROR_MESSAGE='Unexpected Error Occurred with Contract Exceptions. Please try again. If problem persists please contact the help desk.';
    public class ContractExceptionsWrapper{
        @AuraEnabled public String medicalNecessityIndicator;
        @auraEnabled public boolean success;
        @auraEnabled public string message;
        @auraEnabled public ApexPages.Severity severity;
        @auraEnabled public integer statusCode;
    }
    @AuraEnabled
    public static ContractExceptionsWrapper getContractExceptions(string providerId, string taxId, string contractId) {
        ACETWSCalloutResult calloutResult = new ACETWSCalloutResult();
        ContractExceptionsWrapper cew = new ContractExceptionsWrapper();
        String responseStr = '';
        string Indicator = '';
        try {
            Map<String, String> reqPramsMap = new Map<String, String>();
            reqPramsMap.put('app-nm', 'acet');
            reqPramsMap.put('prov-id', providerId);
            reqPramsMap.put('attribute-set', 'detail_0002');
            reqPramsMap.put('tax-id-nbr', taxId);
            reqPramsMap.put('contract-id', contractId);
            
            ACET_WebserviceCalloutFramework wsCallOut = new ACET_WebserviceCalloutFramework();
            wsCallOut.serviceName = 'LinkFacilityContractExceptions';
            wsCallOut.requestParamsMap = reqPramsMap;
            HttpResponse response = wscallout.getResponse();
            responseStr = response.getBody();
            system.debug('ResponseBody&&** ' + responseStr);
            if (response.getStatusCode() == 200) {
                if(responseStr != null && String.isNotBlank(responseStr)){
                    // parse response
                    ACET_ContractExceptions_Json2Apex contractResponse = ACET_ContractExceptions_Json2Apex.parse(responseStr);
                    if(contractResponse.FacilityDetail0002Response.size() > 0){
                         Indicator=  contractResponse.FacilityDetail0002Response[0].medNecData.medicalNecessityIndicator;
                    }
                    system.debug('contractResponse** ' +Indicator);
                    cew.medicalNecessityIndicator = Indicator != null && Indicator != '' ? Indicator : 'N' ;
                    cew.success = true;
                    cew.statusCode = response.getStatusCode();
                    cew.message = COMMON_ERROR_MESSAGE;
                    cew.severity = ApexPages.Severity.ERROR;
                }
            } else {
                // send error details when response fails
                cew.success = false;
                cew.statusCode = response.getStatusCode();
                cew.message = COMMON_ERROR_MESSAGE;
                cew.severity = ApexPages.Severity.ERROR;
            }
            return cew;
        }
        catch (Exception ex) {
            // send error details when there is an exception
            cew.success = false;
            cew.statusCode = 999;
            cew.message = COMMON_ERROR_MESSAGE;
            cew.severity = ApexPages.Severity.ERROR;
            return cew;
        }
    }
}