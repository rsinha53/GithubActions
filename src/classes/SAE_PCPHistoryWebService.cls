public class SAE_PCPHistoryWebService {
    @AuraEnabled
    public static  map<String,Object> getPCPHistoryWS(String transactionId){
        map<String,Object> responseMap = new map<String,Object>();
        
        ACETWSCalloutResult calloutResult = new ACETWSCalloutResult();
        List<SAE_PCPHistoryResult> result = new list<SAE_PCPHistoryResult>();
        try{
            String responseStr = '';
            HttpResponse response;
            //US2505481 : Add Mock response in Lower sandboxes
            Boolean isStaticResponseChecked = false;
            isStaticResponseChecked = SAEUtils.getMockStatus();
            System.debug('@@ SAE_PCPHistoryWebService: getPCPHistoryWS: isStaticResponseChecked: '+isStaticResponseChecked);
            
            if(isStaticResponseChecked && !Test.isRunningTest()) {
                String searchparameter = 'PCPHistory_' + transactionId.remove('-').remove('%').substring(0, 29);
                response = SAEUtils.getResponse(searchparameter);
            } else {
                String reqMethod='GET';
                String endPoint = ISL_Webservice_Config__c.getInstance('SAE_PCPHistory').Value__c; 
                String resultQuery = '?transactionId='+transactionId;
                system.debug('resultQuery::: ' + resultQuery);           
                StaticResource responseJSONSR = null;
                String responseBody;
                
                response = SAEWebservice.makeCallout(resultQuery,endPoint,reqMethod);
            }
			responseStr = response.getBody();
            Integer statusCode = response.getStatusCode();
            //US2101438 - Error Code Handling - PCPEmployerHistory API - Nikhil
            if(statusCode == 200){
                calloutResult.statusCode= response.getStatusCode();
                system.debug('responseStr WS:::'+response.getBody());  
                if(responseStr != null && String.isNotBlank(responseStr)){
                    Map<String, Object> pcpMainMap = (Map<String, Object>)JSON.deserializeUntyped(responseStr);
                    List<Object> pcpHistoryRespMap = (List<Object>)pcpMainMap.get('providerHistoryResponseList');
                    
                    SAEPCPHistoryJSON2Apex json2Apex;
                    list<SAE_PCPHistoryResult> respToReturn = new list<SAE_PCPHistoryResult>();
                    
                    
                    for(Object obj : pcpHistoryRespMap){
                        Map<String, Object> mapobj = (Map<String, Object>)obj;
                        SAE_PCPHistoryResult ss = new SAE_PCPHistoryResult();
                        
                        string startDate = (String)mapobj.get('coverageStartDate');
                        string endDate = (String)mapobj.get('coverageEndDate');
                        if(String.isNotBlank(endDate)){
                            
                            ss.coverageEndDate = endDate == 'Present' ? endDate : SAEUtils.formatDate(endDate);
                        }
                        
                        
                        if(String.isNotBlank(startDate)){
                            ss.coverageStartDate = SAEUtils.formatDate(startDate);
                        }
                        ss.prvGrpNumber = (String)mapobj.get('providerGrpNumber');
                        ss.prvGrpName = (String)mapobj.get('providerGrpName');
                        ss.pcpNumber = (String)mapobj.get('pcpNumber');
                        ss.pcpName = (String)mapobj.get('pcpName');
                        respToReturn.add(ss);
                    }
                    result = respToReturn;
                    
                    responseMap.put('success',true);
                    responseMap.put('Message','');
                    responseMap.put('Response',result);
                    responseMap.put('statusCode',statusCode);
                }
            }else{
                if(statusCode == 400){
                    calloutResult.Message = SAEMemberProviderWS.getErrorMessage(SAEConstants.GN400);
                }
                else if(statusCode == 500){
                    calloutResult.Message = SAEMemberProviderWS.getErrorMessage(SAEConstants.GN500A);
                }
                else if(statusCode == 404){
                    calloutResult.Message = SAEMemberProviderWS.getErrorMessage(SAEConstants.GN404);
                }
                responseMap.put('Success',false);
                responseMap.put('Message',calloutResult.Message);
                responseMap.put('statusCode',statusCode);
            }
        }catch(Exception e){
            system.debug('gettracking'+e.getStackTraceString());
            
            responseMap.put('MessageSeverity',ApexPages.Severity.ERROR);
            responseMap.put('Success',false);
            responseMap.put('Message','Web Service or External System is temporarily unavailable.');
            responseMap.put('statusCode',999);
        }
        system.debug('%%%%%'+responseMap);
        return responseMap;
    }
    
    public class SAE_PCPHistoryResult{
        @AuraEnabled public String coverageStartDate;
        @AuraEnabled public String coverageEndDate;
        @AuraEnabled public String prvGrpNumber;
        @AuraEnabled public String prvGrpName;
        @AuraEnabled public String pcpNumber;
        @AuraEnabled public String pcpName;
        public SAE_PCPHistoryResult(){
            
        }
        
    }
}