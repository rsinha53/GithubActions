public with sharing class ACETLGT_GetCheckStatusWebService extends ACETWebService {
    public override void getEndpoint(){
        GetEndpointDetail('GetCheckStatusEndPoint');               
    } 
    public ACETLGT_GetCheckStatusWebService() {
        super('Stargate');
    }   
       
    public void getRequestBody(String checkSeriesDesignator, String checkEFTNumber){
        RequestBody = '{"getCheckStatusRequest": {"checkSeriesDesignator": "'+ checkSeriesDesignator + '","claimCheckNumber": "' + checkEFTNumber + '"}}';                                                              
    }
     
    public ACETWSCalloutResult getCheckStatus(String checkSeriesDesignator, String checkEFTNumber){
        ACETWSCalloutResult oACETWSCalloutResult = new ACETWSCalloutResult();
        ACETClaimDetail claimDetail = new ACETClaimDetail(); 
         
        try{            
            getEndpoint();             
            getRequestBody(checkSeriesDesignator, checkEFTNumber);                          
                                  
            HttpResponse response;  
            response = Send(OAuthConfig);    
                                           
            system.debug(response.getStatusCode());          
            if(response.getStatusCode() == 200){
                system.debug(response.getBody());
                ACETGetCheckStatusJSON2Apex json2Apex = ACETGetCheckStatusJSON2Apex.parse(response.getBody()); 
                system.debug(json2Apex);
                
                claimDetail.Payments = new List<ACETClaimDetail.Payment>();  
                ACETClaimDetail.Payment pmt = new ACETClaimDetail.Payment();
                
                pmt.SeriesDesignator = checkSeriesDesignator;
                pmt.CheckEFTNumber = checkEFTNumber;
                pmt.CheckStatus = json2Apex.getCheckStatusResponse.checkStatus;
                pmt.Sent = ACETWebserviceHelper.formatDateFromDashToSlash(json2Apex.getCheckStatusResponse.issuedDate);
                pmt.Cashed = ACETWebserviceHelper.formatDateFromDashToSlash(json2Apex.getCheckStatusResponse.cashedDate);
                if(pmt.CheckStatus == 'Matched' || pmt.CheckStatus == 'Outstanding' || pmt.CheckStatus == 'Matched; Outstanding'){
                     pmt.VoidStop = '';
                }
                else {
                    pmt.VoidStop = ACETWebserviceHelper.formatDateFromDashToSlash(json2Apex.getCheckStatusResponse.voidDate);
                }
               
                //pmt.VoidStop = ACETWebserviceHelper.formatDateFromDashToSlash(json2Apex.getCheckStatusResponse.voidDate);
                pmt.Returned = ACETWebserviceHelper.formatDateFromDashToSlash(json2Apex.getCheckStatusResponse.returnedDate);
                pmt.Reemailed = ACETWebserviceHelper.formatDateFromDashToSlash(json2Apex.getCheckStatusResponse.remailedDate);
                claimDetail.Payments.add(pmt);
                
                oACETWSCalloutResult.Success = true;
                oACETWSCalloutResult.Message = '';
                oACETWSCalloutResult.Response = claimDetail;
                
                system.debug('claimDetail:');
                system.debug(claimDetail);
                            
            }else if(response.getStatusCode() == 404 || response.getStatusCode() == 500){                               
                oACETWSCalloutResult = ParseFailureResponse(Response); 
                oACETWSCalloutResult.Message = 'Problem with GetCheckStatus Webservice: ' + oACETWSCalloutResult.Message;                                                                         
            }
         }catch(Exception e){
                system.debug(e.getStackTraceString());
                oACETWSCalloutResult.MessageSeverity = ApexPages.Severity.ERROR;
                oACETWSCalloutResult.Success = false;
                oACETWSCalloutResult.Message = 'Problem with GetCheckStatus Webservice: ' + e.getMessage();                
         }
        
        return oACETWSCalloutResult;    
    }    
}