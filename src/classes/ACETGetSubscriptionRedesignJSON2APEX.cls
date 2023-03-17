/***************
 * @name         :   ACETGetSubscriptionRedesignJSON2APEX
 * @description  :   This component  is created for the re-design of Subscription service to parse the JSON response into apex class
                     US920817                  
 * @author       :   Divya Sindhu B
 * @createddate  :   01-15-2017
 * @lastmodifiedby:  01-24-2017  
*****************/
public class ACETGetSubscriptionRedesignJSON2APEX{
  	/* public getSubscriptionServiceBenefit getSubscriptionServiceBenefit;
     public class getSubscriptionServiceBenefit {
        public getSubscriptionServiceBenefitResponse getSubscriptionServiceBenefitResponse;
        public List<errors> errors;
        
    } */
     public getSubscriptionServiceBenefitResponse getSubscriptionServiceBenefitResponse = new getSubscriptionServiceBenefitResponse();

    public class getSubscriptionServiceBenefitResponse {
        public serviceBenefit serviceBenefit;
        public List<ACETOILError> errors;
        //public List<errors> errors;
        public getSubscriptionServiceBenefitResponse(){
        	
        }
    }
    public class errors {
        public Integer code;    //404
        public String name; //NOT_FOUND
        public String severity; //FAULT
        public String origin;   //eisl
        public String description;  //No Enrollee Individual Found
        
        
    } 
    public class serviceBenefit {
        public memberGroup memberGroup;
        public memberGroupContractPlanOption memberGroupContractPlanOption;
    }
    public class memberGroup {
        public string groupNumber;
        public string groupName;
    }
    public class memberGroupContractPlanOption {
        public String benefitBundleOptionId;    //1108505
        public String planMetallicLevel;    //
        public String oonPricingType;   //UCR
        public String ucrPercentile;    //55
        public String mnrpPercentile;   //45
        public List<benefitPlan> benefitPlan;
    }
    public class benefitPlan {
        public membership[] membership;
        public String benefitPlanId;    //RX00000115
        public String coverageType; //RX
        public String carrierId;    //6
        public String carrierBusinessId; 
        public String legalEntityName;  //Oxford Health Plans (CT), Inc. Oxford Health Insurance, Inc.
        public networkScheduleIds[] networkScheduleIds;
        public String gatedProductIndicator;    //0
        public String pcpRequiredIndicator; //0
        public String productName;  //Pharmacy
        public String productId;    //PR00000001
        public String planTypeCode; //Indemnity
        public String timelyFilingLimitDuration;    //0
        public String timelyFilingLimitType;    //
        public String customerFacingPlanName;   //LG 5/30/60 D2500/5000 O4000/8000 IND4000
        public String administeredByName;   //GX
        public String riderOnlyFlag;    //1
        public String planRiderType;    //0
        public string benefitServiceArea;
        public planTier[] planTier;
        public benefitCode[] benefitCode;
        public String eHBIndicator;
        Public string qualityProviderTierRuleID;
    }
    
    public class membership {
        public String coverageStartDate {get;set;} 
        public String coverageEndDate {get;set;} 
        public String timePeriodQualifier {get;set;}
        public enrolleeIdentifier enrolleeIdentifier {get;set;}    
        public SubscriberIdentifier subscriberIdentifier {get;set;}   
    }
    public class SubscriberIdentifier{
        public String id;
        public String type;   
    }
    public class enrolleeIdentifier{
        public String id; 
        public String type;    
    }
    public class networkScheduleIds {
        public String networkScheduleId;    //Freedom
    }
    public class planTier {
        public String tierIdentifier;   //1
        public String tierDescription;  //INN CT Rx
        public String tierTypeCode; //INN
        public String tierTypeDescription;  //In Network
        public String gatedPlanIndicator;   //N
        public String primaryCoInsurance;   //0
        public String primaryIndividualOOPMaximum;  
        public String primaryIndividualDeductibleMaximum;
        public String primaryFamilyOOPMaximum;  
        public String primaryFamilyDeductibleMaximum;
        public String primaryIndividualDeductibleYTD;   //500
        public String primaryFamilyDeductibleYTD;   //750
        public String primaryIndividualOOPYTD;  //500
        public String primaryFamilyOOPYTD;  //750
        public String primaryFamilyAccumulationTypeDescriptionDeductible;   //Aggregate
        public String primaryFamilyAccumulationTypeDescriptionOOP;  //Aggregate
        public List<String> erCopay;
        public List<String> pcpCopay;
        public List<String> specialistCopay;
        public List<String> virtualVisitsCopay;
        public List<String> urgentCareCopay;
        public List<String> outPatientCopay;
        public List<String> inPatientCopay;
        public String shareBasePlanAccumulatorIndicatorOOP; //Y
        public String shareBasePlanAccumulatorIndicatorDeductible;  //Y
        public string serviceAreaType;
        public planDelegation[] planDelegation;
        public network[] network;
    }
    public class network{
        public string description;
        public string id;
    }	
    
    public class planDelegation {
        public String delegationIndicator;  //
        public String delegationIdentifier; //
        public String delegationName;   //
    }
    public class benefitCode {
        public String benefitName;  //Prescription Drug
        public String benefitCode;  //PRESCRIPTION_DRUG
        public String primaryOOPOnlyFlag;   //1
        public String primaryDeductibleOnlyFlag;    //1
        public String visitLimitsApplies;   //0
        public String copayApplies; //0
        public String variableCoverage; //1
        public String existsOnRiderPlan;    //0
        public String benefitType;
        public hipaaServiceTypes[] hipaaServiceTypes;
        public String benefitDisplay;
    }
    public class hipaaServiceTypes {
        public String categoryCode; //
        public String categoryCodeDescription;  //
        public String serviceTypeCode;  //88
        public String serviceTypeDescription;   //Pharmacy
    }
    public static ACETGetSubscriptionRedesignJSON2APEX parse(String json){
        return (ACETGetSubscriptionRedesignJSON2APEX) System.JSON.deserialize(json, ACETGetSubscriptionRedesignJSON2APEX.class);
    }
}