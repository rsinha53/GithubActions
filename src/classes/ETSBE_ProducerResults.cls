public with sharing class ETSBE_ProducerResults {
	public String producerCustomerValidated {get;set;}
	public String producerID {get;set;}
	public String producerSSN {get;set;}
	public String producerTIN {get;set;}
	public String producerType {get;set;}
	public String producerContact {get;set;}
	public String producerCompanyName {get;set;}
	public String producerStatus {get;set;}
	public String producerEffectiveStartDate {get;set;}
	public String producerEffectiveEndDate {get;set;}
	public List<LegacyProducers> legacyProducers {get;set;}
	public String legacyProducerIDList {get;set;}
	public List<CustomerDetails> customerDetails {get;set;}
	public String coverageType {get;set;}
	public String producerRoleType {get;set;}
	public String producerRole {get;set;}
	public String producerServiceRightsOnly {get;set;}
	public String ProducerCRID {get;set;}
	public String producerSplitPercent {get;set;}
	public IndividualName producerIndividualName {get;set;}
	public Address producerAddress {get;set;}
	
	public class IndividualName{
		public String firstName {get;set;}
		public String middleInitial {get;set;}
		public String lastName {get;set;}
	}
	
	public class Address{
		public String addressTypeCode {get;set;}
		public String producerStreetLine1 {get;set;}
		public String producerStreetLine2 {get;set;}
		public String producerCity {get;set;}
		public String producerState {get;set;}
		public String producerZipCode {get;set;}
		public String producerZipCodeSuffix {get;set;}
		public String producerPhoneNumber {get;set;}
	}
	
	public class LegacyProducers {
		public String legacyProducerSystem {get;set;}
		public String legacyProducerID {get;set;}
	}
	
	public class CustomerDetails {
		public String customerNumber {get;set;}
		public String customerName {get;set;}
		public String adminSystem {get;set;}
		public String producerCustomerStartDate {get;set;}
		public String producerCustomerEndDate {get;set;}
	}
}