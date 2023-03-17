/* Class Name: ACETLGT_SearchBenefitsResponseJSON
* Author: Sai Kolluru
* Created Date: 07/15/2021
* Description: JSON2APEX Class for response from B360 Search Benefits API
*/
public class ACETLGT_SearchBenefitsResponseJSON{
    @AuraEnabled
	public SearchResult result;
	public class SearchResult {
		public MatchingPhrases[] matchingPhrases;
        @AuraEnabled
		public Benefit[] benefit;
	}
	public class MatchingPhrases {
	}
	public class Benefit {
        @AuraEnabled
		public String benefitId;
        @AuraEnabled
		public String benefitName;	
        @AuraEnabled
		public String benefitSummaryText;
	}
	
}