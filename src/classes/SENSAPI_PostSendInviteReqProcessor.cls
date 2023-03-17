/*------------------------------------------------------------
Author:        Manmeet Kaur
Description:   Request processor class for the service request "Post Send Invite"   

Test Class:    SENSAPI_PostSendInviteReqProcessorTest
History
Date            Author              Comments
-------------------------------------------------------------
27-09-2022      Manmeet Kaur      	Created
------------------------------------------------------------*/
public class SENSAPI_PostSendInviteReqProcessor implements IRestRequestProcessor{
	   
    public SENSAPI_PostSendInviteRequest request;
    public SENSAPI_PostSendInviteResponse responseDetails;
    
    //process request and return response
    public IRestResponseWrapper process(String requestStructure){
        responseDetails = new SENSAPI_PostSendInviteResponse();
        try{
            initProcessor(requestStructure);
            String subscriberId = request.subscriberId;
            String sfId = request.sensId;
            String emailId = request.email;
            String result;
            String subscriberIdReq;
            if(sfId!='' && emailId!='' && subscriberId != ''){
                //if(validateRequest()){
                    String emailRegex = '^[a-zA-Z0-9._|\\\\%#~`=?&/$^*!}{+-]+@[a-zA-Z0-9.-]+\\.[a-zA-Z]{2,4}$';
                    Pattern MyPattern = Pattern.compile(emailRegex);
                    Matcher MyMatcher = MyPattern.matcher(emailId);
                    subscriberIdReq = SENSAPI_Utility.getSubscriberId(subscriberId);
                    if (!MyMatcher.matches()) {
                        responseDetails.status = new SENSAPI_PostSendInviteResponse.API_Status(false, 400, SENSAPI_Constant.EMAIL_ADDRESS_INVALID); 
                    }
                    else{
                        List<SNI_FL_Care_Team_Member__c> careTeamMemberId = SENSAPI_Utility.getSpecificCareTeamMemberForFamily(sfId, subscriberIdReq);
                        if(careTeamMemberId.size()>0){
                            String careTeamId = careTeamMemberId[0].id;
                            if(careTeamMemberId[0].SNI_FL_Status__c == SENSAPI_Constant.CTM_REGISTERED_STATUS){
                            	responseDetails.status = new SENSAPI_PostSendInviteResponse.API_Status(false, 400, SENSAPI_Constant.CTM_ALREADY_REGISTERED);
                        	}else{
                                List<User> userdetail = [SELECT Id,username FROM User WHERE accountId =: sfId AND isActive = true limit 1];
                                result = SENSAPI_Utility.resendInvite(careTeamMemberId[0],careTeamId,emailId,userdetail.size()>0?userdetail[0]:null);
                                if(result == 'SUCCESS'){
                                    responseDetails.status = new SENSAPI_PostSendInviteResponse.API_Status(true, 200);  
                                }else{
                                    if(result!=null){
                                        responseDetails.status = new SENSAPI_PostSendInviteResponse.API_Status(false, 400, result); 
                                    }else{
                                        responseDetails.status = new SENSAPI_PostSendInviteResponse.API_Status(false, 400, SENSAPI_Constant.TRY_AGAIN); 
                                    }
                                }
                        	}
                        }else{
                            responseDetails.status = new SENSAPI_PostSendInviteResponse.API_Status(false, 400, SENSAPI_Constant.INVALID_USER_DETAILS); 
                        }
                	}
            	//}
            }else{
                responseDetails.status = new SENSAPI_PostSendInviteResponse.API_Status(false, 400, SENSAPI_Constant.REQUIREDFIELD_MISSING); 
            }
        }catch(exception ex){
            responseDetails.status = new SENSAPI_PostSendInviteResponse.API_Status(false, 500, ex.getMessage() + ex.getStackTraceString());           
        }
        RestContext.response.statusCode = responseDetails.status.responseCode;
        return responseDetails;
    }
    
    private void initProcessor(String requestStructure) {
        try{
            request = SENSAPI_PostSendInviteRequest.parse(requestStructure);
        }catch(Exception e){
            throw new SENSAPI_Exception('Error while parsing wrapper JSON : ' + e.getMessage());
        }        
    }
    
    //Validating the request parameters
  /*  private Boolean validateRequest(){
        Boolean isValid = true;
        if(!String.isBlank(request.subscriberId)){
            String subscriberIdReq = SENSAPI_Utility.getSubscriberId(request.subscriberId);
            List<Account> acc = SENSAPI_Utility.getFamilyAccountForSubscriberId(subscriberIdReq);
            if(acc.size() == 0){
                isValid = false;
            }
        }
        if(!isValid){
            responseDetails.status = new SENSAPI_PostSendInviteResponse.API_Status(false,400,SENSAPI_Constant.NO_FAMILYACCOUNT);
        }
        return isValid;
    }*/
}