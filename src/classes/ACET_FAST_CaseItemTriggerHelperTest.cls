/*****************************************************************************************************
ACET_FAST_CaseItemTriggerHelperTest
Testing Class Name:  ACET_FAST_CaseItemTriggerHelper
Author: Shaik Mohammad Yaseen
Date: 09/05/2021
Description: This is test class and used to get test coverage for ACET_FAST_CaseItemTriggerHelper. 
Initial: Shaik Mohammad Yaseen
******************************************************************************************************/
@isTest(SeeAllData=false)
public class ACET_FAST_CaseItemTriggerHelperTest {
    public static testMethod void testCaseItemTrig(){
        Profile sysAdminPrf = ACET_Fast_TestDataFactory.getSysAdminPrf();
        User thisUser = [Select Id From User Where Id =:UserInfo.getUserId()];
        user sysAdminUser;
        System.runAs(thisUser){
            sysAdminUser = ACET_Fast_TestDataFactory.getUserRecord(sysAdminPrf.id);
            insert sysAdminUser;
        }
        case caseRec = ACET_Fast_TestDataFactory.getCaseRecord('Reactive_Resolution','Open');
        insert caseRec;
        Id recordTypeId =Schema.SObjectType.Case_Item__c.getRecordTypeInfosByDeveloperName().get('PIR_Case_Items').getRecordTypeId();
        System.runAs(sysAdminUser){
            Case_Item__c cItem = new Case_Item__c(Case__c=caseRec.Id);
            citem.RecordTypeId = recordTypeId;
            cItem.ExternalID__c = '121221i2121';
            cItem.Member_Number__c = 'Test';
            cItem.Status__c='New';
            insert cItem;
            
            try{
                cItem.Status__c='Resolved';
                cItem.Claim_Outcome_Status__c = 'Claim Adjusted';
                cItem.Advocate_Comments__c= 'Test comments for feed';
                
                PIR_Root_Cause_Case_Item__c rcItem = new PIR_Root_Cause_Case_Item__c(Root_Cause_1__c='test1',
                                                                                     Root_Cause_1_Key_Code__c='test1code',
                                                                                     Root_Cause_2__c='test2',
                                                                                     Root_Cause_2_Key_Code__c='test2code',
                                                                                     Root_Cause_3__c='test3',
                                                                                     Root_Cause_3_Key_Code__c='test3code',
                                                                                     Root_Cause_4__c='test4',
                                                                                     Root_Cause_4_Key_Code__c='test4code',
                                                                                     Root_Cause_5__c='test5',
                                                                                     Root_Cause_5_Key_Code__c='test5code',
                                                                                     Case_Item__c=cItem.Id);
                PIR_Root_Cause_Case_Item__c rcItem2 = new PIR_Root_Cause_Case_Item__c(Root_Cause_1__c='test1',
                                                                                      Root_Cause_1_Key_Code__c='test1code',
                                                                                      Root_Cause_2__c='test2',
                                                                                      Root_Cause_2_Key_Code__c='test2code',
                                                                                      Root_Cause_3__c='test3',
                                                                                      Root_Cause_3_Key_Code__c='test3code',
                                                                                      Root_Cause_4__c='test4',
                                                                                      Root_Cause_4_Key_Code__c='test4code',
                                                                                      Root_Cause_5__c='test5',
                                                                                      Case_Item__c=cItem.Id);
                insert rcItem;
                insert rcItem2;
                update cItem;
            }
            catch(exception ex){
                system.debug('exception is '+ex.getMessage());
            }
        }
    }
    public static testMethod void testCaseItemTrig1(){
        Profile sysAdminPrf = ACET_Fast_TestDataFactory.getSysAdminPrf();
        User thisUser = [Select Id From User Where Id =:UserInfo.getUserId()];
        user sysAdminUser;
        System.runAs(thisUser){
            sysAdminUser = ACET_Fast_TestDataFactory.getUserRecord(sysAdminPrf.id);
            insert sysAdminUser;
        }
        case caseRec = ACET_Fast_TestDataFactory.getCaseRecord('Reactive_Resolution','Open');
        insert caseRec;
        System.runAs(sysAdminUser){
            Case_Item__c cItem = new Case_Item__c(Case__c=caseRec.Id);
            cItem.Advocate_Comments__c = 'test';
            insert cItem;
            
            try{
                PIR_Root_Cause_Case_Item__c rcItem = new PIR_Root_Cause_Case_Item__c(Root_Cause_1__c='test1',
                                                                                     Root_Cause_1_Key_Code__c='test1code',
                                                                                     Root_Cause_2__c='test2',
                                                                                     Root_Cause_2_Key_Code__c='test2code',
                                                                                     Root_Cause_3__c='test3',
                                                                                     Root_Cause_3_Key_Code__c='test3code',
                                                                                     Root_Cause_4__c='test4',
                                                                                     Root_Cause_4_Key_Code__c='test4code',
                                                                                     Root_Cause_5__c='test5',
                                                                                     Root_Cause_5_Key_Code__c='test5code',
                                                                                     Case_Item__c=cItem.Id);
                insert rcItem;
                cItem.Advocate_Comments__c = 'test2';
                update cItem;
            }
            catch(exception ex){
                system.debug('exception is '+ex.getMessage());
            }
        }
    }
}