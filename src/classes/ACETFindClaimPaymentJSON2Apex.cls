public class ACETFindClaimPaymentJSON2Apex{
	public cls_findClaimPaymentsResponse findClaimPaymentsResponse;
	public class cls_findClaimPaymentsResponse {
		public cls_claimpayment[] claimpayment;
        public cls_Pagination pagination {get;set;} 
	}
	public class cls_claimpayment {
		public cls_claim[] claim;
		public cls_payment[] payment;
	}
	public class cls_claim {
		public String claimID;	//7324230708
		public String claimFirstDateofService;	//2017-04-18
		public String claimLastDateofService;	//2017-04-18
		public String claimEventAdjudicationDateTime;	//2016-10-19T09:07:34Z
		public cls_patient patient;
		public String patientAccountNumber;	//0987654321
		public cls_billingProvider billingProvider;
		public cls_renderingProvider[] renderingProvider;
		public String claimTotalPaidAmount;	//500
	}
	public class cls_patient {
		public cls_name name;
		public cls_identifiers[] identifiers;
		public String relationshipCode;	//1
		public String cardSerialNumber;	//6F16B26842000678B
		public String memberGroupNumber;	//OKH93257984
	}
	public class cls_name {
		public String firstName;	//Memon
		public String lastName;	//King
	}
	public class cls_identifiers {
		public String id;	//6785218362
		public String type;	//1074598
		public String sourceSysCode;	//CR
	}
	public class cls_billingProvider {
		public String providerFirstName;	//Nada
		public String providerLastName;	//Medical
		public String providerOrganizationName;	//Medical
		public String providerNPI;	//0192837465
		public String providerID;	//1029384756
		public String providerTIN;	//123456789
	}
	public class cls_renderingProvider {
		public String providerFirstName;	//Polo
		public String providerLastName;	//UHF
		public String providerID;	//5963458967
	}
    
    public class cls_Pagination {
        public String pageNumber {get;set;} 
        public String pageSize {get;set;} 
        public String recordCount {get;set;} 
        public String totalCount {get;set;} 		
    }
    
	public class cls_payment {
		public String payeeName;	//PHG
		public cls_payeeTypeCode payeeTypeCode;
		public cls_payeeAddress payeeAddress;
		public String paymentTrackingNumber;	//2347832904899213759032
		public String checkSeriesDesignatorNumber;	//EDC5678934
		public String paymentIssueDate;	//2016-10-29
		public String paymentMethodTypeCode;	//CHK
		public String bulkPaymentIndicator;	//N
		public String checkOrEFTAmount;	//143.31
		public String overPaymentWithheldAmt;	//69.10
		public cls_paymentStatus paymentStatus;
	}
	public class cls_payeeTypeCode {
		public String code;	//1209998
        public String description;
	}
	public class cls_payeeAddress {
		public String addressLine1;	//12100
		public String addressLine2;	//Clearwater Drive
		public String city;	//Minnetonka
		public String postalCode;	//4100
		public String state;	//MN
	}
	public class cls_paymentStatus {
		public String code;	//P
	}
	public static ACETFindClaimPaymentJSON2Apex parse(String json){
		return (ACETFindClaimPaymentJSON2Apex) System.JSON.deserialize(json, ACETFindClaimPaymentJSON2Apex.class);
	}
}