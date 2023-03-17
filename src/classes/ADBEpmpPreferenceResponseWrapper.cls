// Response wrapper for epmp service details: US2368815 - sunil vennam 
public without sharing class ADBEpmpPreferenceResponseWrapper {
    @AuraEnabled public String responseCode;
    @AuraEnabled public String responseMsg;
    @AuraEnabled public String responseDetailMsg;
    @AuraEnabled public String phone;
    @AuraEnabled public String email_Address;
    @AuraEnabled public String communication_Preference;
    @AuraEnabled public String ganActivationStatus;
    @AuraEnabled public List<Prefs> prefs;
    Public class Prefs{
        @AuraEnabled public String name;
        @AuraEnabled public String category;
        @AuraEnabled public String value;
    }  
    @AuraEnabled public contactInfo contactInfo;
    @AuraEnabled public preferences preferences;
    Public class contactInfo{
        @AuraEnabled public List<telephones> telephones;
        @AuraEnabled public List<electronicContacts> electronicContacts;
    }    
    public class telephones{
        @AuraEnabled public communicationTypeCode communicationTypeCode;
        @AuraEnabled public communicationTypeDescription communicationTypeDescription;
        @AuraEnabled public renderingAttributesType renderingAttributesType;
        @AuraEnabled public String telephoneNumber;
    }
    public class renderingAttributesType{
        @AuraEnabled public String activationStatus;
    }
    public class communicationTypeCode{
        @AuraEnabled public String code;
    }
    public class electronicContacts{
        @AuraEnabled public string primaryElectronicAddressIndicator;
        @AuraEnabled public string electronicAddress;
        @AuraEnabled public undeliveredReasonTypeCode undeliveredReasonTypeCode;
    }
    public class undeliveredReasonTypeCode{
        @AuraEnabled public string desc_X;
    }
    public class preferences{
        @AuraEnabled public List<preferenceCategories> preferenceCategories;
    }
    public class preferenceCategories{
        @AuraEnabled public string name;
        @AuraEnabled public List<consumerPreferenceTypes> consumerPreferenceTypes;
        @AuraEnabled public List<preferenceCategories> preferenceCategories;
    }
    public class consumerPreferenceTypes{
        @AuraEnabled public string name;
        @AuraEnabled public List<properties> properties;
    }
    public class communicationTypeDescription{
        @AuraEnabled public string text;
    }
    public class properties{
        @AuraEnabled public string name;
        @AuraEnabled public List<listValues> listValues;
    }
    public class listValues{
        @AuraEnabled public string code;
        @AuraEnabled public boolean selected;
        @AuraEnabled public boolean isDefaultValue;
    }
    public static ADBEpmpPreferenceResponseWrapper parse(String json) {
        return (ADBEpmpPreferenceResponseWrapper) System.JSON.deserialize(json.replace('desc', 'desc_X'), ADBEpmpPreferenceResponseWrapper.class);
    }
}