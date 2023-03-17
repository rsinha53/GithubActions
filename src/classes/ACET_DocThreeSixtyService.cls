public with sharing class ACET_DocThreeSixtyService 
{
    public static ACET_SAECalloutResult searchDocuments(String searchId, Boolean isMember)
    {
        ACET_SAECalloutResult returnRes = new ACET_SAECalloutResult();
        String typeName = isMember ? 'u_emp_id' : 'u_claim_fc';
        String reqBody = '{"indexName": "u_orsrec_rpt","criteria": {"filterClauses": [{'+
                            '"value": "' + searchId +'" ,' +
                            '"type": "equal",' +
                            '"name":"' + typeName + '"}]}}';

        try {
            ACET_WebserviceCalloutFramework wsCallOutFW = new ACET_WebserviceCalloutFramework();
            // wsCallOutFW.serviceName = 'PurgedORSIssues';
            wsCallOutFW.serviceName = 'LinkRelatedDocuments';
            wsCallOutFW.requestBody = reqBody;
            //get Response
            HttpResponse response = wsCallOutFW.getResponse();

            Integer statusCode = response.getStatusCode();
            String responseBody = response.getBody();

            if(statusCode == 200){
                returnRes.isSuccess = true; // US3177995 - Thanish - 22nd Jun 2021
                returnRes.statusCode = 200;
                PurgedWrapper pWrap = (PurgedWrapper) JSON.deserialize(responseBody, PurgedWrapper.class);
                returnRes.response = pWrap.totalRecords > 0 ? createReturnWrapper(pWrap) : new List<PurgedORS>();
            }else{
                returnRes.isSuccess = false;
                returnRes.statusCode = statusCode;
            }     
        } catch (Exception e) {
            System.debug(e.getStackTraceString());
            returnRes.isSuccess = false;
            returnRes.statusCode = 999;
        }  
        System.debug(JSON.serialize(returnRes));
        return returnRes;
    }

    private static List<PurgedORS> createReturnWrapper(PurgedWrapper pwrap){
        List<PurgedORS> returnList = new List<PurgedORS>();
        for(PurgedRecord pr : pwrap.recordsList){
            PurgedORS po = new PurgedORS();
            po.objectId = pr.objectId;
            po.idType = 'Purged ORS';
            for(PurgedAttribute pa : pr.attributes){
                if(pa.labelName.equals('u_orig_creation_date')){
                    // String dte = pa.value.length() > 10 ? pa.value.substring(0,9) : '';
                    // po.dateTimeVal = !String.isEmpty(dte) ? SAEUtils.formatDate(dte) : '';
                    po.dateTimeVal = setDateTime(pa.value); // US3177995 - Thanish - 22nd Jun 2021
                }
                if(pa.labelName.equals('u_issue_id_nbr')){
                    po.externalId = pa.value;
                }
                if(pa.labelName.equals('u_claim_fc')){
                    po.claimNo = pa.value;
                }
            }
            returnList.add(po);
        }
        return returnList;
    }

    private static String setDateTime(String dte){
        String dteMod = dte.length() > 10 ? dte.substring(0,9) : '';
        return !String.isEmpty(dteMod) ? SAEUtils.formatDate(dteMod) : '';
    }

    public static ACET_SAECalloutResult getContent(String attchmentId)
    {
        // 
        ACET_SAECalloutResult returnRes = new ACET_SAECalloutResult();
        try {
            Map < String, String > requestParamsMap = new Map < String, String > ();
            requestParamsMap.put('type-name', 'u_orsrec_rpt');
            ACET_WebserviceCalloutFramework wsCallOutFW = new ACET_WebserviceCalloutFramework();
            wsCallOutFW.serviceName = 'PurgedORSGetContent';
            wsCalloutFW.endpointExtraPath = EncodingUtil.urlEncode(attchmentId, 'UTF-8');
            wsCallOutFW.requestParamsMap = requestParamsMap;
            //get Response
            HttpResponse response = wsCallOutFW.getResponse();

            Integer statusCode = response.getStatusCode();
            String responseBody = response.getBody();

            if(statusCode == 200){
                returnRes.isSuccess = true;
                returnRes.statusCode = 200;
                returnRes.response = responseBody.replaceAll('\r\n', '<br/>');
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

    // ----------- Wrappers ------------ //

    // Get Purged ORS Wrapper List
    public class PurgedWrapper
    {
        public boolean moreRecordsLeft;
        public Integer startRow;
        public Integer totalRecords;
        public List<PurgedRecord> recordsList;
    }

    public class PurgedRecord
    {
        public String objectId;
        public String contentType;
        public List<PurgedAttribute> attributes;
    }

    public class PurgedAttribute
    {
        public String labelName;
        public String value;
    }


    //Purged ORS Requrn Objects
    public class PurgedORS
    {
        @AuraEnabled public String objectId;    
        @AuraEnabled public String dateTimeVal;
        @AuraEnabled public String idType;
        @AuraEnabled public String externalId;
        @AuraEnabled public String claimNo;    
    }
}