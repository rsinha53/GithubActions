/*
 * Author : Sai Kolluru
 * */
public without sharing class ADBFollowupsWorkloadListResWpr {
	public class Owner {
        @AuraEnabled public String firstName;
        @AuraEnabled public String lastName;
        @AuraEnabled public String officeName;
	}
    @AuraEnabled public String type;	
    @AuraEnabled public String title;	
    @AuraEnabled public Integer status;	
    @AuraEnabled public String detail;	
    @AuraEnabled public String optumCidExt;	
    @AuraEnabled public Cls_Violations[] violations;
	public class Cls_Violations {
		@AuraEnabled public String reason;	
	}

	public class ServiceRequestOwner {
		@AuraEnabled public String lastUpdate;
		@AuraEnabled public String statusCode;
		@AuraEnabled public String statusDescription;
		@AuraEnabled public String originalDate;
		@AuraEnabled public String reasonCode;
		@AuraEnabled public String reasonDescription;
		@AuraEnabled public String memberId;
		@AuraEnabled public String issueId;
		@AuraEnabled public String originatorLastName;
		@AuraEnabled public String originatorFirstName;
		@AuraEnabled public String policyNumber;
		public String dependentLastName;
		public String dependentFirstName;
		public String associateFirstName;
		public String associateLastName;
		public String serviceRequestType;
		public String serviceRequestSubType;
		public String priority;
		public String serviceRequestTypeDescription;
		@AuraEnabled public String serviceRequestSubTypeDescription;
		public Owner owner;
	}

	@AuraEnabled public PagingState pagingState;
	@AuraEnabled public List<WorkList> workList;
	@AuraEnabled public ResponseHeader responseHeader;

	public class ResponseHeader {
		@AuraEnabled public String serviceCallStatus;
		@AuraEnabled public String externalId;
		@AuraEnabled public List<StatusMessages> statusMessages;
	}

	public class WorkList {
		@AuraEnabled public FollowUpOwner followUpOwner;
		@AuraEnabled public ServiceRequestOwner serviceRequestOwner;
	}

	public class StatusMessages {
	}

	public class FollowUpOwner {
		@AuraEnabled public String estimatedCompletionDate;
		@AuraEnabled public String daysToComplete;
		@AuraEnabled public String nextActionDueDate;
		@AuraEnabled public String purposeCode;
		@AuraEnabled public String statusCode;
		@AuraEnabled public String statusDescription;
		@AuraEnabled public String preferredContactTime;
		@AuraEnabled public Owner owner;
	}

	public class PagingState {
		@AuraEnabled public Boolean moreData;
		@AuraEnabled public String nextKey;
	}

	
}