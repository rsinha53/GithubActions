/**
* Author: Hasara Disanayaka
* Date Created: 31/03/2020
* Purpose: US2510037-TA7202870: function to call SelectIssue service - mapping data to Originated Date & Contact Reason Description
**/

public without sharing class ADBSelectIssuesResponseWrapper {
    
    public SearchResult searchResult;
    public class SearchResult {
        public SearchOutput searchOutput;
    }
    public class SearchOutput {
        public List<IssuesList> issuesList;
    }
    public class IssuesList {
        public String issueId;
        public String contactReasonDescription;
        public String originatedDate;
        public String reasonCategory;
        public String status;
    }
   public static ADBSelectIssuesResponseWrapper parse(String json) {
        return (ADBSelectIssuesResponseWrapper) System.JSON.deserialize(json, ADBSelectIssuesResponseWrapper.class);
    }
	 @AuraEnabled public String title;	
    @AuraEnabled public Cls_Violations[] violations;
	public class Cls_Violations {
		@AuraEnabled public String reason;	
	}								  
}