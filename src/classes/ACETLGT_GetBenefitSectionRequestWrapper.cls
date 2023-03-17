/* Class Name: ACETLGT_GetBenefitSectionRequestWrapper
* Author: Suresh
* Created Date: 07/19/2021
* Description: JSON2APEX Class for response from B360 Get Benefits Section API
*/
public class ACETLGT_GetBenefitSectionRequestWrapper{
	public String benefitId;	
	public String clientId;	
	public String language;	
	public Personalization[] personalization;
	public String session;	
	public String userType;	
	
	public class Personalization {
		public String value;
		public String variable;
	}
}