public class ACETLGT_HSATransactionWebservice extends ACETWebService{
    public class applicationException extends Exception {}
    private String h_key;
    private String h_status;
    
    public override void getEndpoint(){
       GetEndpointDetail('HSATransaction');
    }
    public ACETLGT_HSATransactionWebservice() {
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
       list<ACETLGT_HSATransactionJSON2Apex.transactions> transactionDetails; 
        
       List<ACETLGT_HSATransactionResult> hsaResultList = new List<ACETLGT_HSATransactionResult>();
       ACETLGT_HSATransactionResult htr = new ACETLGT_HSATransactionResult(); 
                    
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
            
            //response.setStatusCode(200);
            String respBody = response.getBody();
            searchResult.statusCode = response.getStatusCode();
            //String respBody = '{"transactions":[{"id":"NHw5MDQzMzE0MjZ8bnVsbHxPUFR8SFNBfG51bGx8bnVsbA==","accountDescription":"12345","status":"PROCESSED","date":"2019-12-31","amount":"5","transactionCode":"804"},{"id":"NHw5MDQzMzE0MjZ8bnVsbHxPUFR8SFNBfG51bGx8bnVsbA==","accountDescription":"Interest Payment","status":"PROCESSED","date":"2019-11-29","amount":"4","transactionCode":"804"},{"id":"NHw5MDQzMzE0MjZ8bnVsbHxPUFR8SFNBfG51bGx8bnVsbA==","accountDescription":"Interest Payment","status":"PROCESSED","date":"2019-10-31","amount":"5","transactionCode":"804"},{"id":"NHw5MDQzMzE0MjZ8bnVsbHxPUFR8SFNBfG51bGx8bnVsbA==","accountDescription":"Interest Payment","status":"PROCESSED","date":"2019-09-30","amount":"5","transactionCode":"804"},{"id":"NHw5MDQzMzE0MjZ8bnVsbHxPUFR8SFNBfG51bGx8bnVsbA==","accountDescription":"Interest Payment","status":"PROCESSED","date":"2019-08-30","amount":"4","transactionCode":"804"},{"id":"NHw5MDQzMzE0MjZ8bnVsbHxPUFR8SFNBfG51bGx8bnVsbA==","accountDescription":"Interest Payment","status":"PROCESSED","date":"2019-07-31","amount":"5","transactionCode":"804"},{"id":"NHw5MDQzMzE0MjZ8bnVsbHxPUFR8SFNBfG51bGx8bnVsbA==","accountDescription":"Interest Payment","status":"PROCESSED","date":"2019-06-28","amount":"4","transactionCode":"804"},{"id":"NHw5MDQzMzE0MjZ8bnVsbHxPUFR8SFNBfG51bGx8bnVsbA==","accountDescription":"Interest Payment","status":"PROCESSED","date":"2019-05-31","amount":"5","transactionCode":"804"},{"id":"NHw5MDQzMzE0MjZ8bnVsbHxPUFR8SFNBfG51bGx8bnVsbA==","accountDescription":"Interest Payment","status":"PROCESSED","date":"2019-04-30","amount":"5","transactionCode":"804"},{"id":"NHw5MDQzMzE0MjZ8bnVsbHxPUFR8SFNBfG51bGx8bnVsbA==","accountDescription":"Interest Payment","status":"PROCESSED","date":"2019-03-29","amount":"4","transactionCode":"804"},{"id":"NHw5MDQzMzE0MjZ8bnVsbHxPUFR8SFNBfG51bGx8bnVsbA==","accountDescription":"Interest Payment","status":"PROCESSED","date":"2019-02-28","amount":"4","transactionCode":"804"},{"id":"NHw5MDQzMzE0MjZ8bnVsbHxPUFR8SFNBfG51bGx8bnVsbA==","accountDescription":"Interest Payment","status":"PROCESSED","date":"2019-01-31","amount":"5","transactionCode":"804"},{"id":"NHw5MDQzMzE0MjZ8bnVsbHxPUFR8SFNBfG51bGx8bnVsbA==","accountDescription":"Interest Payment","status":"PROCESSED","date":"2018-12-31","amount":"5","transactionCode":"804"},{"id":"NHw5MDQzMzE0MjZ8bnVsbHxPUFR8SFNBfG51bGx8bnVsbA==","accountDescription":"Interest Payment","status":"PROCESSED","date":"2018-11-30","amount":"4","transactionCode":"804"},{"id":"NHw5MDQzMzE0MjZ8bnVsbHxPUFR8SFNBfG51bGx8bnVsbA==","accountDescription":"Interest Payment","status":"PROCESSED","date":"2018-10-31","amount":"5","transactionCode":"804"},{"id":"NHw5MDQzMzE0MjZ8bnVsbHxPUFR8SFNBfG51bGx8bnVsbA==","accountDescription":"Interest Payment","status":"PROCESSED","date":"2018-09-28","amount":"4","transactionCode":"804"},{"id":"NHw5MDQzMzE0MjZ8bnVsbHxPUFR8SFNBfG51bGx8bnVsbA==","accountDescription":"Interest Payment","status":"PROCESSED","date":"2018-08-31","amount":"5","transactionCode":"804"},{"id":"NHw5MDQzMzE0MjZ8bnVsbHxPUFR8SFNBfG51bGx8bnVsbA==","accountDescription":"Interest Payment","status":"PROCESSED","date":"2018-07-31","amount":"5","transactionCode":"804"},{"id":"NHw5MDQzMzE0MjZ8bnVsbHxPUFR8SFNBfG51bGx8bnVsbA==","accountDescription":"Interest Payment","status":"PROCESSED","date":"2018-06-29","amount":"2","transactionCode":"804"},{"id":"NHw5MDQzMzE0MjZ8bnVsbHxPUFR8SFNBfG51bGx8bnVsbA==","accountDescription":"CURRENT YEAR INDIVIDUAL CONTR","status":"PROCESSED","date":"2018-06-13","amount":"15000","transactionCode":"615"}],"pagination":{"pageNumber":"1","pageSize":"20","totalCount":"20"}}';
            if(response.getStatusCode() == 200){
               
                
                if(respBody != null){
                    
                    system.debug('**responseBody in find group ==>'+respBody );
                    String responseBody = respBody.replace('\"date\":', '\"transactionDate\":');
                    ACETLGT_HSATransactionJSON2Apex ACTHSAJSON2Apex = (ACETLGT_HSATransactionJSON2Apex)JSON.deserialize(responseBody , ACETLGT_HSATransactionJSON2Apex.class);
                    transactionDetails = ACTHSAJSON2Apex.transactions;
                    system.debug('@@@transactionDetails '+transactionDetails );
                    if(transactionDetails != null){
                        for(ACETLGT_HSATransactionJSON2Apex.transactions tr: transactionDetails ){
                            htr = new ACETLGT_HSATransactionResult();
                            htr.transactionDate = (tr.transactiondate != null)?(cleanDate(String.valueof(AcetUtility.format(Date.ValueOf(tr.transactiondate))))):'';
                            //htr.transactionDateformat = date.valueOf((htr.transactionDate ));
                            htr.status          = (tr.status != null)?tr.status:'';
                            htr.transactionType = (tr.transactionCode != null)?tr.transactionCode:'';
                            htr.description     = (tr.accountDescription != null)?tr.accountDescription:'';
                            htr.amount          = (tr.amount != null)? (tr.amount.contains('.')?(tr.amount.substringAfter('.').length() == 1?tr.amount+'0':tr.amount):tr.amount+'.00'):'0.00';					
                            hsaResultList.add(htr);
                        }
                    }    
                    system.debug('@@@Result'+hsaResultList);
                    
                    searchResult.Success = true;
                    searchResult.Message = '';
                    searchResult.Response = hsaResultList;
                    
                    ACETLGT_HSATransactionJSON2Apex.Pagination pagination = ACTHSAJSON2Apex.pagination;                                                                         
                    searchResult.pageNumber =  pagination.pageNumber; 
                    searchResult.pageSize = pagination.pageSize; 
                    searchResult.totalCount = pagination.totalCount;
                    
                    system.debug('@@@searchResult'+SearchResult);

              }  
                
            }else if(response.getStatusCode() == 500 || response.getStatusCode() == 404){
                
                searchResult.MessageSeverity = ApexPages.Severity.ERROR;
                searchResult.Success = false; 
                searchResult.Message = label.ACETWebServiceUnavailableErrorMessage;               
                searchResult.Response = new List<ACETLGT_HSATransactionResult>();
                system.debug(searchResult);                
            }
            }catch(Exception e){
                    system.debug(e);
                    searchResult.MessageSeverity = ApexPages.Severity.ERROR;
                    searchResult.Success = false;
                    searchResult.Message = label.ACETOILNotAvailable;
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