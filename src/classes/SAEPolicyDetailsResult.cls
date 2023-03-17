public  class SAEPolicyDetailsResult {

    @AuraEnabled public policyResults policyRes {get;set;}

    public class policyResults {
		@AuraEnabled public String mbi {get;set;}
        @AuraEnabled public String sourceCode {get;set;}
        @AuraEnabled public String sourceCodeDetail {get;set;}
        @AuraEnabled public String timelyFilling {get;set;} //GAP
        @AuraEnabled public String MaintenanceDate {get;set;} //GAP
        @AuraEnabled public String payerId {get;set;} //GAP
        @AuraEnabled public String claimsMailingAddress {get;set;}
        @AuraEnabled public String fundingArrangement {get;set;}
        @AuraEnabled public String sharedSavings {get;set;} //GAP
        @AuraEnabled public String regionCode {get;set;} //GAP
        @AuraEnabled public String groupName {get;set;}
        @AuraEnabled public String marketType {get;set;}
        @AuraEnabled public String insuranceTypeCode {get;set;}
        @AuraEnabled public String fundingType {get;set;}
        @AuraEnabled public String groupNumber {get;set;}
        @AuraEnabled public String productType {get;set;}
        @AuraEnabled public String stateOfIssueCode {get;set;} //AKA HealthPlan
        @AuraEnabled public String HealthPlanSite {get;set;} //GAP
        @AuraEnabled public String productId {get;set;} //AKA NetworkType
        @AuraEnabled public String cosmosDivision {get;set;} //AKA DIV
        @AuraEnabled public String coverageStartDate {get;set;} //yyyy-mm-dd
        @AuraEnabled public String groupPanelNumber {get;set;} //AKA Panel
        @AuraEnabled public String EEID {get;set;} //US2253388 - Member Subject Card/Member Snapshot - Integrate EEID-Durga
        @AuraEnabled public String providerDiv {get;set;} //US3574032

        @AuraEnabled public Boolean isPHSPlan {get;set;}
        @AuraEnabled public Boolean isMedicarePlan {get;set;}
        @AuraEnabled public Boolean isMedicaidPlan {get;set;}
        @AuraEnabled public Boolean isComPlan {get;set;}

        //US1827051 - Show only core fields - Sanka - 06/06/2019
        @AuraEnabled public Boolean showAllFields {get;set;}

        //US1901028	- Member CDHP Integration - Sarma - 29/08/2019
        @AuraEnabled public Boolean isCdhp {get;set;}
        @AuraEnabled public Boolean isHsa {get;set;}

        //US2154799
        @AuraEnabled public String xrefId {get;set;}
        @AuraEnabled public String xrefIdPartitionNumber {get;set;} //Avish - CreateAuth
		@AuraEnabled public String coverageLevel {get;set;}
        @AuraEnabled public String tciTableNumber {get;set;}
        @AuraEnabled public String lineofBusiness {get;set;}

        // US1814440 Wrap to IBAAG/PASS for E&I Sarma - 13/02/2020
        @AuraEnabled public String benefitPackageLogNumber {get;set;} //AKA set number
        @AuraEnabled public String platform {get;set;} 
        @AuraEnabled public String policyNumber {get;set;}

        //US2098648 - Sanka - ORS Case Integration
        @AuraEnabled public String alternateId {get;set;}

        //US2563008-Member Snapshot - Phone Number Integration - Sravan - 28/04/2020
        @AuraEnabled public String homeTelephoneNumber {get;set;}

        //US1944144 - 03/19/2020 Avish
        @AuraEnabled public String nonEmbeddedFamilyStatusIndicator {get;set;}

        // US2623985 - Thanish - 10th Jun 2020
        @AuraEnabled public String marketSite {get;set;}

         //US2784325 - TECH: Case Details - Caller ANI/Provider Add'l Elements Mapped to ORS - Durga
         @AuraEnabled public String dependentSequenceNumber {get;set;}
         @AuraEnabled public String pcptaxId {get;set;}

        // US2678249 TECH - Offshore Restriction: Validate data from Proper Use API - Sarma - 26/06/2020
        @AuraEnabled public List<String> policyRestrictionLevelList {get;set;}
        @AuraEnabled public Boolean isOffShoreUser {get;set;}
        @AuraEnabled public Boolean isSpireCreateAuthUser {get;set;}

        //US2382444 tier 1 request - Vinay
         @AuraEnabled public String sharedArrangement {get;set;}
         @AuraEnabled public String obligorID {get;set;}
         @AuraEnabled public String productCode {get;set;}
         @AuraEnabled public String rulesPackageKey {get;set;}
         @AuraEnabled public String unitedHealthPremiumDesignation {get;set;}
         @AuraEnabled public String entityType {get;set;}
         @AuraEnabled public String relationshipCode {get;set;}
         @AuraEnabled public String claimSourceSystemCode {get;set;}
         @AuraEnabled public String eligibilitySourceSystemCode {get;set;}
         
        //  US2696849 - Thanish - 22nd Jul 2020
         @AuraEnabled public String subscriberID {get;set;}
         @AuraEnabled public String coverageLevelNum {get;set;}

        // US2356250 - PCP History Integration
        // Sanka Dharmasena - 14/08/2020
        @AuraEnabled public List<SAEPolicyDetailsResult.PCPHistroy> pcpHistoryList{get;set;}

        //  US2917371 - Thanish - 7th Dec 2020
        @AuraEnabled public SAEPolicyDetailsResult.PrimaryCareProvider primaryCareProvider{get;set;}
        //US3001202 Jitendra
        @AuraEnabled public string benefitPlanId {get;set;}
        // US3244384 Integration for Member Div to Provider Div Mapping - Sarma - 01/03/2021
        @AuraEnabled public string coverageEndDate {get;set;}
	
	//US3314325 - Sanka
        @AuraEnabled public string medicareEntitlementReason{get;set;}
        @AuraEnabled public string medicareIndicator{get;set;}

        @AuraEnabled public MemberInfo memberInfo {get;set;} //US3587915
        @AuraEnabled public String reportingCode {get;set;} //US3587915
    }

    // US2917371 - Thanish - 7th Dec 2020
    public class PrimaryCareProvider{
        @AuraEnabled public String pcpFirstName{get; set;}
        @AuraEnabled public String pcpMiddleName{get; set;}
        @AuraEnabled public String pcpLastName{get; set;}
        @AuraEnabled public String providerNpi{get; set;}
        @AuraEnabled public String taxId{get; set;}
        //US3086530
        @AuraEnabled public string pcpPhoneNumber{get;set;}
        @AuraEnabled public string pcpSpeciality{get;set;}
        @AuraEnabled public string pcpProvideraddressLine1{get;set;}
        @AuraEnabled public string pcpProvideraddressLine2{get;set;}
        @AuraEnabled public string pcpProvidercity{get;set;}
        @AuraEnabled public string pcpProviderstate{get;set;}
        @AuraEnabled public string pcpProviderzip{get;set;}
        @AuraEnabled public string pcpEndDate{get;set;}//add by vishnu
        @AuraEnabled public string pcpStartDate{get;set;}//add by vishnu
        @AuraEnabled public string acoNetworkId{get;set;}//add by vishnu
        @AuraEnabled public string acoNetworkDescription{get;set;}//add by vishnu
    }

    public class Members {

    }

    //US1974546 - Coverage Level Integration
    //Sanka Dharmasena - 28/08/2019
    public class ProviderCoverageLevel
    {
        @AuraEnabled public String CoverageLevel{get;set;}
        @AuraEnabled public Boolean Success{get;set;}
        @AuraEnabled public Integer StatusCode{get;set;}
        @auraEnabled public String Message{get;set;}
        //USS2221006
        @AuraEnabled public String GroupNumber{get;set;}
        @AuraEnabled public String sourceCode{get;set;}
    }

    // US2356250 - PCP History Integration
    // Sanka Dharmasena - 14/08/2020
    public class PCPHistroy
    {
        @AuraEnabled public String StartDate{get;set;}
        @AuraEnabled public String EndDate{get;set;}
        @AuraEnabled public String ProviderGroupNumber{get;set;}
        @auraEnabled public String ProviderGroupName{get;set;}
        @auraEnabled public String ProviderGroupNameShort{get;set;}
        @AuraEnabled public String PCPNumber{get;set;}
        @AuraEnabled public String PCPName{get;set;}
        @AuraEnabled public String PCPNameShort{get;set;}
        @AuraEnabled public String TaxId{get;set;}
    }
    //US3587915 - Create Auth : Call new API for Case Provider Search Provider  Mappings - Sarma- 03rd June 2021
    public class MemberInfo {
		@AuraEnabled public String relationship{get;set;}
		@AuraEnabled public String firstName{get;set;}
		@AuraEnabled public String lastName{get;set;}
        @AuraEnabled public String middleName{get;set;}
		@AuraEnabled public String dob{get;set;}
		@AuraEnabled public String memberID{get;set;}
		@AuraEnabled public String genderCode{get;set;}
		@AuraEnabled public List<ServiceBenefitDetails> members{get;set;}
		@AuraEnabled public String dos{get;set;}
	}
    public class ServiceBenefitDetails {
	}
}