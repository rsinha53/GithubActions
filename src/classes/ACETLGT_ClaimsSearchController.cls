public class ACETLGT_ClaimsSearchController {
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
    public static DataWrapper getClaimsSearchResults(string taxid, string inNetwork,date startdate,date enddate,string strdeductible,string claimnumber, string AuthorizationNumber,string ReferralNumber,string providers, string MemberId,string EID,string Encounters){          
        ACETLGT_FindClaimWebservice findClaimService = new ACETLGT_FindClaimWebservice();
         findClaimService.init(taxid,inNetwork,string.valueOf(startdate),string.valueOf(enddate),strdeductible,claimnumber,AuthorizationNumber,ReferralNumber,providers,MemberId,EID,Encounters);         
        string  service = JSON.serialize(findClaimService).replace('\'', '&#x27;');
        service = service.replace('&#x27;', '\'');
        return new DataWrapper(JSON.serialize(service));

    }
 @AuraEnabled
    public static string getEncoderProDescription(String data){
        
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