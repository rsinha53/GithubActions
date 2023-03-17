public class ACETLGT_GetMedProvAgreementJSON2Apex {

 /*   public class MedicalNecessity {
        public String clauseCode  { get; set; }
        public String externalContractId { get; set; }
        public String statusCode { get; set; }
        public String effectiveDate { get; set; }
        public String cancelDate { get; set; }
        public String setId { get; set; }
        public String clauseProvision;
        public String categoryDescription { get; set; }
        public String clinicalDescription { get; set; }
        public String modifiedFromStandardCode { get; set; }
        public String modifiedFromStandardDescription { get; set; }
    } */

    public class PricingSet {
       @AuraEnabled  public String id { get; set; }
       @AuraEnabled  public String description { get; set; }
       @AuraEnabled  public String version { get; set; }
       @AuraEnabled  public String statusCode { get; set; }
       @AuraEnabled  public String effectiveDate { get; set; }
      @AuraEnabled   public String cancelDate { get; set; }
    }

    public class MedicalProviderAgreement {
       @AuraEnabled  public Key key { get; set; }
     //   public ContractHeader contractHeader { get; set; }
      @AuraEnabled   public ContractDetail contractDetail { get; set; }
      @AuraEnabled   public Network network { get; set; }
       // public NetworkSchedule NetworkSchedule { get; set; }
       // public BenefitPlan benefitPlan { get; set; }
       @AuraEnabled  public List<LineOfBusiness> lineOfBusiness { get; set; }
       @AuraEnabled  public PricingSet pricingSet { get; set; }
       @AuraEnabled  public List<PricingSchedule> pricingSchedule { get; set; }
       @AuraEnabled  public Recovery recovery { get; set; }
       @AuraEnabled  public List<FilingLimit> filingLimit { get; set; }
      @AuraEnabled   public List<FinancialPenalty> financialPenalty { get; set; }
    }

      @AuraEnabled  public getMedicalProviderAgreementResponse getMedicalProviderAgreementResponse { get; set; }
    

    public class Tier {
     //   public String networkScheduleTierNumber { get; set; }
      //  public String networkScheduleTierAssignmentStatusCode { get; set; }
     //   public String networkScheduleTierAssignmentEffectiveDate { get; set; }
    //    public String networkScheduleTierAssignmentCancelDate { get; set; }
        @AuraEnabled public String benefitPlanTierNumber { get; set; }
       @AuraEnabled  public String benefitPlanTierDescription { get; set; }
       @AuraEnabled  public String benefitPlanTierParStatusCode { get; set; }
       @AuraEnabled  public String benefitPlanTierServiceAreaTypeCode { get; set; }
     //   public String benefitPlanTierOutOfCountryIndicator { get; set; }
    //    public String benefitPlanTierReciprocityIndicator { get; set; }
      @AuraEnabled   public String benefitPlanTierBenefitType { get; set; }
    }

    public class ContractDetail {
     @AuraEnabled    public String id { get; set; }
      @AuraEnabled   public String statusCode { get; set; }
      @AuraEnabled   public String effectiveDate { get; set; }
       @AuraEnabled  public String cancelDate { get; set; }
       @AuraEnabled  public String cancelReasonCode { get; set; }
      //  public String networkAssignmentStatusCode { get; set; }
     //   public String networkAssignmentEffectiveDate { get; set; }
      //  public String networkAssignmentCancelDate { get; set; }
     @AuraEnabled   public String description { get; set; }
      @AuraEnabled  public String version { get; set; }
    //    public String discountNonCoveredIndicator { get; set; }
        @AuraEnabled  public String providerAssignmentTypeCode { get; set; }
      @AuraEnabled  public String fundingArrangement { get; set; }
     //   public String claimProcessStartDate { get; set; }
     //   public String promptPayScheduleId { get; set; }
     //   public String externalContractId { get; set; }
    //    public String documentControlNumber { get; set; }
    //    public String claimTypeCode { get; set; }
    //    public String carrier { get; set; }
      @AuraEnabled   public String acceptingNewPatientsIndicator { get; set; }
      @AuraEnabled   public String acceptingExistingPatientsIndicator { get; set; }
      @AuraEnabled   public String processOrderNumber{get;set;}
    }

  /*  public class ContractHeader {
        public String id { get; set; }
        public String providerId { get; set; }
        public String statusCode { get; set; }
        public String cancelDate { get; set; }
        public String cancelReasonCode { get; set; }
    } */

    public class Recovery {
       @AuraEnabled  public String overpaymentIndicator { get; set; }
       @AuraEnabled  public String waitPeriod { get; set; }
       @AuraEnabled  public String waitPeriodTypeCode { get; set; }
       @AuraEnabled  public String deadlinePeriod { get; set; }
       @AuraEnabled  public String deadlinePeriodTypeCode { get; set; }
    }

    public class FinancialPenalty {
       @AuraEnabled  public String id { get; set; }
       @AuraEnabled  public String tableNumber { get; set; }
      @AuraEnabled   public String statusCode { get; set; }
      @AuraEnabled   public String effectiveDate { get; set; }
     @AuraEnabled    public String cancelDate { get; set; }
    }

    public class FilingLimit {
       @AuraEnabled  public String id { get; set; }
       @AuraEnabled  public String statusCode { get; set; }
      @AuraEnabled   public String effectiveDate { get; set; }
       @AuraEnabled  public String cancelDate { get; set; }
      @AuraEnabled   public String period { get; set; }
      @AuraEnabled   public String periodType { get; set; }
      @AuraEnabled   public String typeCode { get; set; }
      @AuraEnabled   public String penaltyPercentage { get; set; }
      @AuraEnabled   public String penaltyAmount { get; set; }
      @AuraEnabled   public String assignmentLevel { get; set; }  //  US3284134 Added by Abhinav
    }

  /*  public class Pagination {
        public String pageNumber { get; set; }
        public String pageSize { get; set; }
        public String recordCount { get; set; }
        public String totalCount { get; set; }
        public String totalPages { get; set; }
    } */

    public class PricingSchedule {
       @AuraEnabled  public String id { get; set; }
       @AuraEnabled  public String description { get; set; }
      //  public String version { get; set; }
       @AuraEnabled  public String assignmentStatusCode { get; set; }
      @AuraEnabled   public String assignmentEffectiveDate { get; set; }
       @AuraEnabled  public String assignmentCancelDate { get; set; }
      @AuraEnabled   public String paperTypeCode { get; set; }
     @AuraEnabled    public String paperTypeDescription { get; set; }
    }

    public class Network {
     @AuraEnabled    public String id { get; set; }
      @AuraEnabled   public String statusCode { get; set; }
      @AuraEnabled   public String effectiveDate { get; set; }
      @AuraEnabled   public String cancelDate { get; set; }
      @AuraEnabled   public String name { get; set; }
       @AuraEnabled  public List<String> typeCode { get; set; }
    }

    public class LineOfBusiness {
     @AuraEnabled    public String name { get; set; }
     //   public String statusCode { get; set; }
      //  public String effectiveDate { get; set; }
     //   public String cancelDate { get; set; }
     @AuraEnabled    public String medicalNecessityIndicator { get; set; }
      //  public List<MedicalNecessity> medicalNecessity { get; set; }
    }

    public class Key {
      @AuraEnabled   public String benefitPlanId { get; set; }
      /*  public String providerTINId { get; set; }
        public String providerTINTypeCode { get; set; }
        public String addressId { get; set; }
        public String addressTypeCode { get; set; }*/
      @AuraEnabled   public String contractDetailId { get; set; }
       /* public String contractHeaderId { get; set; }
        public String networkId { get; set; }
        public String networkScheduleId { get; set; } */
    }

    public class GetMedicalProviderAgreementResponse {
     @AuraEnabled    public MedicalProviderAgreement medicalProviderAgreement { get; set; }
     //   public Pagination pagination { get; set; }
    }


}