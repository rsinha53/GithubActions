public class ACETFindProviderAgreementsJSON2APEX {

    public findMedicalProviderAgreementsResponse findMedicalProviderAgreementsResponse {get;set;}
    
  /*  public class FindMedicalProviderAgreementsResult {
        public FindMedicalProviderAgreementsResponseType findMedicalProviderAgreementsResponseType {get;set;}
    } */
    
    public class findMedicalProviderAgreementsResponse {
        public List<MedicalproviderAgreements> medicalproviderAgreements {get;set;}
        public ACETOILPagination pagination { get; set; }
        public ACETOILError[] errors { get; set; } 
    }
    
    public class MedicalproviderAgreements {
        public Key key {get;set;}
        public ContractHeader contractHeader {get;set;}
        public ContractDetail contractDetail {get;set;}
      //  public List<LineOfBusiness> lineOfBusiness {get;set;}
     //   public List<PricingSchedule> pricingSchedule {get;set;}
        public Network network {get;set;}
        public NetworkSchedule NetworkSchedule {get;set;}
        public BenefitPlan benefitPlan {get;set;}
        public PricingSet pricingSet {get;set;}
        public List<ContractDerivedDates> contractDerivedDates{get;set;}
    }

    public class PricingSet {
        public String id {get;set;}
     /*   public String description {get;set;}
        public String version {get;set;}
        public String statusCode {get;set;}
        public String effectiveDate {get;set;}
        public String cancelDate {get;set;} */
    }

    public class NetworkSchedule {
        public String id {get;set;}
     /*   public String description {get;set;}
        public String serviceArea {get;set;}
        public String benefitPlanAssignmentStatusCode {get;set;}
        public String benefitPlanAssignmentEffectiveDate {get;set;}
        public String benefitPlanAssignmentCancelDate {get;set;}    */
    }  

    public class ContractDetail {
        public String statusCode {get;set;}
        public String effectiveDate {get;set;}
        public String cancelDate {get;set;}
        public String claimTypeCode;
      //  public String id {get;set;}
        public String acceptingNewPatientsIndicator {get;set;}
        public String acceptingExistingPatientsIndicator {get;set;}    
        public String providerAssignmentTypeCode {get;set;}
		public String processOrderNumber{get;set;}
        public String providerAssignmentIndicator{get;set;}
    /*    public String description {get;set;}
        public String version {get;set;}        
        public String externalContractId {get;set;}
        public String documentControlNumber {get;set;}
        public String claimTypeCode {get;set;}
        public String carrier {get;set;}
        public String networkAssignmentStatusCode {get;set;}
        public String networkAssignmentEffectiveDate {get;set;}
        public String networkAssignmentCancelDate {get;set;}
        public String discountNonCoveredIndicator {get;set;}
        public String fundingArrangement {get;set;}
        public String claimProcessStartDate {get;set;}
        public String promptPayScheduleId {get;set;}
        public String cancelReasonCode {get;set;}   */
        
    }

    public class ContractHeader {
        public String organizationName{get;set;}
    }

  /*  public class PricingSchedule {
        public String paperTypeCode {get;set;}
        public String paperTypeDescription {get;set;}
        public String id {get;set;}
        public String description {get;set;}
        public String version {get;set;}
        public String assignmentStatusCode {get;set;}
        public String assignmentEffectiveDate {get;set;}
        public String assignmentCancelDate {get;set;}
    }   */

    public class Network {
        public String id {get;set;}
        public String name {get;set;}
        public String statusCode {get;set;}
     //   public List<String> typeCode {get;set;}
     //   public String effectiveDate {get;set;}
     //  public String cancelDate {get;set;}        
    }

/*    public class LineOfBusiness {
        public String name {get;set;}
        public String statusCode {get;set;}
        public String effectiveDate {get;set;}
        public String cancelDate {get;set;}
        public String medicalNecessityIndicator {get;set;}
    }   */

    public class Key {
    /*    public String providerId {get;set;}
        public String providerTINId {get;set;}
        public String providerTINTypeCode {get;set;}
        public String addressId {get;set;}
        public String addressTypeCode {get;set;}
        public String networkId {get;set;}  */      
        public String contractDetailId {get;set;}
        public String contractHeaderId {get;set;}
        public String benefitPlanId {get;set;}
        public String networkScheduleId {get;set;}
    }
    
   

    public class BenefitPlan {
        public String productName {get;set;}
        public String planTypeCode {get;set;}        
/*        public String statusCode {get;set;}
        public String effectiveDate {get;set;}
        public String cancelDate {get;set;}
        public String id {get;set;}
        public String name {get;set;}
        public String productId {get;set;}
        public String productVersion {get;set;}
        public String version {get;set;}
        public String benefitType {get;set;}    */
    }
/*    public class Pagination {
        public String pageNumber {get;set;}
        public String pageSize {get;set;}
        public String recordCount {get;set;}
        public String totalCount {get;set;}
        public String totalPages {get;set;}
    }    */
    public class ContractDerivedDates {
          public String effectiveDate {get;set;}
          public String cancelDate {get;set;}
          public String statusCode {get;set;}
    }
}