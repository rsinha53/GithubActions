public class ACETLGT_ClaimDetailHistoryController {
@AuraEnabled
    public static string getProfClaimDetail(string claim_Type, string claim_ID,string claimEventId){
        ACETLGT_ProfessionalClmHistoryWebservice  ws = new ACETLGT_ProfessionalClmHistoryWebservice ();
        ACETWSCalloutResult result = new ACETWSCalloutResult();
        result =  ws.ProfessionalClaimHistoryWS(claim_Type,claim_ID,claimEventId); 
        return JSON.serialize(result);
    }
    
    @AuraEnabled
    public static string getInstClaimDetail(string claim_Type, string claim_ID,string claimEventId){
    	ACETLGT_InstiClmHistoryWebservice  ws = new ACETLGT_InstiClmHistoryWebservice ();
        ACETWSCalloutResult result = new ACETWSCalloutResult();
        result =ws.InstitutionalClaimHistoryWS(claim_Type,claim_ID,claimEventId); 
        return JSON.serialize(result);
    }
    
    @AuraEnabled
    public static string getStdErrMsg(String prefix, Integer resultStatusCode) {
    	string errorMessage;
    	ACETErrorHandler errHandler = new ACETErrorHandler();
    	string errorcode = prefix;
    	errorcode  = errorcode + resultStatusCode;
    	system.debug('inside getStdErrMsg ' + errorcode);
        if(resultStatusCode!=null && resultStatusCode !=200 &&(resultStatusCode == 400 || resultStatusCode == 404 || resultStatusCode == 500)) {
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
       
       @AuraEnabled
       public static string getEncoderProDescription(String data){
           system.debug('inside history encoder pro');
           Map<String,List<String>> codesMap = (Map<String,List<String>>)JSON.deserialize(data , Map<String,List<String>>.class);
           ACETWSCalloutResult result = new ACETWSCalloutResult();
           Set<String> codeToProcessSet = new Set<String>();//bring it from ui
           List<String> codeToProcessLst = new  List<String>();
           for(String section : codesMap.keySet() ){
               for(String code : codesMap.get(section)){
                   codeToProcessSet.add(code);
               }
           }
           codeToProcessLst.addAll(codeToProcessSet);//This will make the list with unique codes
           ACETLGT_EncoderProWebservice encoderWS = new ACETLGT_EncoderProWebservice();
           return JSON.serialize(encoderWS.getCodeDescriptions(codeToProcessLst));
       }
    
}