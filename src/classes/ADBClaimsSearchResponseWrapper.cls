/**
* Author: Hasara Disanayaka
* Date Created: 30/06/2020
* Purpose: Function to call ClaimSearchV2 service 
**/
public without sharing class ADBClaimsSearchResponseWrapper {

    public ClaimSearchResponse claimSearchResponse;
        public class ClaimSearchResponse {
        public List<ClaimSearchV2ServiceItem> claimSearchV2ServiceItem;
    }
    public class ClaimSearchV2ServiceItem {
        public String claimStatus;
        public String fillDate;
        public String productNameAbbreviation;
        public String pharmacyName;
        public String daysSupply;
    }
	    public static ADBClaimsSearchResponseWrapper parse(String json) {
        return (ADBClaimsSearchResponseWrapper) System.JSON.deserialize(json, ADBClaimsSearchResponseWrapper.class);
    } 
}