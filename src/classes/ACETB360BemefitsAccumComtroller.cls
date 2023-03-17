global with sharing class ACETB360BemefitsAccumComtroller {
    
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
    public String benefitDateSearchForAccums {get; set;}
    public string currentDate {get; set;}
    public string currentDateBenefits {get; set;}
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
    public ACETB360BemefitsAccumComtroller() {
        hippaBenefitCodeSet = new set<String>();
        specialtyCrosswalk = new Map<string,string>();
        Date todayBenefitsDate = Date.today(); 
        benefitDateSearchForAccums = ACETUtility.format(todayBenefitsDate);
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
             if(orgSitusState != null && sw.Situs_State__c.Contains(orgSitusState)) {
                  specialityCrossWalkUpdated.add(sw);
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
    
    
   
    /*  1. If  coverage end date < today’s date then pick last date of coverage period 
        2. If coverage end date >= today’s date then pick todays date 
        3. If coverage EffectiveDate> today’s date then pick coverage start date
     * */  
    public void populateDate() {
        if(!String.isEmpty(EndDate) && !String.isEmpty(EffectiveDate)) {
            if(date.parse(EndDate) >= Date.Today() && date.parse(EffectiveDate) <  Date.Today()) {
                Date todayBenefitDate  = Date.Today();
                benefitDateSearchForAccums = ACETUtility.format(todayBenefitDate);
            }
            else if(date.parse( EndDate) < Date.Today()) {
                benefitDateSearchForAccums  = EndDate;
            }
            else if(date.parse( EffectiveDate) >  Date.Today() && date.parse(EndDate) >= Date.Today()) {
                benefitDateSearchForAccums  = EffectiveDate;
            }
        } 
    }    
    public String ChangeDateFormatForOIL(String oilDate) {
        String formattedDate = '';
        if (String.isNotBlank(oilDate)) {
            List<String> oilDateSplit = oilDate.split('/');
            if(oilDateSplit.size() == 3) {
                Integer strMonth = integer.ValueOf(oilDateSplit[0]);
                Integer strDay = integer.ValueOf(oilDateSplit[1]);
                String appendMonth,appendDay;
                if(strMonth < 10)
                    appendMonth = 0 + String.valueOf(strMonth);
                else
                    appendMonth = String.valueOf(strMonth);
                
                if(strDay < 10)    
                    appendDay = 0 + String.valueOf(strDay);
                else 
                    appendDay = String.valueOf(strDay);
                
             
                formattedDate = OILDateSplit[2] + '-' + appendMonth + '-' + appendDay;
            }
        }
        
        return formattedDate;
    }
    
    
    
}