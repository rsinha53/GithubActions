public with Sharing class ACETPharmacyController 
{    
    public ACETCallTopicsDataWrapper wrapper {get;set;}
    public boolean showSA {get;set;}
    public string hpAdditionInfoStr{get;set;}
    
    //Added by Vinay for Passing Carrier ID
    public transient ACETNimbusGetSSBAPI ACETGetSubscriptionWS;
    public String groupNo {get; set;}
    public String EndDateSSB {get; set;}
    public String bundleOptionId {get; set;}
    public String SRKID {get; set;}
    public String SubSRKID {get; set;}
    public String EffectiveDate {get; set;} 
    Public String benefitEffectivedate{get;set;}
    Public String benefitEnddate{get;set;}
    public String benefitPlanId { get; set; } 
    public String SSBCarrierId {get;set;}
    Public String customerPurchaseId {get;set;}
    private ACETGroupPlanBenefitWrapper ACETPlanBenefitSearchResults;
    
    public ACETHighlightsPanelAdditionalInfo additionalInfo {
        get;
        set;
    }
    public string policyNumber {
        get;
        set;
    }
    
        public string csrfNumber {get;set;}

    
    public Contact conObj {
        get;
        set;
    }
    
    public string memberId {
        get;
        set;
    }
    
    public Interaction__c interaction {
        get;
        set;
    }
    
    public String selectedValue { get; set; }
    
    public string sourceOriginator {get;set;}
    public String ISETURL { get; set; }
    public String surrogateKey;
    
    public void SSBOnLoadPharmacy(){ 
            ACETWSCalloutResult callOut = new ACETWSCalloutResult(); 
            ACETGetSubscriptionWS = new ACETNimbusGetSSBAPI();
            system.debug(bundleOptionId+':: '+SRKID+'::'+ChangeDateFormatForOIL(EffectiveDate)+'::'+ChangeDateFormatForOIL(EndDateSSB)+'::'+ groupNo);
            callOut = ACETGetSubscriptionWS.init(bundleOptionId, SRKID , SubSRKID, ChangeDateFormatForOIL(benefitEffectivedate) ,ChangeDateFormatForOIL(benefitEnddate),'', groupNo, '','',customerPurchaseId);//US2962032 updated benefit effective and end dates in ssb callout 
            system.debug('GroupNO:::'+groupNo);  
            ACETPlanBenefitSearchResults = (ACETGroupPlanBenefitWrapper)callOut.Response;
        
          if(ACETPlanBenefitSearchResults != null && ACETPlanBenefitSearchResults.carId != null){
            for(string str : ACETPlanBenefitSearchResults.carId){
                SSBCarrierId = str;
                system.debug('CarrierIdClass'+SSBCarrierId);
            }
        }
    }
    
    public ACETPharmacyController(){
        showSA = false; 
        wrapper = new ACETCallTopicsDataWrapper();
        wrapper.CaseObj.Topic__c = 'Pharmacy Inquiry';
        wrapper.CaseRecordTypeLabel = 'Employer&Broker';
        EndDateSSB = ApexPages.currentPage().getParameters().get('EndDate');
        EffectiveDate = ApexPages.currentPage().getParameters().get('EffectiveDate');
        benefitEnddate = ApexPages.currentPage().getParameters().get('benefitEnddate'); //US2962032 
        benefitEffectivedate = ApexPages.currentPage().getParameters().get('benefitEffectivedate');
        bundleOptionId = ApexPages.currentPage().getParameters().get('bundleOptionId');
        groupNo = ApexPages.currentPage().getParameters().get('grpnum');
        SRKID = apexpages.currentpage().getparameters().get('SRK');  
        SubSRKID = apexpages.currentpage().getparameters().get('coverageSRK');
        system.debug('---------SubSRK'+ApexPages.currentPage().getParameters().get('coverageSRK'));
        groupNo = ApexPages.currentPage().getParameters().get('GroupNumber');  
        system.debug('GroupNO::' + groupNo +'bundleOptionId::'+bundleOptionId + 'EndDateSSB::'+EndDateSSB + 'EffectiveDate::'+EffectiveDate);
        String strSurrogateKey = apexpages.currentpage().getparameters().get('SRK');
         wrapper.SurrogateKey = strSurrogateKey;
        additionalInfo = new ACETHighlightsPanelAdditionalInfo();
        String additionalInfostr = ApexPages.currentPage().getParameters().get('additionalInfo');
       customerPurchaseId = ApexPages.currentPage().getParameters().get('cpid');
       
        String contactId = ApexPages.currentPage().getParameters().get('contactId');
        surrogateKey = ApexPages.currentPage().getParameters().get('SRK');
        Wrapper.caseobj.surrogate_key__c = surrogatekey;
        System.debug('surrogateKey ---'+surrogateKey );
        System.debug('contactId::'+ contactId);
        
        if (!String.isEmpty(contactId)) {
            conObj  = new Contact();
            conObj = ACETProviderUtility.GetContactByID(contactId);
            system.debug(LoggingLevel.INFO, 'conObj: ' + conObj);
            memberId = conObj.EID__c;
        }
        String interactionId = ApexPages.currentPage().getParameters().get('interactionId');
        System.debug('interactionId::'+ interactionId);
        interaction = ACETProviderUtility.GetInteractionByID(interactionId);
        sourceOriginator = Interaction.Interaction_Type__c;
        
        if (!String.isEmpty(additionalInfostr)) {
            additionalInfo = (ACETHighlightsPanelAdditionalInfo) JSON.deserialize(additionalInfostr, ACETHighlightsPanelAdditionalInfo.class);
            //AdditionalInfo.DOB = ApexPages.currentPage().getParameters().get('DOB');
            policyNumber = additionalInfo.PolicyNumber;
			groupNo = additionalInfo.GroupNumber;
			bundleOptionId = additionalInfo.BenefitBundleOptionId;
            hpAdditionInfoStr = JSON.serialize(additionalInfo);            
            system.debug(LoggingLevel.INFO, 'additionalInfo: ' + additionalInfo);
            /*if (memberId == '707481') {
                ISETURL = GenerateISETURL('1111', 'Leslie', 'Hall', '08/20/1974', 'F');
            }
            else {
                ISETURL = GenerateISETURL('1000016501', 'Leslie', 'Hall', '08/20/1974', 'F');
            }*/   
            SSBOnLoadPharmacy();
            ISETURL = GenerateISETURL(additionalInfo.MemberId, additionalInfo.FirstName, additionalInfo.LastName, additionalInfo.DOB, additionalInfo.Gender ,additionalInfo.GroupNumber);
            
        }

    }    
    
    public void showSaMethodCon(){
        showSA = true;
    }
    public List<SelectOption> getPharmacyInquiryCallTypes() {
        List<SelectOption> options = new List<SelectOption>();            
        options.add(new SelectOption('Authorizations/Overrides','Authorizations/Overrides'));             
        options.add(new SelectOption('Benefits/Eligibility','Benefits/Eligibility'));
        options.add(new SelectOption('Claim Status','Claim Status'));
        options.add(new SelectOption('Drug Pricing','Drug Pricing'));
        options.add(new SelectOption('Mail Order Information','Mail Order Information'));
        options.add(new SelectOption('Pharmacy Lookup','Pharmacy Lookup'));
        options.add(new SelectOption('Specialty Pharmacy','Specialty Pharmacy'));
        options.add(new SelectOption('Other','Other'));        
        
        return options;
        
    }
    
    public String getCSRFURL() {
        String sandboxName = ACETUtility.GetOrgName();
        return ACETUtility.GetSwivelEndpointByOrgName(sandboxName, 'CSRF');
    }
    
    private String GenerateISETURL(String MemberId, String FirstName, String LastName, String DOB, String Gender , string GroupNumber) {
        system.debug(LoggingLevel.INFO, 'MemberId: ' + MemberId + ', FirstName: ' + FirstName + ', LastName: ' + LastName + ', DOB: ' + DOB + ', Gender: ' + Gender);
        String OrgInstanceURL = String.valueof(URL.getSalesforceBaseUrl().toExternalForm()); 
        String OrgName = ACETUtility.GetOrgName();
        System.debug('OrgName::'+OrgName);
        System.debug('CarrierIDinURLMethod:::'+SSBCarrierId);
        System.debug('All::'+ACETOrgNameToSwivelEndpointMap__c.getall().values());
        System.debug('dev one::'+ACETOrgNameToSwivelEndpointMap__c.getValues('dev_ISETWrap'));
        System.debug('dev one::'+ACETOrgNameToSwivelEndpointMap__c.getValues(OrgName + '_ISETWrap'));        
        ACETOrgNameToSwivelEndpointMap__c ISETWrapURLMap = new ACETOrgNameToSwivelEndpointMap__c();        
        ISETWrapURLMap =  ACETOrgNameToSwivelEndpointMap__c.getValues(OrgName + '_ISETWrap');
        System.debug('ISETWrapURLMap.Swivel_Endpoint__c::'+ ISETWrapURLMap.Swivel_Endpoint__c);        
        String ISETWrapURL = ISETWrapURLMap.Swivel_Endpoint__c;
        ACETWrapEncryptionKey__c ACETWrapEncryptionKey = ACETWrapEncryptionKey__c.getValues(OrgName + '_ISETEncryptionKey');
        String EncryptionKey = ACETWrapEncryptionKey.Key__c;
        String AlgorithmName = ACETWrapEncryptionKey.Algorithm_Name__c;
        system.debug(LoggingLevel.INFO, 'OrgInstanceURL: ' + OrgInstanceURL + ', ISETWrapURL: ' + ISETWrapURL + ', EncryptionKey: ' + EncryptionKey);
        
        Integer AppSourceIndex = ISETWrapURL.indexOf('applicationSource=');
        String ISETQSTemplate = ISETWrapURL.right(ISETWrapURL.length() - AppSourceIndex);
        ISETWrapURL = ISETWrapURL.remove(ISETQSTemplate);
        system.debug(LoggingLevel.INFO, 'ISETWrapURL: ' + ISETWrapURL + ', ISETQSTemplate: ' + ISETQSTemplate);
               
        if(SSBCarrierId != null  &&  SSBCarrierId.isNumeric()){
            SSBCarrierId = 'UHC00'+(Integer.valueOf(SSBCarrierId)<10?'0'+SSBCarrierId:SSBCarrierId)+'XX';
        }
        else{
             SSBCarrierId ='';
         }
        system.debug('SSBCarrierId>>'+SSBCarrierId);
        String ISETQS = String.format(ISETQSTemplate, new List<String>{MemberId, FirstName, LastName, DOB, Gender,SSBCarrierId});
        system.debug('carrier id ---------999++++ '+ISETQS );
        String ISETQSEncrypted = ACETURLEncryptionUtility.GetEncryptedValue(EncryptionKey, AlgorithmName, ISETQS);
        system.debug(LoggingLevel.INFO, 'ISETQS: ' + ISETQS + ', ISETQSEncrypted: ' + ISETQSEncrypted);
        
        //ISETWrapURL = OrgInstanceURL + ISETWrapURL + EncodingUtil.urlEncode(ISETQS, 'UTF-8');
        ISETWrapURL = OrgInstanceURL + ISETWrapURL + EncodingUtil.urlEncode(ISETQSEncrypted, 'UTF-8');
        system.debug('carrier id ---------99999 '+ISETWrapURL);
        return ISETWrapURL;
    }
    
    public PageReference SaveAndClose(){
        if(wrapper.isSystemUnavailable){
            wrapper.caseObj.New_Closed_Reason__c ='System Unavailable';
        }
        else{
        }
        wrapper.caseObj.Topic__c ='Pharmacy Inquiry';
        wrapper.caseObj.Status='Closed';
        System.debug('surrogateKeyif -----'+surrogateKey);
        wrapper.caseObj.Surrogate_Key__c = surrogateKey;
        //wrapper.caseObj.AutoDoc__c = AutoDoc;
        wrapper.createCase();  
        system.debug('wrapper closedreason'+wrapper.caseObj.New_Closed_Reason__c);         
        PageReference caseDetailsReference = new PageReference('/apex/ACETCallTopicSaveAndClose?caseId=' + wrapper.CaseObj.Id);
        system.debug('wrapper.CaseObj.Id  >>>  '+wrapper.CaseObj.Id);
        return caseDetailsReference; 
        
    } 
    
    public String ChangeDateFormatForOIL(String OILDate) {
        String FormattedDate = '';
        
        if (String.isNotBlank(OILDate)) {
            List<String> OILDateSplit = OILDate.split('/');
            if(OILDateSplit.size() == 3) {
                Integer strMonth = integer.ValueOf(OILDateSplit[0]);
                Integer strDay = integer.ValueOf(OILDateSplit[1]);
                String appendMonth,appendDay;
                if(strMonth < 10)
                    appendMonth = 0 + String.valueOf(strMonth);
                else
                    appendMonth = String.valueOf(strMonth);
                    
                if(strDay < 10)    
                    appendDay = 0 + String.valueOf(strDay);
                else 
                    appendDay = String.valueOf(strDay);
                    
                //FormattedDate = OILDateSplit[2] + '-' + OILDateSplit[0] + '-' + OILDateSplit[1];
                FormattedDate = OILDateSplit[2] + '-' + appendMonth + '-' + appendDay;
            }
        }
            
        return FormattedDate;
    }
    
}