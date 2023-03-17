@isTest
private class ACET_ExplorePageCtrl_Test {
    @isTest static void getStateValues_Test() {
        ACET_ExplorePageCtrl.getStateValues();
        ACET_ExplorePageCtrl.FlowDetails fd = new ACET_ExplorePageCtrl.FlowDetails();
        fd.contactExt = '123';
        fd.contactName = 'cn';
        fd.contactNumber = '1234567890';
        fd.interactionType = 'Email';
        ACET_ExplorePageCtrl.getQuestionTypeValueforIVR('C1');
    }
    @isTest static void getTPMSValues_Test() {
    	ACET_ExplorePageCtrl.getTPSMValues('123456','1234568');
        ACET_ExplorePageCtrl.getClaimProjectManagement('co');
    }
}