public class ACETHoldRestrictionsJSON2Apex{
    public SelectHoldRestResponse selectHoldRestrictionsResponse{get; set;}
    public class SelectHoldRestResponse {
        public selectHoldRest selectHoldRestrictions{get; set;}
    }
    
    public class selectHoldRest{
        public List<holdCodeInfo> holdList{get;set;}
    }
        
    public class holdCodeInfo{
        public String holdCode{get;set;}
        public String holdDescription{get;set;}
        public String effectiveDate{get;set;}
        public String expirationDate{get;set;}
        public String holdNote{get;set;}
        public List<String> holdRestriction{get;set;}
        public String holdLevel{get;set;}
    }

}