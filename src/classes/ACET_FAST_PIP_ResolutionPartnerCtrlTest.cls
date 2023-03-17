/*****************************************************************************************************
ACET_FAST_PIP_ResolutionPartnerCtrlTest
Testing Class Name:  ACET_FAST_PIP_ResolutionPartnerCtrl
Author: Karimulla Shaik
Date: 11/26/2020
Description: This is test class and used to get test coverage for ACET_FAST_PIP_ResolutionPartnerCtr. 
Initial: Karimulla Shaik
******************************************************************************************************/
@isTest
public class ACET_FAST_PIP_ResolutionPartnerCtrlTest {
    static testMethod void getRec(){
        case caseRec = ACET_Fast_TestDataFactory.getCaseRecord('Reactive_Resolution','Open');
        
        insert caseRec;
        
        ACET_FAST_PIP_ResolutionPartnerCtrl.getCaseRecordType(caseRec.Id);
    }
    
     static testMethod void getRPRec(){
        case caseRec = ACET_Fast_TestDataFactory.getCaseRecord('Reactive_Resolution','Open');
        
        insert caseRec;
		
         PIR_Resolution_Partner__c rpRec = ACET_Fast_TestDataFactory.getPIRRPRec(caseRec.id);
         insert rpRec;
        ACET_FAST_PIP_ResolutionPartnerCtrl.getRPName(rpRec.Id);
    }
}