public class ACETLGT_MemberOtherInquiryController {

    @AuraEnabled
    public static String getCSRFURL() {
        String sandboxName = ACETUtility.GetOrgName();
        return ACETUtility.GetSwivelEndpointByOrgName(sandboxName, 'CSRF');
    }    
    
}