/*****************************************************************************************************
ACET_Fast_CaseTaskOwnerTrgHandlerTest
Testing Class Name:  ACET_Fast_CaseTaskOwnerTrgHandler, ECMTaskTrigger
Author: Shaik Mohammad Yaseen
Date: 10/29/2020
Description: This is test class and used to get test coverage for ACET_Fast_CaseTaskOwnerTrgHandler and
			  ECMTaskTrigger. 
Initial: Shaik Mohammad Yaseen
******************************************************************************************************/
@isTest(SeeAllData=false)
public class ACET_Fast_CaseTaskOwnerTrgHandlerTest {
    public static final String fastTaskRecordType = 'Reactive_Resolution_Proactive_Action';
     public static final String TASK_SUBJECT = 'Callback Needed';
    public static final String TASK_STATUS = 'Not Started';
    public static final String OPO_PIR = 'OPO PIR';
    
    public static testMethod void testNotaValidFastUser(){
        Profile sysAdminPrf = ACET_Fast_TestDataFactory.getSysAdminPrf();
        user sysAdminUser = ACET_Fast_TestDataFactory.getUserRecord(sysAdminPrf.id);
        insert sysAdminUser;
        System.runAs(sysAdminUser){
            case caseRec = ACET_Fast_TestDataFactory.getCaseRecord('Reactive_Resolution','Open');
            insert caseRec;
            
            task tsk = ACET_Fast_TestDataFactory.getTaskRecord(fastTaskRecordType, caseRec.id,TASK_SUBJECT,system.today(),TASK_STATUS,'Standard'); 
            try{
                ACET_FAST_CasePrmsnFldVldtnHelper.isFirstTime = true;
            	insert tsk;    
            }catch(exception ex){
                system.debug(ex.getMessage());
            }
        }
    }
    public static testMethod void testValidFastUserCaseOpen(){
        Profile sysAdminPrf = ACET_Fast_TestDataFactory.getSysAdminPrf();
        UserRole opoRole = ACET_Fast_TestDataFactory.getRole(OPO_PIR);
        user sysAdminUser = ACET_Fast_TestDataFactory.getUserRecordWithRole(sysAdminPrf.id,opoRole.Id);
        insert sysAdminUser;
        System.runAs(sysAdminUser){
            case caseRec = ACET_Fast_TestDataFactory.getCaseRecord('Reactive_Resolution','Open');
            insert caseRec;
            task tsk = ACET_Fast_TestDataFactory.getTaskRecord(fastTaskRecordType, caseRec.id,TASK_SUBJECT,system.today(),TASK_STATUS,'Standard'); 
            try{
                ACET_FAST_CasePrmsnFldVldtnHelper.isFirstTime = true;
            	insert tsk;    
            }catch(exception ex){
                system.debug(ex.getMessage());
            }
        }
    }
    public static testMethod void testValidFastUserCaseClosed(){
        Profile sysAdminPrf = ACET_Fast_TestDataFactory.getSysAdminPrf();
        UserRole opoRole = ACET_Fast_TestDataFactory.getRole(OPO_PIR);
        user sysAdminUser = ACET_Fast_TestDataFactory.getUserRecordWithRole(sysAdminPrf.id,opoRole.Id);
        insert sysAdminUser;
        System.runAs(sysAdminUser){
            case caseRec = ACET_Fast_TestDataFactory.getCaseRecord('Reactive_Resolution','Closed');
            insert caseRec;
            task tsk = ACET_Fast_TestDataFactory.getTaskRecord(fastTaskRecordType, caseRec.id,TASK_SUBJECT,system.today(),TASK_STATUS,'Standard'); 
            try{
                ACET_FAST_CasePrmsnFldVldtnHelper.isFirstTime = true;
            	insert tsk;    
            }catch(exception ex){
                system.debug(ex.getMessage());
            }
        }
    }
    public static testMethod void testValidFastUserCaseOpenpastDueDate(){
        Profile sysAdminPrf = ACET_Fast_TestDataFactory.getSysAdminPrf();
        UserRole opoRole = ACET_Fast_TestDataFactory.getRole(OPO_PIR);
        user sysAdminUser = ACET_Fast_TestDataFactory.getUserRecordWithRole(sysAdminPrf.id,opoRole.Id);
        insert sysAdminUser;
        System.runAs(sysAdminUser){
            case caseRec = ACET_Fast_TestDataFactory.getCaseRecord('Reactive_Resolution','Open');
            insert caseRec;
            task tsk = ACET_Fast_TestDataFactory.getTaskRecord(fastTaskRecordType, caseRec.id,TASK_SUBJECT,system.today()-1,TASK_STATUS,'Standard'); 
            try{
            	insert tsk;    
            }catch(exception ex){
                system.debug(ex.getMessage());
            }
        }
    }
}