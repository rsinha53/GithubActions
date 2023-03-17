//
//Generated by AdminBooster
//

public class ACET_CDBWebserviceJSONtoApex{
    public eligibilities[] eligibilities;
    public eligibilityMetaData eligibilityMetaData;
    public class eligibilities {
        public sourceIndividual sourceIndividual;
        public memberships[] memberships;
    }
    public class sourceIndividual {
        public boolean active;
        public alternateIdentifiers alternateIdentifiers;
        //public String birthSequenceNumber;    //001 
        public demographicInfo demographicInfo;
        public eligibilityAttributes eligibilityAttributes;
        public String enrolleeSourceCode;   //CS
        //public String enrolleeSourceId;   //09061930061364461700001
        //public String individualIdentifier;   //cdb:3:310071963:CS:09061930061364461700001
        //public legacyAttributes legacyAttributes;
        //public organizationType organizationType;
        public personName personName;
        public postalAddresses[] postalAddresses;
        //public String primeDependentCode; 
        //public boolean researchAuthorizationIndicator;
        //public String socialSecurityNumber;   //613644617
        //public sourceSystemAttributes sourceSystemAttributes;
        //public String sourceSystemCode;   //CDB
    }
    public class alternateIdentifiers {
        public alternateIds[] alternateIds;
        public subscriberIds[] subscriberIds;
        //public employerAssignedIds[] employerAssignedIds;
        
        public String alternateSubscriberId;    //996858301
        //public employerAssignedIds employerAssignedIds;
        public String enterpriseIndividualIdentifier;
        //public Integer familyId;  //19456045
        //public hicNumbers hicNumbers;
        //public mbiNumbers mbiNumbers;
        //public medicaidRecipientNumbers medicaidRecipientNumbers;
        //public memberAlternateIds memberAlternateIds;
        //public memberFamilyLinkIds memberFamilyLinkIds;
        public String memberId; //
        //public priorMemberIds priorMemberIds;
        //public sourceSystemIds[] sourceSystemIds;
        //public survivingSpouseIds survivingSpouseIds;
    }
    public class alternateIds {
        public String identifier;   //996858301
    }
    public class subscriberIds {
        public String identifier;   //996858301
    }
    public class enterpriseIndividualIdentifier {
    }
    
    /*
    public class employerAssignedIds {
        public string identifier;
    }
   
    public class hicNumbers {
    }
    public class mbiNumbers {
    }
    public class medicaidRecipientNumbers {
    }
    class memberAlternateIds {
    }
    public class memberFamilyLinkIds {
    }
    public class priorMemberIds {
    }
    public class sourceSystemIds {
        public String identifier;   //09061930061364461700001
    }
    public class survivingSpouseIds {
    }*/
    public class demographicInfo {
        public String birthDate;    //1992-07-03
        //public ethnicity ethnicity;
        public genderType genderType;
        //public race race;
    }
    /*public class ethnicity {
    }*/
    public class genderType {
        public String code; //M
    }
    /*public class race {
    }*/
    public class eligibilityAttributes {
        //public String enrolleeMemberFacingIdentifier; //
        public relationshipType relationshipType;
        public String subscriberMemberFacingIdentifier; //00613644617
    }
    public class relationshipType {
        public String description;  //Self
    }
    /*public class legacyAttributes {
        //public cancelReasonType cancelReasonType;
        //public governmentProgramType governmentProgramType;
        //public String stateIssueCode; //CO
    }
    public class organizationType {
        //public String code;   //
    }*/
    public class personName {
        public String firstName;    //JASON
        public String lastName; //MADRUGA
        public String middleName;   //A
        public String suffix;   //
    }
    public class postalAddresses {
        //public addressType addressType;
        //public String beginDate;  //2022-01-25
        //public endDate endDate;
        //public isoCountry isoCountry;
        public String line1Text;    //3207 GREEN HAVEN CIR
        public String line2Text;    //
        public String postalCode;   //80126
        //public String postalSuffixCode;   //
        //public boolean preferredIndicator;
        public boolean primaryIndicator;
        public String stateProvinceCode;    //CO
        public String townName; //HIGHLANDS RANCH
    }
    public class addressType {
        public String code; //M
    }
    public class endDate {
    }
    public class isoCountry {
        //public String code;   //US
    }
    public class sourceSystemAttributes {
        //public cdb cdb;
    }
    /*public class cdb {
        public String cesGroupNumber;   //0906193
        public String legacyProductCode;    //
        public String legacyProductId;  //
        public referenceData referenceData;
    }
    public class migratedMemberships {
    }
    public class referenceData {
        public String coverageLevelTypeCode;    //4
        public String coverageTypeCode; //A
    }*/
    public class memberships {
        //public boolean active;
        //public cancelReasonType cancelReasonType;
        //public claimSystemType claimSystemType;
        //public String coveragePaidThruDate;   //9999-12-31
        public customerAccount customerAccount;
        public String customerAccountIdentifier;    //0906193
        //public String divisionCode;   //
        //public String effectiveDate;  //2022-02-01
        //public String eligibilityGracePeriodThruDate; //9999-12-31
        //public eligibilitySystemType eligibilitySystemType;
        //public legacyAttributes legacyAttributes;
        //public marketSegment marketSegment;
        //public marketType marketType;
        // commented on May24th by Prajnith as we are not using these references
        //public String memberEnrollmentOtherIdentifiers;
        /*
         * "memberEnrollmentOtherIdentifiers": [
            {
              "typeCode": "EU3"
            }
          ],
        */
        // commented on May24th by Prajnith as we are not using these references
        //public String memberMarketNumber; //0005440
        /*public organization organization;
        public panelNumber panelNumber;
        public String passportGroupNumber;  //
        public plan plan;
        public String planCode; //
        public product product;
        public String recordType;   //HEALTH_COVERAGE
        public sourceSystemAttributes sourceSystemAttributes;
        public String sourceSystemCode; //CDB
        public String subscriberIndividualIdentifier;*/ //cdb:3:310071963:CS:09061930061364461700001
        public String terminationDate;  //9999-12-31
    }
    /*public class cancelReasonType {
        public String code; //
    }
    public class claimSystemType {
        public String code; //01
    }*/
    public class customerAccount {
        //public businessArrangement businessArrangement;
        public String customerAccountIdentifier;    //0906193
        //public obligor obligor;
        //public String purchasePlanIdentifier; //cdb:CS:0906193:A:ACIS002
        //public sharedArrangement sharedArrangement;
    }
    /*public class businessArrangement {
        public String code; //A
        public String description;  //ASO
    }
    public class obligor {
        public String code; //01
    }
    public class sharedArrangement {
        public String code; //00
    }
    public class eligibilitySystemType {
        public String code; //01
    }
    public class governmentProgramType {
        public String code; //
    }
    public class marketSegment {
    }
    public class marketType {
        public String code; //50
    }
    public class memberEnrollmentOtherIdentifiers {
    }
    
    public class organization {
        public String planVariationCode;    //0010
        public String reportingCode;    //0010
    }
    public class panelNumber {
    }
    public class plan {
    }
    public class product {
        public categoryType categoryType;
        public healthCoverageType healthCoverageType;
        public serviceType serviceType;
    }
    public class categoryType {
        public String code; //
    }
    public class healthCoverageType {
        public String description;  //PHYSICAL HEALTH
    }
    public class serviceType {
        public String code; //7
    }*/
    public class eligibilityMetaData {
        public Integer totalResults;    //23
    }
    public static ACET_CDBWebserviceJSONtoApex parse(String json){
        return (ACET_CDBWebserviceJSONtoApex) System.JSON.deserialize(json, ACET_CDBWebserviceJSONtoApex.class);        
    }

        
}