public with sharing class ACETCaseCommentsHistoryReportController{
    public string CaseSubjectId{get;set;}
    public string CaseSubjectName{get;set;}
    public string CaseSubjectType{get;set;}
    public Report commentsReport{get;set;}
    
    public ACETCaseCommentsHistoryReportController(){
    String reportName=Label.ACETCaseCommentsReport;
        if(String.isNotBlank(reportName)){
           if(!Test.isRunningTest()){
         commentsReport=[Select Id,Name from Report where Name=:reportName limit 1];
         }
        }      
    }
}