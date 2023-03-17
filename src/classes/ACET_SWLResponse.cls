// Response Wrapper for Select Work Load List API
public class ACET_SWLResponse{
    @AuraEnabled public list<workList> workList{get;set;}
    @AuraEnabled public pagingState pagingState{get;set;}
  public class workList{
        @AuraEnabled public serviceRequestOwner serviceRequestOwner{get;set;}
        @AuraEnabled public followUpOwner followUpOwner{get;set;}
    }
    public class serviceRequestOwner{
        @AuraEnabled public String reasonDescription{get;set;}
        @AuraEnabled public String memberId{get;set;}
        @AuraEnabled public String reasonCode{get;set;}
        @AuraEnabled public String issueId{get;set;}
        @AuraEnabled public String originalDate{get;set;}
        @AuraEnabled public String originatorLastName{get;set;}
        @AuraEnabled public String statusDescription{get;set;}
        @AuraEnabled public String originatorFirstName{get;set;}
        @AuraEnabled public String statusCode{get;set;}
        @AuraEnabled public String policyNumber{get;set;}
        @AuraEnabled public String lastUpdate{get;set;}
        @AuraEnabled public String dependentLastName{get;set;}
        @AuraEnabled public String serviceRequestType{get;set;}
        @AuraEnabled public String serviceRequestSubType{get;set;}
        @AuraEnabled public String associateLastName{get;set;}
        @AuraEnabled public String priority{get;set;}
        @AuraEnabled public String associateFirstName{get;set;}
        @AuraEnabled public String serviceRequestTypeDescription{get;set;}
        @AuraEnabled public String dependentFirstName{get;set;}
        @AuraEnabled public String serviceRequestSubTypeDescription{get;set;}
        @AuraEnabled public owner owner{get;set;}
    }
	public class pagingState{
        @AuraEnabled public String nextKey{get;set;}
        @AuraEnabled public Boolean moreData{get;set;}
    }
    public class owner{
        @AuraEnabled public String officeName{get;set;}
        @AuraEnabled public String firstName{get;set;}
        @AuraEnabled public String lastName{get;set;}
    }
    public class followUpOwner{
        @AuraEnabled public owner owner{get;set;}
        @AuraEnabled public String purposeCode{get;set;}
        @AuraEnabled public String statusCode{get;set;}
        @AuraEnabled public String nextActionDueDate{get;set;}
        @AuraEnabled public String statusDescription{get;set;}
        @AuraEnabled public String daysToComplete{get;set;}
        @AuraEnabled public String preferredContactTime{get;set;}
        @AuraEnabled public String estimatedCompletionDate{get;set;}
    }
}