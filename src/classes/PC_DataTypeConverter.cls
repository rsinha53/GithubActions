/**
 * @name         :  PC_DataTypeConverter
 * @description  :  This class will be responsible for converting String recieved into json to necessary datatypes based on the configuration
 * @author       :  Bhanu Jain
 * @createddate  :  9/17/2018
 **/
public with sharing class PC_DataTypeConverter {
	/**
     * @name         :   convert
     * @description  :   This method will check datatype configured for current field and cast the value to that particular datatype
     * @param        :   Field_Mapping__mdt fm
 						 String value
     * @return       :   Object 
     * @author       :  Bhanu Jain
     * @createddate  :  9/17/2018
     * @lastmodifiedby:  
     **/ 	
	public static Object convert(Field_Mapping__mdt fm, String value) {
		Object returnValue = value;
		
		if(!PC_Util.isEmpty(value)) {
			if(fm.dataType__c!=null &&  fm.Type__c == 'Inbound') {
				if(fm.dataType__c.equalsIgnoreCase('Number')) {
					returnValue =  Decimal.valueOf(value);
				}else if(fm.dataType__c.equalsIgnoreCase('Text')){
					returnValue =  String.valueOf(value);
				}else if(fm.dataType__c.equalsIgnoreCase('Date')){
					returnValue =  Date.valueOf(value);
				}else if(fm.dataType__c.equalsIgnoreCase('DateTime')){
					returnValue =  DateTime.valueOf(value);
				}else if(fm.dataType__c.equalsIgnoreCase('Streaming Data')){
					returnValue =  EncodingUtil.base64Decode(value);
				}
                else if(fm.dataType__c.equalsIgnoreCase('Boolean') && (value.equalsIgnoreCase('true') || value.equalsIgnoreCase('false')) && fm.SourceSystemInfo__r.developername == 'IMPACT_FAST'){
					returnValue =  Boolean.valueOf(value);
				}
				
			}			
		}

		return returnValue;
	}
}