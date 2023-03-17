public class ACETCorrespondenceHistoryController {

    Public String type{get;set;}
    public ACETCallTopicsDataWrapper wrapper {get;set;}
    //public ACETHighlightsPanelAdditionalInfo AdditionalInfo {get;set;}
    /*public String searchBy{get;set;}
    public String dateOfService{get;set;}
    public String status{get;set;}
    public Boolean deductible{get;set;}
    public String inNetwork{get;set;}*/
    public String claimnumber{get;set;}
    
    /*public String claimtype{get;set;}
    public Boolean startdatedisabled{get;set;}
    public Boolean enddatedisabled{get;set;}
    public Boolean  dateofservicedisabled {get;set;}*/
   
    public String taxid{get;set;}
    /*public String AuthorizationNumber{get;set;}
    public String ReferralNumber{get;set;}
    // Hide or UnHide Fields
    public Boolean authnumberhide{get;set;}
    public Boolean referralhide{get;set;}
    public Boolean casenumberhide{get;set;}
    public Boolean networkstatushide{get;set;}
    public Boolean deductiblehide{get;set;}
    public Boolean claimtypehide{get;set;}
    public Boolean taxidhide{get;set;}
    public Boolean claimnumberhide{get;set;}*/
    public Case startdate {get;set;}
    public Case enddate {get;set;}
    // Make Field Required
    public String claimNoReqd{get;set;}
    public String startDateReqd{get;set;}
    public String endDateReqd{get;set;}
   /* public String authorizationNoReqd{get;set;}
    public String taxIdReqd{get;set;}
    public String referralNoReqd{get;set;}
    public Boolean claimmandatory{get;set;}
    public String providers{get;set;}
    public boolean notResearchUser {get;set;}
    public boolean disableDates {get;set;}
     */
     //added by khoushik for sorting
      public String SortBy {get;set;}
    public String SortOrder {get;set;}
    public String LastSortBy{get;set;}
    public boolean ischecked{get;set;}
   /*public String strSelectedClaims{get;set;}
   public string surrogateKey {get; set;}*/
   
    public List<ACETCorrespondenceHistoryResult>  Correspondence{ set; get; }
    //public String ClaimsResultJson{get;set;}
    public Interaction__c Interaction { get; set; }
    /*public String SourceOriginator {get;set;}
    public Contact Provider {get;set;}  
    public Contact Subject {get;set;}*/
    public ACETHighlightsPanelAdditionalInfo AdditionalInfo {get;set;}
    /*public Boolean isClaim {get;set;}
    public String hpAdditionInfoStr {get;set;}
    public boolean isCancelCaseCreation{get;set;}
    */
    Public void init()
    {
        wrapper = new ACETCallTopicsDataWrapper();
        startdate = new case();
        enddate = new case();
        enddate.tst_Date_Field__c = null;
        startdate.tst_Date_Field__c = null;
        Correspondence = new List<ACETCorrespondenceHistoryResult>();
        ACETCorrespondenceHistoryResult result = new ACETCorrespondenceHistoryResult();
        result.Address1 = '16283 IVORY COURT';
        result.city = 'Chino Hills';
        result.Claimnumber = '123456';
        result.deliverymethod = 'mail';
        result.Documentid = '12345';
        result.email = 'abc@optum.com';
        result.fax = '9172141118';
        result.Name = 'Connie Grimm';
        result.RequestDate = system.today();
        result.Requestid = 123;
        result.Requestsource = 'ACET';
        result.Sentdate = system.today();
        result.state = 'MN';
        result.zip = '12345';
        
        Correspondence.add(result);
        initHighlightPanelAdditionalInfo();
        String interactionId = ApexPages.currentPage().getParameters().get('interactionId'); 
          
        //Check if User is redirected to Member Search page from Provider detail page          
        if (!String.isEmpty(interactionId)){                        
            system.debug('InteractionId: ' + InteractionId);
            
        
            wrapper.Interaction = ACETProviderUtility.GetInteractionByID(interactionId);
            
        }
    }
     private void initHighlightPanelAdditionalInfo(){
        string additionalInfoStr = apexpages.currentpage().getparameters().get('additionalInfo');
        wrapper.AdditionalInfo = new ACETHighlightsPanelAdditionalInfo(); 
        if(additionalInfoStr != null && additionalInfoStr != '')
        wrapper.AdditionalInfo = (ACETHighlightsPanelAdditionalInfo)json.deserialize(additionalInfoStr, ACETHighlightsPanelAdditionalInfo.class); 
    }
}