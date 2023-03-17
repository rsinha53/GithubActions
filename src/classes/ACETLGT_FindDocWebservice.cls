public class ACETLGT_FindDocWebservice extends ACETWebservice{
    public String documentType;
    public List<documentKey> DocumentKeys;
    
    public class documentKey
    {
        @AuraEnabled public String name{get;set;}
        @AuraEnabled public String value{get;set;}
        @AuraEnabled public String dataTypeIndicator{get;set;}
        @AuraEnabled public String operator{get;set;}
    }
    
    public override void GetEndpoint(){
        GetEndpointDetail('FindDocument');
    }
    public override void GetMethod(){
        Method = 'POST';
    }
    public ACETLGT_FindDocWebservice() {
        super('Stargate');
    }  
    public override void GetHeaders(ISL_Webservice_Config__c OAuthConfig){
        if (WSConfigurations.containsKey('OILHttpHeaderAccept')){
            Headers.put('accept',WSConfigurations.get('OILHttpHeaderAccept').Value__c );
        }
        if (WSConfigurations.containsKey('OILHttpHeaderScope')){
            Headers.put('scope', WSConfigurations.get('OILHttpHeaderScope').Value__c);
        }
        if (WSConfigurations.containsKey('OILHttpHeaderActor')){
            Headers.put('actor', WSConfigurations.get('OILHttpHeaderActor').Value__c);
        }
        
        Headers.put('Content-Type', 'application/json;charset=UTF-8');
        system.debug('OAuthConfig.Value__c is '+OAuthConfig.Value__c);
        Headers.put('authorization', 'Bearer ' + OAuthConfig.Value__c);
        system.debug('!!!documentType'+documentType);
        if(documentType == 'IDCARDS')
        {
            system.debug('!!!inside');
            Headers.put('userName', 'oil_docu_1');
            
        }
        else
        {
            String userFederationId = ACETProviderUtility.getFederationIDByUserID();
            if(!String.isEmpty(userFederationId)){
                Headers.put('userName', userFederationId);  
            }
        }
        
        
    }
    public void GetRequestBodyIdCards(){
        
        system.debug( 'Inside request');
        String RequestTemplate = '~ "findDocumentsRequest": ~ "findDocumentsRequestType": ~ "repositoryId": "FISERV", "repositoryName": "", "documentClass": "IDCARDS", "documentKeys": ~ "documentKey": [{1}] } } } }';
        String DocKeyTemplate = '~"name": "{0}", "value": "{1}"}';
        String DocumentKeysTemplate = '';
        Integer DocKeysIndex = 0;
        for (DocumentKey docKey :DocumentKeys) {
            if (DocKeysIndex > 0) DocumentKeysTemplate += ', ';
            DocumentKeysTemplate += String.format(DocKeyTemplate, new String[] {docKey.name, docKey.value});
            system.debug(LoggingLevel.INFO, 'DocumentKeysTemplate: ' + DocumentKeysTemplate);
            DocKeysIndex++;
        }
        system.debug(LoggingLevel.INFO, 'documentType: '+ documentType);
        RequestBody = String.format(RequestTemplate, new String[] {documentType, DocumentKeysTemplate});
        
        RequestBody = RequestBody.replaceAll('~', '{');
        system.debug('RequestBody' +RequestBody);
    }
    
    public void GetRequestBody(Integer pageNumber, Integer pageSize, Integer startRecord){
        String RequestTemplate = '~ "findDocumentsRequest": ~ "findDocumentsRequestType": ~ "repositoryId": "PSEUDO1", "repositoryName": "", "documentClass": "{0}", "documentKeys": ~ "documentKey": [{1}] }, "searchAllVersions": "false", "pagination":~ "maxRecords": 250,"pageNumber": "' + pageNumber + '","pageSize": "' + pageSize + '"} } } }';
        String DocKeyTemplate = '~"name": "{0}", "value": "{1}", "dataTypeIndicator": "{2}", "operator": "{3}"}';
        String DocumentKeysTemplate = '';
        Integer DocKeysIndex = 0;
        for (DocumentKey docKey :DocumentKeys) {
            if (DocKeysIndex > 0) DocumentKeysTemplate += ', ';
            DocumentKeysTemplate += getDocKeyRequest(DocKeyTemplate, docKey.name, docKey.value, docKey.dataTypeIndicator, docKey.operator);
            system.debug(LoggingLevel.INFO, 'DocumentKeysTemplate: ' + DocumentKeysTemplate);
            DocKeysIndex++;
        }
        system.debug(LoggingLevel.INFO, 'documentType: '+ documentType);
        RequestBody = String.format(RequestTemplate, new String[] {documentType, DocumentKeysTemplate});
        
        RequestBody = RequestBody.replaceAll('~', '{');
        system.debug(LoggingLevel.INFO, 'RequestBody' + RequestBody);
    }
    
    //to support date type in request by simulationg one day span on datetime
    @TestVisible
    private String getDocKeyRequest(String DocKeyTemplate, String docKeyName, String docKeyValue, String docKeyDataType, String docKeyOperator){
        if(docKeyDataType == 'Datetime' && (docKeyOperator == '=' || docKeyOperator == '= ANY') && (!String.isEmpty(docKeyValue) && !docKeyValue.contains('T'))){
            String startDate = docKeyValue;
            String nextDay = getNextDay(docKeyValue);
            if(!String.isEmpty(nextDay)){
                String endDate = nextDay;
                if(docKeyOperator == '= ANY'){
                    return String.format(DocKeyTemplate, new String[] {docKeyName, startDate, docKeyDataType, '>= ANY'}) + ',' + String.format(DocKeyTemplate, new String[] {docKeyName, endDate, docKeyDataType, '< ANY'});
                }
                else{
                    return String.format(DocKeyTemplate, new String[] {docKeyName, startDate, docKeyDataType, '>='}) + ',' + String.format(DocKeyTemplate, new String[] {docKeyName, endDate, docKeyDataType, '<'});
                }
            }
        }
        return String.format(DocKeyTemplate, new String[] {docKeyName, docKeyValue, docKeyDataType, docKeyOperator});   
    }
    
    private String getNextDay(String startDate){
        String nextDay = '';
        if(!String.isEmpty(startDate)){
            try{
                List<String> dateParts = startDate.split('-');
                if(dateParts.size() == 3){
                    Date d = Date.newInstance(Integer.valueOf(dateParts[0]), Integer.valueOf(dateParts[1]), Integer.valueOf(dateParts[2]));
                    d = d.addDays(1);
                    nextDay = d.year() + '-' + d.month() + '-' + d.day();
                }
            }catch(Exception ex){}
        }
        return nextDay;
    }
    
    //init service query params
    public void init(String docType, List<documentKey> docKeys){ 
        system.debug(LoggingLevel.INFO, 'docType: ' + docType + ', docuKeys: ' + docKeys);
        this.documentType = docType;  
        this.DocumentKeys = dockeys;
        System.debug('documentType' +documentType);
        System.debug('DocumentKeys' +DocumentKeys);
    }
    
    public override ACETWSCalloutResult queryPaginatedData(Integer pageNumber, Integer pageSize, Integer startRecord){ 
        ACETWSCalloutResult oACETWSCalloutResult = new ACETWSCalloutResult();
        try{
            //Start of Logic to call for Doc 360 - Team Styx
            if(documentType != 'IDCARDS'){
                list<ACETFindDoc360SearchRequest.filters> filterlist = new list<ACETFindDoc360SearchRequest.filters>();
                Map<String, ACETFindDoc360SearchRequest.range> rangeMap = new Map<String, ACETFindDoc360SearchRequest.range>();
                String regex = '[0-9]{4}-[0-9]{0,2}-[0-9]{0,2}';
                Pattern datePattern = Pattern.compile(regex);
                string filterValue;
                for (DocumentKey docKey :DocumentKeys) {
                    ACETFindDoc360SearchRequest.range dateRange;
                    if(rangeMap.containsKey(docKey.Name)){
                        dateRange = rangeMap.get(docKey.Name);
                    }else{
                        dateRange = new ACETFindDoc360SearchRequest.range();
                    }
                    if(datePattern.matcher(docKey.value).matches()){
                        String []datevals = docKey.value.split('-');
                        datetime dt = datetime.newInstance(Integer.valueof(datevals[0]),Integer.valueof(datevals[1]),Integer.valueof(datevals[2]),00,00,00);
                        filterValue = dt.format('yyyy-MM-dd\'T\'HH:mm:ss.SSS\'Z\'');
                    }else{
                        filterValue = docKey.value;  
                    }
                    system.debug('tes '+filterValue);
                    system.debug('tesop '+docKey.operator);
                    if(docKey.operator=='='){
                        ACETFindDoc360SearchRequest.filters filter = new ACETFindDoc360SearchRequest.filters();
                        filter.name = docKey.name;
                        filter.type ='equal';
                        filter.value = filterValue;
                        filterList.add(filter);
                    }else if(docKey.operator=='>=') {
                        dateRange.gte = filterValue;
                        rangeMap.put(docKey.Name, dateRange);  
                    }else if(docKey.operator=='>') {
                        dateRange.gt = filterValue;
                        rangeMap.put(docKey.Name, dateRange);  
                    }else if(docKey.operator=='<='){
                        dateRange.lte = filterValue;
                        rangeMap.put(docKey.Name, dateRange);  
                    }else if(docKey.operator=='<'){
                        dateRange.lt = filterValue;
                        rangeMap.put(docKey.Name, dateRange);  
                    }else if(docKey.operator=='= ANY'){
                        ACETFindDoc360SearchRequest.filters filter = new ACETFindDoc360SearchRequest.filters();
                        filter.name = docKey.name;
                        filter.type='equalany';
                        list<String> filterValueList = filterValue.split('\\,');
                        filter.values = filterValueList;
                        filterList.add(filter);
                    }    
                }
                system.debug('rangeMap  '+rangeMap);
                if(rangeMap.size()>0){
                    for(String dockeys: rangeMap.keySet()){
                        ACETFindDoc360SearchRequest.filters filter = new ACETFindDoc360SearchRequest.filters();
                        filter.name = dockeys;
                        filter.type = 'range';
                        ACETFindDoc360SearchRequest.range daterange = rangeMap.get(dockeys);                       
                        filter.range = daterange;
                        filterlist.add(filter);
                    }
                }
                system.debug('filterss  '+JSON.serialize(filterlist));
                ACETFindDoc360SearchRequest searchreq = ACETFindDocWebservice.getRequestDoc360Body(pageNumber, pageSize, startRecord, documentType, filterlist);
                oACETWSCalloutResult = ACETFindDocWebservice.getDocumentsfromDoc360(searchreq, pageNumber, pageSize, startRecord);
            }else{ //End of Logic to call for Doc 360 - Team Styx
                GetEndpoint();
                system.debug('!!! before response document type'+documenttype);
                if(documentType == 'IDCARDS')
                {
                    GetRequestBodyIdCards();
                }
                else
                {
                    system.debug('pageNumber is '+pageNumber);
                    GetRequestBody(pageNumber, pageSize, startRecord);
                }
                GetMethod();
                HttpResponse Response = Send(OAuthConfig);
                //Response.setStatusCode(500);
                oACETWSCalloutResult.statusCode=response!=null?response.getStatusCode():null;        
                List<Map<String,String>> docs = new List<Map<String,String>>();                  
                
                if (Response.getStatusCode() == 200){
                    String responsebody = Response.getBody();
                    
                    system.debug('responsebody is '+responsebody);
                    ACETFindDocJson2Apex FDjson2apex = (ACETFindDocJson2Apex)JSON.deserializeStrict (responsebody, ACETFindDocJson2Apex.class);
                    system.debug('FDjson2apex is '+FDjson2apex);
                    system.debug('FDjson2apex.findDocumentsResponse.findDocumentsResponseType.documentList  is '+FDjson2apex.findDocumentsResponse.findDocumentsResponseType.documentList);
                    
                    if(FDjson2apex.findDocumentsResponse.findDocumentsResponseType.documentList == null){
                        oACETWSCalloutResult.Success = false;
                        oACETWSCalloutResult.Message = 'No Results Found.';
                        oACETWSCalloutResult.MessageSeverity = ApexPages.Severity.ERROR; 
                    }else{                   
                        Boolean isIDCard = documentType=='IDCARDS';
                        List<ACETFindDocJson2Apex.Document> documents = FDjson2apex.findDocumentsResponse.findDocumentsResponseType.documentList.document;
                        Integer i=0;//documentCount
                        for(ACETFindDocJson2Apex.Document d : documents){
                            Map<String,String> valuePair = new Map<String,String>();
                            valuePair.put(isIDCard?(i+'')+'DocumentId':'DocumentId', d.documentId); 
                            valuePair.put(isIDCard?(i+'')+'cmis:objectId':'cmis:objectId', d.documentId);
                            for(ACETFindDocJson2Apex.DocumentKey dk : d.documentKeys.documentKey){  
                                if(dk.dataTypeIndicator == 'datetime' && dk.name == 'cmis:creationDate'){
                                    valuePair.put(isIDCard?(i+'')+dk.name:dk.name, ACETWebserviceHelper.formatDateWithTime(dk.value));
                                }
                                else if(dk.dataTypeIndicator == 'datetime'){
                                    valuePair.put(isIDCard?(i+'')+dk.name:dk.name, ACETWebserviceHelper.formatDateFromDashToSlash(dk.value));   
                                }else{                  
                                    valuePair.put(isIDCard?(i+'')+dk.name:dk.name, dk.value);
                                }
                            }           
                            docs.add(valuePair);  
                            i++;
                        }
                        oACETWSCalloutResult.Response = docs;
                        oACETWSCalloutResult.Success = true;
                        oACETWSCalloutResult.Message = '';
                        
                        ACETFindDocJson2Apex.Pagination pagination = FDjson2apex.findDocumentsResponse.findDocumentsResponseType.pagination;
                        if(pagination != null){
                            oACETWSCalloutResult.pageNumber =  pagination.pageNumber; 
                            oACETWSCalloutResult.pageSize = pagination.pageSize; 
                            oACETWSCalloutResult.recordCount = pagination.recordCount;
                            if(pagination.moreRecords == 'true'){
                                oACETWSCalloutResult.totalCount = String.valueOf(Integer.valueOf(pagination.pageNumber) * Integer.valueOf(pagination.pageSize) + 1);
                            }else{
                                oACETWSCalloutResult.totalCount = String.valueOf((Integer.valueOf(pagination.pageNumber) - 1) * Integer.valueOf(pagination.pageSize) + Integer.valueOf(pagination.recordCount)); 
                            }
                            system.debug(pagination);                       
                        }
                    }
                }else {
                    oACETWSCalloutResult.Success = false;
                    oACETWSCalloutResult.statusCode=response!=null?response.getStatusCode():null;           
                }
            }
        }catch(Exception ex){            
            system.debug(LoggingLevel.INFO, 'Exception in Find Doc Webservice. Details: ' + ex+'line '+ex.getLineNumber()); 
            oACETWSCalloutResult.Success = false;
            oACETWSCalloutResult.Message = 'Exception in Find Doc Webservice. Details: '+ex.getMessage();
            oACETWSCalloutResult.MessageSeverity = ApexPages.Severity.ERROR;
            oACETWSCalloutResult.statusCode=999;        
        }
        system.debug('oACETWSCalloutResult-->'+oACETWSCalloutResult);
        return oACETWSCalloutResult;
        
    }
    
}