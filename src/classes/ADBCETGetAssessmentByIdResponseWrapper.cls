public without sharing class ADBCETGetAssessmentByIdResponseWrapper {
    @AuraEnabled
    public Assessment assessment;
    public class Assessment{
        @AuraEnabled
        public String assessmentDateTime;
        @AuraEnabled
        public String conductedByUserName;
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
        public List<AssessmentResponseChoice> assessmentResponseChoice;
    } 
    public class AssessmentResponseChoice{
        @AuraEnabled
        public String questionID;
        @AuraEnabled
        public String responseChoiceID;
        @AuraEnabled
        public String responseValue;
    }
    @AuraEnabled
    public Messages messages;
    public class Messages{
        @AuraEnabled
        public List<GlobalMessages> globalMessages;
    }
    public class GlobalMessages{
        @AuraEnabled
        public String messageString;
    }
    @AuraEnabled
    public responseHeader responseHeader;
    public class responseHeader{
        @AuraEnabled
        public statusMessages statusMessages;
    }
    public class statusMessages{
        @AuraEnabled
        public List<statusMessage> statusMessage;
    }
    public class statusMessage{
        @AuraEnabled
        public String statusMessage;
    }
    public static ADBCETGetAssessmentByIdResponseWrapper parse(String json) {
        return (ADBCETGetAssessmentByIdResponseWrapper) System.JSON.deserialize(json.replace('_messages', 'messages'), ADBCETGetAssessmentByIdResponseWrapper.class);
    } 
}