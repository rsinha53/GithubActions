/**
* Author: Hasara Disanayaka
* Date Created: 02/04/2020
* Date Modified:
* Purpose: To Capture the response of the service
* 
**/
public without sharing class ADBReadIssueDetailsResponseWrapper {
    @AuraEnabled public ResponseHeader responseHeader;
    public class ResponseHeader {
    }
    @AuraEnabled public Issue issue;
    public class Issue {
        @AuraEnabled public String reasonCategory;
    }
    public static ADBReadIssueDetailsResponseWrapper parse(String json) {
        return (ADBReadIssueDetailsResponseWrapper) System.JSON.deserialize(json, ADBReadIssueDetailsResponseWrapper.class);
    }
}