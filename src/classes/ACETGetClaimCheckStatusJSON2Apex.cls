public class ACETGetClaimCheckStatusJSON2Apex {
        public GetCheckStatusResponse getCheckStatusResponse;

    public class GetCheckStatusResponse {
        public String checkStatus;
        public String issuedDate;
        public String voidDate;
        public String returnedDate;
        public String remailedDate;
        public String cashedDate;
        public String itemID;
    }
}