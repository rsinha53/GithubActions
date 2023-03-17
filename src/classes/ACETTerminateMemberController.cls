public with sharing class ACETTerminateMemberController extends ACETErrorHandler{

    public String comments { get; set; }
    public Integer memberID { get; set; }
    public Contact subject {get;set;}
    public List<Alert__c> lstMemAlert{get;set;}
    public List<Alert__c> lstProviderAlert {get;set;}
    public ACETCallTopicsDataWrapper wrapper {get;set;}
    public ACETMemberDetail MemberDetail {get;set;}
    public string swivelcirrus_URL{get;set;}
    public String memberURLId{get;set;}
    public ACETHighlightsPanelAdditionalInfo AdditionalInfo {get;set;}
    public Interaction__c Interaction { get; set; }    
     public String hpAdditionInfoStr {get{
        return JSON.serialize(AdditionalInfo);
    }set;}
    public string surrogateKey {get; set;}  
    public string groupId {get;set;}  
    ACETGetFamilyMemberWebService ACETGetMemWebService;
     
    public ACETTerminateMemberController()
    {     
      try{ 
        memberURLId = ApexPages.currentPage().getParameters().get('Id');        
        MemberDetail=new ACETMemberDetail();
        MemberDetail.memberID=memberURLId; 
        String InteractionId = apexpages.currentpage().getparameters().get('InteractionId');
        if(InteractionId != null && InteractionId != ''){
           Interaction = ACETProviderUtility.GetInteractionByID(InteractionId);
        }
        groupId = apexpages.currentpage().getparameters().get('groupId');
        
        wrapper = new ACETCallTopicsDataWrapper();
        wrapper.CaseObj.Topic__c = label.ACETCallTopicTerminateSubscriberFamilyMember;    
        if(groupId != Null)
        wrapper.caseObj.ID__c =groupId;
                
        wrapper.updategroupinfoSave = true;
        surrogateKey = ApexPages.currentPage().getParameters().get('SRK');
        if (!String.isEmpty(surrogateKey)){ 
            wrapper.surrogateKey = surrogateKey;
        } 
        } 
        catch(Exception ex){
          setErrorMsg('MGD997',ex);
        }
        
    }
           
    
    public object getMemberData(){
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
         }
         catch(Exception ex){
          setErrorMsg('MGD997',ex);
       } 
        return null;
    }
    
}