public without sharing class ADBCETSearchTemplateListRequestWrapper {
	// request params for SearchTemplateListService
    @AuraEnabled
    public String typeText;
    @AuraEnabled
    public String valueText;
    // request params for GetTemplateByIdService
    @AuraEnabled
    public String assessmentTemplateID;
    // request params for SearchAssessmentListService
    @AuraEnabled
    public String sourceApplicationSubjectID;
    @AuraEnabled
    public String sourceApplicationSubjectTypeID;
    @AuraEnabled
    public String sourceApplicationType;
    // request params for GetAssessmentByIdService
    @AuraEnabled
    public String assessmentID;
}