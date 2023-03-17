/********************************************************************************
Class Name: GenericExceptionHandler
Purpose: This class will be responsible for handling exception and perorm necessary action.
Developer: Bhanu Jain
Created On: 9/17/2018 
 ********************************************************************************/
public with sharing virtual class GenericExceptionHandler {
    public static Object handle(Exception e){
    	Object resp;
    	if(e.getTypeName().equalsIgnoreCase('InvalidRequestException') || e.getTypeName().equalsIgnoreCase('InvalidRequestHeaderException')) {
    		resp = PC_ResponseGenerator.getResponse(e);
    	}else {
    		resp = PC_ResponseGenerator.getResponse(new GenericException('Internal Server Error.')); 
    	}
    	return resp;
    }
}