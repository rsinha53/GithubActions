public without sharing class ADBCETSearchAssessmentResponseWrapper {
	@AuraEnabled
    public List<ConductedAssessmentsResponse> conductedAssessmentsResponse;
    public class ConductedAssessmentsResponse{
        @AuraEnabled
        public ConductedAssessments conductedAssessments;
    } 
    public class ConductedAssessments{
        @AuraEnabled
        public String assessmentID;
        @AuraEnabled
        public String assessmentTemplateID;
        @AuraEnabled
        public String builderAssessmentID;
        @AuraEnabled
        public String buildAssessmentVersionNbr;
    } 
    @AuraEnabled
    public ResponseHeader responseHeader;
    public class ResponseHeader{
        @AuraEnabled
        public StatusMessages statusMessages;
    }
    public class StatusMessages{
        @AuraEnabled
        public List<StatusMessage> statusMessage;
    }
    public class StatusMessage{
        @AuraEnabled
        public String statusMessage;
    }
    public static ADBCETSearchAssessmentResponseWrapper parse(String json) {
        return (ADBCETSearchAssessmentResponseWrapper) System.JSON.deserialize(json, ADBCETSearchAssessmentResponseWrapper.class);
    } 
}