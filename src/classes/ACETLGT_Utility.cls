public class ACETLGT_Utility {
    //Return SFDC Id for record type for standard or custom object
    //Parameters: Instance of SObjectType and Record type label
    public static String getRecordTypeId(SObjectType sObjectType, String recordTypeName)    {
        //Generate a map of tokens for all the Record Types for the desired object
        Map<String, Schema.RecordTypeInfo> recordTypeInfos = sObjectType.getDescribe().getRecordTypeInfosByName();
        if (!recordTypeInfos.containsKey(recordTypeName)) {
            throw new RecordTypeException('Record type "'+ recordTypeName +'" does not exist.');
        }
        //Retrieve the record type id by name
        return recordTypeInfos.get(recordTypeName).getRecordTypeId();
    }
    
    public static Id getRecordTypeID(String objectAPIName, String recordTypeName)   {
        Id recordTypeId = Schema.getGlobalDescribe().get(objectAPIName).getDescribe().getRecordTypeInfosByName().get(recordTypeName).getRecordTypeId();
        return recordTypeId;
    }
    
    public static string GetOrgName() {
        Map<String, ACETOrgInstanceURLToOrgNameMap__c> OrgInstance2OrgName = ACETOrgInstanceURLToOrgNameMap__c.getAll();
        return GetOrgName(OrgInstance2OrgName);
    }
    
    public static string GetUserRoleName()  {
        User userrolename = [select UserRole.Name from User where Id = :UserInfo.getUserId()];
        return userrolename.UserRole.Name;//'TestUser'
    }
    
    public static string GetUserProfileName(){
        User profileName = [select Profile.Name from User where Id = :UserInfo.getUserId()];
        return profileName.Profile.Name;//'TestUser'
    }    
    
    public static string GetOrgName(Map<String, ACETOrgInstanceURLToOrgNameMap__c> OrgInstance2OrgNameMap) {
        String SFDCInstanceHostName = URL.getSalesforceBaseUrl().getHost().toLowerCase(); 
        system.debug(LoggingLevel.INFO, 'SFDCInstanceHostName: ' + SFDCInstanceHostName); 
        String OrgName;
        
        for(ACETOrgInstanceURLToOrgNameMap__c OrgInstance2OrgName :OrgInstance2OrgNameMap.values()) {
            if (SFDCInstanceHostName.contains(OrgInstance2OrgName.Name))    {
                OrgName = OrgInstance2OrgName.Org_Name__c;
                break;
            }
        }
        system.debug(LoggingLevel.INFO, 'OrgName: ' + OrgName);

        return (Test.isRunningTest()) ? 'dev' : OrgName;
    }
    
    /* Method to return end point URL to swivel to external UHG system */
    public static string GetSwivelEndpointByOrgName(string SandboxName, string swivelSysName) {
        string swivelSysURL;
        string key = SandboxName + '_' +swivelSysName;
        system.debug(LoggingLevel.INFO, 'SandboxName : ' + SandboxName + 'swivelSysName ' +swivelSysName + 'key' +key );
        Map<String, ACETOrgNameToSwivelEndpointMap__c> mapEndpointDetails = ACETOrgNameToSwivelEndpointMap__c.getAll();
        swivelSysURL = GetSwivelEndpointByOrgName(SandboxName, swivelSysName, mapEndpointDetails);
        system.debug(LoggingLevel.INFO, 'swivelSysURL: ' + swivelSysURL);
        return swivelSysURL;
    }
    
    public static string GetSwivelEndpointByOrgName(string SandboxName, string swivelSysName, Map<String, ACETOrgNameToSwivelEndpointMap__c> mapEndpointDetails){
        string swivelSysURL;
        string key = SandboxName + '_' +swivelSysName;
        system.debug(LoggingLevel.INFO, 'SandboxName : ' + SandboxName + 'swivelSysName ' +swivelSysName + 'key' +key );
        if (!mapEndpointDetails.isEmpty() && mapEndpointDetails.containsKey(Key)) {
            swivelSysURL = mapEndpointDetails.get(Key).Swivel_Endpoint__c;
        }
        system.debug(LoggingLevel.INFO, 'swivelSysURL: ' + swivelSysURL);
        return swivelSysURL;
    }
    
    public static ACETDynatrace GetDynatraceJSURL() {
        
        Map<String, ACETOrgInstanceURLToOrgNameMap__c> OrgInstance2OrgNameMap = ACETOrgInstanceURLToOrgNameMap__c.getAll();
        String OrgName = Test.isRunningTest() ? 'dev' : GetOrgName(OrgInstance2OrgNameMap);
        
        ACETDynatrace oACETDynatrace = new ACETDynatrace();
        for (ISL_Webservice_Config__c WSConfig : ISL_Webservice_Config__c.getAll().values()) {
        	if (WSConfig.Name == OrgName + '_DynatraceJSURL') {
            	oACETDynatrace.srcURL = WSConfig.Value__c;
        	} else if (WSConfig.Name == OrgName + '_DynatraceConfig') {
            	oACETDynatrace.dtConfig = WSConfig.Value__c;
        	} else if (WSConfig.Name == OrgName + '_DynatraceReportURL') {
            	oACETDynatrace.reportURL = WSConfig.Value__c;
        	}
        }	
        
        system.debug(LoggingLevel.INFO, 'oACETDynatrace: ' + oACETDynatrace);
        return oACETDynatrace;
    }
    
    public static String formatDatewithslash(String dateString) {
        if (String.isBlank(dateString)) {
            return null;
        }
        
        List<String> dateParts = dateString.split('/');
        if (dateParts.size() == 3)  {
            String mm = dateParts[0];
            String dd = dateParts[1];
            String yyyy = dateParts[2]; 
            
            mm = mm.contains('0') && mm.indexOf('0') == 0 ? mm.replace('0','0') : mm ; 
            dd = dd.contains('0') && dd.indexOf('0') == 0 ? dd.replace('0','0') : dd; 
            
            return  yyyy +'-'+mm +'-' +dd;
        } else  { 
            return dateString;
        }
    }
    
    public static String formatDateYYYYMMDD(String dateString)  {
        if (String.isBlank(dateString)) {
            return null;
        }
        
        List<String> dateParts = dateString.split('-');
        if (dateParts.size() == 3) {
            String mm = dateParts[1];
            String dd = dateParts[2];
            String yyyy = dateParts[0];
            
            mm = mm.contains('0') && mm.indexOf('0') == 0 ? mm.replace('0','0') : mm ; 
            dd = dd.contains('0') && dd.indexOf('0') == 0 ? dd.replace('0','0') : dd; 
            
            return  yyyy +'-'+mm +'-' +dd;
        } else  {
            return dateString;
        }
    }
    
    public static String formatDateFromDashToSlash(String dateString)   {
        if (String.isBlank(dateString)) {
            return null;
        }
        
        List<String> dateParts = dateString.split('-');
        if (dateParts.size() == 3) {
            String mm = dateParts[1];
            String dd = dateParts[2];
            String yyyy = dateParts[0];
            
            mm = mm.contains('0') && mm.indexOf('0') == 0 ? mm.replace('0','') : mm ; 
            dd = dd.contains('0') && dd.indexOf('0') == 0 ? dd.replace('0','') : dd; 
                                   
            return mm  + '/' + dd + '/' + yyyy;
        } else  {
            return dateString;
        }
    }        
    
    public static Application_Error_Log__c CreateApplicationErrorLog(String Origin, String Application, String Endpoint, String StatusMessage, 
         Integer StatusCode) {
        Application_Error_Log__c AppErrorLog = new Application_Error_Log__c();
        AppErrorLog.Origin__c = Origin;
        AppErrorLog.Application__c = Application;
        AppErrorLog.Endpoint__c = Endpoint;
        AppErrorLog.Status_Message__c = StatusMessage;
        AppErrorLog.Status_Code__c = StatusCode;
        return AppErrorLog;
    }
    
    public static Application_Error_Log__c CreateApplicationExcepLog(String Origin, String Application, String errorcause, String StatusMessage,String errorline, String errormessage, String errortype) {
        Application_Error_Log__c AppErrorLog = new Application_Error_Log__c();
        AppErrorLog.Origin__c = Origin;
        AppErrorLog.Application__c = Application;
        AppErrorLog.Error_Cause__c = errorcause;
        AppErrorLog.Error_Line__c = errorline;
        AppErrorLog.Error_Message__c = errormessage;
        AppErrorLog.Error_Type__c = errortype;
        AppErrorLog.Status_Message__c = StatusMessage;
        
        return AppErrorLog;
    }
    
    public static Attachment CreateAttachment(Id AppErrorLogId, String Name, String Body) {
        Attachment oAttachment = new Attachment();
        oAttachment.ParentId = AppErrorLogId;
        oAttachment.Name = Name;
        oAttachment.Body = Blob.valueof(Body);
        return oAttachment;
    }
    
    public Static String getConsumerDashURL(String policynum , string memberId , String firstName , string lastName) {
        String tempBaseURL ;
        tempBaseURL = String.valueof(URL.getSalesforceBaseUrl().toExternalForm()) + geICUEURL() + 'cdbXrefId=780991&cdbXrefIdPartitionNumber=91&policy=';
        tempBaseURL = tempBaseURL + policynum+'&subscriberId=';
        tempBaseURL = tempBaseURL + memberId+'&firstName='; 
        tempBaseURL = tempBaseURL + firstName+'&lastName=';
        tempBaseURL = tempBaseURL + lastName+'&functionId=Consumer_Dashboard&landingPage=consumerDashboard';
        system.debug(LoggingLevel.INFO, 'tempbaseULR' + tempBaseURL);
        return tempBaseURL ;
    }
        
    public Static String geICUEURL(){
        ACETOrgNameToSwivelEndpointMap__c wrapURL = ACETOrgNameToSwivelEndpointMap__c.getValues('d1_ICUEConsumerDashboard');
        String icueURL = wrapURL.Swivel_Endpoint__c;
        return icueURL ;
        
    }
    
    public static String formatMMDDYYYYwithSlashToYYYYMMDDwithDash(String dateWithSlash){
        String[] temp = dateWithSlash.split('/');
        String dateYYYYMMDD = temp[2] + '-' + temp[0] + '-' + temp[1];
        return dateYYYYMMDD;
    }     
    
    public static String getAgentTypeById(Id UserRecordId) {
        User userInfo = [SELECT Agent_Type__c FROM User WHERE Id =:UserRecordId];
        return userInfo.Agent_Type__c;
    }
    
    public static String escapeHtml(String val){
        if(String.isBlank(val)) return '';
        return val.escapeHtml3();
    }
    
    public class RecordTypeException extends Exception { }
}