public class ACET_SearchBenefitsResponseJSON {
		public SearchResult result;
	public class SearchResult {
		public MatchingPhrases[] matchingPhrases;
		public Benefit[] benefit;
	}
	public class MatchingPhrases {
	}
	public class Benefit {
		public String benefitId;
		public String benefitName;	
		public String benefitSummaryText;
	}
	
}