@isTest(seealldata=false)
private class ACET_ViewAutodocCtrlTest {
    
    //Test coverage for Autodoc cmp
    static testmethod void getAutoDocInfoTest(){
        System.runAs(ACET_TestDataFactory.getUser('Provider Service')){
            Test.startTest();
            Case caseRec = ACET_TestDataFactory.createCase();
            ACET_ViewAutodocCtrl.getAutoDocInfo(caseRec.Id);
            ACET_TestDataFactory.createAttachment(caseRec.Id);
            ACET_ViewAutodocCtrl.getAutoDocInfo(caseRec.Id);
            Test.stopTest();
        }
    }
}