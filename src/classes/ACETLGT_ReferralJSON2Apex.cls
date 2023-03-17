public class ACETLGT_ReferralJSON2Apex{
    
    public ReferralDetailsResponse referralDetailsResponse {get;set;} 
    
    public class Address {
        public String addressLine1 {get;set;} 
        public String city {get;set;} 
        public StatusCode state {get;set;} 
        public String postalCode1 {get;set;} 
        public String postalCode2 {get;set;} 
    }
    
    public class ProcedureCode {
        public String code {get;set;} 
        public String codeDesc {get;set;} 
        public String typeCode {get;set;} 
        public String typeCodeDesc {get;set;} 
    }
    
    public class ReferralDateRange {
        public String startDate {get;set;} 
        public String stopDate {get;set;} 
    }
    
    public class Referrals {
        public String referralId {get;set;} 
        public String referralTypeID {get;set;} 
        public String referralDescription {get;set;} 
        public String numberOfVisits {get;set;} 
        public ReferralDateRange referralDateRange {get;set;} 
        public StatusCode statusCode {get;set;} 
        //public SourceApplicationCode sourceApplicationCode {get;set;} 
        public String noteText {get;set;} 
        public String referralDate {get;set;} 
        public String createDateTime {get;set;} 
        public Member member {get;set;} 
        public List<Providers> providers {get;set;} 
        public List<Services> services {get;set;} 
        public List<Diagnosis> diagnosis {get;set;} 

        
    }
    
    /*public class Providers_Z {
        public String providerSeqNumber {get;set;} 
        public String category {get;set;} 
        public String firstName {get;set;} 
        public String middleName {get;set;} 
        public String lastName {get;set;} 
        public Address address {get;set;} 
        public List<SpecialityType> specialityType {get;set;} 
        public String telephoneNumber {get;set;} 
        public List<Role> role {get;set;} 
        public List<EnrolleIdentifiers> providerIdentifiers {get;set;} 
    }*/

    
    public class Providers {
        public String providerSeqNumber {get;set;} 
        public String category {get;set;} 
        public String firstName {get;set;} 
        public String middleName {get;set;} 
        public String lastName {get;set;} 
        public Address address {get;set;} 
        public List<SpecialityType> specialityType {get;set;} 
        public String telephoneNumber {get;set;} 
        public String faxNumber {get;set;} 
        public List<Role> role {get;set;} 
        public List<EnrolleIdentifiers> providerIdentifiers{get;set;} 
    }
    
    public class StatusCode {
        public String code {get;set;} 
        public String desc_Z {get;set;} // in json: desc
    }
    
    public class SpecialityType {
        public String code {get;set;} 
        public String desc_Z {get;set;} // in json: desc
        public String sourceSystem {get;set;} 
    }
    
    public class Role {
        public String id {get;set;} 
        public String desc_Z {get;set;} // in json: desc
    }
    
    public class Services {
        public String sequenceNumber {get;set;} 
        public ProcedureCode procedureCode {get;set;} 
        public String providerSeqNumber {get;set;} 
    }
    
    public class Pagination {
        public String pageSize {get;set;} 
        public String totalCount {get;set;} 
        public String startRecord {get;set;} 
        public String moreRecords {get;set;} 
    }
    
    public class SourceMemberId {
        public String id {get;set;} 
        public String type_Z {get;set;} // in json: type
    }
    
    public class Diagnosis {
        public String sequenceNumber {get;set;} 
        public ProcedureCode diagnosisCode {get;set;} 
    }
    
    public class ReferralDetailsResponse {
        public List<Referrals> referrals {get;set;} 
        public Pagination pagination {get;set;} 
		public List<errors> errors;
    }
    
    public class errors {
        public Integer code;    //400
        public String name; 
        public String severity; //INFORMATIONAL
        public String origin;   //eisl
        public String description;  //ERR004-Member not found
    }
    
    public class Member {
        public SourceMemberId sourceMemberId {get;set;} 
        public String firstName {get;set;} 
        public String lastName {get;set;} 
        public String middleName {get;set;} 
        public String suffixCode {get;set;} 
        public String birthDate {get;set;} 
        public StatusCode gender {get;set;} 
        public String relationshipCode {get;set;} 
        public List<EnrolleIdentifiers> enrolleIdentifiers {get;set;} 
    }
    
    public class EnrolleIdentifiers {
        public String id {get;set;} 
        public String typeCode {get;set;} 
        public String typeCodeDesc {get;set;} 
    
    }   
}