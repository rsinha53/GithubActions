@isTest
private class ACETCaseDetailControllerTest {

    static testMethod void myUnitTest() {
        // TO DO: implement unit test
        CaseDataWrapper caseDataWrap = new CaseDataWrapper();
        caseDataWrap.mapCaseData.put(TestDataFactory.createCase().Id, TestDataFactory.createCase());
        test.starttest();
       pagereference pg = new pagereference('/apex/test?name=test');
       string year = '2018';
string month = '10';
string day = '5';
string hour = '12';
string minute = '20';
string second = '20';
string stringDate = year + '-' + month + '-' + day + ' ' + hour + ':' 
    + minute +  ':' + second;

//Datetime myDate = Datetime.valueOf(stringDate);
       test.setCurrentpage(pg);
        ACETCaseDetailController caseDetailCls = new ACETCaseDetailController();
        caseDetailCls.ExternalIDs = 'test1,test2';
        caseDetailCls.CaseItemStatus = 'test1,test2';
        caseDetailCls.originalType = 'Test Original Type';
       // caseDetailCls.caseId = TestDataFactory.createCase().Id;
      //  caseDetailCls.caseCommentsMap = caseDataWrap;
      caseDetailCls.caseCommentString='test<1>'+stringDate+'<br/>';
        caseDetailCls.displayCaseComments(); 
        test.stoptest();
    }
}