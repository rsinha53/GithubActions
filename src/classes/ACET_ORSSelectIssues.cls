public class ACET_ORSSelectIssues {

	public class OriginatorInfo {
		public String originatorMPIN;
		public String originatorTIN;
		public String originatorSuffix;
		public String originatorId;
	}

	public class AssociateName {
		public String firstName;
		public String lastName;
	}

	public class MemberInfo {
		public AssociateName dependentName;
		public String groupNumber;
		public String groupName;
		public String product;
		public String memberNumber;
		public String policy;
		public String alternateId;
		public String eligibilitySourceSystem;
		public String primaryPolicyNumber;
		public String sharedArrangementId;
		public String obligorId;
		public String logoIndicator;
		public String fontIndicator;
		public String planCode;
		public String benefitPackageCode;
		public String regionCode;
		public String ipaCode;
		public String panelCode;
		public String source;
	}

	public class ProviderInfo {
		public String productCode;
		public String panelNumber;
		public String ipa;
		public String sourceSystem;
		public String firstInitial;
		public String lastName;
		public String mpin;
	}

	public SearchResult searchResult;

	public class IssuesList {
		public String issueId;
		public String reasonCode;
		public String statusCode;
		public String status;
		public String contactMethodCode;
		public String contactMethodDescription;
		public String originatorTypeCode;
		public String originatorTypeDescription;
		public String originatedDate;
		public String originatedTime;
		public String comment;
		public String updateDate;
		public AssociateName associateName;
		public String businessSegmentName;
		public String subReasonText;
		public String complaintCategoryText;
		public String reasonCategory;
		public String followupStatusCode;
		public String followupStatusDescription;
		public String followupPurposeCode;
		public String claimNumber;
		public String claimAuthorization;
		public String claimServiceDate;
		public String claimCount;
		public String hippa;
		public String extrClaimNumber;
		public String extrSubscriberId;
		public String origOfficeNumber;
		public String ownerOfficeId;
		public String ownerDepartmentCode;
		public MemberInfo memberInfo;
		public ProviderInfo providerInfo;
		public OriginatorInfo originatorInfo;
		public OtherInfo otherInfo;
		public ServiceRequest serviceRequest;
		public String contactReasonDescription;
	}

	public class AlertsList {
	}

	public class SearchResult {
		public SearchOutput searchOutput;
	}

	public class SearchOutput {
		public List<IssuesList> issuesList;
		public List<AlertsList> alertsList;
		public PagingState pagingState;
	}

	public class PagingState {
		public Boolean moreData;
		public String nextIssueKey;
	}

	public class ServiceRequest {
		public String srProductType;
		public String srType;
		public String srSubType;
	}

	public class OtherInfo {
		public String agencyName;
		public String agencyTaxId;
		public String agencyUniqueId;
	}

	
	public static ACET_ORSSelectIssues parse(String json) {
		return (ACET_ORSSelectIssues) System.JSON.deserialize(json, ACET_ORSSelectIssues.class);
	}
}