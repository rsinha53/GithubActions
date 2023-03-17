/* Class Name: ACETLGT_AreBenefitsAvailableResponse
* Author: Suresh
* Created Date: 07/15/2021
* Description: JSON2APEX Class for response from B360 Are Benefit Available API
*/
public class ACETLGT_BenefitsAvailableResponse {
    public Result result{get;set;}
	public class Result{
		public Boolean isAvailable{get;set;}
	}
}