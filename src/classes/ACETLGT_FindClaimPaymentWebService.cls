public with sharing class ACETLGT_FindClaimPaymentWebService extends ACETWebService{
    private String m_claimId;
    public List<String> searchParameters ;
    Public String c_checkSeriesDesignatorNumber{get;set;} 
    Public String c_paymentTrackingNumber{get;set;} 
    Public String c_enrolleeFirstName{get;set;} 
    Public String c_enrolleeLastName{get;set;} 
    Public String c_enrolleeCardSerialNumber{get;set;}
    public map<String,String> errorMap=new map<String,String>();
    public override void getEndpoint(){
        GetEndpointDetail('FindClaimPaymentsEndpoint');               
    }  
    public ACETLGT_FindClaimPaymentWebService() {
        super('Stargate');
        List<AcetErrorMessage__mdt> ErrorMessages =[SELECT  masterlabel,Error_Message__c,Message_Type__c,ServiceError__c,TopPriority__c,
                                                    Error_log_enabled__c FROM AcetErrorMessage__mdt ];//where masterlabel=:errorCode
        for(AcetErrorMessage__mdt em:ErrorMessages){
            errorMap.put(em.masterlabel, em.Error_Message__c);
        }
    }  
       
    public void getRequestBody(String claimId){
        RequestBody = '{'
            + '"findClaimPaymentsRequest": {'
                + '"claimID": "' + claimId + '"'    
            + '}'
            + '}';
    }
     
    //init service query params
    public void init(String claimId){
        m_claimId = claimId;
    }
    
    public ACETWSCalloutResult getClaimPayments(String claimId){
        ACETWSCalloutResult result = new ACETWSCalloutResult();
        ACETClaimDetail claimDetail = new ACETClaimDetail();
        
        try{
            getEndpoint();   
            getRequestBody(claimId);
            
            HttpResponse response;
            
            response = Send(OAuthConfig);
            
            
            system.debug(response.getStatusCode());
            result.statusCode = response.getStatusCode();
            if(response.getStatusCode() == 200){
                system.debug(response.getBody());
                ACETFindClaimPaymentJSON2Apex json2Apex = ACETFindClaimPaymentJSON2Apex.parse(response.getBody());
                system.debug(json2Apex);
                
                if(json2Apex.findClaimPaymentsResponse.claimpayment != null && json2Apex.findClaimPaymentsResponse.claimpayment.size() > 0){
                    if(json2Apex.findClaimPaymentsResponse.claimpayment[0].claim != null && json2Apex.findClaimPaymentsResponse.claimpayment[0].claim.size() > 0){
                        claimDetail.ClaimProcessed = ACETWebserviceHelper.formatDateFromDashToSlash(json2Apex.findClaimPaymentsResponse.claimpayment[0].claim[0].claimEventAdjudicationDateTime);
                    }
                    
                    claimDetail.Payments = new List<ACETClaimDetail.Payment>();
                    for(ACETFindClaimPaymentJSON2Apex.cls_payment payment : json2Apex.findClaimPaymentsResponse.claimpayment[0].payment){
                        ACETClaimDetail.Payment pmt = new ACETClaimDetail.Payment();
                        pmt.PaymentTotal = payment.checkOrEFTAmount;
                        pmt.PaymentType = payment.paymentMethodTypeCode;
                        pmt.SeriesDesignator = payment.checkSeriesDesignatorNumber;
                        pmt.CheckEFTNumber = payment.paymentTrackingNumber;
                        pmt.OverPaymentWithheld = payment.overPaymentWithheldAmt;
                        pmt.BulkPayment = payment.bulkPaymentIndicator;
                        //pmt.ClaimProcessed = claimProcessedDate;
                        //pmt.CheckStatus = payment.paymentStatus.code;
                        pmt.PayeeName = payment.payeeName;
                        //Sampath Added the paymentIssueDate and change the format of the date coming to have dd/mm/yyyy format
                        if(payment.paymentIssueDate != null)
                        {
                            String[] paymentdate = payment.paymentIssueDate.split('-');
                            pmt.PaymentIssueDate = paymentdate[1]+'/'+paymentdate[2]+'/'+paymentdate[0];
                                
                        }
                        //pmt.PaymentIssueDate=String.ValueOf(payment.PaymentIssueDate);
                        if(payment.payeeAddress != null){                           
                            pmt.PayeeAddress = (payment.payeeAddress.addressLine1 == null ? '' : payment.payeeAddress.addressLine1) + (payment.payeeAddress.addressLine2 == null ? '' : (' ' + payment.payeeAddress.addressLine2));
                            pmt.PayeeCity = payment.payeeAddress.city;
                            pmt.PayeeState = payment.payeeAddress.state;
                            pmt.PayeeZip = payment.payeeAddress.postalCode;
                        }
                        claimDetail.Payments.add(pmt);
                    }
                }
                result.MessageSeverity = ApexPages.Severity.INFO;
                result.Success = true;
                result.Response = claimDetail;
                result.Message = '';
                                
            }else if(response.getStatusCode() == 404){
                result.MessageSeverity = ApexPages.Severity.ERROR;
                result.Success = false;
                result.Message = errorMap.get('GN404');
                 result.statusCode=response.getStatusCode();
            }else if(response.getStatusCode() == 500  ){
                result = ParseFailureResponse(Response);
                result.Success = false;
                result.Message = errorMap.get('GN500');
                result.statusCode=response.getStatusCode();
            }else if(response.getStatusCode() == 400  ){
                result = ParseFailureResponse(Response);
                result.Success = false;
                result.Message = errorMap.get('GN400');
                 result.statusCode=response.getStatusCode();
            }
            else {
                result.MessageSeverity = ApexPages.Severity.ERROR;
                result.statusCode = response.getStatusCode();
                result.Message = 'result.Message';
            }
         }catch(Exception e){
             system.debug('Exception is '+e.getmessage()+'at line '+e.getLineNumber());
                system.debug(e.getStackTraceString());
                result.MessageSeverity = ApexPages.Severity.ERROR;
                result.Success = false;
                result.Message = 'Problem with FindClaimPayment Webservice: ' + e.getMessage();
         }
        
        return result;
    }
     
    public void init(String checkSeriesDesignatorNumber, String paymentTrackingNumber, String enrolleeFirstName, String enrolleeLastName, String enrolleeCardSerialNumber){ 
         c_checkSeriesDesignatorNumber = checkSeriesDesignatorNumber;
         c_paymentTrackingNumber = paymentTrackingNumber;
         c_enrolleeFirstName = enrolleeFirstName.toUpperCase();
         c_enrolleeLastName = enrolleeLastName.toUpperCase();
         c_enrolleeCardSerialNumber = enrolleeCardSerialNumber;
    }
    
    Public Void getRequestBody()
    {
        //correct request
        RequestBody = '{"findClaimPaymentsRequest": {"checkSeriesDesignatorNumber": "'+c_checkSeriesDesignatorNumber+'","paymentTrackingNumber": "'+c_paymentTrackingNumber+'","enrolleeFirstName": "'+c_enrolleeFirstName+'","enrolleeLastName": "'+c_enrolleeLastName+'","enrolleeCardSerialNumber": "'+c_enrolleeCardSerialNumber+'","pagination": {"pageNumber": "","pageSize": ""},"sorting": [{"sortColumnName": "","sortOrderType": ""}]}}';
        //RequestBody = '{"findClaimPaymentsRequest": {"checkSeriesDesignatorNumber": "'+c_checkSeriesDesignatorNumber+'","paymentTrackingNumber": "'+c_paymentTrackingNumber+',"enrolleeFirstName": "'+c_enrolleeFirstName+'","enrolleeLastName": "'+c_enrolleeLastName+'","enrolleeCardSerialNumber": "'+c_enrolleeCardSerialNumber+'","pagination": {"pageNumber": "","pageSize": ""},"sorting": [{"sortColumnName": "","sortOrderType": ""}]}}';
    }
    
    public override void GetHeaders(ISL_Webservice_Config__c OAuthConfig){
        /*if (WSConfigurations.containsKey('OILHttpHeaderAccept')){
            Headers.put('accept','application/json');
        }*/
        if (WSConfigurations.containsKey('OILHttpHeaderScope')){
            Headers.put('scope', 'search');
        }
        if (WSConfigurations.containsKey('OILHttpHeaderActor')){
            Headers.put('actor', WSConfigurations.get('OILHttpHeaderActor').Value__c);
        }
        Headers.put('authorization', 'Bearer ' + OAuthConfig.Value__c);           
        Headers.put('Content-Type','application/json');
        //Headers.put('timestamp', String.valueOf(system.now().millisecond()));
        Headers.put('Accept', 'application/json');
    }
    
    public ACETWSCalloutResult findClaimPayments(){
        ACETWSCalloutResult result = new ACETWSCalloutResult();
        ACETClaimDetail claimDetail = new ACETClaimDetail(); 
        List<ACETClaimPaymentResult> resultlist = new List<ACETClaimPaymentResult>();
        
        
        
        //searchParameters = new String[] {checkSeriesDesignatorNumber,paymentTrackingNumber,enrolleeFirstName,enrolleeLastName,enrolleeCardSerialNumber};
        try{            
            getEndpoint();             
            getRequestBody();                 
        
                                  
            HttpResponse response;  
            response = Send(OAuthConfig);    
                                           
            system.debug(response.getStatusCode()); 
            result.statusCode = response.getStatusCode();
            if(response.getStatusCode() == 200){
                system.debug(response.getBody());
                ACETFindClaimPaymentJson2Apex json2Apex = (ACETFindClaimPaymentJson2Apex)JSON.deserialize(Response.getBody(), ACETFindClaimPaymentJson2Apex.class);
                system.debug('json2Apex '+json2Apex);
                
                
                if(json2Apex.findClaimPaymentsResponse.claimpayment != null && json2Apex.findClaimPaymentsResponse.claimpayment.size() > 0){                    
                    if(json2Apex.findClaimPaymentsResponse.claimpayment[0].claim != null && json2Apex.findClaimPaymentsResponse.claimpayment[0].claim.size() > 0){
                        claimDetail.ClaimProcessed = ACETWebserviceHelper.formatDateFromDashToSlash(json2Apex.findClaimPaymentsResponse.claimpayment[0].claim[0].claimEventAdjudicationDateTime);           
                    }    
                                               
                    claimDetail.Payments = new List<ACETClaimDetail.Payment>();  
                    for(ACETFindClaimPaymentJSON2Apex.cls_claimpayment clmpayment : json2Apex.findClaimPaymentsResponse.claimpayment){
                        for(ACETFindClaimPaymentJSON2Apex.cls_payment payment : clmpayment.payment)
                        {
                        ACETClaimPaymentResult pmt = new ACETClaimPaymentResult();
                        pmt.PaymentTotal = payment.checkOrEFTAmount;
                        pmt.PaymentType = payment.paymentMethodTypeCode;
                        pmt.SeriesDesignator = payment.checkSeriesDesignatorNumber;
                        pmt.CheckEFTNumber = payment.paymentTrackingNumber;
                        //pmt.OverPaymentWithheld = payment.overPaymentWithheldAmt;
                        pmt.BulkCheck = payment.bulkPaymentIndicator;
                        //pmt.ClaimProcessed = claimProcessedDate;
                        //pmt.CheckStatus = payment.paymentStatus.code;
                        //pmt.CheckStatus = payment.
                        pmt.PayeeType = payment.payeeTypeCode.description;
                        pmt.PayeeName = payment.payeeName;
                            String paymentdatestr;
                            if(payment.paymentIssueDate != null)
                            {
                                String[] paymentdate = payment.paymentIssueDate.split('-');
                                paymentdatestr = paymentdate[1]+'/'+paymentdate[2]+'/'+paymentdate[0];
                                
                            }
                              
                              system.debug('pmt.paymentIssueDate is'+pmt.paymentIssueDate);
                              //pmt.paymentIssueDate=paymentdatestr;
                            //pmt.IssuedDate = date.parse(paymentdatestr);
                            pmt.checkDate = paymentdatestr;
                        if(payment.payeeAddress != null){
                            pmt.PayeeAddressLine1 = payment.payeeAddress.addressLine1 != null ? payment.payeeAddress.addressLine1 : '';
                            pmt.PayeeAddressLine2 = payment.payeeAddress.addressLine2 != null ? payment.payeeAddress.addressLine2 : '';
                            pmt.PayeeAddress = pmt.PayeeAddressLine1 + ' ' + pmt.PayeeAddressLine2;
                            pmt.City = payment.payeeAddress.city;
                            pmt.State = payment.payeeAddress.state;
                            pmt.Zip = payment.payeeAddress.postalCode;
                        }
                        resultlist.add(pmt);
                        }
                    } 
                }
                result.MessageSeverity = ApexPages.Severity.INFO;
                result.Success = true;                
                result.Response = resultlist;
                result.Message = String.valueof(json2Apex.findClaimPaymentsResponse.claimpayment[0].payment.size());
                system.debug('result.Message is '+result.Message);                          
                                
            }else if(response.getStatusCode() == 404){
                result.MessageSeverity = ApexPages.Severity.ERROR;
                result.Success = false;
                result.Message = errorMap.get('GN404');
                result.statusCode=response.getStatusCode();
            }else if(response.getStatusCode() == 500  ){
                result = ParseFailureResponse(Response);
                result.Success = false;
                result.Message = errorMap.get('GN500');
                result.statusCode=response.getStatusCode();
            }else if(response.getStatusCode() == 400  ){
                result = ParseFailureResponse(Response);
                result.Success = false;
                result.Message = errorMap.get('GN400');
                result.statusCode=response.getStatusCode();
            }else {
                result.Success = false;
            }
         }catch(Exception e){
                system.debug(e.getStackTraceString());
                result.MessageSeverity = ApexPages.Severity.ERROR;
                result.Success = false;
                result.Message = 'Problem with FindClaimPayment Webservice: ' + e.getMessage();  
                //status 999 for ACETErrorHandler metadata class
                result.StatusCode = 999;
         }
        
        return result;  
    }
    
    public override ACETWSCalloutResult queryPaginatedData(Integer pageNumber, Integer pageSize, Integer startRecord){
        ACETWSCalloutResult result = new ACETWSCalloutResult();
        ACETClaimDetail claimDetail = new ACETClaimDetail(); 
        List<ACETClaimPaymentResult> resultlist = new List<ACETClaimPaymentResult>();
        //searchParameters = new String[] {checkSeriesDesignatorNumber,paymentTrackingNumber,enrolleeFirstName,enrolleeLastName,enrolleeCardSerialNumber};
        try{            
            getEndpoint();             
            getRequestBody();                          
                               
            RequestBody = RequestBody.replace('"pageNumber": ""','"pageNumber": "' + pageNumber + '"');
            RequestBody = RequestBody.replace('"pageSize": ""','"pageSize": "' + pageSize + '"');
            RequestBody = RequestBody.replace('"startRecord": ""','"startRecord": "' + startRecord + '"');
            
            HttpResponse response;  
            response = Send(OAuthConfig);    
                                           
            system.debug('response is '+response.getbody());    
            result.statusCode = response.getStatusCode();
            if(response.getStatusCode() == 200){
                system.debug(response.getBody());
                ACETFindClaimPaymentJson2Apex json2Apex = (ACETFindClaimPaymentJson2Apex)JSON.deserialize(Response.getBody(), ACETFindClaimPaymentJson2Apex.class);
                system.debug('json2Apex '+json2Apex);
                
                
                if(json2Apex.findClaimPaymentsResponse.claimpayment != null && json2Apex.findClaimPaymentsResponse.claimpayment.size() > 0){                    
                    if(json2Apex.findClaimPaymentsResponse.claimpayment[0].claim != null && json2Apex.findClaimPaymentsResponse.claimpayment[0].claim.size() > 0){
                        claimDetail.ClaimProcessed = ACETWebserviceHelper.formatDateFromDashToSlash(json2Apex.findClaimPaymentsResponse.claimpayment[0].claim[0].claimEventAdjudicationDateTime);           
                    }    
                                               
                    claimDetail.Payments = new List<ACETClaimDetail.Payment>();  
                    for(ACETFindClaimPaymentJSON2Apex.cls_claimpayment clmpayment : json2Apex.findClaimPaymentsResponse.claimpayment){
                        for(ACETFindClaimPaymentJSON2Apex.cls_payment payment : clmpayment.payment)
                        {
                        ACETClaimPaymentResult pmt = new ACETClaimPaymentResult();
                        pmt.PaymentTotal = payment.checkOrEFTAmount;
                        pmt.PaymentType = payment.paymentMethodTypeCode;
                        pmt.SeriesDesignator = payment.checkSeriesDesignatorNumber;
                        pmt.CheckEFTNumber = payment.paymentTrackingNumber;
                        //pmt.OverPaymentWithheld = payment.overPaymentWithheldAmt;
                        pmt.BulkCheck = payment.bulkPaymentIndicator;
                        //pmt.ClaimProcessed = claimProcessedDate;
                        //pmt.CheckStatus = payment.paymentStatus.code;
                        //pmt.CheckStatus = payment.
                        pmt.PayeeType = payment.payeeTypeCode.description;
                        pmt.PayeeName = payment.payeeName;
                            String paymentdatestr;
                            if(payment.paymentIssueDate != null)
                            {
                                String[] paymentdate = payment.paymentIssueDate.split('-');
                                paymentdatestr = paymentdate[1]+'/'+paymentdate[2]+'/'+paymentdate[0];
                                
                            }
                              
                              system.debug('pmt.paymentIssueDate is'+pmt.paymentIssueDate);
                              //pmt.paymentIssueDate=paymentdatestr;
                            //pmt.IssuedDate = date.parse(paymentdatestr);
                            pmt.checkDate = paymentdatestr;
                        if(payment.payeeAddress != null){
                            pmt.PayeeAddressLine1 = payment.payeeAddress.addressLine1 != null ? payment.payeeAddress.addressLine1 : '';
                            pmt.PayeeAddressLine2 = payment.payeeAddress.addressLine2 != null ? payment.payeeAddress.addressLine2 : '';
                            pmt.PayeeAddress = pmt.PayeeAddressLine1 + ' ' + pmt.PayeeAddressLine2;
                            pmt.City = payment.payeeAddress.city;
                            pmt.State = payment.payeeAddress.state;
                            pmt.Zip = payment.payeeAddress.postalCode;
                        }
                        resultlist.add(pmt);
                        }
                    } 
                }
                result.MessageSeverity = ApexPages.Severity.INFO;
                result.Success = true;                
                result.Response = resultlist;
                result.Message = String.valueof(json2Apex.findClaimPaymentsResponse.claimpayment[0].payment.size());
                system.debug('result.Message is '+result.Message);                          
                                
            }else if(response.getStatusCode() == 404){
                result.MessageSeverity = ApexPages.Severity.ERROR;
                result.Success = false;
                result.Message = errorMap.get('GN404');
                result.statusCode=response.getStatusCode();
            }else if(response.getStatusCode() == 500  ){
                result = ParseFailureResponse(Response);
                result.Success = false;
                result.Message = errorMap.get('GN500');
                result.statusCode=response.getStatusCode();
            }else if(response.getStatusCode() == 400  ){
                result = ParseFailureResponse(Response);
                result.Success = false;
                result.Message = errorMap.get('GN400');
                result.statusCode=response.getStatusCode();
            }
         }catch(Exception e){
                system.debug(e.getStackTraceString());
             system.debug('Exception is '+e.getmessage()+'at line '+e.getLineNumber());
                result.MessageSeverity = ApexPages.Severity.ERROR;
                result.Success = false;
                result.Message = 'Problem with FindClaimPayment Webservice: ' + e.getMessage();  
                //status 999 for ACETErrorHandler metadata class
                result.StatusCode = 999;
         }
        
        return result;
    }
    
}