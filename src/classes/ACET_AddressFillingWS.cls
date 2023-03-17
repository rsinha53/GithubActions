public class ACET_AddressFillingWS {

    public ACETWSCalloutResultAddress getClaimAddressWS(String transactionId){
       
        ACETWSCalloutResultAddress calloutResult = new ACETWSCalloutResultAddress();
        String responseStr = '';
        
        Map<String, String> reqPramsMap = new Map<String, String>();
        
            ACET_WebserviceCalloutFramework wsCallOut = new ACET_WebserviceCalloutFramework();
        
            wsCallOut.serviceName = 'LinkAdditionalMemberInfo';
            reqPramsMap.put('transactionId',transactionId );
            wsCallOut.requestParamsMap = reqPramsMap;
           
            HttpResponse response = wscallout.getResponse(); 
        system.debug('Enter ACET_AddressFillingWS 3');
            
            system.debug('ResponseBody 4** ' + responseStr);
        	if(response.getStatusCode() == 200){
                 responseStr = response.getBody();
                if(responseStr != null && String.isNotBlank(responseStr)){
                    
                    ACET_AddressFillingJSON2Apex json2Apex = ACET_AddressFillingJSON2Apex.parse(responseStr);
                     if(json2Apex != null){
                         
                         calloutResult.city= json2Apex.ClaimMailingAddress.city;
                         calloutResult.state= json2Apex.ClaimMailingAddress.state;
                         calloutResult.street1= json2Apex.ClaimMailingAddress.street1;
                         calloutResult.street2= json2Apex.ClaimMailingAddress.street2;
                         calloutResult.zip= json2Apex.ClaimMailingAddress.zip;
                         calloutResult.zip4= json2Apex.ClaimMailingAddress.zip4;
                         calloutResult.originalEffectiveDate = json2Apex.originalEffectiveDate;
                         
                     }
                    
                }
            }
        
        
       return calloutResult; 
    }
    
    
    
    
}