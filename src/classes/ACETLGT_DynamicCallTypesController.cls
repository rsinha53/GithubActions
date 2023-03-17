public class ACETLGT_DynamicCallTypesController {

    
    @AuraEnabled
    public static List<Swivel_Topic__c> getSwivelTopicList(String topic){
        List<Swivel_Topic__c> swt = new List<Swivel_Topic__c>();
        swt = [SELECT Call_Type__c,Account_Type__c  FROM Swivel_Topic__c WHERE Swivel_Topic__c =:topic AND Active__c = true ORDER BY Call_Type__c ASC ];

        return ACETLGT_DynamicCallTypesController.sortSwivelTopic(swt);
      
    }
    
    private static List<Swivel_Topic__c> sortSwivelTopic(List<Swivel_Topic__c> swt){
        
        //Pass values to set to remove duplicates
        Set<Swivel_Topic__c> setList = new Set<Swivel_Topic__c>(swt);

        List<Swivel_Topic__c> sortedList = new List<Swivel_Topic__c>();
        
        //Convert set to List
        for(Swivel_Topic__c e : setList){
            sortedList.add(e);
        }
              
        for(integer i = 0; i < sortedList.size(); i++) {
            if(sortedList.get(i).Call_Type__c == 'Other'){
                Swivel_Topic__c endElement = sortedList.remove(i);
                sortedList.add(endElement);
                break;
            }
		}
    	return sortedList;
    }
    
}