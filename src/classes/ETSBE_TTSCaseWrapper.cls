public with sharing class ETSBE_TTSCaseWrapper {
        //US1970508 - Ravindra - start
    //provider flow info
    @AuraEnabled public Boolean providerNotFound {get;set;}
    @AuraEnabled public Boolean noProviderToSearch {get;set;}
    @AuraEnabled public Boolean isOtherSearch {get;set;}
    @AuraEnabled public Boolean noMemberToSearch {get;set;}
    @AuraEnabled public String mnf {get;set;}
    @AuraEnabled public String memberContactId {get;set;}
    @AuraEnabled public String providerContactId {get;set;}
    //US1970508 - Ravindra - end
    // Case 
    @AuraEnabled public String Status {get;set;}
    @AuraEnabled public String Interaction {get;set;}

    // Originator
    //US1970508 - Ravindra - start
    @AuraEnabled public String ContactId {get;set;}
    @AuraEnabled public String providerId {get;set;}
    //US1970508 - Ravindra - end
    @AuraEnabled public String OriginatorName {get;set;}
    @AuraEnabled public String OriginatorRelationship {get;set;}
    @AuraEnabled public String OriginatorType{get;set;}
    @AuraEnabled public String OriginatorPhone {get;set;}
    @AuraEnabled public String OriginatorEmail {get;set;}
    @AuraEnabled public String OriginatorContactName {get;set;}

    // Subject
    @AuraEnabled public String SubjectName {get;set;}
    @AuraEnabled public String SubjectType {get;set;}
    @AuraEnabled public String SubjectDOB {get;set;}
    @AuraEnabled public String SubjectId {get;set;}
    @AuraEnabled public String SubjectGroupId {get;set;}

    // Addtional Info
    @AuraEnabled public String MisdirectReason {get;set;}
    @AuraEnabled public String AddInfoTopic {get;set;}
    @AuraEnabled public String AddInfoOrginType {get;set;}
    @AuraEnabled public String AddInfoOrginSubType {get;set;}

    // Case Comments
    @AuraEnabled public String CommentPublic {get;set;}
    @AuraEnabled public String CommentDesc {get;set;}
    
    // US1753077 - Pilot Enhancement - Save Case - Validations and Additional Functionality: Kavinda
    // Validation & Addiotional Information relvent to Case
    @AuraEnabled public Integer PolicyCount {get;set;}
    @AuraEnabled public String CaseCreationFrom {get;set;}

    // US2091974 - Sanka - Case Creation
    @AuraEnabled public String TaxId{get;set;}
    @AuraEnabled public String ttsType{get;set;}
    @AuraEnabled public String ttsSubType{get;set;}

    //US - Autodoc
    @AuraEnabled public String AutoDoc{get;set;}
    @AuraEnabled public String AutoDocCaseItems{get;set;}
    
}