public class ACETHSATransactionWebService extends ACETWebService{
    public class applicationException extends Exception {}
    private String h_key;
    private String h_status;
    
    public override void getEndpoint(){
       GetEndpointDetail('HSATransaction');
    }
     public ACETHSATransactionWebService() {
        super('Stargate');
    }
    public void getRequestBody(String key, String status){
    
       RequestBody = '{'
                       + '"id":  "' + key + '" ,'  
                       + '"status":  "' + status + '" ,'  
                       +'"pagination": {'
                       +'"pageNumber": "1",'
                       +'"recordsPerPage": "1"'
                       +'}'  
                       +'}';
    }

     //init service query params
    public void init(String key, String status){ 
        h_key = key;
        h_status = status;
                                                
    }
    
    
    public override ACETWSCalloutResult queryPaginatedData(Integer pageNumber, Integer pageSize, Integer startRecord){                    
       system.debug('Inside querypaginated Method');
       ACETWSCalloutResult searchResult = new ACETWSCalloutResult();
       list<ACETHSATransactionJSON2Apex.transactions> transactionDetails; 
        
       List<ACETHSATransactionResult> hsaResultList = new List<ACETHSATransactionResult>();
       ACETHSATransactionResult htr = new ACETHSATransactionResult(); 
                    
            try {
            getEndpoint();
            
            if (!String.isEmpty(h_key) && !String.isEmpty(h_status)) {
                getRequestBody(h_key,h_status);
            }
            
            RequestBody = RequestBody.replace('"pageNumber": "1"','"pageNumber": "' + pageNumber + '"');
            RequestBody = RequestBody.replace('"recordsPerPage": "1"','"recordsPerPage": "' + pageSize + '"');
            RequestBody = RequestBody.replace('"startRecord": "1"','"startRecord": "' + startRecord + '"');
            
            system.debug('**RequestBody'+RequestBody);
            HttpResponse response = Send(OAuthConfig);
            system.debug('**OAuthConfig'+OAuthConfig);
            system.debug('**OAuthConfig.response'+response);
            //response.setStatusCode(500);
            if(response.getStatusCode() == 200){
               
                
                if(response.getBody() != null){
                    
                    system.debug('**responseBody in find group ==>'+response.getBody() );
                    String responseBody = response.getBody().replace('\"date\":', '\"transactionDate\":');
                    ACETHSATransactionJSON2Apex ACTHSAJSON2Apex = (ACETHSATransactionJSON2Apex)JSON.deserialize(responseBody , ACETHSATransactionJSON2Apex.class);
                    transactionDetails = ACTHSAJSON2Apex.transactions;
                    system.debug('@@@transactionDetails '+transactionDetails );
                    if(transactionDetails != null){
                        for(ACETHSATransactionJSON2Apex.transactions tr: transactionDetails ){
                            htr = new ACETHSATransactionResult();
                            htr.transactionDate = (tr.transactiondate != null)?(cleanDate(String.valueof(ACETUtility.format(Date.ValueOf(tr.transactiondate))))):'';
                            //htr.transactionDateformat = date.valueOf((htr.transactionDate ));
                            htr.status          = (tr.status != null)?tr.status:'';
                            htr.transactionType = (tr.transactionCode != null)?tr.transactionCode:'';
                            htr.description     = (tr.accountDescription != null)?tr.accountDescription:'';
                            htr.amount          = (tr.amount != null)?((tr.amount.contains('-'))?'-'+'$'+tr.amount.substringAfter('-'):'$'+tr.amount):'$0';
                            hsaResultList.add(htr);
                        }
                    }    
                    system.debug('@@@Result'+hsaResultList);
                    
                    searchResult.Success = true;
                    searchResult.Message = '';
                    searchResult.Response = hsaResultList;
                    
                    ACETHSATransactionJSON2Apex.Pagination pagination = ACTHSAJSON2Apex.pagination;                                                                         
                    searchResult.pageNumber =  pagination.pageNumber; 
                    searchResult.pageSize = pagination.pageSize; 
                    searchResult.totalCount = pagination.totalCount;
                    
                    system.debug('@@@searchResult'+SearchResult);

              }  
                
            }
            
            else if(response.getStatusCode() == 500 || response.getStatusCode() == 404){
                searchResult.MessageSeverity = ApexPages.Severity.ERROR;
                searchResult.Message = label.ACETWebServiceUnavailableErrorMessage;               
                searchResult.Response = new List<ACETHSATransactionResult>();
                searchResult.statusCode=response!=null?response.getStatusCode():null;
                if(response.getStatusCode() == 404){
                 searchResult.Success = true; 
                }else{
                 searchResult.Success = false; 
                }
                system.debug(searchResult);                
            }else{
                searchResult.Success = false; 
                searchResult.Response = new List<ACETHSATransactionResult>();
                searchResult.statusCode=response!=null?response.getStatusCode():null;
            }
            }catch(Exception e){
                    system.debug(e);
                    searchResult.MessageSeverity = ApexPages.Severity.ERROR;
                    searchResult.Success = false;
                    searchResult.Message = label.ACETOILNotAvailable;
                    searchResult.statusCode=999;
           }
        
        return searchResult;    
    }
    public String cleanDate(String theDate){
        String [] s = theDate.split('/');
        String newDate= '';
        String newMonth= '';
        String newDay= '';
        if(s[0].length() == 1){
            newMonth = '0'+s[0];
        }else{
            newMonth = s[0];
        }
        if(s[1].length() == 1){
            newDay = '0'+s[1];
        }else{
            newDay = s[1];
        }
        newDate = newMonth+'/'+newDay+'/'+s[2];
        return newDate;
    }
    
}