public with sharing class ACETReinstateMemberController extends ACETErrorHandler {

    public String comments { get; set; }
    public integer memberID { get; set; }
    public  list<Alert__c> lstProviderAlert { get; set; }
    public Contact Subject { get; set; }
    public Interaction__c  Interaction { get; set; }    
    public ACETCallTopicsDataWrapper wrapper {get;set;}
    public boolean notResearchUser {get;set;}
    
    /*********** Added by Rupsa. US# *************************/
    public ACETMemberDetail MemberDetail {get;set;}
    public string swivelcirrus_URL{get;set;}
    public boolean isTerminated{get;set;}
    public String AutoDoc {get;set;}
    public string memberURLId{get;set;}
    public ACETHighlightsPanelAdditionalInfo AdditionalInfo {get;set;}
     public String hpAdditionInfoStr {get{
        return JSON.serialize(AdditionalInfo);
    }set;}
    public string surrogateKey {get; set;}
    public string groupId;
    ACETGetFamilyMemberWebService ACETGetMemWebService;
     
    //Constructor 
    public ACETReinstateMemberController()
    {    
       try{      
        memberURLId = ApexPages.currentPage().getParameters().get('Id');
        MemberDetail=new ACETMemberDetail(); 
        MemberDetail.memberID=memberURLId; 
        String InteractionId = apexpages.currentpage().getparameters().get('InteractionId');
        groupId = apexpages.currentpage().getparameters().get('groupId');
        if(InteractionId != null && InteractionId != ''){
            Interaction = ACETProviderUtility.GetInteractionByID(InteractionId);              
        }
        getloggedinProfileName();        
        wrapper = new ACETCallTopicsDataWrapper();
        wrapper.CaseObj.Topic__c = label.ACETCallTopicReinstateSubscriberFamilyMember;
        if(groupId != Null)
            wrapper.caseObj.ID__c =groupId;
        
        wrapper.updategroupinfoSave = true;
        surrogateKey = ApexPages.currentPage().getParameters().get('SRK');
         if (!String.isEmpty(surrogateKey)){ 
            wrapper.surrogateKey = surrogateKey;
        }
       } catch(Exception ex){
        setErrorMsg('MGD997',ex);
       }
    }
    
     
    private void getloggedinProfileName(){ 
       try{
        notResearchUser = true;
        List<Profile> PROFILE = [SELECT Id, Name FROM Profile WHERE Id=:userinfo.getProfileId() LIMIT 1];
        String loggedinProfileName = PROFILE[0].Name;
    
       if(loggedinProfileName.contains('Research'))
            { notResearchUser = false;}
    }
    
    catch(Exception ex){
     setErrorMsg('MGD997',ex);
     System.debug('The exception is'+ ex.getmessage());
     
     }
     
   }    
    
    public void toggleExceptionChk(){}

    public object getMemberData(){
        isTerminated = false;        
        Continuation getMembershipContinuation; 
        ACETGetMemWebservice = new ACETGetFamilyMemberWebService();
        memberDetail = new ACETMemberDetail();
        string coverageGroupNumber = apexpages.currentpage().getparameters().get('coverageGroupNumber');
        string coverageEffectiveDate = apexpages.currentpage().getparameters().get('coverageEffectiveDate');
        string coverageSRK = apexpages.currentpage().getparameters().get('coverageSRK');
        
        system.debug('coverageSRK --->'+coverageSRK+'---'+coverageGroupNumber +'----'+coverageEffectiveDate );
        if(coverageGroupNumber != Null && coverageGroupNumber != '' && coverageEffectiveDate != Null && coverageEffectiveDate !='')
        {
             memberDetail.SurrogateKey = coverageSRK;
             memberDetail.PreferredCoverage = new ACETMemberDetail.CoverageLine();
             memberDetail.PreferredCoverage.groupNumber = coverageGroupNumber;
             memberDetail.PreferredCoverage.effectiveDate = coverageEffectiveDate;
             memberDetail.PreferredCoverage.SurrogateKey = coverageSRK;         
        
        }
        system.debug('inside call membership :'+MemberDetail.SurrogateKey);
        if(!String.IsEmpty(MemberDetail.SurrogateKey)) {
            ACETGetMemWebservice = new ACETGetFamilyMemberWebService();
            system.debug('starting getmembership service');
            getMembershipContinuation = ACETGetMemWebservice.StartRequest(MemberDetail.SurrogateKey,MemberDetail,'GetMembershipCallback',null); 
                        system.debug('request prepared getmembership service');
        } 
        return getMembershipContinuation;
        
    }
    
    public PageReference GetMembershipCallback() {
        try{
        system.debug('inside call bacl method'); 
        ACETWSCalloutResult getMembershipResponse;
        getMembershipResponse = ACETGetMemWebservice.ProcessResponse(ACETGetMemWebservice.RequestLabel, MemberDetail);
        system.debug('inside call bacl method' + getMembershipResponse); 
        if(getMembershipResponse.Success) {
            system.debug('>>>>>>> >>>>>> '+MemberDetail);
            MemberDetail = (ACETMemberDetail)getMembershipResponse.Response;
        }else{
           setErrorMsg('GN'+getMembershipResponse.statusCode,null); 
       }

         system.debug('MemberDetail second callback '+JSON.serialize(MemberDetail)); 
       }catch(Exception ex){
          setErrorMsg('MGD997',ex);
       }    
        return null;
    }
    
}