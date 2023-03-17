public without sharing class ADBCETGetTemplateByIdResponseWrapper {
    @AuraEnabled
    public AssessmentTemplate assessmentTemplate;
    
    public class AssessmentTemplate{
        @AuraEnabled
        public List<AssessmentSection> assessmentSection;
        public String builderAssessmentId;
        public String builderAssessmentVersionNumber;
        public String assessmentTemplateID;
    } 
    public class AssessmentSection{
        @AuraEnabled
        public List<AssessmentQuestion> assessmentQuestion;
    }
    public class AssessmentQuestion{
        @AuraEnabled
        public String promptText;
        @AuraEnabled
        public String questionID;
        @AuraEnabled
        public List<AssessmentQuestionResponseChoice> assessmentQuestionResponseChoice;
    }
    public class AssessmentQuestionResponseChoice{
        @AuraEnabled
        public String questionID;
        @AuraEnabled
        public String choiceID;
        @AuraEnabled
        public String choiceText;
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
    public static ADBCETGetTemplateByIdResponseWrapper parse(String json) {
        return (ADBCETGetTemplateByIdResponseWrapper) System.JSON.deserialize(json.replace('_messages', 'messages'), ADBCETGetTemplateByIdResponseWrapper.class);
    } 
}