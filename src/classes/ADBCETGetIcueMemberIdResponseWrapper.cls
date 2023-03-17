public without sharing class ADBCETGetIcueMemberIdResponseWrapper{
    @AuraEnabled
    public MemberSearchResult memberSearchResult;

    public class MemberSearchResult{
        @AuraEnabled
        public String icueMemberId { get;set; }

    }

    public static ADBCETGetIcueMemberIdResponseWrapper parse(String json) {
        system.debug('response from ABDCETgetIcueMember' + json);
        return (ADBCETGetIcueMemberIdResponseWrapper) System.JSON.deserialize(json, ADBCETGetIcueMemberIdResponseWrapper.class);
    } 
}