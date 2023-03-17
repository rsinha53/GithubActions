public with sharing class ACET_BulkRecoveryService 
{
    public static ACET_SAECalloutResult getRecoveryList(BulkRequest bulkRequest)
    {
        ACET_SAECalloutResult returnRes = new ACET_SAECalloutResult();
        try {
            Map < String, String > requestParamsMap = new Map < String, String > ();
            requestParamsMap.put('chkNbr', bulkRequest.paymentReference);
            requestParamsMap.put('paymentType', bulkRequest.paymentType);
            requestParamsMap.put('checkSeriesDesignator', bulkRequest.chkSerDeg);
            requestParamsMap.put('tin', bulkRequest.taxId);
            requestParamsMap.put('platform', bulkRequest.platform);
            requestParamsMap.put('bulkRecoveryInd', bulkRequest.bulkRecoveryInd);

            ACET_WebserviceCalloutFramework wsCallOutFW = new ACET_WebserviceCalloutFramework();
            wsCallOutFW.serviceName = 'LinkBulkRecovery';
            wsCallOutFW.requestParamsMap = requestParamsMap;
            HttpResponse response = wsCallOutFW.getResponse();

            Integer statusCode = response.getStatusCode();
            String responseBody = response.getBody();

            if(statusCode == 200){
                returnRes.isSuccess = true;
                returnRes.statusCode = 200;
                returnRes.response = processRequest(responseBody);
            }else{
                returnRes.isSuccess = false;
                returnRes.statusCode = statusCode;
            }     
        } catch (Exception e) {
            returnRes.isSuccess = false;
            returnRes.statusCode = 999;
        }  
        System.debug(JSON.serialize(returnRes));
        return returnRes;
    }

    private static List<BulkRecoverInfo> processRequest(String response)
    {
        List<BulkRecoverInfo> returnList = new List<BulkRecoverInfo>();
        RecoveryResponse recoveryResp = (RecoveryResponse) JSON.deserializeStrict(response, RecoveryResponse.class);
        if(recoveryResp != null){
            for(AccountRecovery ar : recoveryResp.accountRecoveryList){
                BulkRecoverInfo br = new BulkRecoverInfo();
                br.paidAmount = formatDollarAmount(ar.overPaidAmt);
                br.recoveryAmount = formatDollarAmount(recoveryResp.bulkRecoveryAmt);
                br.draftNbr = ar.draftNbr;
                returnList.add(br);
            }
        }
        return returnList;
    }

    private static String formatDollarAmount(String dollarAmt)
    {
        if(dollarAmt.startsWith('-')){
            return '-' + dollarAmt.replace('-', '$');
        }
        return '$' + dollarAmt;
    }

    // Just for testing - Remove when doing the functional story
    public static void callrecovery()
    {
        BulkRequest br = new BulkRequest();
        br.paymentReference = '80878960';
        br.paymentType = 'E';
        br.chkSerDeg = 'TR';
        br.taxId =  '861175591';
        ACET_SAECalloutResult result = getRecoveryList(br);
    }

    // Wrapper Classes
    // Response
    private class RecoveryResponse
    {
        private String chkSrsDesg;	//TR
        private String paymentRefNumber;	//80878960
        private String chkEftInd;	//E
        private String chkIssueDt;	//04/05/2021
        private String chkAmt;	//15600.7
        private String bulkRecoveryAmt;	//-454.93
        private List<AccountRecovery> accountRecoveryList;       
    }

    private class AccountRecovery 
    {
        private String draftNbr;	//0024318112
        private String draftAmt;	//-213.03
        private String overPaidAmt;	//-213.03
        private String caeClaimNumber;	//CK50771757
        private String tin;	//861175591
        private String billProvNm;	//GOFMAN MD/INESSA
        private String pan;	//EA703430641
        private String altId;	//938580296
    }

    //Request Object
    public class BulkRequest
    {
        @AuraEnabled public String paymentReference{get;set;}
        @AuraEnabled public String paymentType{get;set;}
        @AuraEnabled public String chkSerDeg{get;set;}
        @AuraEnabled public String taxId{get;set;}
        public String platform{get{return 'TOPS';} set;}
        public String bulkRecoveryInd{get{return 'Y';}set;}
    }

    // Front end return object
    public class BulkRecoverInfo
    {
        @AuraEnabled public String recoveryAmount;
        @AuraEnabled public String paidAmount;
        @AuraEnabled public String draftNbr;
    }
}