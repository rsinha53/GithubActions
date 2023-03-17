/**
* Author: Hasara Disanayaka
* Description : Wrapper class to get the response back from Language Preference Service
*               https://api-gateway-stage.linkhealth.com/elink-extended/api/languagePreference/v2.0
* AuraEnabled : False
* Created Date : 12/02/2020
*/

public without sharing class ADBLanguagePreferenceResponseWrapper {
    
    public String responseCode;
    public String responseMsg;
    public String responseDetailMsg;
    
    public Attributes attributes;
    public class Attributes {
        public String verbalLanguagePreference;
    }
    public static ADBLanguagePreferenceResponseWrapper parse(String json) {
        return (ADBLanguagePreferenceResponseWrapper) System.JSON.deserialize(json, ADBLanguagePreferenceResponseWrapper.class);
    }
}