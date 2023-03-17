public class InputDataWrapper {
	
	public list<list<string>> requiredFields;
	public map<string,list<list<string>>> fieldsRequiredByParent;
	public map<string, decimal> fieldMaxLength;
	public map<string, decimal> fieldMinLength;
	public map<string, list<string>> regexToFollow;
	public map<string,validationRule> validationRuleRecords; 
	public list<string> fieldToBeDisplayAsRequired;
	public map<string,list<string>> numbersOnly;
	public map<string,list<string>> alphabetsOnly;
	public map<string,list<string>> alphaAndwildcardOnly;
	public map<string,list<string>> aplhaNumeric; 
	public map<string,list<string>> aplhaNumericwildcardOnly;
	public map<string,list<string>> dateOnly;    
	public map<string,list<string>> invalidCombinations {get; set;}
	
	public InputDataWrapper(list<list<string>> requiredFields,
						    map<string,list<list<string>>> fieldsRequiredByParent,
						    map<string, decimal> fieldMaxLength,
						    map<string, decimal> fieldMinLength,
						    map<string,validationRule> validationRuleRecords,
						    list<string> fieldToBeDisplayAsRequired,
						    map<string,list<string>> numbersOnly,
						    map<string,list<string>> alphabetsOnly,
						    map<string,list<string>> alphaAndwildcardOnly,
						    map<string, list<string>> regexToFollow,
						    map<string,list<string>> aplhaNumeric,
						    map<string,list<string>> aplhaNumericwildcardOnly,
						    map<string,list<string>> dateOnly,
						    map<string,list<string>> invalidCombinations){
		this.requiredFields = requiredFields;
		this.fieldsRequiredByParent = fieldsRequiredByParent;
		this.fieldMaxLength = fieldMaxLength; 
		this.fieldMinLength = fieldMinLength;
		this.validationRuleRecords = validationRuleRecords;
		this.fieldToBeDisplayAsRequired = fieldToBeDisplayAsRequired;
		this.numbersOnly = numbersOnly;
		this.alphabetsOnly = alphabetsOnly;
		this.alphaAndwildcardOnly = alphaAndwildcardOnly;
		this.regexToFollow = regexToFollow; 
		this.aplhaNumeric = aplhaNumeric;
		this.aplhaNumericwildcardOnly = aplhaNumericwildcardOnly;
		this.dateOnly = dateOnly;
		this.invalidCombinations = invalidCombinations;
	}
	
	
	public class validationRule{
    	public string recId {get; set;}
    	public string errorMessage {get; set;}
    	public string errorLocation {get;set;}
    	public validationRule(string recId,string errorMessage,string errorLocation){
    		this.recId = recId;
    		this.errorMessage = errorMessage;
    		this.errorLocation = errorLocation;
    	}
    }
    
}