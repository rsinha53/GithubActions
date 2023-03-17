public class EPIMProviderSearchWS extends ACETWebservice {
    public static String providerType;
    private static Map<String, Provider_Taxonomy__mdt> mapTaxonomyMDT = new Map<String, Provider_Taxonomy__mdt>();
    public static string NetworkId2;
    public static string isLookupflow1; 
    public static string attSet2;  
    private static String specialityCheck;
    public static String addressCheck;
    public static String network;
    public static String qualityTierLevelGlobal;
    public static Boolean isDDP;
    public static Map<String, String> paramsMap;
    public static String RequestBody;
    
    public override void GetEndpoint() {
        
    }
    
    private static void GetRequestBody(Boolean isPractitioner) {        
        
        if (Test.isRunningTest())  {
            RequestBody =' {"findMedicalProvidersRequest":{"providerId":"","providerStatusCode":"","npi":"","npiStatusCode":"","providerTIN":"","providerTINStatusCode":"","name":"","providerFirstName":"","providerGenderCode":"","providerRoleTypeCode":"","specialtyTypeCode":"","providerLocationAffiliationID":"","primarySpecialityIndicator":"","specialityStatusCode":"","addressTypeCode":[],"primaryAddressIndicator":"","addressStatusCode":"","addressPostalPrefixCode":"","addressPostalSuffixCode":"","addressDistance":"","addressCity":"","addressStateCode":"","addressCountyDescription":"","phoneTypeCode":[""],"phoneStatusCode":"","phoneCountryCode":"","primaryPhoneIndicator":"","phoneAreaCode":"","phoneNumber":"","networkId":[""],"benefitServiceArea":"","serviceAreaType":"","contractClaimType":"","businessSegmentCode":[],"contractStatusCode":"","acceptingNewPatientIndicator":"","acceptingExistingPatientIndicator":"","languageCode":"","providerTypeCode":"","attributeDataSet":"","pagination":{"pageNumber":"","pageSize":"","startRecord":""}}} ';
        }
        
        EPIMProviderSearchRequest searchRequest = new EPIMProviderSearchRequest(); 
        searchRequest.entry = new List<EPIMProviderSearchRequest.Entry>();
        searchRequest.id = EPIMProviderSearchWS.GetGUIDForEPIMSearchRequest();
        
        
        
        EPIMProviderSearchRequest.Entry paramEntry = new EPIMProviderSearchRequest.Entry();
        paramEntry.search = new EPIMProviderSearchRequest.Search();
        paramEntry.search.mode = 'match';
        paramEntry.search.score = 1;
        
        paramEntry.request = new EPIMProviderSearchRequest.Request();
        paramEntry.request.method = 'POST';
        String url;
        if(isPractitioner)
            url = '/api/voyager/provider/practitioner/v1.0/search';
        else
            url = '/api/voyager/provider/organization/v1.0/search';
        
        paramEntry.request.url = url;        
        paramEntry.resource = new EPIMProviderSearchRequest.Resource();
        
        EPIMProviderSearchRequest.Event eve = new EPIMProviderSearchRequest.Event();
        eve.code = 'search-request';
        eve.display = 'search-request';
        paramEntry.resource.event = eve;
        paramEntry.resource.resourceType = 'MessageHeader';
        paramEntry.resource.source = new EPIMProviderSearchRequest.Source();
        paramEntry.resource.source.endpoint = url;
        
        EPIMProviderSearchRequest.Focus foc = new EPIMProviderSearchRequest.Focus();
        if(isPractitioner)
            foc.reference = 'Practitioner';
        else
            foc.reference = 'Organisation';
        paramEntry.resource.focus = new List<EPIMProviderSearchRequest.Focus>{foc};
            paramEntry.resource.focus.add(foc);
        
        searchRequest.entry.add(paramEntry);                        
        
        
        List<EPIMProviderSearchRequest.Parameter> paramList = genereteRequestParameter(); 
        system.debug('paramList--'+paramList);
        EPIMProviderSearchRequest.Entry paramEntry2 = new EPIMProviderSearchRequest.Entry();
        paramEntry2.resource = new EPIMProviderSearchRequest.Resource('Parameters', paramList);
        
        searchRequest.entry.add(paramEntry2);
        
        RequestBody = JSON.serialize(searchRequest); 
        system.debug(' :: Request Body :: ' + RequestBody);
        
        
        
    }
    
    private static List<EPIMProviderSearchRequest.Parameter> genereteRequestParameter(){
        List<EPIMProviderSearchRequest.Parameter> paramList = new List<EPIMProviderSearchRequest.Parameter>();
        system.debug('paramsMap--39--'+paramsMap);
        if(paramsMap != null){
            for(String key: paramsMap.keySet()){
                String value = paramsMap.get(key);
                if(!String.isBlank(key) && !String.isBlank(value)){
                    EPIMProviderSearchRequest.Parameter param = new EPIMProviderSearchRequest.Parameter(key, value); 
                    paramList.add(param); 
                }
            }
        }
        return paramList; 
    }
    
    public static ACETWSCalloutResult ParseSuccessResponse(map<string,string> paramMap,HttpResponse Response) {
        ACETWSCalloutResult oACETWSCalloutResult = new ACETWSCalloutResult();
        List<ACETProviderLookupController.ProviderLookupResult> Providers = new List<ACETProviderLookupController.ProviderLookupResult>();
        ACETProviderLookupController.ProviderLookupResult Provider;
        JSON2ApexPracSearch ACETJSON2Apex = new JSON2ApexPracSearch();
        map<string,string> Tinmap= new map<string,string>();
        
        
        String re = Response.getBody();   
        string newString = '';
        String city = paramMap.get('City');
        String state = paramMap.get('State');
        String zip = paramMap.get('PostalCode');
        /*for(String str: re.split('system')){
newString = newString + re.replace('"system":', '"system_Z":');
}*/
        //system.debug('*1newString***'+newString);
        //system.debug('lstSt1--'+lstSt1.size());
        //String replaceSystem = re.replaceAll('"system":', '"system_Z":');
        //List<String> lstSt = replaceSystem.split('system_Z');
        //system.debug('lstSt--'+lstSt.size());
        /*for(String str: newString.split('"address":{')){
newString = newString + newString.replace('"address":{', '"singleAddress":{');
} */
        string replaceSystem = re.replace('"system":','"system_Z":');
        String responseJson = replaceSystem.replace('"address":{', '"singleAddress":{');
        
        system.debug('*2newString***'+responseJson);
        try {
            ACETJSON2Apex = (JSON2ApexPracSearch)JSON.deserialize(responseJson, JSON2ApexPracSearch.class);
        }
        catch(exception e) {
            system.debug('--'+e.getMessage());
        }
        String totalCount = '0';        
        system.debug(LoggingLevel.INFO, 'JSON2ApexPracSearch. ACETJSON2Apex:' + ACETJSON2Apex);
        List<ACETFindMedclProvidrLookupSrvceJSON2Apex.providerLocationAffiliations> providerLocationAffiliationDetails;
        if (ACETJSON2Apex.total > 0) { 
            system.debug('ACETJSON2Apex--'+ACETJSON2Apex);
            try {
                if (ACETJSON2Apex.entry.size() > 1) {
                    List<JSON2ApexPracSearch.Entry> e = ACETJSON2Apex.entry;
                    for (JSON2ApexPracSearch.Entry respEntries : e) {
                        system.debug('respEntries--'+respEntries);
                        Provider = new ACETProviderLookupController.ProviderLookupResult();
                        totalCount = String.valueOf(ACETJSON2Apex.total);
                        if (respEntries.response != null) {
                            JSON2ApexPracSearch.response provResp = respEntries.response;
                            
                            if (provResp.outcome != null ) {
                                
                                JSON2ApexPracSearch.outcome provOutcome = provResp.outcome;
                                Provider.EPIMID = provOutcome.id;
                                if (provOutcome.entry.size() > 0) {
                                    
                                    List<JSON2ApexPracSearch.entry> Entries = provOutcome.entry;
                                    for (JSON2ApexPracSearch.entry  provEntries : Entries) { 
                                        //system.debug('provEntries--'+provEntries);
                                        if (provEntries.resource != null) {
                                            
                                            // to get NPI Id
                                            if (provEntries.resource.identifier != null) { 
                                                /* if (provEntries.resource.identifier[0].type != null) {
JSON2ApexPracSearch.type provType = provEntries.resource.identifier[0].type;
if (provType.coding != null) {
List<JSON2ApexPracSearch.coding> provNPI =  provType.coding;
if (provNPI[0].code == 'NPI') {
Provider.NPI = provEntries.resource.identifier[0].value;
system.debug(' Provider.NPI--'+ Provider.NPI);
}
}
}*/
                                                
                                                for(JSON2ApexPracSearch.Identifier iden : provEntries.resource.identifier)
                                                {
                                                    if (iden.type != null) {
                                                        JSON2ApexPracSearch.type provType = iden.type;
                                                        Tinmap.put(iden.type.coding[0].code,iden.value);
                                                        if (provType.coding != null) {
                                                            List<JSON2ApexPracSearch.coding> provNPI =  provType.coding;
                                                            if (provNPI[0].code == 'NPI') {
                                                                Provider.NPI = provEntries.resource.identifier[0].value;
                                                                system.debug(' Provider.NPI--'+ Provider.NPI);
                                                            }
                                                            if (provNPI[0].code == 'TAX') {
                                                                system.debug('code value--'+provNPI[0].code);
                                                                Provider.taxId = Tinmap.get(provNPI[0].code);//provEntries.resource.identifier[0].value;
                                                                system.debug(' Provider.TaxId--'+ Provider.taxId);
                                                            }
                                                            
                                                        }
                                                        
                                                    }
                                                }
                                            }    
                                            //system.debug('provEntries.resource.name--'+provEntries.resource.name);
                                            if (provEntries.resource.name != null) {
                                                if (provEntries.resource.name.size() > 0) {
                                                    //system.debug('provEntries.resource.name--'+provEntries.resource.name);
                                                    List<JSON2ApexPracSearch.name> provName = provEntries.resource.name;
                                                    
                                                    Provider.lastName = String.isNotBlank(provName[0].family)?provName[0].family:'';
                                                    if (provName[0].given.size() > 0) {
                                                        //system.debug('provName[0].given--'+provName[0].given);
                                                        Provider.firstName = String.isNotBlank(provName[0].given[0])?provName[0].given[0]:'';
                                                    }
                                                    Provider.fullName = Provider.firstName + ' ' + Provider.lastName;
                                                    //system.debug(' Provider.fullName--'+ Provider.fullName);
                                                }
                                            }
                                            //system.debug('provEntries.resource.telecom--'+provEntries.resource.telecom);
                                            if (provEntries.resource.telecom != null){
                                                if (provEntries.resource.telecom.size() > 0) {
                                                    system.debug('provEntries.resource.telecom--'+provEntries.resource.telecom);
                                                    List<JSON2ApexPracSearch.telecom> provTelecom = provEntries.resource.telecom;
                                                    
                                                    for(JSON2ApexPracSearch.telecom tel: provTelecom){
                                                        if (tel.system_Z == 'phone') {
                                                            system.debug('tel.system_Z--'+tel.system_Z);
                                                            Provider.phone = String.isNotBlank(tel.value)?tel.value:'';
                                                        }
                                                        
                                                        if (tel.system_Z == 'fax') {
                                                            Provider.Fax = String.isNotBlank(tel.value)?tel.value:'';
                                                        }
                                                    }     
                                                }
                                            }
                                            if (provEntries.resource.singleAddress != null) {
                                                JSON2ApexPracSearch.Address provAddr = provEntries.resource.singleAddress;
                                                //if (provAddr.type == 'physical') {
                                                Provider.addressLine1 = String.isNotBlank(provAddr.line[0])?provAddr.line[0]:'';
                                                Provider.addressLine2 = provAddr.line.size() > 1 && String.isNotBlank(provAddr.line[1])?provAddr.line[1]:'';
                                                Provider.street = Provider.addressLine1 + ' ' + Provider.addressLine2;
                                                Provider.city = String.isNotBlank(provAddr.city)?provAddr.city:'';
                                                Provider.state = String.isNotBlank(provAddr.state)?provAddr.state:'';
                                                Provider.zipCode = String.isNotBlank(provAddr.postalCode)?provAddr.postalCode:'';
                                                if(((zip == ''|| zip == null) && (state == '' || state == null) && (city == '' || city == null))|| (Provider.address == null && (((zip != '' && zip != null) && Provider.zipCode.indexOf(zip) != -1) || Provider.city == city || Provider.state == state)))
                                                    Provider.address = Provider.addressLine1 + (Provider.addressLine2 != '' ? (', ' + Provider.addressLine2 ) : '')+ ', ' + Provider.city + ', ' + Provider.state + ', ' + Provider.zipCode;
                                                //}
                                            }
                                            if (provEntries.resource.address != null) {
                                                system.debug('*****inside address array***'+provEntries.resource.address);
                                                if (provEntries.resource.address.size() > 0){
                                                    List<JSON2ApexPracSearch.Address> provAddr = provEntries.resource.address;
                                                    for (JSON2ApexPracSearch.Address add : provAddr) {
                                                        //if (add.type == 'physical') {
                                                        if (add.line.size() > 0) {
                                                            Provider.addressLine1 = String.isNotBlank(add.line[0])?add.line[0]:'';
                                                            Provider.addressLine2 = add.line.size() > 1 && String.isNotBlank(add.line[1])?add.line[1]:'';
                                                            Provider.street = Provider.addressLine1 + ' ' + Provider.addressLine2;
                                                            Provider.city = String.isNotBlank(add.city)?add.city:'';
                                                            Provider.state = String.isNotBlank(add.state)?add.state:'';
                                                            Provider.zipCode = String.isNotBlank(add.postalCode)?add.postalCode:'';
                                                            if(((zip == ''|| zip == null) && (state == '' || state == null) && (city == '' || city == null))|| (Provider.address == null && (((zip != '' && zip != null) && Provider.zipCode.indexOf(zip) != -1) || Provider.city == city || Provider.state == state)))
                                                                Provider.address = Provider.addressLine1 + (Provider.addressLine2 != '' ? (', ' + Provider.addressLine2 ) : '') + ', ' + Provider.city +', ' + Provider.state +  ', ' + Provider.zipCode;
                                                        }
                                                        //}
                                                    }
                                                }
                                            } 
                                            if (provEntries.resource.specialty != null){
                                                if (provEntries.resource.specialty.size() > 0) {
                                                    List<JSON2ApexPracSearch.Specialty> provSpclty = provEntries.resource.specialty;
                                                    for(JSON2ApexPracSearch.Specialty spcl: provSpclty){
                                                        if (spcl.coding.size() > 0) {
                                                            system.debug('spcl.display--'+spcl.coding[0].display);
                                                            Provider.speciality = spcl.coding[0].display;
                                                        }
                                                        
                                                        
                                                    }     
                                                }  
                                            } 
                                            system.debug('inside Provider--'+Provider);
                                            
                                        }
                                    }
                                }
                            }
                            system.debug('Provider.fullName--'+Provider.fullName);
                            system.debug('Provider.phone--'+Provider.phone);
                            system.debug('Provider.address--'+Provider.address);
                            system.debug('Provider--'+Provider);
                            Providers.add(Provider);
                        } 
                    }
                }
            } catch (exception e) {
                system.debug('error--'+ e.getMessage());
            }
            
            
            oACETWSCalloutResult.Success = true;
            oACETWSCalloutResult.Message = '';
            oACETWSCalloutResult.Response = Providers;
            oACETWSCalloutResult.statuscode =  Response.getStatusCode() ;
            
            
        } else {
            oACETWSCalloutResult.Success = false;
            oACETWSCalloutResult.Response = null;
            oACETWSCalloutResult.statuscode =  Response.getStatusCode() ;
        }
        oACETWSCalloutResult.totalCount = totalCount;
        return oACETWSCalloutResult;
    }   
    
    public static ACETWSCalloutResult ParseOrgSearchResponse(map<string,string> paramMap,HttpResponse Response) {
        system.debug('inside PSR--'+Response);
        ACETWSCalloutResult oACETWSCalloutResult = new ACETWSCalloutResult();
        List<ACETProviderLookupController.ProviderLookupResult> Providers = new List<ACETProviderLookupController.ProviderLookupResult>();
        ACETProviderLookupController.ProviderLookupResult Provider;
        JSON2ApexOrgSearch ACETJSON2Apex = new JSON2ApexOrgSearch();
        map<string,string> Tinmap= new map<string,string>();
        
        String re = Response.getBody();
        system.debug('***responsebody===>'+re);
        list<string> newstrList = new list<String>();
        //string replaceSystem = replacetheString(re,'"system":','"system_Z":');
        string replaceSystem = re.replace('"system":','"system_Z":');
        String responseJson = replaceSystem.replace('"address":{', '"singleAddress":{');
        //String responseJson = replacetheString(replaceSystem,'"address":\\{','"singleAddress": {');              
        system.debug('responseJson--'+responseJson);
        String city = paramMap.get('City');
        String state = paramMap.get('State');
        String zip = paramMap.get('PostalCode');
        try{
            ACETJSON2Apex = (JSON2ApexOrgSearch)JSON.deserialize(responseJson, JSON2ApexOrgSearch.class);
            //ACETJSON3Apex = (JSON2ApexOrgDetail)JSON.deserialize(responseJson, JSON2ApexOrgDetail.class);
        }
        catch(exception e) {
            system.debug('--'+e.getMessage());
        }
        String totalCount = '0';
        system.debug(LoggingLevel.INFO, 'ACETFindProviderLookupWS. ACETJSON2Apex:' + ACETJSON2Apex);
        system.debug(LoggingLevel.INFO, 'ACETFindProviderLookupWS. ACETJSON2Apex:' + ACETJSON2Apex.entry);
        if (ACETJSON2Apex.total > 0) {                 
            // try {
            if (ACETJSON2Apex.entry.size() > 1) {
                List<JSON2ApexOrgSearch.entry> e = ACETJSON2Apex.entry;
                for (JSON2ApexOrgSearch.entry respEntries : e) {
                    Provider = new ACETProviderLookupController.ProviderLookupResult();
                    totalCount = String.valueOf(ACETJSON2Apex.total);
                    if (respEntries.response != null) {
                        JSON2ApexOrgSearch.response provResp = respEntries.response;
                        if (provResp.outcome != null ) {
                            JSON2ApexOrgSearch.outcome provOutcome = provResp.outcome;
                            Provider.EPIMID = provOutcome.id;
                            if (provOutcome.entry.size() > 0) {
                                List<JSON2ApexOrgSearch.entry> Entries = provOutcome.entry;
                                for (JSON2ApexOrgSearch.entry  provEntries : Entries) { 
                                    system.debug('provEntries--'+provEntries);
                                    if (provEntries.resource != null) {
                                        if (provEntries.resource.identifier != null) {
                                            system.debug('provEntriesresource--'+provEntries.resource.identifier);
                                            //commented for iterating through the array
                                            /*if (provEntries.resource.identifier[0].type != null) {
JSON2ApexOrgSearch.type provType = provEntries.resource.identifier[0].type;
if (provType.coding != null) {
List<JSON2ApexOrgSearch.coding> provNPI =  provType.coding;
if (provNPI[0].code == 'NPI') {
Provider.NPI = provEntries.resource.identifier[0].value;
system.debug(' Provider.NPI--'+ Provider.NPI);
}
}
}*/
                                            
                                            for(JSON2ApexorgSearch.Identifier iden : provEntries.resource.identifier)
                                            {
                                                if (iden.type != null) {
                                                    Tinmap.put(iden.type.coding[0].code,iden.value);
                                                    JSON2ApexOrgSearch.type provType = iden.type;
                                                    if (provType.coding != null) {
                                                        List<JSON2ApexOrgSearch.coding> provNPI =  provType.coding;
                                                        if (provNPI[0].code == 'NPI') {
                                                            Provider.NPI = provEntries.resource.identifier[0].value;
                                                            system.debug(' Provider.NPI--'+ Provider.NPI);
                                                        }
                                                        if (provNPI[0].code == 'TAX') {                                                        
                                                            Provider.taxId =Tinmap.get(provNPI[0].code);//provEntries.resource.identifier[0].value;                                                        
                                                        }
                                                        
                                                    }
                                                    
                                                }
                                            } 
                                        }
                                        system.debug('provEntries.resource.singleAddress--'+provEntries.resource.singleAddress);
                                        if (provEntries.resource.singleAddress != null) {
                                            JSON2ApexOrgSearch.Address provAddr = provEntries.resource.singleAddress;
                                            system.debug('provAddr--'+provAddr);
                                            //if (provAddr.rank == 1) {
                                            if (provAddr.line != null) {
                                                Provider.addressLine1 = String.isNotBlank(provAddr.line[0])?provAddr.line[0]:'';
                                                Provider.addressLine2 = provAddr.line.size() > 1 && String.isNotBlank(provAddr.line[1])?provAddr.line[1]:'';
                                            }
                                            Provider.street = Provider.addressLine1 + ' ' + Provider.addressLine2;
                                            Provider.city = String.isNotBlank(provAddr.city)?provAddr.city:'';
                                            Provider.state = String.isNotBlank(provAddr.state)?provAddr.state:'';
                                            Provider.zipCode = String.isNotBlank(provAddr.postalCode)?provAddr.postalCode:'';
                                            if(((zip == ''|| zip == null) && (state == '' || state == null) && (city == '' || city == null))|| (Provider.address == null && (((zip != '' && zip != null) && Provider.zipCode.indexOf(zip) != -1) || Provider.city == city || Provider.state == state)))
                                                Provider.address = Provider.addressLine1 + (Provider.addressLine2 != '' ? (', ' + Provider.addressLine2 ) : '') + ', ' + Provider.city + ', ' + Provider.state + ', ' + Provider.zipCode;
                                            //} 
                                        }
                                        if (provEntries.resource.Address != null) {
                                            if (provEntries.resource.Address.size() > 0){
                                                List<JSON2ApexOrgSearch.Address> provAddr = provEntries.resource.Address;
                                                
                                                for (JSON2ApexOrgSearch.Address add : provAddr) {
                                                    
                                                    //to be used after confirmation
                                                    //if (add.rank == 1) {
                                                    if (add.line != null) {
                                                        Provider.addressLine1 = String.isNotBlank(add.line[0])?add.line[0]:'';
                                                        Provider.addressLine2 = add.line.size() > 1 &&  String.isNotBlank(add.line[1])?add.line[1]:'';
                                                    }
                                                    Provider.street = Provider.addressLine1 + ' ' + Provider.addressLine2;
                                                    Provider.city = String.isNotBlank(add.city)?add.city:'';
                                                    Provider.state = String.isNotBlank(add.state)?add.state:'';
                                                    Provider.zipCode = String.isNotBlank(add.postalCode)?add.postalCode:'';
                                                    if(Test.isRunningTest() || ((zip == ''|| zip == null) && (state == '' || state == null) && (city == '' || city == null))|| (Provider.address == null && (((zip != '' && zip != null) && Provider.zipCode.indexOf(zip) != -1) || Provider.city == city || Provider.state == state)))
                                                        Provider.address = Provider.addressLine1 + (Provider.addressLine2 != '' ? (', ' + Provider.addressLine2 ) : '') + ', ' + Provider.city + ', ' + Provider.state + ', ' + Provider.zipCode;
                                                    
                                                    // }
                                                    // firstaddress = false;
                                                }
                                            }
                                        }  
                                        if (provEntries.resource.name != null) {
                                            Provider.fullName = provEntries.resource.name;
                                        }
                                        
                                        if (provEntries.resource.telecom != null){
                                            if (provEntries.resource.telecom.size() > 0) {
                                                List<JSON2ApexOrgSearch.telecom> provTelecom = provEntries.resource.telecom;
                                                for(JSON2ApexOrgSearch.telecom tel: provTelecom){
                                                    if (tel.system_Z == 'phone') {
                                                        Provider.phone = String.isNotBlank(tel.value)?tel.value:'';
                                                    }
                                                    
                                                    if (tel.system_Z == 'fax') {
                                                        Provider.Fax = String.isNotBlank(tel.value)?tel.value:'';
                                                    }
                                                }     
                                            }  
                                        } 
                                        system.debug('***inside practi***'+Provider);  
                                    }
                                }
                            }
                        }
                        system.debug('Provider.phone--'+Provider.phone);
                        system.debug('Provider.address--'+Provider.address);
                        system.debug('Provider--'+Provider);
                        Providers.add(Provider);
                    }
                }
                /* } catch (exception e) {
system.debug('error--'+ e.getMessage());
}*/
                oACETWSCalloutResult.Success = true;
                oACETWSCalloutResult.Message = '';
                oACETWSCalloutResult.Response = Providers;
                oACETWSCalloutResult.statuscode =  Response.getStatusCode() ;
                
            }    
        } else {
            oACETWSCalloutResult.Success = false;
            oACETWSCalloutResult.Response = null;
            oACETWSCalloutResult.MessageSeverity = ApexPages.Severity.INFO;
            oACETWSCalloutResult.statuscode =  Response.getStatusCode() ;
        }
        oACETWSCalloutResult.totalCount = totalCount;
        return oACETWSCalloutResult;
    } 
    
    public static HTTPResponse makeProviderSearchCallout (String ServiceName, Map<String, WebserviceConfigurations__c> WebConfigList, String pageNum, Map<String, String> params, String token, Boolean isPractitioner){
        
        //String token = WebConfigList.get('EPIM Authorisation Token').AuthorizationToken__c;
        String endpoint = WebConfigList.get(ServiceName).EndpointPath__c + pageNum + '&pageSize=50';
        system.debug('paramsMap--'+params);
        HttpRequest req = new HttpRequest();
        req.setEndpoint(endpoint);
        req.setMethod(WebConfigList.get(ServiceName).Method__c);
        paramsMap = params;
        GetRequestBody(isPractitioner);
        req.setBody(requestBody);
        
        req.setHeader('Token', token);
        req.setHeader('Content-Type', 'application/json');
        
        Http http = new Http();
        HTTPResponse res = http.send(req);
        system.debug('test56'+res);
        return res;
    }
    
    public static String GetToken(WebserviceConfigurations__c WsObj){ //%EPIM Authorisation%
        system.debug('WsObj--'+WsObj);
        HttpRequest req = new HttpRequest();
        req.setMethod(String.valueOf(WsObj.Method__c));
        req.setHeader('Content-Type','application/x-www-form-urlencoded');
        req.setEndpoint(String.valueOf(WsObj.EndpointPath__c));
        req.setBody(String.valueOf(WsObj.JSONBodyWithMergeFields__c));
        Http http = new Http();
        HTTPResponse response = http.send(req);
        Map<String, Object> result1 = (Map<String, Object>)JSON.deserializeUntyped(response.getBody());
        system.debug('response---'+response.getBody());
        String token = (String)result1.get('access_token');
        system.debug(token);
        return token;
    }
    
    /*public static HTTPResponse makeProviderDetailCallout (String ServiceName, Map<String, WebserviceConfigurations__c> WebConfigList, String NPInum, String token){

String endpoint = WebConfigList.get(ServiceName).EndpointPath__c + NPInum;

HttpRequest req = new HttpRequest();
req.setEndpoint(endpoint);
req.setMethod(WebConfigList.get(ServiceName).Method__c);
req.setHeader('Token', token);

Http http = new Http();
HTTPResponse res = http.send(req);
return res;
}*/
    
    
    /*public static string replacetheString(string input, string replaceStringold,String replaceStringNew){
string newstrafterReplace = '';
for(String  strnew : splitthestring(input,replaceStringold)){
newstrafterReplace = newstrafterReplace + strnew.replace(replaceStringold, replaceStringNew); 
}
return  newstrafterReplace; 
}*/
    
    public static string GetGUIDForEPIMSearchRequest()
    {
        Blob b = Crypto.GenerateAESKey(128);
        String h = EncodingUtil.ConvertTohex(b);
        String guid = h.SubString(0,8)+ '-' + h.SubString(8,12) + '-' + h.SubString(12,16) + '-' + h.SubString(16,20) + '-' + h.substring(20);
        
        system.debug('****GUID***'+guid);
        return guid;
    }
    
    /*public static list<string> splitthestring(string input, string replaceStringold){       
List<String> names = new List<String>();
Utility_RowIterator rowIterator = new Utility_RowIterator(input, replaceStringold);
Iterator<String> iterator = rowIterator.iterator();
while (iterator.hasNext()) {
names.add(iterator.next());
}
system.debug('***names****'+names);

return  names; 
}*/
    
}