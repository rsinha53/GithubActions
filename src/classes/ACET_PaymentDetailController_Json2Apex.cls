public class ACET_PaymentDetailController_Json2Apex {
    
    public List<Payments> payments;
    
    public class PayeeAddress {
        public String addressLine1;
        public String city;
        public String state;
        public String zip;
    }
    
    public class Payments {
        public String paymentIssueDt;
        @AuraEnabled public String checkNbr;
        public String checkAmt;
        @AuraEnabled public String checkEFTIndicator;
        @AuraEnabled public String chkSrsDesg;
        @AuraEnabled public String checkStatus;
        public String draftAmt;
        public String draftNbr;
        public String cashedDt;
        public String payeeTypeCode;
        public String payeeNm;
        // US3476420
        @AuraEnabled public String paymentType;
        public PayeeAddress payeeAddress;
    }
    
    
    public static ACET_PaymentDetailController_Json2Apex parse(String json) {
        return (ACET_PaymentDetailController_Json2Apex) System.JSON.deserialize(json, ACET_PaymentDetailController_Json2Apex.class);
    }
}