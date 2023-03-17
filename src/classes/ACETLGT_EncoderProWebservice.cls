/**
 * @name         :  ACETEncoderProUtility
 * @description  :  Helper for EncoderPro Webservice.
 * @author       :  Bhanu Jain
 * @createddate  :  14/11/2017
 * moved in to lightning 4/26/2020 by Jacob Wagoner
 **/

public with sharing class ACETLGT_EncoderProWebservice extends ACETWebService {
    
    /**
     * @name         :   getEndpoint
     * @description  :   will set endpoint and resource url for encoder pro service
     * @param        :   
     * @return       :   void
     * @author       :  Bhanu Jain
     * @createddate  :  14/11/2017
     * @lastmodifiedby:  
     **/    
    public override void getEndpoint(){ 
        RelativeUrl = '/ws/batch';
        BaseUrl = Label.ACETEncoderProURL;

    }
    
     protected override virtual void GetHeaders(ISL_Webservice_Config__c OAuthConfig) {
        if (OAuthConfig == null)    {
            if (WSConfigurations.containsKey('ISLOAuthContentType'))    {
                Headers.put('Content-Type', Label.ACET_EncoderPro_Content_Type);
            }
        }
        else    {
            if (WSConfigurations.containsKey('OILHttpHeaderAccept'))    {
                Headers.put('Content-Type', WSConfigurations.get('OILHttpHeaderAccept').Value__c);
                Headers.put('accept', WSConfigurations.get('OILHttpHeaderAccept').Value__c);
            }
            Headers.put('timestamp', String.valueOf(system.now().millisecond()));
            if (WSConfigurations.containsKey('OILHttpHeaderScope')) {
                Headers.put('scope', WSConfigurations.get('OILHttpHeaderScope').Value__c);
                if (ScopeHeaderEnabled) {
                    String ScopeAgentType = ACETUtility.getAgentTypeById(UserInfo.getUserID());
                    if (String.isNotBlank(ScopeAgentType)) {
                        if (ScopeAgentType == 'Onshore') {
                            Headers.put('scope', 'ace');
                        }
                        else {
                            Headers.put('scope', 'off');
                        }
                    }
                }
            }
            if (WSConfigurations.containsKey('OILHttpHeaderActor')) {
                Headers.put('actor', WSConfigurations.get('OILHttpHeaderActor').Value__c);
            }
            if (WSConfigurations.containsKey('SNIEligibilityAPIContentType')) {
                Headers.put('Content-Type', WSConfigurations.get('SNIEligibilityAPIContentType').Value__c);
            }
            Headers.put('authorization', 'Bearer ' + OAuthConfig.Value__c);
        }
    }

    /**
     * @name         :   getBatchRequestBody
     * @description  :   will generate batch request for encoder pro service using codetypes, codes and desc type
     * @param        :   Map<String,List<String>> codeVsCodeTypesMap, String descType
     * @return       :   void
     * @author       :  Bhanu Jain
     * @createddate  :  14/11/2017
     * @lastmodifiedby:  
     **/    
    public void getBatchRequestBody(Map<String,List<String>> codeVsCodeTypesMap, String descType){
        RequestBody = '<batch>';
        
        for(String code : codeVsCodeTypesMap.keySet()){
            for(String codeType : codeVsCodeTypesMap.get(code)){
                String requestId = codeType+'_'+code;
                RequestBody = RequestBody + '<request-url request-id="'+requestId+'">/codetype/'+codeType+'/'+code+'/properties?data='+descType+'</request-url>';
            }
        }
        RequestBody = RequestBody + '</batch>';
    }
    
    
    public ACETWSCalloutResult getCodeDescriptions(List<String> codeList){
        ACETWSCalloutResult descResult = new ACETWSCalloutResult();
        //prepare map of code vs list of description
         Map<String,Set<String>> codeDescriptionMap =  prepareResultMap(codeList);
        try{
            getEndpoint();
            getBatchRequestBody(ACETEncoderProUtility.getCodeTypes(codeList), ACETEncoderProUtility.getCodeDescriptionType());
            Headers.put('Accept', 'application/json');
            Headers.put('Authorization','Basic '+ACETEncoderProUtility.getBasicAuthenticationBase64());
           HttpResponse response = send(null);
            system.debug(LoggingLevel.Info,'response >> '+ response);
            if(response.getStatusCode() == 200){
                String responseBody = response.getBody();
                if(!String.isEmpty(responseBody)){
                    responseBody = responseBody.replace('desc-full','description');
                    responseBody = responseBody.replace('"{','{');
                    responseBody = responseBody.replace('}"','}');
                    responseBody = responseBody.replace('\\"','"');
                    responseBody = responseBody.replace('#text','text');
                    responseBody = responseBody.replace('batch-responses','batchResponses');
                    responseBody = responseBody.replace('request-id','requestId');
                    responseBody = responseBody.replace('status-code','statusCode');
                    system.debug(responseBody);                    
                    responseBody = responseBody.replace('"text":""','"text":{"description":""}');
                     //Code Added By Chandan for the fix
                    responseBody=  responseBody.replace('"text" : "<UL><LI>Errors<UL><LI>The requested resource does not exist.</LI></UL></LI><LI>Warnings<UL></UL></LI><LI>Info<UL></UL></LI></UL>"','"text" : {  "description" : "Encoder Pro not available."}');
                    responseBody = responseBody.replace('descFull','description');                    
                    responseBody= responseBody.unescapeEcmaScript();
                    //Code End By Chandan for the fix
                    system.debug(responseBody);
                    Map<String,Integer> codeResponseMap =  prepareEpResponseMap(codeList);//Code Added By Chandan- US851940
                    ACETEncoderProCodeDetails json2Apex = (ACETEncoderProCodeDetails)JSON.deserialize(responseBody,ACETEncoderProCodeDetails.class);
                    system.debug('ACETEncoderProCodeDetails >> '+JSON.serialize(json2Apex));
                    
                    
                    List<ACETEncoderProCodeDetails.CLSresponse> resultList = new List<ACETEncoderProCodeDetails.CLSresponse>(); 
                    for(ACETEncoderProCodeDetails.CLSresponse epResponse : json2Apex.batchResponses.response){
                        String code = epResponse.requestId.split('_')[1];
                        if(!codeResponseMap.containsKey(code)){//Code Added By Chandan - US851940
                             codeResponseMap.put(code, epResponse.statusCode); //Code Added By Chandan - US851940
                        }
                        if(!codeDescriptionMap.containsKey(code)){
                            codeDescriptionMap.put(code, new Set<String>());
                        }
                        
                       if(epResponse.statusCode == 200){
                        codeDescriptionMap.get(code).add(epResponse.text.description);
                        codeResponseMap.put(code, epResponse.statusCode);//Code added by Chandan - US851940
                       }//codeDescriptionMap.get(code).add('Encoder Pro not available.');
                        if(epResponse.statusCode == 200){
                            resultList.add(epResponse);
                        }
                    }
                    for(String code : codeDescriptionMap.keySet() ){
                        if(codeDescriptionMap.get(code).isEmpty()){
                            //Code Added By Chandan -Begin - US851940
                            if(codeResponseMap.get(code) == 404){
                             codeDescriptionMap.get(code).add('Code Description not available.');
                            }
                            else if(codeResponseMap.get(code) == 0){
                             codeDescriptionMap.get(code).add('Code Description not available.');
                            }
                            else{
                             codeDescriptionMap.get(code).add('Encoder Pro not available.');
                            }
                            //Code Added By Chandan -End
                        }                        
                        
                    }
                    
                    descResult.Success = true;
                    descResult.Message = '';
                    //descResult.Response = resultList;                   
                    descResult.Response = codeDescriptionMap;
                }
            }else if(response.getStatusCode() == 500){
                //currently servce returns 500 if no records found
                descResult.MessageSeverity = ApexPages.Severity.INFO;
                descResult.Success = true;                
                descResult.Response = fillDescriptionForError(codeDescriptionMap);
                system.debug(descResult);               
            }
        }catch(Exception e){
            system.debug(e);
            descResult.MessageSeverity = ApexPages.Severity.ERROR;
            descResult.Success = false;
            descResult.Message = 'Web Service or External System is temporarily unavailable.';
            descResult.Response = fillDescriptionForError(codeDescriptionMap);
        }
        return descResult;
    }
    //Code Added By Chandan - US851940 -Begin
    private Map<String,Integer> prepareEpResponseMap(List<String> codes){
        Map<String,Integer> codeVsDescListMap = new Map<String,Integer>();
        for(String code : codes){
            codeVsDescListMap.put(code , 0);
        }
        return codeVsDescListMap;
    }
    //End
    private Map<String,Set<String>> prepareResultMap(List<String> codes){
        Map<String,Set<String>> codeVsDescListMap = new Map<String,Set<String>>();
        for(String code : codes){
            codeVsDescListMap.put(code , new Set<String>());
        }
        return codeVsDescListMap;
    }
    private Map<String,Set<String>> fillDescriptionForError(Map<String,Set<String>> codeVsDescListMap){
        for(String code : codeVsDescListMap.keySet()){
            codeVsDescListMap.get(code).add('Encoder Pro not available.');
        }
        return codeVsDescListMap;
    }
    
}