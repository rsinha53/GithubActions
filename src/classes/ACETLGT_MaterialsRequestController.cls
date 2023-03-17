public class ACETLGT_MaterialsRequestController {
    public class resultswrap {
     @AuraEnabled
        public  list<MaterialForms> vListMaterialsForms  {get; set;}
       @AuraEnabled
       public List<ACETLGT_FormsHistoryResult> formshistoryresult {get; set;}
        @AuraEnabled
        Public object resp {get;set;}
    }
     @AuraEnabled
    Public static resultswrap searchOrderHistory(string startdate,string enddate,string recepientId,string idQualifier, string order){
       
        resultswrap rw = new resultswrap();
        string source ='ACET';
         List<ACETLGT_FormsHistoryResult> formshistory = new List<ACETLGT_FormsHistoryResult>();
                            system.debug(order);

        if(order.equalsignorecase('Order History')){

            ACETLGT_FormsHistoryWebServiceFF formsHistoryWebService = new ACETLGT_FormsHistoryWebServiceFF();
           
            formsHistoryWebService.init(source,10700,String.valueOf(startdate),String.valueOf(enddate),recepientId,idQualifier);    
            ACETWSCalloutResult searchResult =  formsHistoryWebService.queryPaginatedData(1,1,1);
            rw.formshistoryresult = new List<ACETLGT_FormsHistoryResult>();
             
            if(searchResult.Response!= null){
                   
                if(searchResult.statusCode==200 && searchResult.Success) {
                      rw.formshistoryresult.addAll( (List<ACETLGT_FormsHistoryResult>) searchResult.Response);
                }
                else {
                    if(searchResult.statusCode==400) {
                        //setErrorMsg('GN400B');
                    }
                    else if(searchResult.statusCode==200 && !searchResult.success) {
                       // setErrorMsg('MR200');
                    }
                    else if(searchResult.statusCode==404) {
                      //  setErrorMsg('MR404');
                    }
                    else{
                       // setErrorMsg('GN'+searchResult.statusCode);
                    }
                }
            }
        }
      //  order = 'Order History';
        system.debug('====>'+rw.formshistoryresult);
        return rw;
    }
      @AuraEnabled
      public static resultswrap getMaterialForms(string BusinessUnit ) {
           system.debug('BusinessUnit@@@@@@ '+BusinessUnit);
        Transient Map<string,Material_Forms__c> vLstMaterialForms = new Map<string,Material_Forms__c>();
        list<MaterialForms> vListMaterialsForms = new list<MaterialForms>();
        map<string, MaterialForms> mapMaterialForms = new map<string, MaterialForms>();
        
        system.debug('vListMaterialsForms@@@@@@  '+ vListMaterialsForms);
        system.debug('BusinessUnit@@@@@@  '+ BusinessUnit);
        try{
            for(Material_Forms__c vMForms : [SELECT Id, Business_Unit__c,Category__c,Document_Title__c,Document_URL__c,FulfillmentType__c,MRE__c,Quantity__c FROM Material_Forms__c where Business_Unit__c=:BusinessUnit ORDER BY Category__c ASC,Document_Title__c ASC ]){
                if(mapMaterialForms.get(vMForms.Category__c) == null){
                    mapMaterialForms.put(vMForms.Category__c, new MaterialForms(vMForms));
                    vListMaterialsForms.add(mapMaterialForms.get(vMForms.Category__c));
                }
                else{
                    mapMaterialForms.get(vMForms.Category__c).LstMaterialForms.add(vMForms);
                }                                         
            }
            system.debug('mapMaterialForms@@@@@@  '+ vListMaterialsForms);
        }
        catch(Exception ex){
            system.debug('Exception@@ '+ vListMaterialsForms);
        }
          resultswrap rw = new resultswrap();
          rw.vListMaterialsForms = vListMaterialsForms;
        return rw;
        
    }
    
      public class MaterialForms
    {   
        @AuraEnabled
        public list<Material_Forms__c> LstMaterialForms {get; set;}
         @AuraEnabled
        public string CategoryName {get; set;}
        public MaterialForms(Material_Forms__c vMForms)
        {
            CategoryName = vMForms.Category__c;
            LstMaterialForms = new list<Material_Forms__c>{vMForms};
                }
    }


}