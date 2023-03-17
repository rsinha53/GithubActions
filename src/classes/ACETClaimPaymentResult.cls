public class ACETClaimPaymentResult{
    //payment search
    public String GUID {get;set;} //manually generated  
    public String SeriesDesignator {set;get;}
    public String PaymentTotal {set;get;    }
    public String checkDate {set;get;}
    public String PayeeName {set;get;}
    public String PayeeAddress {set;get;}
    public String City {set;get;}
    public String State { set; get; }
    public String Zip { set; get; } 
    public ACETClaimPaymentResult(){
            GUID = ACETGUIDUtil.newGuid();  
    }
    //payment details
    public String  PaymentType { set; get; }
    public String  CheckEFTNumber { set; get; }
    public String  BulkCheck { set; get; }
    public String  CheckStatus { set; get; }
    public Date IssuedDate {set;get;}
    Public String PaymentIssueDate{set;get;}
    //payee information
    public String  PayeeType {set;get;}
    public String  PayeeID {set;get;}   
    public String  PayeeAddressLine1 {set;get;}
    public String  PayeeAddressLine2 {set;get;}
    public String  PayeeAddressCity {set;get;}
    public String  PayeeAddressState {set;get;}
    public String  PayeeAddressZip {set;get;}
    //Claims
    public Claims clms{set;get;}
    public List<Claims> lstClaims {set;get;}
    
    public class Claims{
        public String  ClaimNumber {set;get;}
        public String  MemberID {set;get;}
        public String  PolicyNumber {set;get;}
        public String  PatientAccountNumber {set;get;}
        public String  FirstName {set;get;}
        public String  LastName {set;get;}
        public String  Relationship {set;get;}
        public String  PaidAmount {set;get;}
        public String StartDate {set;get;}
        public String EndDate {set;get;}
        
    }
}