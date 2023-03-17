public class ACET_TimelyFillingWS {
    public ACETWSCalloutResult getClaimWS(string controctorID){
        System.debug('The claim input coming is: '+ controctorID);
        String responseStr = '';
        ACETWSCalloutResult calloutResult = new ACETWSCalloutResult();
        SAETimelyFillingResult returnData = new SAETimelyFillingResult();
        List<ACET_TimelyFillingJSON2Apex.employerandindividualContractDetail> ResponseArray = new List<ACET_TimelyFillingJSON2Apex.employerandindividualContractDetail>();
        try{
            
            Map<String, String> reqPramsMap = new Map<String, String>();
            ACET_WebserviceCalloutFramework wsCallOut = new ACET_WebserviceCalloutFramework();
            wsCallOut.serviceName = 'LinkTimelyFiling';
            reqPramsMap.put('app-nm','acet');
            reqPramsMap.put('attribute-set','unetContractDetailSearch');
            reqPramsMap.put('unet-contract-id',controctorID );
            wsCallOut.requestParamsMap = reqPramsMap;
            System.debug('calling new framework');
            HttpResponse response = wscallout.getResponse();
            
            
            responseStr = response.getBody();
            system.debug('ResponseBody** ' + responseStr);
            if(response.getStatusCode() == 200){
            	if(responseStr != null && String.isNotBlank(responseStr)){
                calloutResult.statusCode= response.getStatusCode();
                ACET_TimelyFillingJSON2Apex json2Apex = ACET_TimelyFillingJSON2Apex.parse(responseStr);
                if(json2Apex != null){
                    if(json2Apex.employerandindividualContractDetail != null){
                        ResponseArray = json2Apex.employerandindividualContractDetail;
                        system.debug('Response'+ResponseArray);
                        for(ACET_TimelyFillingJSON2Apex.employerandindividualContractDetail details : ResponseArray){
                            returnData.Provider_TF = String.isNotBlank(details.pnc_tmly_fl_day_nbr)?details.pnc_tmly_fl_day_nbr:'--';
                            returnData.tax_id_nbr = String.isNotBlank(details.tax_id_nbr)?details.tax_id_nbr:'--';
                            returnData.prov_id = String.isNotBlank(details.prov_id)?details.prov_id:'--';
                        }
                        
                    }
                }
                calloutResult.Success = true;
                calloutResult.Message = '';
                calloutResult.Response = returnData; 
                system.debug('calloutResult.Response = returnData'+returnData);
            }
            }else{
                calloutResult.MessageSeverity = ApexPages.Severity.INFO;
                calloutResult.Success = false;
                calloutResult.statusCode = response.getStatusCode();
                calloutResult.Message = response.getBody();
                calloutResult.Response = getErrorResponse(response.getStatusCode(),response.getBody());
            }
        }Catch(Exception e){
            system.debug(e.getStackTraceString());
            calloutResult.MessageSeverity = ApexPages.Severity.ERROR;
            calloutResult.Success = false;
            calloutResult.Message = 'Web Service or External System is temporarily unavailable.';
            calloutResult.statusCode=999;
        }
        return calloutResult;
    }
    
    public ACETWSCalloutResult getContracorid(String taxId,String providerId,String marketType,String marketSite,String productCode){
        ACETWSCalloutResult calloutResult = new ACETWSCalloutResult();
        String responseStr = '';
        String finalreturnData = '';
        ContractorDetailsResult returnData = new ContractorDetailsResult();
        List<string> getFirstConID = new List<string>();
        List<ACET_TimelyFilling_Contractor_JSON2Apex.Employerandindividual> ResponseArray = new List<ACET_TimelyFilling_Contractor_JSON2Apex.Employerandindividual>();
        try{
            Map<String, String> reqPramsMap = new Map<String, String>();
            ACET_WebserviceCalloutFramework wsCallOut = new ACET_WebserviceCalloutFramework();
            wsCallOut.serviceName = 'LinkContractorID';
            reqPramsMap.put('prov-id',providerId);
            reqPramsMap.put('app-nm','acet');
            reqPramsMap.put('tax_id_nbr',taxId);
            reqPramsMap.put('mkt-typ-cd',marketType);
            reqPramsMap.put('mkt-nbr',marketSite);
            reqPramsMap.put('prdct-ofr-cd',productCode);
            
            wsCallOut.requestParamsMap = reqPramsMap;
            System.debug('calling new framework');
            HttpResponse response = wscallout.getResponse();
            
            
            responseStr = response.getBody();
            system.debug('ResponseBody** Contractor' + responseStr);
            if(response.getStatusCode() == 200) {
            	if(responseStr != null && String.isNotBlank(responseStr)){
                calloutResult.statusCode= response.getStatusCode();
                ACET_TimelyFilling_Contractor_JSON2Apex json2Apex = ACET_TimelyFilling_Contractor_JSON2Apex.parse(responseStr);
                if(json2Apex != null){
                    system.debug('json2Apex'+json2Apex);
                    if(json2Apex.Employerandindividual != null){
                        ResponseArray = json2Apex.Employerandindividual;
                        system.debug('Response123'+ResponseArray);
                        for(ACET_TimelyFilling_Contractor_JSON2Apex.Employerandindividual details : ResponseArray){
                            returnData.Contractorid = String.isNotBlank(details.pnc_contr_id)?details.pnc_contr_id:' ';
                            returnData.taxid = String.isNotBlank(details.tax_id_nbr)?details.tax_id_nbr:' ';
                            getFirstConID.add(returnData.Contractorid);
                        }
                        
                    }
                }
                finalreturnData = getFirstConID[0];
                calloutResult.Success = true;
                calloutResult.Message = '';
                calloutResult.Response = finalreturnData; 
                system.debug('calloutResult.Response = returnData'+returnData);
                system.debug('calloutResult.Response = getFirstConID'+finalreturnData);
            }
            }else{
                calloutResult.MessageSeverity = ApexPages.Severity.INFO;
                calloutResult.Success = false;
                calloutResult.statusCode = response.getStatusCode();
                calloutResult.Message = response.getBody();
                calloutResult.Response = getErrorResponse(response.getStatusCode(),response.getBody());
            }
        }Catch(Exception e){
            system.debug(e.getStackTraceString());
            calloutResult.MessageSeverity = ApexPages.Severity.ERROR;
            calloutResult.Success = false;
            calloutResult.Message = 'Web Service or External System is temporarily unavailable.';
            calloutResult.statusCode=999;
        }
        return calloutResult;
    }
    
    public class SAETimelyFillingResult{
        @AuraEnabled public String Provider_TF {get;set;}
        @AuraEnabled public String tax_id_nbr {get;set;}
        @AuraEnabled public String prov_id {get;set;}
    }
    
    public class ContractorDetailsResult{
        @AuraEnabled public String Contractorid {get;set;}
        @AuraEnabled public String taxid {get;set;}
    }

      //sravani start--> Eror code handling
    public static ACETWSCalloutResult getErrorResponse(Integer statusCode, String responseBody) {
        ACETWSCalloutResult calloutResult = new ACETWSCalloutResult();
        calloutResult.Success = false;
        calloutResult.message = '';
        calloutResult.statusCode = statusCode;
       // calloutResult.message = 'Unexpected error occurred. Please try again. If problem persists contact help desk.';

        Map < String, Object > httpResponseJSON = (Map < String, Object > ) JSON.deserializeUntyped(responseBody);
        String faultCode = (String) httpResponseJSON.get('faultCode');
        if (statusCode == 400) {
            calloutResult.message = 'Unexpected error occurred. Please try again. If problem persists contact help desk.';
        } else if (statusCode == 401) {
            calloutResult.message = 'Unexpected error occurred. Please try again. If problem persists contact help desk.';
        } else if (statusCode == 404) {
            calloutResult.message = 'No Results Found';
        } else if (statusCode == 500) {
            if (faultCode.containsIgnoreCase('LCLM_S_302')) {
                calloutResult.message = getErrorMessage(faultCode);
            }
        } else if (statusCode == 503) {
                calloutResult.message = 'Unexpected error occurred. Please try again. If problem persists contact help desk.';
        }
        else {
            calloutResult.message = getErrorMessage(SAEConstants.GN500A) + '(' + faultCode + ')';
            calloutResult.statusCode = 999;
        }
        return calloutResult;
    }
    // Get Error messages from metadata records
    public static String getErrorMessage(String errorCode) {
        String errorMessage = '';
        AcetErrorMessage__mdt[] errorCodes = [SELECT DeveloperName, Label, Error_Message__c, Message_Type__c FROM AcetErrorMessage__mdt WHERE DeveloperName =: errorCode];
        if (errorCodes.size() > 0) {
            errorMessage = errorCodes[0].Error_Message__c;
        }
        return errorMessage;
    }
}