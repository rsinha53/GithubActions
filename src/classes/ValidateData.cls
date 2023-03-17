global without sharing class ValidateData {
 
    public string typeValue{get; set;}
	
    
    webservice static String getinputswrapperStr(string typeValue){  
        string inputswrapperStr;
        set<string> types = new set<string>();  
        if(typeValue != null){
            types.addAll(typeValue.split(';'));  
        }
        map<id,Validation_Rule__c> validationRuleRecords = new map<id,Validation_Rule__c>();
        validationRuleRecords= ValidationsUtil.getValidationRuleRecords(types);
        list<InputDataWrapper> inputswrapper  = new list<InputDataWrapper>();
        if(validationRuleRecords != null && validationRuleRecords.size() > 0){
            inputswrapper = new list<InputDataWrapper>{ValidationsUtil.getInputDataWrapper(validationRuleRecords)};
            if(inputswrapper != null){
	        	inputswrapperStr = JSON.serialize(inputswrapper);
	        }
        } 
        return inputswrapperStr; 
    }
}