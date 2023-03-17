public without sharing class ADBMCommitmentsServiceRequestWrapper {
	public MemberDetailRequest memberDetailRequest;
    public class MemberDetailRequest {
        public RequestHeader requestHeader;
        public IcueUserCDxRefIdentifierType icueUserCDxRefIdentifierType;
    }
    public class RequestHeader {
        public string applicationName;
    }
    public class IcueUserCDxRefIdentifierType {
        public string cdxRefId;
    }
}