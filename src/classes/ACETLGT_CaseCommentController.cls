public class ACETLGT_CaseCommentController {
    public class OrsResultWrapper{
        @AuraEnabled public List<ACETORSReadResponseWrapper> resultWrapper {get;set;} 
        @AuraEnabled public string message {get;set;}
        @AuraEnabled public integer statusCode {get;set;}
        @AuraEnabled public String comment {get;set;}
        //@AuraEnabled public String source {get;set;}
        
    }
    @AuraEnabled
    public static OrsResultWrapper fetchCaseCommentsWrapper(Id caseId,String issueId) {
      
        List<ACETORSReadResponseWrapper> resultWrapperList = new List<ACETORSReadResponseWrapper>();
        List<Case> CaseList =[Select id,ORS_Macess__c,ID__c,account.FirstName, account.LastName, Subject_Name__c,Subject_Group_ID__c,DOB__c from case where id=:caseId];
        //String issueId='';
        String memberId,policyId,fName,lName;
        if(CaseList!=null && CaseList.size()>0 ){
            issueId=String.isNotBlank(issueId)?issueId:CaseList.get(0).ORS_Macess__c;
            memberId=CaseList.get(0).ID__c;
            policyId=CaseList.get(0).Subject_Group_ID__c;
            //memName=CaseList.get(0).Subject_Name__c;
            fName=CaseList.get(0).account.FirstName;
            lName=CaseList.get(0).account.LastName;
        }
        OrsResultWrapper orsResultData =new OrsResultWrapper();
        orsResultData.resultWrapper = new List<ACETORSReadResponseWrapper>();
        orsResultData.comment = '';
        if(String.isNotBlank(issueId) && String.isNotBlank(memberId) && String.isNotBlank(policyId) && String.isNotBlank(fName) && String.isNotBlank(lName)){ //String.isNotBlank(memName)
            //orsResultData = ACETLGT_CaseCommentController.getORSDetails(issueId,memberId,policyId,memName);
            orsResultData = ACETLGT_CaseCommentController.getORSDetails(issueId,memberId,policyId,fName,lName);
            //memName
              system.debug('orsResultData :'+orsResultData);
        }
        else if(String.isNotBlank(issueId)){
            orsResultData.message = ACETUtility.getErrorMessage('OR998');
            orsResultData.statusCode = 999;  
        }
        List<CaseComment> caseCommentList = [Select Id, ParentId, IsPublished, CommentBody, CreatedBy.Name, CreatedDate, SystemModstamp, LastModifiedDate, LastModifiedById, IsDeleted From CaseComment where ParentId =:caseId];
        for(CaseComment o:caseCommentList){
            ACETORSReadResponseWrapper ors = new ACETORSReadResponseWrapper();
            ors.orsKey = String.valueof(o.CreatedDate);
            ors.userId = o.CreatedBy.Name;
            ors.source = 'ACET';
            ors.commment = o.CommentBody;
            ors.commmentDate = String.valueof(o.CreatedDate.format('MM/dd/yyyy',String.valueOf(userInfo.getTimeZone())));
            ors.commentTime = String.valueof(o.CreatedDate.format('h:mm a'));
            ors.commentDateTime = DateTime.parse(ors.commmentDate+', '+ors.commentTime);
            resultWrapperList.add(ors);
        }
        //resultWrapperList.sort();
        orsResultData.resultWrapper.addAll(resultWrapperList);
        return orsResultData;
    }
    
    
    
   public static OrsResultWrapper getORSDetails(String issueId,String memberId,String policyId,String fName,String lName){
        ACETORSReadWebService orsReadApi=new ACETORSReadWebService();
        //ACETWSCalloutResult CalloutResult  = orsReadApi.readORSWS(issueId,memberId,policyId,memName);
        ACETWSCalloutResult CalloutResult  = orsReadApi.readORSWS(issueId,memberId,policyId,fName,lName);
        System.debug('CalloutResult='+CalloutResult);
        List<ACETORSReadResponseWrapper> resultwrap =new List<ACETORSReadResponseWrapper>();
        OrsResultWrapper returnData = new OrsResultWrapper();
        if (CalloutResult!=null && CalloutResult.Success){
            resultwrap= (List<ACETORSReadResponseWrapper>)CalloutResult.Response;
        }
        returnData.resultWrapper = resultwrap;
        returnData.message = CalloutResult.Message;
        returnData.statusCode = CalloutResult.statusCode;
        return returnData;
    }
    @AuraEnabled
    Public static OrsResultWrapper sendCommentORS(OrsResultWrapper inputData){
        //ACETORSUpdateWebService orsUpdateApi = new ACETORSUpdateWebService();
        ACET_ORSUpdateWebService orsUpdateApi = new ACET_ORSUpdateWebService(); //US2958684: Update to ORS Microservice to the Update API

        ACETWSCalloutResult CalloutResult  = orsUpdateApi.updateORSWS(inputData);
        System.debug('CalloutResult='+CalloutResult);
        if(CalloutResult.statusCode == 200){
            inputData.Message = CalloutResult.Message ;
            inputData.statusCode = CalloutResult.statusCode;
        }
        else if(CalloutResult.statusCode != 200){
            inputData.Message = CalloutResult.Message ;
            inputData.statusCode = CalloutResult.statusCode;
        }
        return inputData;
        
    }
   @AuraEnabled
    public static void saveNewComment(OrsResultWrapper inputData,Id caseId,Boolean isPublic)
    {
        String updateComment =inputData.comment ;
        Case_Comment_Clone__c newComment = new Case_Comment_Clone__c();
            if(updateComment!= '' && updateComment != null && updateComment.length() > 4000){
                updateComment = updateComment.substring(0,2900);
            }
            newComment.CommentBody__c = updateComment;
            newComment.ParentId__c = caseId ;
            newComment.OwnerId = UserInfo.getUserId();
            newComment.IsPublished__c = isPublic;

        insert newComment;
    }

    @AuraEnabled
    public static boolean checkBoxEnablement(Id caseId,OrsResultWrapper inputData){
        system.debug('---'+inputData);
        boolean disableCheckbox  = true ;
        List<Case> CaseList = new List<Case>();
        if(caseId != null)
            CaseList =[Select ORS_Macess__c from case where id=:caseId];
        List<User> userDetails =[SELECT Id, Name, UserRole.Name FROM User where Id=:UserInfo.getUserId()];
        if( (inputData != null && inputData.statusCode == 200)
           && CaseList.size() >0 && CaseList[0].ORS_Macess__c != null && userDetails.size()>0
           && userDetails[0].UserRole.Name != 'Registered Nurse'&&userDetails[0].UserRole.Name != 'Registered Nurse - Supervisor' 
           && userDetails[0].UserRole.Name != 'Nurse Advisor'
           && userDetails[0].UserRole.Name != 'Behavioral Health Advisor'
           && userDetails[0].UserRole.Name != 'Wellness and Community Coach'
           && userDetails[0].UserRole.Name != 'Pharmacist'
           && userDetails[0].UserRole.Name != 'Regional PDC - Supervisor' ){
               disableCheckbox = false ;
           }
        return disableCheckbox;
    }
    
    @AuraEnabled
    public static String getErrorMessage(String errorCode){
        return ACETUtility.getErrorMessage(errorCode);
    }
}