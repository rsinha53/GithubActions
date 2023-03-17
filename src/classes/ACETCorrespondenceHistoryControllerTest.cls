@isTest
public class ACETCorrespondenceHistoryControllerTest {
    static testmethod void ACETCorrespondenceHistoryTest1(){
    	ACETCorrespondenceHistoryController test1 = new ACETCorrespondenceHistoryController();    
    	test1.init();
        test1.type='test';
        test1.claimnumber='test';
        test1.taxid='123456';
        test1.claimNoReqd='test';
        test1.startDateReqd='test';
        test1.endDateReqd='Yes';
        test1.SortBy='Asc';
        test1.SortOrder='Test';
        test1.LastSortBy='TEst';
        test1.ischecked=true;        
    }
}