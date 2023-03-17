public class ACETLGT_DataTable_Controller {
 public  class DatatableWrapper{
       @Auraenabled
        public string responce;       
        public DatatableWrapper(String responce){
            this.responce = responce;        
        }       
    }
    @AuraEnabled
    public static DatatableWrapper getSearchResults(String serviceName,String service, Integer pageNumber, Integer pageSize, Integer startRecord){             
        Type t = Type.forname(serviceName); 
        system.debug('service--->'+service);
        ACETWebservice serviceObj = (ACETWebservice)JSON.deserialize(service, t);  
        ACETWSCalloutResult result =serviceObj.queryPaginatedData(pageNumber, pageSize, startRecord);
        /*ACETLGT_ReferralWebservice actRef = new ACETLGT_ReferralWebservice();
        ACETWSCalloutResult result = actRef.queryPaginatedData(pageNumber, pageSize, startRecord);*/
        return new DatatableWrapper(JSON.serialize(result));
    }
    @AuraEnabled
    public static DatatableWrapper getSearchResults(String serviceName,String service, Integer pageNumber, Integer pageSize, Integer startRecord,String firstName, String lastName, String birthDate, String srk){      
        System.debug('firstName::'+firstName);
        System.debug('lastName::'+lastName);
        System.debug('birthDate::'+birthDate);
        System.debug('srk::'+srk);
        system.debug('service--->'+service);
        if(serviceName=='ACETLGT_ReferralWebservice'){
            ACETLGT_ReferralWebservice actRef = new ACETLGT_ReferralWebservice();
            ACETWSCalloutResult result = actRef.queryPaginatedData(pageNumber, pageSize, startRecord,firstName,lastName,birthDate,srk);
            return new DatatableWrapper(JSON.serialize(result));  
        }
        else{
            Type t = Type.forname(serviceName); 
            ACETWebservice serviceObj = (ACETWebservice)JSON.deserialize(service, t);  
            ACETWSCalloutResult result =serviceObj.queryPaginatedData(pageNumber, pageSize, startRecord);
            return new DatatableWrapper(JSON.serialize(result));
        }
    }
}