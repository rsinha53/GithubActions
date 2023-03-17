public class ACETPlanBenefitRedesignLanguageJson2Apex {
   public getBenefitLanguageResponse getBenefitLanguageResponse;
    public class getBenefitLanguageResponse {
        public benefitSection[] benefitSection;
        public ACETOILError[] errors;
    }
    public class benefitSection {
        public String benefitName;  //Office Physical Therapy Autism
        public String benefitCode;  //PHYSICAL_THERAPY_AUTISM_OFFICE
      //  public hipaaService[] hipaaService;
        public benefitTierSection[] benefitTierSection;
    }
  /*  public class hipaaService {
        public String serviceTypeCode;  //AE
        public String serviceTypeDescription;   //Physical Medicine
    } */
    public class benefitTierSection {
        public String benefitTier;  //7
        public String benefitTierDescription;   //Core Benefits from Choice Plus
        public String parStatusType;    //INN
        public benefitCodeLanguageSection[] benefitCodeLanguageSection;
    }
    public class benefitCodeLanguageSection {
        public String benefitLevel; //1
        public String benefitVersion;   //1
        public String ageFrom;  //1
        public String ageFromDuration;  //Years
        public String ageThrough;   //65
        public String ageThroughDuration;   //Years
        public String languageEffectiveIndicator;  //Years
        public String coverageIndicator;    //0
        public String benefitCodeGeneralLanguage;   //Autism and Developmental Disabilities Outpatient rehabilitation includes physical, speech and occupational therapy.  Coverage is available based upon medical necessity. (Age Limit and Coverage differentiations pending Cirrus Update)
        public String benefitCodeLanguage;  //Care rendered by a participating provider is covered subject to the deductible, copayment, coinsurance and usual and customary allowance as applicable (Cost Share differentiations pending Cirrus Update).
        public List<String> billTypeSetCategory;
        public String benefitCodeEffectiveDate;
        public String benefitCodeExpirationDate;
        Public String calculationBasis;

    }
    
    public class relationshipCode {
    
    }
    
    public class errors {
        public Integer code;  //404
        public String name;  //NOT_FOUND
        public String severity;  //FAULT
        public String origin;  //eisl
        public String description;  //(C360-NOT-FOUND): Unable to find data source: benefits
      }
    
    public static ACETPlanBenefitRedesignLanguageJson2Apex  parse(String json){
        return (ACETPlanBenefitRedesignLanguageJson2Apex ) System.JSON.deserialize(json, ACETPlanBenefitRedesignLanguageJson2Apex .class);
    }
}