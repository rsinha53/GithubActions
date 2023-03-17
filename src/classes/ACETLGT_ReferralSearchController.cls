public class ACETLGT_ReferralSearchController {
    public class custException extends Exception {}
	public  class DatatableWrapper{
	       @Auraenabled
	        public string response;
	       @Auraenabled 
	         public string wrapperdetails;
	        public DatatableWrapper(String response){
	            this.response = response;        
	        }       
	    }
     public class DetailResultWrapper{
        @AuraEnabled public Map<String,ACETLGT_ReferralSearchResult> referralMap {get;set;}
        @Auraenabled public integer statusCode;
    }
	    @AuraEnabled
	    public static DatatableWrapper getReferralSearchResults(string firstName, string lastName, string birthDate, string srk){          
	    	ACETLGT_ReferralWebservice RWS = new ACETLGT_ReferralWebservice();
	    	RWS.init(firstName ,lastName , birthDate, srk);         
	        string  service = JSON.serialize(RWS).replace('\'', '&#x27;');
	        service = service.replace('&#x27;', '\'');
	        return new DatatableWrapper(JSON.serialize(service));

	    }
        @AuraEnabled
	    public static DetailResultWrapper getReferralDetailResults(string firstName, string lastName, string birthDate, string srk){          
	    	ACETWSCalloutResult CalloutResult = new ACETWSCalloutResult();   
            ACETLGT_ReferralWebservice RWS = new ACETLGT_ReferralWebservice();
            List<ACETLGT_ReferralSearchResult> resultwrap = new List<ACETLGT_ReferralSearchResult>(); 
            Map<String,ACETLGT_ReferralSearchResult> referralMap = new Map<String,ACETLGT_ReferralSearchResult>();
            CalloutResult = RWS.findReferrals(firstName ,lastName , birthDate, srk);
            system.debug('CalloutResult.statusCode======'+CalloutResult);
            if (CalloutResult.Success)
            {   
             resultwrap= (list<ACETLGT_ReferralSearchResult>)CalloutResult.Response;
             if(resultwrap != null){
              for(ACETLGT_ReferralSearchResult ac : resultwrap){
                  referralMap.put(ac.resultreferralExternalID, ac);    
                }
             }
           }
           DetailResultWrapper detWrap = new DetailResultWrapper();
           detWrap.referralMap = referralMap;
           detWrap.statusCode= CalloutResult.statusCode;
           system.debug('detWrap======'+detWrap);
           return detWrap;
    }
     @AuraEnabled
      public static string getStdErrMsg(String prefix, Integer resultStatusCode) {
        string errorMessage;
        string resultStatus;
        if(resultStatusCode == 400){
          resultStatus ='400B';
        }else{
          resultStatus = String.valueOf(resultStatusCode);
        }
        ACETErrorHandler errHandler = new ACETErrorHandler();
        string errorcode = prefix;
        errorcode  = errorcode + resultStatus;
        system.debug('inside getStdErrMsg ' + errorcode);
        if(resultStatusCode!=null && resultStatusCode !=200 &&(resultStatusCode == 400 || resultStatusCode == 500)) {
            set<string> msg_set = errHandler.setErrorMsgInDataTable(errorcode,null);
            if(msg_set != null){
                for (string setElement : msg_set) {
                    errorMessage  = setElement;
      
                     }              
                   msg_set.clear();
                 }
        }
        return errorMessage;
      }
}