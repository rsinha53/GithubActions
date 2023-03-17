public class ACETFindDocWebservice extends ACETWebservice{
    public String documentType;
    public List<documentKey> DocumentKeys;
    public static string exceptionMsg ='Exception in Find Doc Webservice. Details';
    public class documentKey
    {
        public String name{get;set;}
        public String value{get;set;}
        public String dataTypeIndicator{get;set;}
        public String operator{get;set;}
    }
    
    public override void GetEndpoint(){
        GetEndpointDetail('FindDocument');
    }
     public ACETFindDocWebservice() {
        super('Stargate');
    }
    public override void GetMethod(){
        Method = 'POST';
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
    
    /**
    * @description US3385722 - Team Styx - Preparing Doc360 Request Body
    * @author Raviteja | 06-08-2021 
    * @param pageNumber 
    * @param pageSize 
    * @param startRecord 
    * @param filters 
    * @return ACETFindDoc360SearchRequest 
    **/
    public static ACETFindDoc360SearchRequest getRequestDoc360Body(Integer pageNumber, Integer pageSize, Integer startRecord, String docType, list<ACETFindDoc360SearchRequest.filters> filters){
        ACETFindDoc360SearchRequest doc360Request = new ACETFindDoc360SearchRequest();
        doc360Request.indexName = docType;
        ACETFindDoc360SearchRequest.criteria criterialVals = new ACETFindDoc360SearchRequest.criteria();
        criterialvals.filterClauses = filters;
        doc360Request.criteria = criterialVals; 
        doc360Request.startRow = startRecord;
        doc360Request.totalRecords = pageSize;
        return doc360Request;
    }
    
    /**
    * @description US3385722 - Team Styx - Calling Doc360 Search Service for getting document results
    * @author Raviteja | 06-08-2021 
    * @param request 
    * @return ACETWSCalloutResult 
    **/
    public static ACETWSCalloutResult getDocumentsfromDoc360(ACETFindDoc360SearchRequest request, Integer pageNumber, Integer pageSize, Integer startRecord){
        ACETWSCalloutResult oACETWSCalloutResult = new ACETWSCalloutResult();
        try{
            String requestBody = JSON.serialize(request);
            system.debug('@@@requestBody '+requestBody);
            ACET_WebserviceCalloutFramework wsCallOutFW = new ACET_WebserviceCalloutFramework('LinkRelatedDocuments',requestBody,null);
            HttpResponse httpResponse = wsCallOutFW.getResponse();
            Integer statusCode = httpResponse.getStatusCode();
            String responseBody = httpResponse.getBody();
            ACETFindDoc360SearchResults doc360results;
            List<Map<String,String>> docs = new List<Map<String,String>>();
            switch on statusCode{
                when 200{
                    doc360results = (ACETFindDoc360SearchResults)JSON.deserializeStrict (responseBody, ACETFindDoc360SearchResults.class);
                }
                when 404{
                    oACETWSCalloutResult.Success = false;
                    oACETWSCalloutResult.MessageSeverity = ApexPages.Severity.ERROR;  
                    oACETWSCalloutResult.statusCode=httpResponse.getStatusCode();          
                }
                when else{
                    oACETWSCalloutResult = parseFailureData(httpResponse);
                    oACETWSCalloutResult.statusCode=httpResponse.getStatusCode();        
                }
            }
            
            switch on doc360results.totalRecords{
                when 0{
                    oACETWSCalloutResult.Success = false;
                    oACETWSCalloutResult.Message = 'No Results Found.';
                    oACETWSCalloutResult.MessageSeverity = ApexPages.Severity.ERROR;
                }
                when else{
                    String regex = '[0-9]{4}-[0-9]{0,2}-[0-9]{0,2}T[0-9]{0,2}:[0-9]{0,2}:[0-9]{0,2}.[0-9]{0,3}Z';
                    Pattern datePattern = Pattern.compile(regex);
                    for(ACETFindDoc360SearchResults.RecordsList d : doc360results.recordsList){
                        Map<String,String> valuePair = new Map<String,String>();
                        string []docidlist = d.objectId.split('\\|');
                        valuePair.put('DocumentId', docidlist[0]); 
                        valuePair.put('u_gbl_doc_id', docidlist[0]);
                        for(ACETFindDoc360SearchResults.Attributes dk : d.attributes){    
                            valuePair.put(dk.labelName, dataFormatting(dk.value, dk.labelName));  
                        }
                        docs.add(valuePair);
                    }
                    oACETWSCalloutResult.Response = docs;
                    oACETWSCalloutResult.Success = true;
                    oACETWSCalloutResult.Message = '';
                    oACETWSCalloutResult.pageNumber =  String.valueof(pageNumber); 
                    oACETWSCalloutResult.pageSize = String.valueof(pageSize); 
                    integer recordSize = doc360results.recordsList.size();
                    oACETWSCalloutResult.recordCount = String.valueof(recordSize);
                    oACETWSCalloutResult.totalCount = String.valueOf(doc360results.totalRecords);
                }
            }
        }catch(Exception ex){            
           oACETWSCalloutResult.Success = false;
           oACETWSCalloutResult.Message = exceptionMsg+ex.getMessage();
           oACETWSCalloutResult.MessageSeverity = ApexPages.Severity.ERROR;
           oACETWSCalloutResult.statusCode=999;        
        }
        return oACETWSCalloutResult;
    }
    
     /**
    * @description US3385722 - Team Styx - Data Formatting the response
    * @author Raviteja | 07-01-2021 
    * @param attributeValue 
    * @return string 
    **/
    public static String dataFormatting(String attributeValue, string fieldname){    
        String attrFinalValue='';
        if(attributeValue.startsWith('[') && attributeValue.endsWith(']')){
            attributeValue = attributeValue.replace('[','');
            attributeValue = attributeValue.replace(']','');          
            list<String> attrList = new list<String>();
            for(String attr: attributeValue.split('\\,')){
                attr = attr.replaceFirst(' ','');
                attrList.add(dataFormattingHelper(attr, fieldname));
            }
            attrFinalValue = String.join(attrList,', ');
        }else{
            attrFinalValue = dataFormattingHelper(attributeValue, fieldname);
        }
        return attrFinalValue;
    }
    
    public static String dataFormattingHelper(String attributeValue, string fieldname){
        String regex = '[0-9]{4}-[0-9]{0,2}-[0-9]{0,2}T[0-9]{0,2}:[0-9]{0,2}:[0-9]{0,2}.[0-9]{0,3}Z';
        Pattern datePattern = Pattern.compile(regex);
        String attrFinalValue='';
        switch on fieldname{
            when 'u_orig_creation_date'{
                attrFinalValue = datePattern.matcher(attributeValue).matches()?ACETWebserviceHelper.formatDateWithTime(attributeValue):attributeValue;
            }when else{
                attrFinalValue = datePattern.matcher(attributeValue).matches()?ACETWebserviceHelper.formatDateFromDashToSlash(attributeValue):attributeValue;
            }
        }
        return attrFinalValue;
    }
    /**
    * @description US3385722 - Team Styx - Parsing failed request
    * @author Raviteja | 06-08-2021 
    * @param FailureResponse 
    * @return ACETWSCalloutResult 
    **/
    public static ACETWSCalloutResult parseFailureData(HttpResponse failureResponse){
        ACETWSCalloutResult oACETWSCalloutResult = new ACETWSCalloutResult();
        oACETWSCalloutResult.Success = false;
        oACETWSCalloutResult.MessageSeverity = ApexPages.Severity.ERROR;
        Map<String, Object> mapErrors = new Map<String, Object>();
        List<Object> lstErrors = new list<Object>();
        Map<String, Object> mapError = new Map<String, Object>();
        try {
            Map<String, Object> mapRootNode = (Map<String, Object>)JSON.deserializeUntyped(failureResponse.getBody());
            if(failureResponse.getStatusCode() == 500 && mapRootNode.containsKey('ErrorCode') && mapRootNode.containsKey('Advice')) {
                //Parse failure repsonse from ISL
                oACETWSCalloutResult.Message = Label.ACETUnexpectedErrorMessage;
            }else {
                //Parse failure response from OIL
                mapErrors = (Map<String, Object>)mapRootNode.values().get(0);
                system.debug('Map Errors:' + mapErrors);
                lstErrors = (List<Object>)mapErrors.get('errors');
                system.debug('List Errors:' + lstErrors);               
            }
            switch on lstErrors.size(){
                when 0{
                    Map<String, Object> mapTypeNode = (Map<String, Object>)mapErrors.values().get(0);
                    lstErrors = (List<Object>)mapTypeNode.get('errors');
                    system.debug('List Errors 2:' + lstErrors);
                }
                when else{
                    String errorDescription;
                    for (Object oError :lstErrors) {
                        mapError = (Map<String, Object>)oError;
                        system.debug('Error: ' + mapError);
                        errorDescription = String.valueOf(mapError.get('description'));
                        oACETWSCalloutResult.Message = String.isBlank(oACETWSCalloutResult.Message)?errorDescription:((oACETWSCalloutResult.Message.length() + errorDescription.length())<=255?oACETWSCalloutResult.Message += '; ' + errorDescription:oACETWSCalloutResult.Message);
                    }
                }
            }
        }
        catch(Exception ex){
            system.debug(LoggingLevel.INFO, 'Error serializing error response JSON. Details: ' + ex);
            oACETWSCalloutResult.Message = failureResponse.getBody();
        }

        return oACETWSCalloutResult;
    }

    
    //to support date type in request by simulationg one day span on datetime
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
    }
    
    /**
    * @description US3385722 - Team Styx - process the filters for Doc360
    * @author Raviteja | 07-01-2021 
    * @param  
    * @return list<ACETFindDoc360SearchRequest.filters> 
    **/
    public static list<ACETFindDoc360SearchRequest.filters> processFilters(list<DocumentKey> documentKeys){
        list<ACETFindDoc360SearchRequest.filters> filterList = new list<ACETFindDoc360SearchRequest.filters>();
        Map<String, ACETFindDoc360SearchRequest.range> rangeMap = new Map<String, ACETFindDoc360SearchRequest.range>();
        String regex = '[0-9]{4}-[0-9]{2}-[0-9]{2}';
        Pattern datePattern = Pattern.compile(regex);
        string filterValue;
        for (DocumentKey docKey : documentKeys) {
            system.debug('tes '+docKey);
            ACETFindDoc360SearchRequest.range dateRange;
            dateRange = rangeMap.containsKey(docKey.Name)?rangeMap.get(docKey.Name):new ACETFindDoc360SearchRequest.range();
            
            if(datePattern.matcher(docKey.value).matches()){
                String []datevals = docKey.value.split('-');
                datetime dt = datetime.newInstance(Integer.valueof(datevals[0]),Integer.valueof(datevals[1]),Integer.valueof(datevals[2]),00,00,00);
                filterValue = dt.format('yyyy-MM-dd\'T\'HH:mm:ss.SSS\'Z\'');
            }else{
                filterValue = docKey.value;  
            }
            ACETFindDoc360SearchRequest.filters filter = new ACETFindDoc360SearchRequest.filters();
            filter.name = docKey.name;
            switch on docKey.operator{
                
                when '>='{
                    dateRange.gte = filterValue;
                    rangeMap.put(docKey.Name, dateRange);  
           		}
                when '>'{
                    dateRange.gt = filterValue;
                    rangeMap.put(docKey.Name, dateRange);  
                }
                when '<='{
                    dateRange.lte = filterValue;
                    rangeMap.put(docKey.Name, dateRange);  
                }
                when '<'{
                    dateRange.lt = filterValue;
                    rangeMap.put(docKey.Name, dateRange);  
                }
                when '= ANY'{
                    filter.type='equalany';
                    list<String> filterValueList = filterValue.split('\\,');
                    filter.values = filterValueList;
                    filterList.add(filter);
                } 
                when else{
                    filter.type ='equal';
                    filter.value = filterValue;
                    filterList.add(filter);
                }
            }
        }
        for(String docKeys: rangeMap.keySet()){
            ACETFindDoc360SearchRequest.filters filter = new ACETFindDoc360SearchRequest.filters();
            filter.name = docKeys;
            filter.type = 'range';
            ACETFindDoc360SearchRequest.range dateRange = rangeMap.get(docKeys);
            filter.range = dateRange;
            filterList.add(filter);
        }
        return filterList;
    }
    
    public override ACETWSCalloutResult queryPaginatedData(Integer pageNumber, Integer pageSize, Integer startRecord){ 
        ACETWSCalloutResult oACETWSCalloutResult = new ACETWSCalloutResult();
        try{
            //Start of Logic to call for Doc 360 Service - Team Styx - Raviteja
            if(documentType != 'IDCARDS'){
                list<ACETFindDoc360SearchRequest.filters> filterList = ACETFindDocWebservice.processFilters(DocumentKeys);
                ACETFindDoc360SearchRequest searchreq = ACETFindDocWebservice.GetRequestDoc360Body(pageNumber, pageSize, startRecord, documentType, filterList);
                oACETWSCalloutResult = ACETFindDocWebservice.getDocumentsfromDoc360(searchreq, pageNumber, pageSize, startRecord);
            }else{ //End of Logic to call for Doc 360 Service - Team Styx - Raviteja
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
                       List<ACETFindDocJson2Apex.Document> documents = FDjson2apex.findDocumentsResponse.findDocumentsResponseType.documentList.document;
                       Boolean isIDCard = (documentType == 'IDCARDS');
                       Integer i=0; //documentNumber
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
               }else if(Response.getStatusCode() == 404){
                    oACETWSCalloutResult.Success = false;
                   // oACETWSCalloutResult.Message = 'No results found.';
                    oACETWSCalloutResult.MessageSeverity = ApexPages.Severity.ERROR;  
                    oACETWSCalloutResult.statusCode=response!=null?response.getStatusCode():null;          
               }else{
                    oACETWSCalloutResult = ParseFailureResponse(Response);
                    //oACETWSCalloutResult.Message = 'Problem with Find Doc Webservice: ' + oACETWSCalloutResult.Message;
                    oACETWSCalloutResult.statusCode=response!=null?response.getStatusCode():null;        
               }
            }
        }catch(Exception ex){            
           system.debug(LoggingLevel.INFO, exceptionMsg+ ex+'line '+ex.getLineNumber()); 
           oACETWSCalloutResult.Success = false;
           oACETWSCalloutResult.Message = exceptionMsg+ex.getMessage();
           oACETWSCalloutResult.MessageSeverity = ApexPages.Severity.ERROR;
           oACETWSCalloutResult.statusCode=999;        
        }
        system.debug('oACETWSCalloutResult-->'+oACETWSCalloutResult);
        return oACETWSCalloutResult;
        
    }
     
}