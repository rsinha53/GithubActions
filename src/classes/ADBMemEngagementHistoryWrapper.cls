/**
* Created By : Madhura Priyadarshana
* Description : Wrapper to be used to handle member engagement history response at contact history
* Date Created: 11/19/2020
*/
public without sharing class ADBMemEngagementHistoryWrapper {

    public List<EngagementHistorySummaryList> engagementHistorySummaryList;
    
    public class EngagementHistorySummaryList{
	public EngagementVO engagementVO;
	public String channelSourceType;
        public String engageCmnctCategoryType;
    }
    
    public class EngagementVO{
		public String createUserID;
		public String changeUserID;
		public Long changeDateTime;
		public Integer tenantID;
		public Integer updateVersion;
		public Boolean trackChanges;
		public String userTimezone;
		//public Object dataSecurityTypeList {get;set;} 
		public Integer historyID;
		public Integer engagementID;
		public Integer memberID;
		public String engagementReasonText;
		//public Object engagementCategoryType {get;set;} 
		public String engagementStatusType;
		public Long startDateTime;
		public Long endDateTime;
		public Integer memberCoverageSeqNum;
		//public Object userEngagementHistoryVOs {get;set;} 
		//public Object engagementMemberCoverageVOs {get;set;} 
		//public Object engagementServiceProviderReferralVOs {get;set;} 
		public Integer facetsAccountID;
		public Integer facetsMemberID;
		public String populationId;
		public Integer customerID;
		public Integer purchaserID;
		//public Object nominatingDepartmentType {get;set;} 
		//public Object derivedFacetsAccountIDs {get;set;} 
		public Integer derivedFacetsMemberID;
		//public Object pickerFacetAcctDerivationType {get;set;} 
		public Boolean updateMemberEligibilityRequired;
		public Boolean closedCommunicationPresent;
		public Boolean multipleCommunicationsPresent;
		//public Object policyNumber {get;set;} 
		public Boolean statusOpen;
		public Boolean statusClosed;
		public Boolean dataSecured;
    }
}