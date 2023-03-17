/*****************************************************************************************************
ACET_FAST_CasePrmsnFldVldtnHelperTest
Testing Class Name:  ACET_FAST_CasePrmsnFldVldtnHelper
Author: Shaik Mohammad Yaseen
Date: 11/10/2020
Description: This is test class and used to get test coverage for ACET_FAST_CasePrmsnFldVldtnHelper. 
Initial: Shaik Mohammad Yaseen
******************************************************************************************************/
@isTest(SeeAllData=false)
public class ACET_FAST_CasePrmsnFldVldtnHelperTest {
    
    public static final String IMPACT_SYSTEM = 'Impact System';
    
   @testSetup static void testSetupMethod() {
        case caseRec = ACET_Fast_TestDataFactory.getCaseRecord('Reactive_Resolution','Open');
        insert caseRec;
        
        case pipCaseRec = ACET_Fast_TestDataFactory.getCaseRecord('Proactive_Action','Open');
        insert pipCaseRec;
       ACET_FAST_CasePrmsnFldVldtnHelper.validateProviderContactFields(pipCaseRec);
           PIR_Detail__c pirRec = new PIR_Detail__c();
           pirRec = ACET_Fast_TestDataFactory.getPIRRec(pipCaseRec.Id);
       		
           insert pirRec;
       PIR_Detail__c pirObj = [SELECT Id, Case__c, Case__r.CaseNumber, Case__r.Id, Case__r.RecordType.Name, Substatus__c, 
Data_Analysis__c, Measurement_System__c, Queries__c, Root_Cause_1_Key_Code__c, Root_Cause_1__c, 
Root_Cause_2_Key_Code__c, Root_Cause_2__c,Root_Cause_3_Key_Code__c, Root_Cause_3__c, 
Root_Cause_4_Key_Code__c, Root_Cause_4__c, Root_Cause_5_Key_Code__c, Root_Cause_5__c, 
Sources_of_Data__c,Provider_Was_contacted__c, Closure_Sub_Status__c,Submitter_to_Contact_Provider_at_Closure__c, 
Will_this_be_closed_in_Practice_Mgmt__c,Issue_Category__c, Issue_Subcategory__c FROM PIR_Detail__c WHERE id=:pirRec.Id];
       
       	ACET_FAST_CasePrmsnFldVldtnHelper.validateProActiviePIRDetails(pirRec);
       ACET_FAST_CasePrmsnFldVldtnHelper.validateReactivePIRDetails(pirRec);
       ACET_FAST_CasePrmsnFldVldtnHelper.validatePIRDetailsToClose(pirObj);
        pipCaseRec.Status = 'closed';
        update pipCaseRec;
       
       string personAccRecordTypeID = ACET_Fast_ProviderContactCtrl.getRecordTypeIdbyDevName('Account','PersonAccount');        
        Account personAcc = new Account(FirstName ='Test', LastName ='TestProvider',RecordTypeId = personAccRecordTypeID, Tax_Id__c='111111111', EID__c='111111111');
        insert personAcc;
    }
    public static testMethod void testValidUser(){
        List<case> caseList = new List<case>();
        caseList=[SELECT id, PC_Provider_TIN__c, Origin, FAST_PIP_Markets__c, Subject, Description, PC_Internal_Contact_Name__c,
                  PC_Internal_Contact_Phone__c, PC_Internal_Contact_Email__c, Submitting_Department__c, Original_Received_Date__c
                  FROM Case];
        if(caseList.size()>0){
            case cVar = new case();
            cVar = caseList[0];
            cVar.PC_Provider_TIN__c=null;
            cVar.Origin=null;
            cVar.FAST_PIP_Markets__c=null;
            cVar.Subject=null;
            cVar.Description=null;
            cVar.PC_Internal_Contact_Name__c=null;
            cVar.PC_Internal_Contact_Phone__c=null;
            cVar.PC_Internal_Contact_Email__c=null;
            cVar.Submitting_Department__c=null;
            cVar.Original_Received_Date__c=null;
            try{
                update cVar;
            }catch(exception ex){
                system.debug('error occored '+ex.getMessage());
            }
        }
    }
    public static testMethod void testValidUser1(){
        List<case> caseList = new List<case>();
        caseList=[SELECT id, PC_Provider_TIN__c, Origin, FAST_PIP_Markets__c, Subject, Description, PC_Internal_Contact_Name__c,
                  PC_Internal_Contact_Phone__c, PC_Internal_Contact_Email__c, Submitting_Department__c, Original_Received_Date__c,
                  PC_External_Contact_Name__c,PC_External_Contact_Phone__c, PC_External_Contact_Email__c,RecordTypeId
                  FROM Case];
        if(caseList.size()>0){
            case cVar = new case();
            cVar = caseList[0];
            cVar.PC_Provider_TIN__c=null;
            cVar.Origin=null;
            cVar.FAST_PIP_Markets__c=null;
            cVar.Subject=null;
            cVar.Description=null;
            cVar.PC_Internal_Contact_Name__c='test';
            cVar.PC_Internal_Contact_Phone__c='9042056694';
            cVar.PC_Internal_Contact_Email__c='test@123.com';
            cVar.Submitting_Department__c='Appeals';
            cVar.Original_Received_Date__c=system.today();
            cVar.PC_External_Contact_Name__c =null;
            cVar.PC_External_Contact_Phone__c =null;
            cVar.PC_External_Contact_Email__c =null;
            ACET_FAST_CasePrmsnFldVldtnHelper.validateExternalContactFields(cVar);
        }
    }
    public static testMethod void testNotaValidUser(){
        List<case> caseList = new List<case>();
        caseList=[SELECT id, PC_Provider_TIN__c, Origin, FAST_PIP_Markets__c, Subject, Description, PC_Internal_Contact_Name__c,
                  PC_Internal_Contact_Phone__c, PC_Internal_Contact_Email__c, Submitting_Department__c, Original_Received_Date__c
                  FROM Case];
        Profile sysAdminPrf = ACET_Fast_TestDataFactory.getSysAdminPrf();
        user sysAdminUser = ACET_Fast_TestDataFactory.getUserRecord(sysAdminPrf.id);
        insert sysAdminUser;
        System.runAs(sysAdminUser){
            if(caseList.size()>0){
                case cVar = new case();
                cVar = caseList[0];
                cVar.PC_Provider_TIN__c=null;
                try{
                    update cVar;
                }catch(exception ex){
                    system.debug('error occored'+ex.getMessage());
                }
            }
        }
    }
    
    public static testMethod void caseValidation(){
        case caseRec = ACET_Fast_TestDataFactory.getCaseRecord('Reactive_Resolution','closed');
        insert caseRec;
    }
        
    public static testMethod void createThirdPartyRec1(){
        List<case> caseRec = new List<case>();
        case caseRe = ACET_Fast_TestDataFactory.getCaseRecord('Reactive_Resolution','New');        
        caseRe.PC_Provider_TIN__c ='111111111';
        caseRe.Origin =IMPACT_SYSTEM;
        caseRec.add(caseRe);
        insert caseRec;
        
        ACET_FAST_CasePrmsnFldVldtnHelper.AccountNameUpdate(caseRec);
    }
    
    public static testMethod void createThirdPartyRec2(){
        List<case> caseRec = new List<case>();
        case caseRe = ACET_Fast_TestDataFactory.getCaseRecord('Reactive_Resolution','New');        
        caseRe.PC_Provider_TIN__c ='';
        caseRe.Origin =IMPACT_SYSTEM;
        caseRec.add(caseRe);
        insert caseRec;
        
        ACET_FAST_CasePrmsnFldVldtnHelper.AccountNameUpdate(caseRec);
    }
    
        public static testMethod void testTriageButton(){
       case  cas=ACET_Fast_TestDataFactory.getCaseRecord('Reactive_Resolution', 'New');
         insert cas;
     case updateCase=[select id,Status,CPU_Processing_Status__c,Interaction__c,
                      PC_Internal_Contact_Name__c,PC_Internal_Contact_Phone__c,
                      Submitting_Department__c,PC_Internal_Contact_Email__c,
                      Original_Received_Date__c from Case where id=:cas.id];
          updateCase.CPU_Processing_Status__c='Case Items Partially Enriched';
          updateCase.origin =IMPACT_SYSTEM;
          updateCase.status = 'Closed';
          updateCase.PC_Internal_Contact_Name__c = '';
          updateCase.PC_Internal_Contact_Phone__c = '';
          updateCase.Submitting_Department__c = '';
          updateCase.PC_Internal_Contact_Email__c = '';
          update updateCase;
            ACET_FAST_TriageCmpCtrl.getCaseRecord(updateCase.id);
    PublishResult__c pr = new PublishResult__c(ReplayId__c = 1234, 
                                               EventUid__c = updateCase.id, 
                                               CPU_Processing_Status__c = updateCase.CPU_Processing_Status__c,
                                               InteractionId__c = updateCase.Interaction__c);
            insert pr;
 
        Test.startTest();        
             ACET_FAST_TriageCmpCtrl.publishPFEvent(updateCase);
             ACET_FAST_CasePrmsnFldVldtnHelper.validateProviderContactFields(updateCase);
        Test.stopTest();     
            
    }


}