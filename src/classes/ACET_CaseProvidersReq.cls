public with sharing class ACET_CaseProvidersReq {

	public class ProviderRoles {
		@AuraEnabled public List<ProviderRole> providerRole  {get; set;}
	}

	public class HscProviders {
		@AuraEnabled public List<HscProvider> hscProvider  {get; set;}
	}

	@AuraEnabled public String transactionId  {get; set;}
	@AuraEnabled public Metadata metadata;
	@AuraEnabled public InvocationContext invocationContext;
	@AuraEnabled public Member member  {get; set;}
	@AuraEnabled public HscProviders hscProviders  {get; set;}

	public class ProviderIdentifiers {
		@AuraEnabled public List<ProviderIdentifier> providerIdentifier  {get; set;}
	}

	public class ProviderIdentifier {
		@AuraEnabled public String providerIDType  {get; set;}
		@AuraEnabled public String providerIDText  {get; set;}
	}

	public class Metadata {
		public String clientNPI;
		public String clientLocation;
		public String clientGroup;
		public String clientBusiness;
		public String caseSubmissionTransactionID;
	}

	public class ProviderRole {
		@AuraEnabled public String providerRole  {get; set;}
	}

	public class InvocationContext {
		public String userIDType;
		public String userID;
		public String serviceCorrelationID;
		public String locationID;
		public String clientID;
		public String clientCorrelationID;
	}

	public class HscProvider {
		@AuraEnabled public ProviderRoles providerRoles  {get; set;}
		@AuraEnabled public ProviderIdentifiers providerIdentifiers  {get; set;}
		@AuraEnabled public String providerCategory  {get; set;}
		@AuraEnabled public String firstName  {get; set;}
		@AuraEnabled public String middleName  {get; set;}
		@AuraEnabled public String lastName  {get; set;}
		@AuraEnabled public String providerSeqNum  {get; set;}
		@AuraEnabled public String address1  {get; set;}
		@AuraEnabled public String city  {get; set;}
		@AuraEnabled public String state  {get; set;}
		@AuraEnabled public String zip  {get; set;}
		@AuraEnabled public String zipSuffix  {get; set;}
		@AuraEnabled public String providerTerminationDate  {get; set;}
		@AuraEnabled public String businessName  {get; set;}
		@AuraEnabled public String providerEffectiveDate  {get; set;}
	}

	public class Member {
		@AuraEnabled public String platform  {get; set;}
		@AuraEnabled public String subscriberID  {get; set;}
		@AuraEnabled public String xrefId  {get; set;}
		@AuraEnabled public String xrefIdPartitionNumber  {get; set;}
		@AuraEnabled public String sourceCode  {get; set;}
		@AuraEnabled public String claimSourceSystemCode  {get; set;}
		@AuraEnabled public String policyNumber  {get; set;}
		@AuraEnabled public String firstName  {get; set;}
		@AuraEnabled public String lastName  {get; set;}
		@AuraEnabled public String middleName  {get; set;}
		@AuraEnabled public String genderCode  {get; set;}
		@AuraEnabled public String sourceId  {get; set;}
		@AuraEnabled public String dob  {get; set;}
		@AuraEnabled public String effectiveStartDate  {get; set;}
		@AuraEnabled public String stateOfIssueCode  {get; set;}
		@AuraEnabled public String effectiveEndDate  {get; set;}
		@AuraEnabled public String governmentProgramCode  {get; set;}
		@AuraEnabled public String tciTableNumber  {get; set;}
		@AuraEnabled public String marketSite  {get; set;}
		@AuraEnabled public String marketType  {get; set;}
		@AuraEnabled public String productCode  {get; set;}
		@AuraEnabled public String sharedArrangementCode  {get; set;}
		@AuraEnabled public String obligorID  {get; set;}
		@AuraEnabled public String cosmosDivision  {get; set;}
		@AuraEnabled public String groupPanelNumber  {get; set;}
		@AuraEnabled public String reportingCode  {get; set;}
		@AuraEnabled public String databaseMemberId  {get; set;}
		@AuraEnabled public String memberID  {get; set;}
		@AuraEnabled public String alternateId  {get; set;}
		@AuraEnabled public String individualIdentifier  {get; set;}
		@AuraEnabled public String mbi  {get; set;}
		@AuraEnabled public String lineOfBusiness  {get; set;}
		@AuraEnabled public String coverageTypeCode  {get; set;}
		@AuraEnabled public String cirrusMCHID {get; set;}
	}

	
	public static ACET_caseProvidersReq parse(String json) {
		return (ACET_caseProvidersReq) System.JSON.deserialize(json, ACET_caseProvidersReq.class);
	}
}