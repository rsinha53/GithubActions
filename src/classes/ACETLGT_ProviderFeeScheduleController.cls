public class ACETLGT_ProviderFeeScheduleController {
    @AuraEnabled
    public static List <Place_Of_Service_Values__mdt> getPlaceOfServicecmdt(){
       return new List<Place_Of_Service_Values__mdt>([select label,Priority__c,Description__c,Place_Of_Service__c from Place_Of_Service_Values__mdt order by Priority__c asc]);
    }
     public class SearchResultWrapper{
		@AuraEnabled public Map<Integer,List<ACETLGT_ProviderFeeScheduleJSON2APEX.claimLines>> resultWrapper {get;set;}
    }
     @AuraEnabled
    public static boolean getProviderFeeScheduleSearchResults1(String DOSFromToday,String DOSThruToday,String pricingSetId,ACETLGT_FeeScheduleWrapper diagCodes,String claimLinesInput,String claimType,String drgCode,String invoiceAmount, String admissionDate, String dischargeDate,String revcode,String claimforType,String typeOfBill) {
        System.debug('inside  DOSFromToday--------'+DOSFromToday);
        return true;
    }
   @AuraEnabled
    public static SearchResultWrapper getProviderFeeScheduleSearchResults(String DOSFromToday, String DOSThruToday,String pricingSetId,ACETLGT_FeeScheduleWrapper diagCodes,String claimLinesInput,String claimType,String drgCode,String invoiceAmount, String admissionDate, String dischargeDate,String revcode,String claimforType,String typeOfBill){
	        Map<Integer,List<ACETLGT_ProviderFeeScheduleJSON2APEX.claimLines>> resultWrapper;
            System.debug('inside search provider fee');
            map<string, boolean> outputcombination;
			 map<Integer,Decimal> mapPriceTotal;
			 List<ACETLGT_ProviderFeeScheduleJSON2APEX.claimLines> outputResponse;
             Integer i =0;
             //ACETLGT_FeeScheduleWrapper diagCodes;
             System.debug(admissionDate);
             System.debug(dischargeDate);
             if(claimType == 'Facility-UB04'){
                i ++;
               outputResponse = new List<ACETLGT_ProviderFeeScheduleJSON2APEX.claimLines>();   
               System.debug('entering');
            }
	        if(outputcombination == null){
            outputcombination = new map<string, boolean>();
           }
		    if(mapPriceTotal == null) {
			   mapPriceTotal = new Map<Integer,Decimal>();
			}
          if(resultWrapper == null) {
            resultWrapper = new Map<Integer,List<ACETLGT_ProviderFeeScheduleJSON2APEX.claimLines>>(); 
          
        }
          if(outputResponse == null) {
               outputResponse = new List<ACETLGT_ProviderFeeScheduleJSON2APEX.claimLines>();
        }
	        List<ACETLGT_FeeScheduleWrapper> claimLinesTemp = new List<ACETLGT_FeeScheduleWrapper>(); 
            System.debug('claimLinesInput' +claimLinesInput);
	        if(claimLinesInput != null && claimLinesInput != ''){
                claimLinesTemp = (List<ACETLGT_FeeScheduleWrapper>) JSON.deserialize(claimLinesInput, list<ACETLGT_FeeScheduleWrapper>.class); 
			} 
			System.debug('claimLinesTemp' +claimLinesTemp);
            System.debug('claimforType' +claimforType);
            System.debug('pricingSetId' +pricingSetId);
            system.debug('outputResponse'+outputResponse);
            ACETLGT_ProviderFeeScheduleWebService ACTPFeeShed = new ACETLGT_ProviderFeeScheduleWebService();
            ACETWSCalloutResult oACETWSCalloutResult = ACTPFeeShed.init(DOSFromToday,DOSThruToday,'','','','','','','','',pricingSetId,diagCodes,claimLinesTemp,drgCode,invoiceAmount,admissionDate,dischargeDate,revCode,claimforType,typeOfBill);	
			Decimal totalPriceAmount = 0.00; 
			if(oACETWSCalloutResult.response != null){
            system.debug('oACETWSCalloutResult.response  ::'+oACETWSCalloutResult.response);
            ACETLGT_ProviderFeeScheduleJSON2APEX outputResponseTemp = (ACETLGT_ProviderFeeScheduleJSON2APEX)oACETWSCalloutResult.response;
            if(outputResponseTemp != null){
                if(outputResponseTemp.feeScheduleDetailResponse != null){
                    if(outputResponseTemp.feeScheduleDetailResponse.claimHeaders != null){
                        
                        for(ACETLGT_ProviderFeeScheduleJSON2APEX.claimHeaders ch: outputResponseTemp.feeScheduleDetailResponse.claimHeaders){
                            if(ch.diagnosisRelatedGroupCode != null)
                                ch.diagnosisRelatedGroupCode = ch.diagnosisRelatedGroupCode;
                            if(ch.claimLines != null){
                                for(ACETLGT_ProviderFeeScheduleJSON2APEX.claimLines cli: ch.claimLines ){
                                    cli.claimClassIDParent = ch.claimClassID;
                                    cli.manualReviewIndicatorParent = ch.manualReviewIndicator;
                                    cli.pricingSetIDParent = ch.pricingSetID;
                                    cli.pricingScheduleIDParent = ch.pricingScheduleID;
                                    cli.pricingScheduleVersionIDParent = ch.pricingScheduleVersionID;
                                    cli.dateOfServiceFrom = cli.dateOfServiceFrom.split('-')[1]+'/'+cli.dateOfServiceFrom.split('-')[2]+'/'+cli.dateOfServiceFrom.split('-')[0];
                                    cli.dateOfServiceThru = cli.dateOfServiceThru.split('-')[1]+'/'+cli.dateOfServiceThru.split('-')[2]+'/'+cli.dateOfServiceThru.split('-')[0];
                                    cli.revenueCode = cli.revenueCode;
                                    cli.drgCode = ch.diagnosisRelatedGroupCode;
                                   
                                    cli.totalPricedAmount = totalPriceAmount;
                                    
                                    if(cli.finalPricedAmount != null){   
                                        totalPriceAmount += decimal.valueOf(cli.finalPricedAmount);
                                        mapPriceTotal.put(i,totalPriceAmount);
                                    }
                                    string claimLineNumberTmp = cli.claimLineNumber;
                                    cli.claimLineNumber = null; 
                                    string combination = string.valueOf(cli.dateOfServiceFrom+''+cli.dateOfServiceThru+''+cli.procedureCode+''+ cli.modifierPricedList + '' + cli.placeOfServiceCode + '' + cli.drgCode+''+cli.serviceUnits+''+cli.billedAmount+''+pricingSetId);
                                     system.debug('>>'+cli);
                                    if(claimType == 'Facility-UB04'){
                                        cli.claimLineNumber = claimLineNumberTmp;
                                        outputResponse.add(cli); 
                                    }else{ 
                                    if(outputcombination.get(combination) == null) {
                                        cli.claimLineNumber = claimLineNumberTmp;
                                        outputResponse.add(cli);    
                                         system.debug('outputResponse===>'+outputResponse);
                                    }
                                    outputcombination.put(combination,true);
                                    }
                                }
                            }                           
                        }  
                    } 
                    
                }
            }
             if(claimType == 'Facility-UB04' && outputResponse.size() > 0){
                ACETLGT_ProviderFeeScheduleJSON2APEX.claimLines cli = new ACETLGT_ProviderFeeScheduleJSON2APEX.claimLines();
                cli.totalPricedAmount = totalPriceAmount;
                outputResponse.add(cli);   
            } 
            System.debug(outputResponse.size())  ; 
            resultWrapper.put(i,outputResponse);
        }
        System.debug('resultWrapper' +resultWrapper);
        SearchResultWrapper detWrap =  new SearchResultWrapper();
	    detWrap.resultWrapper = resultWrapper;
        return detWrap;
        }
	}