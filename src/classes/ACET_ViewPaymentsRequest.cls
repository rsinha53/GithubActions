/*
    Created By: Kavinda Inusha
    Created Date: 27th April 2021
    Description: To create the PaymentDetails related api requests
*/
public with sharing class ACET_ViewPaymentsRequest {

	public class RequestBody {
		public Meta meta;
		public Data data;
	}

	public class Meta {
		public String sourceSystem;
		public String securityToken;
	}

	public class Data {
		public String searchType;
		public String seriesDesignator;
		public String checkNumber;
		public String accountNumber;
		public String policyNumber;
		public String subscriberId;
		public String firstName;
		public String lastName;
		public String draftStatus;
		public PagingState pagingState;
	}

	public class PagingState {
		public String moreData;
		public String nextKey;
	}

	public class PaymentWrapper {
		public String paymentType;
		public String platformType;
	}

    public class PaymentDetailsParams {
        @AuraEnabled public String seriesDesignator{get;set;}
        @AuraEnabled public String checkNumber{get;set;}
        @AuraEnabled public String remitNumber{get;set;}
        @AuraEnabled public String nextKey {get;set;}
    }

}