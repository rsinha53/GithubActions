Public class ETSBE_GetFDSFileWebservice{
    public static String FDSendpoint;
    
    @AuraEnabled
    Public static string fetchFDSFile( string fileID){
        string signedurl;
        Map<String,ISL_Webservice_Config__c> WSConfigurations = ISL_Webservice_Config__c.getAll();
        system.debug('////inside////'+FDSendpoint );
        Map<String, ACETOrgInstanceURLToOrgNameMap__c> OrgInstance2OrgNameMap = ACETOrgInstanceURLToOrgNameMap__c.getAll();
        String  OrgName = Test.isRunningTest() ? 'dev' : ACETUtility.GetOrgName(OrgInstance2OrgNameMap);
        if(WSConfigurations.containsKey(OrgName + '_GetFDSSignedURLEndpoint')){
            FDSendpoint = WSConfigurations.get(OrgName + '_GetFDSSignedURLEndpoint').Value__c; //50f766e3-c685-4e7d-a7d6-423c76b24cd5
        }
        system.debug('////////'+FDSendpoint );
        ETSBE_FDSApiOAuthWebservice oAuth = new ETSBE_FDSApiOAuthWebservice();
        
        String AccessToken = oAuth.GetAccessToken();
        HttpRequest datareq =new HttpRequest();
        datareq.setHeader('Content-Type','multipart/form-data');
        
        datareq .setEndpoint(FDSendpoint +fileID+'/presignedurl?expires=6000');
        datareq.setHeader('Authorization','Bearer '+AccessToken );
        datareq .setMethod('GET');
        
        Http datahttp =new Http();
        HTTPResponse urlres = datahttp.send(datareq );
        system.debug('.........urlres...........'+urlres.getbody());
        if (urlres.getStatusCode() == 200) {
            Map<String, Object> mapOAuthResponse = (Map<String, Object>)JSON.deserializeUntyped(urlres.getBody());
            system.debug('.........mapOAuthResponse ...........'+mapOAuthResponse );
            if (mapOAuthResponse.containsKey('presignedUrl')) {    
                signedurl = (String)mapOAuthResponse.get('presignedUrl'); 
            }    
        }
        return signedurl;
    }
    
    
    
}