public without sharing class ADBFinancialOverViewResponseWrapper {
    
    public class Deductible {
		public Individual individual {get;set;}
		public Family family {get;set;}
    }

    public class AccountFunding {
		public String benefitAmount {get;set;}
		public String carryOverAmount {get;set;}
		public String carryOverBalanceAmount {get;set;}
		public String carryOverIndicator {get;set;}
		public String employeeContributionAmount {get;set;}
		public String employeeContributionIndicator {get;set;}
		public String employeeElectedAmount {get;set;}
		public String employerContributionAmount {get;set;}
		public String employerContributionIndicator {get;set;}
		public String employerContributionLessIncentiveAmount {get;set;}
		public String incentiveIndicator {get;set;}
		public String legacyFundingAmount {get;set;}
		public String prefundAmount {get;set;}
		public String prefundIndicator {get;set;}
		public String totalRefunds {get;set;}
	        public FilingStatus filingStatus {get;set;}
	        public ContributionLimit contributionLimit {get;set;}
	}
    public class FilingStatus{
		public String currentYearFilingStatus {get;set;}
		public String priorYearFilingStatus {get;set;}
    }
    public class ContributionLimit{
		public String currentYearContributionLimit {get;set;}
		public String priorYearContributionLimit {get;set;}
    }
    public class Account {
		public String accountNumberId {get;set;}
		public AccountType accountType {get;set;}
		public List<AccountPlanYear> accountPlanYear {get;set;}
		public String accountSystemCode {get;set;}
		public String displaySequence {get;set;}
    }

    public class Eligibility {
		public String policyNumber {get;set;}
		public List<BenefitSet> benefitSet {get;set;}
    }

	public Data data {get;set;}

	public ADBFinancialOverViewResponseWrapper(JSONParser parser) {
	}

    public class AccountEFT {
		public String eftIndicator {get;set;}
		public String eftDisposition {get;set;}
		public String minimumCheckAmount {get;set;}
		public String withdrawalFrequencyIndicator {get;set;}
    }

    public class NetworkStatusCode {
		public String code {get;set;}
    }

    public class PlanLevel {
		public Deductible deductible {get;set;}
		public Oop oop {get;set;}
    }

    public class SplitDeductible {
		public String accessPointRemainingAmount {get;set;}
		public String appliedAmount {get;set;}
		public String appliedToAccessPoint {get;set;}
		public String deductibleTypeCode {get;set;}
		public String firstName {get;set;}
		public String hraAccessibleIndicator {get;set;}
		public String lastName {get;set;}
		public String phiIndicator {get;set;}
		public String remainingBalanceAmount {get;set;}
	}

    public class PlanBenefitSet {
		public String nonEmbeddedFamilyStatusIndicator {get;set;}
		public String physicianSharedSavingsIndicator {get;set;}
		public List<PlanBenefitLevel> planBenefitLevel {get;set;}
	}

    public class Family_Z {
		public String planFamilyOOPRemaining {get;set;}
		public String familyCopayYTD {get;set;}
		public String planFamilyCoreRemaining {get;set;}
		public String oopYTDAmount {get;set;}
		public String familyCoreYTD {get;set;}
		public String planFamilyCopayRemaining {get;set;}
		public String planFamilyOOP {get;set;}
		public String familyCore {get;set;}
        public String familyCopayMax {get;set;}
    }

    public class AccountBalance {
		public String claimAmount {get;set;}
		public String claimPaidAmount {get;set;}
		public String currentBalanceAmount {get;set;}
		public String totalBalance {get;set;}
		public String paidAmount {get;set;}

    }

    public class AccountDeductible {
		public String familyAccessPoint {get;set;}
		public String hraIncentiveAmount {get;set;}
		public String individualAccessPoint {get;set;}
		public String individualMaxReimbursementAmount {get;set;}
		public String individualMaxReimbursementIndicator {get;set;}
		public String splitDeductibleIndicator {get;set;}
		public List<SplitDeductible> splitDeductible {get;set;}
	}

    public class EffectiveDateRange {
		public String startDate {get;set;}
		public String stopDate {get;set;}
    }

    public class PlanDetailsResult {
        public List<Member> member {get;set;}
    }
    public class PlanDetail {
		public PlanDetailsResult planDetailsResult {get;set;}
        public String planDetailsError {get;set;}
    }

    public class Member {
		public String dependentSeqNbr {get;set;}
		public String planKey {get;set;}
		public Eligibility eligibility {get;set;}
    }

    public class PlanBenefitLevel {
		public NetworkStatusCode networkStatusCode {get;set;}
		public String reverseTieredIndicator {get;set;}
		public PlanLevel planLevel {get;set;}
    }

    public class AccountBalanceResult {
        public List<Account> account {get;set;}
        public String accountBalanceError {get;set;}
    }

    public class AccountBalance_Z {
		public AccountBalanceResult accountBalanceResult {get;set;}
    }

    public class MemberDetail {
		public String ssn {get;set;}
		public String firstName {get;set;}
		public String lastName {get;set;}
    }

    public class Data {
		public PlanDetail planDetail {get;set;}
		public AccountBalance_Z accountBalance {get;set;}
		public Faro faro {get;set;}
    }

    public class AccountType {
		public String code {get;set;}
		public String desc_Z {get;set;} // in json: desc
    }

    public class Oop {
		public Individual_Z individual {get;set;}
		public Family_Z family {get;set;}
    }

    public class Transactions {
		public String amount {get;set;}
		public String description {get;set;}
		public String processedDate {get;set;}
		public String status {get;set;}
		public String type_Z {get;set;} // in json: type
    }

    public class AccountPlanYear {
		public EffectiveDateRange effectiveDateRange {get;set;}
		public AccountEFT accountEFT {get;set;}
		public AccountBalance accountBalance {get;set;}
		public AccountFunding accountFunding {get;set;}
		public AccountDeductible accountDeductible {get;set;}
		public String statusCode {get;set;}
    }

    public class Individual {
		public String ytdAmount {get;set;}
		public String planIndividualRemainingDeductibleAmount {get;set;}
		public String deductibleAmount {get;set;}
    }

    public class Family {
		public String ytdAmount {get;set;}
		public String planFamilyRemainingDeductibleAmount {get;set;}
		public String deductibleAmount {get;set;}
    }

    public class Faro {
		public MemberDetail memberDetail {get;set;}
		public List<Accounts> accounts {get;set;}
		public String error {get;set;}
    }

    public class BenefitSet {
		public List<PlanBenefitSet> planBenefitSet {get;set;}
    }

    public class Individual_Z {
		public String individualCoreYTD {get;set;}
		public String oopYTDAmount {get;set;}
		public String planIndividualCopayRemaining {get;set;}
		public String planIndividualOOP {get;set;}
		public String individualCopayYTD {get;set;}
		public String planIndividualCoreRemaining {get;set;}
		public String individualCore {get;set;}
		public String planIndividualOOPRemaining {get;set;}
        public String individualCopayMax {get;set;}
    }

    public class Accounts {
 		public String spendingCardType{get;set;}
 		public String coordinatedPayment{get;set;}
 		public String preFunded{get;set;}
 		public String allowCoordPayOver{get;set;}
 		public String disableOverrideFromPortal{get;set;}
 		public String carryoverIndicator{get;set;}
 		public String acctPlanYearGracePeriodExpirationDate{get;set;}
		public String accountCode {get;set;}
		public String accountNumber {get;set;}
		public String accountType {get;set;}
		public String investedBalance {get;set;}
		public List<Transactions> transactions {get;set;}
		public String accountError {get;set;}
    }


}