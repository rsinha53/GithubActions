/**
* Author: Hasara Disanayaka
* Date Created: 30/06/2020
* Purpose: Function to call ClaimSearchV2 service 
**/
public without sharing class ADBClaimsSearchRequestWrapper {
    
    public SearchInputMetaData searchInputMetaData;
    public String memberId{ get; set; }
    public String carrierId{ get; set; }
    public String accountId{ get; set; }
    public String groupId{ get; set; }
    public String fillDateFrom{ get; set; }
    public String fillDateThru{ get; set; }
    
    public class SearchInputMetaData {
        public String consumerAppId{ get; set; }
        public String consumerAppType{ get; set; }
        public String rXClaimInstanceId{ get; set; }
        public String externalCorrelationId{ get; set; }
        public String consumerType{ get; set; }
    }
}