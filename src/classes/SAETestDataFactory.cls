public class SAETestDataFactory {

    // Data Factory INSERT Method [ISL_Webservice_Config__c]
    public static ISL_Webservice_Config__c insertISLWebserviceConfig(String strName, String strComName, Boolean isErrorLogEnabled, 
    Boolean isAvailable, String strISLWebserviceEID, Integer numPage, Boolean isScopeHeaderFlag, String strServName, String strValue){
        ISL_Webservice_Config__c configObj = new ISL_Webservice_Config__c();
        configObj.Name = strName;
        configObj.ACET_Common_Name__c = strComName;
        configObj.Error_Log_Enabled__c = isErrorLogEnabled;
        configObj.Is_Available__c = isAvailable;
        configObj.ISLWebserviceEID__c = strISLWebserviceEID;
        configObj.Page_Size__c = numPage;
        configObj.Scope_Header_Flag__c = isScopeHeaderFlag;
        configObj.Service_Name__c = strServName;
        configObj.Value__c = strValue;
        INSERT configObj;
        return configObj;
    }

    // Data Factory INSERT Method [Bookmark_Links__c]
    public static Bookmark_Links__c insertBookmarkLink(String strDisplayName, String strProfiles, String strUrl, Boolean IsActive){
        Bookmark_Links__c bookmarkObj = new Bookmark_Links__c();
        bookmarkObj.Active__c = IsActive;
        bookmarkObj.Display_Name__c = strDisplayName;
        bookmarkObj.Profiles__c = strProfiles;
        bookmarkObj.URL__c = strUrl;
        return bookmarkObj;
    }

    // Get Data Response from StaticResource
    public static String getStaticResourceResponse(String strName) {
        StaticResource ResponseJSONSR = [SELECT Body FROM StaticResource WHERE Name = :strName ];
        return ResponseJSONSR.Body.toString();
    }

    // Create User
    public static User createUser(String strAlias, String strEmail, String strEncodingKey, String strLastName, String strLangLocaleKey, 
    String strLocaleSidKey, String strProfId, String strTimeZoneSidKey, String strUserName){
        User userObj = new User();
        userObj.Alias = strAlias;
        userObj.Email = strEmail;
        userObj.EmailEncodingKey = strEncodingKey;
        userObj.LastName = strLastName;
        userObj.LanguageLocaleKey = strLangLocaleKey;
        userObj.LocaleSidKey = strLocaleSidKey;
        userObj.ProfileId = strProfId;
        userObj.TimeZoneSidKey = strTimeZoneSidKey;
        userObj.UserName = strUserName;
        return userObj;
    }

    // Load Profile
    public static Profile loadProfile(String strProfName){
        return [ SELECT Id, Name FROM Profile WHERE Name = :strProfName ];
    }

    // Load User
    public static User loadUser(String strUserName){
        return [ SELECT Id, Name FROM User WHERE UserName = :strUserName ];
    }

    // Create Call Topic Access
    public static TTS_Access__c createTTSAccess(String strTopic, String strType, String strSubType, String strPerm){
        TTS_Access__c ttsObj = new TTS_Access__c();
        ttsObj.Topic__c = strTopic;
        ttsObj.Type__c = strType;
        ttsObj.Subtype__c = strSubType;
        ttsObj.Limit_To_Profiles__c = strPerm;
        ttsObj.Limit_To_Roles__c = strPerm;
        INSERT ttsObj;
        return ttsObj;
    }

}