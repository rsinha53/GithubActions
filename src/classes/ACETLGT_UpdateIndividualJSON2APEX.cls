public class ACETLGT_UpdateIndividualJSON2APEX {
    public cls_UpdateIndividualMembershipResponse UpdateIndividualMembershipResponse;
    public ACETLGT_UpdateIndividualJSON2APEX()
    {
    
    }
    public class cls_UpdateIndividualMembershipResponse {
        public cls_response response;
        public list<cls_error> errors;
    }
    public class cls_response {
        public String responseCode; //200
        public String responseDesc; // STS0003-Record(s) updated. STS3021-All member benefit records associated to this bundle option are successfully updated. STS0003-Record(s) updated. STS3021-All member benefit records associated to this bundle option are successfully updated. STS0003-Record(s) updated.
    }
    
    public class cls_error{
        public String code;
        public String description;
    }

}