/*****************************************************************************************************
ACET_FAST_UtilityTest
Testing Class Name:  ACET_FAST_Utility
Author: Shaik Mohammad Yaseen
Date: 10/30/2020
Description: This is test class and used to get test coverage for ACET_FAST_Utility. 
Initial: Shaik Mohammad Yaseen
******************************************************************************************************/
@isTest(SeeAllData=false)
public class ACET_FAST_UtilityTest {
    public static testMethod void utilityTestMethod(){
        Profile sysAdminPrf = ACET_Fast_TestDataFactory.getSysAdminPrf();
        UserRole opoRole = ACET_Fast_TestDataFactory.getRole('OPO PIR');
        user sysAdminUser = ACET_Fast_TestDataFactory.getUserRecordWithRole(sysAdminPrf.id,opoRole.Id);
        insert sysAdminUser;
        System.runAs(sysAdminUser){
            case caseRec = ACET_Fast_TestDataFactory.getCaseRecord('Reactive_Resolution','Open');
            insert caseRec;
            ACET_FAST_Utility.getLoggedInUserRole();
            ACET_FAST_Utility.getObjectName(sysAdminUser.id);
            ACET_FAST_Utility.getRecord('case',new set<id>{caseRec.id});
            ACET_FAST_Utility.getPiklistValues('Case','Type__c');
        }
    }
}