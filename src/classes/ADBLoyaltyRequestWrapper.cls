public without sharing class ADBLoyaltyRequestWrapper {
    
    public ReadInput readInput{ get; set; }
    
    public class ReadInput{
        public ControlModifiers controlModifiers{ get; set; }
        public String  searchId{ get; set; }
        public String  policyNumber { get; set; }
        public String  sourceCode{ get; set; }
        public String  requestFamilyOrIndividual{ get; set; }
        public String  asOfDate{ get; set; }
        public String  requestCoverageTimeline{ get; set; }
        public String  requestDemographic{ get; set; }
        public String  requestHealthServices{ get; set; }
        public String  requestFamilyLastUpdateDate{ get; set; }
        public String  requestEmail{ get; set; }
        public String  blsEligibilityInd{ get; set; }
        public String  requestCamsDemographic{ get; set; }
        public String  requestExpandedCoverageTimelines{ get; set; }
        public String  requestPrimeLifeAndDisability{ get; set; }
        public String  requestMemberPopulation{ get; set; }
        
        //  Sanka - US2750324
        public String requestHealthCoverage;
        public String requestCobAndMedicare;
        public String requestLifeAndDisability;
        public String requestFinancial;
        public String requestPreExist;
        public String requestComments;
        public String requestTopsCancelDate;
        public String requestVendorAndCalendar;
        public String requestCobAndMedicarePrimarySecondary;
        public String requestPolicyAmounts;
        public String requestMedicareAndCobDemographic;
        public String requestAuthorizedRepresentative;
        public String requestCptin;
        public String requestDocumentLetterSuppression;
        public String requestMemberLoyalty;
        
        public ReadInput()
        {
            this.requestHealthCoverage = '';
            this.requestCobAndMedicare = '';
            this.requestLifeAndDisability = '';
            this.requestFinancial = '';
            this.requestPreExist = '';
            this.requestComments = '';
            this.requestTopsCancelDate = '';
            this.requestVendorAndCalendar = '';
            this.requestCobAndMedicarePrimarySecondary = '';
            this.requestPolicyAmounts = '';
            this.requestMedicareAndCobDemographic = '';
            this.requestAuthorizedRepresentative = '';
            this.requestCptin = '';
            this.requestDocumentLetterSuppression = '';
            this.requestMemberLoyalty = '';
        }
    }
    
    public class ControlModifiers{
        public CdbSystemParameters cdbSystemParameters;
        public NdbSystemParameters ndbSystemParameters;
        public String requestCodeDescriptionLookup;
        public String requestProviderDemographic;
        public String requestTopsEligibilityInformation;
        public String requestWrittenLanguagePreference;
    }
    
    public class CdbSystemParameters{
        public String applicationId;
        public String roleId;
    }
    
    public class NdbSystemParameters{
        public String platformId;
        public String projectId;
    }
}