public with sharing class ETSBE_SolarisGeneralAgentDetailResult {
    public String rewardAccountNumber {get;set;}
    public String agencyBrokerName {get;set;}
    public String salesforceInternalId {get;set;}
    public List<GeneralAgent> generalAgents {get;set;}
    public List<Producer> producers {get;set;}
    
    public class GeneralAgent {
    	public String name {get;set;}
    	public String salesforceInternalId {get;set;}
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