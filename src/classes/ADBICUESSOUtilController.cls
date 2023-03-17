/** Created by Sai Kolluru on 07/02/2020 **/
public without sharing class ADBICUESSOUtilController {
    
    // Constant variables
    final static String APPLICATIONID = 'ACET';  
    final static String ISOFFERS = 'true';
    
    
    /** Created by Sai Kolluru on 07/02/2020 **/
    public static String generateRedirectUrl(String todoLink,String subscriberId,String cdbXrefId,String firstName, String lastName,String userId,String dob,String programICUESSOURL,String disposition,String nbaParentId){
        system.debug('in ADBICUESSOUtilController::generateRedirectUrl::todoLink'+todoLink+'::suscriberId'+subscriberId+'::firstname'+firstName+'::lastName'+lastName+'::userId'+userId+'::dob'+dob+'programICUESSOURL::'+programICUESSOURL+'disposition::'+disposition);
        String redirectUrl = '';
        String baseURL = '';
        String finalUrl = '';
        if(String.isEmpty(programICUESSOURL)){
            if(todoLink.equals('LAUNCH_NEW_PROG_DOC') && !String.isEmpty(nbaParentId)){
                redirectUrl = 'subscriberId={0}&firstName={1}&lastName={2}&userId={3}&dateOfBirth={4}&isOffers={5}&nbaToDoLink={6}&nbaStatus={7}&nbaParentId={8}';
                List<String> fillers = new String[]{subscriberId,firstName,lastName,userId,dob,ISOFFERS,todoLink,disposition,nbaParentId};    
                    redirectUrl = String.format(redirectUrl, fillers);   
            }else{
                redirectUrl = 'subscriberId={0}&firstName={1}&lastName={2}&userId={3}&dateOfBirth={4}&isOffers={5}&nbaToDoLink={6}&nbaStatus={7}';
                List<String> fillers = new String[]{subscriberId,firstName,lastName,userId,dob,ISOFFERS,todoLink,disposition};    
                    redirectUrl = String.format(redirectUrl, fillers);   
                
            }
        }else{
            if(String.isEmpty(disposition)){
                redirectUrl = programICUESSOURL;
                
            }else {
                redirectUrl = programICUESSOURL+'&nbaStatus='+disposition;    
            }
        }
        system.debug('in ADBICUESSOUtilController::generateRedirectUrl::redirectUrl after fillers'+redirectUrl);
        IcueRequest ir = new IcueRequest();
        ir.agentId = userId;
        ir.appId = 'ACET';
        String serializedBody = JSON.serialize(ir);
        baseURL = getBaseUrl(serializedBody,'ADBRiptideICUEUrl');
        if(!String.isEmpty(baseURL)){
            finalUrl = ACETURLEncryptionUtility.getEncryptedConsumerDashAPIURL(redirectUrl,baseURL);
        }
        system.debug('final url after encryption'+finalUrl);
        return finalUrl;
    }
    
    //getting the Base Url
    public static String getBaseUrl(String serializedBody,String webserviceConfigValue){
        String baseUrl = '';
        IcueSSOResponseWrapper isr = new IcueSSOResponseWrapper();
        try {
            ACET_WebserviceCalloutFramework wsCallOutFW = new ACET_WebserviceCalloutFramework(webserviceConfigValue,serializedBody,null);
            HttpResponse response = wsCallOutFW.getResponse(); 
            system.debug('response for Icue base url'+response.getBody());
            if(!String.isBlank(response.getBody()) && !webserviceConfigValue.equalsIgnoreCase('ADBVIewAddlAppealsLink')){
                isr = (IcueSSOResponseWrapper) JSON.deserialize(response.getBody(), IcueSSOResponseWrapper.class);
                baseUrl = isr.url;
                system.debug('base url after deserialize'+baseUrl);
            }else if(!String.isBlank(response.getBody()) && webserviceConfigValue.equalsIgnoreCase('ADBVIewAddlAppealsLink')){
                system.debug('webservice config string isADBVIewAddlAppealsLink::'+webserviceConfigValue);
                baseUrl = response.getBody();
                system.debug('base url after deserialize'+baseUrl);
            }
        }catch(Exception e){
            system.debug('ADBICUESSOUtilController.getBaseUrl Exception ::' + e.getMessage());
        }
        return baseUrl;
    }
    
    public class IcueRequest{
        public String agentId;
        public String appId;
    }
    
    public class IcueSSOResponseWrapper{
        public String url;
    }
    
    // This method is to be called for navigating to ICUE (HA SUmmary, Incentives tabs and few links in Tools andResources section)
    // This method needs to be called when the url parameter (excluding the ICUE Base url) is already constructed
    public static string generateUrlWithParams(String redirectUrl,String userId){
        String baseURL = '';
        String finalUrl = '';
        IcueRequest ir = new IcueRequest();
        ir.agentId = userId;
        ir.appId = 'ACET';
        String serializedBody = JSON.serialize(ir);
        baseURL = getBaseUrl(serializedBody,'ADBRiptideICUEUrl');
        if(!String.isEmpty(baseURL)){
            finalUrl = ACETURLEncryptionUtility.getEncryptedConsumerDashAPIURL(redirectUrl,baseURL);
        }
        system.debug('finalurl'+finalUrl);
        return finalUrl;
    }
}