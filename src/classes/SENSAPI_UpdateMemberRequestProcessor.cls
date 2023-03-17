/*------------------------------------------------------------
Author:       	Tushar Kaore
Description:  	Processor class for "Update Member" API
User Story: 	US5047888

Test Class:    SENSAPI_UpdateMemberRequestProcessorTest
History
Date            Author              Comments
-------------------------------------------------------------
10-25-2022      Tushar Kaore      	Created
------------------------------------------------------------*/
public without sharing class SENSAPI_UpdateMemberRequestProcessor implements IRestRequestProcessor {
    SENSAPI_UpdateMemberRequest request;
    SENSAPI_UpdateMemberResponse responseDetails;
    Boolean firstTimePhoneUpdate = false;
	
    //process request and return response
    public IRestResponseWrapper process(String jsonRequest){
        Savepoint sp = Database.setSavepoint();
        
        try{   
            responseDetails = new SENSAPI_UpdateMemberResponse();
            initProcessor(jsonRequest);
            User userDetails;
           	Account memberAcct;
            if(validateRequest()){ //validate request here 
                String subscriberId = SENSAPI_Utility.getSubscriberId(request.subscriberId);
                userDetails = SENSAPI_Utility.getUserByAccountId(request.sensId);
                memberAcct = getPersonAccount(request.sensId, subscriberId);
                
                if(userDetails != null && memberAcct != null){
                    //logic is dependent of the sequence of the method calls, do not change
                    populateNotificationPrefs(memberAcct, userDetails); 
                    populatePersonalDetails(memberAcct, userDetails); 
                    update memberAcct;
                    if(!Test.isRunningTest()){
                        update userDetails;
                    }
                    
                    responseDetails.status = new SENSAPI_StatusResponse(true,200);
                }else{
                    responseDetails.status = new SENSAPI_StatusResponse(false,400, SENSAPI_Constant.INVALID_USER_DETAILS);
                }
	        }
        }
        catch(Exception ex) {
            Database.rollback(sp);            
            responseDetails.status = new SENSAPI_StatusResponse(false,500,ex.getMessage() +  ' : ' + ex.getStackTraceString());
        }
        RestContext.response.statusCode = responseDetails.status.responseCode;
        return responseDetails;
    }
	
    private void populateNotificationPrefs(Account memberAcct, User memberUser){
        if(request.notification != null){
            if(request.notification.email != null){
                memberAcct.Email_Notification__c = request.notification.email;
            }

            if(request.notification.textSMS != null){
                
                // to check if SMS preference is being set to true for the first time. If it was already set, the mobile number should exist on the record
                if(request.notification.textSMS && String.IsBlank(memberAcct.PersonMobilePhone)){
                    firstTimePhoneUpdate = true;
                }
                memberAcct.Text_Message_SMS_Notification__c = request.notification.textSMS;
            }
        }
    }
    
    private void populatePersonalDetails(Account memberAcct, User memberUser){
        if(request.personalInfo != null){
            if(request.personalInfo.preferredName != null){
                memberAcct.Preferred_Name__pc = request.personalInfo.preferredName;
            }

            //Email is not updated in Update Member API, it will be updated via Send Invite/Re-send Invite
            
            // mobile number to be updated only if the SMS Preference is set to true for the very first time
            if(firstTimePhoneUpdate && request.personalInfo.mobile != null){
                memberAcct.PersonMobilePhone = request.personalInfo.mobile;
                memberUser.MobilePhone = request.personalInfo.mobile;
            }
        }
    }
    
    //Validating the request parameters
    private Boolean validateRequest(){
        Boolean isValid = true;
        List<String> errorMessages = new List<String>(); 
            
        if(String.isBlank(request.subscriberId) || String.isBlank(request.sensId)){
            isValid = false;
            errorMessages.add(SENSAPI_Constant.REQUIREDFIELD_MISSING);
        }
       	
        //Phone Number Validation 
        String mobilePhone = request?.personalInfo?.mobile;
        Boolean textSmsPreference = request?.notification?.textSMS;
        
        if(textSmsPreference != null && textSmsPreference && String.isBlank(mobilePhone)){
            isValid = false;
            errorMessages.add(SENSAPI_Constant.PASS_MOBILE_NUMBER);
        }
        
        if(String.isNotEmpty(mobilePhone)){ //not empty ('') and not null
            if(mobilePhone.isNumeric() && mobilePhone.length() == 10){
                //formatting the phone number as per UI in CAC - (xxx) xxx-xxx
                request.personalInfo.mobile = '(' + mobilePhone.substring(0, 3) + ') ' + mobilePhone.substring(3, 6) + '-' + mobilePhone.substring(6);
            }else{
                isValid = false;
                errorMessages.add(SENSAPI_Constant.MOBILE_NUMBER_VALIDATION);
            }
        }
        
        if(!isValid){
            responseDetails.status = new SENSAPI_StatusResponse(false,400,errorMessages);
        }
        return isValid;
    }
    
    private void initProcessor(String requestStructure) {
        try{
            request = SENSAPI_UpdateMemberRequest.parse(requestStructure);
        }catch(Exception e){
            throw new SENSAPI_Exception( SENSAPI_Constant.JSON_PARSER_ERROR + e.getMessage());
        }  
    }
    
    public static Account getPersonAccount(String accountId, string subscriberId){
        
        Account acct;
        //to check if the member belongs to the right family
        //DURING DEVELOPMENT NOTE: The query on SNI_FL_Care_Team_Member__c is taking time. 
        List<SNI_FL_Care_Team_Member__c> careTeam = [SELECT Id,SNI_FL_Member__c, SNI_FL_Member__r.Preferred_Name__pc,
                                                     SNI_FL_Member__r.PersonMobilePhone
                                                     FROM SNI_FL_Care_Team_Member__c 
                                                     WHERE SNI_FL_Member__c =: accountId AND SNI_FL_Family__r.Member_ID__c =:subscriberId 
                                                     LIMIT 1];
        if((careTeam != null && careTeam.size() > 0)){
            acct = careTeam[0].SNI_FL_Member__r;
        }
        return acct;
    }
}