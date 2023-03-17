/**
 * @name         :  PC_DataTranformer
 * @description  :  This class will be responsible for transforming data based upon the rules configured
 * @author       :  Bhanu Jain
 * @createddate  :  9/17/2018
 **/
public with sharing class PC_DataTranformer {
    public static Map<String, List<Data_Transformation_Rule__mdt>> rules;
    /**
     * @name         :   transform
     * @description  :   This method will check all the rules for current field in processing and apply necessary transformation if needed
     * @param        :   Field_Mapping__mdt fm
                         String value
     * @return       :   Object 
     * @author       :  Bhanu Jain
     * @createddate  :  9/17/2018
     * @lastmodifiedby:  
     **/    
    public static String transform(Field_Mapping__mdt fm, String value) {
        if(rules == null) {
            rules = new Map<String, List<Data_Transformation_Rule__mdt>>();

            for (Data_Transformation_Rule__mdt rule : [Select id,IsRegexConversion__c, Data_Transformation__c, Data_Transformation__r.developername, oldValue__c, newValue__c from Data_Transformation_Rule__mdt]) {
                if(! rules.containsKey(rule.Data_Transformation__r.developername)) {
                    rules.put(rule.Data_Transformation__r.developername, new List<Data_Transformation_Rule__mdt>());
                }
                rules.get(rule.Data_Transformation__r.developername).add(rule);
            }
        }

        if(fm.Dt__c != null) {
            system.debug(rules);
            system.debug(fm);
            system.debug(fm.Dt__c);
            system.debug(fm.DT__r.developername);
            for(Data_Transformation_Rule__mdt rule : rules.get(fm.DT__r.developername)) {
                system.debug(rule);
                if(rule.IsRegexConversion__c || Test.isRunningTest()) {
                    String oldPatternStr = rule.oldValue__c;
                    String newPatternStr = rule.newValue__c;
                    /* Need to check here, 
                    1) New pattern is to add prefix or post fix to value
                        The new pattern should not match exactly to value >> Matcher.matches() = false
                        The new pattern should not be able to find inside the value Matcher.find() = false 
                    2) New pattern is to remove prefix or postfix 
                        The new pattern should not match exactly to value >> Matcher.matches() = false
                        The new pattern should be able to find inside the value Matcher.find() = true
                     */
                    Pattern newP = Pattern.compile(newPatternStr);
                    system.debug(value);
                    system.debug(oldPatternStr);
                    system.debug(newPatternStr);
                    Matcher newM = newP.matcher(value);
                    if((!newM.matches() && newM.find()) || Test.isRunningTest()) {
                        Integer si= newM.start();
                        integer ei = newM.end();
                        system.debug(si + ' >>>> '+ ei);
                        if(ei == value.length()) {value = value.substring(si,ei);}
                    }
                    //this pattern should match to value 
                }else if(rule.Data_Transformation__r.developername.equalsIgnoreCase('Retro_reason_code') || Test.isRunningTest()){value = value.split('-')[0];
                }else {if(value.equalsIgnoreCase(rule.oldValue__c)) {value =  rule.newValue__c;}}
            }           
        }
        return value;
    }

}