/********************************************************************************
Class Name: PC_ResponseGenerator
Purpose: This class will be responsible generating response for different inbound request.
Developer: Bhanu Jain
Created On: 9/17/2018 
 ********************************************************************************/
global with sharing class PC_ResponseGenerator {
	private Map<String, Object> dataInstance;
	private Map<Database.SaveResult,SObject> saveResultMap;
	private JSONContextParser parser;
	public PC_ResponseGenerator(Map<String, Object> dataInstance, Map<Database.SaveResult,SObject> saveResultMap,JSONContextParser parser) {
		this.dataInstance = dataInstance;
		this.saveResultMap = saveResultMap;
		this.parser = parser;
	}
	/**
	 * @name         :   getResponse
	 * @description  :   This method will generate response for requester after getting response information from configuration.
	 * @param        :   SourceSystemInfo__mdt ssiMDT
	 * @return       :   List<Field_Mapping__mdt>
	 * @author       :  Bhanu Jain
	 * @createddate  :  9/17/2018
	 * @lastmodifiedby:  
	 **/ 	
	public PC_Response  getResponse(SourceSystemInfo__mdt sourceSysInfoMDT){

		PC_Response res = new PC_Response();
		res.data = new List<Map<String,String>>();
		res.responseHeader = new PC_Response.ResponseHeader();
		res.responseHeader.responseStatus ='SUCCESS';

		List<Field_Mapping__mdt> fieldMappingRecords = [select is_active__c, Datatype__c,field_api_name__c, json_tag__c, SObject_Api__c,is_Required__c,
		                                                SourceSystemInfo__r.developername , DT__r.developername ,Type__c from Field_Mapping__mdt 
		                                                where sourcesysteminfo__c =:sourceSysInfoMDT.Id and Type__c = 'Outbound'];
		system.debug('saveResultMap >> '+JSON.serialize(saveResultMap));
		String SobjectToQuery = 'Case';
		for(Database.SaveResult sr : saveResultMap.keySet()) {
			if(!String.valueOf(saveResultMap.get(sr).getSobjectType()).equalsIgnoreCase(SobjectToQuery)) {
				saveResultMap.remove(sr);
			}
		}
		system.debug('saveResultMap >> '+JSON.serialize(saveResultMap));
		List<String> caseIdList = new List<String>();
		String query = 'Select ';
		for(Field_Mapping__mdt fm : fieldMappingRecords) {
			query = query + fm.field_api_name__c + ',';
		}
		query = query.substring(0,query.length()-1) + ' from '+SobjectToQuery+' where ';
		
		List<SObject> sobjInserted =saveResultMap.values();
		query = query + 'id in:sobjInserted';

		system.debug('query >> '+query);
		//res.data.add(new PC_Response.DataWrapper(fm.field_api_name__c ,insertedRecords.get(0).get(fm.field_api_name__c));
		Map<Id, Sobject> sobjectQueried = new Map<Id, Sobject>(Database.query(query));

		for(Database.SaveResult sr : saveResultMap.keySet()) {
			String msg = '';
			String status = '';
			Map<String,String> kval = new Map<String,String>();
			for(Field_Mapping__mdt fm : fieldMappingRecords) {
				object val;
				String fValue;
				String jsonTag = fm.json_tag__c;
                fValue = getFinalValue(saveResultMap,sr,sobjectQueried,fm);
				system.debug(jsonTag + ' ::: '+fValue  );
				kval.put(jsonTag , fValue);
			}	
			if(!sr.isSuccess()) {
				
		        for(Database.Error err : sr.getErrors()) {
		        	msg = msg + err.getMessage() + ' ' + err.getFields();
		        	status = status + String.valueOf(err.getStatusCode());
		        	System.debug(err.getStatusCode() + ': ' + err.getMessage());
		            System.debug(err.getFields());
		        }
				kval.put('Message' , msg);
				kval.put('Status' , status);
			}

			res.data.add(kval);
		}

		return res;

	}
    /**
	 * @name         :   getFinalValue
	 * @description  :   This method will used to get the finaly value for Field Mapping 
	 * @param        :   Database.SaveResult sr
	 * @return       :   String fValue
	 * @author       :   Ganesh Medisetti
	 * @createddate  :   9/1/2021
	 * @lastmodifiedby:  
	 **/
    public string getFinalValue(Map<Database.SaveResult,SObject> saveResultMap, Database.SaveResult sr, Map<Id, Sobject> sobjectQueried, Field_Mapping__mdt fm){
            object val;
            String fValue;
            
            if(sr.isSuccess()) {
              if(fm.json_tag__c == 'ACETInteractionId'){
                    val = sobjectQueried.get(sr.getId()).getSobject('Interaction__r').get('Name');
                }else{
                    val = sobjectQueried.get(sr.getId()).get(fm.field_api_name__c);
                }
            }else {
                val = saveResultMap.get(sr).get(fm.field_api_name__c);
            }
            if(val != null) {
                fValue = String.valueOf(String.valueOf(val));
            }
            return fValue;
        }
    
	/**
	 * @name         :   getResponse
	 * @description  :   This method will generate response for requester after getting exception information from configutaion.
	 * @param        :   SourceSystemInfo__mdt ssiMDT
	 * @return       :   List<Field_Mapping__mdt>
	 * @author       :  Bhanu Jain
	 * @createddate  :  9/17/2018
	 * @lastmodifiedby:  
	 **/	
	public static PC_Response  getResponse(Exception e){

		PC_Response res = new PC_Response();
		res.data = new List<Map<String, String>>();
		res.responseHeader = new PC_Response.ResponseHeader();
		res.responseHeader.responseStatus ='Failure';
		res.responseHeader.responseMessage = e.getMessage();
		return res;
	} 
}