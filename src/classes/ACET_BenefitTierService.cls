//US2973232
public class ACET_BenefitTierService {
    
    @AuraEnabled
    public static benefitTierResponseWrapper getBenefitStatus(string transactionId,string sourceCode){
        benefitTierResponseWrapper respWrapper = new benefitTierResponseWrapper();
        Boolean isStaticResponseChecked = false;
        isStaticResponseChecked = SAEUtils.getMockStatus();
        System.debug('@@ ACET_BenefitTierService: getBenefitStatus: isStaticResponseChecked: '+isStaticResponseChecked);
        ACET_SAECalloutResult benfitSummaryResult = getBenefitSummaryInfo(transactionId,isStaticResponseChecked);
        String finalBenefitId = '';
        boolean physicalFound= false;
        respWrapper.statusCode=benfitSummaryResult.statusCode;// US3299151 - Thanish - 16th Mar 2021
        if(benfitSummaryResult.statusCode == 200){
            ACET_BenefitSummaryResponse responseData = ACET_BenefitSummaryResponse.parse(JSON.serialize(benfitSummaryResult.Response));
            if(responseData != null && responseData.benefits != null && !responseData.benefits.isEmpty()){
                for(ACET_BenefitSummaryResponse.Benefits ben : responseData.benefits){
                    if(physicalFound) break;
                    if(ben.children != null && !ben.children.isEmpty()){
                        for(ACET_BenefitSummaryResponse.Children child : ben.children){
                            if(string.isNotBlank(child.categoryName)){
                                if(child.categoryName.containsignorecase('Physical Therapy')){
                                    finalBenefitId = child.benefitId;
                                    physicalFound = true;
                                    break;
                                }
                                else if(child.categoryName.containsignorecase('Chiropractic Services')){
                                    finalBenefitId = child.benefitId;
                                }
                            }
                        }
                    }
                }
            }
        }
        system.debug('@@ ACET_BenefitTierService: getBenefitStatus: finalBenefitId: '+finalBenefitId);
        if(string.isNotBlank(finalBenefitId)){
            respWrapper = processBenefitDetail(finalBenefitId,transactionId,isStaticResponseChecked,sourceCode);
        }
        System.debug('@@ ACET_BenefitTierService: getBenefitStatus: respWrapper: ' + respWrapper);
        return respWrapper;
    }
    
    public static benefitTierResponseWrapper processBenefitDetail(string finalBenefitId,string transactionId,boolean isStaticResponseChecked,string sourceCode){
        benefitTierResponseWrapper respWrapper = new benefitTierResponseWrapper();
        ACET_SAECalloutResult benfitDetailResult = getBenefitDetailInfo(transactionId,finalBenefitId,isStaticResponseChecked);
        respWrapper.statusCode=benfitDetailResult.statusCode;// US3299151 - Thanish - 16th Mar 2021
        if(benfitDetailResult.statusCode == 200){
            ACET_BenefitDetailSummaryResponse detailResponseData = ACET_BenefitDetailSummaryResponse.parse(JSON.serialize(benfitDetailResult.Response));
            if(detailResponseData != null && detailResponseData.benefit != null && !detailResponseData.benefit.isEmpty()){
                for(ACET_BenefitDetailSummaryResponse.Benefit bent : detailResponseData.benefit){
                    if(respWrapper.isTierOne) break;
                    if(bent.benefitNetworkSection != null && !bent.benefitNetworkSection.isEmpty()){
                        for(ACET_BenefitDetailSummaryResponse.BenefitNetworkSection net : bent.benefitNetworkSection){
                            if(net.networkStatus != null && !net.networkStatus.isEmpty()){
                                string networkStatusString = string.join(net.networkStatus,', ');
                                System.debug('@@ ACET_BenefitTierService: getBenefitStatus: networkStatusString: ' + networkStatusString);
                                if(string.isNotBlank(networkStatusString) && networkStatusString.containsignorecase('Tier 1')){
                                    if(sourceCode == 'CS' && networkStatusString.containsignorecase('IPA')){
                                    respWrapper.csBenefitSourceValue = networkStatusString ;
                                    }
                                    respWrapper.isTierOne = true;
                                    break;
                                }
                            }
                        }
                    }
                }
            }
        }
        System.debug('@@ ACET_BenefitTierService: processBenefitDetail: respWrapper: ' + respWrapper);
        return respWrapper;
    }
    
    public static ACET_SAECalloutResult getBenefitSummaryInfo(string transactionId, boolean isStaticResponseChecked){
        System.debug('@@ ACET_BenefitTierService: getBenefitSummaryInfo: transactionId: '+transactionId);
        ACET_SAECalloutResult calloutResult = new ACET_SAECalloutResult();
        try{
            String responseStr = '';
            HttpResponse benfitSummaryResponse = new HttpResponse();

            Map < String, String > requestParamsMap = new Map < String, String > ();
            requestParamsMap.put('transactionId', String.isNotBlank(transactionId) ? transactionId : '');
            requestParamsMap.put('isB360Call', 'true');
            requestParamsMap.put('isCSR', 'true');

            /*if(isStaticResponseChecked && !Test.isRunningTest()) {
                string searchparameter = 'BenefitSummary_'+ transactionId.remove('-').remove('%').substring(0, 23);
                system.debug('@@ searchparameter: '+searchparameter);
                benfitSummaryResponse = SAEUtils.getResponse(searchparameter);
            }
            else{
                Map < String, ACETOrgInstanceURLToOrgNameMap__c > OrgInstance2OrgNameMap = ACETOrgInstanceURLToOrgNameMap__c.getAll();
                String orgName = Test.isRunningTest() ? 'dev' : ACETUtility.GetOrgName(OrgInstance2OrgNameMap);
                Map < String, ISL_Webservice_Config__c > islWebserviceData = ISL_Webservice_Config__c.getAll();
                String endPoint = islWebserviceData.get(orgName + '_BenefitSummary').Value__c;
                string resultQuery = '?transactionId='+(string.isNotBlank(transactionId) ?  EncodingUtil.urlEncode(transactionId, 'UTF-8') : '') +'&isB360Call=true&isCSR=true';
                benfitSummaryResponse = SAEWebservice.makeCallout(resultQuery, endPoint, 'GET');
            }*/

            ACET_WebserviceCalloutFramework wsCallOutFW = new ACET_WebserviceCalloutFramework();
            wsCallOutFW.serviceName = 'LinkB360BenefitSummary';
            wsCallOutFW.requestParamsMap = requestParamsMap;
            wsCallOutFW.encodeURLParameters = true;
            benfitSummaryResponse = wsCallOutFW.getResponse();

            Integer benfitSummaryStatusCode = benfitSummaryResponse.getStatusCode();
            String strbenfitSumResponseBody = benfitSummaryResponse.getBody();
            if(benfitSummaryStatusCode == 200){ 
                if(string.isNotBlank(strbenfitSumResponseBody)){
                    ACET_BenefitSummaryResponse responseData = ACET_BenefitSummaryResponse.parse(strbenfitSumResponseBody);
                    calloutResult.isSuccess = true;
                    calloutResult.Message = 'Success';
                    calloutResult.statusCode = benfitSummaryStatusCode;
                    calloutResult.Response = responseData; 
                }
            }
            else{ 
                calloutResult.MessageSeverity = ApexPages.Severity.INFO;
                calloutResult.isSuccess = false; 
                calloutResult.statusCode = benfitSummaryStatusCode;
                calloutResult.Message = 'Web Service or External System is temporarily unavailable.';
            } 
        }
        catch(Exception e){
            system.debug(e.getStackTraceString());
            calloutResult.MessageSeverity = ApexPages.Severity.ERROR;
            calloutResult.isSuccess = false;
            calloutResult.Message = 'Web Service or External System is temporarily unavailable.';
            calloutResult.statusCode=999;
        }
        return calloutResult;
    }
    
    public static ACET_SAECalloutResult getBenefitDetailInfo(string transactionId, string benefitId, boolean isStaticResponseChecked){
        System.debug('@@ ACET_BenefitTierService: getBenefitDetailInfo: transactionId: '+transactionId);
        System.debug('@@ ACET_BenefitTierService: getBenefitDetailInfo: benefitId: '+benefitId);
        ACET_SAECalloutResult calloutResult = new ACET_SAECalloutResult();
        try{
            String responseStr = '';
            HttpResponse benfitDetailResponse = new HttpResponse();

            /*if(isStaticResponseChecked && !Test.isRunningTest()) {
                string searchparameter = 'BenefitDetail_'+ transactionId.remove('-').remove('%').substring(0, 23);
                system.debug('@@ searchparameter: '+searchparameter);
                benfitDetailResponse = SAEUtils.getResponse(searchparameter);
            }
            else{
                Map < String, ACETOrgInstanceURLToOrgNameMap__c > OrgInstance2OrgNameMap = ACETOrgInstanceURLToOrgNameMap__c.getAll();
                String orgName = Test.isRunningTest() ? 'dev' : ACETUtility.GetOrgName(OrgInstance2OrgNameMap);
                Map < String, ISL_Webservice_Config__c > islWebserviceData = ISL_Webservice_Config__c.getAll();
                String endPoint = islWebserviceData.get(orgName + '_BenefitDetail').Value__c;
                string resultQuery = '?transactionId='+(string.isNotBlank(transactionId) ?  EncodingUtil.urlEncode(transactionId, 'UTF-8') : '') +'&benefitCode='+(string.isNotBlank(benefitId) ? EncodingUtil.urlEncode(benefitId, 'UTF-8')  : '')+'&isB360Call=true&isCSR=true';
                benfitDetailResponse = SAEWebservice.makeCallout(resultQuery, endPoint, 'GET');
            }*/

            Map < String, String > requestParamsMap = new Map < String, String > ();
            requestParamsMap.put('transactionId', String.isNotBlank(transactionId) ? transactionId : '');
            requestParamsMap.put('isB360Call', 'true');
            requestParamsMap.put('benefitCode', benefitId);
            requestParamsMap.put('isCSR', 'true');

            ACET_WebserviceCalloutFramework wsCallOutFW = new ACET_WebserviceCalloutFramework();
            wsCallOutFW.serviceName = 'LinkB360BenefitDetail';
            wsCallOutFW.requestParamsMap = requestParamsMap;
            wsCallOutFW.encodeURLParameters = true;
            benfitDetailResponse = wsCallOutFW.getResponse();

            Integer benfitDetailStatusCode = benfitDetailResponse.getStatusCode();
            String strbenfitDetailResponseBody = benfitDetailResponse.getBody();
            if(benfitDetailStatusCode == 200){ 
                if(string.isNotBlank(strbenfitDetailResponseBody)){
                    ACET_BenefitDetailSummaryResponse responseData = ACET_BenefitDetailSummaryResponse.parse(strbenfitDetailResponseBody);
                    calloutResult.isSuccess = true;
                    calloutResult.Message = 'Success';
                    calloutResult.statusCode = benfitDetailStatusCode;
                    calloutResult.Response = responseData; 
                }
            }
            else{ 
                calloutResult.MessageSeverity = ApexPages.Severity.INFO;
                calloutResult.isSuccess = false; 
                calloutResult.statusCode = benfitDetailStatusCode;
                calloutResult.Message = 'Web Service or External System is temporarily unavailable.';
            } 
        }
        catch(Exception e){
            system.debug(e.getStackTraceString());
            calloutResult.MessageSeverity = ApexPages.Severity.ERROR;
            calloutResult.isSuccess = false;
            calloutResult.Message = 'Web Service or External System is temporarily unavailable.';
            calloutResult.statusCode=999;
        }
        return calloutResult;
    }

    public class benefitTierResponseWrapper{
        @AuraEnabled public Boolean isTierOne; {isTierOne = false;}
        @AuraEnabled public string csBenefitSourceValue; {csBenefitSourceValue='';}
        @AuraEnabled public Integer statusCode; // US3299151 - Thanish - 16th Mar 2021
    }
}