/*****************************************************************************************************
ACET_FAST_TeamMemNoOpenTaskCasesCtrlTest
Testing Class Name:  ACET_FAST_TeamMemNoOpenTaskCasesCtrl
Author: Shaik Mohammad Yaseen
Date: 01/18/2021
Description: This is test class and used to get test coverage for ACET_FAST_TeamMemNoOpenTaskCasesCtrl. 
Initial: Shaik Mohammad Yaseen
******************************************************************************************************/
@isTest(SeeAllData=false) 
public class ACET_FAST_TeamMemNoOpenTaskCasesCtrlTest {
    public static testMethod void testNotaValidFastUser(){
        Profile sysAdminPrf = ACET_Fast_TestDataFactory.getSysAdminPrf();
        
        UserRole supRole = [SELECT id FROM UserRole WHERE DeveloperName = 'PIR_Reactive_Proactive_Supervisor'];
        
        user sysAdminUser = ACET_Fast_TestDataFactory.getUserRecordWithRole(sysAdminPrf.id,supRole.id);
        insert sysAdminUser;
        
        user sysAdminUser1 = ACET_Fast_TestDataFactory.getUserRecord(sysAdminPrf.id);
        sysAdminUser1.ManagerId=sysAdminUser.id;
        sysAdminUser1.Email='test@124.com';
        sysAdminUser1.UserName='test@124.com.dev';
        insert sysAdminUser1;
        
        System.runAs(sysAdminUser){
            case caseRec = ACET_Fast_TestDataFactory.getCaseRecord('Reactive_Resolution','Open');
            insert caseRec;
            
            caseRec.ownerId = sysAdminUser1.id;
            update caseRec;
            
            ACET_FAST_TeamMemNoOpenTaskCasesCtrl.getOpenTaskCases('Reactive Resolution');
        }
    }
}