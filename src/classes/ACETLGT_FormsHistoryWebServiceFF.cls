public class ACETLGT_FormsHistoryWebServiceFF extends ACETWebService{

    public String searchSourceID{get;set;}
    public Integer fulfillmentType{get;set;}
    public String rangeStartEventReceivedDate{get;set;}
    public String rangeEndEventReceivedDate{get;set;}
    public String recipientID{get;set;}
    public String idQualifier{get;set;}
    //
    public override void getEndpoint(){
        GetEndpointDetail('FindFulfillmentHistoryRRD');
            
    }
    public ACETLGT_FormsHistoryWebServiceFF() {
        super('Stargate');
    }
    public void init(){
        queryPaginatedData(1,1,1);
    }
    public void init(String searchSourceID, Integer fulfillmentType, String rangeStartEventReceivedDate, String rangeEndEventReceivedDate,String recipientID, String idQualifier){ 
         
         this.searchSourceID = searchSourceID;
         this.fulfillmentType = fulfillmentType;
         this.rangeStartEventReceivedDate = rangeStartEventReceivedDate;
         this.rangeEndEventReceivedDate = rangeEndEventReceivedDate;
         this.recipientID = recipientID;
         this.idQualifier = idQualifier;
    }
    
  
   public String formatDatetime(String dateTimeString){        
        if(!String.isEmpty(dateTimeString)){
            List<String> dtParts = dateTimeString.split('T');
            if(dtParts.size() == 2){
                String dateString = dtParts[0];
                String timeString = dtParts[1];
                
                List<String> dateParts = dateString.split('-');               
                if(dateParts.size() == 3){
                    String mm = dateParts[1];
                    String dd = dateParts[2];
                    String yyyy = dateParts[0];
                    
                    mm = mm.contains('0') && mm.indexOf('0') == 0 ? mm.replace('0','') : mm ; 
                    dd = dd.contains('0') && dd.indexOf('0') == 0 ? dd.replace('0','') : dd; 
                    
                    if(timeString.length() > = 8){                       
                        return mm  + '/' + dd + '/' + yyyy + ' ' + timeString.substring(0,8);
                    }
                }
                
            }
        }
        return dateTimeString;
    }
    
    public String FormatRecpt (String  recipient){
    
       if(!String.isEmpty(recipient)){
       
       recipient= recipient.replaceAll('\"[^\"]*\":null',''); //basic removeal of null values
        

       }
     return recipient;
    }
    
    //to remove to global util class
    public String formatStartDate(String dateString){
        if(dateString == null) return null;
        list<String> dateParts = dateString.split('-');
        if(dateParts.size() == 3){
            String mm = dateParts[1];
            String dd = dateParts[2].length() !=2 ? '0'+dateParts[2] : dateParts[2];
            String yyyy = dateParts[0];
            return mm  + '/' + dd + '/' + yyyy;
        }else{
            return dateString;
        }
    }
    public String formatEndDate(String dateString){
        if(dateString == null) return null;
        list<String> dateParts = dateString.split('/');
        if(dateParts.size() == 3){
            String mm =  dateParts[0].length() !=2 ? '0'+dateParts[0] : dateParts[0];
            String dd = dateParts[1].length() !=2 ? '0'+dateParts[1] : dateParts[1];
            String yyyy = dateParts[2];
            return mm  + '/' + dd + '/' + yyyy;
        }else{
            return dateString;
        }
    }
    
    
    //implement pagianted data service
    public override ACETWSCalloutResult queryPaginatedData(Integer pageNumber, Integer pageSize, Integer startRecord){                    
        
        ACETWSCalloutResult searchResult = new ACETWSCalloutResult();
        List<ACETLGT_FormsHistoryResult> fulfillmentSearchResult;
        
        try{
            ServiceName = 'FindFulfillmentHistory';
            getEndpoint();  
            RequestBody='{"findFulfillmentHistory": {'
                    +'"findFulfillmentHistoryRequest": {'
                    +'"searchSourceID": "'+ this.searchSourceID +'",'
                    +'"fulfillmentType": "'+ this.fulfillmentType+'",'// 10700,'
                    +'"rangeStartEventReceivedDate": "'+ formatStartDate(this.rangeStartEventReceivedDate) +'",'
                    +'"rangeEndEventReceivedDate": "'+ formatEndDate(this.rangeEndEventReceivedDate) +'",'
                    +'"recipientID": "'+ this.recipientID +'",'
                    +'"idQualifier": "'+ this.idQualifier +'"'
                    +'}'
                +'}'
            +'}';
            
            HttpResponse response;  
            response = Send(OAuthConfig);
            searchResult.statusCode = response.getStatusCode();
            if(searchResult.statusCode == 200){ 
                if(response.getBody() != null){
                    String responseBody = response.getBody().replace('\"date\":', '\"date2\":');
                    ACETLGT_FindFulfillmentHistoryJSON2Apex ACTFMJSON2Apex = (ACETLGT_FindFulfillmentHistoryJSON2Apex)JSON.deserialize(responseBody, ACETLGT_FindFulfillmentHistoryJSON2Apex.class);
                    System.debug('ACTFMJSON2Apex:::::'+ACTFMJSON2Apex);
                    fulfillmentSearchResult = new List<ACETLGT_FormsHistoryResult>();
                    
                    if(ACTFMJSON2Apex.FindFulfillmentHistoryResult.findFulfillmentHistoryResponse.searchResultSet != null){
                        for(ACETLGT_FindFulfillmentHistoryJSON2Apex.SearchResultSet objSearchResultSet : ACTFMJSON2Apex.FindFulfillmentHistoryResult.findFulfillmentHistoryResponse.searchResultSet){
                            if(objSearchResultSet.responseRequestHeader.requestCategory.contains('TransactionalInlinePrintReadySingleItem')){
                                system.debug('objSearchResultSet is '+objSearchResultSet);
                               system.debug('Inside Loop');
                                ACETLGT_FormsHistoryResult objACETFormsHistoryResult = new ACETLGT_FormsHistoryResult();
                                
                                objACETFormsHistoryResult.Address = (objSearchResultSet.responseRequestDetail.responseTransactionalRequestDetail.responseRecipient[0].MailToAddress.Address1 
                                                                    + ' ' +objSearchResultSet.responseRequestDetail.responseTransactionalRequestDetail.responseRecipient[0].MailToAddress.Address2
                                                                    + ' ' +objSearchResultSet.responseRequestDetail.responseTransactionalRequestDetail.responseRecipient[0].MailToAddress.city
                                                                    + ' ' +objSearchResultSet.responseRequestDetail.responseTransactionalRequestDetail.responseRecipient[0].MailToAddress.state
                                                                    + ' ' +objSearchResultSet.responseRequestDetail.responseTransactionalRequestDetail.responseRecipient[0].MailToAddress.zip).remove('null');
                                 
                                          system.debug('objACETFormsHistoryResult.Address is '+objACETFormsHistoryResult.Address);                          
                                objACETFormsHistoryResult.documentname = objSearchResultSet.responseRequestDetail.responseTransactionalRequestDetail.responseTemplate.templateName;
                                //objACETFormsHistoryResult.documenttype = objSearchResultSet.responseCurrentEventLog.processorName;
                                objACETFormsHistoryResult.documenttype = objSearchResultSet.responseRequestHeader.fulfillmentTypeBusName;
                                if(objSearchResultSet.responseCurrentEventLog.dispatchedDate!=null){
                                    objACETFormsHistoryResult.maileddate = formatDatetime(objSearchResultSet.responseCurrentEventLog.dispatchedDate);
                                }
                                
                                if(objSearchResultSet!=null){
                                    system.debug('objSearchResultSet>>>>'+objSearchResultSet);
                                    if(objSearchResultSet.responseRequestHeader!=null){
                                        system.debug('objSearchResultSet.responseRequestHeader>>>>'+objSearchResultSet.responseRequestHeader);
                                        if(objSearchResultSet.responseRequestHeader.requestTrailer!=null){
                                            system.debug('objSearchResultSet.responseRequestHeader.requestTrailer>>>>'+objSearchResultSet.responseRequestHeader.requestTrailer);
                                            if(objSearchResultSet.responseRequestHeader.requestTrailer.requestItemCount!=null){
                                                system.debug('objSearchResultSet.responseRequestHeader.requestTrailer.requestItemCount>>>>'+objSearchResultSet.responseRequestHeader.requestTrailer.requestItemCount);
                                                objACETFormsHistoryResult.quantity = objSearchResultSet.responseRequestHeader.requestTrailer.requestItemCount;
                                            }
                                        }
                                    }
                                }
                                if(objSearchResultSet.responseRequestDetail.responseTransactionalRequestDetail.responseRecipient[0].person != null){
                                    objACETFormsHistoryResult.recipient = (objSearchResultSet.responseRequestDetail.responseTransactionalRequestDetail.responseRecipient[0].person.prefix
                                                                          +' '+objSearchResultSet.responseRequestDetail.responseTransactionalRequestDetail.responseRecipient[0].person.firstName
                                                                          +' '+objSearchResultSet.responseRequestDetail.responseTransactionalRequestDetail.responseRecipient[0].person.middleName
                                                                          +' '+objSearchResultSet.responseRequestDetail.responseTransactionalRequestDetail.responseRecipient[0].person.lastName).remove('null');
                                }
                                else if(objSearchResultSet.responseRequestDetail.responseTransactionalRequestDetail.responseRecipient[0].organization != null){
                                     objACETFormsHistoryResult.recipient = objSearchResultSet.responseRequestDetail.responseTransactionalRequestDetail.responseRecipient[0].organization.Name1; 
                                }
                                else{
                                  objACETFormsHistoryResult.recipient = '';
                                }
                                objACETFormsHistoryResult.requestdate = formatDatetime(objSearchResultSet.responseRequestHeader.requestDate);
                                objACETFormsHistoryResult.source = objSearchResultSet.responseRequestHeader.sourceIDName;
                                objACETFormsHistoryResult.status = objSearchResultSet.responseCurrentEventLog.statusCode;
                                
                                system.debug('!!!objACETFormsHistoryResult'+objACETFormsHistoryResult);
                                fulfillmentSearchResult.add(objACETFormsHistoryResult);
                                
                            }
                            
                                                        
                            
                        }
                        system.debug('!!!fulfillmentSearchResult'+fulfillmentSearchResult.size()); 
                    }
                    if(fulfillmentSearchResult.size() > 0){
                    searchResult.Success = true;
                    searchResult.Message = '';
                    searchResult.Response = fulfillmentSearchResult;
                    }
                    else{
                        searchResult.Success = false;
                        searchResult.Message = 'No results found.';
                        searchResult.Response = fulfillmentSearchResult;
                    }
                } 
            }else if(searchResult.statusCode == 404 || searchResult.statusCode == 500){                
                searchResult.MessageSeverity = ApexPages.Severity.INFO;
                searchResult.Success = false;                
                searchResult.Response = new List<ACETLGT_FormsHistoryResult>();
                searchResult.Message = 'Service Error. Please try again';//'Search criteria returned no matches.';                
                searchResult.recordCount = '0';                
                system.debug(searchResult);                
            }
            else {
                searchResult.MessageSeverity = ApexPages.Severity.INFO;
                searchResult.Success = false;                
                searchResult.Response = new List<ACETLGT_FormsHistoryResult>();
                searchResult.Message = 'Service Error. Please try again';//'Search criteria returned no matches.';                
                searchResult.recordCount = '0';                
                system.debug(searchResult); 
            }
            }
            catch(Exception e){
                    system.debug('Exception is '+e.getMessage()+'at line '+e.getLineNumber());
                    searchResult.MessageSeverity = ApexPages.Severity.ERROR;
                    searchResult.Success = false;
                    searchResult.Message = 'Web Service or External System is temporarily unavailable.';
                    searchResult.recordCount = '0';
                    searchResult.StatusCode = 999;

           }
        return searchResult;        
    }
}