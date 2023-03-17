/* Class Name:ACETSNIEligibilityUpdAPI
 * Author:Ravi
 * Created Date: 13/05/2020
 * Description: API Class for Create/Update Elligibility Hub 
**/
public with sharing class ACETSNIEligibilityUpdAPI { 
 
    public String GetRequestBody(ACETSNIEligibilityUpdAPIRequest.Family fam,list<ACETSNIEligibilityUpdAPIRequest.member> mems)
    {
        ACETSNIEligibilityUpdAPIRequest obj = new ACETSNIEligibilityUpdAPIRequest();
        return obj.prepareRequestBody(fam,mems); 
        
    }
  
    //public ACETWSCalloutResult updateDetail(String acetFamilyId,String initialCallDate,String policyID,String memberID,String adviserMsId,String advisorFullName,String designation,String acetIndividualId,string firstName,string lastName, string dob,string newlyDiagnosed,string medicalCondition,string behavioralCondition,string relationship,string isPrimary){ 
    public ACETWSCalloutResult callEligibilityService(ACETSNIEligibilityUpdAPIRequest.Family fam,list<ACETSNIEligibilityUpdAPIRequest.member> mems){ 
        
        ACETWSCalloutResult calloutResult = new ACETWSCalloutResult();
        try{
             
             ACET_WebserviceCalloutFramework wsCallOutFW = new ACET_WebserviceCalloutFramework();
             wsCallOutFW.serviceName = 'EHub Update API';
             //wsCallOutFW.requestParamsMap = requestParamsMap;
             wsCallOutFW.requestBody = GetRequestBody(fam,mems); 
             wsCallOutFW.encodeURLParameters = true;
             HttpResponse httpRes  = wsCallOutFW.getResponse();
            
             String responseStr = httpRes!=null?httpRes.getBody():'';
             system.debug('EHub Update API---responseStr---'+responseStr);
             if(responseStr!=null && String.isNotBlank(responseStr)){ 
                    System.debug('response status code is ---'+httpRes.getStatusCode());
                    calloutResult.statusCode = httpRes.getStatusCode();
                    if(calloutResult.statusCode!=null && (calloutResult.statusCode == 200 || calloutResult.statusCode == 201)){
                            calloutResult.Success =true;
                            calloutResult.Message ='Update Successful';
                            calloutResult.MessageSeverity=ApexPages.Severity.Info;     
                    }
                    else{
                         calloutResult.MessageSeverity = ApexPages.Severity.ERROR;
                            calloutResult.Success = false;
                            if(calloutResult.statusCode!=null && calloutResult.statusCode ==400)
                               calloutResult.Message =ACETUtility.getErrorMessage('EHub500');//+mes.description 
                            else if(calloutResult.statusCode!=null && calloutResult.statusCode == 401)
                                calloutResult.Message = ACETUtility.getErrorMessage('EHub500');//+mes.description
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
         System.debug('calloutResult.Message='+calloutResult.Message);
         System.debug('calloutResult.statusCode='+calloutResult.statusCode);
         System.debug('calloutResult.MessageSeverity='+calloutResult.MessageSeverity);
         return calloutResult;
      }
      
      
}