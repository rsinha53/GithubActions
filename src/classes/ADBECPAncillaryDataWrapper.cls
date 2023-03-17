public without sharing class ADBECPAncillaryDataWrapper {

    @AuraEnabled public AncillaryData[] ancillData{get;set;}
    
    public class AncillaryData {
        
        @AuraEnabled public String carrierName{get;set;}
        @AuraEnabled public String planName{get;set;}
        @AuraEnabled public String covRefTypeDesc{get;set;}
        @AuraEnabled public String effDate{get;set;}
        @AuraEnabled public String endDate{get;set;}
        
    }
}