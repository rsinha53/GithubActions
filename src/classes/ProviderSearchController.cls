public class ProviderSearchController {
    public static Map<String, WebserviceConfigurations__c> mapWebserviceConfig = new Map<String, WebserviceConfigurations__c>();
    public static Map<String, String> paramsMap {get;set;}
    public static String token;
     
    @AuraEnabled
    public static ACETWSCalloutResult searchProvider (List<Map<String,Object>> searchParams, String pageNumber, Boolean isPractitioner ) {
        String ServiceName;
        String pn = String.valueOf(pageNumber); 
        list<Provider_Association__c> PaList= new list<Provider_Association__c>();
        ACETWSCalloutResult oACETWSCalloutResult = new ACETWSCalloutResult();
        getWebserviceConfigurationMap ();
        WebserviceConfigurations__c authWebConfig = mapWebserviceConfig.get('EPIM Authorisation Token');
        token = EPIMProviderSearchWS.GetToken(authWebConfig);
        
        if (isPractitioner == false) {
            ServiceName = 'EPIM Search Organisation';
        } else {
            ServiceName = 'EPIM Search Practitioner';
        }

        map<string,string> paramMap= new  map<string,string>();
        for(Map<String,Object> paramdata:searchParams){          
            for(string st:paramdata.keyset()){
                String st2;
                st2 = (st == 'ZipCode') ? 'PostalCode':st;
                st2 = (st == 'PhoneNumber') ? 'Phone':st2; 
                st2 = (st == 'Name') ? 'OrgName':st2;
                st2 = (st == 'TIN') ? 'TAX_LOCATION':st2;
                paramMap.put(st2,string.valueof(paramdata.get(st)));
            }            
        }
        try {
            //EPIMProviderSearchWS.GetRequestBody(isPractitioner);
            HttpResponse searchResp = EPIMProviderSearchWS.makeProviderSearchCallout(ServiceName, mapWebserviceConfig, pn, paramMap, token, isPractitioner);
            //iterating through all TAX parameters in case of 404 status code
            if (paramMap.containskey('TAX_LOCATION') && searchResp.getStatusCode() == 404) {
                paramMap.remove('TAX_LOCATION');
                for(Map<String,Object> paramdata:searchParams){          
                    for(string st:paramdata.keyset()){
                        String st2 = st;
                        st2 = (st == 'TIN') ? 'TAX':st2;
                        paramMap.put(st2,string.valueof(paramdata.get(st)));
                    }            
                }
                searchResp = EPIMProviderSearchWS.makeProviderSearchCallout(ServiceName, mapWebserviceConfig, pn, paramMap, token, isPractitioner);
            }
            
            
            if (searchResp.getStatusCode() == 200 || searchResp.getStatusCode() == 400) {
                if (isPractitioner == true)
                    oACETWSCalloutResult = EPIMProviderSearchWS.ParseSuccessResponse(paramMap,searchResp);
                else 
                    oACETWSCalloutResult = EPIMProviderSearchWS.ParseOrgSearchResponse(paramMap,searchResp);
                oACETWSCalloutResult.statuscode =   searchResp.getStatusCode() ;      
            }
            else
            {
                oACETWSCalloutResult.statuscode =   searchResp.getStatusCode() ;  
                oACETWSCalloutResult.Message =   searchResp.getBody() ;   
            }
        } catch (exception e) {
            oACETWSCalloutResult.statuscode =   500 ;  
            oACETWSCalloutResult.Message =   e.getMessage() ; 
            Application_Error_Log__c appErrorLog = ACETUtility.CreateApplicationErrorLog(ServiceName, 'EPIM', mapWebserviceConfig.get(ServiceName).EndpointPath__c, oACETWSCalloutResult.Message, oACETWSCalloutResult.statuscode);
            insert appErrorLog;    
        }
        
        return oACETWSCalloutResult;
    }
    
    public static void getWebserviceConfigurationMap () {
        String qrystr = '%EPIM%';
        List<WebserviceConfigurations__c> webserviceConfig = [SELECT Id, Name, AuthorizationToken__c, EndpointPath__c, Headers__c, 
                                                              JSONBodyWithMergeFields__c, Method__c, Timeout__c, E400__c, E401__c, 
                                                              E500__c, TokenAPI__r.Name, TokenAPI__r.IsCachedToken__c, Handle_Unauthorized__c 
                                                              FROM WebserviceConfigurations__c Where Name LIKE : qrystr and active__c = true];
        
        for (WebserviceConfigurations__c wsc : webserviceConfig) {
            if (wsc.Name != null) {
                mapWebserviceConfig.put(wsc.Name, wsc);
            }
        }
    }
     @AuraEnabled
    public static string createAssociateRecords(List<Map<String,Object>> selectedRecords, String ParentId) {
        Case cs;
        
        list<Provider_Association__c> PaList= new list<Provider_Association__c>();
        String NPIId;
        
        for(Map<String,Object> res: selectedRecords){
            NPIId = string.valueof(res.get('NPI'));
        }

        list<Provider__c> prlst = new list<Provider__c>();
       // [SELECT Id,NPI__c FROM Provider__c WHERE NPI__c =:NPIId Limit 1];
        if(selectedRecords.size() > 0){
        Map<String,Object> res = selectedRecords[0];
            Provider__c pr= new Provider__c();
            pr.Name=string.valueof(res.get('Name'));
            pr.Address__c = string.valueof(res.get('Address'));
            pr.City__c = string.valueof(res.get('City'));
            pr.Phone__c=string.valueof(res.get('Phone'));
            pr.NPI__c = string.valueof(res.get('NPI'));
            pr.Specialty__c = string.valueof(res.get('Speciality'));
            pr.State__c = string.valueof(res.get('State'));
            pr.Zip_Code__c = string.valueof(res.get('Zipcode'));
            pr.TIN__c=string.valueof(res.get('Tin'));
            pr.EPIM_Id__c = string.valueOf(res.get('EPIMID'));
            prlst.add(pr);
        }
        if(prlst.size()>0){
            upsert prlst EPIM_Id__c;
        }
        
        if(ParentId != null && ParentId.startsWith('500')){
           cs=[select Id,AccountId from case where id=:ParentId];
        }
        
        for(Map<String,Object> res: selectedRecords){
            Provider_Association__c ps=new Provider_Association__c();
            ps.Name=string.valueof(res.get('Name'));
            ps.Address__c=string.valueof(res.get('Address'));
            ps.Phone__c=string.valueof(res.get('Phone'));
            ps.TIN__c=string.valueof(res.get('Tin'));
            ps.Specialty__c = string.valueof(res.get('Speciality'));
            
            ps.Case__c= ParentId != null && ParentId.startsWith('500') ? cs.id : ps.Case__c;
            ps.Provider__c = prlst[0].id;
            ps.Account__c= ParentId != null && ParentId.startsWith('500') ? cs.AccountId : (ParentId != null && ParentId.startsWith('001')? ParentId: ps.Account__c);
            ps.Provider_Association_Id__c = ParentId != null && ParentId.startsWith('500') ? (cs.Id + ''+ ps.Provider__c) : (ParentId != null && ParentId.startsWith('001')? (ParentId +''+ ps.Provider__c): ps.Provider_Association_Id__c);
            PaList.add(ps);
        }
        if(PaList.size()>0){
            upsert PaList Provider_Association_Id__c;
        } 
        
    return 'success' ;      
        
    }
    
   /* @AuraEnabled(cacheable=true)
    public static ACETWSCalloutResult getsearchResults(List<Map<String,Object>> paramsMap) {
        system.debug('data--'+paramsMap);
        map<string,string> paramMap= new  map<string,string>();
        //ACETWSCalloutResult oACETWSCalloutResult = new ACETWSCalloutResult();
        for(Map<String,Object> paramdata:paramsMap){            
            for(string st:paramdata.keyset()){
                system.debug('st---'+st);
                paramMap.put(st,string.valueof(paramdata.get(st)));
            }            
        }
        
        ProviderSearchController.providerSearchParams wrapper= new ProviderSearchController.providerSearchParams();
        ACETWSCalloutResult oACETWSCalloutResult = new ACETWSCalloutResult();       
       
        oACETWSCalloutResult=searchProvider(paramsMap,'0',True);
        system.debug('responsedata'+oACETWSCalloutResult.Response);
       
           return oACETWSCalloutResult;
    }*/

    public class providerSearchParams {
        public String OrgName {  get; set; }
        public String City {  get; set; }
        public String State {  get; set; }
        public String PostalCode {  get; set; }
        public String LastName {  get; set; }
        public String FirstName{  get; set; }
        public String Phone {  get; set; }
        public String TIN {  get; set; }
        public String Address {  get; set; }
    }
    
}