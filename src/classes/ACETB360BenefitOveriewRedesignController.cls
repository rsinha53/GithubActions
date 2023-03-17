/* Class Name: ACETB360BenefitOveriewRedesignController
* Author: Manish
* Created Date: 08/01/2021
* Description: Controller Class to integrate with B360 UI
*/
public class ACETB360BenefitOveriewRedesignController {
    public boolean isBenefitAvailable{get;set;}
    public ACETGetBenefitCategoryAPI.B360BenefitCategory b360BenefitCategory{get;set;}
    public String b360BenefitCategoryStr{get;set;}
    public String benefitDateSearch {get; set;}
    public String currentDate {get; set;}
    public String currentDateBenefits {get; set;}
    public String failureMessage{get;set;}
    public String errorSeverity{get;set;}
    public String effectiveDate {get; set;}
    public String endDate {get; set;} 
    public String groupEffectiveDate {get; set;}
    public String groupRenewalDate {get; set;} 
    public String groupId{get;set;}
    public String benefitBundleOptionId {get; set;}     
    public String searchedKeyword{get;set;}
    public String selectedCategory{get;set;}
    public String benefitId{get;set;}
    public String benefitSectionsStr{get;set;}
    private String sessionId{get;set;}
    public List<ACETGetBenefitCategoryResponse.Child> selectedChildCategory{get;set;}
   
    public ACETB360BenefitOveriewRedesignController(){
        System.debug('>>>Constructor Called');
        sessionId = UserInfo.getSessionId();
        Date todayBenefitsDate = Date.today(); 
        String todayFormattedDate = ACETUtility.formatStrict(todayBenefitsDate);
        benefitDateSearch = todayFormattedDate;
        currentDateBenefits = '[ '+todayFormattedDate+' ]';
    }
   
    public void getBenefitAvailable(){
        System.debug('>>>Benefit Available Service Called');
        String benefitPlanId = groupId + '_' + benefitBundleOptionId;
        String dateOfService = ACETUtility.formatDatewithslash(benefitDateSearch);
        System.debug('>>>>benefitPlanId::'+benefitPlanId);
        isBenefitAvailable = false;
        failureMessage = null;
        errorSeverity = 'error';
        ACETWSCalloutResult calloutResult = new ACETWSCalloutResult();
        ACETAreBenefitsAvailableAPI acetBenefitCat = new ACETAreBenefitsAvailableAPI();
        calloutResult = acetBenefitCat.getB360AreBenefitsAvailableService(benefitPlanId,dateOfService); 
        if(calloutResult != null && calloutResult.Success && calloutResult.statusCode == 200){ 
            isBenefitAvailable = Boolean.valueOf(calloutResult.response);
            if(!isBenefitAvailable)
            {
                failureMessage = 'No benefit language found';
        		errorSeverity = 'info';
            }
        }
        else if(calloutResult != null && String.isNotBlank(calloutResult.Message))
        {
            failureMessage = calloutResult.Message;
        }
        else
        {
            failureMessage = ACETUtility.getErrorMessage('GN999');
        } 
        if(String.isNotBlank(failureMessage)){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, failureMessage));
        }
        System.debug('>>>isBenefitAvailable :: '+isBenefitAvailable);
        addApexPageErrorMessage(failureMessage,errorSeverity);
    } 
    public void getB360BenefitCategoryList()
    {	 System.debug('>>>Benefit Category Service Called');
        String benefitPlanId = groupId + '_' + benefitBundleOptionId;
        String dateOfService = ACETUtility.formatDatewithslash(benefitDateSearch);
        b360BenefitCategory = new ACETGetBenefitCategoryAPI.B360BenefitCategory();
        
        if(isBenefitAvailable){
            	failureMessage = null;
        		errorSeverity = 'error';
                ACETWSCalloutResult calloutResult;
                ACETGetBenefitCategoryAPI getBenefitCatAPI = new ACETGetBenefitCategoryAPI();
                calloutResult = getBenefitCatAPI.getB360BenefitCategoryResponse(benefitPlanId,dateOfService);
                if(calloutResult != null && calloutResult.Success && calloutResult.statusCode == 200)
                {
                    ACETGetBenefitCategoryResponse response = (ACETGetBenefitCategoryResponse)calloutResult.Response;
                    b360BenefitCategory = getBenefitCatAPI.processResponse(response);
                    if(b360BenefitCategory != null && b360BenefitCategory.benefitCategoryList != null && b360BenefitCategory.benefitCategoryList.size() == 0)
                    {
                         failureMessage = 'No benefit language found';
                    }
                    b360BenefitCategoryStr = JSON.serialize(b360BenefitCategory);
                }
                else if(calloutResult != null && String.isNotBlank(calloutResult.Message))
                {
                    failureMessage = calloutResult.Message;
                }
                else
                {
                    failureMessage = ACETUtility.getErrorMessage('GN999');
                }     
         }
        System.debug('>>>B360 Category :: '+ b360BenefitCategoryStr);
       
        addApexPageErrorMessage(failureMessage,errorSeverity);
    }
    public void getChildCategory()
    {
        System.debug('>>>>Selected Category : ' + selectedCategory);
        selectedChildCategory = new List<ACETGetBenefitCategoryResponse.Child>();
        /*
        b360BenefitCategory is getting reintialised 
        Storing the response at client side and passing back to this method to get list of child categories
		*/
        if(String.isNotBlank(b360BenefitCategoryStr))
        	b360BenefitCategory = (ACETGetBenefitCategoryAPI.B360BenefitCategory)JSON.deserialize(b360BenefitCategoryStr, ACETGetBenefitCategoryAPI.B360BenefitCategory.class);
        failureMessage = null;
        errorSeverity = 'error';
        if(b360BenefitCategory != null && b360BenefitCategory.benefitCategoryChildrenMap != null)
        {
            selectedChildCategory = b360BenefitCategory.benefitCategoryChildrenMap.get(selectedCategory); 
        }
        else
        {
            failureMessage = ACETUtility.getErrorMessage('GN404');
        }
        System.debug('>>>>Selected Child Category : ' + JSON.serialize(selectedChildCategory));
        addApexPageErrorMessage(failureMessage,errorSeverity);
    }
	public void benefitKeywordSearch()
    {	
        String benefitPlanId = groupId + '_' + benefitBundleOptionId;
        String dateOfService = ACETUtility.formatDatewithslash(benefitDateSearch);
        failureMessage = null;
        errorSeverity = 'error';
       	selectedChildCategory = new List<ACETGetBenefitCategoryResponse.Child>();
        ACETWSCalloutResult calloutResult;
        ACET_SearchBenefitsService searchBenSer = new ACET_SearchBenefitsService();
        calloutResult = searchBenSer.searchBenefits(benefitPlanId,searchedKeyword,dateOfService, sessionId);
        if(calloutResult != null && calloutResult.Success)
        {
            ACET_SearchBenefitsResponseJSON.Benefit[] benList = (ACET_SearchBenefitsResponseJSON.Benefit[])calloutResult.Response;
            for(ACET_SearchBenefitsResponseJSON.Benefit ben : benList){
                
                //Benefit will display only if benefit id is available 
                if(String.isNotBlank(ben.benefitName) && String.isNotBlank(ben.benefitId))
                {
                    ACETGetBenefitCategoryResponse.Child childCat = new ACETGetBenefitCategoryResponse.Child();
                    childCat.categoryName = ben.benefitName;
                    childCat.benefitId = ben.benefitId;
                    selectedChildCategory.add(childCat);
                }
            }
            if(selectedChildCategory.size() == 0){
                failureMessage = ACETUtility.getErrorMessage('GN404');
            }
        }
        else if(calloutResult != null && String.isNotBlank(calloutResult.Message))
        {
            failureMessage = calloutResult.Message;
        }
        else
        {
            failureMessage = ACETUtility.getErrorMessage('GN999');
        }
        
        System.debug('>>>Keyword Search Benefit :: '+ JSON.serialize(selectedChildCategory));
        addApexPageErrorMessage(failureMessage,errorSeverity);
    }
    public void getBenefitSection()
    {
        ACET_GetBenefitSectionService benSectionSer = new ACET_GetBenefitSectionService();
        System.debug('>>>benefitId :' + benefitId);
        failureMessage = null;
        errorSeverity = 'error';
        ACETWSCalloutResult calloutResult = benSectionSer.searchBenefitsSection(benefitId, sessionId);
        
        if(calloutResult != null && calloutResult.Success)
        {
            ACET_GetBenefitSectionResponseJSON.Benefit[] benefitSections = (ACET_GetBenefitSectionResponseJSON.Benefit[])calloutResult.response;
            benefitSectionsStr = JSON.serialize(benefitSections);
        }
        else if(calloutResult != null && String.isNotBlank(calloutResult.Message))
        {
            failureMessage = calloutResult.Message;
        }
        else
        {
            failureMessage = ACETUtility.getErrorMessage('GN999');
        }
        System.debug('>>>Benefit Sections :: '+ benefitSectionsStr);
        addApexPageErrorMessage(failureMessage,errorSeverity);
    }
    public void addApexPageErrorMessage(String failureMessage, String errorSeverity){
        if(String.isNotBlank(failureMessage))
        	ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,failureMessage));
    }
}