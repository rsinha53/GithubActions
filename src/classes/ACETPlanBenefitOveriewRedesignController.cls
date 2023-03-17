global class ACETPlanBenefitOveriewRedesignController {
    
    //Sindhu: For test code coverage improvement
    //public transient ACETBenefitsRedesignDetails benefitDetailwrapper{get;  set;}
    global ACETGroupPlanBenefitWrapper  ACETPlanBenefitSubscriptionSection {get; set;} 
    public ACETGroupPlanBenefitWrapper  ACETPlanBenefitAccumulatorSection {get; set;} 
    public String  ACETSubscriptionServices {get; set;}

    public set<string>  hippaBenefitCodeSet {get; set;}
    public string MemberId {get; set;}
    public string BenefitBundleOptionId {get; set;}
    public string accumAsOf {get;set;}
    public String failureMessage {get; set;}
    public boolean isVal {get; set;}
    public string dateRange {get; set;}
    public String hippaBenefitCodeJSON {get; set;}
    public string ccc {get; set;}
    public boolean IsPlanBenefit{get;set;}
    public string orgSitusState{get;set;}
    public string primarySpeciality{get;set;}
    
    
    public map<string, string> benefitCodeMap{  
        get{
            if(benefitCodeMap == null){
                benefitCodeMap = new map<string,string>();
                if(ACETPlanBenefitSubscriptionSection != null && ACETPlanBenefitSubscriptionSection.benefitRedesignWrapperList != null){
                    for(string obj : ACETPlanBenefitSubscriptionSection.benefitRedesignWrapperList.keySet()){       
                        system.debug(obj);                 
                        string tmp = obj.replace(' ','_'); 
                        tmp = tmp.replace('/','_').replaceAll(',','_');
                        system.debug(tmp);
                        benefitCodeMap.put(obj,tmp);
                    }
                }
            }
            return benefitCodeMap; 
        }set;
    }
    
    public list<string> allbenefitCodes{  
        get{
            if(allbenefitCodes == null){
                allbenefitCodes = new list<string>();
                if(ACETPlanBenefitSubscriptionSection != null && ACETPlanBenefitSubscriptionSection.benefitRedesignWrapperList != null){
                    for(string obj : ACETPlanBenefitSubscriptionSection.benefitRedesignWrapperList.keySet()){                        
                        allbenefitCodes.add(obj);
                    }
                    allbenefitCodes.sort();
                }                 
            }
            return allbenefitCodes; 
        }set;
    }
    
    public String bundleOptionId {get; set;}                
    public String CoverageType {get; set;}
    public String EffectiveDate {get; set;}
    public String EndDate {get; set;}    
    public String SRKID {get; set;}
    public String SubSRKID {get; set;}
    public String benefitDateSearch {get; set;}
    public string currentDate {get; set;}
    public string currentDateBenefits {get; set;}
    //public list<string> benefitEntireList {get; set;}
    public string benefitKeys {get; set;}

    public String groupId{get;set;}
    public ACETHighlightsPanelAdditionalInfo AdditionalInfo {get;set;}
    public String renewalDate{get;set;}
    public String groupEffectiveDate{get;set;}
    public String benefitLanguageIndicator{get;set;}
    public list<string> benefitCodeValues{get; set;}
    public Map<string,string> specialtyCrosswalk{get;set;}
    public string specialtyCrosswalkString{set;}
    public String SitusState{set;}
    public ACETPlanBenefitOveriewRedesignController() {
        hippaBenefitCodeSet = new set<String>();
        specialtyCrosswalk = new Map<string,string>();
        Date todayBenefitsDate = Date.today(); 
        benefitDateSearch = ACETUtility.format(todayBenefitsDate);
        currentDateBenefits = '[ '+ACETUtility.format(todayBenefitsDate)+' ]';
        isVal = false;
        benefitCodeValues = new list<string>();
        for(ACETLanguageCTIndicator__c benefitCodeValue : [select Name,Benefit_Code__c from ACETLanguageCTIndicator__c order by Benefit_Code__c asc] ){                        
            benefitCodeValues.add(benefitCodeValue.Benefit_Code__c);
            benefitLanguageIndicator = JSON.serialize(benefitCodeValues);
        }
     }
        public String getSitusState() {
           return orgSitusState;
        }
        public String getspecialtyCrosswalkString() {
          List<Specialty_Crosswalk__c> specialityCrossWalk = new List<Specialty_Crosswalk__c>();
          List<Specialty_Crosswalk__c> specialityCrossWalkUpdated = new List<Specialty_Crosswalk__c>();
          specialityCrossWalk = [Select Classification__c,Specialty__c,Benefit_Code__c,Category_Code__c,Situs_State__c from Specialty_Crosswalk__c where Situs_State__c != null];
          for(Specialty_Crosswalk__c sw : specialityCrossWalk){
             if(orgSitusState != null) {
              if(sw.Situs_State__c.Contains(orgSitusState)){
                  specialityCrossWalkUpdated.add(sw);
              }
          }
        }
      System.debug('specialityCrossWalkUpdated' +specialityCrossWalkUpdated);
      System.debug('orgSitusState'+orgSitusState);
         if(specialityCrossWalkUpdated.size()>0){
           for(Specialty_Crosswalk__c s:specialityCrossWalkUpdated){
            if(s.Classification__c == null)
            {
                s.Classification__c = '';
                specialtyCrosswalk.put(s.Classification__c+'~'+s.Specialty__c,s.Benefit_Code__c+'@'+s.Category_Code__c);
            }else if(s.Specialty__c == null){
                s.Specialty__c = '';
                specialtyCrosswalk.put(s.Classification__c+'~'+s.Specialty__c,s.Benefit_Code__c+'@'+s.Category_Code__c);
            }else{
                specialtyCrosswalk.put(s.Classification__c+'~'+s.Specialty__c,s.Benefit_Code__c+'@'+s.Category_Code__c);
            }
            
        }
        }
        return JSON.serialize(specialtyCrosswalk); 
        
   
    } 
     //Sindhu: For test code coverage improvement
      
    public string selectedBenefit{get; set;}
    
    
    
    webservice static string  getAccumRedesign(String BenefitBundleOptionId, String DateStrFormat, String MemberId, String benefitCode,
                                               String EnrolleeIdentifierType, String EnrolleeIdentifierId,String SubscriberIdentifierId, String EffectiveStartDate,
                                               String EffectiveEndDate, String CoverageType, String BenefitVerIndicator, 
                                               String accumAsOf, String BenefitCodeMap, String groupId,String SubscriptionServiceResponse,String MembershipDuration,String SubscriptionResponse,List<String> existsOnRiderPlanArray) {
                                                   
                                                   System.debug('existsOnRiderPlanArray'+existsOnRiderPlanArray);
                                                   list<string> benefitCodeLst = new list<string>();
                                                   ACETPlanBenefitOveriewRedesignController dateStrCon = new ACETPlanBenefitOveriewRedesignController();
                                                   String dateStr = dateStrCon.ChangeDateFormatForOIL(DateStrFormat);
                                                   ACETPlanBenefitLanguageWrapper.BenefitWrapper bw = new ACETPlanBenefitLanguageWrapper.BenefitWrapper();    
                                                   List<ACETPlanBenefitLanguageWrapper.BenefitWrapper> accumsData = new List<ACETPlanBenefitLanguageWrapper.BenefitWrapper>();  
                                                   benefitCodeLst.addALL(benefitCode.split(','));
													
                                                   ACET_GetBenefitAccumsWebService accumsService = new ACET_GetBenefitAccumsWebService();
                                                   ACET_GetBAServiceWrapper bas = new ACET_GetBAServiceWrapper();
                                                   bas.BenefitBundleOptId = BenefitBundleOptionId;
                                                    bas.EnrolleeIdentifierType = EnrolleeIdentifierType; 
                                                    bas.EnrolleeIdentifierId = EnrolleeIdentifierId;
                                                    bas.SubscriberIdentifierId = SubscriberIdentifierId; 
                                                    bas.EffectiveStartDate = EffectiveStartDate; 
                                                    bas.EffectiveEndDate = EffectiveEndDate; 
                                                    bas.CoverageType = CoverageType; 
                                                    bas.BenefitVerIndicator = BenefitVerIndicator; 
                                                    bas.BenefitCode = BenefitCode; 
                                                    bas.accumAsOf = accumAsOf;
                                                    bas.GroupNumber = groupId; 
                                                    bas.SubscriptionServiceResponse = SubscriptionServiceResponse;
                                                    bas.MembershipDuration = MembershipDuration;
                                                    bas.SubscriptionResponse = SubscriptionResponse;
                                                    bas.existsOnRiderPlanArray = existsOnRiderPlanArray;
                                                   accumsData = accumsService.getAccumulatorBenefitsRedesign(bas);
                                                   
                                                   
                                                   
                                                   
                                                   string s = JSON.serialize(accumsData); 
                                                   
                                              
                                                   
                                                   return s; 
                                               }
   
    webservice static string  getBenefitLanguage(String BenefitBundleOptionId, String DateStrFormat, String MemberId, String benefitCode,
                                                 String EnrolleeIdentifierType, String EnrolleeIdentifierId, String EffectiveStartDate,
                                                 String EffectiveEndDate, String CoverageType, String BenefitVerIndicator, 
                                                 String accumAsOf, String groupId, String BenefitCodeMap,boolean multiple) {
                                                     
                                                     
                                                     
                                                     ACETPlanBenefitOveriewRedesignController dateStrCon = new ACETPlanBenefitOveriewRedesignController();
                                                     String dateStr = dateStrCon.ChangeDateFormatForOIL(DateStrFormat);
                                                     List<ACETPlanBenefitLanguageWrapper.BenefitWrapper> bw = new List<ACETPlanBenefitLanguageWrapper.BenefitWrapper>();    
                                                     list<string> benefitCodeLst = new list<string>();
                                                     System.debug('benefitCode' +benefitCode);
                                                     String BenefitCodeIndiv = BenefitCode.removeEnd('_'); 
                                                     benefitCodeLst.add(BenefitCodeIndiv);
                                                     ACETGetBenefitLanguageRedesignWebService service = new ACETGetBenefitLanguageRedesignWebService();  
                                                     bw= service.getPlanBenefitLanguageNew(BenefitBundleOptionId,dateStr,MemberId,benefitCodeLst,accumAsOf,groupId,BenefitCodeMap,multiple,EffectiveStartDate); 
                                                    
                                                     string s = JSON.serialize(bw); 
                                                    
                                                     return s; 
                                                 }                                             
   
    /*  1. If  coverage end date < today’s date then pick last date of coverage period 
        2. If coverage end date >= today’s date then pick todays date 
        3. If coverage EffectiveDate> today’s date then pick coverage start date
     * */  
    public void populateDate() {
        if(!String.isEmpty(EndDate) && !String.isEmpty(EffectiveDate)) {
            if(date.parse(EndDate) >= Date.Today() && date.parse(EffectiveDate) <  Date.Today()) {
                Date todayBenefitDate  = Date.Today();
                benefitDateSearch = ACETUtility.format(todayBenefitDate);
            }
            else if(date.parse( EndDate) < Date.Today()) {
                benefitDateSearch  = EndDate;
            }
            else if(date.parse( EffectiveDate) >  Date.Today() && date.parse(EndDate) >= Date.Today()) {
                benefitDateSearch  = EffectiveDate;
            }
        } 
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