@IsTest
public class ACETViewMemListingPDFControllerJobTest {    
    @isTest 
    static void Testinitaction(){
        try{
        Account acc = new Account();
        acc.Name = 'TestAcc';
        insert acc;
        Blob b = Blob.valueOf('Test Data');
        Attachment attachment = new Attachment();
        attachment.ParentId = acc.id;
        attachment.Name = 'Test Attachment for Parent';
        attachment.Body = b;
        insert(attachment);
        
        string cobraCount1 = '5';
        List<String> ListOfPops = new List<String>{'Test1','Test2'};
        List<String> ListOfBundles = new List<String>{'Bundle1','Bundle2'};
        List<String> ListOfOption = new List<String>{'Option1','Option2'};
        ApexPages.currentPage().getParameters().put('hasPop', 'no');
        ApexPages.currentPage().getParameters().put('groupName', 'TestGroupName');
        ApexPages.currentPage().getParameters().put('groupId', 'TestGroupId');
        ApexPages.currentPage().getParameters().put('contractId', 'TetcontractId');
        ApexPages.currentPage().getParameters().put('request', 'testrequest');
        ApexPages.currentPage().getParameters().put('statusPDF', 'teststatusPDF');
        ApexPages.currentPage().getParameters().put('bundleID', 'testbundleID');
        ApexPages.currentPage().getParameters().put('inquiryDate', string.valueof(system.today()));
        ApexPages.currentPage().getParameters().put('cobraCount', string.valueof(cobraCount1));
        ApexPages.currentPage().getParameters().put('continuationType', 'testcontinuationType');
        ApexPages.currentPage().getParameters().put('selectedPopulation', 'testselectedPopulation');
        ApexPages.currentPage().getParameters().put('attachmentid', attachment.id);
        
        List<ACETViewMemberListingResultsWrapper> lstWrap = new List<ACETViewMemberListingResultsWrapper>();
        List<ACETViewMemberListingResultsWrapper> lstWrapfilteredList = new List<ACETViewMemberListingResultsWrapper>();
        List<ACETViewMemberListingResultsWrapper> lstWrapfinalList = new List<ACETViewMemberListingResultsWrapper>();
        List<ACETViewMemberListingResultsWrapper> lstSearchMemberListingResultsResp1 = new List<ACETViewMemberListingResultsWrapper>();
        
        ACETViewMemberListingPDFControllerJob obj = new ACETViewMemberListingPDFControllerJob();
        obj.renderAs = 'pdf';
        obj.dateValues = string.valueof(system.today());
        obj.searchMemberListingResults = lstWrap;
        obj.filteredList = lstWrapfilteredList;
        obj.finalList = lstWrapfinalList;
        obj.SearchMemberListingResultsResp1 = lstSearchMemberListingResultsResp1;
        obj.bundles = 'Test';
        obj.allpops = 'testOps';
        obj.listbundles = ListOfBundles;
        obj.listpops = ListOfPops;
        obj.startRecord = 1;
        obj.groupNameId = 'test';
        obj.baseURL = 'https://www.salesforce.com';
        obj.initaction();
        }catch(exception ex){}
    }
    
    @isTest 
    static void TestinitactionOne(){
        string cobraCount1 = '5';
        List<String> ListOfPops = new List<String>{'Test1','Test2'};
        List<String> ListOfBundles = new List<String>{'Bundle1','Bundle2'};
        List<String> ListOfOption = new List<String>{'Option1','Option2'};
        ApexPages.currentPage().getParameters().put('hasPop', 'Yes');
        ApexPages.currentPage().getParameters().put('groupName', 'TestGroupName');
        ApexPages.currentPage().getParameters().put('groupId', 'TestGroupId');
        ApexPages.currentPage().getParameters().put('contractId', 'TetcontractId');
        ApexPages.currentPage().getParameters().put('request', 'testrequest');
        ApexPages.currentPage().getParameters().put('statusPDF', 'teststatusPDF');
        ApexPages.currentPage().getParameters().put('bundleID', 'testbundleID');
        ApexPages.currentPage().getParameters().put('inquiryDate', string.valueof(system.today()));
        ApexPages.currentPage().getParameters().put('cobraCount', string.valueof(cobraCount1));
        ApexPages.currentPage().getParameters().put('continuationType', 'testcontinuationType');
        ApexPages.currentPage().getParameters().put('selectedPopulation', 'testselectedPopulation');
        
        List<ACETViewMemberListingResultsWrapper> lstWrap = new List<ACETViewMemberListingResultsWrapper>();
        List<ACETViewMemberListingResultsWrapper> lstWrapfilteredList = new List<ACETViewMemberListingResultsWrapper>();
        List<ACETViewMemberListingResultsWrapper> lstWrapfinalList = new List<ACETViewMemberListingResultsWrapper>();
        List<ACETViewMemberListingResultsWrapper> lstSearchMemberListingResultsResp1 = new List<ACETViewMemberListingResultsWrapper>();
        
        ACETViewMemberListingPDFControllerJob obj = new ACETViewMemberListingPDFControllerJob();
        obj.renderAs = 'pdf';
        obj.dateValues = string.valueof(system.today());
        obj.searchMemberListingResults = lstWrap;
        obj.filteredList = lstWrapfilteredList;
        obj.finalList = lstWrapfinalList;
        obj.SearchMemberListingResultsResp1 = lstSearchMemberListingResultsResp1;
        obj.bundles = 'Test';
        obj.allpops = 'testOps';
        obj.listbundles = ListOfBundles;
        obj.listpops = ListOfPops;
        obj.startRecord = 1;
        obj.groupNameId = 'test';
        obj.baseURL = 'https://www.salesforce.com';
        obj.initaction();
    }
}