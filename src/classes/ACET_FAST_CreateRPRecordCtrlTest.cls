/*****************************************************************************************************
ACET_FAST_CreateRPRecordCtrlTest
Testing Class Name:  ACET_FAST_CreateRPRecordCtrl
Author: Shaik Mohammad Yaseen
Date: 12/03/2021
Description: This is test class and used to get test coverage for ACET_FAST_CreateRPRecordCtrl. 
Initial: Shaik Mohammad Yaseen
******************************************************************************************************/
@isTest
public class ACET_FAST_CreateRPRecordCtrlTest {
    public static testMethod void pMatrixDetailTest(){
        Profile sysAdminPrf = ACET_Fast_TestDataFactory.getSysAdminPrf();
        user sysAdminUser = ACET_Fast_TestDataFactory.getUserRecord(sysAdminPrf.id);
        insert sysAdminUser;
        System.runAs(sysAdminUser){
            
            Provider_Matrix__c pmRec = new Provider_Matrix__c();
            pmRec.Name = 'Test RP';
            pmRec.Resolution_Partner_SLA__c = 20;
            insert pmRec;
            
            PIR_Resolution_Partner__c partner = new PIR_Resolution_Partner__c(Provider_Matrix_Proactive__c=pmRec.Id);
            insert partner;
            ACET_FAST_CreateRPRecordCtrl.getRPNameId(partner.id);
        }
    }
}