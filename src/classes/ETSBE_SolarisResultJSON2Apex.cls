public with sharing class ETSBE_SolarisResultJSON2Apex {

   	public List<GroupResults> groupResults {get;set;}
   	public List<BrokerResults> brokerResults {get;set;}
    
    public class GroupResults{
    	public String accountName {get;set;}
    	public String id {get;set;}
    	public String customerNumber {get;set;}
    	public String policyNumber {get;set;}
    	public String renewalEffectiveDate {get;set;}
    	public String fundingType {get;set;}
    	public String salesOffice {get;set;}
    	public String businessMarketRegion {get;set;}
    	public String gaName {get;set;}
    	public String primaryRewardAccount {get;set;}
    	public String PrimaryRewardAccountName {get;set;}
    	public String situsState {get;set;}
    	public String marketSegment {get;set;}
    	public String businessMinorMarket {get;set;}
    	public String businessMajorMarket {get;set;}
    	public String platform {get;set;}
    	public List<Contact> contacts {get;set;}
    	public List<TeamMember> teamMembers {get;set;}
    }
    public class Contact{
    	public String name {get;set;}
    	public String id {get;set;}
    	public String title {get;set;}
    	public String email {get;set;}
    	public String workPhone {get;set;}
    	public String workPhoneExt {get;set;}
    	public String cellPhone {get;set;}
    }
    public class TeamMember {
    	public String name {get;set;}
    	public String role {get;set;}
    	public String phone {get;set;}
    }
    
    
    public class BrokerResults{
    	public String rewardAccountNumber {get;set;}
    	public String rewardAccountName {get;set;}
    	public String id {get;set;}
    	public List<GeneralAgent> rewardAccountContacts {get;set;}
    	public List<Producer> producers {get;set;}
    }
    
    public class GeneralAgent {
    	public String name {get;set;}
    	public String Id {get;set;}
    	public String type {get;set;}
    	public String workPhone {get;set;}
    	public String mobilePhone {get;set;}
    	public String email {get;set;}
    	public String street {get;set;}
    	public String city {get;set;}
    	public String state {get;set;}
    	public String zip {get;set;}
    }
    
    public class Producer {
    	public string name {get;set;}
    	public string type {get;set;}
    	public string email {get;set;}
    	public string phone {get;set;}
    	public string franchiseCode {get;set;}
    	public string street {get;set;}
    	public string city {get;set;}
    	public string state {get;set;}
    	public string zip {get;set;}
    }
}