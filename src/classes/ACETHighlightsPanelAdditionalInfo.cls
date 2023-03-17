public class ACETHighlightsPanelAdditionalInfo {
    public String OriginatorRelationship {get;set;}
    public String OriginatorDOB {get;set;}
    public String Relationship {get;set;}    
    public String SitusState {get;set;}
    public String OnshoreIndicator {get;set;}
    public String OnshoreIndicatorVerbiage {get;set;}
    public String DOB {get;set;}
    public String Age {get;set;}
    public String EndDate {get;set;}
    public String BenefitPlanId {get;set;}    
    public String BenefitBundleOptionId {get;set;}  
    public String AllGroupBenefitBundleOptionId{get;set;}
    public string EffectiveDate {get;set;}
    public String PolicyNumber {get;set;}
    public String GroupName {get;set;}
    public String Product {get;set;}
    public String ProductType {get;set;}
    public String Network {get;set;}
    public String MemberStatus {get;set;}
    public List<holdCodeInfo> holdCodeList{get;set;}
    public String ConsumerAccountIndicator {get;set;}
    public String FirstName { get; set; }
    public String LastName { get; set; }
    public String Gender { get; set; }
    public String MemberId { get; set; }
    public String GatedPlan {get;set;}
    public String GroupNumber {get;set;}
    public String PhoneNumber {get;set;}
    public String EmployerName {get;set;}
    public String Zip {get;set;}
    public String State {get;set;}
    public String sniEligibility {get;set;}
    public String bookOfBusinessTypeCode{get;set;}
    /*****Added By Sourabh******/
    public String UHCBS{get;set;}
    public String GroupN{get;set;}
    public String GroupStatus{get;set;}
    public String ServiceTeam{get;set;}
    public String EffectiveStartDate{get;set;}
    public String selectedPolicyContract{get;set;} //getemp V3 
    public String RiskManagement{get;set;}
    public String RatingMethod{get;set;}
    public String RenewalDate{get;set;}
    public String RelationshipType{get;set;}
    public String groupSName{get;set;}
    public String contactName{get;set;}
    
    public string producerOriginator{get;set;}
    public string producerSubject{get;set;}
    public string producerId{get;set;}
    public string producerName{get;set;}
    
    public String providerType{get;set;}//added by Vishakha
    public String isMember{get;set;}//added by Vishakha
    public String isGroup{get;set;}//added by Vishakha
    public String surrogatekey {get;set;}
    
    public String isMemNotFound{get;set;}
    public String isGroupNotFound{get;set;}
    public String isProducerNotFound{get;set;}
    public String isProviderNotFound{get;set;}
    public String producerIDPNF{get;set;}
    public String phoneNumberPNF{get;set;}
    public String isMembersearch{get;set;}
    
    public String providerPhoneNumber {get;set;}
    public String platinumProvider {get;set;}
    public String providerId {get;set;}
    public String primarySpecialty {get;set;}
    public String groupFlowGroupNumber {get;set;}
    public String groupFlowGroupName {get;set;}
    public String trackingGroupNumber {get;set;}
    public String accTypes{get;set;}
    public String serviceGrp{get;set;}
    public String hsaPlan {get;set;}
    public class holdCodeInfo{
        public String holdCode{get;set;}
        public String holdDescription{get;set;}
        public String effectiveDate{get;set;}
        public String expirationDate{get;set;}
        public String holdNote{get;set;}
        public List<String> holdRestriction{get;set;}
        public String holdLevel{get;set;}
    }
	//Added by Sai Kolluru for Immunization API sotry US3415658
	public List<String> covidVaccineDosageList{get;set;}													
}