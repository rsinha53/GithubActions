public class ACETLGT_GetFamilyMembershipJson2Apex {
    public cls_getFamilyMembershipResponse getFamilyMembershipResponse{get;set;}
    public class cls_getFamilyMembershipResponse {
        public cls_individual[] individual{get;set;}
    }
    public class cls_individual {
        public String individualIdentifier{get;set;} //1118280
        public cls_name name{get;set;}
        public String birthDate{get;set;}    //1987-03-03
        public String genderCode{get;set;}   //M
        public String genderDescription{get;set;}    //Male
        public String socialSecurityNumber{get;set;} //123456789
        public String privacyIndicator{get;set;} //Y
        public String relationshipCode{get;set;} //001
        public String relationshipDescription{get;set;}  //Spouse
        public cls_address[] address{get;set;}
        public cls_identifiers[] identifiers{get;set;}
        public cls_membership[] membership{get;set;}
    }
    public class cls_name {
        public String firstName{get;set;}    //Jack
        public String lastName{get;set;} //Jinny
        public String middleName{get;set;}   //Jim
        public String nameSuffix{get;set;}   //Jr
    }
    public class cls_address {
        public String typeCode{get;set;} //HOM
        public String addressLine1{get;set;} //Morristown
        public String addressLine2{get;set;} //131
        public String city{get;set;} //BaskingRidge
        public String postalCode{get;set;}   //07307
        public String stateCode{get;set;}    //NJ
        public String countryCode{get;set;}  //US
        public String countryDescription{get;set;}   //United States of America
    }
    public class cls_identifiers {
        public String id{get;set;}   //123
        public String type{get;set;} //SRK
    }
    public class cls_membership {
        public String sourceSysCode{get;set;}    //CR
        public cls_coverages[] coverages{get;set;}
        public cls_utilizationPlan[] utilizationPlan{get;set;}
        public cls_cob[] cob{get;set;}
        public cls_providers[] providers{get;set;}
        public cls_clinicalProgram[] clinicalProgram{get;set;}
        public cls_carrierType carrierType{get;set;}
        public cls_identifiers[] identifiers{get;set;}
    }
    public class cls_coverages {
        public String groupNumber{get;set;}  //123456789
        public String groupName{get;set;}    //Cirrus
        public String eligibilitySystemTypeCode{get;set;}    //AAAA
        public String claimSystemTypeCode{get;set;}  //AAAA
        public String memberStatus{get;set;}
        public cls_bundleOptions[] bundleOptions{get;set;}
    }
    public class cls_bundleOptions {
        public cls_benefits[] benefits{get;set;}
    }
    public class cls_benefits {
        public String benefitBundleId{get;set;}  //OptionId
        public String benefitBundleName{get;set;}    //GTLG BUNDLE
        public String benefitBundleOptionId{get;set;}    //OptionId
        public String benefitBundleOptionDescription{get;set;}   //
        public String benefitEffectiveDate{get;set;} //2007-03-04
        public String benefitExpirationDate{get;set;}    //2020-03-04
        public String benefitPlanId{get;set;}    //M000000023
        public String benefitPlanName{get;set;}  //CTLG DIRECT HSA D&C
        public String benefitType{get;set;}  //HMO
        public String benefitTypeDescription{get;set;}   //Auto
        public String coverageLevelCode{get;set;}    //2
        public cls_product product{get;set;}
        public String relationshipCode{get;set;} //001
        public String relationshipDescription{get;set;}  //Spouse
        public String memberIdCardSerialNumber{get;set;} //A1234567
        public String subscriberIdCardSerialNumber{get;set;} //S987654
        public String eligibilityStatusCode{get;set;}    //AAAA
        public String serviceArea{get;set;}  //NE
        public String cancelReasonTypeCode{get;set;} //0
        public String planType{get;set;} //H
        public String networkScheduleID{get;set;}
        public String marketSegment{get;set;}    //T
        public String stateOfIssueCode{get;set;} //ER
        public String fundingArrangementCode{get;set;}   //ON
        public String fundingArrangementDescription{get;set;}    //ON TIME
        public String coverageLastUpdateDate{get;set;}   //20170101
        public String individualGroupTypeCode{get;set;}  //E
        public cls_coverageLevelList[] coverageLevelList{get;set;}
        public cls_holdList[] holdList{get;set;}
        public cls_indicators indicators{get;set;}
    }
    public class cls_product {
        public String productIdentifier{get;set;}    //A111
        public String productName{get;set;}  //Dental
        public String productType{get;set;}  //PRIMARY
    }
    public class cls_coverageLevelList {
        public String covLevelCode{get;set;} //FAM
        public String covLevelDesc{get;set;} //Family
        public String covLevelEffDate{get;set;}  //2018-10-01
        public String covLevelExpDate{get;set;}  //9999-12-31
    }
    public class cls_holdList {
    }
    public class cls_indicators {
        public String erisaIndicator{get;set;}   //0
        public String qmscoIndicator{get;set;}   //Y
        public String onshoreRestrictionIndicator{get;set;}  //Y
        public String proofOfHealthCoverageIndicator{get;set;}   //Y
        public String dvcnIndicator{get;set;}    //Y
        public String pcpRequiredIndicator{get;set;} //Y
        public String clickToCall{get;set;}  //Y
        public String clickToChat{get;set;}  //Y
        public String activationMessaging{get;set;}  //Y
        public String secureMessaging{get;set;}  //Y
        public String hsaIndicator{get;set;}
    }
    public class cls_utilizationPlan {
        public String planId{get;set;}   //ASO_STD_00001
        public String entityId{get;set;} //BOSS Pop ID
        public String externalPlanId{get;set;}   //POP44603
    }
    public class cls_cob {
        public String cobTypeCode{get;set;}  //A
        public String cobTypeCodeDescription{get;set;}   //Auto
        public String custodyCode{get;set;}  //S
        public String otherInsurancePrimacyIndicator{get;set;}   //p
        public String coverageType{get;set;} //1
        public String medicareEntitlementType{get;set;}
        public String medicareEntitlementReasonCode{get;set;}
        public String cobEffectiveStartDate{get;set;}    //2007-03-04
        public String cobEffectiveEndDate{get;set;}  //2020-03-04
        public String otherInsuranceVerifyDate{get;set;} //2018-01-02
        public String otherInsurancePolicyNumber{get;set;}   //A12345
        public String otherInsuranceCardholderId{get;set;}   //B23456
        public String otherInsuranceCarrierName{get;set;}    //GARDIAN
        public String cobRelatedEntityContactTelephoneNumber{get;set;}   //9738909090
    }
    public class cls_providers {
        public cls_providerIdentifiers[] providerIdentifiers{get;set;}
        public String assignmentType{get;set;}   //SHARE
        public String effectiveDate{get;set;}    //2017-01-01
        public String expirationDate{get;set;}   //2017-12-01
        public String firstName{get;set;}    //K
        public String lastName{get;set;} //C
        public String networkId{get;set;}    //KC010100
        public String networkScheduleId{get;set;}    //23232
        public String networkScheduleDescription{get;set;}   //ONSITE
        public String organizationLocationId{get;set;}   //ERIIII
        public String locationAffiliationID{get;set;}
        //US3806899 Start
        public String assignmentLevel {get;set;}
        public String organizationName {get;set;}
        public String organizationId {get;set;}
        //US3806899 End
    }
    public class cls_providerIdentifiers {
        public String id_z{get;set;}   //A111
        public String type_z{get;set;} //PRIMARY
    }
    public class cls_clinicalProgram {
        public String clinicalProgramVendor{get;set;}    //WALGREEN
        public String serviceCategory{get;set;}  //PHARM
        public String umDetermination{get;set;}  //YES
    }
    public class cls_carrierType {
        public String carrierId{get;set;}    //C11111
        public String carrierName{get;set;}  //GARDIAN
        public String carrierExternalId{get;set;}    //G2222
        public cls_lob[] lob{get;set;}
    }
    public class cls_lob {
        public String lineOfBusinessId{get;set;} //5343
        public String lineOfBusinessName{get;set;}   //DENTAL
        public String lineOfBusinessDescription{get;set;}    //DENTAL OFFICE
    }
    public static ACETLGT_GetFamilyMembershipJson2Apex parse(String json){
        return (ACETLGT_GetFamilyMembershipJson2Apex) System.JSON.deserialize(json, ACETLGT_GetFamilyMembershipJson2Apex.class);
    }    

    
}