/**
 * @name         :  PC_ServiceBaseHandler
 * @description  :  An abstract base class which must be implemented by any service handler.
 * @author       :  Bhanu Jain
 * @createddate  :  9/17/2018
 **/
public with sharing abstract class PC_ServiceBaseHandler {

    /**
     * @name         :   getFieldMapping
     * @description  :   Will bring out the fields mapping from configuration.
     * @param        :   SourceSystemInfo__mdt ssiMDT
     * @return       :   List<Field_Mapping__mdt>
     * @author       :  Bhanu Jain
     * @createddate  :  9/17/2018
     * @lastmodifiedby:  
     **/ 
	protected List<Field_Mapping__mdt> getFieldMapping(SourceSystemInfo__mdt ssiMDT){
		List<Field_Mapping__mdt> fieldMappingRecords = [select is_active__c, Datatype__c,field_api_name__c, json_tag__c, SObject_Api__c,is_Required__c,
		                                                SourceSystemInfo__r.developername , DT__r.developername ,Type__c from Field_Mapping__mdt 
		                                                where sourcesysteminfo__c =:ssiMDT.Id];
		if(fieldMappingRecords.size() == 0){
			//throw NoMappingDefinedException
		}
		return fieldMappingRecords;
	}
    /**
     * @name         :   getSourceSystemInfo
     * @description  :   Will bring  the configuration info for the requester system needed for further processing
     * @param        :   Map<String, Object> parsedData, JSONContextParser parser
     * @return       :   SourceSystemInfo__mdt
     * @author       :  Bhanu Jain
     * @createddate  :  9/17/2018
     * @lastmodifiedby:  
     **/
	protected SourceSystemInfo__mdt getSourceSystemInfo(Map<String, Object> parsedData, JSONContextParser parser){
		String source = (String)parser.getValue('RequestHeader>SourceSystem', parsedData);
		String operation = (String)parser.getValue('RequestHeader>Operation', parsedData);
		String reqData = (String)parser.getValue('RequestHeader>Type', parsedData);
		//reqData = 'RESCU';
		
		List<SourceSystemInfo__mdt> ssi = [Select id,Record_Type__c, developername from sourcesysteminfo__mdt where 
		                                   Operation__c =: Operation and 
		                                   Request_Data__c =: reqData and
		                                   SystemNam__c =: source];
		if(ssi.size() == 0){
			throw new InvalidRequestHeaderException();
		}
		return ssi.get(0);
	}
    /**
     * @name         :   processRequest
     * @description  :   This will be the start from where actual processing will take place.
     * 					 Can be implemented by any handler as required.
     * @param        :   RestRequest req
     * @return       :   PC_Response
     * @author       :   Bhanu Jain
     * @createddate  :   9/17/2018
     * @lastmodifiedby:  
     **/	
	public abstract PC_Response processRequest(RestRequest req);
}