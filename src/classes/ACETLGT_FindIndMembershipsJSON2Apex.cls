public class ACETLGT_FindIndMembershipsJSON2Apex {

    public FindIndividualMembershipsResponse findIndividualMembershipsResponse {get;set;} 
    
    public class FindIndividualMembershipsResponse {
        public List<Individuals> individuals {get;set;}
        //public Pagination pagination{get;set;} 
    }
    
    /* public class Pagination {
        public String pageNumber {get;set;} 
        public String pageSize {get;set;} 
        public String recordCount {get;set;} 
        public String totalCount {get;set;} 
        public String totalPages {get;set;} 
    }*/
    
    public class Individuals {
        public String individualIdentifier {get;set;} 
        public Name name {get;set;} 
        public String birthDate {get;set;} 
        public String genderCode {get;set;} 
        public Address address {get;set;} 
        public String socialSecurityNumber {get;set;} 
        public List<Telephone> telephone {get;set;} 
        public List<Memberships> memberships {get;set;} 
    }
    
    public class Name {
        public String firstName {get;set;} 
        public String lastName {get;set;} 
        public String middleName {get;set;} 
        public String nameSuffix {get;set;} 

    }

    public class Address {
        public String typeCode {get;set;} 
        public String addressLine1 {get;set;} 
        public String addressLine2 {get;set;} 
        public String city {get;set;} 
        public String postalCode {get;set;} 
        public String stateCode {get;set;} 
        public String countryCode {get;set;} 
        public String countryDescription {get;set;} 
    }
    
    public class Telephone {
        public String phoneType {get;set;} 
        public String phoneNumber {get;set;} 

    }
    
    public class Memberships {
        public String sourceSysCode {get;set;} 
        public List<Coverages> coverages {get;set;} 
        public List<Identifiers> identifiers {get;set;} 
        public List<Identifiers> enrolleeSystemSpecificIdentifiers {get;set;} 
    }
    
    public class Coverages implements Comparable{
        public List<Identifiers> subscriberSystemSpecificIdentifiers {get;set;} 
        public String groupNumber {get;set;} 
        public String groupName {get;set;} 
        public String membershipEffectiveDate {get;set;} 
        public String membershipExpirationDate {get;set;} 
        public String coverageType {get;set;} 
        public String coverageTypeDescription {get;set;} 
        public String coverageLevelCode {get;set;} 
        public Product product {get;set;} 
        public Benefit benefit {get;set;} 
        public String relationshipCode {get;set;} 
        public String relationshipDescription {get;set;} 
        public String privacyIndicator {get;set;} 
        public LegacyAttributes legacyAttributes {get;set;} 
		public Integer daysGap{get;set;} 
        
        //Added by Abhinav - US3358395 Speciality Benefits
        public String contractOptionTypeCode {get;set;} 
        public String contractOptionTypeDescription {get;set;} 
        
        public void setCoverages(){
            system.debug('========22-22======='+this.membershipEffectiveDate);
            system.debug('========22-22======='+this.membershipExpirationDate);
            date memEff = Date.valueOf(this.membershipEffectiveDate);
            date memEnd = Date.valueOf(this.membershipExpirationDate);
            if(memEff.daysBetween(Date.today()) < memEnd.daysBetween(Date.today()))
              daysGap = memEff.daysBetween(Date.today());
            else
              daysGap = memEnd.daysBetween(Date.today());
        }
        public Integer compareTo(Object objToCompare){
            
            Coverages covToCompare = (Coverages)objToCompare;
            system.debug('========23-2======='+this.coverageType);
            system.debug('========23-2======='+this.membershipEffectiveDate);
            system.debug('========23-2======='+this.membershipExpirationDate);
            system.debug('========23-1======='+covToCompare.coverageType);
            system.debug('========23-1======='+covToCompare.membershipEffectiveDate);
            system.debug('========23-1======='+covToCompare.membershipExpirationDate);
            if(covToCompare == null) return 1;
            
            Integer currCovdaysGap = Date.valueOf(this.membershipEffectiveDate).daysBetween(Date.today()) < 0 ? Date.valueOf(this.membershipEffectiveDate).daysBetween(Date.today()) * -1 :Date.valueOf(this.membershipEffectiveDate).daysBetween(Date.today());
            Integer currCovEnddaysGap = Date.valueOf(this.membershipExpirationDate).daysBetween(Date.today()) < 0 ? Date.valueOf(this.membershipExpirationDate).daysBetween(Date.today()) * -1 :Date.valueOf(this.membershipExpirationDate).daysBetween(Date.today());
            Integer currFinalCovdaysGap;
            Integer compCovdaysGap = Date.valueOf(covToCompare.membershipEffectiveDate).daysBetween(Date.today()) < 0 ? Date.valueOf(covToCompare.membershipEffectiveDate).daysBetween(Date.today()) * -1 :Date.valueOf(covToCompare.membershipEffectiveDate).daysBetween(Date.today()) ;
            Integer compCovEnddaysGap = Date.valueOf(covToCompare.membershipExpirationDate).daysBetween(Date.today()) < 0 ? Date.valueOf(covToCompare.membershipExpirationDate).daysBetween(Date.today()) * -1 : Date.valueOf(covToCompare.membershipExpirationDate).daysBetween(Date.today()) ;
            Integer compFinalCovdaysGap;
            
            if(currCovdaysGap > currCovEnddaysGap)
                currFinalCovdaysGap = currCovEnddaysGap;
            else
                currFinalCovdaysGap = currCovdaysGap;
            
            if(compCovdaysGap > compCovEnddaysGap)
                compFinalCovdaysGap = compCovEnddaysGap;
            else
                compFinalCovdaysGap = compCovdaysGap;
            
            Integer compareResult = this.coverageType.compareTo(covToCompare.coverageType);
            if (compareResult != 0) {
                system.debug('========23-3======='+compareResult);
            	return compareResult;
                
            } else {
                system.debug('========23-23======='+ currFinalCovdaysGap);
                system.debug('========23-23======='+ compFinalCovdaysGap);
                //return this.daysGap.compareTo(covToCompare.daysGap);
                if (currFinalCovdaysGap == compFinalCovdaysGap) 
                    return 0;
                if (currFinalCovdaysGap > compFinalCovdaysGap) 
                    return 1;
            	else
                	return -1;
            }
        }
    }
    
    public class Identifiers{
        public String id {get;set;} 
        public String type_Z {get;set;} // in json: type
    }
    
    public class Benefit {
        public String benefitPlanId {get;set;} 
        public String benefitPlanName {get;set;} 
        public String planOptionID {get;set;} 
        public String riderOnlyIndicator {get;set;} 
        public String bookOfBusinessTypeCode {get;set;}
        public list<CustomerPurchase> customerPurchase {get;set;} 
    }
    
    
    public class Product {
        public String productIdentifier {get;set;} 
        public String productName {get;set;} 
        public String productType {get;set;} 
    }
    
    
    public class LegacyAttributes {
        public String eligibilitySystemTypeCode {get;set;} 
        public String claimSystemTypeCode {get;set;}
        public String policyNumber{get;set;} 
    }
     public class CustomerPurchase {
        public String customerPurchaseId {get;set;} 
        public list<CustomerPurchaseVersions> customerPurchaseVersions {get;set;}
        
    }
     public class CustomerPurchaseVersions {
        public String customerPurchaseVersionId {get;set;} 
        public String customerPurchaseStatusDescription {get;set;}
        public String contractOptionStartDate {get;set;} 
        public String contractOptionEndDate {get;set;}
        
    }
}