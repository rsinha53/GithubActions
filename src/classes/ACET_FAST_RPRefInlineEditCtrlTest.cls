/*****************************************************************************************************
ACET_FAST_RPRefInlineEditCtrlTest
Testing Class Name:  ACET_FAST_RPRefInlineEditCtrl
Author: Shaik Mohammad Yaseen
Date: 31/03/2021
Description: This is test class and used to get test coverage for ACET_FAST_RPRefInlineEditCtrl. 
Initial: Shaik Mohammad Yaseen
******************************************************************************************************/
@isTest
public class ACET_FAST_RPRefInlineEditCtrlTest {
    public static testMethod void inlineEditTestMethod(){
        Profile sysAdminPrf = ACET_Fast_TestDataFactory.getSysAdminPrf();
        user sysAdminUser = ACET_Fast_TestDataFactory.getUserRecord(sysAdminPrf.id);
        insert sysAdminUser;
        System.runAs(sysAdminUser){
            case caseRec = ACET_Fast_TestDataFactory.getCaseRecord('Reactive_Resolution','Open');
            insert caseRec;              
            
            Provider_Matrix__c pmRec = new Provider_Matrix__c();
            pmRec.Name = 'Test RP';
            pmRec.Resolution_Partner_SLA__c = 20;
            insert pmRec;
            
            PIR_Resolution_Partner__c rp = new PIR_Resolution_Partner__c();
            rp.Case__c = caseRec.id;
            rp.Provider_Matrix_Reactive__c = pmRec.Id;
            insert rp;
            
            List<PIR_Resolution_Partners_Reference__c> rpRefListToInsert = new List<PIR_Resolution_Partners_Reference__c>();
            
            PIR_Resolution_Partners_Reference__c rpRef1 = new PIR_Resolution_Partners_Reference__c();
            rpRef1.PIR_Resolution_Partner__c = rp.id;
            rpRef1.Reference__c = 'qwerty';
            rpRef1.Completed__c = true;
            rpRefListToInsert.add(rpRef1);
            
            PIR_Resolution_Partners_Reference__c rpRef2 = new PIR_Resolution_Partners_Reference__c();
            rpRef2.PIR_Resolution_Partner__c = rp.id;
            rpRef2.Reference__c = 'qwerty';
            rpRef2.Completed__c = true;
            rpRefListToInsert.add(rpRef2);
            
            insert rpRefListToInsert;
            
            ACET_FAST_RPRefInlineEditCtrl.fWrapper fWrap = ACET_FAST_RPRefInlineEditCtrl.getReferences(rp.Id);
            fWrap.pRefWrapList[0].selectedCheckBox= true;
            ACET_FAST_RPRefInlineEditCtrl.completeSelected(fWrap.pRefWrapList,rp.Id);
            ACET_FAST_RPRefInlineEditCtrl.deleteSelected(fWrap.pRefWrapList,rp.Id);
        }
    }
}