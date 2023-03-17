public class ACETFamilyMembershipJson2Apex{
    public cls_getFamilyMembershipResponse getFamilyMembershipResponse;
    public class cls_getFamilyMembershipResponse {
        public cls_individual[] individual;
    }
    public class cls_individual {
        public String individualIdentifier; //1118280
        public cls_name name;
        public String birthDate;    //1987-03-03
        public String genderCode;   //M
        public String genderDescription;    //Male
        public String socialSecurityNumber; //123456789
        public String privacyIndicator; //Y
        public String relationshipCode; //001
        public String relationshipDescription;  //Spouse
        public cls_address[] address;
        public cls_identifiers[] identifiers;
        public cls_membership[] membership;
    }
    public class cls_name {
        public String firstName;    //Jack
        public String lastName; //Jinny
        public String middleName;   //Jim
        public String nameSuffix;   //Jr
    }
    public class cls_address {
        public String typeCode; //HOM
        public String addressLine1; //Morristown
        public String addressLine2; //131
        public String city; //BaskingRidge
        public String postalCode;   //07307
        public String stateCode;    //NJ
        public String countryCode;  //US
        public String countryDescription;   //United States of America
    }
    public class cls_identifiers {
        public String id;   //123
        public String type; //SRK
    }
    public class cls_membership {
        public String sourceSysCode;    //CR
        public cls_coverages[] coverages;
        public cls_utilizationPlan[] utilizationPlan;
        public cls_cob[] cob;
        public cls_providers[] providers;
        public cls_clinicalProgram[] clinicalProgram;
        public cls_carrierType carrierType;
        public cls_identifiers[] identifiers;
    }
    public class cls_coverages {
        public String groupNumber;  //123456789
        public String groupName;    //Cirrus
        public String eligibilitySystemTypeCode;    //AAAA
        public String claimSystemTypeCode;  //AAAA
        public String memberStatus;
        public cls_bundleOptions[] bundleOptions;
        
    }
    public class cls_coverageLevelList{
		public String covLevelCode{get;set;}
		public String covLevelExpDate{get;set;}
		public String covLevelEffDate{get;set;}
		public String covLevelDesc{get;set;}
	}
    public class cls_bundleOptions {
        public cls_benefits[] benefits;
    }
    public class cls_benefits {
        public String benefitBundleId;  //OptionId
        public String benefitBundleName;    //GTLG BUNDLE
        public String benefitBundleOptionId;    //OptionId
        public String benefitBundleOptionDescription;   //
        public String benefitEffectiveDate; //2007-03-04
        public String benefitExpirationDate;    //2020-03-04
        public String benefitPlanId;    //M000000023
        public String benefitPlanName;  //CTLG DIRECT HSA D&C
        public String benefitType;  //HMO
        public String benefitTypeDescription;   //Auto
        public String coverageLevelCode;    //2
        public cls_product product;
        public String relationshipCode; //001
        public String relationshipDescription;  //Spouse
        public String memberIdCardSerialNumber; //A1234567
        public String subscriberIdCardSerialNumber; //S987654
        public String eligibilityStatusCode;    //AAAA
        public String serviceArea;  //NE
        public String cancelReasonTypeCode; //0
        public String planType; //H
        public String marketSegment;    //T
        public String stateOfIssueCode; //ER
        public String fundingArrangementCode;   //ON
        public String fundingArrangementDescription;    //ON TIME
        public String coverageLastUpdateDate;   //20170101
        public String individualGroupTypeCode;  //E
        public cls_indicators indicators;
        public cls_coverageLevelList[] coverageLevelList {get; set;}
        public String networkScheduleID{get;set;}
    }
    public class cls_product {
        public String productIdentifier;    //A111
        public String productName;  //Dental
        public String productType;  //PRIMARY
    }
    public class cls_indicators {
        public String hsaIndicator;//US2962032
        public String erisaIndicator;   //0
        public String qmscoIndicator;   //Y
        public String onshoreRestrictionIndicator;  //Y
        public String proofOfHealthCoverageIndicator;   //Y
        public String dvcnIndicator;    //Y
        public String pcpRequiredIndicator; //Y
        public String clickToCall;  //Y
        public String clickToChat;  //Y
        public String activationMessaging;  //Y
        public String secureMessaging;  //Y
    }
    public class cls_utilizationPlan {
        public String planId;   //ASO_STD_00001
        public String entityId; //BOSS Pop ID
        public String externalPlanId;   //POP44603
    }
    public class cls_cob {
        public String cobTypeCode;  //A
        public String cobTypeCodeDescription;   //Auto
        public String custodyCode;  //S
        public String otherInsurancePrimacyIndicator;   //p
        public String coverageType; //1
        public String medicareEntitlementType;
        public String medicareEntitlementReasonCode;
        public String cobEffectiveStartDate;    //2007-03-04
        public String cobEffectiveEndDate;  //2020-03-04
        public String otherInsuranceVerifyDate; //2018-01-02
        public String otherInsurancePolicyNumber;   //A12345
        public String otherInsuranceCardholderId;   //B23456
        public String otherInsuranceCarrierName;    //GARDIAN
        public String cobRelatedEntityContactTelephoneNumber;   //9738909090
    }
    public class cls_providers {
        public cls_providerIdentifiers[] providerIdentifiers;
        public String assignmentType;   //SHARE
        public String effectiveDate;    //2017-01-01
        public String expirationDate;   //2017-12-01
        public String firstName;    //K
        public String lastName; //C
        public String networkId;    //KC010100
        public String networkScheduleId;    //23232
        public String networkScheduleDescription;   //ONSITE
        public String organizationLocationId;   //ERIIII
        Public String locationAffiliationID;
    }
    public class cls_providerIdentifiers {
        public String id;   //A111
        public String type; //PRIMARY
    }
    public class cls_clinicalProgram {
        public String clinicalProgramVendor;    //WALGREEN
        public String serviceCategory;  //PHARM
        public String umDetermination;  //YES
    }
    public class cls_carrierType {
        public String carrierId;    //C11111
        public String carrierName;  //GARDIAN
        public String carrierExternalId;    //G2222
        public cls_lob[] lob;
    }
    public class cls_lob {
        public String lineOfBusinessId; //5343
        public String lineOfBusinessName;   //DENTAL
        public String lineOfBusinessDescription;    //DENTAL OFFICE
    }
    public static ACETFamilyMembershipJson2Apex parse(String json){
        return (ACETFamilyMembershipJson2Apex) System.JSON.deserialize(json, ACETFamilyMembershipJson2Apex.class);
    }    
}