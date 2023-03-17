public class ACETReferralSearchResult{
    public String resultMembername {get;set;}
    public String resultReferralnumber {get;set;}
    public String resultReferralstatus{get;set;}
    public String resultStartdate {get;set;}
    public String resultEnddate{get;set;}
    public String resultReferaltype {get;set;}
    public String resultRequestingtin {get;set;}
    public String resultPrimarytin {get;set;}
    public String resultRequestingprovider {get;set;}
    public String resultPrimaryprovider {get;set;}
    public String resultServicingtin {get;set;}
    public String resultServicingprovider {get;set;}
    public String resultDxcode {get;set;}
    public String resultDXDescription {get;set;}
    public Boolean selected {get; set;}
    public String resultreferralExternalID {get;set;}
    public String resultCreatedDate{get;set;}
    public String numberofvisit{get;set;}
    public String numberOfVisitUsed{get;set;}       // US935410
    public String numberOfVisitRemaining{get;set;}  // US935410
    public String noteText{get;set;}
    
    public list<Provider> providerlst{get;set;}
    public list<Service> servicelst{get;set;}
    public list<Diagnosis> diagnosisList{get;set;}
    public class Provider {
        public string resultProviderRole{get;set;}
        public string resultMPIN{get;set;}
        public string resultName{get;set;}
        public string resultNetworkStatus{get;set;}
        public string resultTIN{get;set;}
        public string resultAddress{get;set;}
        public string resultCity{get;set;}
        public string resultState{get;set;}
        public string resultZip{get;set;}
        public string speciality{get;set;}
    }
    public class Service {
        public string resultProcedureType{get;set;}
        public String resultProcedureCode{get;set;}
        public String resultDescription{get;set;}
    }
    public class Diagnosis{
        public string resultdiagCode{get;set;}
        public String resultdiadDesc{get;set;}
   }
   
   public ACETReferralSearchResult(){
        selected=false;
    }
}