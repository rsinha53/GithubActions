public class ACETLGT_CaseCommentsHistReportController {
    
    @AuraEnabled
    public static Report caseCommentsReport(){        
        Report commentsReport = new Report();
        String reportName=Label.ACETCaseCommentsReport;
        if(String.isNotBlank(reportName)){
            if(!Test.isRunningTest()){
                commentsReport=[Select Id,Name from Report where Name=:reportName limit 1];
            }
        }
        return commentsReport;
    }
}