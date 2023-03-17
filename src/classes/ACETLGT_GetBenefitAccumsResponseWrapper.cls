/* 
 * @name         :   ACETLGT_GetBenefitAccumsResponseWrapper
 * @description  :   This component  is created to call webservice for the accumulator and pass the accums to benefit language webservice. 
 * @author       :   Sai Kolluru
 * @createddate  :   18-08-2021
 * @lastmodifiedby:
 *
 */

public class ACETLGT_GetBenefitAccumsResponseWrapper{
	public GetBenefitAccumulatorResponse getBenefitAccumulatorResponse{get;set;}
	public class GetBenefitAccumulatorResponse {
		public BenefitAccumulator benefitAccumulator{get;set;}
        public ACETOILError[] errors{get;set;}
	}
	public class BenefitAccumulator {
		public BenefitPlan[] benefitPlan{get;set;}
	}
	public class BenefitPlan {
		public String benefitPlanId{get;set;}	//M000001412
		public BenefitCode[] benefitCode{get;set;}
	}
	public class BenefitCode {
        public String benefitName{get;set;}	//Infertility Services Basic Prof Comp
		public String benefitCode{get;set;}	//INFERTILITY_SERVICES_BASIC_PROF_COMP
		public String benefitTier{get;set;}	//6
		public String benefitLevel{get;set;}	//3
		public String benefitVersion{get;set;}	//1
		public String benefitCodeEffectiveDate{get;set;}	//2021-01-01
		public String benefitCodeExpirationDate{get;set;}	//9999-12-31
		public String providerDesignation{get;set;}	//All Other Prov Des
		public PlaceOfServices[] placeOfServices{get;set;}
		public String outOfCountryIndicator{get;set;}	//false
		public String[] billTypeSetCategory{get;set;}
		public String coveredIndicator{get;set;}	//false
		public String deductibleAppliesIndicator{get;set;}	//false
		public String ageLimitBeginningRangeValue{get;set;}	//0
		public String ageLimitBeginningRangeUnit{get;set;}	//D
		public String ageLimitEndingRangeValue{get;set;}	//999
		public String ageLimitEndingRangeUnit{get;set;}	//Y
		public String genderLimit{get;set;}	//All Genders
		public String occurrenceLimitBeginningRangeValue{get;set;}	//0
		public String occurrenceLimitEndingRangeValue{get;set;}	//0
		public String occurrenceLimitForEveryValue{get;set;}	//0
		public String consecutiveDaysLimitBeginningRangeValue{get;set;}	//0
		public String consecutiveDaysLimitEndingRangeValue{get;set;}	//0
		public String maxConsecutiveDays{get;set;}	//0
		public String maxCopayments{get;set;}	//0
		public String maxCopaymentForEveryValue{get;set;}	//0
		public String dollarLimitPerEveryValue{get;set;}	//0
		public String rxRefills{get;set;}	//0
		public String rxPreventativeIndicator{get;set;}	//false
		public String qualityProviderIndicator{get;set;}	//false
		public String placeOfServiceDifferentialIndicator{get;set;}	//false
		public BenefitOverride[] benefitOverride{get;set;}
		public BenefitCostShare[] benefitCostShare{get;set;}
	}
	public class PlaceOfServices {
		public String placeOfService{get;set;}	//Office
	}
	
	public class BenefitOverride {
		public String benefitOverrideIndicator{get;set;}	//false
	}
	public class BenefitCostShare {
		public String coverageLevel{get;set;}	//Individual
		public String costShareType{get;set;}	//Copayment
		public String benefitMaximumValue{get;set;}	//0.00
		public String benefitMaximumUnit{get;set;}	//Dollar
        public String primaryCostShareIndicator{get;set;}
        public String benefitYTDValue{get;set;}
        public String benefitRemainingValue{get;set;}
        public String costShareId{get;set;}
        public String limitAccumulatorBenefitPeriodDurationCount{get;set;}
        public String limitAccumulatorBenefitPeriodDurationCode{get;set;}
	}
	

}