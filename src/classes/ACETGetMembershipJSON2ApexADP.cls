public class ACETGetMembershipJSON2ApexADP{ 
    public cls_getMembershipResponse getMembershipResponse{get; set;}
    public class cls_getMembershipResponse {
        public cls_membership membership{get; set;}
    }
    public class cls_membership {
       // public String sourceSysCode{get; set;}    //CR
        public cls_coverages[] coverages{get; set;}
     //  public cls_cob[] cob{get; set;}
        public cls_providers[] providers{get; set;}
      //  public cls_identifiers[] identifiers{get; set;}
    }
    public class cls_coverages {
      //  public String groupNumber{get; set;}  //1118478
        //public String groupName{get; set;}    //Membership_services_MG33
        //public String eligibilitySystemTypeCode{get; set;}    //CR
        //public String claimSystemTypeCode{get; set;}  //CR
        public String memberStatus{get; set;}
        public cls_bundleOptions[] bundleOptions{get; set;}
    }
    public class cls_bundleOptions {
        public cls_benefits[] benefits{get; set;}
    }
    public class cls_benefits {
        public String benefitBundleOptionId{get; set;}    //0
       // public String benefitBundleOptionDescription{get; set;}   //MNRP PlanOptionDesc
        public String benefitEffectiveDate{get; set;} //2015-01-01
        public String benefitExpirationDate{get; set;}    //9999-12-31
        public String benefitPlanId{get; set;}    //M000000015
        //public String benefitPlanName{get; set;}  //CTSM FREEDOM DIRECT $30/50 ER$200 OPD&C
        public String benefitType{get; set;}  //MD
        public String coverageLevelCode{get; set;}    //FAM
        public String relationshipCode{get; set;} //18
        public String relationshipDescription{get; set;}  //18
        public String memberIdCardSerialNumber{get; set;} //69688001800
       // public String subscriberIdCardSerialNumber{get; set;} //69688001800
        public String eligibilityStatusCode{get; set;}    //
       // public String stateOfIssueCode{get; set;} //situs state
        public String fundingArrangementDescription{get; set;}
        //public String fundingArrangementCode{get; set;}
        public String cancelReasonTypeCode{get; set;} //
        public String planType{get; set;} //02
        public cls_indicators indicators {get; set;} //
        public String networkScheduleID{get;set;}
        public cls_coverageLevelList[] coverageLevelList {get; set;}
        
    }
    public class cls_coverageLevelList {
        public String covLevelCode {get;set;}
        public String covLevelDesc {get;set;}
        public String covLevelEffDate {get;set;}
        public String covLevelExpDate {get;set;}
    }
    public class cls_indicators {
        public String qmscoIndicator {get; set;}    //N
        public String hsaIndicator{get;set;} //US958187
    }
  //  public class cls_cob {
    //}
    public class cls_providers {
        public cls_providerIdentifiers[] providerIdentifiers{get; set;}
        public String assignmentType{get; set;}   //PCP
        public String effectiveDate{get; set;}    //2017-01-01
        public String expirationDate{get; set;}   //2020-12-31
        public String firstName{get; set;}    //LINDA
        public String lastName{get; set;} //TAO
       // public String networkId{get; set;}    //7
        public String locationAffiliationID {get;set;} //Added by Avish on 09/07/2018 as a part US1234476 
    }
    public class cls_providerIdentifiers {
        public String id_z{get; set;}   //212226509
        public String type_z{get; set;} //SY
    }
   // public class cls_identifiers {
     //   public String id{get; set;}   //890504596
       // public String type{get; set;} //enrolleeSurrogateKey
   // }
}