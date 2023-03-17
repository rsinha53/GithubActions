public with sharing class PC_BusinessRulesUtil {
    public static String getValue(String fieldName, Map<String, Object> dataInstance, JSONContextParser parser) {
        String retVal, retVal2;
        System.debug('===Field Name> '+fieldName);
        if (fieldName.equalsIgnoreCase('Type__c')) {
            String impactLob = (String)parser.getValue('Case__r.UHC_Line_of_Business__c', dataInstance);
            String impactPlatform = (String)parser.getValue('Case__r.UHC_Platform__c', dataInstance);
            String impactLOBPlatform = (String)parser.getValue('Line_of_Business_and_Platform__c', dataInstance);
            retVal = getTypeFromData(impactLob, impactPlatform, impactLOBPlatform);
        } else if (fieldName.equalsIgnoreCase('PC_Type_of_Request__c')) {
            String urgentWhy = (String)parser.getValue('Parent.If_Urgent_why__c', dataInstance);
                retVal = getTypeOfRequestFromData(urgentWhy);
        } else if (fieldName.equalsIgnoreCase('Submitting_Department__c')) {
            String resPartnerName = (String) parser.getValue('Resolution_Partner__r.Name', dataInstance);
            String contactType = (String) parser.getValue('Case__r.UHC_Contact_Type__c', dataInstance);
            retVal = getSubmittingDepartmentFromData(resPartnerName, contactType);
        } else if (fieldName.equalsIgnoreCase('Issue_Type__c')) {
            System.debug('===Issue Type');
			String issueTypeVal = (String)parser.getValue('Issue_Type__c', dataInstance);
			retVal = getIssueTypeFromData(issueTypeVal, dataInstance, parser);
        } else if (fieldName.equalsIgnoreCase('PC_Provider_State__c')) {
             retVal = getProviderSateFromData(dataInstance, parser);
        } else if (fieldName.equalsIgnoreCase('Claim_Examples__c')) {
                retVal = getClaimExamplesFromData(dataInstance, parser);
        } 
        else if (fieldName.equalsIgnoreCase('Expected_Outcome__c')) {
                retVal = getExpectedOutcomeFromData(dataInstance, parser);
        } else if (fieldName.equalsIgnoreCase('PC_External_Contact_Name__c')){
                retVal = getExternalContactNameFromData(dataInstance, parser);
        } else if (fieldName.equalsIgnoreCase('PC_Internal_Contact_Name__c')){
                retVal = getInternalContactNameFromData(dataInstance, parser);
        } else if (fieldName.equalsIgnoreCase('PC_Contact_Type__c')) {
                retVal = getContactTypeFromData(dataInstance, parser);
        }
        return retVal;
    }
    
    // Below method retrieves picklist values from schema definition
    private static Set<String> getPicklistOptions(String objectName, String fieldName) {
        Schema.DescribeFieldResult fieldResult = Schema.getGlobalDescribe().get(objectName.toLowerCase()).getDescribe()
                                                       .Fields.getMap().get(fieldName.toLowerCase()).getDescribe();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
        Set<String> options = new Set<String>();
        
        for( Schema.PicklistEntry f : ple )
        {
            options.add(f.getValue());
        }
        return options;
    }
    
    public static String getTypeFromData(String impactLob, String impactPlatform, String impactLOBPlatform){
        Set<String> picklistValues = getPicklistOptions('Case', 'Type__c');
        String retVal, retVal2;
        if(String.isNotBlank(impactLOBPlatform)){
                retVal = impactLOBPlatform;
            }else{
                if ('Nice'.equalsIgnoreCase(impactPlatform)) {
                    retVal = 'PHS Legacy NICE';
                } else {
                    retVal = getReturnValue1FromData(impactLob);
                    retVal2 = getReturnValue2FromData(impactPlatform);
                    retVal = retVal + ' ' + retVal2;
                    if (retVal != null && retVal.equalsIgnoreCase('C&S COSMOS')) {
                        retVal = 'C&S Cosmos';
                    }
                    System.debug('===Type> '+retVal+' :: '+picklistValues.contains(retVal));
                    if (!picklistValues.contains(retVal)) {
                        retVal = 'BLANK';
                    }
                }
            }
        return retVal;
    }
    
    public static String getTypeOfRequestFromData(String urgentWhy){
        String retVal;
		if(PC_Util.isEmpty(urgentWhy)) {
                retVal = 'Project';
        }else {
            retVal = 'Escalation';
        }        
        return retVal;
    }
    
    public static String getSubmittingDepartmentFromData(String resPartnerName, String contactType){
        String evalVal;
        	if (resPartnerName != null && resPartnerName.equalsIgnoreCase('CPM Level 1')) {
                evalVal = 'FAST Field';
            } else if (resPartnerName != null && resPartnerName.equalsIgnoreCase('CPM Level 2')) {
                evalVal = 'FAST Field';
            } else if (resPartnerName != null && resPartnerName.equalsIgnoreCase('CPM-Adjustment Ready')) {
                evalVal = 'FAST Field_Pass-thru';          //US1598021
            }       
        return evalVal;
    }
    
    public static String getIssueTypeFromData(String issueTypeVal, Map<String, Object> dataInstance, JSONContextParser parser){
        String retVal;
		if(String.isNotBlank(issueTypeVal)){
				retVal = issueTypeVal;
				return retVal;
			}else{
				Object isCorrection = parser.getValue('Case__r.UHC_Is_this_a_State_Directed_Correction__c', dataInstance);
				Object isError = parser.getValue('Case__r.UHC_Is_this_in_relation_to_a_UHC_error__c', dataInstance);
				Object rootCause = parser.getValue('Case__r.Root_Cause__c', dataInstance);
				retVal = 'Unknown';
				if (isCorrection != null && ((String) isCorrection).equalsIgnoreCase('Yes')) {
					retVal = 'State Directed Update';
					return retVal;
				}
				if (isError != null && ((String) isError).equalsIgnoreCase('Yes')) {
					retVal = 'UHC Error';
					return retVal;
				}
				if (rootCause != null && (((String) rootCause).equalsIgnoreCase('Provider Error') || 
					((String) rootCause).equalsIgnoreCase('Provider Education'))) {
					retVal = 'Provider Error';
					return retVal;
				}
			}    
        return retVal;
    }
    
    public static String getProviderSateFromData(Map<String, Object> dataInstance, JSONContextParser parser){
        String retVal;
        	Object market = parser.getValue('Case__r.Markets__c', dataInstance);
            if (market != null && ((String) market).contains(';')) {
                retVal = 'National';
            }else{
                Object marketCS = parser.getValue('Markets__c', dataInstance);
                if (marketCS != null && ((String) marketCS).contains(';')) {
                retVal = 'National';
            }
            }
        return retVal;
    }
    public static String getClaimExamplesFromData(Map<String, Object> dataInstance, JSONContextParser parser){
        String retVal;
        Object data = parser.getValue('Claim_ICN', dataInstance);
        if (data != null && ((String) data).length() > 55) {
            retVal = ((String) data).left(55);
        }
        return retVal;
    }
    
    public static String getExpectedOutcomeFromData(Map<String, Object> dataInstance, JSONContextParser parser){
        String retVal;
        Object data = parser.getValue('Case__r.UHC_What_will_it_take_to_close_in_Prac_M__c', dataInstance);
        if (data != null && ((String) data).length() > 1000) {
            retVal = ((String) data).left(1000);
        }
        return retVal;
    }
    
    public static String getExternalContactNameFromData(Map<String, Object> dataInstance, JSONContextParser parser){
        String retVal;
        	String impactExternalContactNameGI = (String)parser.getValue('Case__r.UHC_Provider_Contact_Information__c', dataInstance);
            String impactExternalContactName = (String)parser.getValue('Case__r.UHC_Provider_Contact__r.Full_Name__c', dataInstance);
            system.debug('!@#impactExternalContactNameGI '+impactExternalContactNameGI +'!@#impactExternalContactName'+impactExternalContactName);
            if(PC_Util.isEmpty(impactExternalContactNameGI) && !PC_Util.isEmpty(impactExternalContactName))
            {
                system.debug('Inside Non Global'+impactExternalContactName);
                retVal = impactExternalContactName;
                
            }else if(!PC_Util.isEmpty(impactExternalContactNameGI) && PC_Util.isEmpty(impactExternalContactName))
            {
                system.debug('Inside Global Issue'+impactExternalContactNameGI);
                retVal = impactExternalContactNameGI;
            }
        return retVal;
    }
    
    public static String getInternalContactNameFromData(Map<String, Object> dataInstance, JSONContextParser parser){
        String retVal;
        	String impactInternalContactNameGI = (String)parser.getValue('Case__r.Submitter_Contact__r.Full_Name__c', dataInstance);
            String impactInternalContactName = (String)parser.getValue('Case__r.Submitter_Contact_Information__c', dataInstance);
            system.debug('!@#impactInternalContactNameGI '+impactInternalContactNameGI +'!@#impactInternalContactName'+impactInternalContactName);
            if(PC_Util.isEmpty(impactInternalContactNameGI) && !PC_Util.isEmpty(impactInternalContactName))
            {
                system.debug('Inside Non Global Internal'+impactInternalContactName);
                retVal = impactInternalContactName;
                
            }else if(!PC_Util.isEmpty(impactInternalContactNameGI) && PC_Util.isEmpty(impactInternalContactName))
            {
                system.debug('Inside Global Issue Internal'+impactInternalContactNameGI);
                retVal = impactInternalContactNameGI;
            }
        return retVal;
    }
    
    public static String getContactTypeFromData(Map<String, Object> dataInstance, JSONContextParser parser){
        String retVal;
        String preferredContactType = (String)parser.getValue('Preferred_Contact_Type__c', dataInstance);
            if(String.isNotBlank(preferredContactType) && preferredContactType =='Submitter') {
                retVal = 'Internal';
            }else if(String.isNotBlank(preferredContactType) && preferredContactType =='Provider') {
                retVal = 'External';
            }else if(String.isNotBlank(preferredContactType)) {
                retVal = preferredContactType;
            }
        return retVal;
    }
    
    public static String getReturnValue1FromData(String impactLob){
        String retVal;
        if('Employer and Individual'.equalsIgnoreCase(impactLob)){
            retVal = 'E&I';
        }
        if('Medicare and Retirement'.equalsIgnoreCase(impactLob)){
            retVal = 'M&R';
        }
        if('Community and State'.equalsIgnoreCase(impactLob)){
            retVal = 'C&S';
        }
        return retVal;
    }
    public static String getReturnValue2FromData(String impactPlatform){
        String retVal2;
        if ('PULSE'.equalsIgnoreCase(impactPlatform)) {
            retVal2 = 'OXFORD Pulse';
        } 
        else if ('CIRRUS'.equalsIgnoreCase(impactPlatform)) {
            retVal2 = 'Oxford Cirrus';
        }else {
            retVal2 = impactPlatform;
        }
        return retVal2;
    }
}