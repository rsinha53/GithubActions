global class ACETPlanBenefitLanguageWrapper {
    
    
    global class BenefitWrapper{
        global boolean isSuccess;
        global string Message{get;set;}
        global apexPages.Severity MessageSeverity{get;set;}
        public String description{get;set;}
        global string messageSeverityStr{get;set;}
        global string BenefitKey;
        global string varriableCoverage;
        global string parStatusKey;
        global list<ParStatus> parStatusList;
        global list<string> dateRange;
        global string dateVersion;
        public ACETOILError[] errors;
        global List<AccumulatorCode> accumulatorCodeList;
        global String BenefitDisplay;
        global String BenefitCode;
        
        
    }
    
    global class ParStatus{
        global string parStatusKey;
        global list<GeneralCode> generalCodeList;
        global string benefitTier;
    }
    
    global class GeneralCode{
        global string benefitLevel;
        global string coverageIndicator;
        global string benefitCodeGeneralLanguage;
        global string languageEffectiveIndicator;
        global string benefitCodeLanguage;
        global string ageFrom;
        global string ageFromDuration;
        global string ageThrough;
        global string ageThroughDuration;
        global string billTypeSetCategory;
        global string networkId;
        global string relationshipCode;
        global string benefitLevelDescription;
        global string benefitVersion;
        global string benefitCodeEffectiveDate;
        global string benefitCodeExpirationDate;
        global string calculationBasis;
    }
    
    global class AccumulatorCode implements Comparable {
        global string BenefitKey; 
        global string coverageType;
        global string coverageLevel;
        global string costShareType;
        global string benefitMaximumValue;
        global string benefitMaximumUnit;
        global string benefitYTDValue;
        global string benefitRemainingValue;
        global string duration;
        global string dateVersion;
        global string dateRangeValue;
        global string costShareId;
        global list<string> dateRange;
        public Integer compareTo(Object ObjToCompare) {
            return coverageLevel.CompareTo(((AccumulatorCode)ObjToCompare).coverageLevel)*-1;
        }
     
  }

}