public with sharing class ACETCreatePCPReferralController {
    public ACETCallTopicsDataWrapper wrapper {get;set;}
    public string surrogateKey {get;set;}
    public string topic {get;set;}
    public string refNumber{get;set;}
    public String baseURL{get;set;}
    public boolean notResearchUser {get;set;}
    
    public ACETCreatePCPReferralController () {
        try{
        wrapper = new ACETCallTopicsDataWrapper();
        wrapper.init();
        wrapper.CaseObj.Topic__c = 'Create PCP Referral';
        initHighlightPanelAdditionalInfo();
        getloggedinProfileName();
         String interactionId = ApexPages.currentPage().getParameters().get('interactionId'); 
          
        //Check if User is redirected to Member Search page from Provider detail page          
        if (!String.isEmpty(interactionId)){                        
            system.debug('InteractionId: ' + InteractionId);
            
        
            wrapper.Interaction = ACETProviderUtility.GetInteractionByID(interactionId);
            
        }
        
        /** added by Pavan on 1/27/2017 for US495232 *****/
            system.debug('apexpages.currentpage().getparameters() is '+apexpages.currentpage().getparameters());
        //Contact varContact = [select FirstName , lastName from Contact where Id=:apexpages.currentpage().getparameters().get('contactId')];
        System.debug('*****'+wrapper.AdditionalInfo.PolicyNumber+'***'+apexpages.currentpage().getparameters().get('memberId'));
        baseURL = String.valueof(URL.getSalesforceBaseUrl().toExternalForm());
        String orginstance;
        //String orginstance = ACETUtility.GetOrgName(ACETOrgInstanceURLToOrgNameMap__c.getAll());
        //String tempBaseURL;
        for(ACETOrgInstanceURLToOrgNameMap__c orgname:ACETOrgInstanceURLToOrgNameMap__c.getAll().values()) {
            system.debug('orgname.name is '+orgname.Name);
            if(baseURL.contains(orgname.Name)) {
                system.debug('tname '+orgname.name);
                orginstance = ACETOrgInstanceURLToOrgNameMap__c.getValues(orgname.name).Org_Name__c;
            }
        }
        if(orginstance != null){        
            system.debug('orginstance is '+orginstance);
            baseURL += ACETURLEncryptionUtility.getICUEURL(orginstance+'_ICUEPCPReferral');
        }
        
        /*tempBaseURL = 'cdbXrefId=780991&cdbXrefIdPartitionNumber=91';
        tempBaseURL = tempBaseURL+'&policy='+ wrapper.AdditionalInfo.PolicyNumber;
        tempBaseURL = tempBaseURL +'&subscriberId='+ apexpages.currentpage().getparameters().get('memberId');
        tempBaseURL = tempBaseURL +'&firstName='+ varContact.FirstName;
        tempBaseURL = tempBaseURL +'&lastName='+ varcontact.LastName;
        tempBaseURL = tempBaseURL +'&functionId=PcpReferral&landingPage=pcpReferral&applicationId=ACET';*/
        User usr = [select FederationIdentifier from user where id=:userinfo.getUserId()];
        
        String tempBaseURL = 'subscriberId={0}&userId={1}&functionId=Pcp_Referral&landingPage=createPcpReferral&applicationId=ACET&SAML_Object= ACET';
        List<String> fillers = new String[]{apexpages.currentpage().getparameters().get('memberId'),usr.FederationIdentifier};
        tempbaseURL = String.format(tempBaseURL, fillers);
        
        system.debug('tempbaseURL is '+tempbaseURL);
        
        String Key = ACETWrapEncryptionKey__c.getValues(orginstance+'_ICUEEncryptionKey').Key__c;
        system.debug('Key: '+Key+'tempBaseURL: '+tempBaseURL);
        baseURL += ACETURLEncryptionUtility.GetEncryptedValue(Key,'AES256',tempBaseURL);
        //baseURL = ACETURLEncryptionUtility.getEncryptedPCPReferralURL(wrapper.AdditionalInfo.PolicyNumber, apexpages.currentpage().getparameters().get('memberId'), varContact.FirstName, varcontact.LastName);
        system.debug('**baseURL - '+ baseURL);
        
        surrogateKey = ApexPages.currentPage().getParameters().get('SRK');
        if(!string.isEmpty(surrogateKey)){ 
            wrapper.surrogateKey = surrogateKey;
        }   
        }
        catch(exception ex)
        {
            system.debug('Exception is '+ex.getMessage()+'at line '+ex.getLineNumber());
        }
    }
    private void getloggedinProfileName(){ 
       try{
            notResearchUser = true;
            List<Profile> PROFILE = [SELECT Id, Name FROM Profile WHERE Id=:userinfo.getProfileId() LIMIT 1];
            String loggedinProfileName = PROFILE[0].Name;
        
            //Check if the logged-in User has profile 'Research' type
               if(loggedinProfileName.contains('Research'))
                { notResearchUser = false;}
        }catch(exception ex){
            System.debug('The exception is'+ ex.getmessage());
        }
       
    }
    private void initHighlightPanelAdditionalInfo(){
        string additionalInfoStr = apexpages.currentpage().getparameters().get('additionalInfo');
        system.debug('additionalInfoStr is '+additionalInfoStr);
        wrapper.AdditionalInfo = (ACETHighlightsPanelAdditionalInfo)json.deserialize(additionalInfoStr, ACETHighlightsPanelAdditionalInfo.class); 
    }
    
    /*public List<SelectOption> getTopics(){
        list<SelectOption> options = new list<SelectOption>();
        options.add(new SelectOption('','--None--'));
        options.add(new SelectOption('Created','Created'));
        options.add(new SelectOption('Not Created','Not Created'));
        return options;        
    }*/
    
    public void updateWrapper(){
        wrapper.blockedCallTopic = topic; 
    } 
}