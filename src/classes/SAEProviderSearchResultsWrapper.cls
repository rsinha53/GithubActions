public class SAEProviderSearchResultsWrapper {
    @AuraEnabled public string benefitLevel {get;set;}
    @AuraEnabled public string taxId {get;set;}
    @AuraEnabled public string lastName {get;set;}
    @AuraEnabled public string hospAffil {get;set;}
    @AuraEnabled public string gender {get;set;}
    @AuraEnabled public string npi {get;set;}
    @AuraEnabled public string firstName {get;set;}
    @AuraEnabled public string dea {get;set;}
    @AuraEnabled public string language {get;set;}
    @AuraEnabled public string providerId {get;set;}
    @AuraEnabled public string phone {get;set;}
    @AuraEnabled public string careGroupName {get;set;}
    @AuraEnabled public string ssn {get;set;}
    @AuraEnabled public string patientReview {get;set;}
    @AuraEnabled public string providerType {get;set;}
    @AuraEnabled public string state {get;set;}
    @AuraEnabled public string speciality {get;set;}
    @AuraEnabled public string zipCode {get;set;}
    @AuraEnabled public string grpPracticeNum {get;set;}
    @AuraEnabled public string planType {get;set;}
    @AuraEnabled public string radius {get;set;}
	
	@AuraEnabled
    public static ProductCodeWrapper getSAEProductCodes(){
        ProductCodeWrapper wrapper = new ProductCodeWrapper();
        List<string> label = new List<string>();
        Map<String,SAE_Product_Code__mdt> productCodeMap = new Map<String,SAE_Product_Code__mdt>();
        List<SAE_Product_Code__mdt> productCodeList = new  List<SAE_Product_Code__mdt>();
        List<SAE_Product_Code__mdt> codesInfoList = [SELECT Id, DeveloperName, MasterLabel, From_CDB__c, Send_To_NDB__c, Label FROM SAE_Product_Code__mdt];
        for(SAE_Product_Code__mdt Info : codesInfoList){
            if(!Label.contains(Info.Label)){
                productCodeList.add(Info);
                label.add(Info.Label);
            }
            productCodeMap.put(Info.Label,Info);
        }
        wrapper.productCodeList = productCodeList;
        wrapper.productCodeMap = productCodeMap;
        return wrapper;
    }
    
    public class ProductCodeWrapper{
        @AuraEnabled public List<SAE_Product_Code__mdt> productCodeList {get;set;}
        @AuraEnabled public Map<String,SAE_Product_Code__mdt> productCodeMap {get;set;}
    }
}