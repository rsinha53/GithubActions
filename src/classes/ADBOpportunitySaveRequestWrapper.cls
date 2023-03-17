public without sharing class ADBOpportunitySaveRequestWrapper {
    
    
    public String memberId { get; set; }
    
    public String memberIdType { get; set; }
    
    public String mdmPersonId { get; set; }
    
    public String policyId { get; set; }
    
    public String srcMemberId { get; set; }
    
    public String srcMemberIdType { get; set; }
    
    public String mbrOppId { get; set; }
    
    public String homMbrOppId { get; set; }
    
    public String sourceCd { get; set; }
    
    public String opportunityId { get; set; }
    
    public String opportunityTypeCd { get; set; }
    
    public String eventDesc { get; set; }
    
    public String audienceLevel { get; set; }
    
    public String audienceKeyDataType { get; set; }
    
    public String interactiveChannelName { get; set; }
    
    public String intPoint { get; set; }
    
    public String eventName { get; set; }
    
    public String statusReasonCode { get; set; }
    
    public String dispositionText { get; set; }
    
    public String treatmentCode { get; set; }
    
    public String offerCode { get; set; }
    
    public String blacklistDays { get; set; }
    
    public String carrierId { get; set; }
    
    public String accountId { get; set; }
    
    public String groupId { get; set; }
    
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