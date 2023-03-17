public class ACETMemberSearchResult implements Comparable{
    public set<string> IDs {get;set;}
    Public String Id {get; set;}
    public string individualIdentifier{get;set;}
    public String LastName {get;set;}
    public String FirstName {get;set;}  
    public String MiddleInitial {get;set;}
    public String Gender {get;set;}
    public String DOB {get;set;}
    public String SCRId {get;set;}
    public String SSNum {get;set;}
    public String SSN {get;set;}
    public String Address {get;set;}
    public String City {get;set;}
    public String State {get;set;}
    public String Zip {get;set;}
    public String SurrogateKey {get;set;} 
    public Set<String> SurrogateKeys {get;set;}
    public String SurrogateKeysStr {get;set;}
    public String SourceCode {get;set;}
    
    public static String SortBy = 'LastName';
    public static String SortOrder = 'Asc';
    
    public ACETMemberSearchResult() {
        SurrogateKeys = new Set<String>(); 
        Ids = new Set<String>();     
    }
    
    public Integer compareTo(Object objToCompare){
        ACETMemberSearchResult memberToCompare = (ACETMemberSearchResult)objToCompare;
                
        if(memberToCompare == null) return 1;
        
        Integer compareResult = 0;
        if(SortBy == 'ID'){
            compareResult = (ID == null? -1 : (ID.compareTo(memberToCompare.ID)));          
        }else if(sortBy == 'LastName'){
            compareResult = (LastName == null? -1 : (LastName.compareTo(memberToCompare.LastName)));            
        }else if(sortBy == 'FirstName'){
            compareResult = (FirstName == null? -1 : (FirstName.compareTo(memberToCompare.FirstName)));         
        }else if(sortBy == 'MiddleInitial'){
            compareResult = (MiddleInitial == null? -1 : (MiddleInitial.compareTo(memberToCompare.MiddleInitial)));         
        }else if(sortBy == 'Gender'){
            compareResult = (Gender == null? -1 : (Gender.compareTo(memberToCompare.Gender)));          
        }else if(sortBy == 'DOB'){
            compareResult = (DOB == null? -1 : (DOB.compareTo(memberToCompare.DOB)));           
        }else if(sortBy == 'SSN'){
            compareResult = (SSN == null? -1 : (SSN.compareTo(memberToCompare.SSN)));           
        }else if(sortBy == 'Address'){
            compareResult = (Address == null? -1 : (Address.compareTo(memberToCompare.Address)));           
        }else if(sortBy == 'City'){
            compareResult = (City == null? -1 : (City.compareTo(memberToCompare.City)));            
        }else if(sortBy == 'State'){
            compareResult = (State == null? -1 : (State.compareTo(memberToCompare.State)));         
        }else if(sortBy == 'Zip'){
            compareResult = (Zip == null? -1 : (Zip.compareTo(memberToCompare.Zip)));           
        }
        
        if(SortOrder != 'Asc') compareResult = compareResult * -1;
        return compareResult;
    }
    
        
}