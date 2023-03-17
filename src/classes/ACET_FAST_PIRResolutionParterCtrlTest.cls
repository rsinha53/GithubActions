/*****************************************************************************************************
ACET_FAST_PIRResolutionParterCtrl
Testing Class Name:  ACET_FAST_PIRResolutionParterCtrlTest
Author: Ratna kumar Mukiri
Date: 17/04/2021
Description: This is test class and used to get test coverage for ACET_FAST_PIRDetailCtrl. 
Initial: Ratna kumar Mukiri
******************************************************************************************************/
@isTest(SeeAllData=false)
public class ACET_FAST_PIRResolutionParterCtrlTest {
    
     public static testMethod void testWithFastUser(){
        Profile sysAdminPrf = ACET_Fast_TestDataFactory.getSysAdminPrf();
        user sysAdminUser = ACET_Fast_TestDataFactory.getUserRecord(sysAdminPrf.id);
        insert sysAdminUser;
         
        System.runAs(sysAdminUser){
            case caseRec = ACET_Fast_TestDataFactory.getCaseRecord('Reactive_Resolution','Open');
            insert caseRec;
             
            PIR_Resolution_Partner__c rPRecord =ACET_Fast_TestDataFactory.getPIRRPRec(caseRec.id);
            insert rPRecord;
             
            Case_Item__c casItem=new Case_Item__c (Case__c	=caseRec.id);
            insert casItem;
            PIR_Resolution_Partners_Reference__c casRPR=new PIR_Resolution_Partners_Reference__c(Case_Item__c=casItem.id,
                                                                                                  PIR_Resolution_Partner__c=rPRecord.id,
                                                                                                  Reference__c='1234');
            insert casRPR;
            ACET_FAST_PIRResolutionParterCtrl.getCaseItemRecord(casItem.id);
            ACET_FAST_PIRResolutionParterCtrl.updateCaseItem(casItem); 
            ACET_FAST_PIRResolutionParterCtrl.getCaseItemRecord(casItem.id);
            ACET_FAST_PIRResolutionParterCtrl.getCaseRecord(caseRec.id);
            ACET_FAST_PIRResolutionParterCtrl.getRPRecord(rPRecord.id);
            ACET_FAST_PIRResolutionParterCtrl.getRPName(rPRecord.id);
            ACET_FAST_PIRResolutionParterCtrl.validateRPRecord(rPRecord.id, caseRec.id);
             ACET_FAST_PIRResolutionParterCtrl.getRPRefrenceNumberRecord('1234'); 
            ACET_FAST_PIRResolutionParterCtrl.getReferenceRecord(rPRecord.id); 
            
        }
    }

}