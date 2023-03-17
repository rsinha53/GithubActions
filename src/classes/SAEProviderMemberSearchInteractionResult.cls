public class SAEProviderMemberSearchInteractionResult {

    @AuraEnabled public List<memberProviderResult> memberProviderResultlst {get;set;}   
    @AuraEnabled public InteractionOverView interactionView{get;set;}
    @AuraEnabled public InteractionSubjectCard subjectCard{get;set;}
    //Find Individual Services
    @AuraEnabled public List<SAEMemberStandaloneSearch> lstSAEMemberStandaloneSearch {get;set;}
    
    public class memberProviderResult{   
        @AuraEnabled public String firstName{get;set;}
        @AuraEnabled public String lastName{get;set;}
        @AuraEnabled public String middleName{get;set;}
        @AuraEnabled public String name{get;set;}
        @AuraEnabled public String dob{get;set;}
        @AuraEnabled public String relationship{get;set;}
    }
    
    public class InteractionOverView{
        @AuraEnabled public String name {get;set;}
        @AuraEnabled public String taxidTIN {get;set;}
        @AuraEnabled public String servicingProvider {get;set;}
        @AuraEnabled public String npi {get;set;}
        @AuraEnabled public String healthCareSys {get;set;}
        @AuraEnabled public String primarySpeciality {get;set;}
        @AuraEnabled public String contactName {get;set;}
        @AuraEnabled public String providerNameID {get;set;}
        @AuraEnabled public String providerFN {get;set;}
        @AuraEnabled public String providerLN {get;set;}
        @AuraEnabled public String providerMN {get;set;}
    }
    
    public class InteractionSubjectCard{
        @AuraEnabled public String subjectName {get;set;}
        @AuraEnabled public String memberName {get;set;}
        @AuraEnabled public String firstName {get;set;}
        @AuraEnabled public String middleName {get;set;}
        @AuraEnabled public String lastName {get;set;}
        @AuraEnabled public String memberDOB {get;set;}
        @AuraEnabled public String memberId {get;set;}
        @AuraEnabled public String relationship {get;set;}
        @AuraEnabled public String gender {get;set;}
        @AuraEnabled public String groupNumber {get;set;}
        @AuraEnabled public integer age {get;set;}
        @AuraEnabled public String SSN {get;set;}
        @AuraEnabled public String EEID {get;set;}
        @AuraEnabled public Map<string,string> policyandPayerMap {get;set;} // US2669563-MVP- Member Snapshot - Policy Details - Populate Payer ID-Durga
        @AuraEnabled public string searchQueryPayerId {get;set;} //US2669563-MVP- Member Snapshot - Policy Details - Populate Payer ID-Durga
    }
    
    public class ErrorMessageHandling{
        @AuraEnabled public String faultyCode {get;set;}
        @AuraEnabled public String message {get;set;}
    }    
  
    //Find Individual Services
    public class SAEMemberStandaloneSearch {
        @AuraEnabled Public String  sourceSysCode {get; set;}
        @AuraEnabled Public String firstName  {get; set;}
        @AuraEnabled Public String lastName {get; set;}
        @AuraEnabled Public String middleName {get; set;}
        @AuraEnabled Public String birthDate {get; set;}
        @AuraEnabled Public String fullName {get; set;}
        @AuraEnabled Public String SSN {get; set;}
        @AuraEnabled Public String EEID {get; set;}
        @AuraEnabled Public Address address {get;set;} //US2589590 - Avish
        @AuraEnabled Public List<String> emailIds {get;set;}
    }
    
    //US2589590 - Avish
    public class Address {
        @AuraEnabled public String addressLine1{get;set;}
        @AuraEnabled public String city{get;set;}
        @AuraEnabled public String stateCode{get;set;}
        @AuraEnabled public String postalCode{get;set;}
    }
}