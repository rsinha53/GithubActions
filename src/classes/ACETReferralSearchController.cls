public with sharing class ACETReferralSearchController extends ACETErrorHandler{
    
    public Interaction__c StartDate{get;set;}
    public Interaction__c EndDate{get;set;}
    public Interaction__c Interaction {get;set;}
    public string strReferralNumber{get;set;}
    public String ReferralType {get;set;}
    public string RefrStatus{get;set;}
    public Contact subject{get;set;}
    public String SourceOriginator {get;set;}
    public ACETHighlightsPanelAdditionalInfo AdditionalInfo {get;set;}
    public Boolean errorFlagForNoRecords {get;set;}      
    public string wrapperresultsStr{get;set;}
    public String hpAdditionInfoStr {get;set;}
    public ACETCallTopicsDataWrapper wrapper {get;set;}
    public list<ACETReferralSearchResult> lstReferrals{get;set;}
    public List<ACETReferralSearchResult> referralsresult{get;set;}
    public map<String,ACETReferralSearchResult> referralselMap{get;set;}
    public Boolean IsfilterApply {get;set;}
    public String selectedRefNumber{get;set;}
    public string surrogateKey {get; set;} 
    public string SRK {get; set;} 
    public String baseURL{get;set;}
    public Boolean isResearchUser {get;set;}
    public Boolean allowedUser {get;set;} 

    public ACETReferralWebservice ACETRW ;
   
    public void init(){
        IsfilterApply = false;
        AdditionalInfo = new ACETHighlightsPanelAdditionalInfo();
        String additionalInfostr = ApexPages.currentPage().getParameters().get('additionalInfo');
        map<String,String> errorMap=new map<String,String>();
        List<AcetErrorMessage__mdt> ErrorMessages =[SELECT  masterlabel,Error_Message__c,Message_Type__c,ServiceError__c,TopPriority__c,
                                                    Error_log_enabled__c FROM AcetErrorMessage__mdt ];//where masterlabel=:errorCode
        for(AcetErrorMessage__mdt em:ErrorMessages){
            errorMap.put(em.masterlabel, em.Error_Message__c);
        }
        system.debug('additionalInfostr '+additionalInfostr);
        SRK = ApexPages.currentPage().getParameters().get('SRK');
        if (!String.isEmpty(additionalInfostr)){        
            AdditionalInfo = (ACETHighlightsPanelAdditionalInfo)JSON.deserialize(additionalInfostr , ACETHighlightsPanelAdditionalInfo.class);
        }
        ACETWSCalloutResult findReferralServiceCalloutResult = new ACETWSCalloutResult();
        ACETRW = new ACETReferralWebservice();
          string additionalinfofirstname = AdditionalInfo.FirstName ;
          string additionalinfoLastName  = AdditionalInfo.LastName;
        if(additionalinfofirstname != null){       
        additionalinfofirstname = additionalinfofirstname.replace('\\', '');
        }
        if(additionalinfoLastName  != null){
        additionalinfoLastName = additionalinfoLastName.replace('\\', '');
        }
        findReferralServiceCalloutResult = ACETRW.findReferrals(additionalinfofirstname,additionalinfoLastName,AdditionalInfo.DOB,SRK);
        referralselMap = new Map<String,ACETReferralSearchResult>();
        lstReferrals = new list<ACETReferralSearchResult>();
        system.debug('findReferralServiceCalloutResult is '+findReferralServiceCalloutResult);
        if (findReferralServiceCalloutResult .Success != null && findReferralServiceCalloutResult .Success) {  
           errorFlagForNoRecords = false;   
           lstReferrals = (list<ACETReferralSearchResult>)findReferralServiceCalloutResult .Response;
          if(lstReferrals != null){
               for(ACETReferralSearchResult ac : lstReferrals){
               referralselMap.put(ac.resultreferralExternalID, ac);    
             }
           } 
       }
       else{
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
    public ACETReferralSearchController(){
        errorFlagForNoRecords = false;   
        IsfilterApply = false;
        StartDate = new Interaction__c();
        EndDate = new Interaction__c();
        Interaction = new Interaction__c();
        getloggedinProfileName();
        baseURL = String.valueof(URL.getSalesforceBaseUrl().toExternalForm());//Code Added By Chandan
        System.debug('baseURL='+baseURL);
        String orginstance;
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
        
        User usr = [select FederationIdentifier from user where id=:userinfo.getUserId()];
        
        String tempBaseURL = 'subscriberId={0}&userId={1}&functionId=Pcp_Referral&landingPage=createPcpReferral&applicationId=ACET&SAML_Object= ACET'; 
        List<String> fillers = new String[]{apexpages.currentpage().getparameters().get('memberId'),usr.FederationIdentifier};
        tempbaseURL = String.format(tempBaseURL, fillers);
        
        system.debug('tempbaseURL is '+tempbaseURL);
        system.debug('orginstance is '+orginstance);
        system.debug('ICUE is '+orginstance+'_ICUEEncryptionKey');
        String Key = ACETWrapEncryptionKey__c.getValues(orginstance+'_ICUEEncryptionKey').Key__c;
        system.debug('Key: '+Key+'tempBaseURL: '+tempBaseURL);
        baseURL += ACETURLEncryptionUtility.GetEncryptedValue(Key,'AES256',tempBaseURL);
        system.debug('**baseURL - '+ baseURL);
        getloggedinProfileName();

        //Get Provider Interaction SFDC Id
        String interactionId = ApexPages.currentPage().getParameters().get('interactionId'); 
          
        //Check if User is redirected to Member Search page from Provider detail page          
        if (!String.isEmpty(interactionId)){                        
            system.debug('InteractionId: ' + InteractionId);
            
        
            Interaction = ACETProviderUtility.GetInteractionByID(interactionId);
            SourceOriginator = Interaction.Interaction_Type__c;
            system.debug('Interaction: ' + Interaction + ', SourceOriginator: ' + SourceOriginator);
        }
        String contactId = ApexPages.currentPage().getParameters().get('contactId');
        if (!String.isEmpty(contactId)){ 
            subject = ACETProviderUtility.GetContactByID(contactId);
        }
       
        String additionalInfostr = ApexPages.currentPage().getParameters().get('additionalInfo');
        if (!String.isEmpty(additionalInfostr)){        
            AdditionalInfo = (ACETHighlightsPanelAdditionalInfo)JSON.deserialize(additionalInfostr , ACETHighlightsPanelAdditionalInfo.class);
        }
        hpAdditionInfoStr = JSON.serialize(AdditionalInfo);
        if(hpAdditionInfoStr.contains('&') || hpAdditionInfoStr.contains('\\'))
        {
        system.debug('hpAdditionInfoStr1 ---->'+hpAdditionInfoStr );
            hpAdditionInfoStr = hpAdditionInfoStr.replace('&', 'and');
             hpAdditionInfoStr = hpAdditionInfoStr.replace('\\', '');
             system.debug('hpAdditionInfoStr2 ---->'+hpAdditionInfoStr );
        
        }
        wrapper = new ACETCallTopicsDataWrapper();
        wrapper.CallTopic ='View PCP Referrals';
        wrapper.init();
        wrapper.CaseObj.Topic__c = 'View PCP Referrals';
        surrogateKey = ApexPages.currentPage().getParameters().get('SRK');
         if (!String.isEmpty(surrogateKey)){ 
            wrapper.surrogateKey = surrogateKey;
        }
        
        String refNumberstr = ApexPages.currentPage().getParameters().get('referralNumber');
        if (!String.isEmpty(refNumberstr)){        
            strReferralNumber = refNumberstr;
        }  
    }
    private void getloggedinProfileName(){ 
        String userRole = ACETUtility.GetUserRoleName();
        allowedUser = false;
        List<Call_Topic_Access__c> accesses = (List<Call_Topic_Access__c>)ACETQueryUtil.query(null,'Call_Topic_Access__c', null, null);
        for(Call_Topic_Access__c acc : accesses){
            if(acc.Call_Topic__c == 'Create PCP Referral'){
                String roles = acc.Limit_To_Roles__c;
                system.debug('$$$$roles'+roles);
                if(roles.contains(';'))
                {
                    system.debug('$$$$multipleroles'+roles);
                    List<String> rolesList = new List<String>(roles.split(';'));
                    for(String role : rolesList){
                        if(role == userRole){
                            allowedUser = true;
                        }
                        system.debug('$$$$$$$'+ role + ' roles ' + userRole);
                    }
                }
                else if(String.isNotBlank(roles) && roles.containsNone(';') && roles == userRole)
                {
                    allowedUser = true;
                }
                               
            }
            system.debug('$$$$$$$'+ acc.Call_Topic__c + 'roles ' + acc.Limit_To_Roles__c);

            
        }
        if(ACETUtility.GetUserProfileName() == 'Research User' && allowedUser == true){
            isResearchUser = true;
            allowedUser = false;
        } else if(ACETUtility.GetUserProfileName() == 'Research User' && allowedUser == false){
            isResearchUser = false;
            allowedUser = false;
        }
        else if(ACETUtility.GetUserProfileName() != 'Research User') {
            isResearchUser = false;
        }
    }

    public void navigateTodetail(){
        
        selectedRefNumber = ApexPages.currentPage().getParameters().get('ReferalNumber');
        if(selectedRefNumber != null) {
            wrapperresultsStr = json.serialize(referralselMap.get(selectedRefNumber));
        }
        system.debug('referralselMap.get(selectedRefNumber) is '+referralselMap.get(selectedRefNumber));
        system.debug('inside the method'+selectedRefNumber+'-----'+wrapperresultsStr);    
        
    }
     public void applyfilter(){
        system.debug('lstReferrals is '+lstReferrals);
        referralsresult = new list<ACETReferralSearchResult>();
        IsfilterApply = false;
        system.debug('default values-->'+strReferralNumber + '***' +ReferralType + '***' +RefrStatus + '***' +StartDate.tst_Date_Field__c + '***' +EndDate.tst_Date_Field__c);
        if(strReferralNumber == '' && ReferralType == null && RefrStatus == null && StartDate.tst_Date_Field__c == null && EndDate.tst_Date_Field__c == null ){
            IsfilterApply = false;
            return;
        }
        if(strReferralNumber != ''){
            IsfilterApply = true;
            for(ACETReferralSearchResult ac: lstReferrals){
                if(ac.resultreferralExternalID == strReferralNumber){
                    referralsresult.add(ac);
                    break;
                }
            }
        }
        else{
            IsfilterApply = true;
            boolean tempCheck = false;
            if(ReferralType != null){
               referralsresult =  filtrReferralList('ReferralType', ReferralType , lstReferrals);
               tempCheck = true;
            }
            if(RefrStatus != null){
                system.debug('Insert 1 block'+RefrStatus);
                if(tempCheck){
                    referralsresult =  filtrReferralList('RefrStatus', RefrStatus , referralsresult);
                }
                else{
                    referralsresult =  filtrReferralList('RefrStatus', RefrStatus , lstReferrals);
                }
                tempCheck = true;
            }
            if(StartDate.tst_Date_Field__c != null){
                if(tempCheck){
                    referralsresult =  filtrReferralList('StartDate.tst_Date_Field__c',ACETRW.formatDateWithZeros(ACETRW.ChangeDateFormat(String.valueof(StartDate.tst_Date_Field__c))), referralsresult);
                    
                    //referralsresult =  filtrReferralList('StartDate.tst_Date_Field__c',ACETRW.formattedDate(ACETRW.ChangeDateFormat(String.valueof(StartDate.tst_Date_Field__c))), referralsresult);
                }
                else{
                    referralsresult =  filtrReferralList('StartDate.tst_Date_Field__c',ACETRW.formatDateWithZeros(ACETRW.ChangeDateFormat(String.valueof(StartDate.tst_Date_Field__c))), lstReferrals);

                    //referralsresult =  filtrReferralList('StartDate.tst_Date_Field__c',ACETRW.formattedDate(ACETRW.ChangeDateFormat(String.valueof(StartDate.tst_Date_Field__c))), lstReferrals);
                    system.debug('test date'+startDate.tst_Date_Field__c.month());
                }
                tempCheck = true;
            }
            if(EndDate.tst_Date_Field__c != null){
                if(tempCheck){
                    referralsresult =  filtrReferralList('EndDate.tst_Date_Field__c', ACETRW.formatDateWithZeros(ACETRW.ChangeDateFormat(String.valueof(EndDate.tst_Date_Field__c))), referralsresult);

                    //referralsresult =  filtrReferralList('EndDate.tst_Date_Field__c', ACETRW.formattedDate(ACETRW.ChangeDateFormat(String.valueof(EndDate.tst_Date_Field__c))), referralsresult);
                }
                else{
                    referralsresult =  filtrReferralList('EndDate.tst_Date_Field__c', ACETRW.formatDateWithZeros(ACETRW.ChangeDateFormat(String.valueof(EndDate.tst_Date_Field__c))), lstReferrals);

                    //referralsresult =  filtrReferralList('EndDate.tst_Date_Field__c', ACETRW.formattedDate(ACETRW.ChangeDateFormat(String.valueof(EndDate.tst_Date_Field__c))), lstReferrals);
                }
                tempCheck = true;
            }
        }
        if(referralsresult != null){
            referralselMap = new Map<String,ACETReferralSearchResult>();
            for(ACETReferralSearchResult ac :referralsresult){
                referralselMap.put(ac.resultreferralExternalID , ac);
            }
        }
        system.debug('referralselMap-->'+referralselMap+'referralsresult-->'+referralsresult);
 
     }
     
     private list<ACETReferralSearchResult> filtrReferralList(String fieldName ,String varRef , list<ACETReferralSearchResult> listselectedRef){
         
         list<ACETReferralSearchResult> tempList = new list<ACETReferralSearchResult>();
         if(fieldName == 'ReferralType'){
             for(ACETReferralSearchResult ac: listselectedRef){
                if(ac.resultReferaltype == varRef){
                    tempList.add(ac);
                    //break;
                }
            }
         } 
         if(fieldName == 'RefrStatus'){
             for(ACETReferralSearchResult ac: listselectedRef){
                if(ac.resultReferralStatus == varRef){
                    tempList.add(ac);
                    system.debug('tempList***'+tempList);
                    //break;
                }
            }
        }
        if(fieldName == 'StartDate.tst_Date_Field__c'){
            system.debug('varRef***'+varRef);
            for(ACETReferralSearchResult ac: listselectedRef){
                system.debug('ac***'+ac.resultStartdate);
                if(ac.resultStartdate == varRef){
                    tempList .add(ac);
                    system.debug('tempList***'+tempList);
                   // break;
                }
            }
        }
        if(fieldName == 'EndDate.tst_Date_Field__c'){
            for(ACETReferralSearchResult ac: listselectedRef){
                if(ac.resultEnddate == varRef){
                    tempList .add(ac);
                    //break;
                }
            }
        }
        return tempList; 
    }
 
    public PageReference clearfilter(){
        startdate.tst_Date_Field__c = null;
        enddate.tst_Date_Field__c = null;
        strReferralNumber = null;
        ReferralType = null;
        RefrStatus = null;
        return null;
    }
 
    public list<SelectOption> getReferralTypeValues(){
        List<SelectOption> options = new List<SelectOption>();
        map<String,String> mapTempRef = new map<String,string>();
        if(lstReferrals != null) {
            for(ACETReferralSearchResult wrapRef : lstReferrals){
                mapTempRef.put(wrapRef.resultReferaltype ,wrapRef.resultReferaltype ); 
            }
        }
        options.add(new SelectOption('','--None--'));
        if(mapTempRef.keySet() != null){
            for(String temp : mapTempRef.keySet()){
                options.add(new SelectOption(temp ,temp));    
            } 
        }
     
        return options; 
        //
        //return null;
    }
    

}