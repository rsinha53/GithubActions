public class ACETGetMedProvAgreementJSON2Apex {

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
        public String id { get; set; }
        public String description { get; set; }
        public String version { get; set; }
        public String statusCode { get; set; }
        public String effectiveDate { get; set; }
        public String cancelDate { get; set; }
    }

    public class MedicalProviderAgreement {
        public Key key { get; set; }
     //   public ContractHeader contractHeader { get; set; }
        public ContractDetail contractDetail { get; set; }
        public Network network { get; set; }
       // public NetworkSchedule NetworkSchedule { get; set; }
       // public BenefitPlan benefitPlan { get; set; }
        public List<LineOfBusiness> lineOfBusiness { get; set; }
        public PricingSet pricingSet { get; set; }
        public List<PricingSchedule> pricingSchedule { get; set; }
        public Recovery recovery { get; set; }
        public List<FilingLimit> filingLimit { get; set; }
        public List<FinancialPenalty> financialPenalty { get; set; }
    }

       public getMedicalProviderAgreementResponse getMedicalProviderAgreementResponse { get; set; }
    

    public class Tier {
     //   public String networkScheduleTierNumber { get; set; }
      //  public String networkScheduleTierAssignmentStatusCode { get; set; }
     //   public String networkScheduleTierAssignmentEffectiveDate { get; set; }
    //    public String networkScheduleTierAssignmentCancelDate { get; set; }
        public String benefitPlanTierNumber { get; set; }
        public String benefitPlanTierDescription { get; set; }
        public String benefitPlanTierParStatusCode { get; set; }
        public String benefitPlanTierServiceAreaTypeCode { get; set; }
     //   public String benefitPlanTierOutOfCountryIndicator { get; set; }
    //    public String benefitPlanTierReciprocityIndicator { get; set; }
        public String benefitPlanTierBenefitType { get; set; }
    }

    public class ContractDetail {
        public String id { get; set; }
        public String statusCode { get; set; }
        public String effectiveDate { get; set; }
        public String cancelDate { get; set; }
        public String cancelReasonCode { get; set; }
      //  public String networkAssignmentStatusCode { get; set; }
     //   public String networkAssignmentEffectiveDate { get; set; }
      //  public String networkAssignmentCancelDate { get; set; }
       public String description { get; set; }
       public String version { get; set; }
    //    public String discountNonCoveredIndicator { get; set; }
         public String providerAssignmentTypeCode { get; set; }
       public String fundingArrangement { get; set; }
     //   public String claimProcessStartDate { get; set; }
     //   public String promptPayScheduleId { get; set; }
     //   public String externalContractId { get; set; }
    //    public String documentControlNumber { get; set; }
    //    public String claimTypeCode { get; set; }
    //    public String carrier { get; set; }
        public String acceptingNewPatientsIndicator { get; set; }
        public String acceptingExistingPatientsIndicator { get; set; }
        public String processOrderNumber{get;set;}
    }

  /*  public class ContractHeader {
        public String id { get; set; }
        public String providerId { get; set; }
        public String statusCode { get; set; }
        public String cancelDate { get; set; }
        public String cancelReasonCode { get; set; }
    } */

    public class Recovery {
        public String overpaymentIndicator { get; set; }
        public String waitPeriod { get; set; }
        public String waitPeriodTypeCode { get; set; }
        public String deadlinePeriod { get; set; }
        public String deadlinePeriodTypeCode { get; set; }
    }

    public class FinancialPenalty {
        public String id { get; set; }
        public String tableNumber { get; set; }
        public String statusCode { get; set; }
        public String effectiveDate { get; set; }
        public String cancelDate { get; set; }
    }

    public class FilingLimit {
        public String id { get; set; }
        public String statusCode { get; set; }
        public String effectiveDate { get; set; }
        public String cancelDate { get; set; }
        public String period { get; set; }
        public String periodType { get; set; }
        public String typeCode { get; set; }
        public String penaltyPercentage { get; set; }
        public String penaltyAmount { get; set; }
        public String assignmentLevel { get; set; }  //  US3284134 Added by Abhinav
    }

  /*  public class Pagination {
        public String pageNumber { get; set; }
        public String pageSize { get; set; }
        public String recordCount { get; set; }
        public String totalCount { get; set; }
        public String totalPages { get; set; }
    } */

    public class PricingSchedule {
        public String id { get; set; }
        public String description { get; set; }
      //  public String version { get; set; }
        public String assignmentStatusCode { get; set; }
        public String assignmentEffectiveDate { get; set; }
        public String assignmentCancelDate { get; set; }
        public String paperTypeCode { get; set; }
        public String paperTypeDescription { get; set; }
    }

    public class Network {
        public String id { get; set; }
        public String statusCode { get; set; }
        public String effectiveDate { get; set; }
        public String cancelDate { get; set; }
        public String name { get; set; }
        public List<String> typeCode { get; set; }
    }

    public class LineOfBusiness {
        public String name { get; set; }
     //   public String statusCode { get; set; }
      //  public String effectiveDate { get; set; }
     //   public String cancelDate { get; set; }
        public String medicalNecessityIndicator { get; set; }
      //  public List<MedicalNecessity> medicalNecessity { get; set; }
    }

    public class Key {
        public String benefitPlanId { get; set; }
     /*   public String providerId { get; set; }
        public String providerTINId { get; set; }
        public String providerTINTypeCode { get; set; }
        public String addressId { get; set; }
        public String addressTypeCode { get; set; }*/
        public String contractDetailId { get; set; }
       /* public String contractHeaderId { get; set; }
        public String networkId { get; set; }
        public String networkScheduleId { get; set; } */
    }

    public class GetMedicalProviderAgreementResponse {
        public MedicalProviderAgreement medicalProviderAgreement { get; set; }
     //   public Pagination pagination { get; set; }
    }


}