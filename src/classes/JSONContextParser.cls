/*******************************************************************
Class: JSONContextParser
Purpose: This class parses the JSON context into key(path from root) 
    and value pair.
*******************************************************************/
public class JSONContextParser {
    Map<String, Object> tempParsedPathValueMap;
    Map<String, Object> finalParsedPathValueMap;
    Object preparedStructure;
    
    public Map<String, Object> parseJSONContext(String jsonContext) {
        tempParsedPathValueMap = new Map<String, Object>();
        finalParsedPathValueMap = new Map<String, Object>();
        try {
            if (jsonContext != null && jsonContext.trim() != '') {
                Object parsedContext = JSON.deserializeUntyped(jsonContext);
                recursiveParsingComponent('', parsedContext);
                organizeComponentMap();
            }
        } catch(Exception ex) {
            System.debug('ERROR: '+ex.getMessage());
        }
        
        //return tempParsedPathValueMap;
        return finalParsedPathValueMap;
    }
    
    // Below method parse elements one by one
    private void recursiveParsingComponent(String prevPath, Object component) {
        if (prevPath != null && prevPath.trim() != '') {
            prevPath += '>';
        }
        if (getType(component) == 'List') {
            Integer i = 0;
            for (Object ins : (List<Object>) component) {
                recursiveParsingComponent(prevPath + 'INSTANCE:' + i, ins);
                i ++;
            }
        } else if (getType(component) == 'Object') {
            Map<String, Object> objectDef = (Map<String, Object>) component;
            for (String key : objectDef.keySet()) {
                recursiveParsingComponent(prevPath + key, objectDef.get(key));
            }
        } else {
            tempParsedPathValueMap.put(prevPath, component);
        }
    }
    
    private void organizeComponentMap() {
        for (String path : tempParsedPathValueMap.keySet()) {
            List<String> pathElements = path.split('>');
            Integer i = 1;
            Map<String, Object> curParsedPathValueMap;
            String prevPathEl;
            for (String pathEl : pathElements) {
                if (i == 1) {
                    curParsedPathValueMap = finalParsedPathValueMap;
                } else {
                    curParsedPathValueMap = (Map<String, Object>)curParsedPathValueMap.get(prevPathEl);
                }
                if (!curParsedPathValueMap.containsKey(pathEl) && i == pathElements.size()) {
                    curParsedPathValueMap.put(pathEl, tempParsedPathValueMap.get(path));
                } else if (!curParsedPathValueMap.containsKey(pathEl) && i < pathElements.size()) {
                    curParsedPathValueMap.put(pathEl, new Map<String, Object>());
                }
                prevPathEl = pathEl;
                i ++;
            }
        }
    }
    
    // Below method retrieves value(s) based on provided path
    public Object getValue(String path, Map<String, Object> sourceParsedPathValueMap) {
        Object res;
        List<String> pathElements = path.split('>');
        Integer i = 1;
        Map<String, Object> curParsedPathValueMap;
        String prevPathEl;
        for (String pathEl : pathElements) {
            if (i == 1) {
                curParsedPathValueMap = sourceParsedPathValueMap.clone();
            } else {
                curParsedPathValueMap = (Map<String, Object>) curParsedPathValueMap.get(prevPathEl);
            }
            if (i == pathElements.size()) {
                res = curParsedPathValueMap.get(pathEl);
            } else {
                prevPathEl = pathEl;
                i ++;
            }
        }
        return res;
    }
    

    
    // Below method returns object type.
    public string getType(Object o) {
        if(o==null) return '';              // we can't say much about null with our current techniques
        //if(o instanceof SObject)            return 'SObject'; //((SObject)o).getSObjectType().getDescribe().getName()+''; 
        if(o instanceof SObject) {
            try {
                List<SObject> sobjectList = (List<SObject>) o;
                return 'List';
            } catch(Exception ex) {
                return 'SObject';
            }
        }
        if(o instanceof Boolean)            return 'Boolean';
        if(o instanceof Id)                 return 'Id';
        if(o instanceof String)             return 'String';
        if(o instanceof Blob)               return 'Blob';
        if(o instanceof Date)               return 'Date';
        if(o instanceof Datetime)           return 'Datetime';
        if(o instanceof Time)               return 'Time';
        if(o instanceof String)             return 'String';
        if(o instanceof Integer)            return 'Integer';
        if(o instanceof Long)               return 'Long';
        if(o instanceof Decimal)            return 'Decimal';  // we can't distinguish between decimal and double
        if(o instanceof Double)             return 'Double';   // we can't distinguish between decimal and double
        if(o instanceof List<object>)       return 'List';
        
        return 'Object';                    // actually we can't detect maps and sets and maps
    }
    
    private class PropertyDefinition {
        String objectName;
        String propertyName;
        String propertyType;
        Integer propertyLength;
        String transformationRule;
    }
    
}
/* :: Test With below in Dev Console ::
String context = '[{'+
'   "OrgName": "PwC",'+
'   "Employees": [{'+
'           "First Name": "Suman",'+
'           "Last Name": "Kundu",'+
'           "Age": 31'+
'       }, {'+
'           "First Name": "Bhanu",'+
'           "Last Name": "Jain",'+
'           "Age": 33'+
'       }'+
'   ],'+
'   "EmpCount": 2'+
'}, {'+
'   "OrgName": "CTS",'+
'   "Employees": [{'+
'           "First Name": "Arun",'+
'           "Last Name": "Hazra",'+
'           "Age": 33'+
'       }, {'+
'           "First Name": "Prosenjit",'+
'           "Last Name": "Ghosh",'+
'           "Age": 27'+
'       }'+
'   ],'+
'   "EmpCount": 2'+
'}]';
JSONContextParser ins = new JSONContextParser();
Map<String, Object> parsedData = ins.parseJSONContext(context);
for (String key : parsedData.keySet()) {
    System.debug(key+' :: '+parsedData.get(key));
}
System.debug('>>'+ins.getValue('INSTANCE:0>Employees>INSTANCE:1>Last Name'));
List<Account> data = [SELECT Name, (SELECT FirstName, LastName FROM Contacts) 
                      FROM Account
                      WHERE Id IN ('0017F00000X3Rjp', '0017F0000111kOJ')];

Map<String, Object> structure = new Map<String, Object>();
structure.put('INSTANCE', new Map<String, Object>());
((Map<String, Object>) structure.get('INSTANCE')).put('Name', 'String');
((Map<String, Object>) structure.get('INSTANCE')).put('Contacts', new Map<String, Object>());
((Map<String, Object>) ((Map<String, Object>) structure.get('INSTANCE')).get('Contacts')).put('INSTANCE', new Map<String, Object>());
((Map<String, Object>) ((Map<String, Object>) ((Map<String, Object>) structure.get('INSTANCE')).get('Contacts')).get('INSTANCE')).put('FirstName', 'String');
((Map<String, Object>) ((Map<String, Object>) ((Map<String, Object>) structure.get('INSTANCE')).get('Contacts')).get('INSTANCE')).put('LastName', 'String');

System.debug(ins.prepareTransactionContent(structure, data, null));
*/