public class SAEGetCOBWebService {

    public ACETWSCalloutResult getCobData(String transactionId){
      
        ACETWSCalloutResult calloutResult = new ACETWSCalloutResult();
        
        try{
            Boolean isStaticResponseChecked = false;
            String responseStr = '';
            HttpResponse response;
            isStaticResponseChecked = SAEUtils.getMockStatus();
            if(isStaticResponseChecked && !Test.isRunningTest()) {
                String searchparameter = 'ExtendedCoverage_' + transactionId.remove('-').remove('%').substring(0, 23);
                response = SAEUtils.getResponse(searchparameter);
            } else {
                //Directly get data from WS
                String reqMethod='GET';
                String endPoint = ISL_Webservice_Config__c.getInstance('SAE_PolicySearch').Value__c; 
                String resultQuery = '?transactionId='+EncodingUtil.urlEncode(transactionId, 'UTF-8'); //DE282083 - 05/12/2019 - Sarma
                         
                StaticResource responseJSONSR = null;
                String responseBody;
                
                response = SAEWebservice.makeCallout(resultQuery,endPoint,reqMethod);
                calloutResult.statusCode= response.getStatusCode();
            }
            responseStr = response.getBody(); 
            calloutResult.Success = true;          
            calloutResult.Response = (SAECOBWrapper)getCOBResult(responseStr);           
        }        
        catch(Exception e){
            //system.debug(e.getStackTraceString());
            calloutResult.MessageSeverity = ApexPages.Severity.ERROR;
            calloutResult.Success = false;
            calloutResult.Message = 'Web Service or External System is temporarily unavailable.';
            calloutResult.statusCode=999;
        }
        
        
        return calloutResult;
    }
    //this method parsing the response string into SAECOBWrapper by vishnu kasu
	public SAECOBWrapper getCOBResult(string responseStr)
	{
		SAECOBWrapper cobDataWrapper = new SAECOBWrapper();
        SAECOBWrapper.Cob cobObj;
        SAECOBWrapper.additionalCoverage additionalCoverageObj;
        List<SAECOBWrapper.additionalCoverage> coverageLine = new List<SAECOBWrapper.additionalCoverage>();
		
                
                Map<String, Object> policyMainMap = (Map<String, Object>)JSON.deserializeUntyped(responseStr); 
                Map<String, Object> policyCobInfoMap = (Map<String, Object>)policyMainMap.get('additionalPlanDetails');
                Map<String, Object> policyCobUpdateInfoMap = (Map<String, Object>)policyCobInfoMap.get('cobUpdateInformation');
                
                if (!policyCobUpdateInfoMap.isEmpty()){
                    cobObj = new SAECOBWrapper.Cob();
                    
                    
                    String dateStr = (String)policyCobUpdateInfoMap.get('cobLastUpdate');
                    if(String.isNotBlank(dateStr)){
                        cobObj.cobLastUpdate = SAEUtils.formatDate(dateStr);
                    }
                    cobObj.cobUpdateMessage = (String)policyCobUpdateInfoMap.get('cobUpdateMessage');
                    String indicator = (String)policyMainMap.get('medicareIndicator');
                    cobObj.medicareIndicator = trsanslaterMethod(indicator);
                    // US2122648 Targeted COB Details - Medicare Entitlement Reason Integration - 25/10/2019 - Sarma
                    cobObj.medicareEntitlementReason = (String)policyMainMap.get('medicareEntitlementReason');
                    cobDataWrapper.cob = cobObj;
                    
                }
                //US1954477	Targeted COB Details - Integration - 30/09/2019 - Sarma
                //block to retrive additional coverage details from respone
                //New codes in top block as well
                if (!policyMainMap.isEmpty()){
                    
                    List<Object> additionalCoverages = (List<Object>) policyMainMap.get('additionalCoverage');
                    
                    for(Object coverage : additionalCoverages){
                        Integer i = 0; 
                        Map<String,Object> coverageObj = (Map<String,Object>)coverage;
                        additionalCoverageObj = new SAECOBWrapper.additionalCoverage();
                        if(coverageObj.get('primaryGroupIndicator') != null && coverageObj.get('primaryGroupIndicator') != ''){
                            additionalCoverageObj.primaryGroupIndicator = (String)coverageObj.get('primaryGroupIndicator');
                        }
                        if(coverageObj.get('payerName') != null && coverageObj.get('payerName') != ''){
                            additionalCoverageObj.payerName = (String)coverageObj.get('payerName');      
                        }
                        if(coverageObj.get('coverageType') != null && coverageObj.get('coverageType') != ''){
                            additionalCoverageObj.coverageType = (String)coverageObj.get('coverageType');
                        }
                        String startDate = (String)coverageObj.get('policyEffectiveStartDate');
                        if(String.isNotBlank(startDate)){
                            additionalCoverageObj.policyEffectiveDates = SAEUtils.formatDate(startDate) + ' - ';
                            // US2138007	Update Logic for Targeted COB - 25/10/2019 - Sarma
                            additionalCoverageObj.policyEffectiveStartDate = SAEUtils.formatDate(startDate);
                        }
                        String endDate = (String)coverageObj.get('policyEffectiveEndDate');
                        if(String.isNotBlank(endDate)){
                            additionalCoverageObj.policyEffectiveDates = additionalCoverageObj.policyEffectiveDates + SAEUtils.formatDate(endDate);
                        }
                        coverageLine.add(additionalCoverageObj);
                        i++;
                       
                    }
                    cobDataWrapper.additionalCoverageList = coverageLine;
                    
                }
             return cobDataWrapper;
	}
    //US1954477 - Translate the code to actual string according to the DD data - 30/09/2019 - Sarma
    public String trsanslaterMethod(String code){
        String returnString='';
        
        COB_MedicareIndicator__mdt[] medicareIndicators = [SELECT MedicareIndicator__c, MedicareIndicatorString__c FROM COB_MedicareIndicator__mdt];
        
        for(COB_MedicareIndicator__mdt indicator : medicareIndicators){
            if(indicator.MedicareIndicator__c == code){
                returnString = indicator.MedicareIndicatorString__c;
            }
        }
        if(code ==''){
            returnString ='Not qualified for Medicare';
        }    
        return returnString;
    }
    
}