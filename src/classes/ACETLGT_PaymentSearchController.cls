public class ACETLGT_PaymentSearchController {
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
           
	@AuraEnabled
    public static string getProfClaimDetail(string claim_Type, string claim_ID){
        ACETLGT_getProfessionalWebservice ws = new ACETLGT_getProfessionalWebservice();
        ACETWSCalloutResult result = new ACETWSCalloutResult();
        result =  ws.GetProfessionalClaimsWS(claim_Type,claim_ID); 
        return JSON.serialize(result);
    }
    
    @AuraEnabled
    public static string getInstClaimDetail(string claim_Type, string claim_ID){
        ACETLGT_getInstitutionalWebservice ws = new ACETLGT_getInstitutionalWebservice();
        ACETWSCalloutResult result = new ACETWSCalloutResult();
        result =  ws.GetInstitutionalClaimsWS(claim_Type,claim_ID); 
        return JSON.serialize(result);
    }
    
    @AuraEnabled
    public static string queryClaimPayment(string claim_ID){
    	ACETLGT_FindClaimPaymentWebService service = new ACETLGT_FindClaimPaymentWebService();
        ACETWSCalloutResult result = new ACETWSCalloutResult();
    	result =  service.getClaimPayments(claim_ID);
        return JSON.serialize(result);
    }
    
    @AuraEnabled
    public static string getStdErrMsg(String prefix, String resultStatusCode) {
        string errorMessage;
        ACETErrorHandler errHandler = new ACETErrorHandler();
        string errorcode = prefix;
        errorcode  = errorcode + resultStatusCode;
        system.debug('inside getStdErrMsg ' + errorcode);
        if(resultStatusCode!=null && resultStatusCode !='200' &&(resultStatusCode == '400B' || resultStatusCode == '404' || resultStatusCode == '500')) {
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
        ACETLGT_GetCheckStatusWebService service = new ACETLGT_GetCheckStatusWebService();
        ACETWSCalloutResult result = new ACETWSCalloutResult();
        result =  service.getCheckStatus(checkSeriesDesignator,checkEFTNumber);        
        return JSON.serialize(result);
    }
    
    @AuraEnabled
    public static string getCheckImageUrl(String  SeriesDesignator, String CheckEFTNumber)
    {
        User usr = [select FederationIdentifier from user where id=:userinfo.getUserId()];
        String baseURL = String.valueof(URL.getSalesforceBaseUrl().toExternalForm());
        String orginstance ;
        String CheckImageUrl;
        for(ACETOrgInstanceURLToOrgNameMap__c orgname:ACETOrgInstanceURLToOrgNameMap__c.getAll().values()) {
            
            if(baseURL.toLowerCase().contains(orgname.Name)) {
                system.debug('tname '+orgname.name);
                orginstance = ACETOrgInstanceURLToOrgNameMap__c.getValues(orgname.name).Org_Name__c;
            }
        }
        if(orginstance != null){
            system.debug('orginstance is '+orginstance);
            ACETOrgNameToSwivelEndpointMap__c wrapURL = ACETOrgNameToSwivelEndpointMap__c.getValues(orginstance+'_IDRS');
            //US2564113 Start
            ISL_Webservice_Config__c appName =  ISL_Webservice_Config__c.getValues(orginstance+'_doc360Appname');
            string doc360Appname ;
            doc360Appname = appName.value__c;
            system.debug('wrapURL is '+wrapURL);
            CheckImageUrl = wrapURL.Swivel_Endpoint__c;
         //   SeriesDesignator ='SY';
         //   CheckEFTNumber='10509822';
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
    public static DatatableWrapper initPaymentResultsDatatable(String SeriesDesignator, String CheckNumber, String FirstName, String LastName, String MemberId){
    	ACETLGT_FindClaimPaymentWebService ws1 = new ACETLGT_FindClaimPaymentWebService();
        ws1.init(SeriesDesignator,CheckNumber,FirstName,LastName,MemberId);
        string  service = JSON.serialize(ws1).replace('\'', '&#x27;');
        service = service.replace('&#x27;', '\'');
        return new DatatableWrapper(JSON.serialize(service));
    }
    
    @AuraEnabled
    public static DatatableWrapper initPaidClaimsDatatable(String SeriesDesignator, String CheckNumber, String FirstName, String LastName, String MemberId){
    	ACETLGT_FindClaimPaymentDetailWebService ws1 = new ACETLGT_FindClaimPaymentDetailWebService();
        ws1.init(SeriesDesignator,CheckNumber,FirstName,LastName,MemberId);
        string  service = JSON.serialize(ws1).replace('\'', '&#x27;');
        service = service.replace('&#x27;', '\'');
        return new DatatableWrapper(JSON.serialize(service));
    }
    

}