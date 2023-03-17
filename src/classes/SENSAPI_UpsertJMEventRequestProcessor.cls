/*------------------------------------------------------------
Author:       	Geeta Koli
Description:  	Processor class for "Upsert Member Journey Event" API
User Story: 	US5027148

Test Class:    SENSAPI_UpsertJMEventReqProcessorTest
History
Date            Author              Comments
-------------------------------------------------------------
11-15-2022      Geeta Koli      	Created
------------------------------------------------------------*/
public without sharing class SENSAPI_UpsertJMEventRequestProcessor implements IRestRequestProcessor {
    SENSAPI_UpsertMemberJourneyEventRequest request;
    SENSAPI_UpsertMemberJourneyEventResponse responseDetails;
    
    //process request and return response
    public IRestResponseWrapper process(String jsonRequest){
        Savepoint sp = Database.setSavepoint();
        try{
            responseDetails = new SENSAPI_UpsertMemberJourneyEventResponse();
            initProcessor(jsonRequest);
            if(validateRequest()){
                request.Data.subscriberId = SENSAPI_Utility.getSubscriberId(request.Data.subscriberId);
                List<SNI_FL_Care_Team_Member__c> caregiverlist = SENSAPI_Utility.getSpecificCareTeamMemberForFamily(request.Data.memberSensId, request.Data.subscriberId);
                
                if(caregiverlist.size() > 0){
                    
                    String responseSensId = upsertMemberActivity(caregiverlist[0].SNI_FL_Family__c);
                    if(responseSensId != null){
                        responseDetails.activityDetail = new SENSAPI_UpsertMemberJourneyEventResponse.ActivityDetail(responseSensId);
                    }
                    responseDetails.status = new SENSAPI_StatusResponse(true,200);
                }else{
                    responseDetails.status = new SENSAPI_StatusResponse(false,400,SENSAPI_Constant.INVALID_USER_DETAILS);
                }
            }
        }catch(Exception ex) {
            Database.rollback(sp);            
            responseDetails.status = new SENSAPI_StatusResponse(false,500,ex.getMessage() +  ' : ' + ex.getStackTraceString());
        }
        RestContext.response.statusCode = responseDetails.status.responseCode;
        return responseDetails;
    }
    
    private void initProcessor(String requestStructure) {
        request = SENSAPI_UpsertMemberJourneyEventRequest.parse(requestStructure);
    }
    
    //Validating the request parameters
    private Boolean validateRequest(){
        Boolean isValid = true;
        List<String> errorMessages = new List<String>(); 
        System.debug('request.type>>'+request.type);
        if(String.isBlank(request.type) || String.isBlank(request?.Data?.subscriberId) || String.isBlank(request?.Data?.memberSensId) 
           || String.isBlank(request?.Data?.carePlanId) || (request.type == 'assignment' && request?.Data?.createdAt == null)
           || String.isBlank(request?.id) || String.isBlank(request?.version) || String.isBlank(request?.Data?.taskId)
           || (request.type == 'activityUpdate' && String.isBlank(request?.Data?.status))
           || (request.type == 'activityUpdate' && request?.Data?.lastModifiedAt == null)){
               isValid = false;
               errorMessages.add(SENSAPI_Constant.REQUIREDFIELD_MISSING);
           }else if((request.type != 'assignment') && (request.type != 'activityUpdate')){
               isValid = false;
               errorMessages.add(SENSAPI_Constant.ACTIVITY_TYPE_ERROR);
           }
        
        if(!isValid){
            responseDetails.status = new SENSAPI_StatusResponse(false,400,errorMessages);
        }
        return isValid;
    }
    
    @testvisible
    private String upsertMemberActivity(Id famId){
        Savepoint sp = Database.setSavepoint();
        List<SENSAPI_UpsertMemberJourneyEventResponse.ActivityDetail> returnActivityDetails = new List<SENSAPI_UpsertMemberJourneyEventResponse.ActivityDetail>();
        SENSAPI_UpsertMemberJourneyEventResponse.ActivityDetail sensIdForActivity;
        List<Member_Activity__c> memberActivityList = new List<Member_Activity__c>();
        List<String> errorMessages = new List<String>(); 
        Member_Activity__c tempActivity = new Member_Activity__c();
        Member_Activity__c activity;
        String oldStatus;
        if(famId != null){
            try{
                activity = [select id,Name,Family__c,Care_Plan_Id__c,Task_Id__c,Care_Advisor__c,
                            Activity_Created_Date__c,Status__c,Expired_Date__c
                            from Member_Activity__c where Task_Id__c =: request.Data.taskId];
                oldStatus = activity.Status__c;
            }catch(Exception e){}
            if(activity !=null){
                tempActivity = activity;
            }else{
                tempActivity = new Member_Activity__c();
            }
            if(request.id != null){
                tempActivity.Id__c = request.id;
            }
            if(request.version != null){
                tempActivity.Version__c = request.version;
            }
            tempActivity.Family__c = famId;
            tempActivity.Member__c = request.Data.memberSensId;
            tempActivity.Task_Id__c = request.Data.taskId;
            if(request.Data.careAdvisorId != null){
                if(request.Data.careAdvisorId == ''){
                    request.Data.careAdvisorId = null;
                }
                tempActivity.Care_Advisor__c = request.Data.careAdvisorId;
            }
            if(request.type == 'assignment'){
                tempActivity.Activity_Created_Date__c = request.Data.createdAt;
                if(tempActivity.Status__c == '' || tempActivity.Status__c == null){
                    tempActivity.Status__c = 'assigned';
                    tempActivity.Assigned_Date__c = system.now();
                }
            }
            if(request.Data.activityTitle != null){
                tempActivity.Title__c = request.Data.activityTitle;
            }
            if(request.Data.carePlanId != null){
                tempActivity.Care_Plan_Id__c = request.Data.carePlanId;
            }
            if(request.type == 'activityUpdate'){
                tempActivity.Activity_Last_Modified_Date__c = request.Data.lastModifiedAt;
                if(tempActivity.Status__c == 'assigned' || tempActivity.Status__c == '' || tempActivity.Status__c == null){
                    tempActivity.Status__c = request.Data.status;
                }else if((tempActivity.Status__c == 'completed' || tempActivity.Status__c == 'removed' || tempActivity.Status__c == 'expired') && request.Data.status == 'assigned'){
                }else if(tempActivity.Status__c != (request.Data.status)){
                    tempActivity.Status__c = request.Data.status;
                }
                
                if(oldStatus != request.Data.status){
                    if(tempActivity.Status__c == 'assigned'){
                        tempActivity.Assigned_Date__c = system.now();
                    }else if(tempActivity.Status__c == 'completed'){
                        tempActivity.Completed_Date__c = system.now();
                    }else if(tempActivity.Status__c == 'removed'){
                        tempActivity.Removed_Date__c = system.now();
                    }else if(tempActivity.Status__c == 'expired'){
                        tempActivity.Expired_Date__c = system.now();
                    }
                }
            }
            upsert tempActivity Task_Id__c;
        }
        
        return tempActivity.Id;
    }
}