public class ACETViewMemberListingJSON2Apex {

    public class Demographics {
        public String memberID;
        public String cobraInd;
        public String nameFirst;
        public String nameLast;
        public String birthDate;
        public String gender;
        public String familystatus;
        public String socialSecurityNumber;
    }

    public class MemberAffiliation {
        public String relationshipCode;
        public String populationName;
        public String subscriberID;
        public String employStatusCode;
        public String memGroupID;
        public String memGroupName;
        public String billGroupReferenceID;// updated from billingPrefID to billGroupReferenceID - US2609420 - sunil vennam
        public String billGroupDescription ;//updated from billingPreferenceDescription to billGroupDescription - US2607851 - suni vennam
        public string employBeginDate;
        public string relationshipCodeDesc;
        public string memberDirectBillingInd;
        public string earliestEffDate;
    }

    public class MemberCoverageList {
        public String coverageOptionDescription; // US2607851 - Sunil Vennam
        public String coverageOptionID;
        public String benPlanEffDate;
        public String benPlanExpDate;
        public String coverageType;
        public List<CoverageOptionPlans> coverageOptionPlans;
        public String memberStatus;
        public String benefitStatusCode;
        public List<CovLevelList> covLevelList;
    }

    public MetaInformation metaInformation;
    public ResponseData responseData;

    public class MemberList {
        public Demographics demographics;
        public List<MemberCoverageList> memberCoverageList;
        public MemberAffiliation memberAffiliation;
    }

    public class ResponseData {
        public List<MemberList> memberList;
        public boolean hasNextPage;
        public Integer pageNumber;
        public Integer size;
    }

    public class MetaInformation {
        public List<ResponseMessageList> responseMessageList {get;set;} 
    }
    
    public class ResponseMessageList {
        public String code {get;set;} 
        public String message {get;set;} 
        public String type_Z {get;set;}
    }
    
    public class CoverageOptionPlans {
        public String planID;
        public String planName;
        public String planType;
        public String benefitType;
    }
    
    public class CovLevelList {
        public String covLevelCode;
        public String covLevelDesc;
        public String covLevelEffDate;
        public String covLevelExpDate;
    }
    
    public static ACETViewMemberListingJSON2Apex parse(String json) {
        return (ACETViewMemberListingJSON2Apex) System.JSON.deserialize(json, ACETViewMemberListingJSON2Apex.class);
    }
}