/* Class Name: ACETLGT_SearchBenefitsRequestWrapper
* Author: Sai Kolluru
* Created Date: 07/15/2021
* Description: JSON2APEX Class for response from B360 Search Benefits API
*/
public class ACETLGT_SearchBenefitsRequestWrapper{
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