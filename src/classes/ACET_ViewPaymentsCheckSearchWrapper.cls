/*
    Created By: Kavinda Inusha
    Created Date: 27th April 2021
    Description: PaymentDetails::CheckDetail Wrapper DTO
*/
public class ACET_ViewPaymentsCheckSearchWrapper {

	@AuraEnabled public Data data;
    
    public class ProviderId {
		@AuraEnabled public String providerTin {get;set;}
		@AuraEnabled public String providerPrefix {get;set;}
		@AuraEnabled public String providerSuffix {get;set;}
	}

	public class PostalAddress {
		@AuraEnabled public String addressLine1 {get;set;}
		@AuraEnabled public String addressLine2 {get;set;}
		@AuraEnabled public String city {get;set;}
		@AuraEnabled public String state {get;set;}
		@AuraEnabled public String zip {get;set;}
	}

	public class DraftItem {
		@AuraEnabled public String draftNumber {get;set;}
		@AuraEnabled public String draftSequenceNumber {get;set;}
		@AuraEnabled public String bankCode {get;set;}
		@AuraEnabled public String topsEngineCode {get;set;}
		@AuraEnabled public String transactionType {get;set;}
		@AuraEnabled public String paidAmount {get;set;}
		@AuraEnabled public String payLocation {get;set;}
		@AuraEnabled public String draftStatusCode {get;set;}
	}

	public class Check {
		@AuraEnabled public String checkIssueDate {get;set;}
		@AuraEnabled public String checkAmount {get;set;}
		@AuraEnabled public String componentCount {get;set;}
		@AuraEnabled public String adjustmentStatus {get;set;}
		@AuraEnabled public String adjustmentTypeCode {get;set;}
		@AuraEnabled public String sourceCode {get;set;}
		@AuraEnabled public String bulkRecoveryIndicator {get;set;}
		@AuraEnabled public String bulkRecoveryAmount {get;set;}
	}

	public class DraftDetail {
		@AuraEnabled public DraftItem draftItem {get;set;}
		@AuraEnabled public String policyNumber {get;set;}
		@AuraEnabled public String subscriberId {get;set;}
		@AuraEnabled public String dependentNumnber {get;set;}
		@AuraEnabled public String firstName {get;set;}
		@AuraEnabled public String lastName {get;set;}
		@AuraEnabled public String relationshipCode {get;set;}
		@AuraEnabled public String icn {get;set;}
		@AuraEnabled public String icnSuffix {get;set;}
		@AuraEnabled public String processedDate {get;set;}
		@AuraEnabled public String processedTime {get;set;}
		@AuraEnabled public String icnDraftSequenceNumber {get;set;}
		@AuraEnabled public ProviderId providerId {get;set;}
		@AuraEnabled public String filmOffice {get;set;}
		@AuraEnabled public String flnJulianDate {get;set;}
		@AuraEnabled public String flnSRLNumber {get;set;}
	}

	public class CheckSummary {
		@AuraEnabled public Check check {get;set;}
		@AuraEnabled public List<DraftDetail> draftDetail {get;set;}
		@AuraEnabled public Payee payee {get;set;}
	}

	public class Data {
		@AuraEnabled public CheckSummary checkSummary {get;set;}
		@AuraEnabled public PagingState pagingState {get;set;}
	}

	public class Payee {
		@AuraEnabled public String payeeType {get;set;}
		@AuraEnabled public String payeeTypeDescription {get;set;}
		@AuraEnabled public String payeeFirstName {get;set;}
		@AuraEnabled public String payeelastName {get;set;}
		@AuraEnabled public PostalAddress postalAddress {get;set;}
	}

	public class PagingState {
		@AuraEnabled public String moreData {get;set;}
		@AuraEnabled public String nextKey {get;set;}
	}

}