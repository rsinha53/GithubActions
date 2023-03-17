public with sharing class ACET_PurgedORSController {

    @AuraEnabled
    public static ACET_SAECalloutResult getPurgedDocument(String objectId){
        ACET_SAECalloutResult result = new ACET_SAECalloutResult();
        result.isSuccess = false;
        result.statusCode = 999;
        result.message = 'Unexpected Error Occured';
        try{
            return ACET_DocThreeSixtyService.getContent(objectId);
        }catch(Exception e){            
            return result;
        }
    }

}