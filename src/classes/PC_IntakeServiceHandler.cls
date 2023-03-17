/**
 * @name         :  PC_IntakeServiceHandler
 * @description  :  This class will be responsible for handling opreation in IntakeService.
 * @author       :  Bhanu Jain
 * @createddate  :  9/17/2018
 **/
public with sharing class PC_IntakeServiceHandler extends PC_ServiceBaseHandler{

	/**
     * @name         :   processRequest
     * @description  :   This method will be the start of request processing.
     * 					 Any handler extending PC_ServiceBaseHandler have to implement this function.
     * @param        :   RestRequest req
     * @return       :   PC_Response
     * @author       :   Bhanu Jain
     * @createddate  :   9/17/2018
     * @lastmodifiedby:  
     **/ 
	public  override PC_Response processRequest(RestRequest req){
		String jsonBody;
		String respBody;
		PC_Response rcResponse;
		try{
			if(PC_Util.isEmpty(req)){
				throw new InvalidRequestException();
			}
			
			jsonBody= req.requestBody.toString();
			//jsonBody = '{ "Data" : [ { "Id" : "a0eK0000004MJkLIAW", "Case__r.UHC_Provider_Contact__r.Phone" : "(833) 456-9991", "Case__r.UHC_Provider_Contact__r.Full_Name__c" : "Suman Kundu", "Case__r.UHC_Submitter_Contacts_Provider_at_Close__c" : "false", "Case__r.UHC_R_Code__c" : null, "Case__r.UHC_Submitter_Received_Date__c" : "2018-10-03 00:00:00", "Case__r.CaseNumber" : "00672437", "Case__r.Submitter_Contact__r.Full_Name__c" : "Bhanu Jain", "Case__r.UHC_System_Reference_Update_ID__c" : null, "Case__r.UHC_What_will_it_take_to_close_in_Prac_M__c" : "NA", "Resolution_Partner__r.Name" : "CPM1", "Case__r.UHC_Is_this_a_State_Directed_Correction__c" : null, "Case__r.UHC_Platform__c" : "Cosmos", "Case__r.Account.Organization_Type__c" : "ACO", "Case__r.Root_Cause__c" : null, "Case__r.Submitter_Contact__r.Email" : "bhanu.p.jain@email.com", "Case__r.Markets__c" : "Alabama", "Case__r.UHC_Related_to_a_Provider_System_Update__c" : "false", "Case__r.Subject" : "SUBJECT", "Case__r.Account_TIN__c" : "009002322", "Case__r.UHC_Is_this_in_relation_to_a_UHC_error__c" : null, "Case__r.UHC_Line_of_Business__c" : "Employer and Individual", "Case__r.Account.Name" : "Nick ACET Provider", "Case__c" : "500K000000GR2ZSIA1", "Case__r.Submitter_Contact__r.Phone" : "(988) 123-8802", "Case__r.UHC_Provider_Contact__r.Email" : "suman.k@pwc.com" } ], "RequestHeader" : { "Operation" : "PUSH", "Type" : "CPM", "SourceSystem" : "IMPACT" } }';
			//jsonBody = '{ "Data" : [ { "Id" : "500K000000GR7KfIAL", "Parent.If_Urgent_why__c" : null, "Description" : null, "Date_Submitted_to_PCDM__c" : "2018-10-04 00:00:00", "CaseNumber" : "00672457", "Parent.Account.Region__c" : "Central", "Synergy_RNOP__c" : null, "LOBs__c" : null, "Parent.Account.Name" : "Nick ACET Provider", "Parent.Delegated__c" : "false", "Phycon__c" : "PR-4664563", "Owner.Name" : "whitesell", "MPINs_in_Project__c" : null, "Account_TIN__c" : "009002322", "Subject" : null, "Parent.Account.State__c" : "MN", "Parent.Priority" : "Standard" }, { "Id" : "500K000000GREfuIAH", "Parent.If_Urgent_why__c" : null, "Description" : "DESC", "Date_Submitted_to_PCDM__c" : "2018-10-08 00:00:00", "CaseNumber" : "00672464", "Parent.Account.Region__c" : "Central", "Synergy_RNOP__c" : null, "LOBs__c" : "C&S", "Parent.Account.Name" : "Nick ACET Provider", "Parent.Delegated__c" : "false", "Phycon__c" : "PR-0000491", "Owner.Name" : "suman", "MPINs_in_Project__c" : "1", "Account_TIN__c" : "009002322", "Subject" : "SUB777", "Parent.Account.State__c" : "MN", "Parent.Priority" : "Project" } ], "RequestHeader" : { "Operation" : "PUSH", "Type" : "RESCU", "SourceSystem" : "IMPACT" } }';
			//jsonBody = '{	"Data": [{		"GName": "Test-GP",		"PName": "TestP",		"C1Name": "Test-C1",		"P1Name": "TestP1",		"C2Name": "Test-C2"	}],	"RequestHeader": {		"Operation": "PUSH",		"Type": "POCINSERT",		"SourceSystem": "POC"	}}';
			system.debug('jsonBody >> '+jsonBody);
			JSONContextParser parser = new JSONContextParser();
			Map<String, Object> parsedData = parser.parseJSONContext(jsonBody);
			//Get System Request Info from configuration
			SourceSystemInfo__mdt sourceSysInfoMDT = getSourceSystemInfo(parsedData, parser); 
			//Get getFieldMapping from configuration
			List<Field_Mapping__mdt> fieldMappings = getFieldMapping(sourceSysInfoMDT);
			//below is the data which will be processed to insert records
			Map<String, Object> dataSet = (Map<String, Object>) parser.getValue('Data', parsedData);
			
			//Here call DataManageMentService to insert records
			Map<Database.SaveResult,SObject> saveResultMap = PC_DataManagementService.insertData(sourceSysInfoMDT,fieldMappings,dataSet,parser);
			system.debug('insertedRecords '+saveResultMap);
			
			//Below for rescu only. this must be removed and should come from configuratio.
			PC_ResponseGenerator rGenerator = new PC_ResponseGenerator(dataSet, saveResultMap, parser);
			rcResponse = rGenerator.getResponse(sourceSysInfoMDT);
			
		}catch(Exception e){
			system.debug('Exception in : '+e.getStackTraceString());
			throw e;
		}
		return rcResponse;

	}

}