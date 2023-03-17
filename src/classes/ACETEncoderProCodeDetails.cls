public with sharing class ACETEncoderProCodeDetails {
    public CLSBatchResponses batchResponses;
    public class CLSBatchResponses {
        public CLSresponse[] response;
    }
    public class CLSresponse {
        public Text text;
        public Integer statusCode;
        public String requestId;
    }
	//
    public class Text{
        public String description;
    }
}