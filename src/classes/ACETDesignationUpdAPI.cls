/* Class Name:ACETDesignationUpdAPI
* Author:Chandan
* Created Date: 07/05/2020
* Description: API Class to Update Designation API for Elligibility Hub 
**/
//public with sharing class ACETDesignationUpdAPI extends ACETWebService {
public with sharing class ACETDesignationUpdAPI {
    //DesignationUpdateAPI -- Endpoint
    //SNIEligibilityAPI -- url
    public string GetRequestBody(String acetFamilyId,String adviserMsId,String advisorFullName,String designation)
    {
        string reqBody ;
        ACETDesignationUpdRequest aDesnAPI = new ACETDesignationUpdRequest();
        if(String.isNotBlank(acetFamilyId) && String.isNotBlank(designation))
            reqBody = aDesnAPI.addSearchInput(acetFamilyId,adviserMsId,advisorFullName,designation);
        return reqBody;
    }
    public ACETWSCalloutResult updateDetail(String acetFamilyId,String adviserMsId,String advisorFullName,String designation){ 
        ACETWSCalloutResult calloutResult = new ACETWSCalloutResult();
        try{
            String responseStr;
            ACET_WebserviceCalloutFramework wsCallOutFW = new ACET_WebserviceCalloutFramework();
            wsCallOutFW.serviceName = 'Designation UpdateAPI';
            wsCallOutFW.requestBody = GetRequestBody(acetFamilyId,adviserMsId,advisorFullName,designation); 
            HttpResponse httpRes  = wsCallOutFW.getResponse();
            responseStr = httpRes!=null?httpRes.getBody():'';
            if(responseStr!=null && String.isNotBlank(responseStr)){ //&& statusCode!=null && statusCode== 200
                ACETDesignationUpdResponse json2Apex = ACETDesignationUpdResponse.parse(responseStr);
                if(json2Apex.Status!=null && json2Apex.Status.messages!=null && json2Apex.Status.messages.size()>0 && json2Apex.Status.messages.get(0)!=null){
                    ACETDesignationUpdResponse.Messages mes= json2Apex.Status.messages.get(0);
                    calloutResult.statusCode =String.isNotBlank(mes.code)?Integer.valueOf(mes.code):null;
                    if(calloutResult.statusCode!=null && (calloutResult.statusCode ==200 || calloutResult.statusCode == 201)){
                        calloutResult.Success =true;
                        calloutResult.Message ='Update Successful';
                        calloutResult.MessageSeverity=ApexPages.Severity.Info;     
                    }
                    else{
                        calloutResult.MessageSeverity = ApexPages.Severity.ERROR;
                        calloutResult.Success = false;
                        if(calloutResult.statusCode!=null && calloutResult.statusCode ==400)
                            calloutResult.Message =ACETUtility.getErrorMessage('EHub500');//+mes.description 
                        else if(calloutResult.statusCode!=null && calloutResult.statusCode == 404)
                            calloutResult.Message = ACETUtility.getErrorMessage('EHub500');//+mes.description
                        else if(calloutResult.statusCode!=null && calloutResult.statusCode ==500)
                            calloutResult.Message =ACETUtility.getErrorMessage('EHub500');//+mes.description 
                        else if(calloutResult.statusCode!=null)
                            calloutResult.Message =ACETUtility.getErrorMessage('EHub500');//+mes.description; 
                        else{
                            calloutResult.Message =ACETUtility.getErrorMessage('EHub500');
                            calloutResult.statusCode = 999;
                        }
                    }
                }
            }
            else{
                calloutResult.MessageSeverity = ApexPages.Severity.ERROR;
                calloutResult.Success = false;
                calloutResult.Message = ACETUtility.getErrorMessage('EHub500');
                calloutResult.statusCode=999;
            }
        }catch(Exception e){
            calloutResult.MessageSeverity = ApexPages.Severity.ERROR;
            calloutResult.Success = false;
            calloutResult.Message = ACETUtility.getErrorMessage('GN999');
            calloutResult.statusCode=999;
        }
        return calloutResult;
    }
}