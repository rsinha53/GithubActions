public without sharing class ADBCETGetTemplateByIdUIWrapper {
    @AuraEnabled
	Public List<ADBCETGetTemplateByIdResponseWrapper.assessmentQuestion> availableList;
    @AuraEnabled
    public Map<String, List<String>> modalList = new Map<String, List<String>>();
	@AuraEnabled
	public String builderAssessmentID;
	@AuraEnabled
	public String builderAssessmentVersionNumber;
	@AuraEnabled
	public String assessmentTemplateID;
}