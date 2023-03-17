public class ACETLGT_GetEmployerGroupAdapterJSON2Apex {

    public GetEmployerGroup getEmployerGroup {get;set;}

    public class GetEmployerGroup {
        public GetEmployerGroupResponse getEmployerGroupResponse {get;set;}
    }
    
    public class GetEmployerGroupResponse {
        public EmployerGroup employerGroup {get;set;}
    }
    
    public class EmployerGroup {
        public String groupNumber {get;set;}
        public String groupName {get;set;}
        public String sourceSysCode {get;set;}
        public List<String> taxIdentificationNumber {get;set;}
        //public String cobraAdministrativeIndicator{get;set;}
        //public String onshoreRestriction{get;set;}
        public String sizeDefinitionCode {get;set;}
        public String sizeDefinitionDescription {get;set;}
        public String groupClassification {get;set;}                 // New 
        public String enrollmentType {get;set;}  
        public String organizationRelationshipTypeCode{get;set;}      // New 
        public ParentGroup parentGroup{get;set;}                     // New 
        public List<ParentGroup> childGroup{get;set;}                // New 
        public ParentGroup alphaParentGroup{get;set;}                // New 
        public String riskManagementIndicator{get;set;}
        public String erisaIndicator{get;set;}
        public String groupLevelHoldIndicator{get;set;}               // New 
        public List<GroupLevelHold> groupLevelHold{get;set;}          // New 
        public List<EmployeeCounts> employeeCounts{get;set;}
        public List<CobAttestation> groupSettings{get;set;}          // New 
        public List<GroupAddress> groupAddress{get;set;}
        public List<GroupContact> groupContact{get;set;}
        public List<GroupSupportTeamContact> groupSupportTeamContact{get;set;}
        public List<GroupInsuringRules> groupInsuringRules{get;set;}  //New
        public List<GroupPopulation> groupPopulation{get;set;}
        public List<CustomerAccount> customerAccount{get;set;}
        Public List<MigrationSourceSystem> migrationSourceSystem{get;set;} //US2884153
    }
    
    public class ParentGroup {          //New
        public String id{get;set;}      //New
        public String name{get;set;}    //New
    }
	//US2884153 Start
     public class MigrationSourceSystem {          
        public String id{get;set;}      
        public String name{get;set;}    
    }
    //US2884153 End
    public class GroupLevelHold {                           //New
        public String groupHoldCode{get;set;}               //New
        public String groupHoldShortDescription{get;set;}   //New
        public String groupHoldEffectiveDates{get;set;}     //New
        public String groupHoldExpirationDates{get;set;}    //New
        public String groupHoldCreatedByUserId{get;set;}    //New
        public String groupHoldTransactionDate{get;set;}    //New
    }

    public class EmployeeCounts {
        public String employeeCountDescription{get;set;}
        public String employeeCount{get;set;}
        public String reportingYear{get;set;}       //New
        public String transactionDate{get;set;}     //New   
    }

    public class CobAttestation {                                       //New
        public String cobAttestationFrequency{get;set;}                 //New
        public String cobAttestationDuration{get;set;}                  //New
        public String cobAttestationDenyGracePeriod{get;set;}           //New
        public String cobAttestationDenyGracePeriodDuration{get;set;}   //New
        public String religiousExemptionTypeDescription{get;set;}
        public String effectiveDate{get;set;}                           //New
        public String expirationDate{get;set;}                          //New
    }
    
    public class GroupAddress {
        public String addressTypeCode{get;set;}
        public String addressTypeDescription{get;set;}
        public String addressLine1{get;set;}
        public String addressLine2{get;set;}
        public String addressLine3{get;set;}
        public String addressCity{get;set;}
        public String addressPostalCode{get;set;}
        public String addressStateCode{get;set;}
        public String addressCountryCode{get;set;}
        public String addressCountryDescription{get;set;}
        public String salesOfficeCode{get;set;}
        public String salesOfficeDescription{get;set;}
        public String effectiveDate{get;set;}           //New
        public String expirationDate{get;set;}          //New
        public List<Phone> phone{get;set;}
    }

    public class Phone {
    		public String phonePrimaryIndicator{get;set;}
        public String phoneType{get;set;}
        public String phoneTypeDescription{get;set;}
        public String telephoneNumber{get;set;}
        public String phoneExtension{get;set;}
    }


    public class GroupContact {
        public String roleType{get;set;}
        public String roleDescription{get;set;}
        public String primaryIndicatorCode{get;set;}
        public String primaryIndicatorDescription{get;set;}
        public String organizationName{get;set;}        //New
        public String firstName{get;set;}
        public String lastName{get;set;}
        public String middleName{get;set;}
        public String nameSuffix{get;set;}
        public String startDate{get;set;}
        public String endDate{get;set;}
        public String assignmentStartDate{get;set;}
        public String assignmentEndDate{get;set;}
        public List<Phone> phone{get;set;}
        public List<Email> email{get;set;}
        public List<Address> address{get;set;}
    }
    
    public class Email {
        public String communicationTypeCode{get;set;}
        public String electronicAddress{get;set;}
    }

    public class Address {
        public String addressTypeCode{get;set;}
        public String addressTypeDescription{get;set;}
        public String addressLine1{get;set;}
        public String addressLine2{get;set;}
        public String addressLine3{get;set;}
        public String addressCity{get;set;}
        public String addressPostalCode{get;set;}
        public String addressStateCode{get;set;}
        public String addressCountryCode{get;set;}
        public String addressCountryDescription{get;set;}
    }

    public class GroupSupportTeamContact {
        public String serviceTeam{get;set;}
        public String roleType{get;set;}
        public String roleDescription{get;set;}
        public String firstName{get;set;}
        public String lastName{get;set;}
        public String middleName{get;set;}
        public String nameSuffix{get;set;}
        public String startDate{get;set;}
        public String endDate{get;set;}
        public List<Phone> phone{get;set;}
        public List<Email> email{get;set;}
    }
    //getemp V3 starts
    public class GroupInsuringRules {                                   //New
        public String cobraAdministrativeIndicator{get;set;}            //Changed
        public String continuationResponsibilityType{get;set;}          //New
        public String insuranceContinuationType{get;set;}               //New
        public String onshoreRestriction{get;set;}                      //Changed
        public String insuringRulesEffectiveDates{get;set;}             //New
        public String insuringRulesExpirationDates{get;set;}            //New
        public String pcpRadomization{get;set;}                         //New
        public String survivingSpouseIndicator{get;set;}                //New
        public String newBornAutoAddIndicator{get;set;}                 //New
        public String countNewbornForCoverageLevelCodeIndicator{get;set;}   //New
        public String classesCode{get;set;}                             //New
        public String earlyRetirementIndicator{get;set;}
        public String earlyRetirementMinimumAge{get;set;}
        public String workingRetirementIndicator{get;set;}
        public String workingRetirementMinimumAge{get;set;}
    }
    //getemp V3 ends


    public class GroupPopulation {
        public String classesCode{get;set;}
        public String classesDescription{get;set;}
        public String populationEnrollmentType{get;set;}          // New
    }

    //getemp V3 starts
    public class CustomerAccount {
     		public String statusCode{get;set;} //not in use
        public String statusDescription{get;set;} //not in use 
        public String startDate{get;set;} //not in use
        public String renewalDate{get;set;} //not in use
        public String terminationReasonCode{get;set;} //not in use
        public String terminationReasonDescription{get;set;} //not in use
        public List<CustomerAccountInsuringRules> customerAccountInsuringRules{get;set;} //not in use
        public List<CustomerPurchase> customerPurchase{get;set;} //not in use
        public String planBillingGroupNumber{get;set;}
        public String originalContractDate{get;set;}        //New
        public String migrationIndicator{get;set;}          //New
        public ParentGroup migrationSourceSystem{get;set;}  //New
        public List<CustomerAccountOption> customerAccountOption{get;set;}   //New
    }

    public class CustomerAccountOption {                            //New
        public String customerAccountOptionId{get;set;}             //New
        public String customerAccountOptionDescription{get;set;}    //New
        public String customerAccountOptionType{get;set;}           //New
        public String statusCode{get;set;}                          //Changed
        public String statusDescription{get;set;}                   //Changed
        public String startDate{get;set;}                           //Changed
        public String renewalDate{get;set;}                         //Changed
        public String terminationDate{get;set;}                     //Changed
        public String terminationReasonCode{get;set;}               //Changed
        public String terminationReasonDescription{get;set;}        //Changed
        public String stateOfIssueCode{get;set;}                    //New
        public String stateOfIssueDescription{get;set;}             //New
        public String exchangeTypeDescription{get;set;}        
        
        public String openEnrollmentStartDate{get;set;}             //New
        public String openEnrollmentEndDate{get;set;}               //New
        public String enrollmentInsuringRulesPopulationIndicator{get;set;} //New
        public String defineOpenEnrollmentbyPopulationIndicator{get;set;}  //New
        public List<CustomerAccountGroupPopulation> customerAccountGroupPopulation{get;set;} //New
        public List<CustomerAccountInsuringRules> customerAccountInsuringRules{get;set;}
        public List<CustomerPurchase> customerPurchase{get;set;}
        public List<StatusHistory> statusHistory{get;set;}          //New
    }

    public class CustomerAccountGroupPopulation {           //New
        public String classesCode{get;set;}                 //New
        public String classesDescription{get;set;}          //New
        public String populationOpenEnrollmentStartDate{get;set;}   //New
        public String populationOpenEnrollmentEndDate{get;set;} //New
    }


    public class CustomerPurchase {
        public String memberGroupContractPlanOptionID{get;set;}
        public String stateOfIssueCode{get;set;} //not in use
        public String stateOfIssueDescription{get;set;} //not in use
        public String fundingArrangementCode{get;set;}
        public String fundingArrangementDescription{get;set;}
        public String coverageStartDate{get;set;}
        public String coverageExpirationDate{get;set;}
        public String benefitBundleOptionID{get;set;}
        public String openEnrollmentStartDate{get;set;} //not in use
        public String openEnrollmentEndDate{get;set;} //not in use
        public String timePeriodQualifier{get;set;}
        public String benefitBasePlan{get;set;}
        public String benefitPlanDescription{get;set;}
        public String gatedProductIndicator{get;set;}
        public String planMetallicLevel{get;set;}
        public List<LineOfBusiness> lineOfBusiness{get;set;}
        public String hsaVendorId{get;set;}
        public String hsaVendorName{get;set;}
        public List<String> networkScheduleId{get;set;}
        public String domesticPartnerIndicator{get;set;}        // New
        public String benefitServiceArea{get;set;}               // New
        public List<BillingSchedule> billingSchedule{get;set;}
        public String bookOfBusinessTypeDescription{get;set;} //US3584878
        public String bookOfBusinessTypeCode{get;set;} //US3584878
    }

    public class LineOfBusiness {
        public String name{get;set;}
        public String description{get;set;}
    }


    public class BillingSchedule {
        public String ratingMethodology{get;set;}
        public String contractTypeCode{get;set;}
        public String contractTypeDescription{get;set;}
        public String amount{get;set;}
        public String genderLimit{get;set;}
        public String ageBandFromValue{get;set;}
        public String ageBandToValue{get;set;}
    }


    public class StatusHistory {                // New
        public String statusCode{get;set;}      // New
        public String statusDescription{get;set;}       // New
        public String effectiveDate{get;set;}       // New
        public String transactionDate{get;set;}     // New
        public String transactionUserId{get;set;}       // New
    }
    
    public class CustomerAccountInsuringRules {                         // New
        public String dependentCutOff{get;set;}                         // New
        public String dependentCutOffType{get;set;}                     // New
        public String studentMaximumAge{get;set;}                       // New
        public String studentmaximumAgeType{get;set;}                   // New
        public String waiveRehiredIndefiniteIndicator{get;set;}         // New
        public String waiveWaitingPeriodForNewHireIndicator{get;set;}   // New
        public String waiveRehiredWithinCount{get;set;}                 // New
        public String waiveRehiredWithinType{get;set;}                  // New
        public String terminationLagType{get;set;}                      // New
        public String terminationLagDescription{get;set;}               // New
        public String overrideRetroBenefitAddIndicator{get;set;}        // New
        public String overrideRetroBenefitAddDays{get;set;}             // New
        public String overrideRetroBenefitChangeIndicator{get;set;}     // New
        public String overrideRetroBenefitChangeDays{get;set;}          // New
        public String overrideRetroBenefitTerminationIndicator{get;set;}// New
        public String overrideRetroBenefitTerminationDays{get;set;}     // New
        public String insuringRuleEffectiveDates{get;set;}              // New
        public String insuringRuleExpirationDates{get;set;}             // New
        public String nonStandardWaitingPeriodIndicator{get;set;}       // New
        public String nonStandardWaitingPeriodValue{get;set;}           // New
        public List<WaitingPeriodRules> waitingPeriodRules{get;set;}    // New
        public String classesCode{get;set;}                             // New
        public String classesDescription{get;set;}                      // New
    }

    public class WaitingPeriodRules {                   // New
        public String waitingPeriodType{get;set;}       // New
        public String waitingDurationType{get;set;}     // New
        public String waitingDurationValue{get;set;}    // New
        public String orientationDurationType{get;set;} // New
        public String orientationDurationValue{get;set;}// New
        public String qualifyingEvent{get;set;}         // New
    }
    //getemp V3 ends
    
}