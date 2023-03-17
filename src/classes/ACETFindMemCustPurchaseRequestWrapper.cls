public class ACETFindMemCustPurchaseRequestWrapper {
public findMembershipsCustomerPurchaseRequest findMembershipsCustomerPurchaseRequest{get;set;}
	public class pagination{
		public Integer pageNumber{get;set;}
		public String startRecord{get;set;}
		public Integer pageSize{get;set;}
	}
	public class findMembershipsCustomerPurchaseRequest{
		public String systemSpecificIndicator{get;set;}
		public String effectiveStartDate{get;set;}
		public String effectiveEndDate{get;set;}
		public String identifierType{get;set;}
		public pagination pagination{get;set;}
		public String identifier{get;set;}
	}
}