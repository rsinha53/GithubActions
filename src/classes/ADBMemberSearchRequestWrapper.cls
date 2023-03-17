/**
* Author: Hasara Disanayaka
* Date Created: 30/06/2020
* Purpose: Function to call MemberSearchV2 service 
**/
public without sharing class ADBMemberSearchRequestWrapper {

    public String memberIDType;
    public String firstName;
    public String lastName;
    public String dateOfBirth;
    public String memberId;
    public SearchInputMetaData searchInputMetaData;
    
    public class SearchInputMetaData {
        public String consumerAppId;
        public String consumerAppType;
        public String consumerType;
        public String externalCorrelationId;
        public Pagination pagination;
    }
    
    public class Pagination {
        public Integer maxResults;
        public Boolean maxResultsIndicator;
    }
 
}