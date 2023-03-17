@isTest(SeeAllData=true)
public class ACETCaseCommentsHistoryReportContTest{
    public static testmethod void ACETReportTest() {
        Report reportName=[select id,Name from Report limit 1];
        ACETCaseCommentsHistoryReportController reportCont = new ACETCaseCommentsHistoryReportController();
        reportCont.CaseSubjectId='test';
        reportCont.CaseSubjectName='test';
        reportCont.CaseSubjectType='test';
        reportCont.commentsReport=reportName;
        
    }
 }