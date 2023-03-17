public class ACETLGT_NimbusGetSSBRequest {

    public GetSubscriptionServiceBenefitRequest getSubscriptionServiceBenefitRequest;
    
	public class Identifier {
        public String id{get;set;}
        public String type{get;set;}
	}

	public class GetSubscriptionServiceBenefitRequest {
        public String planOptionId{get;set;}
        public String benefitBundleOptionId{get;set;}
        public Identifier enrolleeIdentifier{get;set;}
        public Identifier subscriberIdentifier{get;set;}
        public List<CoverageType> coverageTypes;
        public String effectiveStartDate{get;set;}
        public String effectiveEndDate{get;set;}
        public String groupNumber{get;set;}
        public String accumulatorAsOfDate{get;set;}
        public Boolean suppressByHipaaServiceType{get;set;}
        public String customerPurchaseID{get;set;}
	}
    public class CoverageType{
        public String coverageType{get;set;}
    }
    public String addSearchInput(String bundleId, String enrollerSRK, String subscriberSRK, String startDate, String endDate, String coverageType, String groupNumber, String accumsDate, string accumAsOf,string customerPurchaseid){
        getSubscriptionServiceBenefitRequest = new GetSubscriptionServiceBenefitRequest();
        getSubscriptionServiceBenefitRequest.benefitBundleOptionId = bundleId;
        
        Identifier enrolleeIdentifier = new Identifier();
        enrolleeIdentifier.id = enrollerSRK;
        enrolleeIdentifier.type = 'SRK';
        getSubscriptionServiceBenefitRequest.enrolleeIdentifier = enrolleeIdentifier;
        
        Identifier subscriberIdentifier = new Identifier();
        subscriberIdentifier.id = subscriberSRK;
        subscriberIdentifier.type = 'SRK';
        getSubscriptionServiceBenefitRequest.subscriberIdentifier = subscriberIdentifier;
        
        CoverageType covType = new CoverageType();
        covType.coverageType = coverageType;
        List<CoverageType> coverageTypes = new List<CoverageType>();
        coverageTypes.add(covType);
        getSubscriptionServiceBenefitRequest.coverageTypes = coverageTypes;
        
        getSubscriptionServiceBenefitRequest.effectiveStartDate = startDate;
        getSubscriptionServiceBenefitRequest.effectiveEndDate = endDate;
        getSubscriptionServiceBenefitRequest.groupNumber = groupNumber;
        getSubscriptionServiceBenefitRequest.suppressByHipaaServiceType = true;
        getSubscriptionServiceBenefitRequest.accumulatorAsOfDate = accumAsOf;
        if(String.isNotBlank(customerPurchaseid))
        	getSubscriptionServiceBenefitRequest.customerPurchaseID = customerPurchaseid;
        return JSON.serialize(this);
    }
}