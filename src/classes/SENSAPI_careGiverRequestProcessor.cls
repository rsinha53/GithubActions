public class SENSAPI_careGiverRequestProcessor implements IRestRequestProcessor {
    public SENSAPI_careGiverRequest request;
    public SENSAPI_RemoveCaregiverResponse CGremoveResponseDetails;
    public SENSAPI_RegisteredCaregiverResponse CGRegisteredResponseDetails;  //Newly added
    
    //process request and return response
    public IRestResponseWrapper process(String requestStructure){
        Savepoint sp = Database.setSavepoint();            
        try{   
            initProcessor(requestStructure);
            System.debug('requestStructure***:'+requestStructure);
            System.debug('request***:'+request);
            CGremoveResponseDetails = new SENSAPI_RemoveCaregiverResponse();
            Boolean isRemoved = false;
            if(String.isNotBlank(request.action)){
                if(request.action == 'create'){
                    //WIP Code from Pratikshya (commenting the create part as the story is on hold)
                    /* Boolean checkValidRequest;
checkValidRequest = SENSAPI_Utility.validReqPostCareGiverCheck(request);
if(checkValidRequest == true){
Id individualRecTyepId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Individual').getRecordTypeId();
//insert a person account based on request account details
list<account> personAcct = SENSAPI_Utility.getPersonAcct(individualRecTyepId,request.familyMember.firstName,request.familyMember.lastName,request.familyMember.email,Date.valueOf(request.familyMember.dateOfBirth));
list<account> famAccount = [select id from account where Member_ID__c=:request.subscriberId limit 1];
if(famAccount.size()>0){
// Create a care team record related to the person account
list<SNI_FL_Care_Team_Member__c> caregiverlist = SENSAPI_Utility.getCaregiver(famAccount[0].Id,personAcct[0].id,request.familyMember.email);
if(caregiverlist.size()>0){
SNI_FL_ROIUtility.createCommunityUser(caregiverlist[0].Id);
responseDetails.sensId = caregiverlist[0].Id;
responseDetails.status = new SENS_postCareGiverResponse.API_Status(200,true);
}
else{
responseDetails.status = new SENS_postCareGiverResponse.API_Status(400,false,SENSAPI_Constant.NO_CTM_FOUND);  
}
}
else{
responseDetails.status = new SENS_postCareGiverResponse.API_Status(400,false,SENSAPI_Constant.NO_FAMILYACCOUNT);
}
}
else{
if(String.isNotBlank(request.familyMember.sensId)){
responseDetails.status = new SENS_postCareGiverResponse.API_Status(400,false,SENSAPI_Constant.NO_ID_INSERT); 
}
else{
responseDetails.status = new SENS_postCareGiverResponse.API_Status(400,false,SENSAPI_Constant.REQUIREDFIELD_MISSING);    
}
}*/
                }
                if(request.action == 'update'){
                }
                
                
                //Newly added
                if(request.action == 'Registered'){
                    CGRegisteredResponseDetails = new SENSAPI_RegisteredCaregiverResponse();
                    if(String.isNotBlank(request.familyMember.sensId) && String.isNotBlank(request.subscriberId)){
                        //getting old care team based on account id
                        String subscriberId = SENSAPI_Utility.getSubscriberId(request.subscriberId);
                        List<SNI_FL_Care_Team_Member__c> caregiverlist = SENSAPI_Utility.getSpecificCareTeamMemberForFamily(request.familyMember.sensId,subscriberId);
                        if(caregiverlist.size()>0){
                        if(caregiverlist[0].SNI_FL_Status__c != 'Registered'){
                            List<SNI_FL_Care_Team_Member__c> updatedGiverList = new List<SNI_FL_Care_Team_Member__c>();
                            
                                for(SNI_FL_Care_Team_Member__c cgiver : caregiverlist ){
                                    cgiver.SNI_FL_Status__c = 'Registered';
                                    cgiver.SNI_FL_Registered_Date__c = system.today();
                                    updatedGiverList.add(cgiver);
                                } 
                                update updatedGiverList;
                                if(updatedGiverList.size()>0)
                                    CGRegisteredResponseDetails.status = new SENSAPI_RegisteredCaregiverResponse.API_Status(200,true);
                            }
                        else{
                            CGRegisteredResponseDetails.status = new SENSAPI_RegisteredCaregiverResponse.API_Status(400,false,SENSAPI_Constant.CARETEAM_REGISTER);
                        }
                        }
                        else{
                                CGRegisteredResponseDetails.status = new SENSAPI_RegisteredCaregiverResponse.API_Status(400,false,SENSAPI_Constant.INVALID_USER_DETAILS);  
                            }
                    }else{ 
                        CGRegisteredResponseDetails.status = new SENSAPI_RegisteredCaregiverResponse.API_Status(400,false,SENSAPI_Constant.REQUIREDFIELD_MISSING);  
                    } 
                    RestContext.response.statusCode = CGRegisteredResponseDetails.status.responseCode;
                    return CGRegisteredResponseDetails;
                }
                //Newly added
                
                
                
                
                if(request.action == 'Removed'){
                    // For US4980286
                    
                    String familyId = null;
                    Map<Id,SNI_FL_Care_Team_Member__c> careTeamMap = new Map<Id,SNI_FL_Care_Team_Member__c>();
                    if(String.isNotBlank(request.familyMember.sensId) && String.isNotBlank(request.subscriberId)){
                        String subscriberId = SENSAPI_Utility.getSubscriberId(request.subscriberId);
                        List<SNI_FL_Care_Team_Member__c> caregiverlist = SENSAPI_Utility.getAllCareTeamMembersForFamilyMemberId(subscriberId);
                        List<SNI_FL_Care_Team_Member__c> caregiverlistToRemove = new List<SNI_FL_Care_Team_Member__c>();
                        if(caregiverlist.size()>0){
                            for(SNI_FL_Care_Team_Member__c careTeam : caregiverlist){
                                careTeamMap.put(careTeam.SNI_FL_Member__c,careTeam);
                            }
                        }
                        if(careTeamMap.containsKey(request.familyMember.sensId)){
                            if(careTeamMap.get(request.familyMember.sensId).SNI_FL_Status__c == 'Removed'){
                                CGremoveResponseDetails.status = new SENSAPI_StatusResponse(false,400,SENSAPI_Constant.MEMBER_ALREADY_REMOVED);
                            }else{
                                familyId = careTeamMap.get(request.familyMember.sensId).SNI_FL_Family__c;
                                if(careTeamMap.get(request.familyMember.sensId).SNI_FL_Primary_Caregiver__c == true){
                                    caregiverlistToRemove.addAll(careTeamMap.values());
                                    isRemoved = removeCareTeamMemberList(caregiverlistToRemove,request.familyMember.sensId,familyId);
                                }else{
                                    caregiverlistToRemove.add(careTeamMap.get(request.familyMember.sensId));
                                    isRemoved = removeCareTeamMemberList(caregiverlistToRemove,request.familyMember.sensId,familyId);
                                }
                                if(isRemoved){
                                    CGremoveResponseDetails.status = new SENSAPI_StatusResponse(true,200);
                                }else{
                                    CGremoveResponseDetails.status = new SENSAPI_StatusResponse(false,400,SENSAPI_Constant.TRY_AGAIN);  
                                }
                            }
                        }else{
                            CGremoveResponseDetails.status = new SENSAPI_StatusResponse(false,400,SENSAPI_Constant.INVALID_USER_DETAILS);  
                        }
                    }else{ 
                        CGremoveResponseDetails.status = new SENSAPI_StatusResponse(false,400,SENSAPI_Constant.REQUIREDFIELD_MISSING);  
                    } 
                    RestContext.response.statusCode = CGremoveResponseDetails.status.responseCode;
                    return CGremoveResponseDetails;
                }
            }
            else{
                CGremoveResponseDetails.status = new SENSAPI_StatusResponse(false,400,SENSAPI_Constant.ACTION_NOT_BLANK); 
            }
        }
        catch(Exception ex) {
            system.debug('enter catch exception'+ex.getMessage());
            Database.rollback(sp);            
            CGremoveResponseDetails.status = new SENSAPI_StatusResponse(false,400,ex.getMessage());
        }
        RestContext.response.statusCode = CGremoveResponseDetails.status.responseCode;
        return CGremoveResponseDetails;
    }

    //to remove all care giver related to PAO
    private boolean removeCareTeamMemberList(List<SNI_FL_Care_Team_Member__c> careTeamList, Id SensId, Id familyId){
        Boolean isRemoved = false;
        List<String> sensIds = new List<String>();
        sensIds.add(SensId);        
        SENSAPI_Utility.careTeamUpdateStatusList(careTeamList);
        if(sensIds != null && familyId != null){ 
            if(Limits.getQueueableJobs() < Limits.getLimitQueueableJobs()){
                DeactivateUserToRemoveMember obj = new DeactivateUserToRemoveMember(sensIds,familyId);
                System.enqueueJob(obj); 
            }
        }
        List<SNI_FL_Care_Team_Member__c> updatedCTM = SENSAPI_Utility.getSpecificCareTeamMember(SensId);
        if(updatedCTM[0].SNI_FL_Status__c == SENSAPI_Constant.CTM_STATUS_REMOVED){
            isRemoved = true;
        }
        return isRemoved;
    }
    
    private void initProcessor(String requestStructure) {
        try{
            request = SENSAPI_careGiverRequest.parse(requestStructure);
        }catch(Exception e){
            system.debug('enter catch exception of request'+e.getMessage());
        }  
    }
}