/* Class Name: ACETLGT_GetBenefitCategoryRequest
* Author: Manish
* Created Date: 07/14/2020
* Description: Class to generate Request Body for B360 Get Benefit Category API
*/
public class ACETLGT_GetBenefitCategoryRequest {
  
	public String clientId{get;set;}
    public String dateOfService{get;set;}
    public list<BenefitPlanID> benefitPlanIDs{get;set;}
    public list<String> docType{get;set;}
    public String userType{get;set;}
    
	public class BenefitPlanID{
		public String benefitPlanPlatform{get;set;}
		public String benefitPlanID{get;set;}
	}
    
    public String addSearchInput(String benefitPlanID,String dateOfService) {
        clientId = 'acet';
        this.dateOfService = dateOfService;
        benefitPlanIDs = new List<BenefitPlanID>();
        BenefitPlanID benPlanID =  new BenefitPlanID();
        benPlanID.benefitPlanPlatform = 'USP';
        benPlanID.benefitPlanID = benefitPlanID;
        benefitPlanIDs.add(benPlanID);
        docType = new List<String>{'dbd'};
        userType = 'Member';
        
        return JSON.serialize(this);
    }
}