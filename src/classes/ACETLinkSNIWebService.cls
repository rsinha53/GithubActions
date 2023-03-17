public with sharing class ACETLinkSNIWebService { //extends ACETWebService
    
    public String GetRequestBody(String memberId,String policyId,String firstName, String lastName, String memberDOB)
    {
        
        Map<String, String> jsonParams = new Map<String, String>();
        jsonParams.put('memberId', memberId);
        jsonParams.put('policyId', policyId);
        jsonParams.put('firstName', firstName);
        jsonParams.put('lastName', lastName);
        jsonParams.put('dob', memberDOB);
        String jsonInput = JSON.serialize(jsonParams);
        return jsonInput;  //ankit
    }
    
    public ACETWSCalloutResult getMemberWS(String memberId,String policyId, String firstName, String lastName, String memberDOB){
        
        if(!memberDOB.contains('-')){
            memberDOB = ACETUtility.formatDateFutureDate(memberDOB);
        }
        ACETWSCalloutResult calloutResult = new ACETWSCalloutResult();
        
        ACETSNIWrapper obj = new ACETSNIWrapper();
        try{
            
            String reqMethod='POST';
            string sniEligibleVal = '';
            string advFullName = '';
            string assignedToVal = '';
            String lob=''; //Code added By Chandan -US2776388
            String productTypes='';//Code added By Chandan -US2776388
            String serviceGroup='';//Code added By Chandan -US2776388
            
             ACET_WebserviceCalloutFramework wsCallOutFW = new ACET_WebserviceCalloutFramework();
             String responseStr;
             wsCallOutFW.serviceName = 'SNI Eligibility API';
             //wsCallOutFW.requestParamsMap = requestParamsMap;
             wsCallOutFW.requestBody = GetRequestBody(memberId,policyId,firstName,lastName,memberDOB); 
             wsCallOutFW.encodeURLParameters = true;
             HttpResponse httpRes  = wsCallOutFW.getResponse();
            
             
             responseStr = httpRes!=null?httpRes.getBody():'';
             system.debug('SNI Eligibility API---responseStr---'+responseStr);
            //End US3273478
			 Map<String, Object> sniMapResultData = ACETUtility.checkSNiEligibilityValue(httpRes);
			 if(sniMapResultData != null && ! sniMapResultData.isempty()){
			    sniEligibleVal = (String)sniMapResultData.get('sniEligibility');
				advFullName = (String)sniMapResultData.get('advisorFullName');
                assignedToVal = (String)sniMapResultData.get('assignedTo');
                //Code added By Chandan -US2776388 -Begin
                lob = (String)sniMapResultData.get('lob'); 
                serviceGroup=(String)sniMapResultData.get('serviceGroup'); 
                Object[] accountTypes = (Object[])sniMapResultData.get('accountTypes');
                if(accountTypes!=null && accountTypes.size()>0){
                    productTypes=(String)accountTypes.get(0);
                }
                //End
			}       
			system.debug('twins sniEligibleVal--------------------'+sniEligibleVal);
            if(sniEligibleVal != null && sniEligibleVal != '' && httpRes.getStatusCode() == 200 ){
                obj.sniEligibility = sniEligibleVal;
                obj.advisorFullName = advFullName;
                obj.assignedTo = assignedToVal;
                obj.lob = lob; //Code added By Chandan -US2776388
                obj.productTypes=productTypes;//Code added By Chandan -US2776388
                obj.serviceGroup=serviceGroup;//Code added By Chandan -US2776388
                
                
                calloutResult.Success = true;
                calloutResult.Message = '';                
                calloutResult.Response = obj;                 
				calloutResult.statusCode = 200;
            }
            else{
               calloutResult.MessageSeverity = ApexPages.Severity.ERROR;
               calloutResult.Success = false;
               calloutResult.statusCode = httpRes.getStatusCode();
			    if(httpRes.getStatusCode() == 200)
                {
					calloutResult.statusCode = 617;
                    calloutResult.Message = ACETUtility.getErrorMessage('SNI200'); //sni status code 200 and null
                }
                else if(httpRes.getStatusCode() == 400)
                {
                    calloutResult.Message = ACETUtility.getErrorMessage('GN400');
                }
                else if(httpRes.getStatusCode() == 500)
                {
                    calloutResult.Message = ACETUtility.getErrorMessage('GN500');
                }
                else if(httpRes.getStatusCode() == 404)
                {
                    calloutResult.Message = ACETUtility.getErrorMessage('GN404');
                }
                else
                {
                    calloutResult.Message = ACETUtility.getErrorMessage('GN500');
                    calloutResult.statusCode = 999;
                }     
            }
            
            
        }catch(Exception e){
            system.debug(e.getStackTraceString());
            calloutResult.MessageSeverity = ApexPages.Severity.ERROR;
            calloutResult.Success = false;
            calloutResult.Message = 'Web Service or External System is temporarily unavailable.';
            calloutResult.statusCode=999;
        }
        system.debug('calloutResult@@@ ' + calloutResult);
        return calloutResult;
    } 
    
}