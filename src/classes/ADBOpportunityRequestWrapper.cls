/**
 * Author: Hasara Disanayaka
 * Date Created: 09/03/2019
 * Date Modified:
 * Purpose: 
 * 
 **/

public without sharing class ADBOpportunityRequestWrapper {
     
    public String memberId { get; set; }
     
    public String memberIdType { get; set; }
     
    public String audienceLevel { get; set; }
     
    public String audienceKeyDataType { get; set; }
     
    public String interactiveChannelName { get; set; }
     
    public String intPoint { get; set; }
     
    public String eventName { get; set; }
     
    public String userRole { get; set; }
     
    public String opportunityTypeCd { get; set; }
     
    public String carrierId { get; set; }
     
    public String accountId { get; set; }
     
    public String groupId { get; set; }
     
    public String numberOfOffers { get; set; }
     
    public String deduplicationPolicy { get; set; }
     
    public String applicationId { get; set; }
     
    public String userId { get; set; }

    public CallLevel callLevelId1 { get; set; }

    public CallLevel callLevelId2 { get; set; }

    public CallLevel callLevelId3 { get; set; }

    public class CallLevel {
        public String key { get; set; }
        public String value{ get; set; }
    }
}