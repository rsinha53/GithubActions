@isTest
public with sharing Class ACET_FAST_CommunityCaseCreateTest {
    
    static final String PIR_SUPPORT_PROFILE = 'System Administrator'; //'PIR Support Cases Profile'

    @testSetup static void setup() {
        string personAccRecordTypeID = ACET_Fast_ProviderContactCtrl.getRecordTypeIdbyDevName('Account','PersonAccount');        
        Account personAcc = new Account(FirstName ='Test', LastName ='TestProvider',RecordTypeId = personAccRecordTypeID, Tax_Id__c='061330992', EID__c='06133099212345');
        insert personAcc;
    }
    
    public static testmethod void testValidUserPIRCreateandEdit(){
        Profile supportUserProfile = ACET_Fast_TestDataFactory.getProfile(PIR_SUPPORT_PROFILE);      
        user fastUser = ACET_Fast_TestDataFactory.getUserRecord(supportUserProfile.id);
        insert fastUser;
        
        
        
        system.runAs(fastUser){
            case caseRec = ACET_Fast_TestDataFactory.getCaseRecord('Reactive_Resolution','Open');
            
            PIR_Detail__c pir = new PIR_Detail__c(Formal_Complaint_Filed__c='Yes',
                                                  Remark_Explanation_Code__c='test',Status__c='Open',
                                                  Issue_Category__c='First Time Visit',Issue_Subcategory__c='Additional Info Needed',
                                                  Interest_Bearing__c='No',Specialty_Team__c='Region V',
                                                  Region_V_Work_Type__c='Accounts Receivable',LA_C_S_Reason_for_Provider_Issue__c='Reimbursement Rates',
                                                  Claim_Type__c='NDC',
                                                  Submitter_to_Contact_Provider_at_Closure__c='Yes',Reason_for_Submission_Delay__c='Submitter PTO/Weekend/Holiday',
                                                  Provider_Contact__c='Test',Provider_Contact_Preference__c='Both',
                                                  Par_Provider__c='Yes',Claims_Overturned__c='Overturned',
                                                  Will_this_be_closed_in_Practice_Mgmt__c='Yes',Provider_Was_contacted__c='Submitter to Contact Provider',
                                                  Exact_Count_Unknown_Multiple_Claims__c=true, No_Reference_Facilitated_Referral__c=true);
            
            try{
              ACET_FAST_CommunityCaseCreate.recordSave(caseRec, pir, 'TestProvider') ;
               
            }catch(exception ex){
                system.debug(ex.getMessage());
            }
            
        }
        
    }
    
}