public class ACETProviderSearchResult implements Comparable
{
    public String TaxId { set; get; }
    public String NPI { set; get; }
    public String PlatinumProvider { set; get; }
    public String GroupName { set; get; }
    public String StreetAddress { set; get; }
    public String City { set; get; }
    public String State { set; get; }
    public String Zip { set; get; }
    public String PhoneNumber { set; get; }
    public String Facility { set; get; }
    public String ProviderId { set; get; }
    public String AddressId { set; get; }
    public String ProviderTypeCode { set;get;} 
     public String PrimaryAddress { set;get;}
    public String providerTINStatusCode { set;get;}
    public String ProvideraddressTypeCode { set;get;}
    public String County { set;get;} 
    public String Fax { set;get;}
    public String providerTINOwner { set;get;}
    
    public static String SortBy = 'TaxId';
    public static String SortOrder = 'Asc';
    
    public Integer compareTo(Object objToCompare)
    {
        ACETProviderSearchResult ProviderToCompare = (ACETProviderSearchResult)objToCompare;
        if (ProviderToCompare == null) return 1;
        
        Integer CompareResult = 0;
        if (SortBy == 'TaxId')
        {
            CompareResult = String.IsBlank(TaxId) ? -1 : TaxId.compareTo(ProviderToCompare.TaxId);
        }
        else if (SortBy == 'NPI')
        {
            CompareResult = String.IsBlank(NPI) ? -1 : NPI.compareTo(ProviderToCompare.NPI);
        }
        else if (SortBy == 'PlatinumProvider')
        {
            CompareResult = String.IsBlank(PlatinumProvider) ? -1 : PlatinumProvider.compareTo(ProviderToCompare.PlatinumProvider);
        }
        else if (SortBy == 'GroupName')
        {
            CompareResult = String.IsBlank(GroupName) ? -1 : GroupName.compareTo(ProviderToCompare.GroupName);
        }
        else if (SortBy == 'StreetAddress')
        {
            CompareResult = String.IsBlank(StreetAddress) ? -1 : StreetAddress.compareTo(ProviderToCompare.StreetAddress);
        }
        else if (SortBy == 'City')
        {
            CompareResult = String.IsBlank(City) ? -1 : City.compareTo(ProviderToCompare.City);
        }
        else if (SortBy == 'State')
        {
            CompareResult = String.IsBlank(State) ? -1 : State.compareTo(ProviderToCompare.State);
        }
        else if (SortBy == 'Zip')
        {
            CompareResult = String.IsBlank(Zip) ? -1 : Zip.compareTo(ProviderToCompare.Zip);
        }
        else if (SortBy == 'PhoneNumber')
        {
            CompareResult = String.IsBlank(PhoneNumber) ? -1 : PhoneNumber.compareTo(ProviderToCompare.PhoneNumber);
        }
        else
        {
            CompareResult = String.IsBlank(Facility) ? -1 : Facility.compareTo(ProviderToCompare.Facility);
        }
        
        if (SortOrder != 'Asc') 
        {
            CompareResult = CompareResult * -1;
        }
            
        return CompareResult;
    }
}