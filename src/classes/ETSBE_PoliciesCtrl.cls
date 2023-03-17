public class ETSBE_PoliciesCtrl {

    @AuraEnabled
    public static Map<String, Object> getMemberPolicyNetworkInfo(String transactionId){
        Map<String, Object> response = new Map<String, Object>();
        String endPoint = 'https://api-gateway-stage.linkhealth.com/elink-extended/api/networkStatus/v3.0';

        String requestParameters = '?transactionId=' + EncodingUtil.urlEncode(transactionId, 'UTF-8'); //DE282083 - 05/12/2019 - Sarma
        HttpResponse httpResponse = SAEWebservice.makeCallout(requestParameters, endPoint, 'GET');
        //below lines Added by Vinay for Error Messages

        // US1964371: Error Code Handling - Extended Coverage Attribute Service - KAVINDA
        String faultCode = '';
        Integer statusCode = httpResponse.getStatusCode();
        String statusMessage = '';
        Map<String, Object> httpResponseJSON;

        response.put('statusCode', statusCode);
        httpResponseJSON = (Map<String, Object>) JSON.deserializeUntyped(httpResponse.getBody());

        if(statusCode == 200){
            Map<String, Object> attributes = (Map<String, Object>)httpResponseJSON.get('attributes');
            response.put('success', true);
            response.put('networkStatus', attributes.get('networkStatus'));
        }

        faultCode = (String)httpResponseJSON.get('faultCode');

        // US1964371: Error Code Handling - Extended Coverage Attribute Service - KAVINDA: START
        if(statusCode == 500) {
            if (faultCode != null && faultCode.containsIgnoreCase('ED270SE')) {
                statusMessage = getErrorMessage('ED270SE');
            }
            if (faultCode != null && faultCode.containsIgnoreCase('ED270UE')) {
                statusMessage = getErrorMessage('ED270UE');
            }
            if (faultCode != null && faultCode.containsIgnoreCase('AEFNEE')) {
                statusMessage = getErrorMessage('AEFNEE');
            }
        }
        else if(statusCode == 404) {
            if (faultCode != null && faultCode.containsIgnoreCase('AEFNND')) {
                statusMessage = getErrorMessage('AEFNND');
            }
        }
        else if(statusCode == 422) {
            if (faultCode != null && faultCode.containsIgnoreCase('ED270NP')) {
                statusMessage = getErrorMessage('ED270NP');
            }
        }
        else if(statusCode == 400) {
            if (faultCode != null && faultCode.containsIgnoreCase('ED270UG')) {
                statusMessage = getErrorMessage('ED270UG');
            }
            if (faultCode != null && faultCode.containsIgnoreCase('AAA:Fault Code')) {
                statusMessage = (String)httpResponseJSON.get('message'); /** getErrorMessage('AAAFaultCode'); **/
            }
            if (faultCode != null && faultCode.containsIgnoreCase('ED270IP')) {
                statusMessage = (String)httpResponseJSON.get('message'); /** getErrorMessage('ED270IP'); **/
            }
            if (faultCode != null && faultCode.containsIgnoreCase('ED270BP')) {
                statusMessage = (String)httpResponseJSON.get('message'); /** getErrorMessage('ED270BP'); **/
            }
            if (faultCode != null && faultCode.containsIgnoreCase('ED270BR')) {
                statusMessage = getErrorMessage('ED270BR');
            }
        }
        else if(statusCode == 424) {
            if (faultCode != null && faultCode.containsIgnoreCase('ED270UR')) {
                statusMessage = getErrorMessage('ED270UR');
            }
            if (faultCode != null && faultCode.containsIgnoreCase('AAA:42')) {
                statusMessage = getErrorMessage('AAA42');
            }
        }
        else if(statusCode == 406) {
            if (faultCode != null && faultCode.containsIgnoreCase('ED270IA')) {
                statusMessage = (String)httpResponseJSON.get('message'); /** getErrorMessage('ED270IA'); **/
            }
        }
        // US1964371: Error Code Handling - Extended Coverage Attribute Service - KAVINDA: END
        else{
            response.put('success', false);
            response.put('', httpResponse.getStatus());
        }

        // US1964371: Error Code Handling - Extended Coverage Attribute Service - KAVINDA
        if (statusCode <> 200 && statusMessage.length() > 0){
            response.put('', httpResponse.getStatus());
            response.put('faultCode', faultCode);
            response.put('statusCode', statusCode);
            response.put('statusMessage', statusMessage);
        }

        return response;
    }

            /**
        @Desc: US1761826 - UHC/Optum Exclusion UI
        @Date: 18-07-2019
        @Dev: Malinda
        **/

    @AuraEnabled
    public static List<UHG_Restricted_Plans__mdt> getOptumExlusions() {
        List<UHG_Restricted_Plans__mdt> mapOptumExlusions = new List<UHG_Restricted_Plans__mdt>();
        try {
            mapOptumExlusions = [SELECT DeveloperName,MasterLabel FROM UHG_Restricted_Plans__mdt];

        } catch(Exception e) {
            System.debug(LoggingLevel.ERROR,e.getMessage());
        }
        return mapOptumExlusions;
    }

    /**
    @Desc: US1852201 - TTS Modal Case Creation
    @Date: 25-07-2019
    @Dev: Malinda
    **/
    @AuraEnabled
    public static list<String> getTTSFilterMapKeyStr(string callTopic){

        list<string> keylist = new list<string>();
        for(string str:ACETCallTopicsPicklistUtility.getTTSFilterMap(callTopic).keyset()){
            keylist.add(str);
        }
        return keylist;
    }

    /**
    @Desc: US1852201 - TTS Modal Case Creation
    @Date: 25-07-2019
    @Dev: Malinda
    **/
    @AuraEnabled
    public static List<String> getTTSFilterMapValueStr(string callTopic, string keystr){

        string caseSubtype = ACETCallTopicsPicklistUtility.getTTSFilterMap(callTopic).get(keystr);
        List<string> caseSubtypes = caseSubtype.split(';');
        return caseSubtypes;
    }

    //US1974546 - Coverage Level Integration
    //Sanka Dharmasena - 28/08/2019
    @AuraEnabled
    public static ETSBE_PolicyDetailsResults.ProviderCoverageLevel getCoverageLevel(String transactionId)
    {
        return ETSBE_ExtendedCoverageWS.getCoverageLevel(transactionId);
    }

    // US1964371: Error Code Handling - Extended Coverage Attribute Service
    // Kavinda Inusha - 29.11.2019
    // Get ACET Error messages from metadata records
    public static String getErrorMessage(String errorCode){
        String errorMessage = '';
        AcetErrorMessage__mdt[] ErrorCodes = [ SELECT DeveloperName, Label, Error_Message__c, Message_Type__c
        FROM AcetErrorMessage__mdt WHERE DeveloperName = :errorCode ];
        if(ErrorCodes.size() > 0) {
            errorMessage = ErrorCodes[0].Error_Message__c;
        }
        return errorMessage;
    }

}