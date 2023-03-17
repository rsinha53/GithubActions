public with sharing class ACETViewBillingController{

    public string swivelBRMS_URL{get;set;}
    public ACETCallTopicsDataWrapper wrapper {get;set;}
    public string tableau_URL {get;set;}
    public string comments{get;set;} 
    public Contact Subject { get; set; }
    public Interaction__c  Interaction { get; set; }    
    public string redirectUrl {get; set;} 
    public String[] selectedValue{get;set;}
    public boolean notResearchUser {get;set;}
    public id interactionId{get;set;}
    public id contactid{get;set;}
    public string groupId;
    public ACETGroupDetail groupDetails{get;set;}
    
    public ACETHighlightsPanelAdditionalInfo AdditionalInfo {get;set;}
    public String hpAdditionInfoStr {get{
        return JSON.serialize(AdditionalInfo);
    }set;}          
    public String baseURL{get;set;}
    public String tabId{get;set;}
    public ACETViewBillingController()
    {   
        string InteractionId = apexpages.currentpage().getparameters().get('InteractionId');
        string contactId = apexpages.currentpage().getparameters().get('contactId');
        string callTopic = apexpages.currentpage().getparameters().get('callTopic');
        string tabId = apexpages.currentpage().getparameters().get('tabId');
        groupId = apexpages.currentpage().getparameters().get('groupId');
        fetchATNESysURL();
        getloggedinProfileName();
        System.debug('Invalid Id:::::'+InteractionId+'ID::::'+apexpages.currentpage().getparameters().get('Id'));
        system.debug('!!!TabId'+apexpages.currentpage().getparameters().get('tabId'));
        Interaction = ACETProviderUtility.GetInteractionByID(InteractionId);
        
        wrapper = new ACETCallTopicsDataWrapper();
        wrapper.CaseObj.Topic__c = callTopic;
        wrapper.AutodocComment = comments;
        wrapper.updategroupinfoSave = true;
        if(groupId != Null)
        {
            wrapper.caseObj.ID__c =groupId;
        }
        initHighlightPanelAdditionalInfo();
        selectedValue = new String[]{};
        fetchBRMSSysURL();
        baseURL = String.valueof(URL.getSalesforceBaseUrl().toExternalForm());
        String orginstance ;
        system.debug('----baseURL --baseURL --'+baseURL );
        for(ACETOrgInstanceURLToOrgNameMap__c orgname:ACETOrgInstanceURLToOrgNameMap__c.getAll().values()) {
            
            if(baseURL.contains(orgname.Name)) {
                system.debug('tname '+orgname.name);
                orginstance = ACETOrgInstanceURLToOrgNameMap__c.getValues(orgname.name).Org_Name__c;
            }
        }
        if(orginstance != null){
            system.debug('orginstance is '+orginstance);
            baseURL += ACETURLEncryptionUtility.getICUEURL(orginstance+'_OBPPViewBilling');
           // Passing Subject(MSID|I) and AppName(ACET) from Connected App Settings
            String tempBaseURL = 'Permission=U&BillGroup=ALL&GroupID={0}';
            List<String> fillers = new String[]{groupId};
            tempbaseURL = String.format(tempBaseURL, fillers);  
            baseURL += ACETURLEncryptionUtility.GetEncryptedValue(ACETWrapEncryptionKey__c.getValues(orginstance+'_OBPPEncryptionKey').Key__c,'AES256',tempbaseURL);
            system.debug('Baseurl'+baseurl);
        }
     
     }
    
     private void getloggedinProfileName(){ 
       try{
            notResearchUser = true;
            List<Profile> PROFILE = [SELECT Id, Name FROM Profile WHERE Id=:userinfo.getProfileId() LIMIT 1];
            String loggedinProfileName = PROFILE[0].Name;
        
            //Check if the logged-in User has profile 'Research' type
               if(loggedinProfileName.contains('Research'))
                { 
                    notResearchUser = false;
                }
        }catch(exception ex){
            System.debug('The exception is'+ ex.getmessage());
        }
       
    }  
    
    //function to fetch BRMS url 
    public void fetchBRMSSysURL(){    
         Map<String, ACETOrgNameToSwivelEndpointMap__c> mapEndpointDetails = ACETOrgNameToSwivelEndpointMap__c.getAll();
         string sandboxName = ACETUtility.GetOrgName();
         swivelBRMS_URL= ACETUtility.GetSwivelEndpointByOrgName(sandboxName,'BRMS',mapEndpointDetails);
    }
    
    private void initHighlightPanelAdditionalInfo(){
        if(AdditionalInfo == null){
            AdditionalInfo = new ACETHighlightsPanelAdditionalInfo(); 
        }        
         string addInfo = ApexPages.currentPage().getParameters().get('additionalInfo');
        if(addInfo != null)
        {
            AdditionalInfo  = (ACETHighlightsPanelAdditionalInfo)JSON.deserialize(addInfo, ACETHighlightsPanelAdditionalInfo.class);
        }
        /******added by sourabh ****/
        if(Interaction != Null && Interaction.Highlight_Panel_GroupInfo__c != null)
        {
            ACETGroupDetailsWrapper deserializedExceptionData = (ACETGroupDetailsWrapper)JSON.deserialize(Interaction.Highlight_Panel_GroupInfo__c, ACETGroupDetailsWrapper.class);
            System.debug('Group Additional information'+deserializedExceptionData);
            AdditionalInfo.UHCBS = deserializedExceptionData.UHCBS;    
            AdditionalInfo.GroupN = deserializedExceptionData.GroupName ;
            AdditionalInfo.GroupStatus = deserializedExceptionData.GroupStatus;
            AdditionalInfo.ServiceTeam = deserializedExceptionData.ServiceTeam;
            //AdditionalInfo.EffectiveStartDate = deserializedExceptionData.EffectiveStartDate;
            AdditionalInfo.RiskManagement = deserializedExceptionData.RiskManagement;
            AdditionalInfo.RatingMethod = '';
            AdditionalInfo.RenewalDate= deserializedExceptionData.RenewalDate; 
            AdditionalInfo.RelationshipType = deserializedExceptionData.RelationshipType ;
            AdditionalInfo.groupSName = deserializedExceptionData.groupSName;
        }
           
        hpAdditionInfoStr = JSON.serialize(AdditionalInfo);
    }
    
    public void fetchATNESysURL()
    {
         string sandboxName = ACETUtility.GetOrgName();
         system.debug('--------sandboxName ------'+sandboxName);
         tableau_URL = ACETUtility.GetSwivelEndpointByOrgName(sandboxName,'Tableau');
    }
}