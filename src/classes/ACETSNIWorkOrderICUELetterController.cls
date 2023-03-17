public class ACETSNIWorkOrderICUELetterController {
       public class ICUEResultWrapper{
        @AuraEnabled public ACET_ICUELetterResult resultWrapper {get;set;}
        @AuraEnabled public string message {get;set;}
        @AuraEnabled public integer statusCode {get;set;}
        @AuraEnabled public String indexName {get;set;}
    } 
     @AuraEnabled
    public static ICUEResultWrapper findICUELetter(String srnNumber,String documentType){      
        ICUEResultWrapper dataWrap = new ICUEResultWrapper();
        if(String.isNotBlank(documentType)) {
    		ICUEDocRequest icueRequest = new ICUEDocRequest();
    		List<Document_Type__mdt> docTypes = [SELECT Id,Label, Document_Type__c, WS_Field_Name__c FROM Document_Type__mdt where Document_Type__c = :documentType];
    		if(docTypes.size() > 0){
              	icueRequest.indexName =docTypes[0].WS_Field_Name__c;
            }
			List<Document_Type_Search_By_Field__mdt> lstSearchFilter = [SELECT Id, DeveloperName, Document_Type_Field__r.Label, Document_Type__r.Document_Type__c, Document_Type_Field__r.Field_Name__c, Document_Type_Field__r.Field_Type__c, Document_Type_Field__r.WS_Field_Name__c, Document_Type_Field__r.Data_Type__c, Document_type_Field__r.Operator__c FROM Document_Type_Search_By_Field__mdt where Document_Type__r.Document_Type__c=:documentType];
			if(!lstSearchFilter.isEmpty() && String.isNotBlank(srnNumber)) {
        	List<ICUEDocRequest.FilterClauses> FilterClausesLst = new List<ICUEDocRequest.FilterClauses>();
        	ICUEDocRequest.FilterClauses FilterClauses = new ICUEDocRequest.FilterClauses();
        	FilterClauses.type_Z = lstSearchFilter[0].Document_type_Field__r.Operator__c;
        	FilterClauses.name = lstSearchFilter[0].Document_Type_Field__r.WS_Field_Name__c;
        	FilterClauses.value = srnNumber;
        	FilterClausesLst.add(FilterClauses);
        	ICUEDocRequest.Criteria Criteria = new ICUEDocRequest.Criteria();
        	Criteria.filterClauses = FilterClausesLst;
        	icueRequest.Criteria = Criteria;
            System.debug(icueRequest);
            System.debug(documentType + srnNumber);
            ACETWSCalloutResult calloutResult = new ACETWSCalloutResult();
            ACET_ICUELetterResult responseResult = new ACET_ICUELetterResult();
            ACET_ICUELetterWS icueLetterWS = new ACET_ICUELetterWS('CHS',icueRequest); 
            if(icueRequest != null){
                calloutResult = icueLetterWS.findICUELetter(srnNumber);
                responseResult = (ACET_ICUELetterResult)calloutResult.Response;
            }
            dataWrap.resultWrapper = responseResult;
            dataWrap.message = calloutResult.Message;
            dataWrap.statusCode = calloutResult.statusCode;
            dataWrap.indexName = icueRequest.indexName;
        }
      }
        System.debug(dataWrap.resultWrapper);
        return dataWrap;
    }
    @AuraEnabled
    public static string getSearchParamValue (Id recordId,String searchField){
        System.debug(searchField);
        String sObjName = recordId.getSObjectType().getDescribe().getName();
        String searchParam;
        String query = 'SELECT Id,' +searchField+ ' from ' +sObjName+ ' where Id = \'' +recordId+ '\'';
        System.debug(query);
        List<sObject> sobjList = Database.query(query);
        if(!sobjList.isEmpty() && sobjList[0].get(searchField) != null) {
            searchParam  = (String) sobjList[0].get(searchField);
        }
        return searchParam;
    }
}