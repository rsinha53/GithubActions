public class SAEHouseHoldController {
	
    public class SearchResultWrapper{
        @AuraEnabled public SAEHouseHoldWrapper resultWrapper {get;set;}        
    }
    
    @AuraEnabled
    public static SearchResultWrapper getHouseHoldMembers(String transactionId){
        SAEGetHouseHoldWebService callWS = new SAEGetHouseHoldWebService();
        SAEHouseHoldWrapper resultwrap = new SAEHouseHoldWrapper();
        ACETWSCalloutResult CalloutResult = null;
		CalloutResult = callWS.getHouseHoldData(transactionId);
        
        if (CalloutResult.Success)
        {   
            resultwrap = (SAEHouseHoldWrapper)CalloutResult.Response;
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