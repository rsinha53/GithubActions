public class ACETORSUpdateWebService extends ACETWebService {
    
    public override void getEndpoint(){
        GetEndpointDetail('ORSUpdateAPI');
    }
    
    public ACETORSUpdateWebService(){
        super('SNIEligibilityAPI');
    }
    
   public String GetRequestBody(ACETLGT_CaseCommentController.OrsResultWrapper inputWrapper)
    {
        String errorMsg ='';
        List<ACETORSReadResponseWrapper> readResponse = inputWrapper.resultWrapper ;
        String designeeId ='';
        String issueId = '';
        String ownerId ='';
        String contactmethodCode ='';
        String callerfirstname='';
        String originatorTypeCode = '';
        String directionCode = '';
        String updateType = '';
        String status = '';
        String comment = inputWrapper.comment;
        List<String> commentSized = new list<String>();
        //Split the comments into chunks for 71 bytes
        if(comment.length()>0){
            integer index = 0;
            while (index < comment.length()) {
                commentSized.add(comment.substring(index, Math.min(index + 70,comment.length())));
                index += 70;
            }
        }
        System.debug('commentSized'+commentSized);
        SYstem.debug('readResponse'+readResponse);
        for(integer i= readResponse.size() -1 ; i >= 0; i--){
            if(readResponse[i].callerfirstname != null){
                designeeId =readResponse[i].designeeId;
                issueId = readResponse[i].issueId;
                ownerId =readResponse[i].ownerId;
                contactmethodCode =readResponse[i].contactmethodCode;
                callerfirstname=readResponse[i].callerfirstname;
                originatorTypeCode = readResponse[i].originatorTypeCode;
                directionCode =  readResponse[i].directionCode ;
                status = readResponse[i].status;
                break ;
            }
        }
        String updateDate = ACETUtility.julianFormatDate();
        String x = String.valueOf((System.now()).time());
        String updateTime = x.split('\\.')[0];
        
        String topsUserId = (String)Cache.Session.get('local.TOPSProfileInfo.userId'); //'673/AS6';//(String)Cache.Session.get('local.TOPSProfileInfo.userId');//login Offce 673/ Login Id JR2 ///
        List<String> searchInputParams = new List<String>();
        if(!String.isBlank(topsUserId)) {
            searchInputParams = topsUserId.split('/');
        }else {//If UserId is blank then run the service.
            ACET_LoginFlowCtrl loginflow = new ACET_LoginFlowCtrl();
            loginflow.validateTopsCredentials();
            if(loginflow.showError){
                errorMsg=ACETUtility.getErrorMessage('TS500');
                //'Unexpected error occured for TOPS service,so please check your Tops Credential';
            }
            topsUserId = (String)Cache.Session.get('local.TOPSProfileInfo.userId');
            if( String.isBlank(errorMsg) && !String.isBlank(topsUserId)) {
                searchInputParams = topsUserId.split('/');
            }
        }
        if(test.isRunningTest()){
            searchInputParams= new List<String>{'TST','123'};
            
        }
        if(String.isBlank(errorMsg) && (String.isBlank(searchInputParams[0]) || String.isBlank(searchInputParams[1]))){
            System.debug('Token api ran succesful but there is some issue in session cache');
            errorMsg=ACETUtility.getErrorMessage('TS500');
            //errorMsg='Unexpected error happened while setting in session cache';
        }
        System.debug('===='+ownerId);
        updateType = 'X'; 
      
       RequestBody = ACETORSUpdateRequestJSON.getORSUpdateRequestBody(callerfirstname,updateType,updateTime,updateDate,contactmethodCode,directionCode,originatorTypeCode,searchInputParams,issueId,commentSized);
       System.debug('request===='+RequestBody);
        return errorMsg;
    }
    
    public  ACETWSCalloutResult updateORSWS(ACETLGT_CaseCommentController.OrsResultWrapper inputWrapper){
        getEndpoint();
        ACETWSCalloutResult calloutResult = new ACETWSCalloutResult();
        try{
            HttpResponse response = new HttpResponse();
            Integer statusCode;
            String responseStr;
            String topsIssue = GetRequestBody(inputWrapper);
            if(String.isBlank(topsIssue)){
                BaseURL = '';
                System.debug('OAuthConfig='+OAuthConfig);
                response = Send(OAuthConfig);
                responseStr = response!=null?response.getBody():'';
                statusCode= response!=null?response.getStatusCode():null;
                System.debug('response='+responseStr);
                if(responseStr!=null && String.isNotBlank(responseStr) && statusCode== 200){
                    System.debug('statusCode='+statusCode);
                    calloutResult.statusCode= statusCode;
                    calloutResult.Success = true;
                    calloutResult.Message= ACETUtility.getErrorMessage('OR200'); //'Comments Updated Successfully';//ACETUtility.getErrorMessage('OR200'); //
                }
                else{
                    calloutResult.MessageSeverity = ApexPages.Severity.ERROR;
                    calloutResult.Success = false;
                    calloutResult.statusCode = statusCode;
                    if(response.getStatusCode() == 400)
                    {
                        calloutResult.Message = ACETUtility.getErrorMessage('OR400');
                    }
                    else if(response.getStatusCode() == 500)
                    {
                        calloutResult.Message = ACETUtility.getErrorMessage('OR500');
                    }
                    else if(response.getStatusCode() == 404)
                    {
                        calloutResult.Message = ACETUtility.getErrorMessage('OR500');
                    }
                    else
                    {
                        calloutResult.Message = ACETUtility.getErrorMessage('OR500');
                        calloutResult.statusCode = 999;
                    }     
                }
            }
            else {
                calloutResult.Success = false;
                calloutResult.Message = topsIssue;
                calloutResult.statusCode = 999;
            }
        }catch(Exception e){
            system.debug(e.getStackTraceString());
            calloutResult.MessageSeverity = ApexPages.Severity.ERROR;
            calloutResult.Success = false;
            calloutResult.Message = ACETUtility.getErrorMessage('OR999');
            calloutResult.statusCode=999;
        }
        system.debug('calloutResult@@@ ' + calloutResult);
        return calloutResult;
    } 
   
}