public class ACETNimbusGetSSBResponse {
	public GetSubscriptionServiceBenefitResponse getSubscriptionServiceBenefitResponse{get;set;}
	
	public class GetSubscriptionServiceBenefitResponse {
		public ServiceBenefit serviceBenefit{get;set;}
	}
	
	public class ServiceBenefit {
		public MemberGroup memberGroup{get;set;}
		public MemberGroupContractPlanOption memberGroupContractPlanOption{get;set;}
	}
	
	public class MemberGroup {
		public String groupNumber{get;set;}
		public String groupName{get;set;}
	}
	
	public class MemberGroupContractPlanOption {
		public String benefitBundleOptionId{get;set;}
		public String planMetallicLevel{get;set;}
		public String oonPricingType{get;set;}
		public String ucrPercentile{get;set;}
		public String mnrpPercentile{get;set;}
		public List<BenefitPlan> benefitPlan{get;set;}
		public String fallThruPercent{get;set;}
		public String bookOfBusinessTypeCode{get;set;}
		public String bookOfBusinessTypeDescription{get;set;}
		public String lineOfBusinessId{get;set;}
		public String lineOfBusinessName{get;set;}
		public String lineOfBusinessDescription{get;set;}
	}
	
	public class BenefitPlan {
		public List<Membership> membership{get;set;}
		public String benefitPlanId{get;set;}
		public String coverageType{get;set;}
		public String carrierId{get;set;}
		public String legalEntityName{get;set;}
		public List<NetworkScheduleIds> networkScheduleIds{get;set;}
		public String gatedProductIndicator{get;set;}
		public String pcpRequiredIndicator{get;set;}
		public String productName{get;set;}
		public String productId{get;set;}
		public String planTypeCode{get;set;}
		public String timelyFilingLimitDuration{get;set;}
		public String timelyFilingLimitType{get;set;}
		public String customerFacingPlanName{get;set;}
		public String administeredByName{get;set;}
		public String riderOnlyFlag{get;set;}
		public String planRiderType{get;set;}
		public String benefitServiceArea{get;set;}
		public List<PlanTier> planTier{get;set;}
		public List<BenefitCode> benefitCode{get;set;}
		public String eHBIndicator{get;set;}
		public String qualityProviderTierRuleID{get;set;}
		public List<ExternalIds> externalIds{get;set;}
		public String placeOfServiceDifferentialIndicator{get;set;}
		public String fundingArrangementCode{get;set;}
		public String fundingArrangementDescription{get;set;}
		public String revenueArrangementCode{get;set;}
		public String revenueArrangementDescription{get;set;}
		public String carrierBusinessId{get;set;}
		public String memberEnrollServiceAreaType{get;set;}
		public List<AttribSchedule> attribSchedule{get;set;}
	}
	
	public class Membership {
		public String coverageStartDate{get;set;}
		public String coverageEndDate{get;set;}
		public String timePeriodQualifier{get;set;}
		public Identifier enrolleeIdentifier{get;set;}
		public Identifier subscriberIdentifier{get;set;}
		public String contractOptionStartDate{get;set;}
		public String contractOptionEndDate{get;set;}
	}
	
	public class NetworkScheduleIds {
		public String networkScheduleId{get;set;}
	}
	
	public class PlanTier {
		public String tierIdentifier{get;set;}
		public String tierDescription{get;set;}
		public String tierTypeCode{get;set;}
		public String tierTypeDescription{get;set;}
		public String gatedPlanIndicator{get;set;}
		public String primaryCoInsurance{get;set;}
		public List<AccumulatorAmount> accumulatorAmounts{get;set;}
		public List<String> erCopay{get;set;}
		public List<String> pcpCopay{get;set;}
		public List<String> specialistCopay{get;set;}
		public List<String> virtualVisitsCopay{get;set;}
		public List<String> urgentCareCopay{get;set;}
		public List<String> outPatientCopay{get;set;}
		public List<String> inPatientCopay{get;set;}
		public String serviceAreaType{get;set;}
		public List<PlanDelegation> planDelegation{get;set;}
		public List<Network> network{get;set;}
		public Network networkTier{get;set;}
		public PrimaryOopComposition primaryOopComposition{get;set;}
		public String networkAccessTypeCode{get;set;}
		public String networkAccessTypeDescription{get;set;}
		public List<TierLevelServiceProvider> tierLevelServiceProvider{get;set;}
		public List<String> tier1Copay{get;set;}
	}
	
    public class Network {
		public String id{get;set;}
		public String description{get;set;}
	}
    
    public class PlanDelegation {
		public String delegationIndicator{get;set;}
		public String delegationIdentifier{get;set;}
		public String delegationName{get;set;}
	}
    
	public class BenefitCode {
		public String benefitName{get;set;}
		public String benefitCode{get;set;}
		public String primaryOOPOnlyFlag{get;set;}
		public String primaryDeductibleOnlyFlag{get;set;}
		public String visitLimitsApplies{get;set;}
		public String copayApplies{get;set;}
		public String variableCoverage{get;set;}
		public String existsOnRiderPlan{get;set;}
		public String benefitType{get;set;}
		public List<HipaaServiceTypes> hipaaServiceTypes{get;set;}
		public String benefitDisplay{get;set;}
		public List<String> benefitTier{get;set;}
		
	}
	
    public class HipaaServiceTypes {
		public String categoryCode{get;set;}
		public String categoryCodeDescription{get;set;}
		public String serviceTypeCode{get;set;}
		public String serviceTypeDescription{get;set;}
	}
    
	public class ExternalIds {
		public String entityId{get;set;}
		public String externalPlanId{get;set;}
	}
	
	public class AttribSchedule {
		public String attribScheduleID{get;set;}
		public String attribScheduleDesc{get;set;}
		public String attribScheduleType{get;set;}
		public String attribScheduleTypeDisplay{get;set;}
		public String attribScheduleEffectiveDate{get;set;}
		public String attribScheduleExpirationDate{get;set;}
		public List<NameValue> nameValue{get;set;}
	}
	
	public class Identifier {
		public String type{get;set;}
		public String id{get;set;}
	}
	
	public class AccumulatorAmount {
		public String accumLevel{get;set;}
		public String individualDeductibleMaximum{get;set;}
		public String familyDeductibleMaximum{get;set;}
		public String individualOOPMaximum{get;set;}
		public String familyOOPMaximum{get;set;}
		public String individualDeductibleYTD{get;set;}
		public String familyDeductibleYTD{get;set;}
		public String individualOOPYTD{get;set;}
		public String familyOOPYTD{get;set;}
		public String familyAccumulationTypeDescriptionDeductible{get;set;}
		public String familyAccumulationTypeDescriptionOOP{get;set;}
		public String deductibleCarryOverIndicator{get;set;}
		public String shareBasePlanAccumulatorIndicatorOOP{get;set;}
		public String shareBasePlanAccumulatorIndicatorDeductible{get;set;}
	}
    
	public class PrimaryOopComposition {
		public List<String> costShareType{get;set;}
	}
	
	public class TierLevelServiceProvider {
		public String providerAssignmentTypeCode{get;set;}
		public String providerAssignmentTypeDescription{get;set;}
		public String providerSelectionOptionalIndicator{get;set;}
		public String referralConditionTypeCode{get;set;}
		public String referralConditionTypeDescription{get;set;}
		public String providerAssignmentLevel{get;set;}
		public String providerAssignmentLevelDesc{get;set;}
	}
	
	public class NameValue {
		public String name{get;set;}
		public String value{get;set;}
		public String effectiveDate{get;set;}
		public String expirationDate{get;set;}
	}
}