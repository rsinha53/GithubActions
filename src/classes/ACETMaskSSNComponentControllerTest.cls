@isTest()
private class ACETMaskSSNComponentControllerTest {
    static testMethod void Test1() {
        ACETMaskSSNComponentController contrlObj = new ACETMaskSSNComponentController();
        contrlObj.SSNUnMaskValue = '123123123asdfas1122';
        contrlObj.constituentEID = '123123123';
        contrlObj.constituentType = 'Group Detail';
        Test.startTest();
        //contrlObj.getMaskedSSN();
        //contrlObj.getUnMaskedSSN();
        Test.stopTest();
        
    
    }

}