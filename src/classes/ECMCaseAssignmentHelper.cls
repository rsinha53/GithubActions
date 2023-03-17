public with sharing class ECMCaseAssignmentHelper {

    public static final String ObjectName = 'Routing_Configuration__c';

    public ECMCaseAssignmentHelper() {
        
    }

    private static List<String> assignmentFiledList;
    private static List<String> exculdeList = new List<String> {'Topic1__c','Active__c','Department__c',
                                                                'ProfileName__c','Queue_Name__c',
                                                                 'RoleName__c','Topic_Subtype__c','Topic_Type__c','RoutingConfigurationExternalID__c'
                                                                };
    private static String assignmentFiled;
    static {
        assignmentFiled = 'SELECT ';
         Integer i = 0;
        assignmentFiledList = new List<String> ();
        for(Schema.SObjectField fldSchema : Schema.getGlobalDescribe().get(ObjectName).getDescribe().fields.getMap().values()){
             Schema.DescribeFieldResult fld = fldSchema.getDescribe();  
             String fieldName = fld.getName();
             if(fld.isCustom() ){
                
                if(!isListContains(exculdeList ,fieldName)){ 
                    assignmentFiledList.add(fieldName);
                }
                 if(i ++ > 0){
                     assignmentFiled += ',';    
                  }
                 assignmentFiled += fieldName;
                 
           }
         }
          assignmentFiled += ' FROM ' + ObjectName ;
        }

    private static boolean isListContains(List<String> listOfString,String findString){
        for(String st:listOfString) {
            if(st.equals(findString)){
                return true;
            }
        }
        return false;
    }

    public static String getConstirantValue(SObject sobj){
        String constirantValue = null;
        //String query = assignmentFiled + ' where Active__c = true  order by Priorty__c asc';
        String query = assignmentFiled + ' where IsActive__c = true  order by Priority__c asc';
        
         if(!isBasicCriteriaMatch(sobj) && !test.isRunningTest()){
            return null;
         }
        for(Routing_Configuration__c routingConfig:Database.query(query)){
            //Need to consider current login user or owner of the case
            //Find the exact value and mismatch
            //If the field values are commoon then use below mentioned code

        

            List<String> valueCheckList = getNotNulValuesForConstraints(routingConfig);
             Integer index = 0;
                for(String consField:valueCheckList) {

                    if(IsFieldAvliable(sobj,consField) && routingConfig.get(consField) == sobj.get(consField)){
                        index++;
                    }else{
                        break;
                    }
                }

                if(valueCheckList.size() == index) {
                    return routingConfig.Queue_Name__c;
                }
            
        }
        return constirantValue;
    }

 
  public static boolean isBasicCriteriaMatch(SObject sobj) {

    return false;
  }
 
 
  private static List<String> getNotNulValuesForConstraints(Routing_Configuration__c routingConfig) {
    List<String> valueCheckList = new List<String>();
    for(String consField:assignmentFiledList) {

            if(routingConfig.get(consField) != null){
                valueCheckList.add(consField);
            }
        }
        return valueCheckList;
  }

public static boolean IsFieldAvliable(SObject sobj,String consColoumn) {
    String objName = String.valueOf(sobj.getsObjectType());
    return Schema.getGlobalDescribe().get(objName).getDescribe().fields.getMap().get(consColoumn)!=null;
 }


}