@isTest
public class ACET_FAST_ExplorePageCtrl_Test {
    @isTest static void getStateValues_Test() {
        ACET_FAST_ExplorePageCtrl.getStateValues();
        ACET_FAST_ExplorePageCtrl.FlowDetails fd = new ACET_FAST_ExplorePageCtrl.FlowDetails();
        fd.contactExt = '123';
        fd.contactName = 'cn';
        fd.contactNumber = '1234567890';
        fd.interactionType = 'Email';
        ACET_FAST_ExplorePageCtrl.FlowDetails obj=new ACET_FAST_ExplorePageCtrl.FlowDetails();
        fd.IVRInfo=obj;
        fd.isGenesys=true;
        fd.GeneysysQuestionType='String';
        ACET_FAST_ExplorePageCtrl.getQuestionTypeValueforIVR('C1');
    }
}