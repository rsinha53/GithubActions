/* Class Name: ACETAreBenefitsAvailableRequest
* Author: Suresh
* Created Date: 07/16/2021
* Description: Class to generate Request Body for B360 Get Benefit Category API
*/
public class ACETAreBenefitsAvailableRequest {
  
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
        
        benefitPlanIDs = new List<BenefitPlanID>();
        BenefitPlanID benPlanID =  new BenefitPlanID();
        benPlanID.benefitPlanPlatform = 'USP';
        benPlanID.benefitPlanID = benefitPlanID;
        benefitPlanIDs.add(benPlanID);
        clientId = 'acet';
        this.dateOfService = dateOfService;
        docType = new List<String>{'dbd'};
        userType = 'Member';
        System.debug(JSON.serialize(this));
        return JSON.serialize(this);
    }
}