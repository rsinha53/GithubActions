public class ACETAlertTriggerHandler {
    
    //	DE335467 : prevent user being able to insert/update duplicate alerts : 10-July-2020 : Madhura
    public static void preventDuplicates() {
        
         
        FieldValues fieldValues = getFieldValuesFromRecordsString(Trigger.New);
        List<String> allKeys = new List<String>(fieldValues.allValues);
        Set<String> duplicateKeys = fieldValues.duplicateValues;
        
        
        
        if(Trigger.New.size()>1){
            //find duplicates within inserted/updated records
            findDuplicatesAndThrowError(new Map<Id,Alert__c>([
                SELECT Effective_Date__c, End_Date__c,Key__c,Group_Number__c 
                FROM Alert__c 
                WHERE Key__c In: duplicateKeys 
                AND ID in: Trigger.New
            ]));
        }
        duplicateKeys = null;
        //find duplicates with inserted/updated records and existing records
        findDuplicatesAndThrowError(new Map<Id,Alert__c>([
            SELECT Effective_Date__c, End_Date__c,Key__c,Group_Number__c 
            FROM Alert__c 
            WHERE Key__c In: allKeys 
            AND ID NOT IN: Trigger.New
        ]));
        
		allKeys =null;
    }
    
    //To find Duplicate records and Throw Error on duplicate record
    public static void findDuplicatesAndThrowError(Map<Id,Alert__c> alertsMap){        
        
        if(alertsMap.size()>0){
            Map<String,String> keysToAlertIdsMap = new Map<String,String>();
            Date minEffectiveDate = Date.newInstance(5500, 1, 1);
            Date maxEndDate = Date.newInstance(1600, 1, 1);
            for(Alert__c alertObj: alertsMap.values()){
                    keysToAlertIdsMap.put(alertObj.Key__c,keysToAlertIdsMap.get(alertObj.Key__c)!=null?
                                          keysToAlertIdsMap.get(alertObj.Key__c)+','+alertObj.Id : alertObj.Id);
                    minEffectiveDate = minEffectiveDate<alertObj.Effective_Date__c?minEffectiveDate:alertObj.Effective_Date__c;
                    maxEndDate = maxEndDate>alertObj.End_Date__c?maxEndDate:alertObj.End_Date__c;
            }
            // comparing for matching records and preventing duplicates
            for(Alert__c alert : [SELECT Key__c,Effective_Date__c,End_Date__c,Group_Number__c
                                  FROM Alert__c 
                                  WHERE Id IN:Trigger.New 
                                  AND Key__c IN:keysToAlertIdsMap.keySet()
                                  AND Effective_Date__c <= :maxEndDate
                                  AND End_Date__c >= :minEffectiveDate
                                 ])
            {
                if(keysToAlertIdsMap.containsKey(alert.Key__c)){
                    List<String> existingIds = keysToAlertIdsMap.get(alert.Key__c).split(',');
                    for(String existingId : existingIds){
                        if(existingId!=null && existingId!=alert.Id){
                            Alert__c exAlert = alertsMap.get(existingId);
                            if(((alert.Effective_Date__c >= exAlert.Effective_Date__c 
                                 && alert.Effective_Date__c <= exAlert.End_Date__c) ||
                                (alert.Effective_Date__c <= exAlert.Effective_Date__c 
                                 && alert.End_Date__c >= exAlert.Effective_Date__c))){
                                     Trigger.NewMap.get(alert.Id).addError('This is a duplicate entry.  An alert already exists.');
                                 }
                            exAlert =null;
                        }
                        
                    }
                    existingIds = null;
                }
            }
            keysToAlertIdsMap =null;
            minEffectiveDate = null;
            maxEndDate = null;
        }
        alertsMap=null;        
    }
    
    
    //To get only key field from record without looping on each record
    public static FieldValues getFieldValuesFromRecordsString(List<Alert__c> records){ 
        Set<String> keys = new Set<String>();
        Set<String> duplicate = new Set<String>();
        for(Alert__c alertObj : records){
            if(keys.contains(alertObj.Key__c)){
                duplicate.add(alertObj.Key__c);
            }
            else{
                keys.add(alertObj.Key__c);
            }
        }
            FieldValues fieldValues = new FieldValues();
            fieldValues.allValues = keys;
            fieldValues.duplicateValues = duplicate;
            return fieldValues;
    }
	
    //To get only repeated elements in list provided
    public static Set<String> getDuplicates(List<String> originalList,String keyWord){
        originalList.sort();
        Set<String> uniqueList = new Set<String>(originalList);
        Set<String> duplicateList = new Set<String>();
        if(uniqueList.size()!=originalList.size()){
            Integer differenceCount = originalList.size() - uniqueList.size();
            String listString = String.join(originalList,keyWord)+keyWord;
            String setString = String.join(new List<String>(uniqueList),keyWord)+keyWord;
            Integer differenceStartPosition = listString.indexOfDifference(setString);
            
            while(differenceStartPosition!=-1 && duplicateList.size()<differenceCount && listString.length()>0){
                listString = listString.substring(differenceStartPosition,listString.length());
                setString  = setString.substring(differenceStartPosition,setString.length());
                String duplicateElement = listString.substring(0, listString.indexOf(keyWord));
                duplicateList.add(duplicateElement);  
                listString = listString.replaceAll(duplicateElement+keyWord, '');
                setString  = setString.replaceAll(duplicateElement+keyWord, '');
                differenceStartPosition = listString.indexOfDifference(setString);
            }
        }
        return duplicateList;
    }
    
    class FieldValues{
        Set<String> allValues;
        Set<String> duplicateValues;
    }
}