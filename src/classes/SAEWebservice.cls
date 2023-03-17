/*
    Created By: Avish Pagote
    Created Date: 29th March 2019
    Description: Base class for all webservices class. Contains functionality for preparing endpoint, populate http headers, generate request, send request
                and parse failure response both synchronous and asynchronous webservice calls.
*/

public class SAEWebservice {
        static Map<String, ISL_Webservice_Config__c> WSConfigurations;
    
    Public static HttpResponse makeCallout(String requestBody, String endpoint, String requestMethod)
    {
        WSConfigurations = ISL_Webservice_Config__c.getAll();
        
        String Response;
        HttpResponse Res;
        
        HttpRequest Req = new HttpRequest();
        system.debug(LoggingLevel.INFO,'endpoint@@@ ' + endpoint);
        String url = endpoint + requestBody;
        Req.setEndpoint(url);
        Req.setMethod(requestMethod);
        //Req.setBody(requestBody);
        Req.setTimeout(12000);
        for(String str: WSConfigurations.keySet()){
            if (WSConfigurations.containsKey('ISLOAuthContentType')){
                Req.setHeader('Content-Type', WSConfigurations.get('ISLOAuthContentType').Value__c);
            }           
        }
        List<Token_Generation__c> acessTokenRec = [SELECT id,name,Token_Name__c,Value__c FROM Token_Generation__c WHERE Token_Name__c = 'ISLConAccessToken'];
        //Req.setHeader('authorization', 'Bearer '+WSConfigurations.get('ISLConAccessToken').Value__c);
        if(acessTokenRec != null && acessTokenRec.size() > 0)
            if(String.isNotBlank(acessTokenRec[0].Value__c))
        		Req.setHeader('authorization', 'Bearer '+ acessTokenRec[0].Value__c);

        system.debug('RequestBody is '+Req);
        Http H = new Http();
        
        Res = H.send(Req);
        system.debug('Res is '+Res);
        
        return Res;
    }

    //Make Post Callout
    /*Public static HttpResponse makePostCallOut(String requestBody, String endpoint) {
        WSConfigurations = ISL_Webservice_Config__c.getAll();
        String Response;
        HttpResponse Res;
        HttpRequest Req = new HttpRequest();
        Req.setEndpoint(endpoint);
        Req.setMethod('POST');
        Req.setBody(requestBody);
        Req.setTimeout(12000);
        Req.setHeader('Content-Type', 'application/json');
        Req.setHeader('authorization', 'Bearer '+ WSConfigurations.get('SAEAPIAccessToken').Value__c);
        Http H = new Http();
        Res = H.send(Req);
        return Res;
    }*/
    
        //Method to dynamically formed the Query String
    public static String formQueryString(List<String> strLst){
        String resultQuery = '?';
        //US2034277 : TECH - Eligibility V2 Request Changes : START
        //resultQuery += 'searchOption=' + strLst[0] + '&firstName='+strLst[1] + '&lastName='+strLst[2] + '&payerID=' + strLst[3] + '&providerLastName=' + strLst[4] + '&providerFirstName=' + strLst[5] + '&npi=' + strLst[6] + '&dateOfBirth=' + strLst[7] + '&groupNumber=' + strLst[8] + '&memberId='+strLst[9] + '&serviceStart=' + strLst[10] + '&serviceEnd='+ strLst[11] ;
        resultQuery += 'searchOption=' + strLst[0] + '&firstName='+strLst[1] + '&lastName='+strLst[2] + '&payerID=' + strLst[3] + '&providerLastName=' + strLst[4] + '&providerFirstName=' + strLst[5] + '&dateOfBirth=' + strLst[6] + '&groupNumber=' + strLst[7] + '&memberId='+strLst[8] + '&serviceStart=' + strLst[9] + '&serviceEnd='+ strLst[10] + '&taxIdNumber='+ strLst[11] + '&providerNameID=' + strLst[12];
        //US2034277 : TECH - Eligibility V2 Request Changes : END
        return resultQuery;
    }
}