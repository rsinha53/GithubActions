public with sharing class ACETGroupDetail{
    public string groupName{get;set;}
    public string groupId{get;set;}
    public string groupTaxId{get;set;}
    public string groupRenewalDate{get;set;}
    public string groupAddress{get;set;}
    public string groupCity{get;set;}
    public string groupState{get;set;}
    public string groupZip{get;set;}
    public string groupStatus{get;set;}
    public Boolean noCustomerAccount{get;set;}
    public Boolean isChildPEO{get;set;}
    public String parentPEOId{get;set;}
    public list<purchasedBenefits> purchasedBenefitsList{get;set;}
    public list<CurveOut> curveOutList{get;set;}
    Public string tieredPlan{get;set;}
    public list<holdCodeInfo> holdCode {get; set;} 
    public list<cobAttestation> groupSettings {get;set;} //US1699536
    public groupGeneralInfo genGroupInfo{get; set;}
    public AddressInfo addrGroupInfo {get;set;}
    Public GroupAffiliationsinfo grpAffiliationsinfo{get;set;}
    Public list<GroupAffiliationsinfo> grpAffiliationsinfolist{get;set;}

    public addGroupInfo additionalGroupInfo {get;set;}
    public list<employeeCountInfo> groupEmployeeCountInfoList{get;set;}
    public list<groupContactInfo> groupExternalContactInfoFullList{get;set;}  //US966071 
    public list<groupContactInfo> groupExternalContactInfoList{get;set;}
    public list<groupContactInfo> groupExternalContactInfoHistoryList{get;set;}
    public list<groupContactInfo> groupInternalContactInfoList{get;set;}
    public list<AddressInfo> groupAddressInfoList {get;set;}
    public list<AddressInfo> groupAddressInfoPastList {get;set;}
    public list<AddressInfo> groupAddressInfoCurrFutureList {get;set;}

    public SpecialityBenefit SpecialityBenefit{get;set;}
    //public list<StatusDetails> groupStatusDetailsList {get;set;}
    public list<Notes> groupNotes{get;set;} //US914091
    public list<PolicyContractStatus> policyStatusList{get;set;} 
    //Benefit
    public list<GroupPlanWrapper> GroupPlanBenefitList {get;set;}
    public list<StatusDetails> groupStatusDetailsList {get;set;}
    public list<PolicyContract> polContract{get;set;}     //US912388 //getemp V3 
    public list<InsuredRules> insurRuleslist{get;set;} //US921396
    public list<GroupInsuringRules> groupInsuringRules{get;set;}
    public list<GroupInsuringSettings> groupInsuringSettings{get;set;}
   
    public List<SpecialtyBenefits_CoverageLine> specialityBenefits{get;set;}
    public ACETGroupDetail(){
        specialityBenefits = new List<SpecialtyBenefits_CoverageLine>();
    }
    
    public class groupGeneralInfo{
        public string groupName{get;set;}
        public string groupId{get;set;}
        public string groupTaxId{get;set;}
        public string groupStatus{get;set;}
        public string groupRenewalDate{get;set;}
        public String groupTeamSize { get; set; }
        public string serviceTeam{get;set;}
        public String effectiveStartDate { get; set; }
        public String effectiveEndDate { get; set; }
        public String UHCBSCOBRA{ get; set;}                // Continuation Responsibility
        public String continuationType{get;set;}
        public String legacyGroupNumber{get;set;}
        public String riskManagement{ get; set;}
        public String asianInitIndicator{ get; set;}
        public String insured{ get; set;}                    // Funding Arragement
        public string onshoreRestriction{get;set;}
        public string terminationDate{get;set;}
        public string terminationReason{get;set;}
        public String classesIncluded{get; set;}
        //US909857 start
        public String holdCode {get; set;}
        public Boolean holdCodeIndicator {get; set;}
        public String fundingArrangement{get; set;}
        public String parentIndicator{get; set;}
        public String exchangeType{get; set;}
        //US909857 end
        public String enrollmentMethod{get;set;} //US997421
        public String originalgrpStartDate{get;set;} // Added for V3
        public String religiousExemptionType {get;set;} //US1747504
        public String religiousExemptionDesc {get;set;} //US1747504
        Public String alphaParentGroup{get;set;}
        Public String parentGroup{get;set;}
        Public String migrationSourceSystem {get;set;} //US2810030
       
    }
    //US953096 starts
    public class holdCodeInfo{
        public String holdID {get; set;}
        public String holdCode {get; set;}
        public String holdDescription {get; set;}
        public String holdEffectiveDate {get; set;}
        public String holdExpirationDate {get; set;} 
        public String holdProcessedOn {get;set;}       
    }
    //US953096 ends
    
    
    //US912435 start
     public class addGroupInfo{
        public String memGroupClassification{get;set;}
        public String industryClassCodeType{get;set;}
        public String enrollmentMethod{get;set;}
        public String industryClassCode{get;set;}
        public String timelyFilingID{get;set;}
        public String industryClassCodeDesc{get;set;}
        public String medicareEstimation{get;set;} //US526624
        public String medicareCrossoverAvailable{get;set;} //US816409
        public String medicareCrossoverElected{get;set;} //US816409
     }
    //US912435 end    
    public class AddressInfo{
        public string addrType {get;set;}
        public String addrLine1 { get; set;}
        public String addrLine2 { get; set;}
        public String addrLine3 { get; set;}
        public String city { get; set;}
        public String state{ get; set;}
        public String zip { get; set;}
        public string address{get;set;} //Added by Krishna for US598757
        public string concatAddrLines{get;set;} //Added by Krishna for US665995 
        public String effectiveDate{get;set;}
        public String expirationDate{get;set;}
    }
     public class GroupAffiliationsinfo{
        public string parentGroupid {get;set;}
        public String parentGroupname { get; set;}
        public String childGroupid { get; set;}
        public String childGroupname { get; set;}
        public list<String> childGroupidlist { get; set;}
        public list<String> childGroupnamelist { get; set;}
        public String alphaParentGroupid { get; set;}
        public String alphaParentGroupname{ get; set;}
        public String groupLevelHoldIndicator { get; set;}
        public string organizationRelationshipTypeCodeandDescription{get;set;} 
        public String effectiveDate{get;set;}
        public String expirationDate{get;set;}
    }
    
    //US1699536 starts
    public class cobAttestation{
        public String cobAttestationFrequency{get;set;}                 
        public String cobAttestationDenyGracePeriod{get;set;}           
        public String effectiveDate{get;set;}                           
        public String expirationDate{get;set;}                          
        public String religiousExemptionTypeDescription{get;set;}       
    }
    //US1699536 ends
    
    public class employeeCountInfo{
        public String employeeAtne{get;set;}
        public String efectiveFrom{get;set;}
        public String effectiveThrough{get;set;}
        public String fullTime{get;set;}
        public String partTime{get;set;}
        public String unionEligible{get;set;}
        public String totalEligible{get;set;}
        public String fullTimeEquivalent{get;set;}
        //US812027           
        public String renewalYear{get;set;}  
        public String lastUpdate{get;set;}                          
    }
    
    
   
    public class groupContactInfo{
        public String primaryContactType{get;set;}
        public String firstName{get;set;}
        public String LastName{get;set;}
        public String middleName{get;set;}
        public String fullName{get;set;}
        public String startDate{get;set;}
        public String endDate{get;set;}
        public String effeDate{get;set;}
        public String AddrLine1 { get; set;}
        public String AddrLine2 { get; set;}
        public String City { get; set;}
        public String State{ get; set;}
        public String Zip { get; set;}
        public String country { get; set;}
        public String Phone{get;set;}
        public String extension{get;set;}
        public String fax{get;set;}
        public String EmailAddress{get;set;}
        public string address{get;set;}
        public list<addressInfo> contactAddress{get;set;}
        public list<contactPhoneInfo> contactPhones{get;set;}
        public list<string> contactEmails{get;set;}
        public string contactType{get;set;}
        public string addressType{get; set;}
        public string activeStatus{get;set;}
        public string Organization{get;set;}
    }
    
    public class contactPhoneInfo{
        public String phonePrimaryIndicator{get;set;}
        public string phoneType{get;set;}
        public string phoneNumber{get;set;}
        public string phoneExt{get;set;}
        public string internationalIndicator{get;set;} 
    }
    
    public class purchasedBenefits{
        public string product{get;set;}
        public string benefit{get;set;}
        public string planMetalicLevel{get;set;}
        public string network{get;set;}
        public string tier{get;set;}
        public CurveOut CarveOutDetails{get; set;}
        public list<Riders> ridersList{get;set;}
        public list<contactType> contactTypeList{get;set;}
        public list<CSPDetails> CSPDetailsList{get;set;}
        public list<ageBand> ageBandList{get; set;}        
    }
    
    public class Riders{
        public string riderCode{get;set;}
        public string description{get;set;}
        public string fromDate{get;set;}
        public string thruDate{get;set;}
    }
    
    public class CurveOut{
        public string high{get;set;}
        public string low{get;set;}
    }
    public class contactType{
        public string contactType{get;set;}
        public string amount{get;set;}
    }
    
    public class CSPDetails{
        public string cspDetail{get;set;}
        public string conType{get;set;}
        public string fdType{get;set;}
        public string amount{get;set;}
        public string fromDate{get;set;}
        public string thruDate{get;set;}
        public string reason{get;set;}
        public string deactivated{get;set;}        
    }
    
    public class ageBand{
        public string ageBand{get;set;}
        public single singleDetails{get;set;}
        public parentwoChildren parentDetails{get;set;}
        public couple coupleDetails{get;set;}
        public family familyDetails{get;set;}
        public medicare medicareDetails{get;set;}
    }
    
    public class single{
        public string male{get;set;}
        public string female{get;set;}
    }
    
    public class parentwoChildren{
        public string male{get;set;}
        public string female{get;set;}
    }
    
    public class couple{
        public string male{get;set;}
        public string female{get;set;}
    } 
    
    public class family{
        public string male{get;set;}
        public string female{get;set;}
    } 
    
    public class medicare{
        public string status{get;set;}        
    } 
  
    //Plan Summary Section
    public string accumulator {get; set;}
    public string PlanClass {get; set;}
    public String Product {get; set;}
    public String Gated {get; set;}
    public String PCPRequired {get; set;}
    public String PlanMettalicLevel {get; set;}
    public String Network {get; set;}
    public String Tier {get; set;}
    public String policyNo {get; set;}
    public String planID {get; set;}
    public String effecDate {get; set;}
    public String endDate {get; set;}
    public String situsState {get; set;}
    //US957991 starts
    public String hsaAvailable {get;set;}
    public String hsaElected {get;set;}
    public String administeredBy {get;set;}
    public String phone {get;set;}
    //US957991 ends
    public String domPartner{get;set;}
    public String FundingArrangement{get;set;}
    Public String dependentCutOff{get;set;}
    
    //Group Plan benefit Section 
    public class GroupPlanWrapper {
        public String PlanClass {get; set;}
        public String stateOfIssueCode{get;set;}
        public String Accumulator {get; set;}
        public String planOptionDesc{get; set;}  //US1036961
        public String Product {get; set;}
        public String Gated {get; set;}
        public String PCPRequired {get; set;}
        public String PlanMettalicLevel {get; set;}
        public String Network {get; set;}
        public String Tier {get; set;}
        public String contractID {get; set;}
        public String bundleID {get; set;}
        public String planID {get; set;}
        public String effecDate {get; set;}
        public String endDate {get; set;}
        public String GUID {get; set;}
        public boolean isActive {get; set;}
        public String groupId {get; set;}
        public String domPartner{get;set;} // Domestic partner
        public String FundingArrangement{get;set;}
        public List<FamilyBasedWrap> familyBasedGroupPlanList {get; set;} 
        public List<AgeBandWrap> ageBandGroupPlanList {get; set;} 
        public list<InsuredRules> insurRules{get;set;} 

        //US941788 start
        public String hsaAvailable {get; set;}
        public String hsaElected {get;set;}
        public String administeredBy {get; set;}
        public String phone {get; set;}
        public String planNameHoverVal{get;set;}
        
        //US941788 end
        //public GroupPlanWrapper(String policyNoGp,String planIDGp, String PlanClss, String ProductSa, String GatedGrp,String PCPReq,String accgp,String PlanMetall, String NetworkGrp, String TierGrp,String effecDategp,String endDategp) {
        public GroupPlanWrapper() {   
            /*policyNo = policyNoGp;
            planID = planIDGp;
            //CSP = CspCpunt;
            PlanClass = PlanClss;
            Accumulator = accgp;
            Product = ProductSa;
            Gated = GatedGrp;
            PCPRequired = PCPReq;
            PlanMettalicLevel = PlanMetall;
            Network = NetworkGrp;
            Tier = TierGrp;
            effecDate = effecDategp;
            endDate = endDategp;*/
            GUID = ACETGUIDUtil.newGuid();                
        }
        
        public String getImage(){ 
            String benefitStatus = '';
            Date objEffectiveDate = Date.newInstance(Integer.valueOf(effecDate.split('/')[2]), Integer.valueOf(effecDate.split('/')[0]), Integer.valueOf(effecDate.split('/')[1]));
            Date objEndDate = Date.newInstance(Integer.valueOf(EndDate.split('/')[2]), Integer.valueOf(EndDate.split('/')[0]), Integer.valueOf(EndDate.split('/')[1]));
            
            if(Date.today() < objEffectiveDate) {
                benefitStatus = 'Blue';
            }
            else if(Date.today() >= objEffectiveDate && Date.today() <= objEndDate) {
                benefitStatus = 'active';
            }
            else if(Date.today() > objEffectiveDate && Date.today() > objEndDate) {
                benefitStatus = 'inactive';
            }
            return benefitStatus;
        }    
    } 
    
    public class AgeBandWrap implements Comparable {
        public String AgeBand {get; set;}
        public String premium {get; set;}
        
        public Integer compareTo(Object o) {
            AgeBandWrap that = (AgeBandWrap) o;
            if (this.AgeBand < that.AgeBand) return -1;
            else if (this.AgeBand > that.AgeBand) return 1;
            else return 0;
        }
        
    } 
    public class FamilyBasedWrap {
        public String contractTypeCode{get;set;}
        public String contractTypeDescription{get;set;}
        public String amount{get;set;}
        
    } 
    
    public class riderWrapper {
        public String riderCode {get; set;}
        public String description {get; set;}
        public String FromGp {get; set;}
        public String thru {get; set;}
         public riderWrapper (String riderCodegp,String descriptionGp,String fromGpp, String thruGp) {
            riderCode = riderCodegp;
            description = descriptionGp;
            FromGp = fromGpp;
            thru = thruGp;
        }
    }
      
      public class StatusDetails{
        public String status{get;set;}
        public String effectDate{get;set;}
        public String endDate{get;set;}
        public String processedOn{get;set;}
        public String processedBy{get;set;}
        public String reason{get;set;}
    }
    //US914091 starts
    public class Notes{
        public String noteSubject{get;set;}
        public String noteType{get;set;}
        public String createdBy{get;set;}
        public String createdDate{get;set;}
        public String contractId{get;set;}
    }
    //US914091 ends
    
    public class PolicyGeneralInfo{
        public String contractId{ get; set; }                // Contract Option Id
        public String contractDesc{ get; set; }
        public String contractStatus{ get; set;}
        public String contractEffectiveDate{ get; set; }
        public String contractEndDate{ get; set; }
        public String memberGroupId{ get; set; }
        public String contractType{ get; set; }
        public String originalContractDate{ get; set;}
        public String migratedContract{ get; set; }
        public String enrollmetIns{ get; set; }
        public String situsState{ get; set;}
        public String contractDCN{ get; set;}
        public String participationType{ get; set; }
        public String sourceSys{ get; set; }
        public String sourceSysId{ get; set;}
        public String billingPrefType{ get; set;}
        public String renewalDate{get;set;}
        //more TBD        
    }
    
    //US912388 starts
    //getemp V3 starts
    public class PolicyContract implements Comparable{
        public String policyConId{get;set;} // US1036941    // Contract Option or Account Option Id
        public String population{get;set;}  // US1036941    // Concatenation of Account Option populations
        //public String policyId{get;set;}
        public Boolean hasPopulation{get;set;}
        public String policyOptId{get;set;}            // Contract Plan Option ID
        public String policyStatus{get;set;}           // Populate based on Date
        public String policyActualStatus{get;set;}     // Mapped from service
        public String benefitBundleId{get;set;}        // Benefit Bundle Option ID
        public String effectiveDate{get;set;}
        public String effectiveDatenoformat{get;set;}  // Temp
        public String endDate{get;set;}
        public String endDateNoFormat{get;set;}
        public String migrated{get;set;}
        public String stateOfIssueCode{get;set;}      // US758593
        public String OnshoreRestrictionCode {get;set;}          
        public String onshoreRestrictionText{get;set;}            
        public String onshoreRestrictionToolTip{get;set;}         
        public String onshoreRestrictionBoolean{get;set;}         
        public boolean onshoreRestrictionError{get;set;}         
        public boolean isRestrict{get;set;}                       
        public String continuationType {get;set;}                
        public String responsibilityType {get;set;}              
        public PolicyGeneralInfo polGenGroupInfo{get;set;}   
        public list<InsuredRules> insurRules{get;set;} //US921396 
        //Benefit
        public list<GroupPlanWrapper> GroupPlanBenefitList {get;set;}   
        public String groupSitusState{get;set;}
        public String exchangeType{get;set;}     //US1744101
        public String bookOfBusinessTypeCode{get;set;}	// US3584879 : Added By Manish
        public String bookOfBusinessTypeDesc{get;set;}  // US3584879 : Added By Manish
        public Integer compareTo(Object objToCompare) {
            PolicyContract polcy= (PolicyContract)objToCompare;
            if (policyConId > polcy.policyConId) return 1;
            else if(policyConId == polcy.policyConId){
               if (policyActualStatus> polcy.policyActualStatus) return 1;
               else return -1;
            }
            else return -1;
        }
    }
    
    
     public class SpecialityBenefit implements Comparable{
        public String contractOptionType{get;set;} 
        public String policyOptId{get;set;}            
        public String effectiveDate{get;set;}
        public String endDate{get;set;}
         public String status{get;set;}
        public Integer compareTo(Object o) {
            SpecialityBenefit that = (SpecialityBenefit) o;
            if(this.status=='Active' && that.status!='Active') return 1;
            else if(that.status=='Active' && this.status!='Active') return -1;
            else if (this.effectiveDate <= that.effectiveDate) return -1;
            else if (this.effectiveDate >= that.effectiveDate) return 1;
            else return 0;
        }
    }   
        
    //US912388 ends
    //US758593 changes starts

    
   
    
    //US758593 changes ends
    
    //US936960 changes starts
    public class PolicyContractStatus{
        public String status{get;set;}
        public String effectiveDate{get;set;}
        public String endDate{get;set;}
        public String processedOn{get;set;}
        public String processedBy{get;set;}
        public String reason{get;set;}
    }
    //US936960 changes ends
    
     //US921396 starts
    public class InsuredRules implements Comparable{
        public list<InsRule> insrules{get;set;}
        public String population{get;set;}
        public String effectiveDate{get;set;}
        public Boolean hasPopulation{get;set;}
        public String status{get;set;}
        public String endDate{get;set;}
        public String fullDate{get;set;}
        Public String insuringRuleEffectiveDates{get;set;}
        Public String insuringRuleExpirationDates{get;set;}
        Public String dependentCutOff{get;set;}
        Public String insRulesDesc{get;set;}
        Public string dependentCutOffType{get;set;}
        public Integer compareTo(Object objToCompare) {
           InsuredRules insRl= (InsuredRules)objToCompare;
           if ((String.IsNotBlank(effectiveDate)&& String.IsNotBlank(insRl.effectiveDate))&& (Date.parse(effectiveDate)> Date.parse(insRl.effectiveDate))) return -1;
           else return 1;
      }
    }
    //US921396 ends
    
    public class InsRule{
        public String pop{get;set;}
        public String fullDate{get;set;}
        public String insRules{get;set;}
        public String insRulesDesc{get;set;}
        public String OnshoreRestrictTooltip{get;set;}
        Public String dependentCutOff{get;set;}
        Public String insuringRuleEffectiveDates{get;set;}
        Public String insuringRuleExpirationDates{get;set;}
        
    }
    
    public class GroupInsuringRules{
        public String classesCode{get;set;}  
        public String cobraAdministrativeIndicator{get;set;}            
        public String continuationResponsibilityType{get;set;}          
        public String insuranceContinuationType{get;set;}               
        public String onshoreRestriction{get;set;}                      
        public String insuringRulesEffectiveDates{get;set;}             
        public String insuringRulesExpirationDates{get;set;}            
        public String insuringRulesEffectiveDatesNoFormat{get;set;}             
        public String insuringRulesExpirationDatesNoFormat{get;set;}            
        public String pcpRadomization{get;set;}                         
        public String survivingSpouseIndicator{get;set;}                
        public String newBornAutoAddIndicator{get;set;}                 
        public String countNewbornForCoverageLevelCodeIndicator{get;set;}   
        public String earlyRetirementIndicator{get;set;}
        public String earlyRetirementMinimumAge{get;set;}
        public String workingRetirementIndicator{get;set;}
        public String workingRetirementMinimumAge{get;set;}
    }
    //getemp V3 ends
     public class GroupInsuringSettings{
        public String classesCode{get;set;}  
        public String continuationResponsibilityType{get;set;}          
        public String insuranceContinuationType{get;set;}     
        public String onshoreRestriction{get;set;}                      
        public String insuringRulesEffectiveDates{get;set;}             
        public String insuringRulesExpirationDates{get;set;} 
        public String pcpRadomization{get;set;}                        
        public String survivingSpouseIndicator{get;set;}               
        public String newBornAutoAddIndicator{get;set;}                
        public String countNewbornForCoverageLevelCodeIndicator{get;set;}  
        public String earlyRetirement{get;set;}
        public String workingRetirement{get;set;}
                   
    }
      
     /******New Code added by Abhinav Balla Start******/
        
     public class GroupRules{
        public String newPopulation{get;set;}
        public list<String> newDates{get;set;}
        public list<GroupInsuredRules> newRules{get;set;}
        
    }   
    public Class SpecialtyBenefits_CoverageLine implements Comparable{
        Public String ContractOptionType {get;set;}
        Public String planOptionID{get;set;}
        Public String ContractOptionStartDate {get;set;}
        Public String ContractOptionEndDate {get;set;}
        Public String isActive {get;set;}
        Public String customerPurchaseId {get;set;}
        
        public Integer compareTo(Object o) {
            SpecialtyBenefits_CoverageLine that = (SpecialtyBenefits_CoverageLine) o;
            if(this.isActive=='Active' && that.isActive!='Active') return -1;
            else if(that.isActive=='Active' && this.isActive!='Active') return 1;
            else if (this.ContractOptionEndDate!=null && that.ContractOptionEndDate!=null && Date.valueOf(this.ContractOptionEndDate) <= Date.valueOf(that.ContractOptionEndDate)) return 1;
            else if (this.ContractOptionEndDate!=null && that.ContractOptionEndDate!=null && Date.valueOf(this.ContractOptionEndDate) >= Date.valueOf(that.ContractOptionEndDate)) return -1;
            else return 0;
        }
        
        public String formatDate(String dateInstance){
            if(dateInstance!=null && dateInstance!=''){
                return dateInstance.split('-')[1]+'/'+dateInstance.split('-')[2]+'/'+dateInstance.split('-')[0];
            }
            return null;
        }
        
        public List<SpecialtyBenefits_CoverageLine> formatDate(List<SpecialtyBenefits_CoverageLine> listOfSpecialBenefits){
            for(SpecialtyBenefits_CoverageLine sp: listOfSpecialBenefits){
                sp.ContractOptionStartDate = formatDate(sp.ContractOptionStartDate);
                sp.ContractOptionEndDate = formatDate(sp.ContractOptionEndDate);                
            }
            return listOfSpecialBenefits;
        }
        
    }
    public class GroupInsuredRules{
            public string pop{get;set;}
            public string effectiveDate{get;set;}
            public string endDate{get;set;}
            public string fullDate{get;set;}
            public list<InsRule> insrules{get;set;}
         
    } 
    /******New Code added by Abhinav Balla End******/
    
   
       
}