/**
 * @name         :  PC_Util
 * @description  :  
 * @author       :  Bhanu Jain
 * @createddate  :  9/17/2018
 **/
public with sharing class PC_Util {
    public static Boolean isEmpty(RestRequest req){
    	if(req != null) {
    		if(req.requestBody != null) {
    			String jsonContent = req.requestBody.toString();
    			return isEmpty(jsonContent);
    		}
    	}
        return true;
        
    }
    
    public static Boolean isEmpty(String str){
        Boolean ret = str == null || str == '' ? true : false;
        return ret;
    }

    

    
    public class FieldStructure {
        Integer size;
        List<FieldDescribe> records;
    }
    public class FieldDescribe {
        String Id;
        String DeveloperName;
    }
}