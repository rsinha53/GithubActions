public class ACETFindEmployerGroupCallableJSON2Apex{
        public FindEmployerGroupsResponse findEmployerGroupsResponse {get;set;} 

    public class FindEmployerGroupsResponse {
        public List<EmployerGroup> employerGroup {get;set;} 
        public Pagination pagination {get;set;} 

    }
    
    public class EmployerGroup {
        public String groupNumber {get;set;} 
        public String sourceSysCode {get;set;} 
        public String groupName {get;set;} 
        public List<String> taxIdentificationNumber {get;set;} 
        public SizeDefinition sizeDefinition {get;set;} 
        public Address address {get;set;} 
        public List<Phone> phone {get;set;} 
        public GroupContract groupContract {get;set;} 

    }
    
    public class Pagination {
        public String pageNumber {get;set;} 
        public String pageSize {get;set;} 
        public String recordCount {get;set;} 
        public String totalCount {get;set;} 
        public String totalPages {get;set;} 
        public String moreRecords {get;set;} 

    }
    
    public class SizeDefinition {
        public String code {get;set;} 
        public String descr {get;set;} // in json: desc
    }
    
    public class GroupPurchase {
        public SizeDefinition stateofIssue {get;set;} 
        public SizeDefinition fundingArrangement {get;set;} 

    }
    
    public class Address {
        public String addressLine1 {get;set;} 
        public String addressLine2 {get;set;} 
        public String addressLine3 {get;set;} 
        public String city {get;set;} 
        public String postalCode {get;set;} 
        public String stateCode {get;set;} 
        public SizeDefinition salesOffice {get;set;} 

    }
    
    public class Phone {
        public String phoneType {get;set;} 
        public String phoneNumber {get;set;} 
        public String phoneExt {get;set;} 
        public String primaryIndicator {get;set;} 

    }
    
    public class GroupContract {
        public List<GroupPurchase> groupPurchase {get;set;} 
        public String startDate {get;set;} 
        public String renewalDate {get;set;} 
        public String expirationDate {get;set;} 
        public SizeDefinition status {get;set;} 

    }

}