public without sharing class ValidationsUtil {
    
    public static map<id,Validation_Rule__c> getValidationRuleRecords(set<string> typeVal){
        map<id,Validation_Rule__c> rules = new map<id,Validation_Rule__c>();
        rules = new map<id,Validation_Rule__c>([select id,No_Dependency__c,Min_Char_for_wild_card__c,Regex_To_Follow__c,Active__c, 
        												Restriction__c,Display_As_Required_Field__c,Dependent_Fields__c,Error_Message__c,Max_Length__c,Min_Length__c,
        												Parent_Field__c,Required_Fields__c,Type__c,Error_Location__c,Field_Not_Contains_Value__c,Fields_Contains_Value__c
								                 from Validation_Rule__c
								                 where Type__c In:typeVal AND Active__c = true]);
        return rules;
    }
    
    
     
    
    public static InputDataWrapper getInputDataWrapper(map<id,Validation_Rule__c> validationRuleRecords){
        list<list<string>> requiredFields = new list<list<string>>();
        map<string,list<list<string>>> fieldsRequiredByParent = new map<string, list<list<string>>>();
        map<string, decimal> fieldMaxLength = new map<string, decimal>();
        map<string, decimal> fieldMinLength = new map<string, decimal>();
        map<string, list<string>> regexToFollow = new map<string, list<string>>();
        list<string> fieldToBeDisplayAsRequired = new list<string>();
        map<string,list<string>> numbersOnly = new map<string,list<string>>(); 
        map<string,list<string>> alphabetsOnly = new map<string,list<string>>();
        map<string,list<string>> alphaAndwildcardOnly = new map<string,list<string>>();
        map<string,list<string>> aplhaNumeric = new map<string,list<string>>();
        map<string,list<string>> aplhaNumericwildcardOnly = new map<string,list<string>>();
        map<string,list<string>> dateOnly = new map<string,list<string>>();
        map<string,list<string>> invalidCombinations= new map<string, list<string>>();
        
        
        for(Validation_Rule__c vr : validationRuleRecords.values()){
            if(vr.Required_Fields__c != null){
                for(string reqFields : vr.Required_Fields__c.split(';')){
                    list<string> tmpLst = new list<string>();
                    for(string field : reqFields.split(',')){
                        string key = vr.id + '~' +field;
                        tmpLst.add(key);
                    }
                    requiredFields.add(tmpLst);
                }
            }
            if(vr.Parent_Field__c != null ){
                string key = vr.id + '~' +vr.Parent_Field__c;
                
                
                if(vr.No_Dependency__c){
                	list<list<string>> tmpmapValue = new list<list<string>>();
                	fieldsRequiredByParent.put(key, tmpmapValue);
                }else{
                	if(vr.Dependent_Fields__c != null){
	                    for(string childFields : vr.Dependent_Fields__c.split(';')){
	                        list<string> tmpLst = new list<string>();
	                        for(string field : childFields.split(',')){
	                            tmpLst.add(field);
	                        }
	                        
	                        if(fieldsRequiredByParent.get(key) != null){
	                            fieldsRequiredByParent.get(key).add(tmpLst);
	                        }else{
	                            list<list<string>> mapValue = new list<list<string>>();
	                            mapValue.add(tmpLst);
	                            fieldsRequiredByParent.put(key, mapValue);
	                        }
	                    }
	                    
	                }
                }
                
                
                if(vr.Max_Length__c != null){
                    fieldMaxLength.put(key,vr.Max_Length__c); 
                }
                if(vr.Min_Length__c != null){
                    fieldMinLength.put(key,vr.Min_Length__c);
                }
                
                if(vr.Regex_To_Follow__c != null){
                    list<string> tmp = new list<string>();
                    for(string s :vr.Regex_To_Follow__c.split(';') ){
                    	
                    	s = s.replaceAll('\\\\','slash');
                    	//system.assert(false,s);
                    	tmp.add(s);
                    }
                    
                    regexToFollow.put(key,tmp);
                }
                
            }
            if(vr.Restriction__c != null && vr.Parent_Field__c != null){
            	list<string> tmp = new list<string>();
                tmp.addAll(vr.Parent_Field__c.split(';'));
                
                if(vr.Restriction__c == 'Numbers Only'){
	                numbersOnly.put(vr.id,tmp);
	            }else if(vr.Restriction__c == 'Alphabets Only'){
	                alphabetsOnly.put(vr.id,tmp);
	            }else if(vr.Restriction__c == 'Alphabets and Wildcard characters only'){
                    list<string> listWithMinOfChars = new list<string>();
                    if(vr.Min_Char_for_wild_card__c != null){
                        for(string s : tmp){
                            s = s + '~' + vr.Min_Char_for_wild_card__c ;
                            listWithMinOfChars.add(s);
                        }
                    }
                    
                    if(listWithMinOfChars.size() > 0){
                        aplhaNumericwildcardOnly.put(vr.id,listWithMinOfChars);
                    }else{
                        aplhaNumericwildcardOnly.put(vr.id,tmp);
                    } 
	                
	            }else if(vr.Restriction__c == 'Alphanumeric'){
	                aplhaNumeric.put(vr.id,tmp);
	            }else if(vr.Restriction__c == 'Alphanumeric and Wildcard characters'){
                    
                    list<string> listWithMinOfChars = new list<string>();
                    if(vr.Min_Char_for_wild_card__c != null){
                        for(string s : tmp){
                            s = s + '~' + vr.Min_Char_for_wild_card__c ;
                            listWithMinOfChars.add(s);
                        }
                    }
                    
                    if(listWithMinOfChars.size() > 0){
                        aplhaNumericwildcardOnly.put(vr.id,listWithMinOfChars);
                    }else{
                        aplhaNumericwildcardOnly.put(vr.id,tmp);
                    }
	                
	            }else if(vr.Restriction__c == 'Date Only'){
	                dateOnly.put(vr.id,tmp);
	            }
            }
            
            
            
            if(vr.Display_As_Required_Field__c && vr.Parent_Field__c != null){
                fieldToBeDisplayAsRequired.addAll(vr.Parent_Field__c.split(';'));
            }
            
            if(vr.Field_Not_Contains_Value__c != null && vr.Fields_Contains_Value__c != null){
            	string key = vr.id + '~' ;
            	integer i=0;
            	for(string s : vr.Fields_Contains_Value__c.split(',')){
            		if(i==0){
            			i++;
            			key = key + s;
            		}else{
            			key = key + ',' + s;
            		}
            	}
            	
            	invalidCombinations.put(key,vr.Field_Not_Contains_Value__c.split(','));
            }
             
        }
        map<string,InputDataWrapper.validationRule> validationRules = new map<string,InputDataWrapper.validationRule>();
        for(Validation_Rule__c vr:validationRuleRecords.values()){
        	validationRules.put(vr.id,new InputDataWrapper.validationRule(vr.id, vr.Error_Message__c,vr.Error_Location__c));
        }
        
        
        InputDataWrapper wrapper = new InputDataWrapper(requiredFields,
						    							fieldsRequiredByParent,
						    							fieldMaxLength,
						    							fieldMinLength,
						    							validationRules,
						    							fieldToBeDisplayAsRequired,
						    							numbersOnly,
						    							alphabetsOnly,
						    							alphaAndwildcardOnly,
						    							regexToFollow,
						    							aplhaNumeric,
						    							aplhaNumericwildcardOnly,
						    							dateOnly,
						    							invalidCombinations); 
        
        return wrapper;
    }
    
}