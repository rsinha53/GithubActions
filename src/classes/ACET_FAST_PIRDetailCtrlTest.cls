/*****************************************************************************************************
ACET_FAST_PIRDetailCtrlTest
Testing Class Name:  ACET_FAST_PIRDetailCtrl
Author: Shaik Mohammad Yaseen
Date: 11/06/2020
Description: This is test class and used to get test coverage for ACET_FAST_PIRDetailCtrl. 
Initial: Shaik Mohammad Yaseen
******************************************************************************************************/
@isTest(SeeAllData=false)
public class ACET_FAST_PIRDetailCtrlTest {
    public static testMethod void testNotaValidFastUser(){
        Profile sysAdminPrf = ACET_Fast_TestDataFactory.getSysAdminPrf();
        user sysAdminUser = ACET_Fast_TestDataFactory.getUserRecord(sysAdminPrf.id);
        insert sysAdminUser;
        System.runAs(sysAdminUser){
            case caseRec = ACET_Fast_TestDataFactory.getCaseRecord('Reactive_Resolution','Open');
            insert caseRec;
            ACET_FAST_PIRDetailCtrl.getCaseRecord(caseRec.id);
            PIR_Detail__c pirRec = new PIR_Detail__c();
            pirRec = ACET_Fast_TestDataFactory.getPIRRec(caseRec.Id);
            insert pirRec;
            ACET_FAST_PIRDetailCtrl.getPIRRecId(caseRec.id);
            ACET_FAST_PIRDetailCtrl.getPIRRec(pirRec.id);
            ACET_FAST_PIRDetailCtrl.getUserDetails();
            
            //root cause
            PIR_Root_Cause__c rc1 = new PIR_Root_Cause__c(name='RC1', Active__c=true, Description__c='rc1 desc',Level__c=1, Root_Cause_Key__c='RC-1');
            insert rc1;
            PIR_Root_Cause__c rc2 = new PIR_Root_Cause__c(name='RC2', Active__c=true, Description__c='rc2 desc',Level__c=2, Root_Cause_Key__c='RC-2', Parent_Root_Cause__c=rc1.id);
            insert rc2;
            PIR_Root_Cause__c rc3 = new PIR_Root_Cause__c(name='RC3', Active__c=true, Description__c='rc3 desc',Level__c=3, Root_Cause_Key__c='RC-3', Parent_Root_Cause__c=rc2.id);
            insert rc3;
            PIR_Root_Cause__c rc4 = new PIR_Root_Cause__c(name='RC4', Active__c=true, Description__c='rc4 desc',Level__c=4, Root_Cause_Key__c='RC-4', Parent_Root_Cause__c=rc3.id);
            insert rc4;
            PIR_Root_Cause__c rc5 = new PIR_Root_Cause__c(name='RC5', Active__c=true, Description__c='rc5 desc',Level__c=5, Root_Cause_Key__c='RC-5', Parent_Root_Cause__c=rc4.id);
            insert rc5;
            ACET_FAST_PIRDetailCtrl.getrootCause1List();
            ACET_FAST_PIRDetailCtrl.getrootCause2List(rc1.Root_Cause_Key__c);
            ACET_FAST_PIRDetailCtrl.getrootCause3List(rc2.Root_Cause_Key__c);
            ACET_FAST_PIRDetailCtrl.getrootCause4List(rc3.Root_Cause_Key__c);
            ACET_FAST_PIRDetailCtrl.getrootCause5List(rc4.Root_Cause_Key__c);
            
        }
    }
}