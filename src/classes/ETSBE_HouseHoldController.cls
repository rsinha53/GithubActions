public class ETSBE_HouseHoldController {
	
    public class SearchResultWrapper{
        @AuraEnabled public ETSBE_HouseHoldWrapper resultWrapper {get;set;}        
    }
    
    @AuraEnabled
    public static SearchResultWrapper getHouseHoldMembers(String transactionId){
        ETSBE_GetHouseHoldWebService callWS = new ETSBE_GetHouseHoldWebService();
        ETSBE_HouseHoldWrapper resultwrap = new ETSBE_HouseHoldWrapper();
        ACETWSCalloutResult CalloutResult = null;
		CalloutResult = callWS.getHouseHoldData(transactionId);
        
        if (CalloutResult.Success)
        {   
            resultwrap = (ETSBE_HouseHoldWrapper)CalloutResult.Response;
            System.debug('resultwrap.houseHoldList@@@ ' + resultwrap.houseHoldList);
        } 
        else
        {
            //ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Webservice Error'));
        }           
        system.debug('>>>resultwrap------'+resultwrap); 
        SearchResultWrapper dataWrap = new SearchResultWrapper();
        dataWrap.resultWrapper = resultwrap;
        return dataWrap;
    }
}