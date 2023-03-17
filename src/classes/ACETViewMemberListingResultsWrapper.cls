public class ACETViewMemberListingResultsWrapper implements comparable{
    public String firstName {get; set;}
    public String lastName {get; set;}
    public String memberID {get; set;}
    public String relationShip {get; set;}
    public String bundleId {get; set;}
    public String bundleDescription {get; set;}// US2607851- Sunil Vennam
    public String effectiveDate {get; set;}
    public String terminationDate {get; set;}
    public String contractType {get; set;}
    public String billingGroup {get; set;}
    public String billingGroupDesc {get; set;}
    public String status {get; set;}
    public String memberDOB {get; set;}
    public String planOption {get;set;}
    public String population {get;set;}
    public String age {get;set;}
    public String continuationType{get;set;}
    public Integer compareTo(Object ObjToCompare) {
        return lastName.CompareTo(((ACETViewMemberListingResultsWrapper)ObjToCompare).lastName );
    }
    public ACETViewMemberListingResultsWrapper() {
        
    }
}