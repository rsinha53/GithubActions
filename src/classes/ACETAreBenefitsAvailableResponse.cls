/* Class Name: ACETAreBenefitsAvailableResponse
* Author: Suresh
* Created Date: 07/16/2021
* Description: JSON2APEX Class for response from B360 Are Benefit Available API
*/
public class ACETAreBenefitsAvailableResponse {
    public Result result{get;set;}
	public class Result{
		public Boolean isAvailable{get;set;}
	}
}