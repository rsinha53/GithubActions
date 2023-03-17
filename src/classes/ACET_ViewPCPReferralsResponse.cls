public class ACET_ViewPCPReferralsResponse {
 
    @AuraEnabled public referralStatusResponseWrapper[] referralStatusResponse;
	public class referralStatusResponseWrapper {
		@AuraEnabled public String comments;	
		@AuraEnabled public String endDate;
		@AuraEnabled public String firstDiagnosisCode;	
		@AuraEnabled public String numberOfVisits;	
		@AuraEnabled public String referralId;	
		@AuraEnabled public String referredToProvider;	
		//@AuraEnabled public addressWrapper referredToProviderAddress;
		@AuraEnabled public String referredToProviderMpin;	
		@AuraEnabled public String referredToProviderNpi;	
		@AuraEnabled public String referredToProviderPhoneNumber;	
		//@AuraEnabled public providerSpecialityWrapper referredToProviderSpeciality;
		@AuraEnabled public String referredToProviderTin;	
		@AuraEnabled public String referringProvider;	
		//@AuraEnabled public addressWrapper referringProviderAddress;
		@AuraEnabled public String referringProviderMpin;	
		@AuraEnabled public String referringProviderNpi;	
		@AuraEnabled public String referringProviderPhoneNumber;	
		@AuraEnabled public String referringProviderTin;	
		@AuraEnabled public String remainingVisits;
		@AuraEnabled public String secondDiagnosisCode;	
		@AuraEnabled public String startDate;	
	}
    
   
	/*public class addressWrapper {
		public String address1;	
		public String address2;	
		public String city;	
		public String state;	
		public String zip;	
	}*/
    
   
	/*public class providerSpecialityWrapper {
		public String code;	
		public String description;	
	}*/
	
	public static ACET_ViewPCPReferralsResponse parse(String json) {
		return (ACET_ViewPCPReferralsResponse) System.JSON.deserialize(json, ACET_ViewPCPReferralsResponse.class);
	}

}