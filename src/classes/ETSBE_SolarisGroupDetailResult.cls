public with sharing class ETSBE_SolarisGroupDetailResult {
    @AuraEnabled public String groupName {get;set;}
	@AuraEnabled public String salesforceInternalId {get;set;}
	@AuraEnabled public String groupId {get;set;}
	@AuraEnabled public String policyNumber {get;set;}
	@AuraEnabled public String renewalEffectiveDate {get;set;}
	@AuraEnabled public String fundingType {get;set;}
	@AuraEnabled public String salesOffice {get;set;}
	@AuraEnabled public String businessMarketRegion {get;set;}
	@AuraEnabled public String generalAgentName {get;set;}
	@AuraEnabled public String brokerSalesforceId {get;set;}
	@AuraEnabled public String brokerName {get;set;}
	@AuraEnabled public String situsState {get;set;}
	@AuraEnabled public String lineOfBusiness {get;set;}
	@AuraEnabled public String businessMinorMarket {get;set;}
	@AuraEnabled public String businessMajorMarket {get;set;}
	@AuraEnabled public String platform {get;set;}
	@AuraEnabled public List<Contact> contacts {get;set;}
    @AuraEnabled public List<TeamMember> groupTeamMembers {get;set;}
    @AuraEnabled public String sourceCode {get;set;}
    
    public class Contact{
    	@AuraEnabled public String name {get;set;}
        @AuraEnabled public String firstName {get;set;}
        @AuraEnabled public String lastName {get;set;}
    	@AuraEnabled public String id {get;set;}
    	@AuraEnabled public String title {get;set;}
    	@AuraEnabled public String email {get;set;}
    	@AuraEnabled public String workPhone {get;set;}
    	@AuraEnabled public String workPhoneExt {get;set;}
    	@AuraEnabled public String cellPhone {get;set;}
    }
    public class TeamMember {
    	@AuraEnabled public String name {get;set;}
        @AuraEnabled public String firstName {get;set;}
        @AuraEnabled public String lastName {get;set;}
    	@AuraEnabled public String role {get;set;}
    	@AuraEnabled public String phone {get;set;}
    }
}