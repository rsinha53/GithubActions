public with sharing class ACETReferralDetailsController extends ACETErrorHandler {
    
    public String notes{get;set;}
    public Interaction__c Interaction {get;set;}
    public Contact subject{get;set;}
    public String SourceOriginator {get;set;}
    public ACETHighlightsPanelAdditionalInfo AdditionalInfo{get;set;}
    public String referralID{get;set;}
    public ACETCallTopicsDataWrapper wrapper {get;set;}
    public List<ACETReferralSearchResult> refsearchvalues{get;set;}
    public ACETReferralSearchResult wrapperresults1 {get;set;}  
    public ACETReferralWebservice ACETRW ;
    public map<String,ACETReferralSearchResult> referralselMap{get;set;}
    public list<ACETReferralSearchResult> lstReferrals{get;set;}
    
    public void init(){
        referralID= ApexPages.currentPage().getParameters().get('id').trim();
       
        system.debug('ApexPages.currentPage().getParameters() is '+ApexPages.currentPage().getParameters());
       /*String response = ApexPages.currentPage().getParameters().get('wrapperresultsStr');
       system.debug('response-->'+response);*/
        
        
        AdditionalInfo = new ACETHighlightsPanelAdditionalInfo();
        String additionalInfostr = ApexPages.currentPage().getParameters().get('additionalInfo');
        String SRK = ApexPages.currentPage().getParameters().get('SRK');
        if (!String.isEmpty(additionalInfostr)){        
            AdditionalInfo = (ACETHighlightsPanelAdditionalInfo)JSON.deserialize(additionalInfostr , ACETHighlightsPanelAdditionalInfo.class);
        }
        ACETWSCalloutResult findReferralServiceCalloutResult = new ACETWSCalloutResult();
        ACETRW = new ACETReferralWebservice();
        //findReferralServiceCalloutResult = ACETRW.findReferrals('Jacqueline','Henry','1969-06-17','890504607');
        findReferralServiceCalloutResult = ACETRW.findReferrals(AdditionalInfo.FirstName,AdditionalInfo.LastName,AdditionalInfo.DOB,SRK);
        referralselMap = new Map<String,ACETReferralSearchResult>();
        lstReferrals = new list<ACETReferralSearchResult>();
        system.debug('findReferralServiceCalloutResult is '+findReferralServiceCalloutResult);
        if (findReferralServiceCalloutResult .Success != null && findReferralServiceCalloutResult .Success) {   
           lstReferrals = (list<ACETReferralSearchResult>)findReferralServiceCalloutResult .Response;
            system.debug('lstReferrals is '+lstReferrals);
          if(lstReferrals != null){
               for(ACETReferralSearchResult ac : lstReferrals){
               referralselMap.put(ac.resultreferralExternalID, ac);    
             }
           } 
            system.debug('referralselMap is '+referralselMap.keySet());
            //String wrapperresultsStr = json.serialize(referralselMap.get(referralID));
            //system.debug('wrapperresultsStr is '+wrapperresultsStr);
            if(referralselMap.containsKey(referralID)){
                system.debug('referralID is '+referralselMap.get(referralID));
            wrapperresults1 = referralselMap.get(referralID);
                //(ACETReferralSearchResult)JSON.deserialize(wrapperresultsStr,ACETReferralSearchResult.class); //06-Dec
            system.debug('wrapperresults1####' + wrapperresults1);
            }
       }else{
             if(findReferralServiceCalloutResult.statusCode==400) {
                          setErrorMsg('GN400B');
             }
            else if(findReferralServiceCalloutResult.statusCode==404 || findReferralServiceCalloutResult.statusCode==500) {
                          setErrorMsg('GN'+findReferralServiceCalloutResult.statusCode);
            } 
            else {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, system.Label.ACETUnexpectedErrorMessage));
           }            
       }          
        
        
    }
    
    public  ACETReferralDetailsController(){
       
       Interaction = new Interaction__c();
       //AdditionalInfo = new ACETHighlightsPanelAdditionalInfo();
       String interactionId = ApexPages.currentPage().getParameters().get('interactionId');    
       if (!String.isEmpty(interactionId)){                        
          Interaction = ACETProviderUtility.GetInteractionByID(interactionId);
          SourceOriginator = Interaction.Interaction_Type__c;
       }
       String contactId = ApexPages.currentPage().getParameters().get('contactId');
       if (!String.isEmpty(contactId)){ 
            subject = ACETProviderUtility.GetContactByID(contactId);
       }
       String additionalInfostr = ApexPages.currentPage().getParameters().get('additionalInfo');
       if (!String.isEmpty(additionalInfostr)){        
            AdditionalInfo = (ACETHighlightsPanelAdditionalInfo)JSON.deserialize(additionalInfostr , ACETHighlightsPanelAdditionalInfo.class);
       }
     string surrogateKey = ApexPages.currentPage().getParameters().get('SRK'); 
       wrapper = new ACETCallTopicsDataWrapper();
       wrapper.init();
       if (!String.isEmpty(surrogateKey)){ 
            wrapper.surrogateKey = surrogateKey;
        }
       
       wrapper.CaseObj.Topic__c = 'View PCP Referrals';
    }
}