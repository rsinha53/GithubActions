public class ACETLGT_PlanBenefitDetailController extends ACETErrorHandler{
    
    public class SearchResultWrapper {
        @AuraEnabled public ACETGroupPlanBenefitLEXWrapper resultWrapper {get;set;}
        @AuraEnabled public String ErrorMessage {get;set;}
    }

    @AuraEnabled
    public static SearchResultWrapper getSearchResults(String surrogateKey, String bundleId, String enrollerSRK, String startDate, 
    String endDate, String coverageTypes, String groupNumber, String accumsDate, String accumAsOf, Boolean isActive, Boolean isTermed,String customerPurchaseId){
        
         System.debug('surrogateKey:'+ surrogateKey);
         System.debug('bundleId:'+ bundleId);
         System.debug('enrollerSRK:'+ enrollerSRK);
         System.debug('startDate:'+ startDate);
         System.debug('endDate:'+ endDate);
         System.debug('coverageTypes:'+ coverageTypes);
         System.debug('groupNumber:'+ groupNumber);
         System.debug('accumsDate:'+ accumsDate);
         System.debug('accumAsOf:'+ accumAsOf);
         System.debug('isActive:'+ isActive);
         System.debug('isTermed:'+ isTermed);

        SearchResultWrapper detWrap = new SearchResultWrapper();
        try{
            
            ACETLGT_NimbusGetSSBAPI getPlanBenefitService = new ACETLGT_NimbusGetSSBAPI();
            
            ACETWSCalloutResult CalloutResult = getPlanBenefitService.init(surrogateKey, bundleId, enrollerSRK, startDate, 
            endDate, coverageTypes, groupNumber, accumsDate, accumAsOf, isActive, isTermed,customerPurchaseId);

            ACETGroupPlanBenefitLEXWrapper resultWrapper = new ACETGroupPlanBenefitLEXWrapper(); 
            if (CalloutResult != null && CalloutResult.Success){   
                resultWrapper = (ACETGroupPlanBenefitLEXWrapper)CalloutResult.Response;
                detWrap.resultWrapper = resultWrapper;
                return detWrap;
            } else {
                detWrap.resultWrapper = new ACETGroupPlanBenefitLEXWrapper();
                if(CalloutResult!= null && CalloutResult.statusCode == 400)
            		detWrap.ErrorMessage = setLightningErrorMsg('GN400B');
            	else
            		detWrap.ErrorMessage = setLightningErrorMsg('GN'+CalloutResult.statusCode );
                return detWrap;
            } 

        } catch(Exception ex){
            detWrap.resultWrapper = new ACETGroupPlanBenefitLEXWrapper();
            detWrap.ErrorMessage = setLightningErrorMsg('MGD997');
            system.debug('final res::: '+detWrap );
            return detWrap;
        }
    }

}