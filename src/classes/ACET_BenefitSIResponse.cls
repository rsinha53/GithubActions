public class ACET_BenefitSIResponse {
      @AuraEnabled public resultWrap[] result;
    public class  resultWrap {
        @AuraEnabled public String procedureCode;	
        @AuraEnabled public String paStatus;	
        @AuraEnabled public String productType;	
        @AuraEnabled public String effectiveDate;	
        @AuraEnabled public string description;
        @AuraEnabled public String dataSource;	
        @AuraEnabled public specialInstructionsCls[] specialInstructions;
        @AuraEnabled public String remarks;	
    }
    
    public class specialInstructionsCls {
        @AuraEnabled public String key;	
        @AuraEnabled public String data {get;set;}
    }
    public static ACET_BenefitSIResponse parse(String json){
        return (ACET_BenefitSIResponse) System.JSON.deserialize(json, ACET_BenefitSIResponse.class);
    }
    
    
}