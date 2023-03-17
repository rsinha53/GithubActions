/*****************************************************************************************************
ACET_FAST_RootCauseUtilityTest
Testing Class Name:  ACET_FAST_RootCauseUtility
Author: Shaik Mohammad Yaseen
Date: 13/05/2021
Description: This is test class and used to get test coverage for ACET_FAST_RootCauseUtility. 
Initial: Shaik Mohammad Yaseen
******************************************************************************************************/
@isTest(SeeAllData=false)
public class ACET_FAST_RootCauseUtilityTest {
    public static testMethod void testRootCauseUtil(){
        Profile sysAdminPrf = ACET_Fast_TestDataFactory.getSysAdminPrf();
        user sysAdminUser = ACET_Fast_TestDataFactory.getUserRecord(sysAdminPrf.id);
        insert sysAdminUser;
        System.runAs(sysAdminUser){ 
            case caseRec = ACET_Fast_TestDataFactory.getCaseRecord('Reactive_Resolution','Open');
            insert caseRec;
            
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
            
            ACET_FAST_RootCauseUtility.jsonWrap wrapVar = new ACET_FAST_RootCauseUtility.jsonWrap();
            wrapVar.rc1='test1';
            wrapVar.rc1KeyCode= 'test1code';
            wrapVar.rc2='test2';
            wrapVar.rc2KeyCode= 'test2code';
            wrapVar.rc3='test3';
            wrapVar.rc3KeyCode= 'test3code';
            wrapVar.rc4='test4';
            wrapVar.rc4KeyCode= 'test4code';
            wrapVar.rc5='test5';
            wrapVar.rc5KeyCode= 'test5code';
            string wrapStr = JSON.serialize(wrapVar);
            
            ACET_FAST_RootCauseUtility.getRootCauseWrapper(wrapStr);
        }
    }
}