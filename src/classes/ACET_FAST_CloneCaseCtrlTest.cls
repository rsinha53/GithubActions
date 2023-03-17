/*****************************************************************************************************
ACET_FAST_CloneCaseCtrlTest
Testing Class Name:  ACET_FAST_CloneCaseCtrl
Author: Shaik Mohammad Yaseen
Date: 01/29/2020
Description: This is test class and used to get test coverage for ACET_FAST_CloneCaseCtrl. 
Initial: Shaik Mohammad Yaseen
******************************************************************************************************/
@isTest(SeeAllData=false)
public class ACET_FAST_CloneCaseCtrlTest {
    
    public static testMethod void testNotaValidFastUser(){
        Profile sysAdminPrf = ACET_Fast_TestDataFactory.getSysAdminPrf();
        User thisUser = [Select Id From User Where Id =:UserInfo.getUserId()];
        user sysAdminUser;
        System.runAs(thisUser){
            sysAdminUser = ACET_Fast_TestDataFactory.getUserRecord(sysAdminPrf.id);
            insert sysAdminUser;
        }
        case caseRec = ACET_Fast_TestDataFactory.getCaseRecord('Reactive_Resolution','New');
        insert caseRec;
        PIR_Detail__c pirDetail = ACET_Fast_TestDataFactory.getPIRRec(caseRec.id);
        insert pirDetail;
        System.runAs(sysAdminUser){
            ACET_FAST_CloneCaseCtrl.cloneCaseWrapper wrap = ACET_FAST_CloneCaseCtrl.getCaseRecord(caseRec.id);
            string wrapStr = JSON.serialize(wrap);
            ACET_FAST_CloneCaseCtrl.cloneCaseAndRelatedRecords(wrapStr);
            
            //insert interaction record
            Interaction__c inter = new Interaction__c();
            inter.Interaction_Type__c = 'Email';
            insert inter;
            
            ACET_FAST_CloneCaseCtrl.cloneIntRec(inter.Id);
        }
    }
}