/* Class Name: ACETLGT_GetBenefitSectionResponseJSON
* Author: Sai Kolluru
* Created Date: 07/19/2021
* Description: JSON2APEX Class for response from B360 Get Benefits Section API
*/

public class ACETLGT_GetBenefitSectionResponseJSON{
    @AuraEnabled public Result result;
	public class Result {
		@AuraEnabled public Benefit[] benefit;
	}
	public class Benefit {
		@AuraEnabled public String benefitSectionName;	
		@AuraEnabled public String benefitType;	
		@AuraEnabled public String benefitName;	
		@AuraEnabled public String benefitLanguageDescription;	
		@AuraEnabled public BenefitNetworkSection[] benefitNetworkSection;
		@AuraEnabled public BenefitLimitAndExcptn[] benefitLimitAndException;
	}
	public class BenefitNetworkSection {
		@AuraEnabled public String networkLanguageDescription;	
		@AuraEnabled public List<String> networkTypeDescription;
	}
	
	public class BenefitLimitAndExcptn {
		@AuraEnabled public String description;	
		@AuraEnabled public String details;
	}
}