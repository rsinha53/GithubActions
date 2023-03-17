public class ACET_EPMPMemberDetailsWebService extends ACETWebservice{
    
    private HTTPResponse httpResponseObj;
    
    public override void getEndpoint(){
        GetEndpointDetail('EPMPMemberDetailsAPI');
    }
    
    public ACET_EPMPMemberDetailsWebService(){
        super('Stargate');
    }
    
    public void getRequestBody(String lastName,String firstName,
                               String policyNumber,String subscriberId,
                               String dob, String userId,
                               String userType, String callingAppName)
    {
        String dateStr = ACETUtility.formatDateRequest(dob);
        RequestBody = '{"lst_nm":"'+lastName+'","first_nm":"'+firstName
            +'","policy_nbr":"'+policyNumber
            +'","subscriber_id":"'+subscriberId
            +'","dob":"'+dob+'","user_id":"'+userId+'","user_type":"'
            +userType+'","calling_app_name":"'+callingAppName+'"}'; 
    }
    
    public ACETWSCalloutResult getEPMPMemberDetailsWS(String lastName,String firstName,
                                                      String policyNumber,String subscriberId,
                                                      String dob, String userId,
                                                      String userType, String callingAppName)
    {
        ACETWSCalloutResult calloutResult = new ACETWSCalloutResult();
        try
        {
            getEndpoint();
            getRequestBody(lastName,firstName, policyNumber,subscriberId,
                           dob, userId, userType, callingAppName);
            httpResponseObj = Send(OAuthConfig);
            if(httpResponseObj.getStatusCode()==200){
                String responseBody = httpResponseObj.getBody(); 
                if(responseBody!=null){
                    //remove HTML messages in response
                    calloutResult.responseBody = responseBody.replaceAll('<[/a-zAZ0-9]*>',''); 
                    calloutResult.statusCode = 200;
                    calloutResult.Success = true;
                    
                }
            }
            else if(httpResponseObj.getStatusCode()==400 || httpResponseObj.getStatusCode()==404
                    || httpResponseObj.getStatusCode()==500)
            {
                calloutResult.Message = 'Unexpected Error Occured';
                calloutResult.statusCode = httpResponseObj.getStatusCode();
                calloutResult.Success = false;
            }
        }
        catch(Exception e){            
            calloutResult.Message = 'Unexpected Error Occured';
            calloutResult.statusCode = httpResponseObj!=null ? httpResponseObj.getStatusCode() : null;
            calloutResult.Success = false;
            System.debug('Exception: '+e.getMessage()+' at '+e.getLineNumber()+', StackTrace'+e.getStackTraceString());
        }
        return calloutResult;
    }
    
    public ACET_EPMPMemberDetailsJSON2Apex getEPMPMemberDetails(String lastName,String firstName,
                                                                String policyNumber,String subscriberId,
                                                                String dob, String userId,
                                                                String userType, String callingAppName)
    {
        ACET_EPMPMemberDetailsJSON2Apex emdj2a = new ACET_EPMPMemberDetailsJSON2Apex();
        try{
            ACETWSCalloutResult calloutResult;
            if(httpResponseObj==null){
                calloutResult = getEPMPMemberDetailsWS(lastName,firstName, policyNumber,subscriberId,
                                                       dob, userId, userType, callingAppName);
            }
            if(calloutResult!=null &&  calloutResult.statusCode==200 && calloutResult.responseBody!=null){  
                emdj2a = ACET_EPMPMemberDetailsJSON2Apex.parse(calloutResult.responseBody);
            }
            else if(calloutResult!=null &&  !calloutResult.Success){
                emdj2a = null;
            }
        }
        catch(Exception e){
            emdj2a = null;
            System.debug('Exception: '+e.getMessage()+' at '+e.getLineNumber()+', StackTrace'+e.getStackTraceString());
        }
        return emdj2a;
    }
    
    public ACET_EPMPMemberDetailsResult getEPMPMemberDetailsFormattedResult(String lastName,String firstName,
                                                                String policyNumber,String subscriberId,
                                                                String dob, String userId,
                                                                String userType, String callingAppName)
    {
        ACET_EPMPMemberDetailsResult emdrObj = new ACET_EPMPMemberDetailsResult();
        try
        {
            ACET_EPMPMemberDetailsJSON2Apex emdj2a = getEPMPMemberDetails(lastName,firstName,policyNumber,
                                                                          subscriberId, dob, userId,userType,
                                                                          callingAppName);
           if(emdj2a!=null)  
               emdrObj = new ACET_EPMPMemberDetailsResult(emdj2a);
        }    
        catch(Exception e){
            emdrObj = null;
            System.debug('Exception: '+e.getMessage()+' at '+e.getLineNumber()+', StackTrace'+e.getStackTraceString());
        }
        return emdrObj;
    }
}