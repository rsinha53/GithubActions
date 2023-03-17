public class ACETFindMemCustPurchaseJSON2Apex {
        public findMembershipsCustomerPurchaseResponse findMembershipsCustomerPurchaseResponse{get;set;}
    public class cls_subscriberSystemSpecificIdentifiers{
        public String type_z{get;set;}
        public String idstr{get;set;}
    }
    public class cls_product{
        public String productIdentifier{get;set;}
        public String productName{get;set;}
        public String productType{get;set;}
    }

    public class cls_memberships{
        public list<cls_coverages> coverages{get;set;}
        public list<cls_identifiers> identifiers{get;set;}
        public list<cls_enrolleeSystemSpecificIdentifiers> enrolleeSystemSpecificIdentifiers{get;set;}
        public String sourceSysCode{get;set;}
    }
    public class legacyAttributes{
        public String policyNumber{get;set;}
        public String claimSystemTypeCode{get;set;}
        public String serviceArea{get;set;}
        public String eligibilitySystemTypeCode{get;set;}
        public String stateOfIssueCode{get;set;}
    }
    public class cls_identifiers{
        public String type_z{get;set;}
        public String idstr{get;set;}
    }
    public class findMembershipsCustomerPurchaseResponse{
        public list<cls_memberships> memberships{get;set;}
    }
    public class cls_enrolleeSystemSpecificIdentifiers{
        public String type_Z{get;set;}
        public String idstr{get;set;}
    }
    public class customerPurchase{
        public String contractOptionStartDate{get;set;}
        public String customerPurchaseVersionId{get;set;}
        public String customerPurchaseId{get;set;}
        public String customerPurchaseStatusDescription{get;set;}
        public String contractOptionEndDate{get;set;}
    }
    public class cls_coverages{
        public cls_product product{get;set;}
        public benefit benefit{get;set;}
        public String coverageLevelCode{get;set;}
        public String relationshipCode{get;set;}
        public String coverageTypeDescription{get;set;}
        public String relationshipDescription{get;set;}
        public String coverageType{get;set;}
        public legacyAttributes legacyAttributes{get;set;}
        public String membershipExpirationDate{get;set;}
        public String brandingEntityName{get;set;}
        public String membershipEffectiveDate{get;set;}
        public String brandingEntityDescription{get;set;}
        public String groupName{get;set;}
        public String contractOptionType{get;set;}
        public String groupNumber{get;set;}
        public String contractOptionTypeDesc{get;set;}
        public list<cls_subscriberSystemSpecificIdentifiers> subscriberSystemSpecificIdentifiers{get;set;}
    }
    public class benefit{
        public String riderOnlyIndicator{get;set;}
        public list<customerPurchase> customerPurchase{get;set;}
        public String planOptionID{get;set;}
        public String bookOfBusinessTypeCode{get;set;}
        public String benefitPlanName{get;set;}
        public String bookOfBusinessTypeDescription{get;set;}
        public String benefitPlanId{get;set;}
    }
    
    public static ACETFindMemCustPurchaseJSON2Apex parse(String json) {
        return (ACETFindMemCustPurchaseJSON2Apex) System.JSON.deserialize(json, ACETFindMemCustPurchaseJSON2Apex.class);
    }
}