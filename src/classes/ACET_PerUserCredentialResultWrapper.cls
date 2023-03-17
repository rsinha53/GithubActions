public class ACET_PerUserCredentialResultWrapper {

	public class Authorization {
		public String inquireIssues;
		public String updateIssues;
		public String assignIssues;
		public String receiveIssues;
		public String routeIssues;
		public String modifyGrievance;
		public String overrideDepartment;
		public String overrideTeam;
		public String overrideOperatorID;
		public String sal;
	}

	public class PostResult {
		public List<Errors> errors;
		public UserProfile userProfile;
		public List<UserTokens> userTokens;
	}

	public class AssociateName {
		public String firstName;
		public String lastName;
	}

	public PostResult postResult;

	public class UserProfile {
		public String userId;
		public String unitId;
		public String expiryDate;
		public String expiryTime;
		public String officeNumber;
		public String departmentCode;
		public String teamCode;
		public String operatorId;
		public AssociateName associateName;
		public String phone;
		public String hideIssue;
		public String designeeUserId;
		public String directoryCode;
		public String soleDestinationOffice;
		public String soleDestinationDepartment;
		public String soleDestinationTeam;
		public String socialSecurityNumber;
		public String sortOrderForIssuesToBeAssigned;
		public String sortOrderForStatusOfIssues;
		public String primaryPlatform;
		public String status;
		public String cosmosUserId;
		public List<String> routePreferences;
		public List<String> businessGroups;
		public Authorization authorization;
	}

	public class UserTokens {
		public String userToken;
		public String sourceSystem;
		public String daysRemainingPasswordExpiration;
	}

	public class Errors {
		public Integer code;
		public String name;
		public String severity;
		public String origin;
		public String description;
	}

	
	public static ACET_PerUserCredentialResultWrapper parse(String json) {
		return (ACET_PerUserCredentialResultWrapper) System.JSON.deserialize(json, ACET_PerUserCredentialResultWrapper.class);
	}
}