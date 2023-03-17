public class ACETLGT_HSABankAcccountController extends ACETErrorHandler{
    
    //Added 20/12/2019
    //
    
    public List<ACETLGT_HSATransactionResult> allTransactions;
    
    public class HSASummaryResultWrapper{
        @AuraEnabled public ACETLGT_HSASummaryResult resultWrapper {get;set;}
        @AuraEnabled public String ErrorMessage {get;set;}
    }
    public class HSATransactionResultWrapper{
        @AuraEnabled public List<ACETLGT_HSATransactionResult> transactionResultWrapper {get;set;}
        @AuraEnabled public String ErrorMessage {get;set;}
    }
    
    public  class DataWrapper{
        @Auraenabled
        public string responce;
        @Auraenabled 
        public string wrapperdetails;
        public DataWrapper(String responce){
            this.responce = responce;        
        }       
    }
    
    @AuraEnabled 
    public static HSASummaryResultWrapper GetHsaSummaryValues(String ssn){
        
        ACETLGT_HSASummaryResult resultwrap = new ACETLGT_HSASummaryResult();
        System.debug('Enter :: ');
        ACETLGT_HSASummaryWebservice hsa = new ACETLGT_HSASummaryWebservice();
        ACETWSCalloutResult CalloutResult = hsa.GetHsaSummary(ssn);
        
        HSASummaryResultWrapper detWrap = new HSASummaryResultWrapper();
        system.debug('~~~After callout'+CalloutResult);
        
        if (CalloutResult != null && CalloutResult.Success == true){   
            resultwrap= (ACETLGT_HSASummaryResult)CalloutResult.Response;
            
            system.debug('~~~resultwrap------'+resultwrap);
            detWrap.resultWrapper = resultwrap;
        system.debug('>>>finalresult'+detWrap );
        return detWrap;
        } else{
            detWrap.resultWrapper = new ACETLGT_HSASummaryResult();
            if(CalloutResult!= null && CalloutResult.statusCode == 400)
                detWrap.ErrorMessage = setLightningErrorMsg('GN400B');
            else
                detWrap.ErrorMessage = setLightningErrorMsg('GN'+CalloutResult.statusCode );
            return detWrap;
        }
        
    }
    
    @AuraEnabled 
    public static HSATransactionResultWrapper GetHsaTrasactionValues(String hsaid,String status){
        List<ACETLGT_HSATransactionResult> allTransactions = new List<ACETLGT_HSATransactionResult>();
        List<ACETLGT_HSATransactionResult> finalTransactions = new List<ACETLGT_HSATransactionResult>();
                
        List<ACETLGT_HSATransactionResult> resultwrapTransaction = new List<ACETLGT_HSATransactionResult>();
        Boolean isError = false; 
        Integer StatusCode;
        System.debug('Enter :: Recent'+hsaid);
        ACETLGT_HSATransactionWebservice hsa = new ACETLGT_HSATransactionWebservice();
        hsa.init(hsaid, 'Recent');  
        ACETWSCalloutResult CalloutResult = hsa.querypaginateddata(1 , 50, 1);
        
        //ACETWSCalloutResult CalloutResult = hsa.GetHsaSummary(ssn);
        
        system.debug('~~~After callout'+CalloutResult);
	if (CalloutResult != null && CalloutResult.Success == true){   
            resultwrapTransaction= (List<ACETLGT_HSATransactionResult>)CalloutResult.Response;
            allTransactions.addAll(resultwrapTransaction );
                
            } else{
               isError = true; 
                StatusCode = CalloutResult.statusCode;
        } 
        
        //Second Callout
        List<ACETLGT_HSATransactionResult> resultwrapTransaction_Scheduled = new List<ACETLGT_HSATransactionResult>();
        
        System.debug('Enter :: scheduled');
        ACETLGT_HSATransactionWebservice hsa_scheduled = new ACETLGT_HSATransactionWebservice();
        hsa_scheduled.init(hsaid, 'Scheduled');  
        ACETWSCalloutResult CalloutResult_Scheduled = hsa_scheduled.querypaginateddata(1 , 50, 1);
        
        //ACETWSCalloutResult CalloutResult = hsa.GetHsaSummary(ssn);
        
        system.debug('~~~After callout'+CalloutResult_Scheduled);
        
        if (CalloutResult_Scheduled != null && CalloutResult_Scheduled.Success == true){   
            resultwrapTransaction_Scheduled= (List<ACETLGT_HSATransactionResult>)CalloutResult_Scheduled.Response;
            allTransactions.addAll(resultwrapTransaction_Scheduled );
            
            
            } else{
                isError = true; 
                StatusCode = CalloutResult.statusCode;
        } 
        system.debug('~~~resultwrap------'+allTransactions);
        if(isError){
            HSATransactionResultWrapper detWrap = new HSATransactionResultWrapper();
            detWrap.transactionResultWrapper = new List<ACETLGT_HSATransactionResult>();
            if(StatusCode!= null && StatusCode == 400)
                detWrap.ErrorMessage = setLightningErrorMsg('GN400B');
            else
                detWrap.ErrorMessage = setLightningErrorMsg('GN'+CalloutResult.statusCode );
            return detWrap; 
        }else{
            finalTransactions = sortByDate(allTransactions);   
            HSATransactionResultWrapper detWrap = new HSATransactionResultWrapper();
            detWrap.transactionResultWrapper = finalTransactions;
            system.debug('>>>finalresult'+detWrap );
            return detWrap;
}
    }

//Sort By Date
private static List<ACETLGT_HSATransactionResult> sortByDate(List<ACETLGT_HSATransactionResult> allTransactions){
    system.debug('in sortbydate');
    List<ACETLGT_HSATransactionResult> tempList = new List<ACETLGT_HSATransactionResult>();
    tempList.addAll(allTransactions);
    for(ACETLGT_HSATransactionResult temp: tempList){
        System.debug(temp);
    }
    for(Integer i = 0; i < (tempList.size() - 1) ; i++){
        String oldDate, newDate;
        oldDate = tempList[i].transactionDate.split('/')[2] + tempList[i].transactionDate.split('/')[0] + tempList[i].transactionDate.split('/')[1];
        newDate = tempList[i+1].transactionDate.split('/')[2] + tempList[i+1].transactionDate.split('/')[0] + tempList[i+1].transactionDate.split('/')[1];
        if(oldDate < newDate){
            ACETLGT_HSATransactionResult placeholder = tempList[i+1];
            tempList[i+1] = tempList[i];
            tempList[i] = placeholder;
        }
        if(i > 0){
            for(Integer j = i; j > 0; j--){
                oldDate = tempList[j].transactionDate.split('/')[2] + tempList[j].transactionDate.split('/')[0] + tempList[j].transactionDate.split('/')[1];
                newDate = tempList[j-1].transactionDate.split('/')[2] + tempList[j-1].transactionDate.split('/')[0] + tempList[j-1].transactionDate.split('/')[1];
                if(oldDate > newDate){
                    ACETLGT_HSATransactionResult placeholder = tempList[j-1];
                    tempList[j-1] = tempList[j];
                    tempList[j] = placeholder;
                }
            }
        }
    } 
    for(ACETLGT_HSATransactionResult temp: tempList){
        System.debug(temp);
    }
    
    allTransactions = tempList; 
    return allTransactions;
}


@AuraEnabled
public static DataWrapper GetHsaDTTrasactionValues(string hsaid, string status){          
    ACETLGT_HSATransactionWebservice hsa = new ACETLGT_HSATransactionWebservice();
    hsa.init(hsaid, status);  
    //ACETWSCalloutResult CalloutResult = hsa.querypaginateddata(1 , 50, 1);
    string  service = JSON.serialize(hsa).replace('\'', '&#x27;');
    service = service.replace('&#x27;', '\'');
    return new DataWrapper(JSON.serialize(service));
    
}


}