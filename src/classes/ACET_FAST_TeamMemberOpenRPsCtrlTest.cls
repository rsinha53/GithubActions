/*****************************************************************************************************
ACET_FAST_TeamMemberOpenRPsCtrlTest
Testing Class Name:  ACET_FAST_TeamMemberOpenRPsCtrl
Author: Shaik Mohammad Yaseen
Date: 01/18/2021
Description: This is test class and used to get test coverage for ACET_FAST_TeamMemberOpenRPsCtrl. 
Initial: Shaik Mohammad Yaseen
******************************************************************************************************/
@isTest(SeeAllData=false)
public class ACET_FAST_TeamMemberOpenRPsCtrlTest {
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
            
            Provider_Matrix__c pMatrix = new Provider_Matrix__c(CrossWalk_Case_RPI__c='test');
            insert pMatrix;
            
            Id recordTypeId = Schema.SObjectType.PIR_Resolution_Partner__c.getRecordTypeInfosByDeveloperName().get('Reactive_Resolution_Partners').getRecordTypeId();
            
            PIR_Resolution_Partner__c rp = new PIR_Resolution_Partner__c(Case__c=caseRec.Id,recordtypeId=recordTypeId,
                                                                         Provider_Matrix_Proactive__c=pMatrix.id,
                                                                         Resolution_Partner_Outcome__c='Open');
            insert rp;
            ACET_FAST_TeamMemberOpenRPsCtrl.getRPRecords('Reactive Resolution');
        }
    }
}