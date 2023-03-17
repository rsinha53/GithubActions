public class ACETBenefitCoverageOverviewController {

    public ACETGroupPlanBenefitWrapper ACETPlanBenefitSearchResults {get; set;}
    public String covrgLevel {get; set;}
    public Case accumsdate {get; set;}
    public String EffectiveDate {get;set;}
    public String EndDate {get; set;}
    public String PlanType {get; set;}
    public Date CoverageEndDate {get; set;}
    public ACETAccumAsOfWrapper dateSearch {get;set;}
    public ACETAccumAsOfWrapper ACETdateSearchResults {get;set;}
    public String accumsDateSearch {get; set;}
    public String currentDate {get; set;}
    public String customerPurchaseid{get;set;}
    
    public ACETBenefitCoverageOverviewController() {
          accumsdate = new Case();
          Date todayAccumsDate = Date.Today();
          currentDate = '[ '+Acetutility.format(todayAccumsDate)+' ]';
       
          
    }
    
    public List<ACETGroupPlanBenefitWrapper.coPayWrapper> getCoPayList() {
        
        List<ACETGroupPlanBenefitWrapper.coPayWrapper> copayWrapperList = new List<ACETGroupPlanBenefitWrapper.coPayWrapper>();
        System.debug('Go::'+ACETPlanBenefitSearchResults);
        if(ACETPlanBenefitSearchResults != null && ACETPlanBenefitSearchResults.coPayingMap != null) {
            ACETGroupPlanBenefitWrapper.coPayWrapper coPayPCP = new ACETGroupPlanBenefitWrapper.coPayWrapper();
            coPayPCP.Label = 'PCP';
            coPayPCP.value =  String.isNotBlank(ACETPlanBenefitSearchResults.coPayingMap.get('PCP'))?ACETPlanBenefitSearchResults.coPayingMap.get('PCP'):'';
            copayWrapperList.add(coPayPCP);
            
            ACETGroupPlanBenefitWrapper.coPayWrapper coPaySpecialist = new ACETGroupPlanBenefitWrapper.coPayWrapper();
            coPaySpecialist.Label = 'Specialist';
            coPaySpecialist.value = String.isNotBlank(ACETPlanBenefitSearchResults.coPayingMap.get('Specialist'))?ACETPlanBenefitSearchResults.coPayingMap.get('Specialist'):'';
            copayWrapperList.add(coPaySpecialist);
            
            ACETGroupPlanBenefitWrapper.coPayWrapper coPayER = new ACETGroupPlanBenefitWrapper.coPayWrapper();
            coPayER.Label = 'ER';
            coPayER.value = String.isNotBlank(ACETPlanBenefitSearchResults.coPayingMap.get('ER'))?ACETPlanBenefitSearchResults.coPayingMap.get('ER'):'';
            copayWrapperList.add(coPayER);
            
            ACETGroupPlanBenefitWrapper.coPayWrapper coPayUC = new ACETGroupPlanBenefitWrapper.coPayWrapper();
            coPayUC.Label = 'Urgent Care';
            coPayUC.value = String.isNotBlank(ACETPlanBenefitSearchResults.coPayingMap.get('UC'))?ACETPlanBenefitSearchResults.coPayingMap.get('UC'):'';
            copayWrapperList.add(coPayUC);
            
            ACETGroupPlanBenefitWrapper.coPayWrapper virtualVisit = new ACETGroupPlanBenefitWrapper.coPayWrapper();
            virtualVisit.Label = 'Virtual Visit';
            virtualVisit.value = String.isNotBlank(ACETPlanBenefitSearchResults.coPayingMap.get('Virtual Visit'))?ACETPlanBenefitSearchResults.coPayingMap.get('Virtual Visit'):'';
            copayWrapperList.add(virtualVisit);
        }
        System.debug('ACETGroupPlanBenefitWrapper.coPayWrapper::::'+copayWrapperList);
        return copayWrapperList;
    }
    
    public List<ACETGroupPlanBenefitWrapper.OONReimbursement> OONReimbursementList{
        get{
            if(OONReimbursementList == null || (OONReimbursementList != null && OONReimbursementList.size() == 0)){
                List<ACETGroupPlanBenefitWrapper.OONReimbursement> OONReimbursementList = new List<ACETGroupPlanBenefitWrapper.OONReimbursement>();
                if(ACETPlanBenefitSearchResults != null && ACETPlanBenefitSearchResults.OONReimbursementMap != null) {
                    for(String OONKey: ACETPlanBenefitSearchResults.OONReimbursementMap.keySet()) {
                       ACETGroupPlanBenefitWrapper.OONReimbursement OONRiem = new ACETGroupPlanBenefitWrapper.OONReimbursement();
                       OONRiem.Percentile = ACETPlanBenefitSearchResults.OONReimbursementMap.get(OONKey);
                       OONRiem.OONPricingType = OONKey;
                       OONReimbursementList.add(OONRiem);
                    }
                }
                System.debug('ACETGroupPlanBenefitWrapper.OONReimbursement::::'+OONReimbursementList);
                return OONReimbursementList;
            }
            return OONReimbursementList;
        }set;
        
    }
    
    public List<ACETGroupPlanBenefitWrapper.AccumulatorP> IndividualAccs {
        get{
            if(IndividualAccs == null || (IndividualAccs != null && IndividualAccs.size() == 0)){
                List<ACETGroupPlanBenefitWrapper.AccumulatorP> IndividualAccList = new List<ACETGroupPlanBenefitWrapper.AccumulatorP>();
                Map<String, ACETGroupPlanBenefitWrapper.AccumulatorP> IndividualSet = new Map<String, ACETGroupPlanBenefitWrapper.AccumulatorP>();
                      
                if(ACETPlanBenefitSearchResults != null && ACETPlanBenefitSearchResults.accumulatorList != null && !ACETPlanBenefitSearchResults.accumulatorList.isEmpty()) {
                    for (ACETGroupPlanBenefitWrapper.AccumulatorP oAccumulator :ACETPlanBenefitSearchResults.accumulatorList) {
                        if (oAccumulator.Section == 'Individual' && oAccumulator != null) {
                            IndividualSet.put(oAccumulator.TypeCode,oAccumulator);
                        }
                    }
                    if(IndividualSet.size() > 0) {
                        IndividualAccList.addAll(IndividualSet.values());
                        IndividualAccList.sort();
                    }
                }
                System.debug('ACETGroupPlanBenefitWrapper.IndividualAccList::::'+IndividualAccList);
                return IndividualAccList;
            }
            return IndividualAccs;
        }set;
        
    }
    
   
    public List<ACETGroupPlanBenefitWrapper.AccumulatorP> FamilyAccs {
        get{
            if(FamilyAccs == null || (FamilyAccs != null && FamilyAccs.size() == 0)){
                List<ACETGroupPlanBenefitWrapper.AccumulatorP> familyAccList = new List<ACETGroupPlanBenefitWrapper.AccumulatorP>();
                Map<String, ACETGroupPlanBenefitWrapper.AccumulatorP> familySet = new Map<String, ACETGroupPlanBenefitWrapper.AccumulatorP>();
                
                if(ACETPlanBenefitSearchResults!= null && ACETPlanBenefitSearchResults.accumulatorList != null && !ACETPlanBenefitSearchResults.accumulatorList.isEmpty()) {
                    for (ACETGroupPlanBenefitWrapper.AccumulatorP oAccumulator :ACETPlanBenefitSearchResults.accumulatorList) {
                        if (oAccumulator.Section == 'Family' && oAccumulator != null) {
                            familySet.put(oAccumulator.TypeCode,oAccumulator);
                        }
                    }
                    if(familySet.size() > 0) {
                        familyAccList.addAll(familySet.values());
                        familyAccList.sort();
                    }
                }
                System.debug('ACETGroupPlanBenefitWrapper.familyAccList::::'+familyAccList);
                return familyAccList;
            }   
            return FamilyAccs;
        }set;
        
    }
    
   public List<ACETGroupPlanBenefitWrapper.AccumulatorP> getGroupFamilyAccs() {
       System.debug('ACETPlanBenefitSearchResults:::GroupFamilyAccs'+ACETPlanBenefitSearchResults);
       List<ACETGroupPlanBenefitWrapper.AccumulatorP> familyAccList = new List<ACETGroupPlanBenefitWrapper.AccumulatorP>();
       return familyAccList;
   }
   
   public List<ACETGroupPlanBenefitWrapper.AccumulatorP> getGroupIndividualAccs() {
       System.debug('ACETPlanBenefitSearchResults:::IndividualFamilyAccs'+ACETPlanBenefitSearchResults);
       List<ACETGroupPlanBenefitWrapper.AccumulatorP> individualAccList = new List<ACETGroupPlanBenefitWrapper.AccumulatorP>();
       return individualAccList;
   }
   
    
    /*  1. If  coverage end date < today’s date then pick last date of coverage period 
        2. If coverage end date >= today’s date then pick todays date 
        3. If coverage EffectiveDate> today’s date then pick coverage start date
     * */
  
     public void populateDate() {
         DateTime todaysdate = DateTime.newInstance(date.today().year(),date.today().month(),date.today().day(),0,0,0);
                     //US2962032 : replaced date.parse() to DateTime.newInstance() to handle open ended dtaes 
        if(!String.isEmpty(EndDate) && !String.isEmpty(EffectiveDate)) {
       if(DateTime.newInstance(integer.valueof(EndDate.split('/')[2]),integer.valueof(EndDate.split('/')[0]),integer.valueof(EndDate.split('/')[1]), 0, 0, 0) >= todaysdate && DateTime.newInstance(integer.valueof(EffectiveDate.split('/')[2]),integer.valueof(EffectiveDate.split('/')[0]),integer.valueof(EffectiveDate.split('/')[1]), 0, 0, 0) <  todaysdate) {
                Date todayAccumsDate  = Date.Today();
                accumsDateSearch =Acetutility.format(todayAccumsDate);
            }
            else if(DateTime.newInstance(integer.valueof(EndDate.split('/')[2]),integer.valueof(EndDate.split('/')[0]),integer.valueof(EndDate.split('/')[1]), 0, 0, 0) < todaysdate) {
                accumsDateSearch  = EndDate;
            }
            else if(DateTime.newInstance(integer.valueof(EffectiveDate.split('/')[2]),integer.valueof(EffectiveDate.split('/')[0]),integer.valueof(EffectiveDate.split('/')[1])) >  todaysdate && DateTime.newInstance(integer.valueof(EndDate.split('/')[2]),integer.valueof(EndDate.split('/')[0]),integer.valueof(EndDate.split('/')[1]), 0, 0, 0) >= todaysdate) {
                accumsDateSearch  = EffectiveDate;
            }
        } 
    }    
      public void accumasOfDate(){
        if(dateSearch != null){
            ACETNimbusGetSSBAPI subwebsrvc = new ACETNimbusGetSSBAPI();
            ACETWSCalloutResult callouresult = subwebsrvc.getSubscriptionBenefitSearch(dateSearch.bundleOptionId,'',dateSearch.SRKID,'',dateSearch.effectStartDate,dateSearch.effectEndDate,dateSearch.cvrType,dateSearch.grpNumber,'',accumsDateSearch,customerPurchaseid); 
            IndividualAccs =null; //getIndividualAccs();
            
        }
        System.debug('onclick-->'+dateSearch);
    }
}