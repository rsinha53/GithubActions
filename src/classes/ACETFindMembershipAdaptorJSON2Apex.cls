public class ACETFindMembershipAdaptorJSON2Apex{
    public cls_findMembershipsResponse findMembershipsResponse; 
    public class  cls_findMembershipsResponse {
        public cls_memberships[] memberships;
        public cls_pagination pagination;
    }
    public class cls_memberships { 
        public String sourceSysCode;    //CIRRUS
        public cls_coverages[] coverages;
        public cls_identifiers[] identifiers;
        public cls_systemSpecificIdentifiers[] systemSpecificIdentifiers;
        public cls_enrolleeSystemSpecificIdentifiers[] enrolleeSystemSpecificIdentifiers;
    }
   public class cls_enrolleeSystemSpecificIdentifiers {           
        public String claimSystemTypeCode;  //AAAA
    public String idstr;  //23452521            public String dependentSequenceNumber;  //E1D
    public String type_Z;  //enrolleeSystemID            public String policyNumber; //LGCY0001
  }
    public class cls_coverages {
    public cls_subscriberSystemSpecificIdentifiers[] subscriberSystemSpecificIdentifiers;
        public String groupNumber;  //12345678
        public String groupName;    //CIRRUS
        public String membershipEffectiveDate;  //2010-01-01
        public String membershipExpirationDate; //2016-01-01
        public String coverageType; //B
        public String coverageTypeDescription;  //BEHAVIORAL HEALTH
        public String coverageLevelCode;    //ABC
        public cls_product product;
        public cls_benefit benefit;
        public String relationshipCode; //001
        public String relationshipDescription;  //SPOUSE/DOMESTIC PARTNER
        public String privacyIndicator; //Y
        public cls_legacyAttributes legacyAttributes;
        
    }
    public class cls_subscriberSystemSpecificIdentifiers{
        public String idstr;
        public String type_z;
    }
    public class cls_product {
        public String productIdentifier;    //PM00000001
        public String productName;  //INN ONLY
        public String productType;  //M001
    }
    public class cls_benefit {
        public String benefitPlanId;    //M000000023
        public String benefitPlanName;  //CTLG DIRECT HSA
        public String benefitBundleId;  //AAAA
        public String benefitBundleName;    //CTLG BUNDLE
        public String benefitBundleOptionId;    //A1111
        public String benefitBundleOptionDescription;   //STRING
        public String bookOfBusinessTypeCode;
        public list<customerPurchase> customerPurchase{get;set;} // US2962032 
    }
    public class customerPurchase{
		public String customerPurchaseId{get;set;}
	}
    public class cls_legacyAttributes {
        public String eligibilitySystemTypeCode;    //AAAA
        public String claimSystemTypeCode;  //AAAA
        public String dependentSequenceNumber;  //E1D
        public String policyNumber; //LGCY0001
        public String marketType;   //MYUHC
        public String governmentProgramCode;    //1
        public String serviceArea;  //MKT_SITE
        public String migrationLegacySourceId;  //PHS
        public String migrationLegacyPolicyNumber;  //PHS123456
        public String divisionCode; //COSMO
        public String sharedArrangement;    //00
        public String obligorId;    //04
        public String stateOfIssueCode; //AK
    }
    public class cls_identifiers {
        public String idstr;   //99887766
        public String type_z; //MemberId
    }
    public class cls_systemSpecificIdentifiers {
        public String idstr;   //10699865
        public String type_z; //EID
    }
    public class cls_pagination {
        public String pageNumber;   //1
        public String pageSize; //10
        public String recordCount;  //5
        public String totalCount;   //10
        public String totalPages;   //10
        public String moreRecords;  //true
    }
    public static ACETFindMembershipAdaptorJSON2Apex parse(String json) {
        return (ACETFindMembershipAdaptorJSON2Apex) System.JSON.deserialize(json, ACETFindMembershipAdaptorJSON2Apex.class);
    }    
}