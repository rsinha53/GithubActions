public class ACET_MedNecServiceResponse {

    public searchResult searchResult;
	public class searchResult {
		public errors[] errors;
		public searchOutput searchOutput;
	}
	public class errors {
		public Integer code;	
		public String name;	
		public String severity;	
		public String origin;	
		public String description;	
	}
	public class searchOutput {
		public String relatedServiceIndicator;	
		public String priorAuthorizationIndicator;
		public String radiologyAuthorizationIndicator;
		public String cardiologyAuthorizationIndicator;
		public String chemotherapyPriorAuthorizationIndicator;
		public String geneticTestingPriorAuthorizationIndicator;
		public String policyPlanParticipationIndicator;
		public claims[] claims;
		public searchOutputMeta searchOutputMeta;
	}
	public class claims {
		public String filmOfficeNumber;
		public String filmLocatorNumber;
		public String filmLocatorDate;
		public String auditControlNumber;
		public String auditControlNumberSuffixCode;
		public String draftNumber;
		public String headerCount;
		public String firstServiceDate;
		public String lastServiceDate;
		public String processedDate;
		public String processedTime;
		public String claimType;
		public String providerTaxIdPrefix;
		public String providerTaxId;
		public String providerTaxIdSuffix;
		public String providerName;
		public String providerFirstName;
		public String providerLastName;
		public String totalCharged;
		public String totalDeductible;
		public String totalPaid;
		public String claimStatus;
		public String closedFlag;
		public String paidFlag;
		public String pendedFlag;
		public String rejectedFlag;
		public String unprocessedFlag;
		public String adjudicateIndicator;
		public String remarkCode;
		public String source;
		public String paidStatus;
		public String ppoIndicator;
		public String tier1ProcessIndicator;
		public String claimProtectedHealthIndicator;
		public String authorizationNumber;
		public String authorizationSourceId;
		public String authorizationProcedureCode;
		public String authorizationClaimLevelIndicator;
		public String authorizationUniqueCount;
		public String primaryDiagnosis;
		public String claimIndicator;
		public String parsWaivIndicator;
		public String parIndicator;
		public String nonParIndicator;
		public String deductibleFlag;
		public String memberId;
		public String memberIdPrefix;
		public String groupPolicy;
		public String dependentNumber;
		public String firstName;
		public String lastName;
		public String relationshipCode;
		//public String system;
		public String planVariationCode;
		public String reportingCode;
		public String fundingResponsibility;
		public String patientPhiIndicator;
		public String uhpIndicator;
		public String providerTier;
		public String tpsmServiceCode;
		public String delegatedEncounterIndicator;
		public String mskIndicator;
		public String totalPatientResponsibility;
		public String providerSpecialty;
		public String contractId;
	}
	public class searchOutputMeta {
		public pagingState pagingState;
	}
	public class pagingState {
		public boolean moreData;
		public String nextKey;
	}
	public static ACET_MedNecServiceResponse parse(String json){
		return (ACET_MedNecServiceResponse) System.JSON.deserialize(json, ACET_MedNecServiceResponse.class);
	}

}