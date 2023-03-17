public without sharing class SNI_FL_HistoryMessageController {
    public class singleHistMsgWrapper{
        @AuraEnabled
        public String authorFirstName;
        @AuraEnabled
		public String authorLastName;
        @AuraEnabled
		public datetime messageDateTime;
        @AuraEnabled
		public String message;
        @AuraEnabled
        public String UserChange;
    }
    public class wsReturnWrapper{
        @AuraEnabled
        public List<singleHistMsgWrapper>returnMsg;
    	@AuraEnabled
        public Integer statusCode;
        @AuraEnabled
        public String statusMessage;
    }
    public class returningMsgWrapper{
        @AuraEnabled
        public Integer statusCode;
        @AuraEnabled
        public String statusMessage;
        @AuraEnabled
        public String ListauthorName;
        @AuraEnabled
        public datetime ListDateTime;
        @AuraEnabled
        public list<singleHistMsgWrapper> singleMsgList;
    }
    public class providerMessageWrapper{
        @AuraEnabled
        public String ListauthorName;
        @AuraEnabled
        public datetime ListDateTime;
        @AuraEnabled
        public String memberAffiliationId;
    }
    public class providerReturnWrapper{
        @AuraEnabled
        public List<providerMessageWrapper> providerMessages;
        @AuraEnabled
        public Integer statusCode;
        @AuraEnabled
        public String statusMessage;
        @AuraEnabled
        public Boolean hasNext;
    }
    @AuraEnabled
    public static returningMsgWrapper getsingleMsg(String requestType, String Id){
        returningMsgWrapper rMSGWrapper = new returningMsgWrapper();
        wsReturnWrapper returnWrap = SNI_FL_HistoryMsgCallout.getsingleMsg(requestType, Id);
        if(returnWrap.statusCode == 200 && (returnWrap.statusMessage == null || returnWrap.statusMessage == '')){
            List<singleHistMsgWrapper> singlemsg = returnWrap.returnMsg;
            if(singlemsg != null && singlemsg.size() > 0){
                rMSGWrapper.singleMsgList = singlemsg;
                integer a = singlemsg.size();
                rMSGWrapper.ListauthorName = singlemsg[a-1].authorFirstName+' '+singlemsg[a-1].authorLastName;
                rMSGWrapper.ListDateTime = singlemsg[a-1].messageDateTime;
            }
        }
        rMSGWrapper.statusCode = returnWrap.statusCode;
        rMSGWrapper.statusMessage = returnWrap.statusMessage;
        return rMSGWrapper;
    }
    @AuraEnabled
    public static providerReturnWrapper getProviderMessages(String Id, Integer pageNumber){
        providerReturnWrapper retWrap = SNI_FL_HistoryMsgCallout.getProviderAffMessages(Id,pageNumber);
        return retWrap;
    }
}