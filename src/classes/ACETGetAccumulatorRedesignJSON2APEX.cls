public class ACETGetAccumulatorRedesignJSON2APEX{
    public getBenefitAccumulatorResponse getBenefitAccumulatorResponse;
    public class getBenefitAccumulatorResponse {
        public benefitAccumulator benefitAccumulator;
        public ACETOILError[] errors;
    }
    public class benefitAccumulator {
        public benefitPlan[] benefitPlan;
    }
    public class benefitPlan {
        public String benefitPlanId;    //M000000812
        public benefitCode[] benefitCode;
    }
    public class benefitCode {
        public String benefitName;  //Outpatient Abdominal Aortic Screening
        public String benefitCode;  //ABDOMINAL_AORTIC_SCREENING_OUTPATIENT
        public String benefitTier;  //6
        public String benefitLevel; //1
        public String benefitVersion;   //1
        public String benefitCodeEffectiveDate; //2016-01-01
        public String benefitCodeExpirationDate;    //9999-12-31
        public String providerDesignation;  //All Providers
        public placeOfServices[] placeOfServices;
        public String coveredIndicator; //true
        public String deductibleAppliesIndicator;   //false
        public String ageLimitBeginningRangeValue;  //0
        public String ageLimitBeginningRangeUnit;   //D
        public String ageLimitEndingRangeValue; //999
        public String ageLimitEndingRangeUnit;  //Y
        public String genderLimit;  //A
        public String occurrenceLimitBeginningRangeValue;   //0
        public String occurrenceLimitEndingRangeValue;  //0
        public String occurrenceLimitForEveryValue; //0
        public String occurrenceLimitForEveryUnit;  //
        public String consecutiveDaysLimitBeginningRangeValue;  //0
        public String consecutiveDaysLimitEndingRangeValue; //0
        public String maxConsecutiveDays;   //0
        public String maxCopayments;    //0
        public String maxCopaymentForEveryValue;    //0
        public String maxCopaymentForEveryUnit; //
        public String benefitCodeCopaymentDuration; //
        public String dollarLimitBeginningRangeValue;   //
        public String dollarLimitEndingRangeValue;  //0.00
        public String dollarLimitPerEveryValue; //0
        public String dollarLimitPerEveryUnit;  //
        public String dollarLimitType;  //
        public benefitCostShare[] benefitCostShare;
    }
    public class placeOfServices {
        public String placeOfService;   //Ambulatory Surg Ctr
    }
    public class benefitCostShare {
        public String coverageLevel;    //Individual
        public String costShareType;    //Copayment
        public String copaymentOrder;   //
        public String primaryCostShareIndicator;    //
        public String benefitMaximumUnit;   //Dollar
        public String benefitMaximumValue;  //0.00
        public String shareBasedPlanAccumulatorIndicator;   //
        public String maximumCostShareAmount;   //
        public String mximumCostShareAmountDuration;    //
        public string benefitYTDValue;
        public string costShareId;
        public string benefitRemainingValue;
        public string limitAccumulatorBenefitPeriodDurationCode;
        public string limitAccumulatorBenefitPeriodDurationCount;
      
        
    }
    public static ACETGetAccumulatorRedesignJSON2APEX parse(String json){
        return (ACETGetAccumulatorRedesignJSON2APEX) System.JSON.deserialize(json, ACETGetAccumulatorRedesignJSON2APEX.class);
    }
}