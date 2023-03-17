public without sharing class ADBClientEventTrackerController {
    public class IcueMemberIdUiWrapper{
        @AuraEnabled public String icueMemberId;
        @AuraEnabled public String icueMemIdMessage;
    }
    public class GetAssessmentByIdDetails{
        @AuraEnabled
        public String updatedDate;
        @AuraEnabled
        public String updatedBy;
        @AuraEnabled
        public String conductedByUserID;
        @AuraEnabled
        public String conductedByUserRoleText;
        @AuraEnabled
        public String changeUserName;
        @AuraEnabled
        public String changeUserRoleText;
        @AuraEnabled
        public String assessmentTemplateID;
        @AuraEnabled
        public String totalScoreNumber;
        @AuraEnabled
        public String assessmentStatusTypeID;
        @AuraEnabled
        public String assessmentStatusReasonTypeID;
        @AuraEnabled
        public String deliveryMethodTypeID;
        @AuraEnabled
        public String builderAssessmentID;
        @AuraEnabled
        public String builderAssessmentVersionNumber;
        @AuraEnabled
        public String parentAssessmentID;
        @AuraEnabled
        public String totalAvgQuestScore;
        @AuraEnabled
        public List<AvailableChoiceList> completedTasks = new  List<AvailableChoiceList>();
        @AuraEnabled
        public String errorMessage;
    }
    public class ADBCETGetTemplateByIdUIWrapper {
        @AuraEnabled
        Public List<ADBCETGetTemplateByIdResponseWrapper.assessmentQuestion> availableList;
        @AuraEnabled
        public Map<String, List<AvailableChoiceList>> modalList = new Map<String, List<AvailableChoiceList>>();
        @AuraEnabled
        public String assessmentTemplateID;
        @AuraEnabled
        public String builderAssessmentId;
        @AuraEnabled
        public String builderAssessmentVersionNumber;
        @AuraEnabled
        public String errorMessage;
    }
    public class AvailableChoiceList{
        @AuraEnabled
        public String questionID;
        @AuraEnabled
        public String choiceID;
        @AuraEnabled
        public String choiceText;
    }
    public class ADBCETSearchTemplateListUIWrapper {
        @AuraEnabled
        public String templateId;
        @AuraEnabled
        public String errorMessage;
    }
    public class ADBCETSearchAssessmentListUIWrapper {
        @AuraEnabled
        public String assessmentID;
        @AuraEnabled
        public String errorMessage;
    }
    // method to call callGetIcueMemberIdService
    @AuraEnabled
        public static IcueMemberIdUiWrapper fetchGetIcueMemberIdService(String sourceMemberID){
            ADBCETGetIcueMemberIdResponseWrapper responseWrapper = new ADBCETGetIcueMemberIdResponseWrapper();
            IcueMemberIdUiWrapper uiWrapper = new IcueMemberIdUiWrapper();
            String result = '';
            String icueMemberId = '';
            //RequestBody
            String SoapXMLBody = '<memberDetailSearchRequest sourceMemberID='+ '"' + sourceMemberID + '"' + '/>';

            try{
                // Hit the service
                ACET_WebserviceCalloutFramework wsCallOutFW = new ACET_WebserviceCalloutFramework('ADBClientEventGetIcueMemberId', SoapXMLBody, null);
                HttpResponse response = wsCallOutFW.getResponse();
                if(response.getStatusCode() == 200) {
                    String xml = response.getBody();
                    // Load the xml in the document
                    if(xml!=null){
                        String key = 'icueMemberId';
                        Dom.Document doc = new Dom.Document();
                        doc.load(xml);
                        Dom.XMLNode root = doc.getRootElement();
                        icueMemberId = root.getAttributeValue(key, null);
                    }

                    if(icueMemberId!=null && icueMemberId != ''){
                        uiWrapper.icueMemberId = icueMemberId;
                    }
                    else{
                        System.debug('Icue API is failing ::' + response.getStatusCode() +'-'+ response.getBody());
                    }
                }
            }
            catch(Exception ex) {
                System.debug('ERROR : callGetIcueMemberIdService: ' + ex.getMessage());
                uiWrapper.icueMemIdMessage = ex.getMessage();
            }
            return uiWrapper;
        }
    // method to call SearchTemplateListService - Sunil
    @AuraEnabled
    public static ADBCETSearchTemplateListUIWrapper fetchSearchTemplateListService(){
        ADBCETSearchTemplateListRequestWrapper requestWrapper = new ADBCETSearchTemplateListRequestWrapper();
        ADBCETSearchTemplateListResponseWrapper responseWrapper = new ADBCETSearchTemplateListResponseWrapper();
        ADBCETSearchTemplateListUIWrapper uiWrapper = new ADBCETSearchTemplateListUIWrapper();
        requestWrapper.typeText = System.Label.ADB_CETTypeText;
        requestWrapper.valueText = System.Label.ADB_CETValueText;
        String serializedBody = JSON.serialize(requestWrapper);
        system.debug('serialzed body : '+ serializedBody);
        try {    
            // Call SearchTemplateListService
            ACET_WebserviceCalloutFramework wsCallOutFW = new ACET_WebserviceCalloutFramework('ADBClientEventSearchTemplateList', serializedBody, null);
            HttpResponse response = wsCallOutFW.getResponse();
            system.debug('response - SearchTemplateListService'+response.getBody());                    
            if(response.getStatusCode() == 200){
                responseWrapper = ADBCETSearchTemplateListResponseWrapper.parse(response.getBody());
                system.debug('responseWrapper - SearchTemplateListService'+responseWrapper);
                if(responseWrapper!=null){
                    if(responseWrapper.assessmentTemplateResult!=null && responseWrapper.assessmentTemplateResult[0].assessmentTemplateID!=null){
                        uiWrapper.templateId = responseWrapper.assessmentTemplateResult[0].assessmentTemplateID;
                    }
                    else if(responseWrapper.messages!=null && responseWrapper.messages.globalMessages!=null){
                        uiWrapper.errorMessage = responseWrapper.messages.globalMessages[0].messageString;
                    }
                }
            }
        }
        catch(Exception ex) {
            System.debug('ERROR : SearchTemplateListService: ' + ex.getMessage());
            uiWrapper.errorMessage = ex.getMessage();
        }
        return uiWrapper;
    } 
    // method to call GetTemplateByIdService - Sunil
    @AuraEnabled
    public static ADBCETGetTemplateByIdUIWrapper fetchGetTemplateByIdService(String templateId){
        ADBCETGetTemplateByIdUIWrapper uiWrapper = new ADBCETGetTemplateByIdUIWrapper();
        Map<String, List<AvailableChoiceList>> mList = new  Map<String, List<AvailableChoiceList>>(); 
        ADBCETSearchTemplateListRequestWrapper requestWrapper = new ADBCETSearchTemplateListRequestWrapper();
        ADBCETGetTemplateByIdResponseWrapper responseWrapper = new ADBCETGetTemplateByIdResponseWrapper();
        List<AvailableChoiceList> choiceTexts = new  List<AvailableChoiceList>();
        List<ADBCETGetTemplateByIdResponseWrapper.assessmentQuestion> availableExcludeList = new  List<ADBCETGetTemplateByIdResponseWrapper.assessmentQuestion>();
        requestWrapper.assessmentTemplateID = templateId;
        String serializedBody = JSON.serialize(requestWrapper);
        system.debug('serialzed body GetTemplateByIdService'+ serializedBody);
        try {    
            // Call GetTemplateByIdService
            ACET_WebserviceCalloutFramework wsCallOutFW = new ACET_WebserviceCalloutFramework('ADBClientEventGetTemplateById', serializedBody, null);
            HttpResponse response = wsCallOutFW.getResponse();
            system.debug('response - GetTemplateByIdService'+response.getBody());
            if(response.getStatusCode() == 200){
                responseWrapper = ADBCETGetTemplateByIdResponseWrapper.parse(response.getBody());
                system.debug('responseWrapper - GetTemplateByIdService'+responseWrapper.assessmentTemplate.builderAssessmentId);
                if(responseWrapper!=null){
                    if(responseWrapper.assessmentTemplate!=null){
                        uiWrapper.builderAssessmentId = responseWrapper.assessmentTemplate.builderAssessmentId;
                        uiWrapper.builderAssessmentVersionNumber = responseWrapper.assessmentTemplate.builderAssessmentVersionNumber;
                        uiWrapper.assessmentTemplateID = responseWrapper.assessmentTemplate.assessmentTemplateID;
                        if(responseWrapper.assessmentTemplate.assessmentSection!=null) {
                            for(ADBCETGetTemplateByIdResponseWrapper.assessmentSection templateResult : responseWrapper.assessmentTemplate.assessmentSection){
                                if(templateResult!=null && templateResult.assessmentQuestion!=null){
                                    for(ADBCETGetTemplateByIdResponseWrapper.assessmentQuestion questions : templateResult.assessmentQuestion){
                                            if(questions!=null && !questions.promptText.containsIgnoreCase('Core Advocacy CheckList') && !questions.promptText.containsIgnoreCase('Annual Enrollment')){
                                                availableExcludeList.add(questions); 
                                                for(ADBCETGetTemplateByIdResponseWrapper.assessmentQuestionResponseChoice choices :questions.assessmentQuestionResponseChoice){
                                                    if(choices!=null){
                                                        AvailableChoiceList availableChoiceList= new AvailableChoiceList();
                                                        availableChoiceList.questionID = choices.questionID;
                                                        availableChoiceList.choiceID = choices.choiceID;
                                                        availableChoiceList.choiceText = choices.choiceText;
                                                        choiceTexts.add(availableChoiceList);
                                                    }
                                                }
                                            }
                                        system.debug('choiceTexts'+ choiceTexts);
                                        mList.put(questions.promptText, choiceTexts);
                                        choiceTexts = new  List<AvailableChoiceList>();
                                        uiWrapper.modalList =mList;
                                        uiWrapper.availableList = availableExcludeList;
                                    }
                                }
                            }
                        }
                    }
                    else if(responseWrapper.messages!=null && responseWrapper.messages.globalMessages!=null){
                        uiWrapper.errorMessage = responseWrapper.messages.globalMessages[0].messageString;
                    }
                }
            }
        }
        catch(Exception ex) {
            System.debug('ERROR : GetTemplateByIdService: ' + ex.getMessage());
            uiWrapper.errorMessage = ex.getMessage();
        }
        return uiWrapper;
    } 
    // method to call SearchAssessmentListService - Sunil
    @AuraEnabled
    public static ADBCETSearchAssessmentListUIWrapper fetchSearchAssessmentListService(String icueMemberId,  String assessmentTemplateID, String builderAssessmentID, String builderAssessmentVersionNumber){
        ADBCETSearchTemplateListRequestWrapper requestWrapper = new ADBCETSearchTemplateListRequestWrapper();
        ADBCETSearchAssessmentResponseWrapper responseWrapper = new ADBCETSearchAssessmentResponseWrapper();
        ADBCETSearchAssessmentListUIWrapper uiWrapper = new ADBCETSearchAssessmentListUIWrapper();
        requestWrapper.sourceApplicationSubjectID = icueMemberId;
        requestWrapper.sourceApplicationSubjectTypeID = '6';
        requestWrapper.sourceApplicationType = '73';
        String serializedBody = JSON.serialize(requestWrapper);
        system.debug('serialzed body'+ serializedBody);
        try {    
            // Call SearchAssessmentListService
            ACET_WebserviceCalloutFramework wsCallOutFW = new ACET_WebserviceCalloutFramework('ADBClientEventSearchAssessmentList', serializedBody, null);
            HttpResponse response = wsCallOutFW.getResponse();
            system.debug('response - SearchAssessmentListService'+response.getBody());
            if(response.getStatusCode() == 200){
                responseWrapper = ADBCETSearchAssessmentResponseWrapper.parse(response.getBody());
                system.debug('responseWrapper - SearchAssessmentListService'+responseWrapper);
                if(responseWrapper!=null){
                    if(responseWrapper.conductedAssessmentsResponse!=null){
                        for(ADBCETSearchAssessmentResponseWrapper.conductedAssessmentsResponse assessmentResponse : responseWrapper.conductedAssessmentsResponse){
                            if(assessmentResponse!=null && assessmentResponse.conductedAssessments!=null &&
                               assessmentResponse.conductedAssessments.assessmentID!=null && assessmentResponse.conductedAssessments.assessmentTemplateID!=null &&
                               assessmentResponse.conductedAssessments.builderAssessmentId != null &&assessmentResponse.conductedAssessments.builderAssessmentId == builderAssessmentID &&
                               assessmentResponse.conductedAssessments.buildAssessmentVersionNbr!=null && assessmentResponse.conductedAssessments.buildAssessmentVersionNbr == builderAssessmentVersionNumber){
                                   uiWrapper.assessmentID = assessmentResponse.conductedAssessments.assessmentID;
                                   break;
                               }
                        } 
                    }
                    if(responseWrapper.responseHeader!=null && responseWrapper.responseHeader.statusMessages!=null && responseWrapper.responseHeader.statusMessages.statusMessage!=null){
                        uiWrapper.errorMessage = responseWrapper.responseHeader.statusMessages.statusMessage[0].statusMessage;
                        system.debug('error message search assessment list'+ uiWrapper.errorMessage);
                    }
                }
            }
        }
        catch(Exception ex) {
            System.debug('ERROR : SearchTemplateListService: ' + ex.getMessage());
            uiWrapper.errorMessage = ex.getMessage();
        }
        return uiWrapper;
    } 
    // method to call GetAssessmentByIdService
    @AuraEnabled
    public static GetAssessmentByIdDetails fetchGetAssessmentByIdService(String assessment_Id){
        GetAssessmentByIdDetails uiWrapper = new GetAssessmentByIdDetails();
        List<AvailableChoiceList> completedList = new  List<AvailableChoiceList>();
        ADBCETSearchTemplateListRequestWrapper requestWrapper = new ADBCETSearchTemplateListRequestWrapper();
        ADBCETGetAssessmentByIdResponseWrapper responseWrapper = new ADBCETGetAssessmentByIdResponseWrapper();
        requestWrapper.assessmentID = assessment_Id;
        String serializedBody = JSON.serialize(requestWrapper);
        system.debug('serialzed body GetAssessmentByIdService'+ serializedBody);
        try {    
            // Call GetAssessmentByIdService
            ACET_WebserviceCalloutFramework wsCallOutFW = new ACET_WebserviceCalloutFramework('ADBClientEventGetAssessmentById', serializedBody, null);
            HttpResponse response = wsCallOutFW.getResponse();
            system.debug('response - GetAssessmentByIdService'+response.getBody());
            if(response.getStatusCode() == 200){
                responseWrapper = ADBCETGetAssessmentByIdResponseWrapper.parse(response.getBody());
                system.debug('responseWrapper - GetAssessmentByIdService'+responseWrapper);
                if(responseWrapper!=null){
                    if(responseWrapper.assessment!=null && responseWrapper.assessment.assessmentResponseChoice!=null){
                        for(ADBCETGetAssessmentByIdResponseWrapper.assessmentResponseChoice compTasks: responseWrapper.assessment.assessmentResponseChoice){
                            if(compTasks!=null ){
                                AvailableChoiceList cList = new AvailableChoiceList();
                                cList.questionID = compTasks.questionID;
                                cList.choiceID = compTasks.responseChoiceID;
                                cList.choiceText = compTasks.responseValue;
                                completedList.add(cList);
                            }
                        }
                        uiWrapper.completedTasks = completedList;
                        uiWrapper.updatedDate = responseWrapper.assessment.assessmentDateTime;
                        uiWrapper.updatedBy = responseWrapper.assessment.conductedByUserName;
                        uiWrapper.conductedByUserID = responseWrapper.assessment.conductedByUserID;
                        uiWrapper.conductedByUserRoleText = responseWrapper.assessment.conductedByUserRoleText;
                        uiWrapper.changeUserName = responseWrapper.assessment.changeUserName;
                        uiWrapper.changeUserRoleText = responseWrapper.assessment.changeUserRoleText;
                        uiWrapper.assessmentTemplateID = responseWrapper.assessment.assessmentTemplateID;
                        uiWrapper.totalScoreNumber = responseWrapper.assessment.totalScoreNumber;
                        uiWrapper.assessmentStatusTypeID = responseWrapper.assessment.assessmentStatusTypeID;
                        uiWrapper.assessmentStatusReasonTypeID = responseWrapper.assessment.assessmentStatusReasonTypeID;
                        uiWrapper.deliveryMethodTypeID = responseWrapper.assessment.deliveryMethodTypeID;
                        uiWrapper.builderAssessmentID = responseWrapper.assessment.builderAssessmentID;
                        uiWrapper.builderAssessmentVersionNumber = responseWrapper.assessment.builderAssessmentVersionNumber;
                        uiWrapper.parentAssessmentID = responseWrapper.assessment.parentAssessmentID;
                        uiWrapper.totalAvgQuestScore = responseWrapper.assessment.totalAvgQuestScore;
                        system.debug('responseWrapper - uiWrapper'+uiWrapper);
                    }
                    else if(responseWrapper.messages!=null && responseWrapper.messages.globalMessages!=null){
                        uiWrapper.errorMessage = responseWrapper.messages.globalMessages[0].messageString;
                    }else if(responseWrapper.responseHeader!=null && responseWrapper.responseHeader.statusMessages!=null && responseWrapper.responseHeader.statusMessages.statusMessage!=null){
                        uiWrapper.errorMessage = responseWrapper.responseHeader.statusMessages.statusMessage[0].statusMessage;
                    }
                }
            }
        }
        catch(Exception ex) {
            System.debug('ERROR : GetAssessmentByIdService: ' + ex.getMessage());
            uiWrapper.errorMessage = ex.getMessage();
        }
        return uiWrapper;
    }
    // method to call fetchSaveService
    @AuraEnabled
    public static String fetchSaveService(String saveRequestDetails, Integer totalChoices){
        String message = '';
        Map<String, Object> paramsMap = (Map<String,Object>)JSON.deserializeUntyped(saveRequestDetails);
        ADBCETSaveAPIResponseWrapper responseWrapper = new ADBCETSaveAPIResponseWrapper();
        ADBCETSaveRequestWrapper requestWrapper = prepareSaveRequest(paramsMap, totalChoices);
        System.debug('requestWrapper : ' + requestWrapper);
        String serializedBody = JSON.serialize(requestWrapper);
        system.debug('serialzed body fetchSaveService'+ serializedBody);
        try {    
            // Call fetchSaveService
            ACET_WebserviceCalloutFramework wsCallOutFW = new ACET_WebserviceCalloutFramework('ADBClientEventSaveAssessment', serializedBody, null);
            HttpResponse response = wsCallOutFW.getResponse();
            system.debug('response - fetchSaveService :: '+response.getBody());
            if(response.getStatusCode() == 200){
                responseWrapper = ADBCETSaveAPIResponseWrapper.parse(response.getBody());
                system.debug('responseWrapper - GetAssessmentByIdService'+responseWrapper);
                if(responseWrapper!=null && responseWrapper.responseHeader!=null && responseWrapper.responseHeader.serviceCallStatus!=null){
                    if(responseWrapper.responseHeader.serviceCallStatus == 'SUCCESS'){
                        message = responseWrapper.responseHeader.serviceCallStatus;
                    }else if (responseWrapper.responseHeader.serviceCallStatus == 'ERROR' && responseWrapper.responseHeader.statusMessages!=null &&responseWrapper.responseHeader.statusMessages.statusMessage!=null){
                        message = responseWrapper.responseHeader.statusMessages.statusMessage[0].statusMessage;
                    }
                }
            }
        }
        catch(Exception ex) {
            System.debug('ERROR : GetAssessmentByIdService: ' + ex.getMessage());
            message = ex.getMessage();
        }
        return message;
    }
    //	populating the save assessment api request body
    static ADBCETSaveRequestWrapper prepareSaveRequest(Map<String, Object> paramsMap, Integer totalChoices) {
        ADBCETSaveRequestWrapper wrapper = new ADBCETSaveRequestWrapper();
        System.debug('params : ' + paramsMap);
        wrapper.assessmentID = (String)paramsMap.get('assessmentID');
        wrapper.assessmentStatusReasonTypeID = (String)paramsMap.get('assessmentStatusReasonTypeID');
        if((String)paramsMap.get('assessmentTemplateID')!=null)
            wrapper.assessmentTemplateID = Integer.valueOf((String)paramsMap.get('assessmentTemplateID'));
        wrapper.builderAssessmentID = (String)paramsMap.get('builderAssessmentID');
        if((String)paramsMap.get('builderAssessmentVersionNumber')!=null)
            wrapper.builderAssessmentVersionNumber = Integer.valueOf((String)paramsMap.get('builderAssessmentVersionNumber'));
        wrapper.conductedByUserID = (String)paramsMap.get('conductedByUserID');
        wrapper.conductedByUserName = (String)paramsMap.get('conductedByUserName');
        if((String)paramsMap.get('deliveryMethodTypeID')!=null)
            wrapper.deliveryMethodTypeID = Integer.valueOf((String)paramsMap.get('deliveryMethodTypeID'));
        wrapper.groupTotalScoreNumber = 0;
        if((String)paramsMap.get('parentAssessmentID')!=null)
            wrapper.parentAssessmentID = Integer.valueOf((String)paramsMap.get('parentAssessmentID'));
        wrapper.sourceApplicationType = 73;
        if((String)paramsMap.get('totalAvgQuestScore')!=null)
            wrapper.totalAvgQuestScore = Integer.valueOf((String)paramsMap.get('totalAvgQuestScore'));
        if((String)paramsMap.get('totalScoreNumber')!=null)
            wrapper.totalScoreNumber = Integer.valueOf((String)paramsMap.get('totalScoreNumber'));
        wrapper.userID = (String)paramsMap.get('userID');
        wrapper.timeZoneOffset = 'Etc/GMT';
        wrapper.assessmentResponseVOs = new List<ADBCETSaveRequestWrapper.AssessmentResponseVOs>();
        wrapper.assessmentResponseGridVOs = new List<ADBCETSaveRequestWrapper.AssessmentResponseVOs>();
        ADBCETSaveRequestWrapper.AssessmentSubjectVOs subject = new ADBCETSaveRequestWrapper.AssessmentSubjectVOs();
        subject.sourceApplicationSubjectID = Integer.valueOf((String)paramsMap.get('sourceApplicationSubjectID'));
        subject.sourceApplicationSubjectTypeID = 6;
        subject.sourceApplicationType = 73;
        subject.primarySubjectIndicator = 1;
        wrapper.assessmentSubjectVOs = new List<ADBCETSaveRequestWrapper.AssessmentSubjectVOs> {subject};
            List<ADBCETSaveRequestWrapper.AssessmentResponseChoiceVOs> responses = new List<ADBCETSaveRequestWrapper.AssessmentResponseChoiceVOs>();        
        List<Object> choiceList = (List<Object>)paramsMap.get('completedCheckList');
        if(choiceList.size() == totalChoices){
            wrapper.assessmentStatusTypeID = 3;
        }else{
            wrapper.assessmentStatusTypeID = Integer.valueOf((String)paramsMap.get('assessmentStatusTypeID'));
        }
        for(Object currChoice : choiceList) {
            ADBCETSaveRequestWrapper.AssessmentResponseChoiceVOs choiceResponse = new ADBCETSaveRequestWrapper.AssessmentResponseChoiceVOs();
            Map<String, Object> choiceMap = (Map<String, Object>)currChoice;
            choiceResponse.questionID = (String)choiceMap.get('questionID');
            choiceResponse.responseChoiceID = Integer.valueOf((String)choiceMap.get('choiceID'));
            choiceResponse.responseValue = (String)choiceMap.get('choiceText');
            responses.add(choiceResponse);
        }
        wrapper.assessmentResponseChoiceVOs = responses;
        System.debug('responses : ' + responses);
        return wrapper;
    }
}