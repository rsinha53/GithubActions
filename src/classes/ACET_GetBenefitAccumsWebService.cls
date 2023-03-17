/* 
 * @name         :   ACET_GetBenefitAccumsWebService
 * @description  :   This component  is created to call webservice for the accumulator and pass the accums to benefit language webservice. 
 * @author       :   Sai Kolluru
 * @createddate  :   03-11-2017
 * @lastmodifiedby:
 *
 */
public class ACET_GetBenefitAccumsWebService extends ACETWebservice {
    public ACETGroupPlanBenefitWrapper ACETPlanBenefitSearchResults;
    public ACETGroupPlanBenefitWrapper ACETSubscriptionServiceResults;
    Map<String,ACETPlanBenefitLanguageWrapper.AccumulatorCode> accumMap = new Map<String,ACETPlanBenefitLanguageWrapper.AccumulatorCode>(); 
    Map<String,ACETPlanBenefitLanguageWrapper.AccumulatorCode> accumOONMap = new Map<String,ACETPlanBenefitLanguageWrapper.AccumulatorCode>();                                                                      
    ACETPlanBenefitLanguageWrapper.BenefitWrapper bw = new ACETPlanBenefitLanguageWrapper.BenefitWrapper(); 
    public override void GetEndpoint()
    {
         GetEndpointDetail('GetBenefitAccumulatorsAPI');
    }
    public ACET_GetBenefitAccumsWebService() {
        super('Stargate');
    }
    private void GetRequestBody() {
        RequestBody = GetRequestBody('ACETGetBenefitAccRequestJSON', RequestParameters);        
    }
    
  
    public List<ACETPlanBenefitLanguageWrapper.BenefitWrapper> getAccumulatorBenefitsRedesign(ACET_GetBAServiceWrapper bas) {
          
			String BenefitBundleOptId = bas.BenefitBundleOptId;
			String EnrolleeIdentifierType = bas.EnrolleeIdentifierType; 
            String EnrolleeIdentifierId = bas.EnrolleeIdentifierId;
            String SubscriberIdentifierId = bas.SubscriberIdentifierId; 
            String EffectiveStartDate = bas.EffectiveStartDate; 
            String EffectiveEndDate = bas.EffectiveEndDate; 
            String CoverageType = bas.CoverageType; 
            String BenefitVerIndicator = bas.BenefitVerIndicator; 
            String BenefitCode = bas.BenefitCode; 
            String accumAsOf = bas.accumAsOf;
            String GroupNumber = bas.GroupNumber; 
            String SubscriptionServiceResponse = bas.SubscriptionServiceResponse;
            String MembershipDuration = bas.MembershipDuration;
            String SubscriptionResponse = bas.SubscriptionResponse;
            List< String> existsOnRiderPlanArray = bas.existsOnRiderPlanArray;
                                                                             
                                                                             
                                                                             
			system.debug('in new API method');
			Map<String,List<String>> tierTypeCodeMap = new Map<String,List<String>>();
          Map<String,String> tierTypeIdentifierMap = new Map<String,String>();
          List<String> SubscriptionServiceResponseList = new List<String>();
          List<String> SubscriptionResponseList = new List<String>(); 
          String existsOnRiderPlanBenefitIndicator = '';  
          
          
          system.debug('SubscriptionServiceResponse::'+SubscriptionServiceResponse);
          system.debug('MembershipDuration'+MembershipDuration); 
          system.debug('SubscriptionResponse::'+SubscriptionResponse);  
          System.debug('BenefitCode'+BenefitCode);                                                                 
          if(String.isNotBlank(SubscriptionServiceResponse)){         
            SubscriptionServiceResponseList = SubscriptionServiceResponse.split(',');
           	tierTypeCodeMap = generateTierTypeCodeMap(SubscriptionServiceResponseList);
        	}                                                                   
          Set<String> tierCodeSet = new Set<String>();
        	tierCodeSet = prepareTierCodeSet(tierTypeCodeMap);
          
        if(String.isNotBlank(SubscriptionResponse)){
           SubscriptionResponseList = SubscriptionResponse.split(','); 
           tierTypeIdentifierMap = processTierTypeIdentifierMap( SubscriptionResponseList);
          
       }
           System.debug('existsOnRiderPlanArray'+existsOnRiderPlanArray);   
           if(existsOnRiderPlanArray != null && !existsOnRiderPlanArray.isEmpty()) {                                                                
               existsOnRiderPlanBenefitIndicator = prepareExistsOnRiderPlanBenefitIndicator(existsOnRiderPlanArray,BenefitCode);
           }
          System.debug('tierTypeIdentifierMap :'+tierTypeIdentifierMap);    
          
          List<ACETPlanBenefitLanguageWrapper.BenefitWrapper> accumList = new List<ACETPlanBenefitLanguageWrapper.BenefitWrapper>(); 
          bw.dateRange = new list<string>();                                                              
          try {
            HttpResponse response = null;
            List<String> accumsBeefitsCode = BenefitCode.split(',');
            String accumsBenefitJoin='';
           
            for(String s: accumsBeefitsCode ){
               accumsBenefitJoin = accumsBenefitJoin+'{"benefitCode":'+'"'+s.removeEnd('_').trim()+'"},';    
            }
            accumsBenefitJoin = accumsBenefitJoin.removeEnd(',');
              system.debug('accumsBenefitJoin'+accumsBenefitJoin);
              system.debug('ChangeDateFormatForOIL(accumAsOf)'+ChangeDateFormatForOIL(accumAsOf));
            RequestParameters = new List<String>{BenefitBundleOptId,  EnrolleeIdentifierId,SubscriberIdentifierId, ChangeDateFormatForOIL(EffectiveStartDate), 
            ChangeDateFormatForOIL(EffectiveEndDate),  accumsBenefitJoin, ChangeDateFormatForOIL(accumAsOf),GroupNumber};
            System.debug('tierCodeSet ::'+tierCodeSet);
            system.debug('RequestParameters'+RequestParameters);
            ACETWSCalloutResult calloutResult = new ACETWSCalloutResult();
        
            ACET_WebserviceCalloutFramework wsCallOutFW = new ACET_WebserviceCalloutFramework();
            wsCallOutFW.serviceName = 'GetBenefitAccumulatorsAPI';
            RequestBody = GetRequestBody('ACETLGT_GetBenefitAccRequestJSON', RequestParameters); 
            wsCallOutFW.requestBody = RequestBody; 
            response  = wsCallOutFW.getResponse();
              
            if (Response.getStatusCode() == 200) {
                  bw.accumulatorCodeList =  new list<ACETPlanBenefitLanguageWrapper.AccumulatorCode>();
                  ACET_GetBenefitAccumsResponseWrapper ACETJSON2Apex = (ACET_GetBenefitAccumsResponseWrapper)JSON.deserialize(Response.getBody(), ACET_GetBenefitAccumsResponseWrapper.class); 
                  		processSuccessResponse(ACETJSON2Apex,existsOnRiderPlanBenefitIndicator,tierCodeSet,tierTypeIdentifierMap,tierTypeCodeMap,MembershipDuration);
                     bw.isSuccess = true;
                     bw.Message = '';  
                     accumList.add(bw);
              }
             else if (Response.getStatusCode() == 404){     
                    bw = new ACETPlanBenefitLanguageWrapper.BenefitWrapper(); 
                    bw.isSuccess = false;
                    bw.messageSeverityStr = 'INFO';
                    ACET_GetBenefitAccumsResponseWrapper JSON2ApexError = (ACET_GetBenefitAccumsResponseWrapper)JSON.deserialize(Response.getBody(), ACET_GetBenefitAccumsResponseWrapper.class);
                    bw.Message = GetOILErrorMessage(JSON2ApexError.getBenefitAccumulatorResponse.errors);
                    System.debug('*****'+bw);  
                    accumList.add(bw);
                }else {
                    bw = new ACETPlanBenefitLanguageWrapper.BenefitWrapper();
                    bw.isSuccess = false;
                    bw = ParseFailureResponseFromOil(Response); 
                    System.debug('*****500'+bw); 
                    accumList.add(bw);
                }                     
      }
      catch(Exception w) {
          System.debug('Excepttion:::'+w);
      }
      System.debug(' accumList ::' + accumList);
      return  accumList;
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
    private static List<ACET_GetBenefitAccumsResponseWrapper.benefitCode> benefitPlanMapping(Map<String,List<ACET_GetBenefitAccumsResponseWrapper.benefitCode>> benefitPlanMap,String existsOnRiderPlanBenefitIndicator,String benefitPlanKey) {
       List<ACET_GetBenefitAccumsResponseWrapper.benefitCode> benefitCodeObj = new List<ACET_GetBenefitAccumsResponseWrapper.benefitCode>();
        System.debug('benefitPlanMap' +benefitPlanMap);
        if(benefitPlanMap != null && benefitPlanKey != null && benefitPlanKey != '' && benefitPlanMap.containsKey(benefitPlanKey)) {
            System.debug('benefitPlanMap' +benefitPlanMap);
            for(String benefitKey : benefitPlanMap.keyset()) {
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
        String FormattedDate = '';
        
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
                
                FormattedDate = OILDateSplit[2] + '-' + appendMonth + '-' + appendDay;
            }
        }
        
        return FormattedDate;
    }
    public ACETPlanBenefitLanguageWrapper.BenefitWrapper ParseFailureResponseFromOil(HttpResponse FailureResponse)   {
        ACETPlanBenefitLanguageWrapper.BenefitWrapper bw = new ACETPlanBenefitLanguageWrapper.BenefitWrapper();
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
    
    private Map<String,List<String>> generateTierTypeCodeMap(List<String> SubscriptionServiceResponseList){ 
		Map<String,List<String>> tierTypeCodeMapTmp = new Map<String,List<String>>();
 		if(SubscriptionServiceResponseList != null && !SubscriptionServiceResponseList.isEmpty()){                          
            for(String s : SubscriptionServiceResponseList){
              List<string> tempString = new List<String>();
              tempString = s.split('-');
              String first = tempString[tempString.size() - 2];
              String last = tempString[tempString.size()-1];
              List<String> temp = tierTypeCodeMapTmp.get(first);
                if(temp == null) {
                      tierTypeCodeMapTmp.put(first, new List<String>{last});
                } else {
                      temp.add(last);
                }  
              }    
              System.debug('tierTypeCodeMapTmp ::'+tierTypeCodeMapTmp);    
          }  
		return tierTypeCodeMapTmp;	  
	}	
    
    private Map<String,String> processTierTypeIdentifierMap(List<String> SubscriptionResponseList){
		Map<String,String> tierTypeIdentifierMapTemp = new Map<String,String>();
		if(SubscriptionResponseList != null && !SubscriptionResponseList.isEmpty()){ 
				  for(String s : SubscriptionResponseList) { 
					  List<string> tempTierIdentifier = new List<String>();
					  tempTierIdentifier = s.split('-');
					  if(tempTierIdentifier !=null && tempTierIdentifier.size() > 0){
						String tierIdentifier = tempTierIdentifier[tempTierIdentifier.size() - 2];
						system.debug('tierIdentifier'+tierIdentifier);
						String tierType = tempTierIdentifier[tempTierIdentifier.size()-1];
						system.debug('tierType'+tierType);  
						tierTypeIdentifierMapTemp.put(tierIdentifier,tierType); 
					  }
				  }
		}
		
		return tierTypeIdentifierMapTemp;	
	}
    
    private void processSuccessResponse(ACET_GetBenefitAccumsResponseWrapper ACETJSON2Apex,String existsOnRiderPlanBenefitIndicator,Set<String> tierCodeSet,Map<String,String> tierTypeIdentifierMap,Map<String,List<String>> tierTypeCodeMap,String MembershipDuration){
		Map<String,List<ACET_GetBenefitAccumsResponseWrapper.benefitCode>> benefitPlanMap = new Map<String,List<ACET_GetBenefitAccumsResponseWrapper.benefitCode>>();         
	 	   List<ACETPlanBenefitLanguageWrapper.AccumulatorCode> aList = new List<ACETPlanBenefitLanguageWrapper.AccumulatorCode>();
          List<ACETPlanBenefitLanguageWrapper.AccumulatorCode> aOONList = new List<ACETPlanBenefitLanguageWrapper.AccumulatorCode>();
       
        if(ACETJSON2Apex.getBenefitAccumulatorResponse.benefitAccumulator != null) {
                      ACET_GetBenefitAccumsResponseWrapper.benefitAccumulator benefitsAccumulator = ACETJSON2Apex.getBenefitAccumulatorResponse.benefitAccumulator;
                         processBenefitsAccumulator(benefitsAccumulator, benefitPlanMap, existsOnRiderPlanBenefitIndicator, tierCodeSet, tierTypeIdentifierMap, tierTypeCodeMap,MembershipDuration);
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

		}
    
    
    private void processBenefitsAccumulator(ACET_GetBenefitAccumsResponseWrapper.benefitAccumulator benefitsAccumulator,Map<String,List<ACET_GetBenefitAccumsResponseWrapper.benefitCode>> benefitPlanMap,String existsOnRiderPlanBenefitIndicator,Set<String> tierCodeSet,Map<String,String> tierTypeIdentifierMap,Map<String,List<String>> tierTypeCodeMap,String MembershipDuration){
	 for(ACET_GetBenefitAccumsResponseWrapper.benefitPlan benefitPlanObj: benefitsAccumulator.benefitPlan) {
             benefitPlanMap.put(benefitPlanObj.benefitPlanId,benefitPlanObj.benefitCode);
             String benefitPlanKey = benefitPlanObj.benefitPlanId;
             System.debug('benefitPlanKey'+benefitPlanKey);
             List<ACET_GetBenefitAccumsResponseWrapper.benefitCode> benefitPlanCodeObj = benefitPlanMapping(benefitPlanMap,existsOnRiderPlanBenefitIndicator,benefitPlanKey);
             System.debug('benefitPlanCodeObj'+benefitPlanCodeObj); 
             if(benefitPlanCodeObj != null) {
                 for(ACET_GetBenefitAccumsResponseWrapper.benefitCode benefitCodeObj: benefitPlanCodeObj) {
                    processBenefitPlanCodeObj(benefitCodeObj,benefitPlanObj, existsOnRiderPlanBenefitIndicator, tierCodeSet, tierTypeIdentifierMap, tierTypeCodeMap, MembershipDuration);
                 }
                 
             }
                          }
	
	}
    
    private void processBenefitPlanCodeObj(ACET_GetBenefitAccumsResponseWrapper.benefitCode benefitCodeObj,ACET_GetBenefitAccumsResponseWrapper.benefitPlan benefitPlanObj, String existsOnRiderPlanBenefitIndicator,Set<String> tierCodeSet,Map<String,String> tierTypeIdentifierMap,Map<String,List<String>> tierTypeCodeMap,String MembershipDuration){
	 bw.BenefitKey = getValidString(benefitCodeObj.benefitCode)+' - '+getValidString(benefitCodeObj.benefitName);
                     if(string.isNotBlank(benefitCodeObj.benefitCodeEffectiveDate) && string.isNotBlank(benefitCodeObj.benefitCodeExpirationDate)){    
                         string listVal = ChangeDateFormat(benefitCodeObj.benefitCodeEffectiveDate)+' - '+ChangeDateFormat(benefitCodeObj.benefitCodeExpirationDate);
                         System.debug('listVal :'+listVal);
                         if(!bw.dateRange.contains(listVal)){
                             bw.dateRange.add(listVal);  
                         }
                         if(string.isNotBlank(benefitCodeObj.benefitVersion)){
                             bw.dateVersion = benefitCodeObj.benefitVersion;
                         }
                         System.debug('benefitCodeObj.benefitTier :'+benefitCodeObj.benefitTier);
                         System.debug('tierCodeSet :'+tierCodeSet);
                         System.debug('tierTypeIdentifierMap'+tierTypeIdentifierMap);
                         //system.debug('existsOnRiderPlanBenefitIndicator++'+existsOnRiderPlanBenefitIndicator+' +existsOnRiderPlanBenefitIndicator+'+existsOnRiderPlanBenefitIndicator);
                         if((String.isNotBlank(existsOnRiderPlanBenefitIndicator) && existsOnRiderPlanBenefitIndicator == 'true') ||(String.isBlank(existsOnRiderPlanBenefitIndicator) && String.ValueOf(tierTypeCodeMap.keySet()).removeEnd('}').removeStart('{')==benefitPlanObj.benefitPlanId && tierCodeSet.contains(benefitCodeObj.benefitTier) && tierTypeIdentifierMap != null && tierTypeIdentifierMap.containsKey(benefitCodeObj.benefitTier))){
                             	processBenefitCodeObj(benefitCodeObj,tierTypeIdentifierMap,MembershipDuration);
                            
                         }  
                     }


	}
    private void processBenefitCodeObj(ACET_GetBenefitAccumsResponseWrapper.benefitCode benefitCodeObj,Map<String,String> tierTypeIdentifierMap,String MembershipDuration){
	 for(ACET_GetBenefitAccumsResponseWrapper.benefitCostShare benefitCostShareObj: benefitCodeObj.benefitCostShare) {
             if(benefitCostShareObj.costShareType == 'Benefit Maximum' || (benefitCostShareObj.primaryCostShareIndicator == 'false' 
                                                                           && benefitCostShareObj.benefitMaximumValue!=null))  { //Benefit Maximum
                 processBenefitCostShareObj(benefitCodeObj,benefitCostShareObj,tierTypeIdentifierMap, MembershipDuration);
             }
             System.debug('bw.accumulatorCodeList ::'+bw.accumulatorCodeList);
         }

		}
    
    private void processBenefitCostShareObj(ACET_GetBenefitAccumsResponseWrapper.benefitCode benefitCodeObj,ACET_GetBenefitAccumsResponseWrapper.benefitCostShare benefitCostShareObj,Map<String,String> tierTypeIdentifierMap,String MembershipDuration){
	  ACETPlanBenefitLanguageWrapper.AccumulatorCode Ac = new ACETPlanBenefitLanguageWrapper.AccumulatorCode();
		 Ac.BenefitKey = bw.BenefitKey;
		 Ac.coverageLevel = (String.isNotBlank(benefitCostShareObj.coverageLevel)? (benefitCostShareObj.coverageLevel) : '');
		 Ac.coverageType = (String.isNotBlank(tierTypeIdentifierMap.get(benefitCodeObj.benefitTier))? (tierTypeIdentifierMap.get(benefitCodeObj.benefitTier)) : '');
		 Ac.costShareType = (String.isNotBlank(benefitCostShareObj.costShareType) ? (benefitCostShareObj.costShareType) : '');
		 Ac.benefitMaximumValue = (String.isNotBlank(benefitCostShareObj.benefitMaximumValue) ? (benefitCostShareObj.benefitMaximumValue) : '');
		 if(Ac.benefitMaximumUnit == 'Limits'){
			 Ac.benefitMaximumUnit = 'Visits';
		 }
		 else{
			 Ac.benefitMaximumUnit = (String.isNotBlank(benefitCostShareObj.benefitMaximumUnit) ? (benefitCostShareObj.benefitMaximumUnit) : '');
		 }    
		 Ac.benefitYTDValue = (String.isNotBlank(benefitCostShareObj.benefitYTDValue) ? (benefitCostShareObj.benefitYTDValue) : '');
		 
			 Ac.duration = prepareDuration(benefitCostShareObj,MembershipDuration);
		 
		 Ac.benefitRemainingValue = (String.isNotBlank(benefitCostShareObj.benefitRemainingValue) ? (benefitCostShareObj.benefitRemainingValue) : '');
		 System.debug('benefitCostShareObj.costShareId'+benefitCostShareObj.costShareId);
		 Ac.dateRange = new List<string>();
		 if(string.isNotBlank(benefitCodeObj.benefitVersion)){
			 Ac.dateVersion = benefitCodeObj.benefitVersion;
		 }
		 Ac.costShareId = benefitCostShareObj.costShareId;
		 if(Ac.coverageType == 'INN') {
			 accumMap.put(benefitCostShareObj.costShareId+Ac.coverageLevel+Ac.benefitMaximumUnit+Ac.BenefitKey,Ac);
			 System.debug('INN'+accumMap);
		 }
		 if(Ac.coverageType == 'OON') {
			 accumOONMap.put(benefitCostShareObj.costShareId+Ac.coverageLevel+Ac.benefitMaximumUnit+Ac.BenefitKey,Ac);
			 System.debug('OON'+accumOONMap);                                                        
		 }
		 system.debug('benefitCodeObj.benefitTier+benefitCostShareObj.coverageLevel+Ac.BenefitKey :'+benefitCodeObj.benefitTier+benefitCostShareObj.coverageLevel+Ac.BenefitKey);
		 if(bw.accumulatorCodeList == null){
			 bw.accumulatorCodeList = new list<ACETPlanBenefitLanguageWrapper.AccumulatorCode>{Ac};
		}
        
 	}
    
    
    private String prepareExistsOnRiderPlanBenefitIndicator(List<String> existsOnRiderPlanArray,String BenefitCode){
        String indicator = '';
      
        For(Integer i =0; i<existsOnRiderPlanArray.size();i++) {
                       if(existsOnRiderPlanArray[i].contains('-')) {
                       String existsOnRiderPlanBenefitKey = existsOnRiderPlanArray[i].split('-')[0];
                       System.debug('BenefitCode--->123'+BenefitCode);
                       System.debug('existsOnRiderPlanArray7777'+existsOnRiderPlanBenefitKey);
                                              System.debug('existsOnRiderPlanBenefitKey.trim()'+existsOnRiderPlanBenefitKey.trim());
    
                       if(BenefitCode.trim() == existsOnRiderPlanBenefitKey.trim()) {
                           System.debug('benefit code matches existsriderplan');
                           System.debug('existsOnRiderPlanArray1234'+existsOnRiderPlanArray[i]); 
                           if(existsOnRiderPlanArray[i].contains('=')) {
                             indicator = existsOnRiderPlanArray[i].split('=')[1];
                             System.debug('existsOnRiderPlanBenefitIndicator456'+indicator);
                           }
                       }
                    }
        }
        return indicator;
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
    
	    
    private String prepareDuration(ACET_GetBenefitAccumsResponseWrapper.benefitCostShare benefitCostShareObj,String MembershipDuration){
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
    
    private Set<String> prepareTierCodeSet(Map<String,List<String>> tierTypeCodeMap){
		Set<String> tierCodeSetTemp = new Set<String>();
		if(tierTypeCodeMap != null && !tierTypeCodeMap.isEmpty()) { 
           for( String key: tierTypeCodeMap.keySet() ){
           List<String> lstString = tierTypeCodeMap.get(key);
          if ( lstString.size()>0 )
          {
          tierCodeSetTemp.addAll(lstString);
          }
         }

        }
		return tierCodeSetTemp;
	}
}