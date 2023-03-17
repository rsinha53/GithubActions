public with sharing class ACET_WebServiceUtils {
    
    private static Map<String,WebserviceConfigurations__c> serviceWebConfigMap=new Map<String,WebserviceConfigurations__c>();
    
    public class ServiceMockResponse{
        public boolean isMockAVailable{get;set;}
        public HttpResponse mockResponse{get;set;}
        
    }
	public class Doc360Input{
        public String docClass{get;set;}
        public Map<String,String> requestMap{get;set;}
        
    }
    
    public static Map<String,ServiceMockResponse> getMockResponse(List<ACET_CountinousCallout.ServiceCallout> serviceCalloutList){
        
        String orgName = Organization_Properties__c.getOrgDefaults().OrganizationName__c;
        Map<String,ACET_CountinousCallout.ServiceCallout> serviceCalloutMap=new Map<String,ACET_CountinousCallout.ServiceCallout>();
        Map<String,ServiceMockResponse> output=new Map<String,ServiceMockResponse>();
        List<String> serviceList=new List<String>();
        try {      
            for (ACET_CountinousCallout.ServiceCallout each:serviceCalloutList)  {
                serviceList.add(each.docClass);
                serviceCalloutMap.put(each.docClass, each);
            }   
            List<WebserviceConfigurations__c>  wsConfigList = [SELECT Id, Name, AuthorizationToken__c, EndpointPath__c, Headers__c, JSONBodyWithMergeFields__c, Method__c, Timeout__c, E400__c, E401__c, E500__c, TokenAPI__r.Name, TokenAPI__r.IsCachedToken__c,
                                                               Handle_Unauthorized__c,
                                                               (SELECT EnableLogs__c, EnableMock__c, EnableMockForProfiles__c, EndpointDomain__c, ErrorReportingEmailIds__c, SendEmailOnError__c FROM OrgSpecificConfigurations__r WHERE Name =: orgName LIMIT 1)
                                                               FROM WebserviceConfigurations__c WHERE Name =:serviceCalloutList[0].serviceName   LIMIT 3];
            
            HttpResponse response;
            for(String each:serviceList){
                OrgSpecificConfigurations__c orgSpecificConfigs = wsConfigList[0].OrgSpecificConfigurations__r;
                if (orgSpecificConfigs.EnableMock__c && !(Organization_Properties__c.getInstance(UserInfo.getProfileId()).OverrideEnableMock__c || Organization_Properties__c.getInstance(UserInfo.getUserId()).OverrideEnableMock__c)) {
                    if (String.isNotBlank(orgSpecificConfigs.EnableMockForProfiles__c)) {
                        String userProfileName = [SELECT Name FROM Profile WHERE Id =: UserInfo.getProfileId() LIMIT 1].Name;
                        if (orgSpecificConfigs.EnableMockForProfiles__c.split(',').contains(userProfileName)) {
                            response= ACET_WebserviceMockFramework.getMockResponse('LinkRelatedDocuments', serviceCalloutMap.get(each).requestParamsMap, serviceCalloutMap.get(each).requestBody, wsConfigList[0].getPopulatedFieldsAsMap());
                        }
                    } else {
                        response= ACET_WebserviceMockFramework.getMockResponse('LinkRelatedDocuments', serviceCalloutMap.get(each).requestParamsMap, serviceCalloutMap.get(each).requestBody, wsConfigList[0].getPopulatedFieldsAsMap());
                    }
                    if(response!=null){
                        ServiceMockResponse temp=new ServiceMockResponse();
                        temp.isMockAVailable=true;
                        temp.mockResponse=response;
                        output.put(each, temp);
                    }
                }
            }
        } catch (Exception e) {
            //  Do something
        } 
        return output;
    }
    
    public Static String createJsonRequestBoby(string indexName,string docInputs){
        List<string> docLst = new List<string>();
        docLst.add('u_prov_attch');docLst.add('u_clm_corsp_lwso_doc');docLst.add('u_keyed_claim');docLst.add('u_edi_claim');docLst.add('u_eps_prov_eob');
        docLst.add('u_unet_gflx_eob');docLst.add('u_cosmos_pra');docLst.add('u_cosmos_pra_ub');docLst.add('u_cos_clmltr_mem_doc');docLst.add('u_cos_clmltr_prov_doc');
        docLst.add('u_mli_elgs');docLst.add('u_nasc_salsa_ltr');docLst.add('u_ovat_mapd_ltr');docLst.add('u_mber_eob');docLst.add('u_cosmos_eob');docLst.add('u_cosmos_eob_ub');docLst.add('u_mr_partc_eob');
        if(String.isNotEmpty(indexName)){
            if(docLst.contains(indexName))
                return new ACET_ClaimRelatedDocumentWS().getAttachmentsRequestBody(indexName,docInputs);
        }
        return '';
    }
    public Static List<ACET_ClaimRelatedDocumentController.AttachmentsResponseData> transformResponse(String serviceName,Object response){
        ACET_ClaimRelatedDocument_JSON2Apex result=(ACET_ClaimRelatedDocument_JSON2Apex)JSON.deserialize((String)response, ACET_ClaimRelatedDocument_JSON2Apex.class);
        List<string> imgLst = new List<string>();
        imgLst.add('u_clm_corsp_lwso_doc');imgLst.add('u_keyed_claim');imgLst.add('u_edi_claim');
        List<string> prLST = new List<string>();
        prLST.add('u_eps_prov_eob');prLST.add('u_unet_gflx_eob');prLST.add('u_cosmos_pra');prLST.add('u_cosmos_pra_ub');
        List<string> clLST = new List<string>();
        clLST.add('u_cos_clmltr_mem_doc');clLST.add('u_cos_clmltr_prov_doc');clLST.add('u_ovat_mapd_ltr');clLST.add('u_mli_elgs');clLST.add('u_nasc_salsa_ltr');
        List<string> meLST = new List<string>();
        meLST.add('u_mber_eob');meLST.add('u_cosmos_eob');meLST.add('u_cosmos_eob_ub');meLST.add('u_mr_partc_eob');
        if(String.isNotEmpty(serviceName)){
            if(imgLst.contains(serviceName))
            {
                return ACET_ClaimRelatedDocumentController.getClaimsImages(result,serviceName);
            }else if(prLST.contains(serviceName))
            {
                return ACET_ClaimRelatedDocumentController.getProviderRemittanceInfo(result,serviceName);
            }else if(clLST.contains(serviceName))
            {
                return ACET_ClaimRelatedDocumentController.getClaimLettersInfo(result,serviceName);
            }else if(meLST.contains(serviceName))
            {
                return ACET_ClaimRelatedDocumentController.getMemberEOBInfo(result,serviceName);
            }
            else if(serviceName.equalsIgnoreCase('u_prov_attch'))
            {
                return ACET_ClaimRelatedDocumentController.getAttachmentInfo(result,serviceName);
            }
        }
        return new List<ACET_ClaimRelatedDocumentController.AttachmentsResponseData>();
    }
	public static String generateDoc360URL(String input){
        string url='';
        String orgName = Organization_Properties__c.getOrgDefaults().OrganizationName__c;
        WebserviceConfigurations__c wsConfig = [SELECT Id, Name,                      
                (SELECT EndpointDomain__c,Static_Data__c,EnableMock__c FROM OrgSpecificConfigurations__r WHERE Name =: orgName LIMIT 1)
                FROM WebserviceConfigurations__c WHERE Name ='DOC360GLobalURL' LIMIT 1];
       OrgSpecificConfigurations__c orgSpecificConfigs = wsConfig.OrgSpecificConfigurations__r;
        Map<String,String> orgStaticMap=(Map<String,String>)JSON.deserialize(orgSpecificConfigs.Static_Data__c, Map<String,String>.class);
        system.debug('input >>'+input);
        ACET_ClaimRelatedDocumentController.AttachmentsResponseData doc360Input=(ACET_ClaimRelatedDocumentController.AttachmentsResponseData)JSON.deserializeStrict(input,ACET_ClaimRelatedDocumentController.AttachmentsResponseData.class);
        Map<String,String> feildMap=doc360Input.feildMap;
        
        system.debug('feildMap >>'+feildMap);
        String docClass='';
        if(feildMap.containsKey('docClass'))
        docClass=feildMap.get('docClass');
        Doctype_Doc_Class__mdt docClass1=[SELECT Label,Document_Type__c, Doc_Class_Abbr__c, Id,(Select id,Document_Type_Field__r.WS_Field_Name__c,Document_Type_Field__r.DeveloperName from Document_Type_DocClass_Search_By_Fields__r) FROM Doctype_Doc_Class__mdt where Label=:docClass];
        List<String> keyList=new List<String>();
        for(Document_Type_Search_By_Field__mdt each:docClass1.Document_Type_DocClass_Search_By_Fields__r){
            if(feildMap.containsKey(each.Document_Type_Field__r.DeveloperName))
            keyList.add(each.Document_Type_Field__r.WS_Field_Name__c+'='+feildMap.get(each.Document_Type_Field__r.DeveloperName));
        }
        String keys=keyList.size()>0?String.join(keyList,'&'):'';
        String needToBeencoded='appId='+orgStaticMap.get('appId')+'&app_user_id='+orgStaticMap.get('app_user_id')+'&user='+orgStaticMap.get('user')+'&datagroup='+docClass1.Doc_Class_Abbr__c+'&screen=3&'+keys;
        system.debug('needToBeencoded>>>'+needToBeencoded);
        Blob beforeblob = Blob.valueOf(needToBeencoded);
        if(!orgSpecificConfigs.EnableMock__c)
        url=orgSpecificConfigs.EndpointDomain__c+'?'+EncodingUtil.base64Encode(beforeblob);
        else{
            //Include code for mock data
           url='';
         
        }
        system.debug('url>>'+url);
        return url;
        
    }

    public static String ReplaceKeywords(String ResponsBody) {         
        Integer StringMaxLimit = 100000;
        
        if(ResponsBody!=null && ResponsBody.length() < StringMaxLimit){
            //If Response Body Length is less than 1M characters replace all the keywords
            return ResponsBody.replaceAll('"desc"','"descr"').
                replaceAll('"date"','"dte"')
                .replaceAll('"dateTime"','"dteTime"')
                .replaceAll('"number"','"numbr"')
                .replaceAll('"type"','"eType"')
                .replaceAll('"object"','"Object_Z"');
        }
        
        else if(ResponsBody != null){
            
            /*If Response Body Length is more than 1M characters, replaceAll throws "Regex too complicated" exception 
             * reported in PGA 1727 or 	DE362641 , so ReponseBody will be split into Strings of 1M characters each 
             * and scenarios when keyword is divided between the parts must be handled*/
            
            String regex = ResponsBody;
            List<String> parts = new List<String>();
            Integer partsCount = Integer.valueOf(regex.length()/StringMaxLimit);
            
            //Dividing into parts of 1M each
            for(Integer i=0;i<partsCount;i++){
                if(i<partsCount-1){  
                    parts.add(regex.substring(i*StringMaxLimit,(i+1)*StringMaxLimit));
                }
                else{
                    parts.add(regex.substring(i*StringMaxLimit,regex.length()));  
                }
            }
            
            //Variable returned by this method
            String updatedString = '';
            
            //Replacing the strings in each part and concatenating to single String
            for(Integer i=0;i<parts.size();i++){
                
                
                //If the parts[i] is not last part there chance the keyword divided in this part parts[i] and next parts[i+1]
                if(i<partsCount-1){
                    
                    /*if keyword is divided, 
                    * ex: '"desc"' divided as  parts[i]='abc...."des' & parts[i+1]='c"...xyz' 
                    * then removing the divided combination from end of parts[i] and start of parts[i+1]*/
                    
                    /*Below variable will hold the updated part and replaced String
					*  if keyword is divided in parts */
                    List<String> updatedParts = new List<String>();
                    
                    //isReplacingStringDividedBetweenParts boolean below is true if any keyword is divided between parts                    
                    Boolean isReplacingStringDividedBetweenParts = 
                        replaceDividedString(parts[i],parts[i+1],updatedParts,'"desc"','"descr"');
                    
                    isReplacingStringDividedBetweenParts = isReplacingStringDividedBetweenParts
                        || replaceDividedString(parts[i],parts[i+1],updatedParts,'"date"','"dte"');
                    
                    isReplacingStringDividedBetweenParts = isReplacingStringDividedBetweenParts 
                        || replaceDividedString(parts[i],parts[i+1],updatedParts,'"type"','"eType"');
                    
                    isReplacingStringDividedBetweenParts = isReplacingStringDividedBetweenParts
                        || replaceDividedString(parts[i],parts[i+1],updatedParts,'"number"','"numbr"');
                    
                    isReplacingStringDividedBetweenParts = isReplacingStringDividedBetweenParts
                        || replaceDividedString(parts[i],parts[i+1],updatedParts,'"object"','"Object_Z"');
                    
                    isReplacingStringDividedBetweenParts = isReplacingStringDividedBetweenParts 
                        || replaceDividedString(parts[i],parts[i+1],updatedParts,'"dateTime"','"dteTime"');
                    
                    /*If keyword divided between parts then remove the divided string
					*  in parts[i] and parts[i+1] as returned from replaceDividedString method */		
                    
                    if(isReplacingStringDividedBetweenParts){
                        parts[i] = updatedParts[0];
                        parts[i+1] = updatedParts[1];
                    } 
                    
                    //Replacing keyword occurences in between of parts[i] and appending to updatedString
                    updatedString +=
                        parts[i].replaceAll('"desc"','"descr"')
                        .replaceAll('"date"','"dte"')
                        .replaceAll('"dateTime"','"dteTime"')
                        .replaceAll('"number"','"numbr"')
                        .replaceAll('"type"','"eType"') 
                        .replaceAll('"object"','"Object_Z"');
                    
                    
                    /*If keyword was divided then append replaced String to updatedString 
					* respective replaced Sting updatedParts[2] is returned from replaceDividedString method */
                    
                    if(isReplacingStringDividedBetweenParts){
                        updatedString += updatedParts[2];
                    }
                }
                else{
                    updatedString += 
                        parts[i].replaceAll('"desc"','"descr"')
                        .replaceAll('"date"','"dte"')
                        .replaceAll('"dateTime"','"dteTime"')
                        .replaceAll('"number"','"numbr"')
                        .replaceAll('"type"','"eType"')
                        .replaceAll('"object"','"Object_Z"');
                }
            }
            return updatedString;
        }
        return null;
    }
    
    public static Boolean replaceDividedString(String firstPart,String secondPart,List<String> updatedParts,String keyword,String replacedString)
    {
        if(firstPart.length() > keyword.length() && secondPart.length() > keyword.length()){
            String shortStr = firstPart.substring(firstPart.length()-keyword.length(),firstPart.length());
            shortStr += secondPart.substring(0,keyword.length());
            if(!shortStr.contains(keyword)){
                return false;
            }
        }
        
        /* Keyword character wise comparison, (done by splitting the keyword into 
         * character increments and residual characters) to confirm the index at which the keyword 
         * is divided between firstPart and secondPart to remove the divided parts in firstPart and secondPart */
        
        for(integer i=0;i<keyword.length()-1;i++){
            String part1 = keyword.substring(0,i+1);
            String part2 = keyword.substring(i+1,keyword.length());
            if(firstPart.endsWith(part1) && secondPart.startsWith(part2)){
                updatedParts.add(firstPart.removeEnd(part1));
                updatedParts.add(secondPart.removeStart(part2));
                updatedParts.add(replacedString);
                return true;
            }
        }
        return false;
    }
}