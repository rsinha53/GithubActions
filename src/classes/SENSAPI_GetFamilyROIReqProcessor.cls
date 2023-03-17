/*------------------------------------------------------------
Author:         Tushar Kaore
Description:    Processor class for "GET Family ROI" API
User Story:   Used in US5027391

Test Class:    SENSAPI_GetFamilyROIReqProcessorTest
History
Date            Author              Comments
-------------------------------------------------------------
16 Nov,2022     Tushar Kaore        Created
------------------------------------------------------------*/
public without sharing class SENSAPI_GetFamilyROIReqProcessor implements IRestRequestProcessor {
    SENSAPI_GetFamilyROIRequest request;
    SENSAPI_GetFamilyROIResponse responseDetails;
    Map<String,String> roiStatusMap = new Map<String,String>{'Active' => 'Active','InActive' => 'Expired','Revoked' => 'Revoked'};

    Account familyAcct;
    
    //process request and return response
    public IRestResponseWrapper process(String jsonRequest){
        Savepoint sp = Database.setSavepoint();
        try{   
            responseDetails = new SENSAPI_GetFamilyROIResponse();
            initProcessor(jsonRequest);
            if(validateRequest()){ //validate request here 
                String subscriberId = SENSAPI_Utility.getSubscriberId(request.subscriberId);
                List<Account> familyAcctList = getFamilyAccountWithCareTeam(subscriberId); 
                if(familyAcctList.size() > 0){
                    familyAcct= familyAcctList[0];
                    //Reason to query ROIs via Care Team is that the Person Account can 
        			//be part of multiple families and we are looking at the data from single family
                    Map<Id,SNI_FL_Care_Team_Member__c> careTeamMap = new Map<Id,SNI_FL_Care_Team_Member__c>(familyAcct.SNI_FL_CareTeam_Members__r); 
                    List<SNI_FL_Care_Team_Member__c> careTeamList = getFamilyRoiFromCareTeam(new List<Id>(careTeamMap.keySet())); 
                    responseDetails.members = populateFamilyRoiDetails(careTeamList);
                    responseDetails.subscriberId = subscriberId;
                    responseDetails.status = new SENSAPI_StatusResponse(true,200);
                }else{
                    responseDetails.status = new SENSAPI_StatusResponse(false,400, SENSAPI_Constant.NO_FAMILYACCOUNT);
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
    
    //Validating the request parameters
    private Boolean validateRequest(){
        Boolean isValid = true;
        List<String> errorMessageList = new List<String>(); 
        
        if(String.IsBlank(request.subscriberId)){
            isValid = false;
            errorMessageList.add(SENSAPI_Constant.REQUIREDFIELD_MISSING);
        }
        
        if(!isValid){
            responseDetails.status = new SENSAPI_StatusResponse(false,400,errorMessageList);
        }
        return isValid;
    }
    
    
    private void initProcessor(String requestStructure) {
        try{
            request = SENSAPI_GetFamilyROIRequest.parse(requestStructure);
        }catch(Exception e){
            throw new SENSAPI_Exception( SENSAPI_Constant.JSON_PARSER_ERROR + e.getMessage());
        }  
    }
    
    /*
     * Fetching family details with Care Team
     */ 
    public static List<Account> getFamilyAccountWithCareTeam(String subscriberId){
        return [SELECT Id,
                (SELECT Id,SNI_FL_Non_Policy_Member__c FROM SNI_FL_CareTeam_Members__r)
                FROM Account WHERE Member_ID__c=:subscriberId AND RecordType.Name = 'Family' LIMIT 1];
    }
    
    
    
    public static List<SNI_FL_Care_Team_Member__c> getFamilyRoiFromCareTeam(List<Id> careTeamIds){
        //Reason to query ROIs via Care Team is that the Person Account can 
        //be part of multiple families and we are looking at the data from single family
        List<SNI_FL_Care_Team_Member__c> careTeamList = [SELECT Id, SNI_FL_Member__c,SNI_FL_Member__r.FirstName, SNI_FL_Member__r.LastName, SNI_FL_Non_Policy_Member__c, 
                                                      (SELECT Id,Exp_Date__c, SNI_FL_Status__c, SNI_FL_ROI_Signed_Date__c,SNI_FL_Account__c, SNI_FL_Account__r.FirstName,
                                                       SNI_FL_Account__r.LastName, SNI_FL_Member__c,SNI_FL_Member__r.SNI_FL_Member__r.Id,SNI_FL_Member__r.SNI_FL_Member__r.FirstName, 
                                                       SNI_FL_Member__r.SNI_FL_Member__r.LastName,SNI_FL_ROI_Signed_With__c, SNI_FL_ROI_Signed_With__r.SNI_FL_Member__r.Id, 
                                                       SNI_FL_ROI_Signed_With__r.SNI_FL_Member__r.FirstName, SNI_FL_ROI_Signed_With__r.SNI_FL_Member__r.LastName,Is_Revoked__c
                                                       FROM Members_ROIs__r)
                                                      FROM SNI_FL_Care_Team_Member__c WHERE Id IN:careTeamIds];
        return careTeamList;
    }
    
    
    
    // Method to populate Content Document to wrapper class
    public List<SENSAPI_GetFamilyROIResponse.Member> populateFamilyRoiDetails(List<SNI_FL_Care_Team_Member__c> careTeamWithRoi){
        Map<String,SENSAPI_GetFamilyROIResponse.Member> sensIdAndRoiDetailsMap
            = new Map<String,SENSAPI_GetFamilyROIResponse.Member>();
        
        for(SNI_FL_Care_Team_Member__c careTeam: careTeamWithRoi){
           	//populating only policy member details
            if(careTeam.SNI_FL_Non_Policy_Member__c == false && careTeam.SNI_FL_Member__c != null){
                String sensId = careTeam.SNI_FL_Member__c;
                String firstName = careTeam.SNI_FL_Member__r.FirstName;
                String lastName = careTeam.SNI_FL_Member__r.LastName;
                if(!sensIdAndRoiDetailsMap.containsKey(sensId)){
                    sensIdAndRoiDetailsMap.put(sensId, new SENSAPI_GetFamilyROIResponse.Member(sensId, firstName, lastName)); 
                }
                
                //Adding details only for the Active ROIs
                for(SNI_FL_Members_ROI__c memberRoi: careTeam.Members_ROIs__r){
                    if(memberRoi.SNI_FL_Status__c == SENSAPI_Constant.ROI_STATUS_ACTIVE || memberRoi.SNI_FL_Status__c == SENSAPI_Constant.ROI_STATUS_INACTIVE){
                        handleCanBeViewedBy(sensIdAndRoiDetailsMap,memberROi); 
                        handleCanView(sensIdAndRoiDetailsMap,memberROi); 
                    }
                }
            }
        }
        
        
        return sensIdAndRoiDetailsMap.values();
    }
    
    /**
     * Populating ROI Details to capture Can Be Viewed By details
     */ 
    public SENSAPI_GetFamilyROIResponse.Member handleCanBeViewedBy(Map<String,SENSAPI_GetFamilyROIResponse.Member> sensIdAndRoiDetailsMap, SNI_FL_Members_ROI__c memberROi){
        String sensId = memberROi.SNI_FL_Account__c; 
        String firstName = memberROi.SNI_FL_Account__r.FirstName;
        String lastName = memberROi.SNI_FL_Account__r.LastName;
        SENSAPI_GetFamilyROIResponse.Member memberInfo;

        if(String.IsNotBlank(sensId) ){
            if(!sensIdAndRoiDetailsMap.containsKey(sensId)){
                sensIdAndRoiDetailsMap.put(sensId, new SENSAPI_GetFamilyROIResponse.Member(sensId,firstName, lastName));
            }
            memberInfo = sensIdAndRoiDetailsMap.get(sensId);
            SENSAPI_GetFamilyROIResponse.ROIDetails authorizedMember = new SENSAPI_GetFamilyROIResponse.ROIDetails();
            authorizedMember.sensId = memberROi.SNI_FL_ROI_Signed_With__r.SNI_FL_Member__c;
            authorizedMember.submittedDate = memberROi.SNI_FL_ROI_Signed_Date__c;
            authorizedMember.expiryDate = memberROi.Exp_Date__c;
            authorizedMember.firstName = memberROi.SNI_FL_ROI_Signed_With__r.SNI_FL_Member__r.FirstName;
            authorizedMember.lastName = memberROi.SNI_FL_ROI_Signed_With__r.SNI_FL_Member__r.LastName;
            if(memberROi.SNI_FL_Status__c == 'InActive' && memberROi.Is_Revoked__c == true){
                memberROi.SNI_FL_Status__c = 'Revoked';
            }
            authorizedMember.status = roiStatusMap.get(memberROi.SNI_FL_Status__c);
            memberInfo.canBeViewedBy.add(authorizedMember);
        }
        return memberInfo;
    }
    
    
    /*
     * Populating ROI Details to capture Can View details
     */ 
    public SENSAPI_GetFamilyROIResponse.Member handleCanView(Map<String,SENSAPI_GetFamilyROIResponse.Member> sensIdAndRoiDetailsMap, SNI_FL_Members_ROI__c memberRoi){
        //code to handle can view part of the authorized member
        String authorizedMemberSendId = memberRoi.SNI_FL_ROI_Signed_With__r.SNI_FL_Member__c;
        String firstName = memberRoi.SNI_FL_ROI_Signed_With__r.SNI_FL_Member__r.FirstName;
        String lastName = memberRoi.SNI_FL_ROI_Signed_With__r.SNI_FL_Member__r.LastName;
        SENSAPI_GetFamilyROIResponse.Member memberInfo;
        if(String.IsNotBlank(authorizedMemberSendId)){
            if( !sensIdAndRoiDetailsMap.containsKey(authorizedMemberSendId)){
                sensIdAndRoiDetailsMap.put(authorizedMemberSendId, new SENSAPI_GetFamilyROIResponse.Member(authorizedMemberSendId,firstName,lastName)); 
            }
            memberInfo = sensIdAndRoiDetailsMap.get(authorizedMemberSendId);
            SENSAPI_GetFamilyROIResponse.ROIDetails authorizingMember = new SENSAPI_GetFamilyROIResponse.ROIDetails();
            authorizingMember.sensId = memberROi.SNI_FL_Member__r.SNI_FL_Member__c;
            authorizingMember.submittedDate = memberROi.SNI_FL_ROI_Signed_Date__c;
            authorizingMember.expiryDate = memberROi.Exp_Date__c;
            authorizingMember.firstName = memberROi.SNI_FL_Member__r.SNI_FL_Member__r.FirstName;
            authorizingMember.lastName = memberROi.SNI_FL_Member__r.SNI_FL_Member__r.LastName;
            if(memberROi.SNI_FL_Status__c == 'InActive' && memberROi.Is_Revoked__c == true){
                memberROi.SNI_FL_Status__c = 'Revoked';
            }
            authorizingMember.status = roiStatusMap.get(memberROi.SNI_FL_Status__c);
            memberInfo.canView.add(authorizingMember);
        }
        return memberInfo;
    }
}