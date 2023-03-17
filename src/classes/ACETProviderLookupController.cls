global with sharing class ACETProviderLookupController {
    
    public Boolean isErrorMessageAdded {get; set;}
    public Interaction__c interaction { get; set; }
    public Contact conObj { get; set; }
    public ACETHighlightsPanelAdditionalInfo additionalInfo { get; set; }
    public ACETCallTopicsDataWrapper acetCallTopicData { get; set; }
    public String memId { get; set; } 
    public String bundleOptionId {get; set;}
    public Boolean qualityBenefitTier {get; set;}
    public String EffectiveDate {get; set;} 
    public string surrogateKey {get; set;} 
    public string SubSRKID {get; set;} 
     public string coverageSRK {get; set;} 
    Public String networkId{get;set;}
    public String EndDateSSB {get; set;}
    public String groupNo {get; set;}
    public string serviceType{get; set;}
    public string taxId{get; set;}
    public string lastName{get; set;}
    public string phoneNumber{get; set;}
    public string firstName{get; set;}
    public string searchProviderId {get; set;}
    public string cityVal{get; set;}
    public string city{get; set;}
    public string npi{ get; set; } 
    public string qualityProviderRuleId{ get; set; }  
    public ACETstateCodeContainer stateCode { get; set; }
    public string LanguageVal{ get; set; }
    public map<string,Language_Codes__mdt> languageSchedulemapId = new map<string,Language_Codes__mdt>();    
    public string radious{get;set;}
    public string zipCode{get;set;}
    public string zip{get;set;}
    public string gender{get; set;}
    public string selectNetwork{get; set;} 
    public string claimType{get; set;}
    public boolean NewpatientsInd { get; set; }     
    public boolean existingpatientsInd { get; set; }  
    public string searchType{get; set;}
    public Boolean showNonParChckBox {get;set;}
    public Boolean FreeStandingFacl {get;set;}
    public Boolean isDDP{get;set;}
    Public String benefitEffectivedate {get;set;}
    Public String benefitEnddate {get;set;}
    public String isLookup {get;set;}
    public String benefitPlanId { get; set; }    
    public ACETDatatableWrapper PLDTWrapper { get; set; }     //Used by pagination component
    Public String Network{get;set;} 
    public list<ProviderLookupResult> lstProviderLookupResults { get; set; }
    public string networkval { get; set; }   
    public string SelSpecialityCodes {get; set;}
    public string selectedSpeciality{get; set;}
    public string providerType{get; set;}
    public string BenefitServiceArea {get;set;}
    public string specialty { get; set; } 
    public map<string,string> SpecCodes;
    public String groupNum  {get; set;}
    public String urlscrId  {get; set;}
    public String urlssn  {get; set;}
    public String urlrelationshipCode {get;set;}
    public String hpAdditionInfoStr { get; set; }    
    public String searchPcpOBGYNId{get;set;}
    public String pcpLocatorID { get; set; } 
    public String pcpFlag { get; set; }  
    public string AttributeSet {get; set;} 
    public String selectStatus{get;set;}
    Public String customerPurchaseId {get;set;}
    Public String defNetworkVal{get; set;}                                    
    Public String defNetworkValName{get; set;}                                        
    public ACETProviderLookupController(){
        SpecCodes = new map<string,string>();
        for(Provider_Taxonomy__mdt prodTax : [select label,Classification__c,Provider_Type__c,Speciality__c,Speciality_Code__c from Provider_Taxonomy__mdt order by Classification__c asc]){       
            SpecCodes.put(prodTax.Classification__c+'#'+prodTax.Speciality__c, prodTax.Speciality_Code__c);  
        }   
            
    /*   public ACETProviderLookupController(){
        SpecCodes = new map<string,string>();
        for(Provider_Taxonomy__mdt prodTax : [select label,Classification__c,Provider_Type__c,Speciality__c,Speciality_Code__c from Provider_Taxonomy__mdt]){       
            SpecCodes.put(prodTax.Classification__c+'#'+prodTax.Speciality__c, prodTax.Speciality_Code__c);  
        }
        
        */ 
        isLookup = 'true';
        showNonParChckBox = false;
        searchType = 'Basic';
        surrogateKey = ApexPages.currentPage().getParameters().get('SRK'); 
        memId = ApexPages.currentPage().getParameters().get('Id');
        networkId = ApexPages.currentPage().getParameters().get('networkId');
        /* Added by Avish on 09/062018 */
        pcpLocatorID = ApexPages.currentPage().getParameters().get('pcpLocatorId');
        pcpFlag = ApexPages.currentPage().getParameters().get('pcpFlag');
        if(String.isNotBlank(pcpLocatorID)){
            searchPcpOBGYNId = pcpLocatorID;
            providerType = 'Physician';
        }
        //Ends
        bundleOptionId = apexpages.currentpage().getparameters().get('bundleOptionId');              
        EffectiveDate = apexpages.currentpage().getparameters().get('EffectiveDate'); 
        coverageSRK = apexpages.currentpage().getparameters().get('coverageSRK');                  
        EndDateSSB = apexpages.currentpage().getparameters().get('EndDate');      
        taxId = ApexPages.currentPage().getParameters().get('taxid');
        cityVal = ApexPages.currentPage().getParameters().get('city');
        cityVal = String.isEmpty(cityVal)?cityVal:String.escapeSingleQuotes(cityVal); //US3636286 : Checkmarx Fix
        zip = ApexPages.currentPage().getParameters().get('zipCode');
        zip = String.isEmpty(zip)?zip:String.escapeSingleQuotes(zip); //US3636286 : Checkmarx Fix
        benefitPlanId  = ApexPages.currentPage().getParameters().get('benefitPlanId');
        groupNum = ApexPages.currentPage().getParameters().get('grpnum');
        urlscrId = ApexPages.currentPage().getParameters().get('scrId');
        urlssn = ApexPages.currentPage().getParameters().get('ssnId');
        urlrelationshipCode = ApexPages.currentPage().getParameters().get('rl');
        benefitEffectivedate= ApexPages.currentPage().getParameters().get('benefitEffectivedate'); //US2962032 dates are mapped to ss callout via Vf page remote action 
        benefitEnddate= ApexPages.currentPage().getParameters().get('benefitEnddate');
        
        stateCode = new ACETstateCodeContainer('');
        customerPurchaseId = ApexPages.currentPage().getParameters().get('cpid');

        String interactionId = ApexPages.currentPage().getParameters().get('interactionId');
        if (!String.isEmpty(interactionId)) {       
            interaction = ACETProviderUtility.GetInteractionByID(interactionId);
        }
        
        String contactId = ApexPages.currentPage().getParameters().get('contactId');
        if (!String.isEmpty(contactId)) {
            conObj = ACETProviderUtility.GetContactByID(contactId);         
        }
        
        String additionalInfostr = ApexPages.currentPage().getParameters().get('additionalInfo');     
        if (!String.isEmpty(additionalInfostr)) {
            additionalInfo = (ACETHighlightsPanelAdditionalInfo) JSON.deserialize(additionalInfostr, ACETHighlightsPanelAdditionalInfo.class);
            hpAdditionInfoStr = JSON.serialize(additionalInfo);
            groupNum = additionalInfo.GroupNumber;
            system.debug('GroupNumberHere****' +groupNum);

        }
        
        
        acetCallTopicData = new ACETCallTopicsDataWrapper();        
        acetCallTopicData.CallTopic = 'Provider Lookup';         
        acetCallTopicData.CaseObj.topic__c = 'Provider Lookup';
        if(string.isNotBlank(surrogateKey)){
            acetCallTopicData.surrogateKey = surrogateKey;
        }   
        lstProviderLookupResults = new list<ProviderLookupResult>();
    }
    
    public List < SelectOption > languagescmdt{
        get{ 
            if(languagescmdt == null){
                languagescmdt =  new List<SelectOption> ();
                languagescmdt.add(new SelectOption('','--None--'));
                for(Language_Codes__mdt lancode:[select label,DeveloperName from Language_Codes__mdt order by label asc]) {
                    languagescmdt.add(new SelectOption(lancode.label,lancode.label));
                    languageSchedulemapId.put(lancode.label,lancode);             
                }
            }
            return languagescmdt;
        }set;
    }
    
    
    public static String ChangeDateFormatForOIL(String OILDate) {
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
    
   
    public ACETGroupPlanBenefitWrapper ACETPlanBenefitSearchResults;
    public static map<string,Network_Values__mdt> networkSchedulemapId = new map<string,Network_Values__mdt>(); 

    
    global static string getBenefitTiers(string bundleOptionId,string surrogateKey, string SubscriberSRKID , string EffectiveDate ,string EndDateSSB,string CoverageTypes,string groupNum,string accumsDate,string accumAsOf,string memId){        
        return getBenefitTiers( bundleOptionId, surrogateKey,  SubscriberSRKID ,  EffectiveDate , EndDateSSB, CoverageTypes, groupNum, accumsDate, accumAsOf, memId, null,null);
    }
    
    @RemoteAction
    global static string getBenefitTiers(string bundleOptionId,string surrogateKey, string SubscriberSRKID , string EffectiveDate ,string EndDateSSB,string CoverageTypes,string groupNum,string accumsDate,string accumAsOf,string memId,String planId, String customerPurchaseId){        
        GetBenefitTiersReturnType rt = new GetBenefitTiersReturnType();
        List<selectOptionWrapper> optionsList = new List<selectOptionWrapper>(); 
        if(memId != null && memId != ''){
            ACETWSCalloutResult callOut = new ACETWSCalloutResult(); 
            ACETNimbusGetSSBAPI getSubscriptionWS = new ACETNimbusGetSSBAPI();
            getSubscriptionWS.planId = planId;
            system.debug(bundleOptionId+':: '+surrogateKey+':: '+ChangeDateFormatForOIL(EffectiveDate) +':: '+ChangeDateFormatForOIL(EndDateSSB)+'GroupNumber::::::::::::'+groupNum);
            callOut = getSubscriptionWS.init(bundleOptionId, surrogateKey ,SubscriberSRKID ,ChangeDateFormatForOIL(EffectiveDate) ,ChangeDateFormatForOIL(EndDateSSB),CoverageTypes,groupNum, accumsDate,accumAsOf,customerPurchaseId);
            ACETGroupPlanBenefitWrapper ACETPlanBenefitSearchResults = new ACETGroupPlanBenefitWrapper();
            ACETPlanBenefitSearchResults = (ACETGroupPlanBenefitWrapper)callOut.Response; 
            if(ACETPlanBenefitSearchResults!=null)
            rt.qualityProviderRuleId = ACETPlanBenefitSearchResults.qualityProviderTierRuleID;
            optionsList.add(new selectOptionWrapper(callOut.responseBody));
            
            if(callOut.Response == null){
                if(callOut.Message != null){
                    selectOptionWrapper sw = new selectOptionWrapper();
                    sw.errorMessage = callOut.Message;
                    optionsList.add(sw);
                }
            }
  
            if(ACETPlanBenefitSearchResults != null && ACETPlanBenefitSearchResults.tierDescMap != null){
                for(string key : ACETPlanBenefitSearchResults.tierDescMap.keySet()){                    
                    List<selectOptionWrapper> networks = new List<selectOptionWrapper>();                    
                    if(ACETPlanBenefitSearchResults.networkMap.get(key)!=null){
                    for(String ntwStr:ACETPlanBenefitSearchResults.networkMap.get(key)){
                        if(string.isNotBlank(ntwStr)){
                            list<String> ntwArray = ntwStr.split('_'); 
                            if(ntwArray.size()>0){
                                networks.add(new selectOptionWrapper(ntwArray[1],ntwArray[0],null)); 
                            }
                        }
                    }
                    }
                    string serviceType = '';
                    if(ACETPlanBenefitSearchResults.sAreaType != null){
                        if(ACETPlanBenefitSearchResults.sAreaType.get(key) != null){
                            serviceType = ACETPlanBenefitSearchResults.sAreaType.get(key);
                        }
                    }
                    optionsList.add(new selectOptionWrapper(ACETPlanBenefitSearchResults.tierDescMap.get(key),key,networks,serviceType));
                }        
            }     
        }
             
        List<selectOptionWrapper> networks = new List<selectOptionWrapper>();
        for(Network_Values__mdt netwrok : [select label,Network_ID__c from Network_Values__mdt order by label asc]){
            networks.add(new selectOptionWrapper(netwrok.label,netwrok.Network_ID__c,null)); 
            networkSchedulemapId.put(netwrok.label,netwrok);
        }
        if(networks.size() > 0){
            optionsList.add(new selectOptionWrapper('','',networks));
        }
        rt.optionsList = optionsList;
        return JSON.seriaLize(rt);
    }  
    
    global static List<Provider_Taxonomy__mdt> providerTaxonomyMdt = new List<Provider_Taxonomy__mdt>([select label,Classification__c,Provider_Type__c,Speciality__c,Speciality_Code__c from Provider_Taxonomy__mdt order by Classification__c asc]);
    
   // global static List<Provider_Taxonomy__mdt> providerTaxonomyMdt = new List<Provider_Taxonomy__mdt>([select label,Classification__c,Provider_Type__c,Speciality__c,Speciality_Code__c from Provider_Taxonomy__mdt ]);
    
@RemoteAction
    global static string getNetworkVal(String netVal){ 
        List<String> defNetworkList = new List<String>();
        String defNetworkValue, defNetworkName, defNetworkId;
            List<ACETNetworkValues__mdt> val = [SELECT NetworkValue__c, Network_ID__c from ACETNetworkValues__mdt WHERE Label =: netVal];
            if(val.size() > 0){
                defNetworkName = val[0].NetworkValue__c;
                defNetworkId = val[0].Network_ID__c;
                defNetworkValue = defNetworkId+'_'+defNetworkName;
                defNetworkList.add(defNetworkValue);
                system.debug('@@val'+val);
           }
        return JSON.seriaLize(defNetworkList);
  }
    @RemoteAction
    global static string getProviders(){        
        List<selectOptionWrapper> optionsList = new List<selectOptionWrapper>();
             
        set<string> providers = new set<string>();
        for(Provider_Taxonomy__mdt prodTax :providerTaxonomyMdt){            
            providers.add(prodTax.Provider_Type__c);
        }        
        for(string provider : providers){
            optionsList.add(new selectOptionWrapper(provider,provider,null)); 
        }
        
        return JSON.seriaLize(optionsList);
    }  
    
    @RemoteAction
    global static string getClasifications(){        
        List<selectOptionWrapper> optionsList = new List<selectOptionWrapper>();
             
        map<string,set<string>> calisificationByProvider = new map<string,set<string>>();
        for(Provider_Taxonomy__mdt prodTax :providerTaxonomyMdt){            
            if(calisificationByProvider.get(prodTax.Provider_Type__c) != null){
                calisificationByProvider.get(prodTax.Provider_Type__c).add(prodTax.Classification__c);
            }else{
                calisificationByProvider.put(prodTax.Provider_Type__c, new set<string>{prodTax.Classification__c});
            }
        }        
        for(string provider : calisificationByProvider.keySet()){
            List<selectOptionWrapper> clasfications = new list<selectOptionWrapper>();
            for(string clasification : calisificationByProvider.get(provider)){
                clasfications.add(new selectOptionWrapper(clasification,clasification,null));
            }          
            optionsList.add(new selectOptionWrapper(provider,provider,clasfications)); 
        }
        
        return JSON.seriaLize(optionsList);
    } 
    
    
    @RemoteAction
    global static string getSpecilities(){   
        
        List<selectOptionWrapper> optionsList = new List<selectOptionWrapper>();
             
        map<string,set<string>> specialityByProviderAndClasification = new map<string,set<string>>();
        
        for(Provider_Taxonomy__mdt prodTax :providerTaxonomyMdt){       
            
            string key = prodTax.Provider_Type__c+''+prodTax.Classification__c;
            if(specialityByProviderAndClasification.get(key) != null){
                specialityByProviderAndClasification.get(key).add(prodTax.speciality__c);
            }else{
                specialityByProviderAndClasification.put(key, new set<string>{prodTax.speciality__c});
            }
        }        
        for(string key : specialityByProviderAndClasification.keySet()){
            List<selectOptionWrapper> specilities = new list<selectOptionWrapper>();
            for(string specility : specialityByProviderAndClasification.get(key)){
                specilities.add(new selectOptionWrapper(specility,specility,null));
            }          
            optionsList.add(new selectOptionWrapper(key,key,specilities)); 
        }
        
        return JSON.seriaLize(optionsList);
    } 
    
    public class selectOptionWrapper{
        public string label;
        public string value;        
        public list<selectOptionWrapper> childValues; 
        public string additionalInfo; //To store Service Type (OR) Speciality
        public string response;
        public string errorMessage;
        public selectOptionWrapper(){
            
        }
        public selectOptionWrapper(string response){
            this.response = response;
        }
        public selectOptionWrapper(string value,string label, List<selectOptionWrapper> childValues){            
            this.value = value;
            this.label = label;
            this.childValues = childValues;
        }
        public selectOptionWrapper(string value,string label, List<selectOptionWrapper> childValues,string additionalInfo){            
            this.value = value;
            this.label = label;
            this.childValues = childValues;
            this.additionalInfo = additionalInfo;
        }
    }
    
    public String selectedNetwordId{get;set;} 
    public string benefitTier{get; set;}
    public string callOutErrorMessage{get; set;}

    public void addErrorMessage(){
        if(callOutErrorMessage != null && callOutErrorMessage != ''){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error, callOutErrorMessage));
        }
    }
    
    public void prepareSelectedNetWorkVals(){         
        selectedNetwordId = '';    
        if(memId!=null && memId!='' && ACETPlanBenefitSearchResults != null &&  ACETPlanBenefitSearchResults.networkMap != null && String.isNotBlank(benefitTier) && ACETPlanBenefitSearchResults.networkMap.get(benefitTier) != null && ACETPlanBenefitSearchResults.networkMap.containsKey(benefitTier)){
            if(searchType == 'Basic' || (searchType == 'Advanced' && selectNetwork == 'INN Only')) {
                //Network Id Fixed for entire for loop
                for(String ntwStr:ACETPlanBenefitSearchResults.networkMap.get(benefitTier)){
                    system.debug('ntwStr :: '+ntwStr);
                    if(string.isNotBlank(ntwStr)){
                        list<String> ntwArray = ntwStr.split('_'); 
                        if(ntwArray.size()>0){                                                
                            if(selectedNetwordId == ''){
                                selectedNetwordId = ntwArray[0];
                            }else{
                                selectedNetwordId = selectedNetwordId + '@'+ntwArray[0];
                            }                                                        
                        }
                    }                
                }
            }
        }
    }
    
    
    public string responceParam{get; set;} 
    public void searchResults() {
        system.debug(benefitTier);
        system.debug(searchType);
        
        if(serviceType == 'Service Area could not be determined'){
            serviceType = '';
        }
        
          
        if(String.isNotBlank(responceParam) && (memId != null && memId !='')){
            ACETNimbusGetSSBAPI obj = new ACETNimbusGetSSBAPI();              
            ACETPlanBenefitSearchResults = obj.parseSuccessAdapterResponse(responceParam,''); 
        }
        prepareSelectedNetWorkVals();
        
        if(String.isNotBlank(memId) && ACETPlanBenefitSearchResults != null && ACETPlanBenefitSearchResults.benefitServiceSet != null){
            if(searchType == 'Basic' || (searchType == 'Advanced' && selectNetwork == 'INN Only')) {
                 for(String str:ACETPlanBenefitSearchResults.benefitServiceSet){
                     BenefitServiceArea = str;    
                 }
             }
            else {
                BenefitServiceArea = ''; 
            }
        }
        system.debug(ACETPlanBenefitSearchResults);
        system.debug(BenefitServiceArea);
        string languagesel = LanguageVal;        
        ProviderLookupResult objSearch = new ProviderLookupResult();                    
        ACETWSCalloutResult CalloutResult = new ACETWSCalloutResult();        
        lstProviderLookupResults = new list<ProviderLookupResult>();
        String strNewpatientsInd,strExistingpatientsInd,strFreeStandingFacl;
        if (NewpatientsInd) {
            strNewpatientsInd = 'Y';
        } else {
            strNewpatientsInd = '';
        }
        
        if (existingpatientsInd) {
            strExistingpatientsInd = 'Y';
        } else {
            strExistingpatientsInd = '';
        }
        
      
        if (FreeStandingFacl) {
            strFreeStandingFacl  = 'FSF';
        } else {
            strFreeStandingFacl  = '';
        }
        
       
        
        
        if (string.isNotBlank(networkval)) {
              if(networkSchedulemapId != null && networkSchedulemapId.containsKey(networkval)) {
                networkval = networkSchedulemapId.get(networkval).Network_ID__c;
              }
        } 
        if (string.isNotBlank(LanguageVal)) {
            LanguageVal = languageSchedulemapId.get(LanguageVal).DeveloperName;
        }
        string Speccod;
        system.debug(SpecCodes);
        if (string.isNotBlank(SelSpecialityCodes) && string.isNotBlank(selectedSpeciality)) {
            if (SpecCodes.containsKey(SelSpecialityCodes+'#'+selectedSpeciality)) {
                Speccod=SpecCodes.get(SelSpecialityCodes+'#'+selectedSpeciality);
            }
        }
        /*  Added by Avish as a part of US577497  */
        if (showNonParChckBox) {
            benefitPlanId = null;
        } else {
            benefitPlanId  = ApexPages.currentPage().getParameters().get('benefitPlanId');
        } 
        if(networkval == '' || networkval == null || networkval == '-None-'){
            if(selectedNetwordId != ''){
                networkval = selectedNetwordId;
            }            
        }
        system.debug('All>>'+networkval);
        
        /* End */   
        System.debug('providerType## ' + providerType);     
        qualityProviderRuleId =  searchType.trim() == 'Advanced' && selectNetwork.trim() == 'INN and OON'?null:qualityProviderRuleId;
        qualityBenefitTier = !String.isEmpty(qualityProviderRuleId) && qualityBenefitTier!=null  && qualityBenefitTier?true:false;
        if (providerType == 'Physician') {
            System.debug('providerType111## ' + providerType);
            ACETFindHCPWebservice ACTFHCPWS = new ACETFindHCPWebservice();
            ACTFHCPWS.network = selectNetwork!=null && selectNetwork.trim()=='INN Only'?'A':'';
            ACTFHCPWS.Init(searchProviderId, NPI, TaxId, LastName, FirstName, gender, Speccod, ZipCode, radious, city, stateCode.value, 
                PhoneNumber,networkval,qualityProviderRuleId,qualityBenefitTier?'1':'',
                           BenefitServiceArea,serviceType,claimType,strNewpatientsInd,strExistingpatientsInd, LanguageVal, providerType,searchPcpOBGYNId,selectStatus,AttributeSet,'true');
            ACTFHCPWS.GetEndpoint();    
            PLDTWrapper = new ACETDatatableWrapper('ACETFindHCPWebservice', ACTFHCPWS);
            PLDTWrapper.PageSize = ACTFHCPWS.PageSize;
            PLDTWrapper.datatablename= 'ProviderLookup';
        } else if(providerType == 'Facility') {
            ACETFindHCOWebservice ACTFPWS = new ACETFindHCOWebservice();
            ACTFPWS.network = selectNetwork!=null && selectNetwork.trim()=='INN Only'?'A':'';
            ACTFPWS.Init(searchProviderId, NPI, TaxId, LastName, Speccod, ZipCode, radious, city, stateCode.value, PhoneNumber,networkval,BenefitServiceArea,claimType,serviceType,providerType,strFreeStandingFacl,selectStatus,AttributeSet,'true',isDDP);
            ACTFPWS.GetEndpoint();
            PLDTWrapper = new ACETDatatableWrapper('ACETFindHCOWebservice', ACTFPWS);
            PLDTWrapper.PageSize = ACTFPWS.PageSize;  
        } 
        else
        {
            ACETFindProviderLookupWebservice ACTFPWS = new ACETFindProviderLookupWebservice();
            
            ACTFPWS.network = selectNetwork!=null && selectNetwork.trim()=='INN Only'?'A':'';
                ACTFPWS.Init(searchProviderId, NPI, TaxId, LastName, FirstName, gender, specialty,searchPcpOBGYNId, ZipCode, radious, city, stateCode.value, PhoneNumber,networkval,
                qualityProviderRuleId,qualityBenefitTier?'1':'',BenefitServiceArea,serviceType,claimType,
                 strNewpatientsInd, strExistingpatientsInd, LanguageVal, providerType,AttributeSet,isLookup,selectStatus,strFreeStandingFacl,isDDP);
            
            ACTFPWS.GetEndpoint();   
            PLDTWrapper = new ACETDatatableWrapper('ACETFindProviderLookupWebservice', ACTFPWS);   
            PLDTWrapper.PageSize = ACTFPWS.PageSize;
            PLDTWrapper.datatablename= 'ProviderLookup';
        } 
        PLDTWrapper.PageStartNumber = 0;
        PLDTWrapper.PageNumber = 0;
        PLDTWrapper.StartRecord = 0;
        PLDTWrapper.initOnDocumentReady = false; 
        PLDTWrapper.IsSortEnabled = true;
        PLDTWrapper.defaultSortBy = -1;
      //  PLDTWrapper.IsSortEnabled = true;       
        
        PLDTWrapper.Columns.add(new ACETDataTableWrapper.DataColumn('Provider ID', 'providerId'));
        PLDTWrapper.Columns.add(new ACETDataTableWrapper.DataColumn('Name', 'fullName'));
        PLDTWrapper.Columns.add(new ACETDataTableWrapper.DataColumn('Provider Type', 'providerType'));
        PLDTWrapper.Columns.add(new ACETDataTableWrapper.DataColumn('Tax ID', 'taxId'));
        PLDTWrapper.Columns.add(new ACETDataTableWrapper.DataColumn('Address', 'address'));
        PLDTWrapper.Columns.add(new ACETDataTableWrapper.DataColumn('Phone Number', 'phoneNumber'));
        PLDTWrapper.Columns.add(new ACETDataTableWrapper.DataColumn('Specialty', 'speciality'));
        PLDTWrapper.Columns.add(new ACETDataTableWrapper.DataColumn('PCP Role', 'PCPRole'));
        if(providerType == 'Physician' || providerType == '') {
           PLDTWrapper.Columns.add(new ACETDataTableWrapper.DataColumn('PCP/OBGYN ID', 'pcpObgnID'));
        }
        PLDTWrapper.Columns.add(new ACETDataTableWrapper.DataColumn('Gender', 'gender'));
        if(memId!=null) {
        PLDTWrapper.Columns.add(new ACETDataTableWrapper.DataColumn('Tiered', 'qualityBenefitTier')); 
        }
        PLDTWrapper.Columns.add(new ACETDataTableWrapper.DataColumn('UnitedHealth Premium Program', 'uphd'));
        if(memId == null) {
        PLDTWrapper.Columns.add(new ACETDataTableWrapper.DataColumn('Platinum', 'Platinum'));
        }
        if(providerType != 'Physician' && memId != null) {
        PLDTWrapper.Columns.add(new ACETDataTableWrapper.DataColumn('DDP Type', 'labTypeCode'));
        }
        PLDTWrapper.Columns.add(new ACETDataTableWrapper.DataColumn('Radius', 'radious'));
        if(providerType == 'Physician' || providerType == '') {
           PLDTWrapper.Columns.add(new ACETDataTableWrapper.DataColumn('Address Status', 'providerLocationAffiliationsStatusCode'));
        }
        isErrorMessageAdded = false;
       
        LanguageVal = languagesel;
        system.debug('*****'+selectNetwork);
        system.debug('searchPcpOBGYNId::'+searchPcpOBGYNId);
    }
    
    public class ProviderLookupResult {
        @AuraEnabled public string fullName {  get; set; }
        @AuraEnabled public string networkSchedule { get; set; }
        @AuraEnabled public string languageSchedule { get; set; }
        @AuraEnabled public string providerId { get; set; }
        @AuraEnabled public string providerType { get; set; }
        @AuraEnabled public string status { get; set; }
        @AuraEnabled public string taxId { get; set; }
        @AuraEnabled public string ssn { get; set; }
        @AuraEnabled public string address { get; set; }
        @AuraEnabled public string SelSpecialityCodes { get; set; }
        @AuraEnabled public string NPI { get; set; }  
        @AuraEnabled public string EPIMID { get; set; }
        @AuraEnabled public string street { get; set; }
        @AuraEnabled public string city { get; set; }
        @AuraEnabled public string state { get; set; }
        @AuraEnabled public string zipCode { get; set; }
        @AuraEnabled public string providerTypeCode { get; set; }   
        @AuraEnabled public string phoneNumber { get; set; }
        @AuraEnabled public string speciality { get; set; }
        @AuraEnabled public string PCPRole { get; set; }
        @AuraEnabled public string gender { get; set; }
        @AuraEnabled public string qualityBenefitTier { get; set; }
        @AuraEnabled public string network { get; set; }
        @AuraEnabled public string affiliation { get; set; }
        @AuraEnabled public string tieredBenefit { get; set; }
        @AuraEnabled public string uphd { get; set; }
        @AuraEnabled public string radious { get; set; }
        @AuraEnabled public string acceptNewPatient { get; set; }
        @AuraEnabled public string Platinum { get; set; }
        @AuraEnabled public string radius { get; set; }
        @AuraEnabled public string ProviderName { get; set; }
        @AuraEnabled public string typeDescription { get; set; }
        @AuraEnabled public string phone { get; set; }
        @AuraEnabled public string Code { get; set; }
        @AuraEnabled public String providerTINTypeCode { get; set; }
        @AuraEnabled public String providerTINStatusCode { get; set; }  
        @AuraEnabled public String addressId { get; set; }
        @AuraEnabled public String addressTypeCode { get; set; } 
        @AuraEnabled public String benefitPlanId { get; set; }
        @AuraEnabled public String County { get; set; } 
        @AuraEnabled public String Fax { get; set; }
        @AuraEnabled public String Email { get; set; }
        @AuraEnabled public String OperationHours { get; set; }
        @AuraEnabled public String PatientAgeRange { get; set; }
        @AuraEnabled public String owner { get; set; }  
        @AuraEnabled public String hcoTypeCode { get; set; }
        @AuraEnabled public String addressLine1 { get; set; }
        @AuraEnabled public String addressLine2 { get; set; }
        @AuraEnabled public String firstName { get; set; }
        @AuraEnabled public String lastName { get; set; }
        @AuraEnabled public String middleName { get; set; }
        @AuraEnabled public String suffix { get; set; }
        @AuraEnabled public string networkId {get;set;}
        @AuraEnabled public string cliamType {get;set;}
        @AuraEnabled public string pcpObgnID {get;set;}
        @AuraEnabled public String providerLocationAffiliationsStatusCode {get;set;}
        @AuraEnabled public boolean existpatient{get;set;}
        @AuraEnabled public string labTypeCode {get;set;}
        @Auraenabled public List<labType> labTypes{get;set;}
        
        public ProviderLookupResult() {
            providerId = '';
            taxId = '';
            NPI = '';
            fullName = '';
            providerType = '';  
        }
        public ProviderLookupResult(ProviderLookupResult providerLookupResult) {
            this.fullName = providerLookupResult.fullName;
            this.providerId = providerLookupResult.providerId;
            this.providerType = providerLookupResult.providerType;
            this.taxId = providerLookupResult.taxId;
            this.address = providerLookupResult.address;     
            this.providerTypeCode = providerLookupResult.providerTypeCode;  
            this.phoneNumber= providerLookupResult.phoneNumber;
            this.speciality = providerLookupResult.speciality;
            this.PCPRole = providerLookupResult.PCPRole;
            this.gender = providerLookupResult.gender;   
            this.tieredBenefit = providerLookupResult.tieredBenefit;
            this.uphd = providerLookupResult.uphd;
            this.radious = providerLookupResult.radious;
            this.acceptNewPatient = providerLookupResult.acceptNewPatient;
            this.Platinum = providerLookupResult.Platinum;
            this.providerTINTypeCode = providerLookupResult.providerTINTypeCode;
            this.addressId = providerLookupResult.addressId;
            this.addressTypeCode = providerLookupResult.addressTypeCode;
            this.pcpObgnID = providerLookupResult.pcpObgnID;
            this.providerLocationAffiliationsStatusCode = providerLookupResult.providerLocationAffiliationsStatusCode;
        }
        
        //added for provider fast track service
        public String addressStatusCode { get; set; }
        public String postalPrefixCode { get; set; }
        public String postalSuffixCode { get; set; }
        public String addressCountyDesc { get; set; }
        
    }
    
    public void clearResults(){
        PLDTWrapper = null;
    }
    
    public class GetBenefitTiersReturnType{
        List<selectOptionWrapper> optionsList;
        String qualityProviderRuleId;
    }
     
      public class labType {
        @Auraenabled public String code {get;set;}
        @Auraenabled public String description {get;set;}
    }
    
}