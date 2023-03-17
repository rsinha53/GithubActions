public class ETSBE_PolicyDetailsController {
   
    public class SearchResultWrapper{
        @AuraEnabled public ETSBE_PolicyDetailsResults resultWrapper {get;set;}
    }
    

    
    @AuraEnabled(cacheable=true)
    public static SearchResultWrapper getPolicyData(String transactionId){
        ETSBE_PolicyDetailsResults resultwrap = new ETSBE_PolicyDetailsResults(); 
        ETSBE_PolicyDetailsResults.policyResults policyResultwrap = new ETSBE_PolicyDetailsResults.policyResults(); 
        system.debug('transactionId::'+transactionId);
        ETSBE_ExtendedCoverageWS policyDetailsWS = new ETSBE_ExtendedCoverageWS();
        ACETWSCalloutResult CalloutResult = null;
        
        CalloutResult = policyDetailsWS.getPolicyWS(transactionId);
        if (CalloutResult.Success)
        {   
            //policyResultwrap= (SAEPolicyDetailsResult.policyResults)CalloutResult.Response;
            resultwrap= (ETSBE_PolicyDetailsResults)CalloutResult.Response;
            //resultwrap= (SAEPolicyDetailsResult)CalloutResult.Response;
            System.debug('resultwrap::: ' + resultwrap);
            System.debug('policyResultwrap::: ' + resultwrap.policyRes);
            
        } 
        else
        {
            
        }           
        
        
        SearchResultWrapper dataWrap = new SearchResultWrapper();
        dataWrap.resultWrapper = resultwrap;
        system.debug('dataWrap:::'+dataWrap);
        return dataWrap;
    }    

}