/*
 * @Desc: US2974834 - Create  Benefit Check API Request
 * @Date: 18-12-2020
 * @Dev: Kavinda
*/
public class ACET_BenefitCheckRequest {

    public String certificationType {get;set;} 
    public Dates dates {get;set;} 
    public List<Diagnosis> diagnosis {get;set;} 
    public String facilityType {get;set;} 
    public String levelOfService {get;set;} 
    public String message {get;set;} 
    public Patient patient {get;set;} 
    public String placeOfService {get;set;} 
    public List<Procedures> procedures {get;set;} 
    public ReferringProvider referringProvider {get;set;} // Gaps
    public String requestCategory {get;set;} 
    public String serviceSettingType {get;set;} 
    public String serviceType {get;set;} 
    public List<ServicingProviders> servicingProviders {get;set;} 
    public String submissionDateTime {get;set;} 
    public String transactionId {get;set;}  
    
    public class MemberAddresses {
        public String address1 {get;set;} 
        public String address2 {get;set;}
        public String addressType {get;set;} 
        public String city {get;set;} 
        public String countryCode {get;set;} 
        public String state {get;set;} 
        public String zip {get;set;} 
        public String zipSuffix {get;set;} 
    }
    
    public class Address {
        public String city {get;set;} 
        public String line1 {get;set;} 
        public String line2 {get;set;} 
        public String state {get;set;} 
        public String zip {get;set;}  
    }
    
    public class ServicingProviders {
        public String MPIN {get;set;} 
        public String NPI {get;set;} 
        public String TAX {get;set;} 
        public Address address {get;set;} 
        public String firstName {get;set;} 
        public String id {get;set;} 
        public String lastName {get;set;} 
        public String primaryPhone {get;set;} 
        public String providerCategory {get;set;} 
        public String providerRole {get;set;}  
        public String middleName {get;set;}
        public String businesName {get;set;}
    }
    
    public class Dates {
        public String fromDate {get;set;} 
        public String toDate {get;set;} 
        public String type {get;set;} // in json: type 
    }
    
    public class Patient {
        public String SSN {get;set;} 
        public String dob {get;set;} 
        public String firstName {get;set;} 
        public String genderType {get;set;} 
        public String lastName {get;set;} 
        public List<MemberAddresses> memberAddresses {get;set;} 
        public String memberId {get;set;} 
        public String middleName {get;set;}
        public String policyNumber {get;set;} 
        public String relationshipCode {get;set;} 
        public String sourceMemberID {get;set;} 
        public String subscriberFirstName {get;set;} 
        public String subscriberID {get;set;} 
        public String subscriberLastName {get;set;}  
    }
    
    public class Procedures {
        public String code {get;set;} 
        public String numberOfPeriods {get;set;} 
        public String quantity {get;set;} 
        public String quantityQualifier {get;set;} 
        public String sampleModulus {get;set;} 
        public List<ServicingProviders> servicingProviders {get;set;} 
        public String timePeriodQualifier {get;set;} 
        public String type {get;set;} // in json: type
        public String unit {get;set;} 
        public String description {get;set;} 
        public String dmeTotalCost {get;set;}
        public String dmeClinicalIllnessDescText {get;set;}
        public String dmeEnternalFeedingSSONutrInd {get;set;}
        public String dmeFormulaNameText {get;set;}
        public String dmeInitialTreatmentDate {get;set;}
        public String dmeMedicalConditionText {get;set;}
        public String dmeProcurementType {get;set;}
        public String dmeServiceDescriptionText {get;set;}
        public String dmeSupplyDescText {get;set;} 
        public String procedureIndex {get;set;} 
    }
    
    public class Diagnosis {
        public String code {get;set;} 
        public String type {get;set;} // in json: type 
    }
    
    public class ReferringProvider {
        public String MPIN {get;set;} 
        public String NPI {get;set;} 
        public String TAX {get;set;} 
        public Address address {get;set;} 
        public String contact {get;set;} 
        public String firstName {get;set;} 
        public String lastName {get;set;} 
        public String providerCategory {get;set;}  
    }  
}