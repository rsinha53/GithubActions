public class ACETHSASummaryJSON2Apex {

    public class PostalAddress {
        public String typeCode{get;set;}
        public String streetLine1{get;set;}
        public String streetLine2{get;set;}
        public String city {get;set;}
        public String countryCode {get;set;}
        public String postalCode {get;set;}
        public String stateCode{get;set;}
    }

    public class EmployerGroup {
        public String employerGroupId {get;set;}
        public String employerGroupName {get;set;}
    }

    public HsaSummaryResponse hsaSummaryResponse;

    public class Telephone {
        public String phoneType{get;set;}
        public String phoneNumber{get;set;}
    }

    public class ElectronicAddress {
        public String emailAddress {get;set;}
    }

    public class Individuals {
        public String firstName {get;set;}
        public String lastName {get;set;}
        public String birthDate {get;set;}
        public String genderCode {get;set;}
        public String socialSecurityNumber {get;set;}
        public PostalAddress postalAddress {get;set;}
        public List<Telephone> telephone {get;set;}
        public ElectronicAddress electronicAddress {get;set;}
        public List<AccountDetails> accountDetails {get;set;}
    }

    public class HsaSummaryResponse {
        public Individuals individuals;
    }

    public class AccountDetails {
        public String Id {get;set;}
        public String accountId {get;set;}
        public String accountCode {get;set;}
        public String accountName {get;set;}
        public String accountType {get;set;}
        public String totalBalance {get;set;}
        public String investedBalance {get;set;}
        public String availableBalance {get;set;}
        public EmployerGroup employerGroup {get;set;}
    }

}