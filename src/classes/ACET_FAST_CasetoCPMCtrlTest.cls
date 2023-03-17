/*****************************************************************************************************
ACET_FAST_CasetoCPMCtrlTest
Testing Class Name:  ACET_FAST_ACET_FAST_CasetoCPMCtrl
Author: Shaik Mohammad Yaseen
Date: 11/26/2020
Description: This is test class and used to get test coverage for ACET_FAST_ACET_FAST_CasetoCPMCtrl. 
Initial: Shaik Mohammad Yaseen
******************************************************************************************************/
@isTest
public class ACET_FAST_CasetoCPMCtrlTest {
    static final String PIR_PROFILE = 'Provider Issue Resolution';
    public static testmethod void testValidUserPIRCreateandEdit(){
        Profile fastUserProfile = ACET_Fast_TestDataFactory.getProfile(PIR_PROFILE);
        UserRole fastRole = ACET_Fast_TestDataFactory.getRole('PIR - Reactive Resolution');
        user fastUser = ACET_Fast_TestDataFactory.getUserRecordWithRole(fastUserProfile.id,fastRole.Id);
        insert fastUser;
        system.runAs(fastUser)
        {
            case caseRec = ACET_Fast_TestDataFactory.getCaseRecord('Reactive_Resolution','Open');
            insert caseRec;
            
            ACET_FAST_CasetoCPMCtrl.CpmWrapper wrap = new ACET_FAST_CasetoCPMCtrl.CpmWrapper();
            wrap = ACET_FAST_CasetoCPMCtrl.initializeCaseWrapper(caseRec.id);
            string wrapStr = JSON.serialize(wrap);
            ACET_FAST_CasetoCPMCtrl.sendToCPM(wrapStr);
        }
    }
}