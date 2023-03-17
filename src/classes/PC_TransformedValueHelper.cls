public with sharing class PC_TransformedValueHelper {
    public static Map<String, String> caseFieldValueMap = new Map<String, String>();
    
    public static String updateValue(String value) {
        if(value.equalsIgnoreCase('Blank')) {
            return null;
        }
        return value;
    }
}