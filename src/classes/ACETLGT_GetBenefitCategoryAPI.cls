/* Class Name: ACETLGT_GetBenefitCategoryAPI
* Author: Manish
* Created Date: 07/14/2021
* Description: API Class to get B360 Benefit Categories
*/
public class ACETLGT_GetBenefitCategoryAPI {
    
    public class B360BenefitCategory{
        @AuraEnabled public List<String> benefitCategoryList{get;set;}
        @AuraEnabled public Map<String,List<ACETLGT_GetBenefitCategoryResponse.Child>> benefitCategoryChildrenMap;
    }
    
    public String getRequestBody(String benefitPlanID, String dateOfService)
    {
        String requestBody ;
        ACETLGT_GetBenefitCategoryRequest getBenefitCategoryRequest = new ACETLGT_GetBenefitCategoryRequest();
        requestBody = getBenefitCategoryRequest.addSearchInput(benefitPlanID, dateOfService);
        return requestBody;
    }
    public List<ACETLGT_GetBenefitCategoryResponse.Child> getChildBenList(ACETLGT_GetBenefitCategoryResponse.Result result){
        List<ACETLGT_GetBenefitCategoryResponse.Child> childList = new List<ACETLGT_GetBenefitCategoryResponse.Child>();
        if(result.children != null)
        {
            for(ACETLGT_GetBenefitCategoryResponse.Child child : result.children)
            {
                //Child benefit will display only if benefit id is available 
                if(String.isNotBlank(child.categoryName) && String.isNotBlank(child.benefitId))
                {
                    childList.add(child);
                }
            }
        }
        return childList;
    }
    public ACETLGT_GetBenefitCategoryAPI.B360BenefitCategory processResponse(ACETLGT_GetBenefitCategoryResponse response){
        ACETLGT_GetBenefitCategoryAPI.B360BenefitCategory benefitCategory = new ACETLGT_GetBenefitCategoryAPI.B360BenefitCategory();
        if(response!= null && response.result != null)
        {
            List<ACETLGT_GetBenefitCategoryResponse.Result> results = response.result;
            List<String>benefitCategoryList = new List<String>();
            Map<String,List<ACETLGT_GetBenefitCategoryResponse.Child>> benefitCategoryChildrenMap = new Map<String,List<ACETLGT_GetBenefitCategoryResponse.Child>>();
            for(ACETLGT_GetBenefitCategoryResponse.Result result : results)
            {
                String categoryName = result.categoryName;
                List<ACETLGT_GetBenefitCategoryResponse.Child> childList = getChildBenList(result);
                //Category will not display in dropdown list if none of the children have benefit id
                if(String.isNotBlank(categoryName) && childList.size() > 0){
                    benefitCategoryList.add(categoryName);
                    benefitCategoryChildrenMap.put(categoryName,childList);
                }
            }
            benefitCategory.benefitCategoryList = benefitCategoryList;
            benefitCategory.benefitCategoryChildrenMap = benefitCategoryChildrenMap;
        }
        return benefitCategory;
    }
    public ACETWSCalloutResult getB360BenefitCategoryResponse(String benefitPlanID, String dateOfService)
    {
        ACETWSCalloutResult calloutResult = new ACETWSCalloutResult();
        try{
            
            ACET_WebserviceCalloutFramework wsCallOutFW = new ACET_WebserviceCalloutFramework();
            wsCallOutFW.serviceName = 'B360GetBenefitCategoryService';
            wsCallOutFW.requestBody = GetRequestBody(benefitPlanID,dateOfService); 
            HttpResponse httpResponse  = wsCallOutFW.getResponse();
            if(httpResponse != null && httpResponse.getStatusCode() == 200){
                System.debug('>>> Status Code: '+ httpResponse.getStatusCode());
                System.debug('>>> Response Body: '+ httpResponse.getBody());
                calloutResult.statusCode = httpResponse.getStatusCode();
                String responseStr = httpResponse.getBody();
                ACETLGT_GetBenefitCategoryResponse response = (ACETLGT_GetBenefitCategoryResponse)JSON.deserialize(responseStr, ACETLGT_GetBenefitCategoryResponse.class);
 				calloutResult.Success = true;
                calloutResult.Message = '';
                calloutResult.Response = response;
            }
            else{
                calloutResult.MessageSeverity = ApexPages.Severity.ERROR;
                calloutResult.Success = false;
                calloutResult.statusCode = (httpResponse == null) ? 999 : httpResponse.getStatusCode();
                getErrorMessage(calloutResult);
            }
        }catch(Exception e){
            calloutResult.MessageSeverity = ApexPages.Severity.ERROR;
            calloutResult.Success = false;
            calloutResult.Message = ACETUtility.getErrorMessage('GN999');
            calloutResult.statusCode = 999;
        }
        return calloutResult; 
    }
    public void getErrorMessage(ACETWSCalloutResult calloutResult){
            
        if(calloutResult.statusCode != null && calloutResult.statusCode == 400)
            calloutResult.Message = ACETUtility.getErrorMessage('GN400B'); 
        else if(calloutResult.statusCode != null && calloutResult.statusCode == 404)
            calloutResult.Message = ACETUtility.getErrorMessage('GN404');
        else if(calloutResult.statusCode != null && calloutResult.statusCode == 500)
            calloutResult.Message = ACETUtility.getErrorMessage('GN500'); 
        else if(calloutResult.statusCode != null && calloutResult.statusCode == 504)
            calloutResult.Message = ACETUtility.getErrorMessage('GN504'); 
        else
            calloutResult.Message = ACETUtility.getErrorMessage('GN999');
    }
}