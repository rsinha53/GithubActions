/*
* @Desc: US1741780 - Wrapper Class for CopayAdditionalCoInsurance web service  
* @Date: 18-03-2020
* @Dev: Sarma
*/

public class ACET_CopayCoInsuranceResult {
    
    @AuraEnabled public CopayCoInsurance copayCoInsurance {
        get;
        set;
    }
    
    public class CopayCoInsurance {
        @AuraEnabled public String serviceName {
            get;
            set;
        }
        @AuraEnabled public String serviceCode {
            get;
            set;
        }
        @AuraEnabled public Boolean combinedAcc {
            get;
            set;
        }
        @AuraEnabled public List < String > notesList {
            get;
            set;
        }
        @AuraEnabled public Individual individual {
            get;
            set;
        }
        @AuraEnabled public ACET_AutoDocUtil.TableDetails tableData{get;set;}
    }
    
    public class Individual {
        @AuraEnabled public Boolean found {
            get;
            set;
        }
        @AuraEnabled public InNetwork inNetwork {
            get;
            set;
        }
        @AuraEnabled public InNetwork outNetwork {
            get;
            set;
        }
        @AuraEnabled public InNetwork tier1 {
            get;
            set;
        }
        @AuraEnabled public InNetwork tier2 {
            get;
            set;
        }
        @AuraEnabled public InNetwork tier1Preferred {
            get;
            set;
        }
        // US2575447 - Plan Benefits Details - for Remaining & Remaining MSK Benefit Types
        @AuraEnabled public Boolean isMskAvailable {
            get;
            set;
        }
        // US2779783 - Plan Benefits: Benefits Limit
        @AuraEnabled public Boolean isDollarAmountAvailable {
            get;
            set;
    }
    
    }
    
    public class InNetwork {
        @AuraEnabled public String coverageLevel {
            get;
            set;
        }
        @AuraEnabled public String rehablimit {
            get;
            set;
        }
        @AuraEnabled public String rehabApplied {
            get;
            set;
        }
        @AuraEnabled public String rehabRemaining {
            get;
            set;
        }
        @AuraEnabled public String habLimit {
            get;
            set;
        }
        @AuraEnabled public String habRemaining {
            get;
            set;
        }
        @AuraEnabled public String benefitsAllowed {
            get;
            set;
        }
        @AuraEnabled public String benefitsRemaining {
            get;
            set;
        }
        // US2575447 - Plan Benefits Details - for Remaining & Remaining MSK Benefit Types
        @AuraEnabled public String mskRemaining {
            get;
            set;
        }
        // US2779783 - Plan Benefits: Benefits Limit
        @AuraEnabled public String dollarAmount {
            get;
            set;
        }
        @AuraEnabled public String copay {
            get;
            set;
        }
        @AuraEnabled public String coInsurance {
            get;
            set;
        }
        // US3786086 - Thanish - 17th Aug 2021
        @AuraEnabled public String cochlearRehabLimit {
            get;
            set;
        }
        @AuraEnabled public String cochlearRehabRem {
            get;
            set;
        }
        @AuraEnabled public String cochlearHabLimit {
            get;
            set;
        }
        @AuraEnabled public String cochlearHabRem {
            get;
            set;
        }
    }
    
}