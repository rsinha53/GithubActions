/* Class Name: ACETGetBenefitCategoryResponse
* Author: Manish
* Created Date: 07/14/2021
* Description: JSON2APEX Class for response from B360 Get Benefit Category API
*/
public class ACETGetBenefitCategoryResponse {
    public list<Result> result{get;set;}
	public class Result{
		public list<Child> children{get;set;}
		public String categoryName{get;set;}
	}
	public class Child{
		public String benefitId{get;set;}
		public String categoryName{get;set;}
	}

}