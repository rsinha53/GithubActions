/**
* Author: Hasara Disanayaka
* Date Created: 31/03/2020
* Purpose: US2510037-TA7202870: function to call SelectIssue service - mapping data to Originated Date & Contact Reason Description
**/

public without sharing class ADBSelectIssuesRequestWrapper {
    
    public SearchInput searchInput{ get; set; }
    public class SearchInput {
        public String searchType{ get; set; }
        public String officeId{ get; set; }
        public String agentId{ get; set; }
        public String subscriberId{ get; set; }
    }
    
}