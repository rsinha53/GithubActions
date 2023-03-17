/**
 * @name         :  GenericException
 * @description  :  This is a Generic custom base Exception class. 
 * 					This will give proper error messages and code for any custom exception which extends this class.
 * @author       :  Bhanu Jain
 * @createddate  :  9/17/2018
 **/
public with sharing  virtual class GenericException extends Exception{

	public override String getMessage() {
		PC_CustomException__mdt ge = [Select message__c, error_code__c from PC_CustomException__mdt where developername = :getTypeName() OR developername = :'GenericException'  limit 1];
		return ge.message__c ;
	}

}