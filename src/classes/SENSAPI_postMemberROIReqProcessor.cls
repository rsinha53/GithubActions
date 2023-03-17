public class SENSAPI_postMemberROIReqProcessor implements IRestRequestProcessor  {
    
    public SENSAPI_postMemberROIRequest request;
    public SENSAPI_postMemberROIResponse responseDetails; 
    
    //process request and return response
    public IRestResponseWrapper process(String requestStructure){
        Savepoint sp = Database.setSavepoint();            
        try{
            responseDetails = new SENSAPI_postMemberROIResponse();
            initProcessor(requestStructure);
            System.debug('requestStructure***:'+requestStructure);
            System.debug('request***:'+request);
            List<User> roiOwner;
            List<String> roiListMembers = new List<String>();
            Boolean isUpdated;
            List<String> invalidIds;
            String subscriberId;
            SENSAPI_Utility.roiWrapper extROI = new SENSAPI_Utility.roiWrapper();
            SENSAPI_Utility.careTeamWrap cwraps = new SENSAPI_Utility.careTeamWrap();
            map<String,SNI_FL_Care_Team_Member__c> validMembersMap = new map<String,SNI_FL_Care_Team_Member__c>();
            Boolean checkValidRequest = SENSAPI_Utility.validRequestCheck(request);
            
            //Check valid request if true
            if(checkValidRequest == true){
                subscriberId = SENSAPI_Utility.getSubscriberId(request.subscriberId);
                //Check if request has authorizedFor and RevokedFor as null or not
                if(request.authorizedFor != null && request.revokedFor != null){
                    cwraps = SENSAPI_Utility.isValidMember(request.authorizedFor, request.revokedFor,request.sensId,subscriberId);
                }
                else if(request.authorizedFor != null && request.revokedFor == null){
                    cwraps = SENSAPI_Utility.isValidMember(request.authorizedFor, null,request.sensId,subscriberId);
                }
                else if(request.authorizedFor == null && request.revokedFor != null){
                    cwraps = SENSAPI_Utility.isValidMember(null, request.revokedFor,request.sensId,subscriberId);
                }
                
                // Check if the subscriber Id is Valid and has any care team members present
                if(cwraps.cteamMems.size() > 0){
                    //Check if member ids are valid
                    if (cwraps.invalidMems.size() <= 0 || cwraps.invalidMems == null){
                        //Get owner of the family member who is giving/revoking authorization
                        roiOwner = SENSAPI_Utility.getROIOwner(request.sensId);
                        //Check size of the authorized and revoked list
                        if((request.revokedFor == null || request.revokedFor.size() <= 0) && request.authorizedFor.size() > 0){
                            roiListMembers = request.authorizedFor.clone();
                            //Check if the authorized and revoked members have the existing ROI records
                            extROI= SENSAPI_Utility.getExistingROIS(roiListMembers,request.authorizedFor,null,request.sensId);
                        }
                        else if((request.authorizedFor == null || request.authorizedFor.size() <= 0) && request.revokedFor.size() > 0){
                            roiListMembers = request.revokedFor.clone();
                            extROI= SENSAPI_Utility.getExistingROIS(roiListMembers,null,request.revokedFor,request.sensId);
                        }
                        else if(request.authorizedFor.size()>0 && request.revokedFor.size()>0){
                            roiListMembers = request.authorizedFor.clone();
                            roiListMembers.addall(request.revokedFor);
                            extROI= SENSAPI_Utility.getExistingROIS(roiListMembers,request.authorizedFor,request.revokedFor,request.sensId);
                        }
                        //If revokedMembers don't have existing ROIs
                        if(extROI.revokedNonROIList.size() > 0){
                            String noRoi = 'No ROI exists for the member'+ ':' + extROI.revokedNonROIList;
                            responseDetails.status = new SENSAPI_StatusResponse(false,400,noRoi); 
                        }
                        else{
                            List<SNI_FL_Members_ROI__c> roiListForMembers = new List<SNI_FL_Members_ROI__c>();
                            //If revoked and authorized members of existing ROIs. Update Existing ROIS
                            if(extROI.authorizedMap.size() > 0 || extROI.revokedMap.size() > 0 ){
                                roiListForMembers = SENSAPI_Utility.updateExistingROIS(extROI.authorizedMap,extROI.revokedMap);
                                responseDetails.status = new SENSAPI_StatusResponse(true,200);
                            }
                            //If authorized members don't have existing ROIs. Create ROIS
                            if(extROI.authorizedNonROIList.size() > 0){
                                //Check if owner of the ROI record has user created
                                if(roiOwner.size() > 0){
                                    for(String nonROIMem : extROI.authorizedNonROIList){
                                        if(cwraps.validMems.containskey(Id.valueOf(nonROIMem)))
                                            validMembersMap.put(nonROIMem,cwraps.validMems.get(nonROIMem));
                                    }
                                    List<SNI_FL_Members_ROI__c> roiLists = SENSAPI_Utility.createROIS(validMembersMap, cwraps.validSensId,roiOwner[0].Id);
                                    for(SNI_FL_Members_ROI__c roiRecs : roiLists){
                                        roiListForMembers.add(roiRecs);   
                                    }
                                    upsert roiListForMembers;
                                    if(roiListForMembers.size() > 0){
                                        responseDetails.status = new SENSAPI_StatusResponse(true,200);  
                                    }
                                }
                                else{
                                    responseDetails.status = new SENSAPI_StatusResponse(false,400,SENSAPI_Constant.NOUSER_EXIST);   
                                }
                            }
                        }
                    }
                    else{
                        String invalidMems = SENSAPI_Constant.INVALID_MEMBERID + ':' + cwraps.invalidMems;
                        responseDetails.status = new SENSAPI_StatusResponse(false,400,invalidMems);
                    }
                }
                else{
                    String noFam = 'No Care Team member found with this subscriber id'+ ':' + subscriberId;
                    responseDetails.status = new SENSAPI_StatusResponse(false,400,noFam); 
                }
            }
            else{
                responseDetails.status = new SENSAPI_StatusResponse(false,400,SENSAPI_Constant.REQUIREDFIELD_MISSING);
            }
        }
        catch(Exception ex) {
            system.debug('enter catch exception'+ex.getMessage());
            responseDetails.status = new SENSAPI_StatusResponse(false,400,ex.getMessage());
        }  
        RestContext.response.statusCode = responseDetails.status.responseCode;
        return responseDetails;
    }
    
    private void initProcessor(String requestStructure) {
        try{
            request = SENSAPI_postMemberROIRequest.parse(requestStructure);
        }catch(Exception e){
            system.debug('enter request catch exception'+e.getMessage());
        }       
    }
}