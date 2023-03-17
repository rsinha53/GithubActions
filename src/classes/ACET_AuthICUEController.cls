public class ACET_AuthICUEController{
    
    public class ICUEResultWrapper{
        @AuraEnabled public ACET_ICUELetterResult resultWrapper {get;set;}
        @AuraEnabled public string message {get;set;}
        @AuraEnabled public integer statusCode {get;set;}
    }
    
     public boolean isSuccess {get;set;}

    @AuraEnabled
    public static ICUEResultWrapper findICUE(String srnNumber){
        ACET_ICUELetterWS icueLetterWS = new ACET_ICUELetterWS();
        ACETWSCalloutResult calloutResult = new ACETWSCalloutResult();
        ICUEResultWrapper dataWrap = new ICUEResultWrapper();
        ACET_ICUELetterResult responseResult = new ACET_ICUELetterResult();
        if(String.isNotBlank(srnNumber)){
            calloutResult = icueLetterWS.findICUELetter(srnNumber);
            responseResult = (ACET_ICUELetterResult)calloutResult.Response;
        }

        dataWrap.resultWrapper = responseResult;
        dataWrap.message = calloutResult.Message;
        dataWrap.statusCode = calloutResult.statusCode;

        return dataWrap;
    }
    
    @AuraEnabled
    public static ACET_ICUELetterWS.ICUEDocResponse getICUEDoc(String docId){
        ACET_ICUELetterWS iCUELetterWS = new ACET_ICUELetterWS();
        ACET_ICUELetterWS.ICUEDocResponse resWrap = iCUELetterWS.getICUELetter(docId);

        return resWrap;
    }
    public static ACET_ICUELetterWS.ICUEDocResponse getICUEDocByIndexName(String docId,String indexName,String businessFlow){
        ACET_ICUELetterWS iCUELetterWS = new ACET_ICUELetterWS(businessFlow,indexName);
        ACET_ICUELetterWS.ICUEDocResponse resWrap = iCUELetterWS.getICUELetter(docId);
        return resWrap;
    }
   
    public String docContent{get;set;}

     public void getdoc360Value(){
          isSuccess = false;
        string docid = apexpages.currentpage().getparameters().get('DocId');
        
        ACET_ICUELetterWS.ICUEDocResponse docResult;
        String businessFlow = String.isNotBlank(apexpages.currentpage().getparameters().get('businessFlow')) ? apexpages.currentpage().getparameters().get('businessFlow'): '';
        String indexName = String.isNotBlank(apexpages.currentpage().getparameters().get('indexName')) ? apexpages.currentpage().getparameters().get('indexName'): '';
        if(String.isNotBlank(businessFlow) && String.isNotBlank(indexName)){
            docResult = getICUEDocByIndexName(docid,indexName,businessFlow);
        }else {
            docResult = getICUEDoc(docid);
        }
        Blob docStr = docResult.responseBody;
        String contentType = docResult.fileType;
        String responseStrbody = EncodingUtil.Base64Encode(docStr);
        Integer statuscode = docResult.statusCode;
        if(docStr != null && statusCode==200){
             isSuccess = true;
            docContent = 'data:'+contentType+';base64,'+responseStrbody;
         }
         else{
              isSuccess = false;
         }
    }
   
}