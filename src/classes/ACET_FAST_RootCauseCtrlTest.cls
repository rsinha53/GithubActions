/*****************************************************************************************************
ACET_FAST_RootCauseCtrlTest
Testing Class Name:  ACET_FAST_RootCauseCtrl
Author: Shaik Mohammad Yaseen
Date: 09/05/2021
Description: This is test class and used to get test coverage for ACET_FAST_RootCauseCtrl. 
Initial: Shaik Mohammad Yaseen
******************************************************************************************************/
@isTest(SeeAllData=false)
public class ACET_FAST_RootCauseCtrlTest {
    public static testMethod void testCaseItemTrig(){
        Profile sysAdminPrf = ACET_Fast_TestDataFactory.getSysAdminPrf();
        user sysAdminUser = ACET_Fast_TestDataFactory.getUserRecord(sysAdminPrf.id);
        insert sysAdminUser;
        System.runAs(sysAdminUser){
            case caseRec = ACET_Fast_TestDataFactory.getCaseRecord('Reactive_Resolution','Open');
            insert caseRec;
            
            Case_Item__c cItem = new Case_Item__c(case__c=caseRec.Id);
            insert cItem;
            
            PIR_Root_Cause_Case_Item__c rcCaseItem = new PIR_Root_Cause_Case_Item__c(Case_Item__c=cItem.Id);
            insert rcCaseItem;
            
            PIR_Root_Cause__c rootCause1 = new PIR_Root_Cause__c(Level__c=1,Name='test1',Root_Cause_Key__c='test1code', Active__c=true);
            insert rootCause1;
            
            PIR_Root_Cause__c rootCause2 = new PIR_Root_Cause__c(Level__c=2,Name='test2',Root_Cause_Key__c='test2code', Active__c=true, Parent_Root_Cause__c=rootCause1.id);
            insert rootCause2;
            
            PIR_Root_Cause__c rootCause3 = new PIR_Root_Cause__c(Level__c=3,Name='test3',Root_Cause_Key__c='test3code', Active__c=true, Parent_Root_Cause__c=rootCause2.id);
            insert rootCause3;
            
            PIR_Root_Cause__c rootCause4 = new PIR_Root_Cause__c(Level__c=4,Name='test4',Root_Cause_Key__c='test4code', Active__c=true, Parent_Root_Cause__c=rootCause3.id);
            insert rootCause4;
            
            PIR_Root_Cause__c rootCause5 = new PIR_Root_Cause__c(Level__c=5,Name='test5',Root_Cause_Key__c='test5code', Active__c=true, Parent_Root_Cause__c=rootCause4.id);
            insert rootCause5;
            
            ACET_FAST_RootCauseCtrl.PIRWrapper pWrap = ACET_FAST_RootCauseCtrl.getRootCauseValues(cItem.Id);
            pWrap.rootCause1='test1';
            pWrap.rootCause1='test1code';
            pWrap.rootCause1='test2';
            pWrap.rootCause1='test2code';
            pWrap.rootCause1='test3';
            pWrap.rootCause1='test3code';
            pWrap.rootCause1='test4';
            pWrap.rootCause1='test4code';
            pWrap.rootCause1='test5';
            pWrap.rootCause1='test5code';
            string wrapStr = JSON.serialize(pWrap);
            ACET_FAST_RootCauseCtrl.saveRootCause(wrapStr,cItem.Id);
            ACET_FAST_RootCauseCtrl.getrootCause2List('test1code');
            ACET_FAST_RootCauseCtrl.getrootCause3List('test2code');
            ACET_FAST_RootCauseCtrl.getrootCause4List('test3code');
            ACET_FAST_RootCauseCtrl.getrootCause5List('test4code');
        }
    }
}