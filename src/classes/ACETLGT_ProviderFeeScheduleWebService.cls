public class ACETLGT_ProviderFeeScheduleWebService extends ACETWebservice{
    
    public static boolean showCustomErrorMessage = false;
    
    public override void GetEndpoint()
    {
       GetEndpointDetail('FeeSchedule');
       //BaseURL = 'https://api-stg.optum.com:8443';
       //RelativeURL = '/api/alpha/eisl/provider/feeschedules/v1.0/read';
    }
     public ACETLGT_ProviderFeeScheduleWebService() {
        super('Stargate');
    }
     public ACETWSCalloutResult init(string DOSFromToday, string DOSThruToday,String dollarCharges, String dateOfServiceFrom, String dateOfServicethru,String Modifiers, String POS,string CPT, String rxNationalDrugCode, String daysOfUnits,String pricingsetId,ACETLGT_FeeScheduleWrapper diagCodes,list<ACETLGT_FeeScheduleWrapper> claimLinesInput,string drgCode,string invoiceAmount, string admissionDate, string dischargeDate,string revcode,string claimforType,string typeOfBill){
         system.debug('cliamLinesInputWS@@@'+claimLinesInput);  
         list<ACETLGT_FeeScheduleWrapper> obj = (list<ACETLGT_FeeScheduleWrapper>)claimLinesInput;
       
        ACETWSCalloutResult oACETWSCalloutResult = new ACETWSCalloutResult();
        GetEndpoint();
         //requestParameters = new List<String>{DOSFromToday,DOSThruToday,dateOfServiceFrom,dateOfServicethru,diagCodes,dollarCharges,POS,rxNationalDrugCode,daysOfUnits,Modifiers,CPT,pricingsetId};            
        GetRequestBody(DOSFromToday,DOSThruToday,dollarCharges,dateOfServiceFrom,dateOfServicethru,Modifiers,POS,CPT,rxNationalDrugCode,daysOfUnits,pricingsetId,diagCodes,claimLinesInput,drgCode,invoiceAmount,admissionDate,dischargeDate,revCode,claimforType,typeOfBill);
        
        HttpResponse Response;
        Response = Send(OAuthConfig);
        system.debug('StatusCode@@@@'+Response.getStatusCode());
        if (Response.getStatusCode() == 200)
            {
                oACETWSCalloutResult.Success = true;
                oACETWSCalloutResult.Message = '';
                oACETWSCalloutResult = ParseSuccessResponse(ReplaceKeywords(Response.getBody()));   
                
                oACETWSCalloutResult.responseBody = ReplaceKeywords(Response.getBody().replaceAll('\n','').replaceAll('\r',''));
                ACETLGT_ProviderFeeScheduleJSON2APEX reslst = (ACETLGT_ProviderFeeScheduleJSON2APEX)JSON.deserialize(Response.getBody(), ACETLGT_ProviderFeeScheduleJSON2APEX.class);
                List<ACETLGT_ProviderFeeScheduleJSON2APEX.claimLines>  claimLineslst= new List<ACETLGT_ProviderFeeScheduleJSON2APEX.claimLines>();  
                for(ACETLGT_ProviderFeeScheduleJSON2APEX.claimHeaders hed:reslst.feeScheduleDetailResponse.claimHeaders){
                    claimLineslst = hed.claimLines;
                }
                 if(claimLineslst.size()==0)
                oACETWSCalloutResult.Message = 'Pricing Not Available - Send Case For Review';
            }
          else{
                ACETLGT_ProviderFeeScheduleJSON2APEX ACETEGDJSON2Apex = (ACETLGT_ProviderFeeScheduleJSON2APEX)JSON.deserialize(Response.getBody(), ACETLGT_ProviderFeeScheduleJSON2APEX.class);
                oACETWSCalloutResult.Success = false;
                List<ACETOILError> authErrors = new List<ACETOILError>();
                if(ACETEGDJSON2Apex != null && ACETEGDJSON2Apex.feeScheduleDetailResponse != null)
                    authErrors = ACETEGDJSON2Apex.feeScheduleDetailResponse.errors;  
                oACETWSCalloutResult.Message = GetOILErrorMessage(authErrors);
                oACETWSCalloutResult.MessageSeverity = ApexPages.Severity.ERROR;  
                if(Response.getStatusCode() == 404){
                    showCustomErrorMessage = true;
                    oACETWSCalloutResult.Message = 'No Results Found';//'No Results Found';
                    oACETWSCalloutResult.MessageSeverity = ApexPages.Severity.Info; 
                }else if(Response.getStatusCode() == 500){
                    oACETWSCalloutResult.Message = 'Unexpected error occurred. Please try again. If problem persists, please contact the help desk.';
                }   
            }
       
        return oACETWSCalloutResult;
    }
    
    private void GetRequestBody(string DOSFromToday, string DOSThruToday,String dollarCharges, String dateOfServiceFrom, String dateOfServicethru,String Modifiers, String POS,string CPT, String rxNationalDrugCode, String daysOfUnits,String pricingsetId,ACETLGT_FeeScheduleWrapper diagCodes,list<ACETLGT_FeeScheduleWrapper> claimLinesInput,string drgCode,string invoiceAmount, string admissionDate, string dischargeDate,string revCode,string claimforType,string typeOfBill){
       
        StaticResource requestJSON =  [SELECT Body FROM StaticResource WHERE Name = 'ACETProviderFeeScheduleRequestTemplate'];    
        String reqBody =requestJSON.Body.toString();   
        System.debug('claimforType' +claimforType);
        System.debug('pricingsetId' +pricingsetId);
        requestParameters = new List<String>{DOSFromToday,DOSThruToday,dollarCharges,dateOfServiceFrom,dateOfServicethru,Modifiers,POS,CPT,rxNationalDrugCode,daysOfUnits,pricingsetId,diagCodes.diagnosisCode1,drgCode,invoiceAmount,admissionDate,dischargeDate,revCode,claimforType,typeOfBill};            
        reqBody = String.format(reqBody, requestParameters).replaceAll('~', '{');
        sResourceReqManipulation(diagCodes,reqBody,claimLinesInput);    
        
    }
    
    private void sResourceReqManipulation(ACETLGT_FeeScheduleWrapper  diagCodes,String reqBody,list<ACETLGT_FeeScheduleWrapper > claimLinesInput){
        System.debug('diagCodes' +diagCodes) ;    
        Map<String, Object> jsonMap = (Map<String, Object>) JSON.deserializeUntyped(reqBody);
        System.debug('jsonMap' +jsonMap);
        Map<String,Object>  reqKeys = (Map<String,Object>)jsonMap.get('feeScheduleDetailRequest');
        Map<String,Object> institutionalClaimHeaderObj = (Map<String,Object>)reqKeys.get('institutionalClaimHeader');
   
        List<Object> diagnosisCodesLst = (List<Object>)institutionalClaimHeaderObj.get('diagnosisCodes');
        diagCodePopulation(diagnosisCodesLst,diagCodes);
        
        List<Object> cliamLinesLst = (List<Object>)reqKeys.get('claimLines');
        cliamLinesLst.clear();
        cliamLinesPopulation(cliamLinesLst,claimLinesInput);
                   
        RequestBody = JSON.serialize(jsonMap);
        system.debug('Final JSON>>>'+RequestBody);
        system.debug('jsonMap>>>>'+jsonMap);
        system.debug('reqKeys>>>>>'+reqKeys);
        system.debug('institutionalClaimHeaderObj>>>>'+institutionalClaimHeaderObj);
    }
    
    private void diagCodePopulation(List<Object> diagnosisCodesLst,ACETLGT_FeeScheduleWrapper  diagCodes){
        if(String.isNotBlank(diagCodes.diagnosisCode2)){
            diagnosisCodesLst.add(addingElementToObject(diagCodes.diagnosisCode2));
        }
        if(String.isNotBlank(diagCodes.diagnosisCode3)){
            diagnosisCodesLst.add(addingElementToObject(diagCodes.diagnosisCode3));
        }
        if(String.isNotBlank(diagCodes.diagnosisCode4)){
            diagnosisCodesLst.add(addingElementToObject(diagCodes.diagnosisCode4));
        }
        if(String.isNotBlank(diagCodes.diagnosisCode5)){
            diagnosisCodesLst.add(addingElementToObject(diagCodes.diagnosisCode5));
        }
        if(String.isNotBlank(diagCodes.diagnosisCode6)){
            diagnosisCodesLst.add(addingElementToObject(diagCodes.diagnosisCode6));
        }
        if(String.isNotBlank(diagCodes.diagnosisCode7)){
            diagnosisCodesLst.add(addingElementToObject(diagCodes.diagnosisCode7));
        }
        if(String.isNotBlank(diagCodes.diagnosisCode8)){
            diagnosisCodesLst.add(addingElementToObject(diagCodes.diagnosisCode8));
        }
        if(String.isNotBlank(diagCodes.diagnosisCode9)){
            diagnosisCodesLst.add(addingElementToObject(diagCodes.diagnosisCode9));
        }
        if(String.isNotBlank(diagCodes.diagnosisCode10)){
            diagnosisCodesLst.add(addingElementToObject(diagCodes.diagnosisCode10));
        }
        if(String.isNotBlank(diagCodes.diagnosisCode11)){
            diagnosisCodesLst.add(addingElementToObject(diagCodes.diagnosisCode11));
        }
        if(String.isNotBlank(diagCodes.diagnosisCode12)){
            diagnosisCodesLst.add(addingElementToObject(diagCodes.diagnosisCode12));
        }
      
    }

    private void cliamLinesPopulation(List<Object> cliamLinesLst,list<ACETLGT_FeeScheduleWrapper > claimLinesInput){
        integer claimLineCount = 1;
        for(ACETLGT_FeeScheduleWrapper  wrapLst: claimLinesInput){
                system.debug('wrapLIst:::'+wrapLst);
                cliamLinesLst.add(addingElementToClaimsObject(wrapLst,claimLineCount)); 
                claimLineCount++;
        }
    }
    
    private Object addingElementToObject(String diagElem){
        Map<String,Object> newEle = new Map<String,Object>{'diagnosisCode'=>diagElem};
        Object objEl = (Object)newEle;
        return objEl;
    }
    
    private Object addingElementToClaimsObject(ACETLGT_FeeScheduleWrapper wrapLst,integer claimLineCount){
        wrapLst.MOdifiersList = wrapLst.MOdifiersList==null ? new List<String>() : wrapLst.MOdifiersList; 

        if(string.isNotBlank(wrapLst.modifierCode1)){
             wrapLst.MOdifiersList.add(wrapLst.modifierCode1);
        }
        if(string.isNotBlank(wrapLst.modifierCode2)){
             wrapLst.MOdifiersList.add(wrapLst.modifierCode2);
        }
        if(string.isNotBlank(wrapLst.modifierCode3)){
             wrapLst.MOdifiersList.add(wrapLst.modifierCode3);
        }
        if(string.isNotBlank(wrapLst.modifierCode4)){
             wrapLst.MOdifiersList.add(wrapLst.modifierCode4);
        }
      
        List<Object> modfiersList = new List<Object>();
        if(wrapLst.modifiersList != null){
            for(string str : wrapLst.modifiersList){
                Map<String,Object> modifiersMap = new Map<String,Object>{'code'=>str};
                Object mdObj = (Object)modifiersMap;
                modfiersList.add(mdObj);
            }
         }  
		 
		
		 
        system.debug('from:::'+wrapLst.dateOfServicethru + 'thru::'+wrapLst.dateOfServiceFrom);
        string specialChar = string.valueOf(claimLineCount);
        Map<String,Object> newEle = new Map<String,Object>{
                                    'billedAmount'=>wrapLst.billedAmount,
                                    'claimLineNumber'=>specialChar,
                                    'dateOfServiceThru'=>ChangeDateFormatForOIL(wrapLst.dateOfServicethru),
                                    'dateOfServiceFrom'=>ChangeDateFormatForOIL(wrapLst.dateOfServiceFrom),
                                    'modifierCodes' =>modfiersList,
                                    'mprPercent'=>'',
                                    'pickupPostalCode'=>'',
                                    'placeOfServiceCode'=>wrapLst.placeOfServiceCode,
                                    'procedureCodeType'=>'',
                                    'procedureCode'=>wrapLst.procedureCode,
                                    'recommendedAllowPercentIndicator'=>'',
                                    'recommendedAllowPercent'=>'',
                                    'revenueCode'=>wrapLst.revCode,
                                    'rxNationalDrugCode'=>wrapLst.rxNationalDrugCode,
                                    'serviceUnits'=>wrapLst.serviceUnits,
                                    'unitCode'=>''
                                    };
        Object objEl = (Object)newEle;
        return objEl;
    }
    
   private ACETWSCalloutResult ParseSuccessResponse(String ResponseBody)  {
       ACETWSCalloutResult oACETWSCalloutResult = new ACETWSCalloutResult();        
       system.debug('ResponseBody@@@ ' + ResponseBody);
       ACETLGT_ProviderFeeScheduleJSON2APEX ACTPFSJSON2Apex = (ACETLGT_ProviderFeeScheduleJSON2APEX)JSON.deserialize(ResponseBody, ACETLGT_ProviderFeeScheduleJSON2APEX.class);
       system.debug('ACTPFSJSON2Apex@@@ ' + ACTPFSJSON2Apex);          
       oACETWSCalloutResult.Success = true;
       oACETWSCalloutResult.Message = '';
       oACETWSCalloutResult.Response = ACTPFSJSON2Apex; 
       return oACETWSCalloutResult;
    }
    
    public Continuation StartRequest(string DOSFromToday, string DOSThruToday, String dollarCharges, String dateOfServiceFrom, String dateOfServicethru,String Modifiers, String POS,string CPT, String rxNationalDrugCode, String daysOfUnits,String pricingsetId, ACETLGT_FeeScheduleWrapper diagCodes,list<ACETLGT_FeeScheduleWrapper> claimLinesInput,string drgCode,string invoiceAmount, string admissionDate, string dischargeDate,string revCode,string claimforType,string typeOfBill,String returningFrom, 
            String CallbackMethodName,Continuation oContinuation){
        GetEndpoint();
        GetRequestBody(DOSFromToday,DOSThruToday,dollarCharges,dateOfServiceFrom,dateOfServicethru,Modifiers,POS,CPT,rxNationalDrugCode,daysOfUnits,pricingsetId,diagCodes,claimLinesInput,drgCode,invoiceAmount,admissionDate,dischargeDate,revCode,claimforType,typeOfBill);
        return oContinuation;
    }
    
     public override ACETWSCalloutResult queryPaginatedData(Integer pageNumber, Integer pageSize, Integer startRecord) {
        system.debug(LoggingLevel.INFO, 'Page Number: ' + pageNumber + ', Page Size: ' + pageSize + ', Start Record: ' + startRecord);
        ACETWSCalloutResult oACETWSCalloutResult = new ACETWSCalloutResult();
        
        try
        {
            system.debug('DataRes@@@11 ');
            HttpResponse Response = Send(OAuthConfig);
            system.debug('DataRes@@@22 ' + Response.getBody());
            if (Response.getStatusCode() == 200 || Response.getStatusCode() == 400) {
                
                oACETWSCalloutResult = ParseSuccessResponse(ReplaceKeywords(Response.getBody().replaceAll('\n','')));  
                system.debug('oACETWSCalloutResult@@@ ' + oACETWSCalloutResult);
            }
            else {
                oACETWSCalloutResult = ParseFailureResponse(Response);
                oACETWSCalloutResult.Success = false;
                oACETWSCalloutResult.MessageSeverity = ApexPages.Severity.ERROR;        
            }
        }
        catch(Exception ex)
        {
            system.debug(LoggingLevel.INFO, 'Exception in Find Medical Providers. Details: ' + ex); 
            System.debug(LoggingLevel.INFO, 'getStackTraceString ' + ex.getStackTraceString());
            oACETWSCalloutResult.Success = false;
            oACETWSCalloutResult.Message = ex.getMessage();
            oACETWSCalloutResult.MessageSeverity = ApexPages.Severity.ERROR;
        }
        system.debug(LoggingLevel.INFO, 'oACETWSCalloutResult: ' + oACETWSCalloutResult);
        return oACETWSCalloutResult;
    }
     public String ChangeDateFormatForOIL(String OILDate) {
         String FormattedDate = '';  
         if (String.isNotBlank(OILDate)) {
             List<String> OILDateSplit = OILDate.split('-');
             if(OILDateSplit.size() == 3) { 
                 String appendMonth = OILDateSplit[1];
                 String appendDay = OILDateSplit[2];
                 
                 appendMonth = String.isBlank(appendMonth) ? appendMonth : appendMonth.leftPad(2,'0');
                 appendDay = String.isBlank(appendDay) ? appendDay : appendDay.leftPad(2,'0');
                 
                 FormattedDate = OILDateSplit[0] + '-' + appendMonth + '-' + appendDay;
             }
         }
         system.debug('>>'+FormattedDate);
         return FormattedDate;
     }

}