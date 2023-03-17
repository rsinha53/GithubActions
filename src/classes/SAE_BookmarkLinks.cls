public with sharing class SAE_BookmarkLinks {

    @AuraEnabled
    public static Bookmark_Links__c[] getAllBookmarks() {
        // try {
            String strProfName = [ SELECT Id, Name FROM Profile WHERE Id = :Userinfo.getProfileId() ].Name;
            return [ SELECT Name, Display_Name__c, Profiles__c, URL__c, Active__c FROM Bookmark_Links__c 
            WHERE Active__c = true AND Profiles__c INCLUDES(:strProfName) ORDER BY Display_Name__c ];
        // } catch (AuraHandledException ex) {
        //     System.debug(LoggingLevel.ERROR, 'SAE_BookmarkLinks: getAllBookmarks() - ' + ex.getLineNumber() + ' : ' + ex.getMessage());
        //     throw new AuraHandledException(ex.getMessage());
        // }
    }

}