public class ACETLGT_GroupDetail {
    
    @AuraEnabled public string groupName{get;set;}
    @AuraEnabled public string groupId{get;set;}
    @AuraEnabled public string groupTaxId{get;set;}
    @AuraEnabled public string groupRenewalDate{get;set;}
    @AuraEnabled public string groupAddress{get;set;}
    @AuraEnabled public string groupCity{get;set;}
    @AuraEnabled public string groupState{get;set;}
    @AuraEnabled public string groupZip{get;set;}
    @AuraEnabled public string groupStatus{get;set;}
    @AuraEnabled public Boolean noCustomerAccount{get;set;}
    @AuraEnabled public Boolean parentPEOId{get;set;}
    @AuraEnabled public list<purchasedBenefits> purchasedBenefitsList{get;set;}
    @AuraEnabled public list<CurveOut> curveOutList{get;set;}

    @AuraEnabled public list<holdCodeInfo> holdCode {get; set;} 
    @AuraEnabled public list<cobAttestation> groupSettings {get;set;} //US1699536
    @AuraEnabled public groupGeneralInfo genGroupInfo{get; set;}
    @AuraEnabled public AddressInfo addrGroupInfo {get;set;}
    @AuraEnabled public addGroupInfo additionalGroupInfo {get;set;}
    @AuraEnabled public list<employeeCountInfo> groupEmployeeCountInfoList{get;set;}
    @AuraEnabled public list<groupContactInfo> groupExternalContactInfoFullList{get;set;}  //US966071 
    @AuraEnabled public list<groupContactInfo> groupExternalContactInfoList{get;set;}
    @AuraEnabled public list<groupContactInfo> groupExternalContactInfoHistoryList{get;set;}
    @AuraEnabled public list<groupContactInfo> groupInternalContactInfoList{get;set;}
    @AuraEnabled public list<AddressInfo> groupAddressInfoList {get;set;}
    @AuraEnabled public list<AddressInfo> groupAddressInfoPastList {get;set;}
    @AuraEnabled public list<AddressInfo> groupAddressInfoCurrFutureList {get;set;}

    
    
    @AuraEnabled public list<Notes> groupNotes{get;set;} //US914091
    @AuraEnabled public list<PolicyContractStatus> policyStatusList{get;set;} 
    //Benefit
    @AuraEnabled public list<GroupPlanWrapper> GroupPlanBenefitList {get;set;}
    @AuraEnabled public list<StatusDetails> groupStatusDetailsList {get;set;}
    @AuraEnabled public list<PolicyContract> polContract{get;set;}     //US912388 //getemp V3 
    @AuraEnabled public list<InsuredRules> insurRules{get;set;} //US921396
    @AuraEnabled public list<GroupInsuringRules> groupInsuringRules{get;set;}
    @AuraEnabled public list<GroupInsuringSettings> groupInsuringSettings{get;set;}
    
    public ACETLGT_GroupDetail(){}
    
    public class groupContactInfo{
        @AuraEnabled public String primaryContactType{get;set;}
        @AuraEnabled public String firstName{get;set;}
        @AuraEnabled public String LastName{get;set;}
        @AuraEnabled public String middleName{get;set;}
        @AuraEnabled public String fullName{get;set;}
        @AuraEnabled public String startDate{get;set;}
        @AuraEnabled public String endDate{get;set;}
        @AuraEnabled public String effeDate{get;set;}
        @AuraEnabled public String AddrLine1 { get; set;}
        @AuraEnabled public String AddrLine2 { get; set;}
        @AuraEnabled public String City { get; set;}
        @AuraEnabled public String State{ get; set;}
        @AuraEnabled public String Zip { get; set;}
        @AuraEnabled public String country { get; set;}
        @AuraEnabled public String Phone{get;set;}
        @AuraEnabled public String extension{get;set;}
        @AuraEnabled public String fax{get;set;}
        @AuraEnabled public String EmailAddress{get;set;}
        @AuraEnabled public string address{get;set;}
        @AuraEnabled public list<addressInfo> contactAddress{get;set;}
        @AuraEnabled public list<contactPhoneInfo> contactPhones{get;set;}
        @AuraEnabled public list<string> contactEmails{get;set;}
        @AuraEnabled public string contactType{get;set;}
        @AuraEnabled public string addressType{get; set;}
        @AuraEnabled public string activeStatus{get;set;}
        @AuraEnabled public string Organization{get;set;}
    }
    
    public class contactPhoneInfo{
        @AuraEnabled public String phonePrimaryIndicator{get;set;}
        @AuraEnabled public string phoneType{get;set;}
        @AuraEnabled public string phoneNumber{get;set;}
        @AuraEnabled public string phoneExt{get;set;}
        @AuraEnabled public string internationalIndicator{get;set;} 
    }        
    
    public class groupGeneralInfo{
        @AuraEnabled public string groupName{get;set;}
        @AuraEnabled public string groupId{get;set;}
        @AuraEnabled public string groupTaxId{get;set;}
        @AuraEnabled public string groupStatus{get;set;}
        @AuraEnabled public string groupRenewalDate{get;set;}
        @AuraEnabled public String groupTeamSize { get; set; }
        @AuraEnabled public string serviceTeam{get;set;}
        @AuraEnabled public String effectiveStartDate { get; set; }
        @AuraEnabled public String effectiveEndDate { get; set; }
        @AuraEnabled public String UHCBSCOBRA{ get; set;}                // Continuation Responsibility
        @AuraEnabled public String continuationType{get;set;}
        @AuraEnabled public String legacyGroupNumber{get;set;}
        @AuraEnabled public String riskManagement{ get; set;}
        @AuraEnabled public String asianInitIndicator{ get; set;}
        @AuraEnabled public String insured{ get; set;}                    // Funding Arragement
        @AuraEnabled public string onshoreRestriction{get;set;}
        @AuraEnabled public string terminationDate{get;set;}
        @AuraEnabled public string terminationReason{get;set;}
        @AuraEnabled public String classesIncluded{get; set;}
        //US909857 start
        @AuraEnabled public String holdCode {get; set;}
        @AuraEnabled public Boolean holdCodeIndicator {get; set;}
        @AuraEnabled public String fundingArrangement{get; set;}
        @AuraEnabled public String parentIndicator{get; set;}
        @AuraEnabled public String parentGroup{get; set;} //US2874415
        @AuraEnabled public String alphaParentGroup{get; set;}  //US2874415
        @AuraEnabled public String exchangeType{get; set;}
        //US909857 end
        @AuraEnabled public String enrollmentMethod{get;set;} //US997421
        @AuraEnabled public String originalgrpStartDate{get;set;} // Added for V3
        @AuraEnabled public String religiousExemptionType {get;set;} //US1747504
        @AuraEnabled public String religiousExemptionDesc {get;set;} //US1747504
    }
    //US953096 starts
    public class holdCodeInfo{
        @AuraEnabled public String holdID {get; set;}
        @AuraEnabled public String holdCode {get; set;}
        @AuraEnabled public String holdDescription {get; set;}
        @AuraEnabled public String holdEffectiveDate {get; set;}
        @AuraEnabled public String holdExpirationDate {get; set;} 
        @AuraEnabled public String holdProcessedOn {get;set;}       
    }
    //US953096 ends    
    
    //US912435 start
     public class addGroupInfo{
        @AuraEnabled public String memGroupClassification{get;set;}
        @AuraEnabled public String industryClassCodeType{get;set;}
        @AuraEnabled public String enrollmentMethod{get;set;}
        @AuraEnabled public String industryClassCode{get;set;}
        @AuraEnabled public String timelyFilingID{get;set;}
        @AuraEnabled public String industryClassCodeDesc{get;set;}
        @AuraEnabled public String medicareEstimation{get;set;} //US526624
        @AuraEnabled public String medicareCrossoverAvailable{get;set;} //US816409
        @AuraEnabled public String medicareCrossoverElected{get;set;} //US816409
     }
    //US912435 end    
    public class AddressInfo{
        @AuraEnabled public string addrType {get;set;}
        @AuraEnabled public String addrLine1 { get; set;}
        @AuraEnabled public String addrLine2 { get; set;}
        @AuraEnabled public String addrLine3 { get; set;}
        @AuraEnabled public String city { get; set;}
        @AuraEnabled public String state{ get; set;}
        @AuraEnabled public String zip { get; set;}
        @AuraEnabled public string address{get;set;} //Added by Krishna for US598757
        @AuraEnabled public string concatAddrLines{get;set;} //Added by Krishna for US665995 
        @AuraEnabled public String effectiveDate{get;set;}
        @AuraEnabled  public String expirationDate{get;set;}
    }
    
    //US1699536 starts
    public class cobAttestation{
        @AuraEnabled public String cobAttestationFrequency{get;set;}                 
        @AuraEnabled public String cobAttestationDenyGracePeriod{get;set;}           
        @AuraEnabled public String effectiveDate{get;set;}                           
        @AuraEnabled public String expirationDate{get;set;}                          
        @AuraEnabled public String religiousExemptionTypeDescription{get;set;}       
    }
    //US1699536 ends
    public class employeeCountInfo{
        @AuraEnabled public String employeeAtne{get;set;}
        @AuraEnabled public String efectiveFrom{get;set;}
        @AuraEnabled public String effectiveThrough{get;set;}
        @AuraEnabled public String fullTime{get;set;}
        @AuraEnabled public String partTime{get;set;}
        @AuraEnabled public String unionEligible{get;set;}
        @AuraEnabled public String totalEligible{get;set;}
        @AuraEnabled public String fullTimeEquivalent{get;set;}
        //US812027           
        @AuraEnabled public String renewalYear{get;set;}  
        @AuraEnabled public String lastUpdate{get;set;}                          
    }
    
    public class purchasedBenefits{
        @AuraEnabled public string product{get;set;}
        @AuraEnabled public string benefit{get;set;}
        @AuraEnabled public string planMetalicLevel{get;set;}
        @AuraEnabled public string network{get;set;}
        @AuraEnabled public string tier{get;set;}
        @AuraEnabled public CurveOut CarveOutDetails{get; set;}
        @AuraEnabled public list<Riders> ridersList{get;set;}
        @AuraEnabled public list<contactType> contactTypeList{get;set;}
        @AuraEnabled public list<CSPDetails> CSPDetailsList{get;set;}
        @AuraEnabled public list<ageBand> ageBandList{get; set;}        
    }
    
    public class Riders{
        @AuraEnabled public string riderCode{get;set;}
        @AuraEnabled public string description{get;set;}
        @AuraEnabled public string fromDate{get;set;}
        @AuraEnabled public string thruDate{get;set;}
    }
    
    public class CurveOut{
        @AuraEnabled public string high{get;set;}
        @AuraEnabled public string low{get;set;}
    }
    public class contactType{
        @AuraEnabled public string contactType{get;set;}
        @AuraEnabled public string amount{get;set;}
    }
    
    public class CSPDetails{
        @AuraEnabled public string cspDetail{get;set;}
        @AuraEnabled public string conType{get;set;}
        @AuraEnabled public string fdType{get;set;}
        @AuraEnabled public string amount{get;set;}
        @AuraEnabled public string fromDate{get;set;}
        @AuraEnabled public string thruDate{get;set;}
        @AuraEnabled public string reason{get;set;}
        @AuraEnabled public string deactivated{get;set;}        
    }
    
    public class ageBand{
        @AuraEnabled public string ageBand{get;set;}
        @AuraEnabled public single singleDetails{get;set;}
        @AuraEnabled public parentwoChildren parentDetails{get;set;}
        @AuraEnabled public couple coupleDetails{get;set;}
        @AuraEnabled public family familyDetails{get;set;}
        @AuraEnabled public medicare medicareDetails{get;set;}
    }
    
    public class single{
        @AuraEnabled public string male{get;set;}
        @AuraEnabled public string female{get;set;}
    }
    
    public class parentwoChildren{
        @AuraEnabled public string male{get;set;}
        @AuraEnabled public string female{get;set;}
    }
    
    public class couple{
        @AuraEnabled public string male{get;set;}
        @AuraEnabled public string female{get;set;}
    } 
    
    public class family{
        @AuraEnabled public string male{get;set;}
        @AuraEnabled public string female{get;set;}
    } 
    
    public class medicare{
        @AuraEnabled public string status{get;set;}        
    } 
  
    //Plan Summary Section
    @AuraEnabled public string accumulator {get; set;}
    @AuraEnabled public string PlanClass {get; set;}
    @AuraEnabled public String Product {get; set;}
    @AuraEnabled public String Gated {get; set;}
    @AuraEnabled public String PCPRequired {get; set;}
    @AuraEnabled public String PlanMettalicLevel {get; set;}
    @AuraEnabled public String Network {get; set;}
    @AuraEnabled public String Tier {get; set;}
    @AuraEnabled public String policyNo {get; set;}
    @AuraEnabled public String planID {get; set;}
    @AuraEnabled public String effecDate {get; set;}
    @AuraEnabled public String endDate {get; set;}
    @AuraEnabled public String situsState {get; set;}
    //US957991 starts
    @AuraEnabled public String hsaAvailable {get;set;}
    @AuraEnabled public String hsaElected {get;set;}
    @AuraEnabled public String administeredBy {get;set;}
    @AuraEnabled public String phone {get;set;}
    //US957991 ends
    @AuraEnabled public String domPartner{get;set;}
    @AuraEnabled public String FundingArrangement{get;set;}
  
    //Group Plan benefit Section 
    public class GroupPlanWrapper {
        @AuraEnabled public String PlanClass {get; set;}
        @AuraEnabled public String stateOfIssueCode{get;set;}
        @AuraEnabled public String Accumulator {get; set;}
        @AuraEnabled public String planOptionDesc{get; set;}  //US1036961
        @AuraEnabled public String Product {get; set;}
        @AuraEnabled public String Gated {get; set;}
        @AuraEnabled public String PCPRequired {get; set;}
        @AuraEnabled public String PlanMettalicLevel {get; set;}
        @AuraEnabled public String Network {get; set;}
        @AuraEnabled public String Tier {get; set;}
        @AuraEnabled public String contractID {get; set;}
        @AuraEnabled public String bundleID {get; set;}
        @AuraEnabled public String planID {get; set;}
        @AuraEnabled public String effecDate {get; set;}
        @AuraEnabled public String endDate {get; set;}
        @AuraEnabled public String GUID {get; set;}
        @AuraEnabled public boolean isActive {get; set;}
        @AuraEnabled public String groupId {get; set;}
        @AuraEnabled public String domPartner{get;set;} // Domestic partner
        @AuraEnabled public String FundingArrangement{get;set;}
        @AuraEnabled public List<FamilyBasedWrap> familyBasedGroupPlanList {get; set;} 
        @AuraEnabled public List<AgeBandWrap> ageBandGroupPlanList {get; set;} 
        //US941788 start
        @AuraEnabled public String hsaAvailable {get; set;}
        @AuraEnabled public String hsaElected {get;set;}
        @AuraEnabled public String administeredBy {get; set;}
        @AuraEnabled public String phone {get; set;}
        //US941788 end
        public GroupPlanWrapper() {
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
        @AuraEnabled public String AgeBand {get; set;}
        @AuraEnabled public String premium {get; set;}
        
        public Integer compareTo(Object o) {
            AgeBandWrap that = (AgeBandWrap) o;
            if (this.AgeBand < that.AgeBand) return -1;
            else if (this.AgeBand > that.AgeBand) return 1;
            else return 0;
        }        
    } 
    public class FamilyBasedWrap {
        @AuraEnabled public String contractTypeCode{get;set;}
        @AuraEnabled public String contractTypeDescription{get;set;}
        @AuraEnabled public String amount{get;set;}        
    } 
    
    public class riderWrapper {
        @AuraEnabled public String riderCode {get; set;}
        @AuraEnabled public String description {get; set;}
        @AuraEnabled public String FromGp {get; set;}
        @AuraEnabled public String thru {get; set;}
         public riderWrapper (String riderCodegp,String descriptionGp,String fromGpp, String thruGp) {
            riderCode = riderCodegp;
            description = descriptionGp;
            FromGp = fromGpp;
            thru = thruGp;
        }
    }
      
    public class StatusDetails{
        @AuraEnabled public String status{get;set;}
        @AuraEnabled public String effectDate{get;set;}
        @AuraEnabled public String endDate{get;set;}
        @AuraEnabled public String processedOn{get;set;}
        @AuraEnabled public String processedBy{get;set;}
        @AuraEnabled public String reason{get;set;}
    }
    //US914091 starts
    public class Notes{
        @AuraEnabled public String noteSubject{get;set;}
        @AuraEnabled public String noteType{get;set;}
        @AuraEnabled public String createdBy{get;set;}
        @AuraEnabled public String createdDate{get;set;}
        @AuraEnabled public String contractId{get;set;}
    }
    //US914091 ends
    
    public class PolicyGeneralInfo{
        @AuraEnabled public String contractId{ get; set; }                // Contract Option Id
        @AuraEnabled public String contractDesc{ get; set; }
        @AuraEnabled public String contractStatus{ get; set;}
        @AuraEnabled public String contractEffectiveDate{ get; set; }
        @AuraEnabled public String contractEndDate{ get; set; }
        @AuraEnabled public String memberGroupId{ get; set; }
        @AuraEnabled public String contractType{ get; set; }
        @AuraEnabled public String originalContractDate{ get; set;}
        @AuraEnabled public String migratedContract{ get; set; }
        @AuraEnabled public String enrollmetIns{ get; set; }
        @AuraEnabled public String situsState{ get; set;}
        @AuraEnabled public String contractDCN{ get; set;}
        @AuraEnabled public String participationType{ get; set; }
        @AuraEnabled public String sourceSys{ get; set; }
        @AuraEnabled public String sourceSysId{ get; set;}
        @AuraEnabled public String billingPrefType{ get; set;}
        @AuraEnabled public String renewalDate{get;set;}
        //more TBD        
    }
    
    //US912388 starts
    //getemp V3 starts
    public class PolicyContract implements Comparable{
        @AuraEnabled public String policyConId{get;set;} // US1036941    // Contract Option or Account Option Id
        @AuraEnabled public String population{get;set;}  // US1036941    // Concatenation of Account Option populations
        @AuraEnabled public Boolean hasPopulation{get;set;}
        @AuraEnabled public String policyOptId{get;set;}            // Contract Plan Option ID
        @AuraEnabled public String policyStatus{get;set;}           // Populate based on Date
        @AuraEnabled public String policyActualStatus{get;set;}     // Mapped from service
        @AuraEnabled public String benefitBundleId{get;set;}        // Benefit Bundle Option ID
        @AuraEnabled public String effectiveDate{get;set;}
        @AuraEnabled public String effectiveDatenoformat{get;set;}  // Temp
        @AuraEnabled public String endDate{get;set;}
        @AuraEnabled public String endDateNoFormat{get;set;}
        @AuraEnabled public String migrated{get;set;}
        @AuraEnabled public String stateOfIssueCode{get;set;}      // US758593
        @AuraEnabled public String OnshoreRestrictionCode {get;set;}          
        @AuraEnabled public String onshoreRestrictionText{get;set;}            
        @AuraEnabled public String onshoreRestrictionToolTip{get;set;}         
        @AuraEnabled public String onshoreRestrictionBoolean{get;set;}         
        @AuraEnabled public boolean onshoreRestrictionError{get;set;}
        @AuraEnabled public boolean isRestrict{get;set;}                       
        @AuraEnabled public String continuationType {get;set;}                
        @AuraEnabled public String responsibilityType {get;set;}              
        @AuraEnabled public PolicyGeneralInfo polGenGroupInfo{get;set;}   
        @AuraEnabled public list<InsuredRules> insurRules{get;set;} //US921396 
        //Benefit
        @AuraEnabled public list<GroupPlanWrapper> GroupPlanBenefitList {get;set;}   
        @AuraEnabled public String groupSitusState{get;set;}
        @AuraEnabled public String exchangeType{get;set;}     //US1744101
        
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
    //US912388 ends
    //US758593 changes starts           
    //US758593 changes ends
    
    //US936960 changes starts
    public class PolicyContractStatus{
        @AuraEnabled public String status{get;set;}
        @AuraEnabled public String effectiveDate{get;set;}
        @AuraEnabled public String endDate{get;set;}
        @AuraEnabled public String processedOn{get;set;}
        @AuraEnabled public String processedBy{get;set;}
        @AuraEnabled public String reason{get;set;}
    }
    //US936960 changes ends
    
     //US921396 starts
    public class InsuredRules implements Comparable{
        @AuraEnabled public list<InsRule> insrules{get;set;}
        @AuraEnabled public String population{get;set;}
        @AuraEnabled public String effectiveDate{get;set;}
        @AuraEnabled public Boolean hasPopulation{get;set;}
        @AuraEnabled public String status{get;set;}
        @AuraEnabled public String endDate{get;set;}
        @AuraEnabled public String fullDate{get;set;}
        
        public Integer compareTo(Object objToCompare) {
           InsuredRules insRl= (InsuredRules)objToCompare;
           if ((String.IsNotBlank(effectiveDate)&& String.IsNotBlank(insRl.effectiveDate))&& (Date.parse(effectiveDate)> Date.parse(insRl.effectiveDate))) return -1;
           else return 1;
      }
    }
    //US921396 ends
    
    public class InsRule{
        @AuraEnabled public String pop{get;set;}
        @AuraEnabled public String fullDate{get;set;}
        @AuraEnabled public String insRules{get;set;}
        @AuraEnabled public String insRulesDesc{get;set;}
        @AuraEnabled public String OnshoreRestrictTooltip{get;set;}
    }
    
    public class GroupInsuringRules{
        @AuraEnabled public String classesCode{get;set;}  
        @AuraEnabled public String cobraAdministrativeIndicator{get;set;}            
        @AuraEnabled public String continuationResponsibilityType{get;set;}          
        @AuraEnabled public String insuranceContinuationType{get;set;}               
        @AuraEnabled public String onshoreRestriction{get;set;}                      
        @AuraEnabled public String insuringRulesEffectiveDates{get;set;}             
        @AuraEnabled public String insuringRulesExpirationDates{get;set;}            
        @AuraEnabled public String insuringRulesEffectiveDatesNoFormat{get;set;}             
        @AuraEnabled public String insuringRulesExpirationDatesNoFormat{get;set;}            
        @AuraEnabled public String pcpRadomization{get;set;}                         
        @AuraEnabled public String survivingSpouseIndicator{get;set;}                
        @AuraEnabled public String newBornAutoAddIndicator{get;set;}                 
        @AuraEnabled public String countNewbornForCoverageLevelCodeIndicator{get;set;}   
        @AuraEnabled public String earlyRetirementIndicator{get;set;}
        @AuraEnabled public String earlyRetirementMinimumAge{get;set;}
        @AuraEnabled public String workingRetirementIndicator{get;set;}
        @AuraEnabled public String workingRetirementMinimumAge{get;set;}
    }
    //getemp V3 ends
     public class GroupInsuringSettings{
        @AuraEnabled public String classesCode{get;set;}  
        @AuraEnabled public String continuationResponsibilityType{get;set;}          
        @AuraEnabled public String insuranceContinuationType{get;set;}     
        @AuraEnabled public String onshoreRestriction{get;set;}                      
        @AuraEnabled public String insuringRulesEffectiveDates{get;set;}             
        @AuraEnabled public String insuringRulesExpirationDates{get;set;} 
        @AuraEnabled public String pcpRadomization{get;set;}                        
        @AuraEnabled public String survivingSpouseIndicator{get;set;}               
        @AuraEnabled public String newBornAutoAddIndicator{get;set;}                
        @AuraEnabled public String countNewbornForCoverageLevelCodeIndicator{get;set;}  
        @AuraEnabled public String earlyRetirement{get;set;}
        @AuraEnabled public String workingRetirement{get;set;}
                   
    }
      
     /******New Code added by Abhinav Balla Start******/
        
    public class GroupRules{
        @AuraEnabled public String newPopulation{get;set;}
        @AuraEnabled public list<String> newDates{get;set;}
        @AuraEnabled public list<GroupInsuredRules> newRules{get;set;}        
    }  
    
    public class GroupInsuredRules{
        @AuraEnabled public string pop{get;set;}
        @AuraEnabled public string effectiveDate{get;set;}
        @AuraEnabled public string endDate{get;set;}
        @AuraEnabled public string fullDate{get;set;}
        @AuraEnabled public list<InsRule> insrules{get;set;}         
    } 
    /******New Code added by Abhinav Balla End******/
}