/*
 * @Desc: US1956058 - Deserialize Claim Details Response
 * @Date: 19-08-2019
 * @Dev: Malinda
*/
public class SAEEligibilityClaimDetailsJSON2Apex {
    
    @AuraEnabled public String transactionId {get;set;}
	@AuraEnabled public List<ClaimsDetailInfo> claimsDetailInfo {get;set;}

	public class ClaimCodes {
		@AuraEnabled public String type {get;set;}
		@AuraEnabled public String code {get;set;}
		@AuraEnabled public String description {get;set;}
	}

    public class ReimbursementPolicy {
		@AuraEnabled public String icesCode {get;set;}
		@AuraEnabled public String policyName {get;set;}
	}

	public class CobInfo {
		@AuraEnabled public String claimOIPaidAmt {get;set;}
		@AuraEnabled public String otherInsuredNm {get;set;}
		@AuraEnabled public String primaryImpact {get;set;}
	}

	public class DiagnosisCodes {
		@AuraEnabled public String diagnosisCode {get;set;}
		@AuraEnabled public String submtPOAInd {get;set;}
	}

	public class DiagnosisPtrs {
		@AuraEnabled public String diagnosisPtr {get;set;}
	}

	public class ClaimsDetailInfo {
		@AuraEnabled public String claimNumber {get;set;}
        @AuraEnabled public String reimbursementPolicyURL {get;set;}
        @AuraEnabled public String icn {get;set;}
		@AuraEnabled public CobInfo cobInfo {get;set;}
		@AuraEnabled public List<DiagnosisCodes> diagnosisCodes {get;set;}
        @AuraEnabled public List<ReimbursementPolicy> reimbursementPolicy {get;set;}
		@AuraEnabled public List<Lines> lines {get;set;}
        @AuraEnabled public List<PaymentInfo> paymentInfo {get;set;}
        @AuraEnabled public String dccflnNbr{get;set;}
        @AuraEnabled public String providerTin{get;set;}
        @AuraEnabled public String electronicPayerID{get;set;}

		// US3464932
		@AuraEnabled public String placeOfService{get;set;}
        //Referral Number Changes
        @AuraEnabled public String referralNumber{get;set;}
	}

    public class Modifiers {
		@AuraEnabled public String modifierCode {get;set;}
	}

   public class PaymentInfo {
		@AuraEnabled public String checkNumber {get;set;}
		@AuraEnabled public String chkSrsDesg {get;set;}
		@AuraEnabled public Double chkAmount {get;set;}
	}

	public class Lines {
		@AuraEnabled public String lineNbr {get;set;}
		@AuraEnabled public String processedDt {get;set;}
		@AuraEnabled public String firstSrvcDt {get;set;}
		@AuraEnabled public String lastSrvcDt {get;set;}
		@AuraEnabled public String srvcCode {get;set;}
        @AuraEnabled public List<Modifiers> modifiers {get;set;}
		@AuraEnabled public String paidAmt {get;set;}
		@AuraEnabled public String allowdAmt {get;set;}
		@AuraEnabled public String provWrtOffAmt {get;set;}
		@AuraEnabled public String notCovAmt {get;set;}
		@AuraEnabled public String totalMemResp {get;set;}
        @AuraEnabled public String causeCd {get;set;}
		@AuraEnabled public String copay {get;set;}
		@AuraEnabled public String deductible {get;set;}
		@AuraEnabled public String coinsurance {get;set;}
		@AuraEnabled public List<ClaimCodes> claimCodes {get;set;}
		@AuraEnabled public String billedAmt {get;set;}
        @AuraEnabled public String ovrCd {get;set;}
        @AuraEnabled public String planCoveragePercent {get;set;}
        @AuraEnabled public String icnSuffix {get;set;}
        @AuraEnabled public String priorAuthNbr {get;set;}
        @AuraEnabled public Double nySurchrgPaidAmt {get;set;}
		@AuraEnabled public String networkStatus {get;set;}
		@AuraEnabled public String medicarePaidAmt {get;set;}
		@AuraEnabled public String reserveAmt {get;set;}
		@AuraEnabled public String unitCount {get;set;}
		@AuraEnabled public String provNotCovAmt {get;set;}
		@AuraEnabled public String ptntNoCovAmt {get;set;}


        @AuraEnabled public String interestPaidAmt {get;set;}
        //@AuraEnabled public String reserveAmt {get;set;}

        //Ketki 11/5/2020 US2338191
        @AuraEnabled public String procedureCd {get;set;}
		@AuraEnabled public String processedTime {get;set;}
        public String lineLevelPlaceOfService { get;set;}
        //sravani servicelines
        @AuraEnabled public String revenueCode {get;set;}

		// US3464932
		@AuraEnabled public List<DiagnosisPtrs> diagnosisPtrs{get;set;}

	}
    
    public static SAEEligibilityClaimDetailsJSON2Apex parse(String json) {
		return (SAEEligibilityClaimDetailsJSON2Apex) System.JSON.deserialize(json, SAEEligibilityClaimDetailsJSON2Apex.class);
	}

}