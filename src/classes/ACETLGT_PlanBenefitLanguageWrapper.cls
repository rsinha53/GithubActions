global class ACETLGT_PlanBenefitLanguageWrapper {
    
    
    global class BenefitWrapper{ 
       @AuraEnabled global boolean isSuccess;
       @AuraEnabled global string Message{get;set;}
       global apexPages.Severity MessageSeverity{get;set;}
       @AuraEnabled public String description{get;set;}
       @AuraEnabled global string messageSeverityStr{get;set;}
       @AuraEnabled global string BenefitKey;
       @AuraEnabled global string benefitLanguageCode;
       @AuraEnabled global string benefitDisplay;
       @AuraEnabled global boolean benefitLanguageIndicator;
       @AuraEnabled global string varriableCoverage;
       @AuraEnabled global string parStatusKey;
       @AuraEnabled global list<ParStatus> parStatusList;
       @AuraEnabled global list<string> dateRange;
       @AuraEnabled global string dateVersion;
       @AuraEnabled public ACETOILError[] errors;
       @AuraEnabled global List<AccumulatorCode> accumulatorCodeList;
        
        
    }
    
    global class ParStatus{
       @AuraEnabled global string parStatusKey;
       @AuraEnabled global list<GeneralCode> generalCodeList;
               global string benefitTier;
 
    }
    
    global class GeneralCode{
       @AuraEnabled global String benefitLevel;
       @AuraEnabled global Integer benefitLevelCode;
       @AuraEnabled global string coverageIndicator;
       @AuraEnabled global string benefitCodeGeneralLanguage;
       @AuraEnabled global string languageEffectiveIndicator;
       @AuraEnabled global string benefitCodeLanguage;
       @AuraEnabled global string ageFrom;
       @AuraEnabled global string ageFromDuration;
       @AuraEnabled global string ageThrough;
       @AuraEnabled global string ageThroughDuration;
       @AuraEnabled global List<string> billTypeSetCategory;
       @AuraEnabled global string networkId;
       @AuraEnabled global string relationshipCode;
       @AuraEnabled global string benefitLevelDescription;
       @AuraEnabled global string benefitVersion;
       @AuraEnabled global string benefitCodeEffectiveDate;
       @AuraEnabled global string benefitCodeExpirationDate;
       @AuraEnabled global string calculationBasis;

    }
    
    global class AccumulatorCode implements Comparable {
        @AuraEnabled global string BenefitKey; 
        @AuraEnabled global string coverageType;
        @AuraEnabled global string coverageLevel;
        @AuraEnabled global string costShareType;
        @AuraEnabled global string benefitMaximumValue;
        @AuraEnabled global string benefitMaximumUnit;
        @AuraEnabled global string benefitYTDValue;
        @AuraEnabled global string benefitRemainingValue;
        @AuraEnabled global string duration;
        @AuraEnabled global string dateVersion;
        @AuraEnabled global string dateRangeValue;
        @AuraEnabled global string costShareId;
        @AuraEnabled global list<string> dateRange;
        public Integer compareTo(Object ObjToCompare) {
            return coverageLevel.CompareTo(((AccumulatorCode)ObjToCompare).coverageLevel)*-1;
        }
     
  }

}