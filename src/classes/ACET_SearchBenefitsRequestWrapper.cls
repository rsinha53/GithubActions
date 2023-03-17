public class ACET_SearchBenefitsRequestWrapper {
	public BenefitPlanIDs[] benefitPlanIDs;
	public String clientId;	
	public String dateOfService;	
	public List<String> docType;
	public String language;	
	public String searchPhrase;
	public String session;	
	public String userType;	
	public class BenefitPlanIDs {
		public String benefitPlanID;
		public String benefitPlanPlatform;	
	}
	
}