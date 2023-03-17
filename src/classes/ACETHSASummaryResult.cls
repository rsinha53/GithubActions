public class ACETHSASummaryResult
{
    public list<HSAAccountsWrapper> hsaAccounts{get;set;}
    public list<hsaBankAuthentication> accHolderList{get;set;}
    
    public class hsaBankAuthentication
    {
        public String accountHoldersName{get;set;}
        public String ssn{get;set;}
        public String address{get;set;}
        public String phone{get;set;}
        public String phoneType{get;set;}
        public String dob{get;set;}
    }
    
    public class HSAAccountsWrapper
    {
       public String hsaId{get;set;}
       public String HSAAccountNoMasked{get;set;}
       public String HSAAccountNo{get;set;}
       public String AccCode{get;set;}
       public String AccName{get;set;}
       public String cummulativeBalance{get;set;}
       public String investedBalance{get;set;}
       public String availableBalance{get;set;}
       public String administeredBy{get;set;} 
       public String groupName {get;set;} 
       public String groupId {get;set;}
    }



}