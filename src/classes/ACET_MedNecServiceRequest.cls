public class ACET_MedNecServiceRequest {
    
    
	public searchInput searchInput;
	public class searchInput {
		public searchInputMeta searchInputMeta;
		public String searchType;	
		public String policy;	
		public String memberId;	
		public String firstName;	
		public String relationship;	
		public String firstServiceDate;	
		public String lastServiceDate;	
        public string authorizationNumber;
        public string claimLevelCauseCode;
        public string cptCodeFrom; // Code Range && CPT/HCPC Code
        public string cptCodeThru; // Code Range && CPT/HCPC Code
        public string remarkCode;
        public string revenueCodeFrom;
        public string revenueCodeThru;
        public string appliedToOopInd;

	}
	public class searchInputMeta {
		public String sourceSystem;	
		public topsSystemParameter topsSystemParameter;
	}
	public class topsSystemParameter {
		public String securityToken;	
	}
    
    public static ACET_MedNecServiceRequest parse(String json){
		return (ACET_MedNecServiceRequest) System.JSON.deserialize(json, ACET_MedNecServiceRequest.class);
	}

}