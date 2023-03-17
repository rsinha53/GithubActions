/**
* Author: Sai Kolluru
* Description : Controller class to be used by Dahsboard-->Tools and Resources card to get data Urls for all external links
* AuraEnabled : True
* Date Created: 4/6/2020
*/

public without sharing class ADBToolsAndResourcesController {
    public class RIRequest{
        public String subscriberId;
        public String firstName;
        public String lastName;
        public String dob;
        public String userId;
        public String policy;
    }

    public class CLRequest{
        public String subscriberId;
        public String firstName;
        public String lastName;
        public String dob;
        public String agentId;
        public string clientName;

    }

    public class CLWrapper{
        @AuraEnabled
        public Boolean castLightIndicator{get;set;}
        @AuraEnabled
        public String clientName{get;set;}
        @AuraEnabled
        public String purchaseId{get;set;}
    }

    @AuraEnabled
    public static String getAvayaCallbackUrl (){
        ACETOrgNameToSwivelEndpointMap__c  url = [Select name,Swivel_Endpoint__c 
                                                  from ACETOrgNameToSwivelEndpointMap__c 
                                                  where name='ADBAvayaCallbackUrl']; 
        String wellnessDefUrl = String.valueOf(url.Swivel_Endpoint__c);
        System.debug(wellnessDefUrl);
        return wellnessDefUrl;
    }
    
    @AuraEnabled
    public static String getEviveUrl (){
        ACETOrgNameToSwivelEndpointMap__c  url = [Select name,Swivel_Endpoint__c 
                                                  from ACETOrgNameToSwivelEndpointMap__c 
                                                  where name='ADBMyEviveUrl']; 
        String wellnessDefUrl = String.valueOf(url.Swivel_Endpoint__c);
        System.debug(wellnessDefUrl);
        return wellnessDefUrl;
    }
    @AuraEnabled
    public static String getInitiateEngagementIntakeUrl (String subscriberId,String userId){
        String intakeUrl = '';
        List<ADBIcueSsoApiUrlParams__mdt> urlParams = [SELECT URL__c  
                                                FROM ADBIcueSsoApiUrlParams__mdt WHERE MasterLabel = 'EngagementIntakeUrl'];
        if(urlParams != null && !urlParams.isEmpty()){
            String prefilledUrl = urlParams[0].URL__c;
        	System.debug('prefilledUrl'+prefilledUrl);
            List<String> fillers = new String[]{subscriberId};   
            prefilledUrl = String.format(prefilledUrl, fillers);  
            intakeUrl = ADBICUESSOUtilController.generateUrlWithParams(prefilledUrl,userId);
        	return intakeUrl;
        }
        return intakeUrl;
    }
    
    @AuraEnabled
    public static String getICUEHomeUrl(String cdbXrefId,String userId){
        String icueHomeUrl = '';
        List<ADBIcueSsoApiUrlParams__mdt> urlParams = [SELECT URL__c  
                                                FROM ADBIcueSsoApiUrlParams__mdt WHERE MasterLabel = 'MemberPreferencesurl'];
        if(urlParams != null && !urlParams.isEmpty()){
            String prefilledUrl = urlParams[0].URL__c;
        	System.debug('prefilledUrl'+prefilledUrl);
            List<String> fillers = new String[]{cdbXrefId};    
            prefilledUrl = String.format(prefilledUrl, fillers);  
            icueHomeUrl = ADBICUESSOUtilController.generateUrlWithParams(prefilledUrl,userId);
        	return icueHomeUrl;
        }
        return icueHomeUrl;
    }
    
    @AuraEnabled
    public static String getICUEPolicyAdminUrl (String cdbXrefId,String userId){
        String icueUrl = '';
        List<ADBIcueSsoApiUrlParams__mdt> urlParams = [SELECT URL__c  
                                                FROM ADBIcueSsoApiUrlParams__mdt WHERE MasterLabel = 'ICUESAIUrl'];
        if(urlParams != null && !urlParams.isEmpty()){
            String prefilledUrl = urlParams[0].URL__c;
        	System.debug('prefilledUrl'+prefilledUrl);
            List<String> fillers = new String[]{cdbXrefId};    
            prefilledUrl = String.format(prefilledUrl, fillers);  
            icueUrl = ADBICUESSOUtilController.generateUrlWithParams(prefilledUrl,userId);
        	return icueUrl;
        }
        return icueUrl;
    }
    
    //New MyHealthDirect Method : Nadeem
    public class UrlRequestParams{
        public String userId;
        public String subject;
    }
    
    // New MyHealthDirect Method :- Nadeem
    @AuraEnabled
    public static String getMyHealthDirectUrl (String userId){
        String baseURL = '';
        UrlRequestParams mhd = new UrlRequestParams();
        mhd.userId = userId;
        mhd.subject = 'ACET';
        String serializedBody = JSON.serialize(mhd);
        baseURL = ADBICUESSOUtilController.getBaseUrl(serializedBody,'MyHealthDirectUrlEndpoint');
        return baseURL;
    }
    
    @AuraEnabled
    public static String getRallyCostEstimatorUrl (){
        ACETOrgNameToSwivelEndpointMap__c  url = [Select name,Swivel_Endpoint__c 
                                                  from ACETOrgNameToSwivelEndpointMap__c 
                                                  where name='ADBRallyCostEstimatorUrl']; 
        String wellnessDefUrl = String.valueOf(url.Swivel_Endpoint__c);
        System.debug(wellnessDefUrl);
        return wellnessDefUrl;
    }
    
    @AuraEnabled
    public static String getHealthMessageCenterUrl (){
        ACETOrgNameToSwivelEndpointMap__c  url = [Select name,Swivel_Endpoint__c 
                                                  from ACETOrgNameToSwivelEndpointMap__c 
                                                  where name='ADBHealthCenterUrl']; 
        String wellnessDefUrl = String.valueOf(url.Swivel_Endpoint__c);
        System.debug(wellnessDefUrl);
        return wellnessDefUrl;
    }
    
         @AuraEnabled
    public static String getThirdPartReferralUrl (){
        ACETOrgNameToSwivelEndpointMap__c  url = [Select name,Swivel_Endpoint__c 
                                                  from ACETOrgNameToSwivelEndpointMap__c 
                                                  where name='ADBThirdPartyReferralPortalUrl']; 
        String wellnessDefUrl = String.valueOf(url.Swivel_Endpoint__c);
        System.debug(wellnessDefUrl);
        return wellnessDefUrl;
    }
    //
          @AuraEnabled
    public static String getMyUhcSupervisorUrl (){
        ACETOrgNameToSwivelEndpointMap__c  url = [Select name,Swivel_Endpoint__c 
                                                  from ACETOrgNameToSwivelEndpointMap__c 
                                                  where name='ADBMyUHCSupervisor']; 
        String supervisorUrl = String.valueOf(url.Swivel_Endpoint__c);
        System.debug(supervisorUrl);
        return supervisorUrl;
    }
    // call Impersonation method: US2991937 - Sunil Vennam - Endpoints are pending
    @AuraEnabled
    public static String getRallyImpersonationUrl (String memberId, String userId, String firstname, String lastname, String memberDob, String policy){
        String baseURL = '';
        RIRequest ic = new RIRequest();
        ic.subscriberId = memberId;
        ic.firstName = firstname;
        ic.lastName = lastname;
        ic.dob = memberDob;
        ic.policy = policy; 
        ic.userId = userId;
        String serializedBody = JSON.serialize(ic);
        baseURL = ADBICUESSOUtilController.getBaseUrl(serializedBody,'ADBRallyImpersonationEndpoint');
        system.debug('base url for rally impersonation link'+baseURL);
        return baseURL;
    }

    @AuraEnabled
    public static CLWrapper getCastLightMetadata(String policy){
        List <ADB_Client_Mapping__mdt> url = [SELECT cast_light_indicator__c,client_name__c,purchase_id__c FROM ADB_Client_Mapping__mdt WHERE policy__c=:policy];

        CLWrapper clwrapper = new CLWrapper();

        if(!url.isEmpty()){
            clwrapper.castLightIndicator = url[0].cast_light_indicator__c;
            clwrapper.clientName = url[0].client_name__c;
            clwrapper.purchaseId = url[0].purchase_id__c;
        }
        return clwrapper;
    }

    @AuraEnabled
    public static String getCastLightUrl (String userId, String subscriberId, String firstname, String lastname, String memberDob, String clientname){
        String baseURL = '';
        CLRequest ic = new CLRequest();
        ic.subscriberId = subscriberId;
        ic.firstName = firstname;
        ic.lastName = lastname;
        ic.dob = memberDob;
        ic.agentId = userId;
        ic.clientName = clientname;
        String serializedBody = JSON.serialize(ic);
        baseURL = ADBICUESSOUtilController.getBaseUrl(serializedBody,'ADBCastLightSSOEndPointUrl');
        return baseURL;
    }
}