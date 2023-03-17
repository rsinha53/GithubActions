@IsTest
public class ACETLGT_UpdateIndividualTest {
    public testmethod static void test(){
        ACETLGT_UpdateIndividualJSON2APEX ja = new ACETLGT_UpdateIndividualJSON2APEX();
        ja.UpdateIndividualMembershipResponse = new ACETLGT_UpdateIndividualJSON2APEX.cls_UpdateIndividualMembershipResponse();
        ja.UpdateIndividualMembershipResponse.response = new ACETLGT_UpdateIndividualJSON2APEX.cls_response();
        System.debug(ja.UpdateIndividualMembershipResponse.response.responseCode);
        System.debug(ja.UpdateIndividualMembershipResponse.response.responseDesc);        
    }
}