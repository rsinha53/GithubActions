@isTest
public class ACETViewMemberListingPDFControllerTest {
    public static testMethod void getSearchMemberListingResultsResptestTest() {
        Test.startTest();
        PageReference myVfPage = Page.ACETGroupPlanBenefitDetailExcel;
        Test.setCurrentPage(myVfPage); 
        String pageName = ApexPages.currentPage().getUrl().substringBetween('apex/', '?');
        ApexPages.currentPage().getParameters().put('population', 'All');
        ApexPages.currentPage().getParameters().put('allPop', 'testOp3,testopo4');
        ApexPages.currentPage().getParameters().put('inqDate', '31/03/2017');
        ApexPages.currentPage().getParameters().put('cobCount','');
        ApexPages.currentPage().getParameters().put('hasPop', 'false');
        ApexPages.currentPage().getParameters().put('bundles', 'Bundle1,Bundle2');
        ApexPages.currentPage().getParameters().put('groupnumber', 'test1,test2');
        ApexPages.currentPage().getParameters().put('status', 'Future');
        Test.stopTest();
        ACETViewMemberListingPDFController obj = new ACETViewMemberListingPDFController();
        obj.getSearchMemberListingResultsResp();
    }
    
    public static testMethod void getSearchMemberListingResultsResptestTestOne() {
        Test.startTest();
        string cobraCount1 = '5';
        PageReference myVfPage = Page.ACETGroupPlanBenefitDetailExcel;
        Test.setCurrentPage(myVfPage); 
        String pageName = ApexPages.currentPage().getUrl().substringBetween('apex/', '?');
        ApexPages.currentPage().getParameters().put('population', 'AllTest');
        ApexPages.currentPage().getParameters().put('allPop', 'testOp3,testopo4');
        ApexPages.currentPage().getParameters().put('inqDate', '31/03/2017');
        ApexPages.currentPage().getParameters().put('cobCount',string.valueof(cobraCount1));
        ApexPages.currentPage().getParameters().put('hasPop', 'true');
        ApexPages.currentPage().getParameters().put('bundles', 'Bundle1,Bundle2');
        ApexPages.currentPage().getParameters().put('groupnumber', 'test1,test2');
        ApexPages.currentPage().getParameters().put('status', 'Pend');
        Test.stopTest();
        ACETViewMemberListingPDFController obj = new ACETViewMemberListingPDFController();
        obj.getSearchMemberListingResultsResp();
        
    }
}