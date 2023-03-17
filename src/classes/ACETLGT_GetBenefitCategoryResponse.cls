/* Class Name: ACETLGT_GetBenefitCategoryResponse
* Author: Manish
* Created Date: 07/14/2020
* Description: JSON2APEX Class for response from B360 Get Benefit Category API
*/
public class ACETLGT_GetBenefitCategoryResponse {
    public list<Result> result{get;set;}
	public class Result{
		public list<Child> children{get;set;}
		public String categoryName{get;set;}
	}
	public class Child{
		@AuraEnabled public String benefitId{get;set;}
		@AuraEnabled public String categoryName{get;set;}
	}

}