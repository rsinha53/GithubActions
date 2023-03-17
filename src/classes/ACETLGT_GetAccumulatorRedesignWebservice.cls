/* 
 * @name         :   ACETLGT_GetAccumulatorRedesignWebservice
 * @description  :   This component  is created to call webservice for the accumulator and pass the accums to benefit language webservice. 
 * @author       :   Divya Sindhu B
 * @createddate  :   03-11-2017
 * @lastmodifiedby:
 *
 */
public class ACETLGT_GetAccumulatorRedesignWebservice extends ACETWebservice {
    public ACETGroupPlanBenefitWrapper ACETPlanBenefitSearchResults;
    public ACETGroupPlanBenefitWrapper ACETSubscriptionServiceResults;
    public override void GetEndpoint()
    {
         GetEndpointDetail('GetBenefitAccEndpoint');
    }
    public ACETLGT_GetAccumulatorRedesignWebservice() {
        super('Stargate');
    }
    private void GetRequestBody() {
        RequestBody = GetRequestBody('ACETLGT_GetBenefitAccRequestJSON', RequestParameters);        
    }
    
      public List<ACETLGT_PlanBenefitLanguageWrapper.BenefitWrapper> getAccumulatorBenefitsRedesign(String BenefitBundleOptId, 
                                                                         
                                                                         String enrollerSRK, 
                                                                         String surrogateKey, 
                                                                         String EffectiveStartDate,
                                                                         String EffectiveEndDate,                         
                                                                         String BenefitCode, string accumAsOf,String GroupNumber, String SubscriptionServiceResponse,String MembershipDuration,String SubscriptionResponse,List<String> benefitRiderList) {
           Map<String,List<String>> tierTypeCodeMap = new Map<String,List<String>>();
          Map<String,String> tierTypeIdentifierMap = new Map<String,String>();
          List<String> SubscriptionServiceResponseList = new List<String>();
		  List<String> SubscriptionResponseList = new List<String>(); 
          String existsOnRiderPlanBenefitIndicator = '';
          //BenefitCode = 'RX_TIER_1';                                                                    
          Map<String,List<ACETLGT_GetAccumulatorRedesignJSON2APEX.benefitCode>> benefitPlanMap = new Map<String,List<ACETLGT_GetAccumulatorRedesignJSON2APEX.benefitCode>>();                                                                          
          system.debug('SubscriptionServiceResponse::'+SubscriptionServiceResponse);
		  system.debug('MembershipDuration'+MembershipDuration); 
          system.debug('SubscriptionResponse::'+SubscriptionResponse);
          String SubscriptionServiceReplaceResponse = SubscriptionServiceResponse.replace('(','').replace(')','');
          System.debug('SubscriptionServiceReplaceResponse' +SubscriptionServiceReplaceResponse);                                                                
          if(String.isNotBlank(SubscriptionServiceReplaceResponse)){ 		  
            SubscriptionServiceResponseList = SubscriptionServiceReplaceResponse.split(',');
          } 
          if(SubscriptionServiceResponseList != null && !SubscriptionServiceResponseList.isEmpty()){                   		  
            for(String s : SubscriptionServiceResponseList){
              system.debug('s :'+s);
              List<string> tempString = new List<String>();
              tempString = s.split('-');
              String first = tempString[0].trim();
              system.debug('first'+first);
              String last = tempString[1];
              system.debug('last'+last);
              if(tierTypeCodeMap.containsKey(first)) {
                 tierTypeCodeMap.get(first).add(last);    
              }else {
                  System.debug('tierTypeCodeMap' +tierTypeCodeMap);
                  tierTypeCodeMap.put(first, new List<String>{last});
              }
               
             
            }     
              System.debug('tierTypeCodeMap ::'+tierTypeCodeMap);  
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
        }	
	     if(SubscriptionResponseList != null && !SubscriptionResponseList.isEmpty()){ 
          for(String s : SubscriptionResponseList) { 
              List<string> tempTierIdentifier = new List<String>();
              tempTierIdentifier = s.split('-');
              if(tempTierIdentifier !=null && tempTierIdentifier.size() > 0){
                String tierIdentifier = tempTierIdentifier[0].trim();
                system.debug('tierIdentifier'+tierIdentifier);
                String tierType = tempTierIdentifier[1];
                system.debug('tierType'+tierType);  
                tierTypeIdentifierMap.put(tierIdentifier,tierType); 
              }
          }
		}
          System.debug('tierTypeIdentifierMap :'+tierTypeIdentifierMap);
          System.debug('benefitRiderList000'+benefitRiderList); 
          if(benefitRiderList != null && !benefitRiderList.isEmpty()) {
               For(Integer i =0; i<benefitRiderList.size();i++) {
                   if(benefitRiderList[i].contains('-')) {
                   String existsOnRiderPlanBenefitKey = benefitRiderList[i].split('-')[0];
                   System.debug('BenefitCode777'+BenefitCode);
                   System.debug('benefitRiderList888'+existsOnRiderPlanBenefitKey);
                  // if(String.isNotBlank(existsOnRiderPlanBenefitKey) && BenefitCode.trim() == existsOnRiderPlanBenefitKey.trim()) {
                     if(existsOnRiderPlanBenefitKey.contains(BenefitCode)) {
                       System.debug('benefit code matches existsriderplan');
                       System.debug('benefitRiderList'+benefitRiderList[i]); 
                       if(benefitRiderList[i].contains('=')) {
                         existsOnRiderPlanBenefitIndicator = benefitRiderList[i].split('=')[1].replaceAll('"', '');
                         System.debug('existsOnRiderPlanBenefitIndicator--->'+existsOnRiderPlanBenefitIndicator);
                       }
                   }
               }
           } 
           }                                                                  
          ACETLGT_PlanBenefitLanguageWrapper.BenefitWrapper bw = new ACETLGT_PlanBenefitLanguageWrapper.BenefitWrapper(); 
          List<ACETLGT_PlanBenefitLanguageWrapper.BenefitWrapper> accumList = new List<ACETLGT_PlanBenefitLanguageWrapper.BenefitWrapper>(); 
          Map<String,ACETLGT_PlanBenefitLanguageWrapper.AccumulatorCode> accumMap = new Map<String,ACETLGT_PlanBenefitLanguageWrapper.AccumulatorCode>(); 
          Map<String,ACETLGT_PlanBenefitLanguageWrapper.AccumulatorCode> accumOONMap = new Map<String,ACETLGT_PlanBenefitLanguageWrapper.AccumulatorCode>();                                                                      
          List<ACETLGT_PlanBenefitLanguageWrapper.AccumulatorCode> aList = new List<ACETLGT_PlanBenefitLanguageWrapper.AccumulatorCode>();
          List<ACETLGT_PlanBenefitLanguageWrapper.AccumulatorCode> aOONList = new List<ACETLGT_PlanBenefitLanguageWrapper.AccumulatorCode>();
          bw.dateRange = new list<string>();                                                              
          try {
            HttpResponse response = null;
            GetEndpoint();
            List<String> accumsBeefitsCode = BenefitCode.split(',');
            //system.debug('accumsBeefitsCode :'+accumsBeefitsCode);  
            String accumsBenefitJoin='';
            //accumsBenefitJoin = accumsBenefitJoin+'[';
            for(String s: accumsBeefitsCode ){
               accumsBenefitJoin = accumsBenefitJoin+'{"benefitCode":'+'"'+s.removeEnd('_').trim()+'"},';    
            }
            accumsBenefitJoin = accumsBenefitJoin.removeEnd(',');
            //System.debug('accumsBenefitJoin ::'+accumsBenefitJoin);
            RequestParameters = new List<String>{BenefitBundleOptId, enrollerSRK,surrogateKey,EffectiveStartDate, 
            EffectiveEndDate,accumsBenefitJoin, accumAsOf,GroupNumber};
            //system.debug('RequestParameters ::'+RequestParameters);
            GetRequestBody(); 
            System.debug('tierCodeSet ::'+tierCodeSet);
            Response = Send(OAuthConfig); 
            if (Response.getStatusCode() == 200) {
                  bw.accumulatorCodeList =  new list<ACETLGT_PlanBenefitLanguageWrapper.AccumulatorCode>();
                  ACETLGT_GetAccumulatorRedesignJSON2APEX ACETJSON2Apex = (ACETLGT_GetAccumulatorRedesignJSON2APEX)JSON.deserialize(Response.getBody(), ACETLGT_GetAccumulatorRedesignJSON2APEX.class); 
                  if(ACETJSON2Apex.getBenefitAccumulatorResponse.benefitAccumulator != null) {
                      ACETLGT_GetAccumulatorRedesignJSON2APEX.benefitAccumulator benefitsAccumulator = ACETJSON2Apex.getBenefitAccumulatorResponse.benefitAccumulator;
                      //System.debug('benefitsAccumulator::::'+benefitsAccumulator);
                      if(benefitsAccumulator != null) {
                          
                          for(ACETLGT_GetAccumulatorRedesignJSON2APEX.benefitPlan benefitPlanObj: benefitsAccumulator.benefitPlan) {
                                  benefitPlanMap.put(benefitPlanObj.benefitPlanId,benefitPlanObj.benefitCode);
                                  String benefitPlanKey = benefitPlanObj.benefitPlanId;
                                  System.debug('benefitPlanKey'+benefitPlanKey);
                                 List<ACETLGT_GetAccumulatorRedesignJSON2APEX.benefitCode> benefitPlanCodeObj = benefitPlanMapping(benefitPlanMap,existsOnRiderPlanBenefitIndicator,benefitPlanKey);
                                 System.debug('benefitPlanCodeObj'+benefitPlanCodeObj); 
                                 if(benefitPlanCodeObj != null) {
                                  for(ACETLGT_GetAccumulatorRedesignJSON2APEX.benefitCode benefitCodeObj: benefitPlanCodeObj) {
                                  bw.BenefitKey = getValidString(benefitCodeObj.benefitCode)+' - '+getValidString(benefitCodeObj.benefitName);
                                  //system.debug('bw.BenefitKey :'+bw.BenefitKey);
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
                                        if((String.isNotBlank(existsOnRiderPlanBenefitIndicator) && existsOnRiderPlanBenefitIndicator == 'true') ||(String.isBlank(existsOnRiderPlanBenefitIndicator) && String.ValueOf(tierTypeCodeMap.keySet()).removeEnd('}').removeStart('{')==benefitPlanObj.benefitPlanId && tierCodeSet.contains(benefitCodeObj.benefitTier) && tierTypeIdentifierMap != null && tierTypeIdentifierMap.containsKey(benefitCodeObj.benefitTier))){
                                            
                                            for(ACETLGT_GetAccumulatorRedesignJSON2APEX.benefitCostShare benefitCostShareObj: benefitCodeObj.benefitCostShare) {
                                                //System.debug('benefitCostShareObj.costShareType:::'+benefitCostShareObj.costShareType);
                                                if(benefitCostShareObj.costShareType == 'Benefit Maximum' || (benefitCostShareObj.primaryCostShareIndicator == 'false' && benefitCostShareObj.benefitMaximumValue!=null))  { //Benefit Maximum
                                                    ACETLGT_PlanBenefitLanguageWrapper.AccumulatorCode Ac = new ACETLGT_PlanBenefitLanguageWrapper.AccumulatorCode();
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
                                                    if(String.isNotBlank(benefitCostShareObj.limitAccumulatorBenefitPeriodDurationCount) && String.isNotBlank(benefitCostShareObj.limitAccumulatorBenefitPeriodDurationCode)) {
                                                       Ac.duration  = (String.isNotBlank(benefitCostShareObj.limitAccumulatorBenefitPeriodDurationCount) ? (benefitCostShareObj.limitAccumulatorBenefitPeriodDurationCount) : '') + '  '+ (String.isNotBlank(benefitCostShareObj.limitAccumulatorBenefitPeriodDurationCode ) ? (benefitCostShareObj.limitAccumulatorBenefitPeriodDurationCode ) : '') ;
                                                    } 
                                                    else if(benefitCostShareObj.costShareType == 'Out of Pocket' && String.isBlank(benefitCostShareObj.limitAccumulatorBenefitPeriodDurationCount) && String.isBlank(benefitCostShareObj.limitAccumulatorBenefitPeriodDurationCode)) {
                                                        Ac.duration = (String.isNotBlank(MembershipDuration)) ? ('1'+ '  '+MembershipDuration):'';
                                                    }
                                                    else {
                                                        Ac.duration = '';
                                                    }
                                                    Ac.benefitRemainingValue = (String.isNotBlank(benefitCostShareObj.benefitRemainingValue) ? (benefitCostShareObj.benefitRemainingValue) : '');
                                                    Ac.dateRangeValue = listVal;
                                                    System.debug('benefitCostShareObj.costShareId'+benefitCostShareObj.costShareId);
                                                    Ac.dateRange = new List<string>();
                                                    if(bw.dateRange != Null){
                                                        Ac.dateRange.addAll(bw.dateRange);    
                                                    }
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
                                                        bw.accumulatorCodeList = new list<ACETLGT_PlanBenefitLanguageWrapper.AccumulatorCode>{Ac};
                                                    }   
                                                }
                                                System.debug('bw.accumulatorCodeList ::'+bw.accumulatorCodeList);
                                            }
                                        }  
                                          
                                      
                                  }
                              }
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
                  } 
                     bw.isSuccess = true;
                     bw.Message = '';  
                     accumList.add(bw);
              }
             else if (Response.getStatusCode() == 404){     
                    bw = new ACETLGT_PlanBenefitLanguageWrapper.BenefitWrapper(); 
                    bw.isSuccess = false;
                    bw.messageSeverityStr = 'INFO';
                    ACETLGT_GetAccumulatorRedesignJSON2APEX JSON2ApexError = (ACETLGT_GetAccumulatorRedesignJSON2APEX)JSON.deserialize(Response.getBody(), ACETGetAccumulatorRedesignJSON2APEX.class);
                    bw.Message = GetOILErrorMessage(JSON2ApexError.getBenefitAccumulatorResponse.errors);
                    System.debug('*****'+bw);  
                    accumList.add(bw);
                }else {
                    bw = new ACETLGT_PlanBenefitLanguageWrapper.BenefitWrapper();
                    bw.isSuccess = false;
                    bw = ParseFailureResponseFromOil(Response); 
                    System.debug('*****500'+bw); 
                    accumList.add(bw);
                }                     
      }
      catch(Exception w) {
          System.debug('Excepttion:::'+w);
      }
      //System.debug(' accumList ::' + accumList);
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
    private static List<ACETLGT_GetAccumulatorRedesignJSON2APEX.benefitCode> benefitPlanMapping(Map<String,List<ACETLGT_GetAccumulatorRedesignJSON2APEX.benefitCode>> benefitPlanMap,String existsOnRiderPlanBenefitIndicator,String benefitPlanKey) {
       List<ACETLGT_GetAccumulatorRedesignJSON2APEX.benefitCode> benefitCodeObj = new List<ACETLGT_GetAccumulatorRedesignJSON2APEX.benefitCode>();
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
                
                //FormattedDate = OILDateSplit[2] + '-' + OILDateSplit[0] + '-' + OILDateSplit[1];
                FormattedDate = OILDateSplit[2] + '-' + appendMonth + '-' + appendDay;
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
                        if (String.isBlank(bw.Message)) { 
                            bw.Message = ErrorDescription;
                        } else {
                            if (bw.Message.length() + ErrorDescription.length() <= 255) {
                                bw.Message += '; ' + ErrorDescription;
                            } else {
                                break;
                            }   
                        }   
                    }
                }
            }       
        }
        catch(Exception ex)
        {
            system.debug(LoggingLevel.INFO, 'Error serializing error response JSON. Details: ' + ex);
            bw.Message = FailureResponse.getBody();
        }
        
        return bw;
      }

}