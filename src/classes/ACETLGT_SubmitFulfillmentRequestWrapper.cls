/* Class Name:ACETLGT_SubmitFulfillmentRequestWrapper
 * Author:Manish
 * Created Date: 07/06/2021
 * Description: Class to generate request for Submit Fulfillment Request API
**/
public class ACETLGT_SubmitFulfillmentRequestWrapper {
    
    public String type{get;set;}
    public Values values{get;set;}

	public class Values {
        public String memberGroupID{get;set;}
        public String memberID{get;set;}
        public String benefitBundleOptionID{get;set;}
	}
    
    public String addSearchInput(String memberId,string groupId, string bundleId) {
        type = 'MEMBERCARD';
        values = new Values();
        values.memberGroupID = groupId;
        values.memberID = memberId;
        values.benefitBundleOptionID = bundleId;
        return JSON.serialize(this);
    }
}