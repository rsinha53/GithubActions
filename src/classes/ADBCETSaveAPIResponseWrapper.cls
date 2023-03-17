public class ADBCETSaveAPIResponseWrapper {
    @AuraEnabled
    public ResponseHeader responseHeader;
    public class ResponseHeader{
        @AuraEnabled
        public StatusMessages statusMessages;
        @AuraEnabled
        public String serviceCallStatus;
    }
    public class StatusMessages{
        @AuraEnabled
        public List<StatusMessage> statusMessage;
    }
    public class StatusMessage{
        @AuraEnabled
        public String statusMessage;
    }
    public static ADBCETSaveAPIResponseWrapper parse(String json) {
        return (ADBCETSaveAPIResponseWrapper) System.JSON.deserialize(json, ADBCETSaveAPIResponseWrapper.class);
    } 
}