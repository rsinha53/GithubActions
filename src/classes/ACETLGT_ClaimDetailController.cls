public class ACETLGT_ClaimDetailController{
    @AuraEnabled public ACETWSCalloutResult result {get;set;}
     public  class DatatableWrapper{
           @Auraenabled
            public string responce;
           @Auraenabled 
             public string wrapperdetails;
            public DatatableWrapper(String responce){
                this.responce = responce;        
            }       
        }
        public  class resultsWrapper{
           @Auraenabled
            public string responce;
           @Auraenabled 
             public string baseurl;
        }    
    @AuraEnabled
    public static resultsWrapper getProfClaimDetail(string claim_Type, string claim_ID){
        ACETgetProfessionalWebservice ws = new ACETgetProfessionalWebservice();
        ACETWSCalloutResult result = new ACETWSCalloutResult();
        result =  ws.GetProfessionalClaimsWS(claim_Type,claim_ID); 
        resultsWrapper rw = new resultsWrapper();
        rw.responce = JSON.serialize(result);
        rw.baseurl = URL.getSalesforceBaseUrl().toExternalForm() + '/';
        return rw;
    }
    
    @AuraEnabled
    public static resultsWrapper getInstClaimDetail(string claim_Type, string claim_ID){
        ACETgetInstitutionalWebservice ws = new ACETgetInstitutionalWebservice();
        ACETWSCalloutResult result = new ACETWSCalloutResult();
        result =  ws.GetInstitutionalClaimsWS(claim_Type,claim_ID); 
          resultsWrapper rw = new resultsWrapper();
        rw.responce = JSON.serialize(result);
        rw.baseurl = URL.getSalesforceBaseUrl().toExternalForm();
        return rw;
    }
    
    @AuraEnabled
    public static string queryClaimPayment(string claim_ID){
        //ACETFindClaimPaymentWebService service = new ACETFindClaimPaymentWebService(); -commented by gayatri
        ACETLGT_FindClaimPaymentWebService  service = new ACETLGT_FindClaimPaymentWebService();
        ACETWSCalloutResult result = new ACETWSCalloutResult();
        result =  service.getClaimPayments(claim_ID);
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
    public static string queryCheckStatus(String checkSeriesDesignator, String checkEFTNumber){       
        ACETGetCheckStatusWebService service = new ACETGetCheckStatusWebService();
        ACETWSCalloutResult result = new ACETWSCalloutResult();
        result =  service.getCheckStatus(checkSeriesDesignator,checkEFTNumber);        
        return JSON.serialize(result);
    }
    
    @AuraEnabled
    public static string getCheckImageUrl(String  SeriesDesignator, String CheckEFTNumber)
    {
        User usr = [select FederationIdentifier from user where id=:userinfo.getUserId()];
        String baseURL = String.valueof(URL.getSalesforceBaseUrl().toExternalForm());
        system.debug('baseURL '+baseURL);
        String orginstance ;
        String CheckImageUrl;
        for(ACETOrgInstanceURLToOrgNameMap__c orgname:ACETOrgInstanceURLToOrgNameMap__c.getAll().values()) {
            system.debug('tname '+orgname.name);
            if(baseURL.toLowerCase().contains(orgname.Name)) {
                system.debug('tname '+orgname.name);
                orginstance = ACETOrgInstanceURLToOrgNameMap__c.getValues(orgname.name).Org_Name__c;
            }
        }
        if(orginstance != null){
            system.debug('orginstance is '+orginstance);
            ACETOrgNameToSwivelEndpointMap__c wrapURL = ACETOrgNameToSwivelEndpointMap__c.getValues(orginstance+'_IDRS');
            // US2564113 Start
            ISL_Webservice_Config__c appName =  ISL_Webservice_Config__c.getValues(orginstance+'_doc360Appname');
            string doc360Appname ;
            doc360Appname = appName.value__c;
            system.debug('wrapURL is '+wrapURL);
            CheckImageUrl = wrapURL.Swivel_Endpoint__c;
          //  SeriesDesignator ='SY';
          // CheckEFTNumber='10509822';
          	if(doc360Appname != null && doc360Appname != ''){
                    String strparams = 'appId='+doc360Appname+'&user='+usr.FederationIdentifier+'&datagroup=trsy&screen=4'+'&key0='+SeriesDesignator+'&key1='+CheckEFTNumber;
                    system.debug('before encoding '+strparams);
                    blob params = blob.valueOf(strparams);
                    String base64params = EncodingUtil.base64Encode(params);
                    CheckImageUrl+= base64params;
                    system.debug('CheckImageUrl is '+CheckImageUrl);
             }
            //US2564113 End
        }
        return CheckImageUrl;
                

    }
    
    @AuraEnabled
    public static DatatableWrapper initClaimDocDatatable(String docType, String memberId, String claimId){
       // ACETFindDocWebservice findDocService = new ACETFindDocWebservice();-Commented and replaced with ACETLGT_FindDocWebservice
        ACETLGT_FindDocWebservice findDocService = new ACETLGT_FindDocWebservice();
        List<ACETLGT_FindDocWebservice.documentKey> findDocKeys = new List<ACETLGT_FindDocWebservice.documentKey>();
        
        if(!String.isEmpty(memberId)){
            ACETLGT_FindDocWebservice.documentKey memberIdKey = new ACETLGT_FindDocWebservice.documentKey();
            memberIdKey.value = memberId;
            memberIdKey.name = (docType=='u_optum_physical_health_ltr')?'u_id_crd_srl_nbr':'u_mbr_id'; // Updated doc class for Physical Health letter by Abhinav
            memberIdKey.dataTypeIndicator = 'string';
            memberIdKey.operator = '=';
            findDocKeys.add(memberIdKey);
        }
        
        if(!String.isEmpty(claimId)){
            ACETLGT_FindDocWebservice.documentKey claimIdKey = new ACETLGT_FindDocWebservice.documentKey();
            claimIdKey.value = claimId;
            claimIdKey.name = (docType=='u_oxf_pra' || docType=='u_oxf_med_eob')?'u_claim_nbr':'u_clm_nbr'; // Updated doc class for Provider RA and Member EOB by Abhinav
            claimIdKey.dataTypeIndicator = 'string';
            claimIdKey.operator = '=';
            findDocKeys.add(claimIdKey);
        }
                
        //change operator to = ANY for WS MultiValue Field
        List<Document_Type_Search_By_Field__mdt> listSearchByFields = [SELECT Document_Type__r.WS_Field_Name__c, WS_MultiValue_Field__c, Document_Type_Field__r.WS_Field_Name__c FROM Document_Type_Search_By_Field__mdt where WS_MultiValue_Field__c=TRUE];
        for(Document_Type_Search_By_Field__mdt sf : listSearchByFields){
            for(ACETLGT_FindDocWebservice.documentKey docKey : findDocKeys){
                if(docType == sf.Document_Type__r.WS_Field_Name__c && sf.Document_Type_Field__r.WS_Field_Name__c == docKey.name){
                    docKey.operator += ' ANY';
                }   
            }   
        }
        
        findDocService.init(docType, findDocKeys); 
        string  service = JSON.serialize(findDocService).replace('\'', '&#x27;');
        service = service.replace('&#x27;', '\'');
        return new DatatableWrapper(JSON.serialize(service));
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