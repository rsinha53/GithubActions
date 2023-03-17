public with sharing class ACETProducerSearchResult implements Comparable
{
    public String Name{get;set;}
    public boolean hasName{get;set;}
    public String CompanyName {get;set;}  
    public String Status {get;set;} 
    public String LastName {get;set;}
    public String FirstName {get;set;}  
    public String MiddleInitial {get;set;}
    public String ProducerID {get;set;}
    public String ProducerTIN {get;set;}
    public String ProducerType {get;set;}
    public String State {get;set;}    
    public string producerMemberGrpStartDate {get;set;}
    public string producerMemberGrpEndDate {get;set;}   
    public string producerContact{get;set;} 
    public string producerState{get;set;} 
    public string producerCity{get;set;} 
    public string producerPhoneNumber{get;set;} 
    public string producerLegacyBrokerCode {get;set;}
    public static String SortBy = 'LastName';
    public static String SortOrder = 'Asc';
    public string producerEffectiveAsOfDate{get;set;}
    public string producerSSN{get;set;}
    public string producerUnMaskedSSN{get;set;}
    public string coverageType{get;set;}
    public string producerRoleType{get;set;}
    public string producerRole{get;set;}
    public string producerServiceRightsOnly{get;set;}
    public string producerCRID{get;set;}
    public string producerSplitPercent{get;set;}
    public string producerStreetLine1{get;set;}
    public string producerStreetLine2{get;set;}
    public string producerZipCode{get;set;}
    public string producerZipCodeSuffix{get;set;}
    public string producerWritingAgent{get;set;}
    public string producerPayee {get;set;}
     public string producerLegacySystem;
    public string producerLegacyId;
    public String customerNumber;
	public String customerName;
	public String adminSystem;
	public String producerCustomerStartDate;
	public String producerCustomerEndDate;
    
    public Integer compareTo(Object objToCompare)
    {
        ACETProducerSearchResult ProducerToCompare = (ACETProducerSearchResult)objToCompare;        
        if (ProducerToCompare == null) return 1;
        
        Integer CompareResult = 0;
        if (SortBy == 'LastName')
        {
            CompareResult = String.IsBlank(LastName) ? -1 : LastName.compareTo(ProducerToCompare.LastName);
        }
        else if (SortBy == 'FirstName')
        {
            CompareResult = String.IsBlank(FirstName) ? -1 : FirstName.compareTo(ProducerToCompare.FirstName);
        }
        else if (SortBy == 'CompanyName')
        {
            CompareResult = String.IsBlank(CompanyName) ? -1 : CompanyName.compareTo(ProducerToCompare.CompanyName);
        }
        else if (SortBy == 'MiddleInitial')
        {
            CompareResult = String.IsBlank(MiddleInitial) ? -1 : MiddleInitial.compareTo(ProducerToCompare.MiddleInitial);
        }
        else if (SortBy == 'ProducerID')
        {
            CompareResult = String.IsBlank(ProducerID) ? -1 : ProducerID.compareTo(ProducerToCompare.ProducerID);
        }
        else if (SortBy == 'ProducerTIN')
        {
            CompareResult = String.IsBlank(ProducerTIN) ? -1 : ProducerTIN.compareTo(ProducerToCompare.ProducerTIN);
        }
        
        else if (SortBy == 'State')
        {
            CompareResult = String.IsBlank(State) ? -1 : State.compareTo(ProducerToCompare.State);
        }
        
        if (SortOrder != 'Asc') 
        {
            CompareResult = CompareResult * -1;
        }
            
        return CompareResult;
    }   

}