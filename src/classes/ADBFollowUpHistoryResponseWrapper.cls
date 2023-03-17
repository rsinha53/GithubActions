/*
 * Author: SaiKolluru on 10/12/2020 
 */

public without sharing class ADBFollowUpHistoryResponseWrapper {
	
    public List<FollowUpHistory> followUpHistory;
    
    public class FollowUpHistory{
        public String followUpType;
        public String updateDate;
        public String purposeDescription;
        public String nextActionDueDate;
        public String statusCode;
    }
}