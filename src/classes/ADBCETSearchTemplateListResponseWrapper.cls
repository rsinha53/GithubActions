public without sharing class ADBCETSearchTemplateListResponseWrapper {
    @AuraEnabled
    public List<AssessmentTemplateResult> assessmentTemplateResult;
    public class AssessmentTemplateResult{
        @AuraEnabled
        public String assessmentTemplateID;
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
    public static ADBCETSearchTemplateListResponseWrapper parse(String json) {
        return (ADBCETSearchTemplateListResponseWrapper) System.JSON.deserialize(json.replace('_messages', 'messages'), ADBCETSearchTemplateListResponseWrapper.class);
    } 
}