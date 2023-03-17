public class ACETUtility {
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
        return userrolename.UserRole.Name;
    }

    public static string GetUserProfileName(){
        User profileName = [select Profile.Name from User where Id = :UserInfo.getUserId()];
        return profileName.Profile.Name;
    }

    public static string GetOrgName(Map<String, ACETOrgInstanceURLToOrgNameMap__c> OrgInstance2OrgNameMap) {
        String SFDCInstanceHostName = URL.getSalesforceBaseUrl().getHost().toLowerCase();
        system.debug(LoggingLevel.INFO, 'SFDCInstanceHostName: ' + SFDCInstanceHostName);
        String orgName;

        for(ACETOrgInstanceURLToOrgNameMap__c OrgInstance2OrgName :OrgInstance2OrgNameMap.values()) {
            if (SFDCInstanceHostName.contains(OrgInstance2OrgName.Name))    {
                orgName = OrgInstance2OrgName.Org_Name__c;
                break;
            }
        }
        //US3098067 - Avish & vishnu
        orgName=(Organization_Properties__c.getInstance(UserInfo.getProfileId()).callProductionEndpoints__c)?'prd':orgName;

        system.debug(LoggingLevel.INFO, 'OrgName: ' + orgName);

        return (Test.isRunningTest()) ? 'dev' : orgName;
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

	public static String julianFormatDate()   {
         String julianDate = '';
         Date currentDate = Date.today();
         String year = String.valueOf(currentDate.year()) ;
         String yearSplit = year.substring(year.length() - 2,year.length()) ;
         String dayOfYear = (String.valueOf(currentDate.dayOfYear()).length() == 3)  ? String.valueOf(currentDate.dayOfYear()) : '0'+String.valueOf(currentDate.dayOfYear());
         julianDate = yearSplit + dayOfYear;
         return julianDate;
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

    //Code Added By Chandan for LinkApi-Start
    //Format date in MM/DD/YYYY
    public static string formatDate(String dateStr){
        List<String> dateArr = new List<String>();
        try{
            if(String.isNotBlank(dateStr)){
                dateArr = dateStr.split('-');
            }
            String returnStr;
            if(dateArr != null && dateArr.size() > 0){
                return returnStr = dateArr[1]+'/'+dateArr[2]+'/'+dateArr[0];
            }else
                return dateStr;
        }catch(Exception e){
            System.debug('Exception occured='+e);
            return '';
        }
    }

    //Format date in YYYY-MM-DD
    public static string formatDateRequest(String dateStr){
        List<String> dateArr = new List<String>();
        try{
            if(String.isNotBlank(dateStr)){
                dateArr = dateStr.split('-');
            }
            String returnStr;
            if(dateArr != null && dateArr.size() > 0){
                return returnStr = dateArr[0]+ '-' + dateArr[1]+ '-' +dateArr[2];
            }else
                return dateStr;
        }catch(Exception e){
            System.debug('Exception occured='+e);
            return '';
        }
    }

        //Format date in YYYY-MM-DD from MM/DD/YYYY
    public static string formatDateFutureDate(String dateStr){
        List<String> dateArr = new List<String>();
        try{
            if(String.isNotBlank(dateStr)){
                dateArr = dateStr.split('/');
            }
            String returnStr;
            if(dateArr != null && dateArr.size() > 0){
                return returnStr = dateArr[2]+ '-' + dateArr[0]+ '-' +dateArr[1];
            }else
                return dateStr;
        }catch(Exception e){
            System.debug('Exception occured='+e);
            return '';
        }
    }


    public static String getAgeFromBirthday(String birthDate){
        try{
            if(String.isBlank(birthDate)) return null;
            Date d = Date.valueOf(birthDate);
            return String.valueOf(d.daysBetween(Date.today())/365);
        }catch(Exception e){
            System.debug('Exception Happened='+e);
            return null;
        }
    }
    //Code Added By Chandan for LinkApi-End
    public static Map<String, Object> checkSNiEligibilityValue(HttpResponse sniResponse ){
        string responseStr = sniResponse.getBody();
        string sniELi = '';
        Map<String, Object> sniMapResultData = new Map<String, Object>();
        if(responseStr != null && String.isNotBlank(responseStr)){
           Map<String, Object> sniMap = (Map<String, Object>)JSON.deserializeUntyped(responseStr);
            if(sniMap.containsKey('result')){
                //Code Changed By Chandan-US2345291 -Start
               Map<String, Object> sniMapResult = (Map<String, Object>)sniMap.get('result');
                if(sniMapResult!=null && sniMapResult.containsKey('data')){

                     Object[] dataResult = (Object[])sniMapResult.get('data');
                     if(dataResult!=null && dataResult.size()>0 && dataResult.get(0)!=null)
                     	sniMapResultData = (Map<String, Object>)(dataResult.get(0));
                }//Code Changed By Chandan-US2345291 -End
            }
                 //sniELi = (String)sniMapResultData.get('sniEligibility');
        }
        return sniMapResultData;

    }
     public static String getErrorMessage(String errorCode)
    {
        String errorMessage = '';
        AcetErrorMessage__mdt[] ErrorCodes = [SELECT DeveloperName, Label, Error_Message__c, Message_Type__c
                                                    FROM AcetErrorMessage__mdt
                                                    WHERE DeveloperName = :errorCode];

        if(ErrorCodes.size() > 0)
        {
            errorMessage = ErrorCodes[0].Error_Message__c;
        }

        return errorMessage;
    }
    public static boolean checkUHGPolicy(String policyId){
        Boolean isUHGPolicy = false;

        for(UHG_Restricted_Plans__mdt mt : [select Label from UHG_Restricted_Plans__mdt]){
       // if(mt.Label != null && policyId != null && integer.ValueOf(mt.Label) == integer.ValueOf(policyId)){
       // System.debug('mt.Label='+mt.Label);
       // System.debug('policyId='+policyId);
        if(mt.Label != null && policyId != null && mt.Label.equalsIgnoreCase(policyId)){
            isUHGPolicy = true;
        }
        }
       /* string uhgPolicies = label.UHGPolicies;
        if(uhgPolicies != null){
            List<string> lstUhgPol = new List<string>();
            if(uhgPolicies.contains(';')){
                lstUhgPol = uhgPolicies.split(';');
            }
            else{
                lstUhgPol.add(uhgPolicies);
            }
            for(string pol:lstUhgPol){
                if(pol.equals(policyId)){
                  isUHGPolicy = true;
                }
            }
        }*/
        return isUHGPolicy;
    }
    public static boolean checkUserUhgAccess(){
           string uId = userInfo.getUserId();
           string uhgAccess = [select UHG_Access__c from user where id =: uId].UHG_Access__c;
           if(uhgAccess == 'Yes' || uhgAccess == 'yes' || uhgAccess == 'YES'){
                   return true;
           }
        return false;
    }
	public static map<String,String> getHouseholdRelationshipMap(){
        Map<String,String> houseHoldMap=new Map<String,String>();
        for(ACETServiceRelationshipMap__c asr:[Select name,Service_Relationship__c from ACETServiceRelationshipMap__c]){
            houseHoldMap.put(asr.Service_Relationship__c, asr.name);
        }
        System.debug('houseHoldMap='+houseHoldMap);
        return houseHoldMap;
    }
	public static void insertHouseholdRelationshipData(String newRelationValue){
       List<ACETServiceRelationshipMap__c> relationShips = [SELECT Id FROM ACETServiceRelationshipMap__c Where Service_Relationship__c =:newRelationValue];
        if(relationShips.size() == 0){
        ACETServiceRelationshipMap__c asr = new ACETServiceRelationshipMap__c();
        asr.Service_Relationship__c = newRelationValue;
        asr.Name = 'Unknown';
        insert asr;
        }
    }
    public static void insertHouseholdRelationshipData(List<String> newRelationValList){
        for(String s : newRelationValList){
         List<ACETServiceRelationshipMap__c> relationShips = [Select ID From ACETServiceRelationshipMap__c Where Service_Relationship__c =:s];
        if(relationShips.size() == 0){
        ACETServiceRelationshipMap__c asr = new ACETServiceRelationshipMap__c();
        asr.Service_Relationship__c = s;
        asr.Name = 'Unknown';
        insert asr;
         }
        }
    }
    
    // US2720791 - commented the method and added a new method  - Inshar - 07/23/2020
    /*public static Boolean fetchUser(){
        // query current user information
        Set<String> allProfiles = new Set<String>();
        Boolean profileCheck=false;
        //User oUser = [select id,Name,Profile.Name FROM User Where id =: userInfo.getUserId()];
        String usrProfileName = [select u.Profile.Name from User u where u.id = :Userinfo.getUserId()].Profile.Name;
        for(Profile_Routing__mdt s:[SELECT DeveloperName, Profile_Name__c,MasterLabel  FROM Profile_Routing__mdt where MasterLabel ='SNI']){
            allProfiles.add(s.Profile_Name__c);
        }
        system.debug('usrProfileName........'+usrProfileName);
        system.debug('allProfiles........'+allProfiles);
        if(allProfiles.contains(usrProfileName)){
            profileCheck = true;
        }
        return profileCheck;
    }*/
    
    
  // US2720791 - Refactored Inshar - 07/23/2020
  public static Boolean fetchUser() {
    String usrProfileName ='';
    String loggeduser = Userinfo.getFirstName()+' '+Userinfo.getLastName();
    //Checking Automated Process
    if(loggeduser!=null  && loggeduser!='Automated Process'){
        usrProfileName = [ SELECT Profile.Name FROM User WHERE Id =: Userinfo.getUserId() ].Profile.Name;
    }
    Integer count = [ SELECT Count() FROM Profile_Routing__mdt WHERE MasterLabel = 'SNI' AND Profile_Name__c =: usrProfileName ];
    return count > 0;
    
}
    
    public static String policyRefactor(String PolicyId){
        return PolicyId.replaceFirst('^0+','').leftPad(7, '0');
    }

	public static boolean IDRefactorCheck(String linkAltID,String orsAltID){
        if(String.isNotBlank(linkAltID) && String.isNotBlank(orsAltID)){
          if(linkAltID.length()>=orsAltID.length())
              orsAltID= orsAltID.leftPad(linkAltID.length(), '0');
          else
             linkAltID= linkAltID.leftPad(orsAltID.length(), '0');
          return (linkAltID==orsAltID);
         }
      return false; //Any of the ID should not be blank or null
    }

	public static boolean compareData(String linkData,String orsData,Integer datalimit){
        if(String.isNotBlank(linkData) && String.isNotBlank(orsData) && datalimit>0){
          if(linkData.length()>datalimit)
              linkData= linkData.substring(0, datalimit);
          return (linkData==orsData);
         }
      return false; //Any of the Data should not be blank or null
    }

	Public static String getStaticResponseCheck(String memberId, String memberDOB, String memberFN, String memberLN, String memberGrpN, String searchOption,String transactionId,String orgName){
       boolean isStaticResponseChecked=false;
       String responseStr='';
       System.debug('orgName='+orgName);
       if(orgName!='prd' && !Test.isRunningTest()){
        List<AcetLinkStaticResponse__mdt> StaticResponseCheckList =[SELECT label,isAvailable__c FROM AcetLinkStaticResponse__mdt where label='GetStaticResponse' limit 1];
        if(StaticResponseCheckList!=null && StaticResponseCheckList.size()>0){
          AcetLinkStaticResponse__mdt StaticResponseCheck=StaticResponseCheckList.get(0);
          if(StaticResponseCheck!=null && StaticResponseCheck.isAvailable__c)isStaticResponseChecked=true;
        }
        if(isStaticResponseChecked){
            String searchparameter='';
            responseStr='Checked';
            System.debug('transactionId='+transactionId);
            if(transactionId!=null){
                responseStr=ACETUtility.getStaticResponse(transactionId+'_LinkExtendedResponse');
                if(String.isblank(responseStr))responseStr='Checked';
            }
            else{
                switch on searchOption {
                           when 'MemberIDNameGroupNumberDateOfBirth' {
                               searchparameter=  memberId+'_'+memberFN+'_'+memberLN+'_'+memberGrpN+'_'+memberDOB;

                           }
                           when 'MemberIDNameDateOfBirth' {
                               searchparameter=  memberId+'_'+memberFN+'_'+memberLN+'_'+memberDOB;

                           }
                           when 'MemberIDName'{
                               searchparameter=  memberId+'_'+memberFN+'_'+memberLN;
                           }
                           when 'MemberIDLastNameDateOfBirth' {
                               searchparameter=  memberId+'_'+memberLN+'_'+memberDOB;
                           }
                           when 'MemberIDFirstNameDateOfBirth'{
                               searchparameter=  memberId+'_'+memberFN+'_'+memberDOB;
                           }
                           when 'NameDateOfBirth' {
                               searchparameter=  memberFN+'_'+memberLN+'_'+memberDOB;
                           }
                           when 'MemberIDDateOfBirth'{
                               searchparameter=  memberId+'_'+memberDOB;
                           }
                           when else {
                               System.debug('default');
                           }
                        }
                   if(String.isNotBlank(searchparameter)){
                    System.debug('searchparameter='+searchparameter);
                    List<AcetLinkStaticResponse__mdt> LinkEllStaticResList =[SELECT label,isAvailable__c,FileName__c FROM AcetLinkStaticResponse__mdt where label=:searchparameter];

                     if(LinkEllStaticResList!=null && LinkEllStaticResList.size()==1){
                        AcetLinkStaticResponse__mdt LinkEllStaticRes=LinkEllStaticResList.get(0);
                        if(String.isNotBlank(LinkEllStaticRes.FileName__c))
                            responseStr=ACETUtility.getStaticResponse(LinkEllStaticRes.FileName__c);
                        if(String.isblank(responseStr))
                             responseStr='Checked';
                     }
                   else if(LinkEllStaticResList!=null && LinkEllStaticResList.size()==2){
                       responseStr='Duplicate';
                   }
                   else{
                       responseStr='Not found';
                   }
                }
             }
           }
       }
      System.debug('responseStr='+responseStr);
      return responseStr;
    }


    public Static String getStaticResponse(String StaticResourceName){
        System.debug('StaticResourceName in getStaticResponse='+StaticResourceName);
        String responseStr;
        StaticResource responseJSONSR = [SELECT Body FROM StaticResource WHERE Name = :StaticResourceName limit 1];
        //System.debug('StaticResource@@@@='+responseJSONSR);
        responseStr = responseJSONSR!=null?responseJSONSR.Body.toString():'';
        //System.debug('responseStr in getStaticResponse='+responseStr);
        return responseStr;
    }


    /* US2644969: Community - Error Handling and Logging - Implementation**/
    /*This method is used to create a application error log in case of exception along with the browser detailsof the error */
    public Static void CreateAndRedirectToError(String Application,String errorcause,Exception e) {
        String errorline =(e.getLineNumber()).format();
        String errormessage =e.getMessage();
        String errortype =e.getTypeName();
        List<LoginHistory> loginHstry = [SELECT Browser,Platform,Id,Application FROM LoginHistory Where UserId = : UserInfo.getUserId() order by LoginTime desc limit 1] ;
        String Origin = '';
        if(loginHstry.size()>0){
            Origin = loginHstry[0].Browser + '_'+ loginHstry[0].Platform;
        }
        Application_Error_Log__c err =  ACETUtility.CreateApplicationExcepLog(Origin,Application,errorcause,'',errorline,errormessage,errortype) ;
        Database.Insert(err,false) ;

    }



     // US2678265 MVP - Offshore Restriction - Implementation for Member &  Provider Interaction - Sarma
    public static boolean isOffShoreUser(){
        List<User> CurrentUser = [SELECT ID,Agent_Type__c FROM User WHERE Id = :USerInfo.getUserId()];

        if(CurrentUser.get(0).Agent_Type__c.equals('Offshore')){
            return true;
        }
        else{
            return false;
        }
    }
    // US2678265 MVP - Offshore Restriction - Implementation for Member &  Provider Interaction - Sarma
    public static List<String> getPolicyRestrictionLevel(String policyType,String searchParam){
        List<String> restrictionLevelList = new List<String>();
        final String STATIC_RESOURCE_NAME = 'ProperUseProcessedData';

        List<StaticResource> responseJSONlst = [SELECT Body FROM StaticResource WHERE Name = :STATIC_RESOURCE_NAME limit 1];

        if( responseJSONlst != null){

            if(responseJSONlst.size() > 0){

                String responseStr = responseJSONlst.get(0) != null ? responseJSONlst.get(0).Body.toString() : '';


                if(responseStr != null && String.isNotBlank(responseStr)){

                    Map<String,Object> restrictionDataMainMap = (Map<String,Object>)JSON.deserializeUntyped(responseStr);

                    if(!restrictionDataMainMap.containsKey(policyType)) {
                        return restrictionLevelList;
                    }

                    Object obj = restrictionDataMainMap.containsKey(policyType) ? restrictionDataMainMap.get(policyType) : '';

                    Map<String,Object> policyLevelRestrictionDataMap = (Map<String,Object>)JSON.deserializeUntyped(String.valueOf(obj));

                    String restrictionString = policyLevelRestrictionDataMap.containsKey(searchParam) ? String.valueOf(policyLevelRestrictionDataMap.get(searchParam)) : '' ;
                    if(restrictionString != null && String.isNotBlank(restrictionString)){
                        List<String> lstString = restrictionString.split(',');
                        for (String st : lstString){
                            if(st != null && String.isNotBlank(st)){
                                List<String> newList = new List<String>();
                                newList = st.split(':');
                                if(newList[1] == 'RS' || newList[1] == 'NP'){
                                    restrictionLevelList.add(newList[0]);
                                }
                            }
                        }
                    }
                }
            }
        }
        return restrictionLevelList;
    }
	
	//Method to format the date in mm/dd/yyyy and date time to mm/dd/yyyy h:mm a
    //If date is less than 10 or month is a single digit number then it would give in dd or MM in single digit only 
    //e.g: if todays date is 5th August 2021, then it would give 8/5/2021 
     public static String format(object dt){
      try{
        if(dt!=null) {
           if (dt instanceof Date)
            {
                 Date dt1=Date.valueof(dt);
                 return dt1.month() +'/'+dt1.day()+'/'+ dt1.year();
            }
            else if(dt instanceof Datetime){
                 Datetime dt1=Datetime.valueof(dt);
                 System.debug('dt1='+dt1);
                 //return dt1.format('MM/dd/yyyy h:mm a');
                 return dt1.month()  + '/' + dt1.day() + '/' + dt1.year() +' '+dt1.format('h:mm a');
    
            }  
        }
      }
        catch(Exception e){
           System.debug('Exception happened='+e); 
        }
       
       return null;
    } 
    
    //Method to format the date in mm/dd/yyyy and date time to mm/dd/yyyy h:mm on stictly basis
    //If date is less than 10 or month is a single digit number then it would add a zero to dd or MM to give op in two digits 
    //e.g: if todays date is 5th August 2021, then it would give 08/05/2021 
    public static String formatStrict(object dt){
      try{
        if(dt!=null) {
           if (dt instanceof Date)
            {
                 Date dt1=Date.valueof(dt);
                 String mm=dt1.month()<10?'0'+dt1.month():String.valueOf(dt1.month()) ;
                 String dd=dt1.day()<10?'0'+dt1.day():String.valueOf(dt1.day());
                 String yyyy=String.valueOf(dt1.year());
                 return mm +'/'+dd+'/'+ yyyy;
            }
            else if(dt instanceof Datetime){
                 Datetime dt1=Datetime.valueof(dt);
                 System.debug('dt1='+dt1);
                 return dt1.format('MM/dd/yyyy h:mm a');
                 //return dt1.month()  + '/' + dt1.day() + '/' + dt1.year() +' '+dt1.format('h:mm a');
    
            }  
        }
      }
        catch(Exception e){
           System.debug('Exception happened='+e); 
        }
       
       return null;
    }  
    public static Date parseDate(String myDate) {
        String[] strDate = myDate.split('/');
        Integer myIntDate;
        Integer myIntMonth;
        Integer myIntYear;
        if(strDate.size() == 1){
            strDate = myDate.split('-');
        }
        if (strDate[0].length() == 4) {
            myIntDate = integer.valueOf(strDate[2]);
            myIntMonth = integer.valueOf(strDate[1]);
            myIntYear = integer.valueOf(strDate[0]);
        }
        else {
            myIntDate = integer.valueOf(strDate[1]);
            myIntMonth = integer.valueOf(strDate[0]);
            myIntYear = integer.valueOf(strDate[2]);
        }
        Date d = Date.newInstance(myIntYear, myIntMonth, myIntDate);
        return d;
    }
   public static DateTime parseDateTime(String myDateTime) {
   String[] myDateOnly = myDateTime.split(', ');
   String[] strDate = myDateOnly[0].split('/');
   String[] strTime = myDateOnly[1].split(':');
   Integer myIntDate = integer.valueOf(strDate[1]);
   Integer myIntMonth = integer.valueOf(strDate[0]);
   Integer myIntYear = integer.valueOf(strDate[2]);
   Integer myhh = integer.valueOf(strTime[0]);
   Integer mymin = integer.valueOf(strTime[1]);
   Integer mysec = integer.valueOf(strTime[2]);
   DateTime d = DateTime.newInstance(myIntYear, myIntMonth, myIntDate,myhh,mymin,mysec);
   return d;
}

}