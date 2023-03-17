/* Class Name: ACET_GetBenefitSectionResponseJSON
* Author: Sai Kolluru
* Created Date: 07/19/2021
* Description: JSON2APEX Class for response from B360 Get Benefits Section API
*/

public class ACET_GetBenefitSectionResponseJSON{
	public Result result;
	public class Result {
		public Benefit[] benefit;
	}
	public class Benefit {
		public String benefitSectionName;	
		public String benefitType;	
		public String benefitName;	
		public String benefitLanguageDescription;	
		public BenefitNetworkSection[] benefitNetworkSection;
		public BenefitLimitAndExcptn[] benefitLimitAndException;
	}
	public class BenefitNetworkSection {
		public String networkLanguageDescription;	
		public List<String> networkTypeDescription;
	}
	
	public class BenefitLimitAndExcptn {
		public String description;	
		public String details;
	}
}