/**
* Author: Madhura Priyadarshana
* Description : Wrapper class to get the response back from OGM service
*               https://gateway-stage.optum.com/api/stage/ben/nba-member/offers/v1/search
* AuraEnabled : False
* Created Date : 11 September 2019
*/
public without sharing class ADBOpportunityResponseWrapper {

    /**
    public String responseCode;
    public String responseMsg;
    public String responseDetailMsg;
    public List<Offer> offers;
    
    public class KeyValuePair {
        public String key;
        public String values;
    }
    
    public class Offer {
        public List<KeyValuePair> offerAttributes;
        public List<Disposition> dispositions;
    }
    
    public class Disposition {
        public List<KeyValuePair> dispositions;
	}
    */
    
    public String responseCode;
	public String responseMsg;
	public String responseDetailMsg;
	public List<Offers> offers;

	public class KeyValuePair {
		public String key;
		public String value;
	}

	public class Dispositions {
		public List<KeyValuePair> disposition;
	}

	public class Offers {
		public List<KeyValuePair> offerAttributes;
		public List<Dispositions> dispositions;
        
	}
}