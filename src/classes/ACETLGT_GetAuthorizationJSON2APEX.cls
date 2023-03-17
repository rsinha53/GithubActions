public class ACETLGT_GetAuthorizationJSON2APEX {
    public AuthDetailsResponse authDetailsResponse {get;set;}

    public class EnrolleIdentifiers {
        public String id {get;set;} 
        public String typeCode {get;set;} 
    }
    
    public class RuleDecision {}
    
    public class AuthDetailsResponse {
        public String authId {get;set;} 
        public String coverageSequenceNumber {get;set;} 
        public String createDateTime {get;set;}
        public String caseOwner {get;set;}
        public StatusReasonCode statusReasonCode {get;set;} 
        public StatusReasonCode statusCode {get;set;} 
        public StatusReasonCode serviceSettingTypeCode {get;set;} 
        public String globalId {get;set;} 
        public StatusReasonCode reviewPriority {get;set;} 
        public StatusReasonCode serviceCategoryTypeCode {get;set;} 
        public Member member {get;set;} 
        public AuthFollowUpContact authFollowUpContact {get;set;} 
        public List<Providers> providers {get;set;} 
        public List<Notes> notes {get;set;} 
        public Facility facility {get;set;}
        public List<RuleDecision> ruleDecision {get;set;} 
        public List<Services> services {get;set;} 
        public List<Diagnosis> diagnosis {get;set;} 
        public List<RuleDecision> letterTypes {get;set;}
        public List<errors> errors; 
    }
    
    public class Facility{
    
        public String notifyLateInd{get;set;}
        public String notifyRetrospectiveInd{get;set;}
        public StatusReasonCode placeOfServiceCode{get;set;}
        public StatusReasonCode serviceDescUrgencyCode{get;set;}
        public StatusReasonCode serviceDetailCategoryCode{get;set;}
        public StatusReasonCode dischargeDispositionType{get;set;}
        public String expectedAdmissionDate{get;set;}
        public String expectedDischargeDate{get;set;}
        public String actualAdmissionDateTime{get;set;}
        public String actualDischargeDateTime{get;set;}
        public String icmAvaliableInd{get;set;}
        public String serviceReferenceNumber{get;set;}
        public String admissionNotifyDateTime{get;set;}
        public String advanceNotificationTimeStamp{get;set;}        
        public String dischargeNotifyDateTime{get;set;}
        public FacilityDecision facilityDecision{get;set;}
    }
   
    public class errors {
        public Integer code;    //400
        public String name; 
        public String severity; //INFORMATIONAL
        public String origin;   //eisl
        public String description;  //ERR004-Member not found
    }
    
    public class Address {
        public String addressLine1 {get;set;} 
        public String city {get;set;} 
        public StatusReasonCode state {get;set;} 
        public String postalCode1 {get;set;} 
        public StatusReasonCode addressType {get;set;} 
        public StatusReasonCode countryCode {get;set;} 
        public EffectiveDateRange effectiveDateRange {get;set;} 
        public String countyFIPS {get;set;} 
        public String countyName {get;set;} 
    }
    
    public class ProviderIdentifiers {
        public String id {get;set;} 
        public String typeCode {get;set;} 
        public String typeCodeDesc {get;set;} 
    }
    
    public class ProcedureCode {
        public String code {get;set;} 
        public String codeDesc {get;set;} 
        public String typeCode {get;set;} 
        public String typeCodeDesc {get;set;} 
    }
    
    public class ServiceDecisionSource {
        public String sourceSeqNumber {get;set;} 
        public StatusReasonCode decisionSourceType {get;set;} 
    }
    
    public class AuthFollowUpContact {
        public String contactFullName {get;set;} 
        public StatusReasonCode departmentTypecode{get;set;} 
        public StatusReasonCode communicationContactRoleCode {get;set;} 
        public String medicalRecordNumber {get;set;} 
        public AvaliabilityeffectiveDateRange avaliabilityeffectiveDateRange {get;set;}
        public list<PhoneNumber> phoneNumber{get;set;} 
    public String emailAddressText{get;set;}
    }
    
    public class PhoneNumber{
        public String telephoneNumber{get;set;} 
        public String phoneTypeCode{get;set;} 

    }


    public class StatusReasonCode {
        public String code {get;set;} 
        public String description {get;set;} 
    }
	
	public class StatusReasonCodeNew {
        public String code {get;set;} 
        public String description {get;set;} 
    }
    
    public class AvaliabilityeffectiveDateRange {
        public String code {get;set;} 
        public String descr {get;set;} // in json: desc
        public String sourceSystem {get;set;} 
    }
    
    public class Providers {
        public String seqNum {get;set;} 
        public String categoryCode {get;set;} 
        public String firstName {get;set;} 
        public String middleName {get;set;} 
        public String lastName {get;set;} 
        public String organizationName{get;set;}
        public Address_Z address {get;set;} 
        public List<AvaliabilityeffectiveDateRange> specialtyType {get;set;} 
        public String productType{get;set;} 
        public String primaryPhone {get;set;} 
        public String primaryTelephoneInternationalIndicator {get;set;} 
        public String faxNumber{get;set;}
        public String faxInternationalIndicator {get;set;} 
        public StatusReasonCode networkStatusType {get;set;} 
        public List<ProviderIdentifiers> providerIdentifiers {get;set;} 
        public List<Role> role {get;set;} 
        public List<ProviderContractOrgs> providerContractOrgs {get;set;}
    }
    
    public class ProviderContractOrgs{
        public String contractOrg{get;set;}
        public String contractContext{get;set;}
        public String contractOrgPriority{get;set;}
    }
    
    public class ServiceEffDates {
        public String startDate {get;set;} 
        public String stopDate {get;set;} 
    }
    
    public class Role {
        public String id {get;set;} 
        public String descr {get;set;} // in json: desc
    }
    
    public class Services {
        public String sequenceNumber {get;set;} 
        public String serviceReferenceNumber{get;set;} 
        public String procedureFullDescription {get;set;} 
        public String providerSeqNumber {get;set;} 
        public ServiceDecision serviceDecision {get;set;} 
        public ProcedureCode procedureCode {get;set;} 
        public ServiceNonFacility serviceNonFacility {get;set;}
    public string procedureOtherText{get;set;} 
        public ServiceFacility serviceFacility{get;set;} 
    }
    
    public class ServiceFacility{
        public String expectedProcedureDate{get;set;}
        public String actualProcedureDate{get;set;}
    }
    public class ServiceNonFacility {
        public String advanceNotificationTimestamp {get;set;} 
        public StatusReasonCode placeOfServiceCode {get;set;} 
        public StatusReasonCode procedureFrequencyCode {get;set;} 
        public String procedureUnitCount {get;set;} 
        public StatusReasonCode procedureUnitOfMeasureCode {get;set;} 
        public StatusReasonCode serviceDescUrgencyCode {get;set;} 
        public StatusReasonCode serviceDetailCategoryCode {get;set;} 
        public ServiceEffDates serviceEffDates {get;set;} 
        public String unitPerFrequencyCount {get;set;} 
        public String dmeTotalCost {get;set;} 
        public String dmeEnternalFeedingSSONutrInd {get;set;} 
    }
    
    public class ServiceDecision {
        public String decisionSequenceNbr {get;set;} 
        public StatusReasonCode decisionSubTypeCode {get;set;}
        public StatusReasonCode decisionReasonCode{get;set;} 
        public StatusReasonCode decisionOutcomeCode{get;set;}
        public StatusReasonCode gapReviewOutcomeCode{get;set;} 
        public String decisionMadeByUserId {get;set;} 
        public StatusReasonCode derivedClaimRemarkCode {get;set;} 
        public StatusReasonCodeNew overrideClaimRemarkCode{get;set;} 		
        public String decisionRenderedDatetime {get;set;}           
        public List<ServiceDecisionSource> serviceDecisionSource {get;set;}
        public String claimNoteText{get;set;} 
    }
    
    public class FacilityDecision {
        public String decisionSequenceNbr {get;set;} 
        public StatusReasonCode subTypeCode{get;set;}
        public StatusReasonCode decisionReasonCode {get;set;} 
        public StatusReasonCode decisionOutcomeCode {get;set;}
        public StatusReasonCode gapReviewOutcomeCode{get;set;} 
        public String madeByUserid{get;set;} 
        public StatusReasonCode derivedClaimRemarkCode{get;set;} 
        public StatusReasonCodeNew overrideClaimRemarkCode{get;set;}        
        public String renderedDateTime{get;set;}           
        public List<ServiceDecisionSource> facilityDecisionSource {get;set;}
        public List<BedDayDec> bedDayDecision {get;set;}
        public String sourceCommentText{get;set;} 
    }
    
    public class BedDayDec{
        public ServiceEffDates bedDates {get;set;}
        public StatusReasonCode bedTypeCode {get;set;}
        public StatusReasonCode revenueCode {get;set;}
        public StatusReasonCode decisionReasonCode {get;set;}
        public StatusReasonCode systemClaimRemarkCode {get;set;}
        public StatusReasonCodeNew overrideClaimRemarkCode {get;set;}
        public StatusReasonCode decisionOutcomeCode {get;set;}
        public String decisionUpdateDateTime {get;set;}
    }
    
    public StatusReasonCode subTypeCode{get;set;}          // For Facility 
    public String systemClaimRemarkCode{get;set;}                // For Facility 
    public String renderedDateTime{get;set;}                    // For Facility
                
    
    public class EffectiveDateRange {
        public String stopDate {get;set;} 
    }
    
    public class SourceMemberId {
        public String id {get;set;} 
        public String etype {get;set;} // in json: type
    }
    
    public class Diagnosis {
        public String sequenceNumber {get;set;} 
        public ProcedureCode diagnosisCode {get;set;} 
        public String preferenceInd {get;set;} 
        public String admitInd {get;set;} 
    }
    
    public class Member {
        public SourceMemberId sourceMemberId {get;set;} 
        public List<EnrolleIdentifiers> enrolleIdentifiers {get;set;} 
        public String firstName {get;set;} 
        public String lastName {get;set;} 
        public String middleName {get;set;}
        public String birthDate {get;set;} 
        public StatusReasonCode gender {get;set;} 
        public String relationshipCode {get;set;} 
        public List<Address> address {get;set;} 
    }
    
    public class Address_Z {
        public String addressLine1 {get;set;} 
        public String city {get;set;} 
        public StatusReasonCode state {get;set;} 
        public String postalCode1 {get;set;} 
        public String postalCode2 {get;set;} 
    }
    
    public class Notes {
        public StatusReasonCode categoryCode {get;set;} 
        public String text {get;set;} 
        public String createdByUserId {get;set;} 
        public String createdByUserFirstName {get;set;} 
        public String createdByUserLastName {get;set;} 
        public String createDateTime {get;set;} 
    }
    
}