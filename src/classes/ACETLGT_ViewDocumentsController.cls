public class ACETLGT_ViewDocumentsController {
    public  class DataWrapper{
       @Auraenabled
        public string responce;
       @Auraenabled 
         public string wrapperdetails;
       @Auraenabled
       public string resultFields;
        public DataWrapper(String responce, string resultFields){
            this.responce = responce;    
            this.resultFields = resultFields;
        }       
    }
  @AuraEnabled
    public static DataWrapper initDocDatatable(String docType, String GroupID, String BBundleId){
   system.debug('docType==='+docType+'GroupID===='+GroupID+'BBundleId===='+BBundleId);
      ACETFindDocWebservice findDocService = new ACETFindDocWebservice();
        List<ACETFindDocWebservice.documentKey> findDocKeys = new List<ACETFindDocWebservice.documentKey>();
        
       if(!String.isEmpty(GroupID)){
            ACETFindDocWebservice.documentKey groupIdKey = new ACETFindDocWebservice.documentKey();
            GroupIdKey.value = GroupID ;
            GroupIdKey.name = 'u_grp_id';
            GroupIdKey.dataTypeIndicator = 'string';
            GroupIdKey.operator = '=';
            findDocKeys.add(GroupIdKey);
        }
       
        if(!String.isEmpty(BBundleId)){
            ACETFindDocWebservice.documentKey BBundleIdKey = new ACETFindDocWebservice.documentKey();
            BBundleIdKey.value = BBundleId;
            BBundleIdKey.name = 'u_grp_contr_ben_bndl_opt_id';
            BBundleIdKey.dataTypeIndicator = 'string';
            BBundleIdKey.operator = '=';
            findDocKeys.add(BBundleIdKey);
        }
         system.debug('findDocKeys====='+findDocKeys);        
        //change operator to = ANY for WS MultiValue Field
       List<Document_Type_Search_By_Field__mdt> listSearchByFields = [SELECT Document_Type__r.WS_Field_Name__c, WS_MultiValue_Field__c, Document_Type_Field__r.WS_Field_Name__c FROM Document_Type_Search_By_Field__mdt];
       
        for(Document_Type_Search_By_Field__mdt sf : listSearchByFields){
            if(sf.WS_MultiValue_Field__c == true){
             
                for(ACETFindDocWebservice.documentKey docKey : findDocKeys){
                    if(docType == sf.Document_Type__r.WS_Field_Name__c && sf.Document_Type_Field__r.WS_Field_Name__c == docKey.name){
                        docKey.operator += ' ANY';
                    }   
                }   
            }
        }
        
        findDocService.init(docType, findDocKeys); 
        string  service = JSON.serialize(findDocService).replace('\'', '&#x27;');
        service = service.replace('&#x27;', '\'');
        System.debug(JSON.serialize(service));
        List<Document_Type_Search_Result_Field__mdt> resultFields = [select DeveloperName,Document_Type_Field__r.WS_Field_Name__c,Document_Type_Field__r.Field_Name__c, Display_Order__c from Document_Type_Search_Result_Field__mdt where Document_Type__r.WS_Field_Name__c = :docType order by Display_Order__c];           
       return new DataWrapper(JSON.serialize(service), JSON.serialize(resultFields)); 
    }
    
    /**
    * @description US3385722 - Team Styx - Preparing Doc360 Document View URL
    * @author Raviteja | 06-25-2021
    * @return string 
    **/
    @AuraEnabled
    public static String getDoc360URL(String documentId, String doctypeWSName){
        return ACETLGT_DocumentController.getdoc360Url(documentId,doctypeWSName);
    }
    
}