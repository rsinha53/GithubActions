/* 
 * @name         :   ACETLGT_GetBenefitAccumsWebService
 * @description  :   This component  is created to call webservice for the accumulator and pass the accums to benefit language webservice. 
 * @author       :   Sai Kolluru
 * @createddate  :   18-08-2021
 * @lastmodifiedby:
 *
 */
public class ACETLGT_GetBenefitAccumsWebService extends ACETWebservice{

    Map<String,ACETLGT_PlanBenefitLanguageWrapper.AccumulatorCode> accumMap = new Map<String,ACETLGT_PlanBenefitLanguageWrapper.AccumulatorCode>(); 
     Map<String,ACETLGT_PlanBenefitLanguageWrapper.AccumulatorCode> accumOONMap = new Map<String,ACETLGT_PlanBenefitLanguageWrapper.AccumulatorCode>();                                                                      
    ACETLGT_PlanBenefitLanguageWrapper.BenefitWrapper bw = new ACETLGT_PlanBenefitLanguageWrapper.BenefitWrapper(); 
    public override void GetEndpoint()
    {
         GetEndpointDetail('GetBenefitAccumulatorsAPI');
    }
    public ACETLGT_GetBenefitAccumsWebService() {
        super('Stargate');
    }
    private void GetRequestBody() {
        RequestBody = GetRequestBody('ACETLGT_GetBenefitAccRequestJSON', RequestParameters);        
    }
    
    
      public List<ACETLGT_PlanBenefitLanguageWrapper.BenefitWrapper> getAccumulatorBenefits(ACETLGT_GetBAServiceWrapper getBAServiceWrapper) {
          
         	  String BenefitBundleOptId = getBAServiceWrapper.BenefitBundleOptId; 
              String enrollerSRK = getBAServiceWrapper.enrollerSRK;
              String surrogateKey = getBAServiceWrapper.surrogateKey;
              String EffectiveStartDate = getBAServiceWrapper.EffectiveStartDate;
              String EffectiveEndDate = getBAServiceWrapper.EffectiveEndDate;
              String BenefitCode = getBAServiceWrapper.BenefitCode;
              string accumAsOf = getBAServiceWrapper.accumAsOf;
              String GroupNumber = getBAServiceWrapper.GroupNumber;
              String SubscriptionServiceResponse = getBAServiceWrapper.SubscriptionServiceResponse;
              String MembershipDuration = getBAServiceWrapper.MembershipDuration;
              String SubscriptionResponse = getBAServiceWrapper.SubscriptionResponse;
              List<String> benefitRiderList = getBAServiceWrapper.benefitRiderList;
              
              
           Map<String,List<String>> tierTypeCodeMap = new Map<String,List<String>>();
          Map<String,String> tierTypeIdentifierMap = new Map<String,String>();
          List<String> SubscriptionServiceResponseList = new List<String>();
		  List<String> SubscriptionResponseList = new List<String>(); 
          String existsOnRiderPlanBenefitIndicator = '';
          
          system.debug('SubscriptionServiceResponse::'+SubscriptionServiceResponse);
		  system.debug('MembershipDuration'+MembershipDuration); 
          system.debug('SubscriptionResponse::'+SubscriptionResponse);
          String SubscriptionServiceReplaceResponse = SubscriptionServiceResponse.replace('(','').replace(')','');
          System.debug('SubscriptionServiceReplaceResponse' +SubscriptionServiceReplaceResponse);                                                                
          if(String.isNotBlank(SubscriptionServiceReplaceResponse)){ 		  
            SubscriptionServiceResponseList = SubscriptionServiceReplaceResponse.split(',');
           	tierTypeCodeMap = generateTierTypeCodeMap(SubscriptionServiceResponseList);
          }       
          
          Set<String> tierCodeSet = new Set<String>();
		  if(tierTypeCodeMap != null && !tierTypeCodeMap.isEmpty()) { 
           for( String key: tierTypeCodeMap.keySet() ){
           List<String> lstString = tierTypeCodeMap.get(key);
          if ( lstString.size()>0 )
          {
          tierCodeSet.addAll(lstString);
          }
         }
		}
        String SubscriptionReplaceResponse = SubscriptionResponse.replace('(','').replace(')','');                                                                   
		if(String.isNotBlank(SubscriptionReplaceResponse)){
           SubscriptionResponseList = SubscriptionReplaceResponse.split(','); 
        	tierTypeIdentifierMap = processTierTypeIdentifierMap(SubscriptionResponseList);
	    
        }
          System.debug('tierTypeIdentifierMap :'+tierTypeIdentifierMap);
          System.debug('benefitRiderList000'+benefitRiderList); 
          existsOnRiderPlanBenefitIndicator = processExistsOnRiderPlanBenefitIndicator(benefitRiderList,BenefitCode);                                                                 
         
          List<ACETLGT_PlanBenefitLanguageWrapper.BenefitWrapper> accumListUpdtd = new List<ACETLGT_PlanBenefitLanguageWrapper.BenefitWrapper>(); 
          
          try {
            List<String> accumsBeefitsCode = BenefitCode.split(',');
            String accumsBenefitJoin='';
            for(String s: accumsBeefitsCode ){
               accumsBenefitJoin = accumsBenefitJoin+'{"benefitCode":'+'"'+s.removeEnd('_').trim()+'"},';    
            }
            accumsBenefitJoin = accumsBenefitJoin.removeEnd(',');
            RequestParameters = new List<String>{BenefitBundleOptId, enrollerSRK,surrogateKey,EffectiveStartDate, 
            EffectiveEndDate,accumsBenefitJoin, accumAsOf,GroupNumber};
            System.debug('tierCodeSet ::'+tierCodeSet);
        ACET_WebserviceCalloutFramework wsCallOutFW = new ACET_WebserviceCalloutFramework();
        wsCallOutFW.serviceName = 'GetBenefitAccumulatorsAPI';
         RequestBody = GetRequestBody('ACETLGT_GetBenefitAccRequestJSON', RequestParameters); 
        wsCallOutFW.requestBody = RequestBody; 
        HttpResponse response  = wsCallOutFW.getResponse();
              
              system.debug('Response'+response.getBody());
                    accumListUpdtd =  processResponse(response,existsOnRiderPlanBenefitIndicator,tierCodeSet,tierTypeIdentifierMap, tierTypeCodeMap,MembershipDuration);     
      }
      catch(Exception w) {
          System.debug('Excepttion:::'+w);
      }
      
      return  accumListUpdtd;
   }
      
    public string getValidString(string inputStr){
        if(string.isNotBlank(inputStr)){
            inputStr = inputStr.replaceAll('\"','');
            return inputStr;
            
        }else{
            return '';
        }
    }
    public Map<String,String> durationMap {get; set;}
    public Map<String,String> getDurationCodeMap() {
        durationMap = new Map<String,String>();        
        durationMap.put('C','Calendar Year(s)');
        durationMap.put('D','Day(s)');
        durationMap.put('L','Lifetime');
        durationMap.put('M','Month(s)');
        durationMap.put('P','Plan Year(s)');
        durationMap.put('W','Week(s)');
        return durationMap;
    }
    private static List<ACETLGT_GetBenefitAccumsResponseWrapper.benefitCode> benefitPlanMapping(Map<String,List<ACETLGT_GetBenefitAccumsResponseWrapper.benefitCode>> benefitPlanMap,String existsOnRiderPlanBenefitIndicator,String benefitPlanKey) {
       List<ACETLGT_GetBenefitAccumsResponseWrapper.benefitCode> benefitCodeObj = new List<ACETLGT_GetBenefitAccumsResponseWrapper.benefitCode>();
        System.debug('benefitPlanMap' +benefitPlanMap);
        if(benefitPlanMap != null && benefitPlanKey != null && benefitPlanKey != '' && benefitPlanMap.containsKey(benefitPlanKey)) {
            System.debug('benefitPlanMap' +benefitPlanMap);
            for(String benefitKey : benefitPlanMap.keyset()) {
                System.debug('existsOnRiderPlanBenefitIndicator::'+existsOnRiderPlanBenefitIndicator);
                System.debug('benefitKey.startsWithMR::'+benefitKey.startsWith('MR'));
                if(String.isNotBlank(existsOnRiderPlanBenefitIndicator) && existsOnRiderPlanBenefitIndicator == 'true' && String.isNotBlank(benefitKey) && benefitKey.startsWith('MR')) {
                   System.debug('rider plan'); 
                   benefitCodeObj = benefitPlanMap.get(benefitKey);
                   
                }else if(String.isBlank(existsOnRiderPlanBenefitIndicator)) {
                    System.debug('medical plan');
                    benefitCodeObj = benefitPlanMap.get(benefitKey);
                }
            }
        }
        System.debug('benefitCodeObj'+benefitCodeObj);
        return benefitCodeObj;
    }
     public String ChangeDateFormatForOIL(String OILDate) {
        String formattedDate = '';
        
        if (String.isNotBlank(OILDate)) {
            List<String> OILDateSplit = OILDate.split('/');
            if(OILDateSplit.size() == 3) {
                Integer strMonth = integer.ValueOf(OILDateSplit[0]);
                Integer strDay = integer.ValueOf(OILDateSplit[1]);
                String appendMonth,appendDay;
                if(strMonth < 10)
                    appendMonth = 0 + String.valueOf(strMonth);
                else
                    appendMonth = String.valueOf(strMonth);
                
                if(strDay < 10)    
                    appendDay = 0 + String.valueOf(strDay);
                else 
                    appendDay = String.valueOf(strDay);
                
            
                formattedDate = OILDateSplit[2] + '-' + appendMonth + '-' + appendDay;
            }
        }
        
        return FormattedDate;
    }
    public ACETLGT_PlanBenefitLanguageWrapper.BenefitWrapper ParseFailureResponseFromOil(HttpResponse FailureResponse)   {
        ACETLGT_PlanBenefitLanguageWrapper.BenefitWrapper bw = new ACETLGT_PlanBenefitLanguageWrapper.BenefitWrapper();
        bw.isSuccess = false;   
        bw.MessageSeverity = ApexPages.Severity.ERROR;
        try {
            Map<String, Object> mapRootNode = (Map<String, Object>)JSON.deserializeUntyped(FailureResponse.getBody());
            if (FailureResponse.getStatusCode() == 500 && 
                (mapRootNode.containsKey('ErrorCode') && mapRootNode.containsKey('Advice'))) {
                //Parse failure repsonse from ISL
                bw.Message = Label.ACETUnexpectedErrorMessage; 
                system.debug('List Errors 500:' + bw.Message);
            } else { 
                //Parse failure response from OIL
                bw.Message = parseFailureResponse(mapRootNode);
               
            }       
        }
        catch(Exception ex)
        {
            system.debug(LoggingLevel.INFO, 'Error serializing error response JSON. Details: ' + ex);
            bw.Message = FailureResponse.getBody();
        }
        
        return bw;
      }

    private List<ACETLGT_PlanBenefitLanguageWrapper.BenefitWrapper> processResponse(HttpResponse response,
                                                                                    String existsOnRiderPlanBenefitIndicator,
                                                                                    Set<String> tierCodeSet,
                                                                                    Map<String,String> tierTypeIdentifierMap,
                                                                                    Map<String,List<String>> tierTypeCodeMap,
                                                                                    String MembershipDuration){
         
        
	    List<ACETLGT_PlanBenefitLanguageWrapper.BenefitWrapper> accumList = new List<ACETLGT_PlanBenefitLanguageWrapper.BenefitWrapper>();                                                                                       
       
         
         ACETWSCalloutResult calloutResult = new ACETWSCalloutResult();
			if (response.getStatusCode() == 200) {
                accumList = processSuccessResponse( response, existsOnRiderPlanBenefitIndicator,
													 tierCodeSet,tierTypeIdentifierMap,
													 tierTypeCodeMap,MembershipDuration);
              
                
              }
             else if (Response.getStatusCode() == 404){     
                    bw = new ACETLGT_PlanBenefitLanguageWrapper.BenefitWrapper(); 
                    bw.isSuccess = false;
                    bw.messageSeverityStr = 'INFO';
                    ACETLGT_GetBenefitAccumsResponseWrapper jSON2ApexError = (ACETLGT_GetBenefitAccumsResponseWrapper)JSON.deserialize(Response.getBody(), ACETGetAccumulatorRedesignJSON2APEX.class);
                    bw.Message = GetOILErrorMessage(jSON2ApexError.getBenefitAccumulatorResponse.errors);
                    System.debug('*****'+bw);  
                    accumList.add(bw);
                }else {
                    bw = new ACETLGT_PlanBenefitLanguageWrapper.BenefitWrapper();
                    bw.isSuccess = false;
                    bw = ParseFailureResponseFromOil(Response); 
                    System.debug('*****500'+bw); 
                    accumList.add(bw);
                } 
                                                                                        
		return accumList;                                                                                        
    }
    
   private ACETLGT_PlanBenefitLanguageWrapper.AccumulatorCode processAccumCode(ACETLGT_PlanBenefitLanguageWrapper.BenefitWrapper bw,
																				ACETLGT_GetBenefitAccumsResponseWrapper.benefitCostShare benefitCostShareObj,
																				Map<String,String> tierTypeIdentifierMap,
																				ACETLGT_GetBenefitAccumsResponseWrapper.benefitCode benefitCodeObj,
																				String MembershipDuration){
	ACETLGT_PlanBenefitLanguageWrapper.AccumulatorCode acd = new ACETLGT_PlanBenefitLanguageWrapper.AccumulatorCode();
	acd.BenefitKey = bw.BenefitKey;
	acd.coverageLevel = (String.isNotBlank(benefitCostShareObj.coverageLevel)? (benefitCostShareObj.coverageLevel) : '');
	acd.coverageType = (String.isNotBlank(tierTypeIdentifierMap.get(benefitCodeObj.benefitTier))? (tierTypeIdentifierMap.get(benefitCodeObj.benefitTier)) : '');
	acd.costShareType = (String.isNotBlank(benefitCostShareObj.costShareType) ? (benefitCostShareObj.costShareType) : '');
	acd.benefitMaximumValue = (String.isNotBlank(benefitCostShareObj.benefitMaximumValue) ? (benefitCostShareObj.benefitMaximumValue) : '');
	if(acd.benefitMaximumUnit == 'Limits'){
		acd.benefitMaximumUnit = 'Visits';
	}
	else{
		acd.benefitMaximumUnit = (String.isNotBlank(benefitCostShareObj.benefitMaximumUnit) ? (benefitCostShareObj.benefitMaximumUnit) : '');
	}    
	acd.benefitYTDValue = (String.isNotBlank(benefitCostShareObj.benefitYTDValue) ? (benefitCostShareObj.benefitYTDValue) : '');
                                                                                    
	
	acd.duration = calculateDuration(benefitCostShareObj,MembershipDuration);
	
	acd.benefitRemainingValue = (String.isNotBlank(benefitCostShareObj.benefitRemainingValue) ? (benefitCostShareObj.benefitRemainingValue) : '');
	System.debug('benefitCostShareObj.costShareId'+benefitCostShareObj.costShareId);
	if(string.isNotBlank(benefitCodeObj.benefitVersion)){
		acd.dateVersion = benefitCodeObj.benefitVersion;
	}
	acd.costShareId = benefitCostShareObj.costShareId;
	if(acd.coverageType == 'INN') {
        accumMap.put(benefitCostShareObj.costShareId+acd.coverageLevel+acd.benefitMaximumUnit+acd.BenefitKey,acd);
        System.debug('INN'+accumMap);
    }
   if(acd.coverageType == 'OON') {
 	 accumOONMap.put(benefitCostShareObj.costShareId+acd.coverageLevel+acd.benefitMaximumUnit+acd.BenefitKey,acd);
 	 System.debug('OON'+accumOONMap);                                                        
	}
	
   if(bw.accumulatorCodeList == null){
		bw.accumulatorCodeList = new list<ACETLGT_PlanBenefitLanguageWrapper.AccumulatorCode>{acd};
	}   
                                                                                    
	return acd;
													
}
    
    private Map<String,String> processTierTypeIdentifierMap(List<String> SubscriptionResponseList){
        Map<String,String> tierTypeIdentifierMapTemp = new Map<String,String>();
         if(SubscriptionResponseList != null && !SubscriptionResponseList.isEmpty()){ 
              for(String s : SubscriptionResponseList) { 
                  List<string> tempTierIdentifier = new List<String>();
                  tempTierIdentifier = s.split('-');
                  if(tempTierIdentifier !=null && tempTierIdentifier.size() > 0){
                    String tierIdentifier = tempTierIdentifier[0].trim();
                    system.debug('tierIdentifier'+tierIdentifier);
                    String tierType = tempTierIdentifier[1];
                    system.debug('tierType'+tierType);  
                    tierTypeIdentifierMapTemp.put(tierIdentifier,tierType); 
                  }
              }
            }
		
		return tierTypeIdentifierMapTemp;
	}
    
    private String processExistsOnRiderPlanBenefitIndicator(List<String> benefitRiderList,String BenefitCode){
		String existsOnRiderPlanBenefitIndicatorTemp = '';
		if(benefitRiderList != null && !benefitRiderList.isEmpty()) {
               For(Integer i =0; i<benefitRiderList.size();i++) {
                   if(benefitRiderList[i].contains('-')) {
                   String existsOnRiderPlanBenefitKey = benefitRiderList[i].split('-')[0];
                   System.debug('BenefitCode777'+BenefitCode);
                   System.debug('benefitRiderList888'+existsOnRiderPlanBenefitKey);
                     if(existsOnRiderPlanBenefitKey.contains(BenefitCode) && benefitRiderList[i].contains('=') ) {
                         existsOnRiderPlanBenefitIndicatorTemp = benefitRiderList[i].split('=')[1].replaceAll('"', '');
                         System.debug('existsOnRiderPlanBenefitIndicatorTemp--->'+existsOnRiderPlanBenefitIndicatorTemp);
                   }
               }
           } 
           }
		   return existsOnRiderPlanBenefitIndicatorTemp;
	}
    
    
    private List<ACETLGT_PlanBenefitLanguageWrapper.BenefitWrapper> processSuccessResponse(HttpResponse response,String existsOnRiderPlanBenefitIndicator,
													Set<String> tierCodeSet,
													Map<String,String> tierTypeIdentifierMap,
													Map<String,List<String>> tierTypeCodeMap,
													String MembershipDuration){
		Map<String,List<ACETLGT_GetBenefitAccumsResponseWrapper.benefitCode>> benefitPlanMap = new Map<String,List<ACETLGT_GetBenefitAccumsResponseWrapper.benefitCode>>();                                                                          
		List<ACETLGT_PlanBenefitLanguageWrapper.BenefitWrapper> accumListTemp = new List<ACETLGT_PlanBenefitLanguageWrapper.BenefitWrapper>();                                                                                       											
	   List<ACETLGT_PlanBenefitLanguageWrapper.AccumulatorCode> aList = new List<ACETLGT_PlanBenefitLanguageWrapper.AccumulatorCode>();
          List<ACETLGT_PlanBenefitLanguageWrapper.AccumulatorCode> aOONList = new List<ACETLGT_PlanBenefitLanguageWrapper.AccumulatorCode>();
            bw.accumulatorCodeList =  new list<ACETLGT_PlanBenefitLanguageWrapper.AccumulatorCode>();
                  ACETLGT_GetBenefitAccumsResponseWrapper aCETJSON2Apex = (ACETLGT_GetBenefitAccumsResponseWrapper)JSON.deserialize(response.getBody(), ACETLGT_GetBenefitAccumsResponseWrapper.class); 
                  if(aCETJSON2Apex.getBenefitAccumulatorResponse.benefitAccumulator != null) {
                      ACETLGT_GetBenefitAccumsResponseWrapper.benefitAccumulator benefitsAccumulator = aCETJSON2Apex.getBenefitAccumulatorResponse.benefitAccumulator;
                          for(ACETLGT_GetBenefitAccumsResponseWrapper.benefitPlan benefitPlanObj: benefitsAccumulator.benefitPlan) {
                                  benefitPlanMap.put(benefitPlanObj.benefitPlanId,benefitPlanObj.benefitCode);
                                  String benefitPlanKey = benefitPlanObj.benefitPlanId;
                                  System.debug('benefitPlanKey'+benefitPlanKey);
                                 List<ACETLGT_GetBenefitAccumsResponseWrapper.benefitCode> benefitPlanCodeObj = benefitPlanMapping(benefitPlanMap,existsOnRiderPlanBenefitIndicator,benefitPlanKey);
                                 System.debug('benefitPlanCodeObj'+benefitPlanCodeObj); 
                                 if(benefitPlanCodeObj != null) {
                                 		processBenefitPlabCodeObj( benefitPlanCodeObj,existsOnRiderPlanBenefitIndicator, tierTypeCodeMap,
                                                                  benefitPlanObj, tierCodeSet,  tierTypeIdentifierMap, MembershipDuration);	
							
                   				}
                          }
                          System.debug('accumMap :::::'+accumMap);
                          System.debug('accumOONMap ::::'+accumOONMap);
                          if(accumMap.size() > 0){
                              aList.addAll(accumMap.Values());
                              aList.sort();
                              System.debug('aList ::'+aList);
                              bw.accumulatorCodeList.addAll(aList);
                          }
                          if(accumOONMap.size() > 0) {
                              aOONList.addAll(accumOONMap.Values());
                              aOONList.sort();
                              System.debug('aOONList ::'+aOONList);
                              bw.accumulatorCodeList.addAll(aOONList);
                          }
                      
                  } 
                     bw.isSuccess = true;
                     bw.Message = '';  
                     accumListTemp.add(bw);
               

			return accumListTemp;

		}
    
    private Map<String,List<String>> generateTierTypeCodeMap(List<String> SubscriptionServiceResponseList){	
		Map<String,List<String>> tierTypeCodeMapTmp = new Map<String,List<String>>();
		if(SubscriptionServiceResponseList != null && !SubscriptionServiceResponseList.isEmpty()){                   		  
            for(String s : SubscriptionServiceResponseList){
              system.debug('s :'+s);
              List<string> tempString = new List<String>();
              tempString = s.split('-');
              String first = tempString[0].trim();
              system.debug('first'+first);
              String last = tempString[1];
              system.debug('last'+last);
              if(tierTypeCodeMapTmp.containsKey(first)) {
                 tierTypeCodeMapTmp.get(first).add(last);    
              }else {
                  System.debug('tierTypeCodeMapTmp' +tierTypeCodeMapTmp);
                  tierTypeCodeMapTmp.put(first, new List<String>{last});
              }
            }     
              System.debug('tierTypeCodeMapTmp ::'+tierTypeCodeMapTmp);  
          }  
        return tierTypeCodeMapTmp;
	}		  
   
    private String parseFailureResponse(Map<String, Object> mapRootNode){
		String errMsg = '';
			Map<String, Object> mapErrors = (Map<String, Object>)mapRootNode.values().get(0);
                system.debug('Map Errors:' + mapErrors);
                List<Object> lstErrors = (List<Object>)mapErrors.get('errors');
                system.debug('List Errors:' + lstErrors);
                if (lstErrors == null) {
                    Map<String, Object> mapTypeNode = (Map<String, Object>)mapErrors.values().get(0);
                    lstErrors = (List<Object>)mapTypeNode.get('errors');
                    system.debug('List Errors 2:' + lstErrors);
                }
                Map<String, Object> mapError;
                String ErrorDescription;
                if(lstErrors != null) {
                    for (Object oError :lstErrors) {
                        mapError = (Map<String, Object>)oError;
                        system.debug('Error: ' + mapError);
                        ErrorDescription = String.valueOf(mapError.get('description'));
                        if (String.isBlank(errMsg)) { 
                            errMsg = ErrorDescription;
                        } else {
                            if (errMsg.length() + ErrorDescription.length() <= 255) {
                                errMsg += '; ' + ErrorDescription;
                            } else {
                                break;
                            }   
                        }   
                    }
                }
		return errMsg;			
	}
    
    private void processBenefitPlabCodeObj(List<ACETLGT_GetBenefitAccumsResponseWrapper.benefitCode> benefitPlanCodeObj,String existsOnRiderPlanBenefitIndicator,Map<String,List<String>> tierTypeCodeMap,ACETLGT_GetBenefitAccumsResponseWrapper.benefitPlan benefitPlanObj,Set<String> tierCodeSet,Map<String,String> tierTypeIdentifierMap,String MembershipDuration){
	for(ACETLGT_GetBenefitAccumsResponseWrapper.benefitCode benefitCodeObj: benefitPlanCodeObj) {
                                  bw.BenefitKey = getValidString(benefitCodeObj.benefitCode)+' - '+getValidString(benefitCodeObj.benefitName);
                                 		 if(string.isNotBlank(benefitCodeObj.benefitCodeEffectiveDate) && string.isNotBlank(benefitCodeObj.benefitCodeExpirationDate)){    
                                    string listVal = ChangeDateFormat(benefitCodeObj.benefitCodeEffectiveDate)+' - '+ChangeDateFormat(benefitCodeObj.benefitCodeExpirationDate);
                                    System.debug('listVal :'+listVal);
                                    
                                        System.debug('benefitCodeObj.benefitTier :'+benefitCodeObj.benefitTier);
                                        System.debug('tierCodeSet :'+tierCodeSet);
                                        System.debug('tierTypeIdentifierMap'+tierTypeIdentifierMap);
                                             processBenefitCostShare( existsOnRiderPlanBenefitIndicator, tierTypeCodeMap,
                                                                     benefitPlanObj,tierCodeSet, benefitCodeObj, tierTypeIdentifierMap,MembershipDuration);
                                  }
                              }
	


}
    
    private void processBenefitCostShare(String existsOnRiderPlanBenefitIndicator,Map<String,List<String>> tierTypeCodeMap,ACETLGT_GetBenefitAccumsResponseWrapper.benefitPlan benefitPlanObj,Set<String> tierCodeSet,ACETLGT_GetBenefitAccumsResponseWrapper.benefitCode benefitCodeObj,Map<String,String> tierTypeIdentifierMap,String MembershipDuration){
		
		 if(( null != existsOnRiderPlanBenefitIndicator && String.isNotBlank(existsOnRiderPlanBenefitIndicator) && existsOnRiderPlanBenefitIndicator == 'true') 
                                           ||(String.isBlank(existsOnRiderPlanBenefitIndicator) && String.ValueOf(tierTypeCodeMap.keySet()).removeEnd('}').removeStart('{')==benefitPlanObj.benefitPlanId && tierCodeSet.contains(benefitCodeObj.benefitTier) && tierTypeIdentifierMap != null && tierTypeIdentifierMap.containsKey(benefitCodeObj.benefitTier))){
                                            system.debug('benefitCodeObj.benefitCostShare'+benefitCodeObj.benefitCostShare);
                                            for(ACETLGT_GetBenefitAccumsResponseWrapper.benefitCostShare benefitCostShareObj: benefitCodeObj.benefitCostShare) {
                                                System.debug('benefitCostShareObj.costShareType:::'+benefitCostShareObj.costShareType);
                                                System.debug('benefitCostShareObj.primaryCostShareIndicator:::'+benefitCostShareObj.primaryCostShareIndicator);
	                                            System.debug('benefitCostShareObj.benefitMaximumValue::'+benefitCostShareObj.benefitMaximumValue);    
                                                if(benefitCostShareObj.costShareType == 'Benefit Maximum' || 
                                                   (benefitCostShareObj.primaryCostShareIndicator == 'false'  && benefitCostShareObj.benefitMaximumValue!=null))  { //Benefit Maximum
                                                    ACETLGT_PlanBenefitLanguageWrapper.AccumulatorCode ac = new ACETLGT_PlanBenefitLanguageWrapper.AccumulatorCode();
                                                    ac = processAccumCode(bw,benefitCostShareObj,tierTypeIdentifierMap,benefitCodeObj,MembershipDuration);
                                   
                                                    system.debug('benefitCodeObj.benefitTier+benefitCostShareObj.coverageLevel+Ac.BenefitKey :'+benefitCodeObj.benefitTier+benefitCostShareObj.coverageLevel+Ac.BenefitKey);
                                                   
                                                }
                                                System.debug('bw.accumulatorCodeList ::'+bw.accumulatorCodeList);
                                            }
        		}

		}


	private String calculateDuration(ACETLGT_GetBenefitAccumsResponseWrapper.benefitCostShare benefitCostShareObj,
																				String MembershipDuration){
        String duration = '';
        if(String.isNotBlank(benefitCostShareObj.limitAccumulatorBenefitPeriodDurationCount) && String.isNotBlank(benefitCostShareObj.limitAccumulatorBenefitPeriodDurationCode)) {
           duration  = (String.isNotBlank(benefitCostShareObj.limitAccumulatorBenefitPeriodDurationCount) ? (benefitCostShareObj.limitAccumulatorBenefitPeriodDurationCount) : '') + '  '+ (String.isNotBlank(benefitCostShareObj.limitAccumulatorBenefitPeriodDurationCode ) ? (benefitCostShareObj.limitAccumulatorBenefitPeriodDurationCode ) : '') ;
        } 
        else if(benefitCostShareObj.costShareType == 'Out of Pocket' && String.isBlank(benefitCostShareObj.limitAccumulatorBenefitPeriodDurationCount) && String.isBlank(benefitCostShareObj.limitAccumulatorBenefitPeriodDurationCode)) {
            duration = (String.isNotBlank(MembershipDuration)) ? ('1'+ '  '+MembershipDuration):'';
        }
        else {
            duration = '';
        }
        return duration;
	}

	
}