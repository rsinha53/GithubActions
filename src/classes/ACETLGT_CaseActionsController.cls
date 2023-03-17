public class ACETLGT_CaseActionsController {
    
    @AuraEnabled
    public static Case createCase(Id InteractionId, Id SubjectId,string originator, string csetopic, string csetype, string csesubtype,Boolean migIssueChecked,Boolean escalatedChecked, Boolean complaintChecked, String disasterEpidemicValue, string srk, String comments, String autodocData, String autodocCaseItemsData,string autodocCaseComment, string caseDataWrapper,ACETLGT_HighlightPanelInfo highlightsPanelInfo,Id parentcaseid){        
    	return createCase(InteractionId, SubjectId,originator, csetopic, csetype, csesubtype,migIssueChecked, escalatedChecked, complaintChecked, disasterEpidemicValue, srk, comments, autodocData, autodocCaseItemsData,autodocCaseComment, caseDataWrapper,highlightsPanelInfo,parentcaseid,null);      
    }
    @AuraEnabled
    public static Case createCase(Id InteractionId, Id SubjectId,string originator, string csetopic, string csetype, string csesubtype,Boolean migIssueChecked,Boolean escalatedChecked, Boolean complaintChecked, String disasterEpidemicValue, string srk, String comments, String autodocData, String autodocCaseItemsData,string autodocCaseComment, string caseDataWrapper,ACETLGT_HighlightPanelInfo highlightsPanelInfo,Id parentcaseid,String bookOfBusinessTypeCode){        
        system.debug('~~~ Int Id'+InteractionId+'=====>>hlgt create case'+originator+csetopic+csetype+csetype+highlightsPanelInfo);
        system.debug('====autodocCaseComment=====>>'+autodocCaseComment);
        system.debug('parentcaseid'+parentcaseid);
        String tpRelationship = '';
        List<Interaction__c> caseIntList = [SELECT Interaction_Type__c,Originator__c,Third_Party__r.Other_Originator__c  FROM Interaction__c where Id =: InteractionId LIMIT 1];
        Interaction__c caseInt;
        if(caseIntList.size() > 0){
            caseInt = CaseIntList.get(0);
            tpRelationship = caseInt.Third_Party__r.Other_Originator__c;
            system.debug('tpRelationship :: '+tpRelationship);
            if(highlightsPanelInfo != null){
                if (highlightsPanelInfo.originatorID!=null && highlightsPanelInfo.originatorID.startsWith('003'))
                    caseInt.Originator__c = highlightsPanelInfo.originatorID;
            }
            if(caseInt != null)
                update caseInt;
        }   
       	Case newCase = new Case();        
        String devname= 'ECM';
        String profileName=[Select Id,Name from Profile where Id=:userinfo.getProfileId() LIMIT 1].Name;
        if(profileName =='ACET Motion'){
            devname= 'Motion';
        }
        //get profile specific record type
        newCase.recordTypeId = [SELECT Id, Name FROM RecordType where developerName =: devname LIMIT 1 ].Id;
        newCase.Interaction__c = InteractionId;
        // Added as part of US3223282 by Venkat
        if(profileName =='OF CSR'){
            newCase.ContactId=SubjectId;
        }

        newCase.ParentId = parentcaseid;
        newCase.ServiceLevel__c = bookOfBusinessTypeCode;
        if(caseInt != null)
            newCase.Origin = caseInt.Interaction_Type__c    ;
        if(csetype == 'Issue Resolved')
            newCase.status = 'Closed';
        else if(devname =='Motion'){
        	newCase.status = 'Working';            
        }else{
           newCase.status = 'Open';            
        }
        
        newCase.Topic__c = csetopic;
        newCase.Type__c = csetype;
        newCase.Subtype__c = csesubtype;
        //US2442061 : Migration Issue
        newCase.Migration_Issue__c=  migIssueChecked;
        //US2357303 Begin
        newCase.IsEscalated = escalatedChecked;
        newCase.Complaint__c = complaintChecked;
        //US2357303 End
        //US2470022 : Disaster / Epidemic 
        newCase.National_Disaster_Epidemic__c =  disasterEpidemicValue;
        newCase.Surrogate_Key__c = srk;
        newCase.Original_Subtype__c = csesubtype;
        newCase.Original_Type__c  = csetype;
        if(highlightsPanelInfo != null){
            newCase.Onshore_Restriction_Code__c = highlightsPanelInfo.onshoreCode != '' && highlightsPanelInfo.onshoreCode != null?highlightsPanelInfo.onshoreCode:'00';
            newCase.Onshore_Restriction__c = highlightsPanelInfo.onshoreValue != '' && highlightsPanelInfo.onshoreValue != null?highlightsPanelInfo.onshoreValue:'No';
            newCase.DOB__c  = highlightsPanelInfo.MemberDOB != '' && highlightsPanelInfo.MemberDOB != null?highlightsPanelInfo.MemberDOB:'';
            newCase.ID__c =  highlightsPanelInfo.MemberId != '' && highlightsPanelInfo.MemberId != null?highlightsPanelInfo.MemberId:'';
            newCase.Subject_Group_ID__c  = highlightsPanelInfo.GroupNumber != '' && highlightsPanelInfo.GroupNumber != null?highlightsPanelInfo.GroupNumber:'';
			newCase.Group_Name__c  = highlightsPanelInfo.GroupName != '' && highlightsPanelInfo.GroupName != null?highlightsPanelInfo.GroupName:'';
            newCase.ContactId= highlightsPanelInfo.subjectID;
            newCase.Originator_Relationship__c= highlightsPanelInfo.originatorRel;
            newCase.Subject_Type__c = 'Member'; //
            newCase.Caller__c = highlightsPanelInfo.originatorName != '' && highlightsPanelInfo.originatorName != null?highlightsPanelInfo.originatorName:'';
            newCase.Situs_State__c = (highlightsPanelInfo.situsstate!='' && highlightsPanelInfo.situsstate !=null)?highlightsPanelInfo.situsstate:''; // Added by Abhinav for US2667418 - Situs state to highlightspanel and case detail
            newCase.Service_Group__c = (highlightsPanelInfo.serviceGrp!='' && highlightsPanelInfo.serviceGrp !=null)?highlightsPanelInfo.serviceGrp:''; 
            newCase.Product_Type__c = (highlightsPanelInfo.accTypes!='' && highlightsPanelInfo.accTypes !=null)?highlightsPanelInfo.accTypes:''; 

        }
        //newCase.Situs_State__c = situsstate;
        if (newCase.Originator_Relationship__c == '' || newCase.Originator_Relationship__c == null)
            newCase.Originator_Relationship__c = tpRelationship;

        Insert newCase;  
        
        
        if(!String.isBlank(comments) && newCase != null){
            CaseComment objcc = new CaseComment();
            objcc.CommentBody = comments;
            objcc.ParentId = newCase.Id;
            insert objcc; 
        }
        if(!String.isBlank(autodocCaseComment) && newCase != null){
            CaseComment objcc = new CaseComment();
            objcc.CommentBody = autodocCaseComment;
            objcc.ParentId = newCase.Id;
            insert objcc; 
        }
        
        if(!String.isEmpty(autodocData) && autodocData != '[]'){
            addFilesToCase(newCase.Id , autodocData);                
        }
        //if(!String.isEmpty(autodocCaseItemsData)){
            addCaseItems(newCase.Id, autodocCaseItemsData);
       // }
        //  US3119834: Motion Reporting for Autodoc
       if(devname=='Motion'){
            SAECaseCreationController.createADReporting(autodocData,newCase.Id );
        }
       
        updateInitalMilestonePerofmance(newCase.Id);
        return newCase ;
    }
    
    public static void updateInitalMilestonePerofmance(Id caseId){
         system.debug('%%0508 caseid '+ caseid);
         Case cas = new case(Id = caseid,Trigger_Initial_MP_Record__c = true);
         update cas;
    }
   
    @AuraEnabled
    public static Map<string, string> getTTSFilterTopicStr(string callTopic){
        system.debug('========calltopic===='+callTopic+'----'+ACETCallTopicsPicklistUtility.getTTSFilter(callTopic));
        return ACETCallTopicsPicklistUtility.getTTSFilterMap(callTopic);
    }
    @AuraEnabled
    public static List<String> getTTSFilterMapValueStr(string callTopic, string keystr){
        //system.debug('========calltopic===='+callTopic+'----'+ACETCallTopicsPicklistUtility.getTTSFilter(callTopic));
		callTopic = String.isBlank(callTopic) ? callTopic : String.escapeSingleQuotes(callTopic); //US3636286 : Checkmarx Fix
        string caseSubtype = ACETCallTopicsPicklistUtility.getTTSFilterMap(callTopic).get(keystr);
        List<string> caseSubtypes = caseSubtype.split(';');
        //caseSubtypes.sort();
        caseSubtypes = sortAlphabetically(caseSubtypes) ;
        return caseSubtypes;
    }
    @AuraEnabled
    public static list<String> getTTSFilterMapKeyStr(string callTopic){
        //system.debug('========calltopic===='+callTopic+'----'+ACETCallTopicsPicklistUtility.getTTSFilter(callTopic));
        list<string> keylist = new list<string>();
        for(string str:ACETCallTopicsPicklistUtility.getTTSFilterMap(callTopic).keyset()){
            keylist.add(str);
        }
        keylist = sortAlphabetically(keyList) ;
        return keylist;
    }
    public static list<String> sortAlphabetically(list<String> keyList){
        list<string> stringList = new list<string>();
        list<string> outputList = new list<string>();
        map<string,string> keyMap = new map<string,string>();
        for(String str:keyList){
            keyMap.put(str.toUpperCase(), str);
        }
        for(String str:keyMap.keyset()){
            stringList.add(str);
        }
        stringList.sort();
        for(String str:stringList){
            outputList.add(keyMap.get(str));
        }
        return outputList;
    }
    @AuraEnabled
    public static list<Alert__c> getAllMemberAlerts(string memberId, string groupNumber, string intId,string bundleId){
        //system.debug('========calltopic===='+callTopic+'----'+ACETCallTopicsPicklistUtility.getTTSFilter(callTopic));
        list<Alert__c> lstMemAlert = new list<Alert__c>();
        ACETLGT_HighlightsPanelController AlertNo = new ACETLGT_HighlightsPanelController();
        lstMemAlert = AlertNo.getNoAlert('Member',memberId,groupNumber,bundleId);
        if(lstMemAlert!=null && lstMemAlert.size()>0 ){
            list<Interaction_Alert__c> lstIntAlert = new list<Interaction_Alert__c>();
            for(Alert__c varalert : lstMemAlert){
                Interaction_Alert__c intAlert = new Interaction_Alert__c();
                intAlert.Alert__c = varAlert.id;
                intAlert.Interaction__c = intId;
                intAlert.ID_Number__c = memberId;
                intAlert.Intercation_Alert_Unique_Id_del__c = String.valueof(varAlert.id)+String.valueof(intId)+ memberId;
                lstIntAlert.add(intAlert); 
            }
            try{
                upsert lstIntAlert Intercation_Alert_Unique_Id_del__c  ;
            }
            catch(DMLException e){}
    }
        return lstMemAlert;
    }
    
    
    //US1935709 : Check Type validation
    @AuraEnabled 
    public static List<ACET_Types_without_SubTypes__mdt> getOptumExlusions() {
        List<ACET_Types_without_SubTypes__mdt> typesWithoutSubtypes = new List<ACET_Types_without_SubTypes__mdt>();
        try {
            typesWithoutSubtypes = [SELECT DeveloperName,MasterLabel FROM ACET_Types_without_SubTypes__mdt];
            
        } catch(Exception e) {
            System.debug(LoggingLevel.ERROR,e.getMessage());
        } 
        return typesWithoutSubtypes;
    }
    
    
    @AuraEnabled 
    public static user getProfileUser(){
     //query current user information  
        system.debug(userInfo.getUserId());

      User oUser = [select id,Name,Agent_Type__c,Profile.Name,Profile_Name__c,Role_Name__c FROM User Where id =: userInfo.getUserId()];
        system.debug('oUser:: '+oUser);
        return oUser;
    }
    
    @AuraEnabled
    public static Boolean isSNIUser(){
        List<PermissionSetAssignment> psa = [
            SELECT AssigneeId 
            FROM PermissionSetAssignment 
            WHERE PermissionSet.Name = 'SNI_UI_Access' 
            AND AssigneeId=: UserInfo.getUserId()
        ];
        /*List<User> oUser = [
            SELECT Profile.Name 
            FROM User 
            WHERE Id =: userInfo.getUserId()
            AND ( Profile.Name = 'Family Engagement Center'
            OR  Profile.Name = 'Family Engagement Center - Read Only')
        ];*/
        return !psa.isEmpty(); // || !oUser.isEmpty() ;
    }
    @AuraEnabled 
    public static Id getTaskRecordType(String devName){
     system.debug('>>get Task rec type');
        if(String.isNotEmpty(devName) && devName=='Motion'){
           devName='Motion_Task';
        }
        else{
            String profileName=[Select Id,Name from Profile where Id=:userinfo.getProfileId()].Name;
            if(profileName!='OF CSR'){
            	devName='Polaris_Front_Office';
            }else{
              devName='OF_CSR';  
            }
        }
      recordType rt = [select id,Name,developerName FROM recordType Where developerName =:devName];
        system.debug('>>tsk rt:: '+rt);
      //Added by Prasad -US2904966: Follow up Required
        /*recordType rt;
       String profileName=[Select Id,Name from Profile where Id=:userinfo.getProfileId()].Name;
        if(profileName!='OF CSR'){
       rt = [select id,Name,developerName FROM recordType Where developerName ='Polaris_Front_Office'];
        } 
         else {
               rt = [select id,Name,developerName FROM recordType Where developerName ='OF_CSR'];  
            }  
         system.debug('>>tsk rt:: '+rt);*/
        return rt.Id;
    }
    public static void addFilesToCase(String caseId, String Autodoc){
        
        Case cId = [Select Id,CaseNumber from case where Id=:caseId];
        
        ContentVersion conVer = new ContentVersion();
        conVer.ContentLocation = 'S'; // S specify this document is in SF, use E for external files
        conVer.PathOnClient = 'autodoc.html'; // The files name, extension is very important here which will help the file in preview.
        conVer.Title = 'Autodoc '+cId.CaseNumber; // Display name of the files
        conVer.VersionData =  blob.valueof(Autodoc); // converting your binary string to Blog
        insert conVer;
        
        // First get the content document Id from ContentVersion
        Id conDoc = [SELECT ContentDocumentId FROM ContentVersion WHERE Id =:conVer.Id].ContentDocumentId;
         
        //Create ContentDocumentLink
        ContentDocumentLink cDe = new ContentDocumentLink();
        cDe.ContentDocumentId = conDoc;
        cDe.LinkedEntityId = caseId; // you can use objectId,GroupId etc
        cDe.ShareType = 'I'; 
        //cDe.Visibility = 'InternalUsers';
        insert cDe;
        
    }
    public static void addCaseItems(String caseId, String caseItemsInfo){
        case cse = [select id, Type__c, subtype__c, status from Case where id =:caseId];
        System.debug('Entering.....'+caseItemsInfo+'>>>'+cse); 
        List<Case_Item__c> caseItems = new List<Case_Item__c>();
        
        if(!String.isEmpty(caseItemsInfo)){            
            List<String> keyIds = caseItemsInfo.split('\\|');
            Map<String, String> keyIdMap = new Map<String,String>();
            
            //merge case item with same keyid, case item from sub tab overrides same case item from search page
            for(String keyId : keyIds){
                system.debug('====keyId=====>'+keyId);
                if(keyId.indexOf('::') != -1){
                    List<String> keyIdParts = keyId.split('::');
                    keyIdMap.put(keyIdParts[0], keyIdParts[1]);     
                }
            }
     
            for(String keyId : keyIdMap.keyset()){                
                Case_Item__c ci = new Case_Item__c();
                ci.Case__c = caseId;
                if(keyId.contains(';')) 
                {
                    List<String> keyIdParts = keyId.split(';');
                    ci.ExternalID__c = keyIdParts.size() > 0?keyIdParts[0]:'';
                    ci.tax_id__c = keyIdParts.size() > 0?keyIdParts[1]:'';
                    ci.Provider_Name__c = keyIdParts.size() > 2?keyIdParts[2]:'';
                }else{
                    ci.ExternalID__c = keyId;
                }
                ci.Resolved__c = Boolean.valueOf(keyIdMap.get(keyId));  
                //adding default resolved reason if Case Item is Resolved [Genesis:added10/19/2017- US793868]
                if(Boolean.valueOf(keyIdMap.get(keyId))) {                  
                    ci.Resolved_Reason__c = 'Resolved';
                }   
                // Automatically resolve case items when subtype is Issue resolved
                if(cse.status == 'Closed'){
                    ci.Resolved__c = true;
                    ci.Resolved_Reason__c = 'Resolved';
                }           
                caseItems.add(ci);
            }                        
        }else{
            //create a dummy case item
            Case_Item__c ci = new Case_Item__c();
            ci.Case__c = caseId; 
            ci.Resolved__c = true;
            //adding default resolved reason [Genesis:added10/19/2017- US793868]
            ci.Resolved_Reason__c = 'Resolved';
            caseItems.add(ci);
        } 
        if(Case_Item__c.SObjectType.getDescribe().isCreateable()) {  //code added as per the Checkmarx improvement -Rahul
          insert caseItems;    
      }         
    }
    
    @AuraEnabled
    public static String buttonAccessPCP(String userRole) {
        String allowedUser = 'false';
        
        List<Call_Topic_Access__c> accesses = (List<Call_Topic_Access__c>)ACETQueryUtil.query(null,'Call_Topic_Access__c', null, null);
        
        //system.debug('inside AUth access'+accesses.size());
        for(Call_Topic_Access__c acc : accesses){
            if(acc.Call_Topic__c == 'Create PCP Referral'){
                String roles = acc.Limit_To_Roles__c;
                system.debug('$$$$roles'+roles);
                if(roles.contains(';'))
                {
                    system.debug('$$$$multipleroles'+roles);
                    List<String> rolesList = new List<String>(roles.split(';'));
                    for(String role : rolesList){
                        if(role == userRole){
                            allowedUser = 'true';
                        }
                        system.debug('$$$$$$$'+ role + ' roles ' + userRole);
                    }
                }
                else if(String.isNotBlank(roles) && roles.containsNone(';') && roles == userRole)
                {
                    allowedUser = 'true';
                }
                
            }
            system.debug('$$$$$$$'+ acc.Call_Topic__c + 'roles ' + acc.Limit_To_Roles__c);
            
            
        } 
        return allowedUser;
    }
    
    
    @AuraEnabled
    public static String PCPCreateURL(String memberID) {
        String baseURL = String.valueof(URL.getSalesforceBaseUrl().toExternalForm());//Code Added By Chandan
        System.debug('baseURL='+baseURL);
        String orginstance;
        for(ACETOrgInstanceURLToOrgNameMap__c orgname:ACETOrgInstanceURLToOrgNameMap__c.getAll().values()) {
            system.debug('orgname.name is '+orgname.Name);
            if(baseURL.toLowerCase().contains(orgname.Name.toLowerCase())) {
                system.debug('tname '+orgname.name);
                orginstance = ACETOrgInstanceURLToOrgNameMap__c.getValues(orgname.name).Org_Name__c;
            }
        }
        if(orginstance != null){        
            system.debug('orginstance is '+orginstance);
            baseURL += ACETURLEncryptionUtility.getICUEURL(orginstance+'_ICUEPCPReferral');
        }
        
        User usr = [select FederationIdentifier from user where id=:userinfo.getUserId()];
        
        String tempBaseURL = 'subscriberId={0}&userId={1}&functionId=Pcp_Referral&landingPage=createPcpReferral&applicationId=ACET&SAML_Object= ACET'; 
        List<String> fillers = new String[]{memberID,usr.FederationIdentifier};
        tempbaseURL = String.format(tempBaseURL, fillers);
        
        system.debug('tempbaseURL is '+tempbaseURL);
        system.debug('orginstance is '+orginstance);
        system.debug('ICUE is '+orginstance+'_ICUEEncryptionKey');
        String Key = ACETWrapEncryptionKey__c.getValues(orginstance+'_ICUEEncryptionKey').Key__c;
        system.debug('Key: '+Key+'tempBaseURL: '+tempBaseURL);
        baseURL += ACETURLEncryptionUtility.GetEncryptedValue(Key,'AES256',tempBaseURL);
        system.debug('**baseURL - '+ baseURL);
        return baseURL;
    }
    @AuraEnabled
    public static string getDermURL(){
		String OrgName;
        Map<String, ISL_Webservice_Config__c> motiondermurl = ISL_Webservice_Config__c.getAll();
        Map<String, ACETOrgInstanceURLToOrgNameMap__c> OrgInstance2OrgNameMap = ACETOrgInstanceURLToOrgNameMap__c.getAll();
        OrgName = Test.isRunningTest() ? 'dev' : MotionCommonUtil.GetOrgName(OrgInstance2OrgNameMap);
        String motion_Endpoint = ''; 
        if (motiondermurl.containsKey(OrgName + '_Dermendpoint'))    {
            motion_Endpoint = motiondermurl.get(OrgName + '_Dermendpoint').Value__c;
        }
        return motion_Endpoint;
    }
 @AuraEnabled
    public static string getConsoleURL(){
		String OrgName;
        Map<String, ISL_Webservice_Config__c> motionconsoleurl = ISL_Webservice_Config__c.getAll();
        Map<String, ACETOrgInstanceURLToOrgNameMap__c> OrgInstance2OrgNameMap = ACETOrgInstanceURLToOrgNameMap__c.getAll();
        OrgName = Test.isRunningTest() ? 'dev' : MotionCommonUtil.GetOrgName(OrgInstance2OrgNameMap);
        String motion_Endpoint = ''; 
        if (motionconsoleurl.containsKey(OrgName + '_ConsoleApiEndPoint'))    {
            motion_Endpoint = motionconsoleurl.get(OrgName + '_ConsoleApiEndPoint').Value__c;
        }
        return motion_Endpoint;
    }
    @AuraEnabled
    public static string getEZCommURL(String widget,String bookOfBusiness,ACETLGT_HighlightPanelInfo highlightsPanelInfo,String memFirstName,String memLastName,string memDOB,String groupId,String memberId,Boolean landingPageOnMemberDetail) {
        System.debug('widget'+widget+'bookOfBusiness'+bookOfBusiness+'highlightsPanelInfo'+highlightsPanelInfo); 
        System.debug('memFirstName'+memFirstName+'memLastName'+memLastName+'memDOB'+memDOB+'groupId'+groupId+'memberId'+memberId+'landingPageOnMemberDetail'+landingPageOnMemberDetail);
        Map<String, ACETOrgInstanceURLToOrgNameMap__c> orgInstance2OrgNameMap = ACETOrgInstanceURLToOrgNameMap__c.getAll();
        String orgName = Test.isRunningTest() ? 'dev' : ACETUtility.GetOrgName(orgInstance2OrgNameMap);
        ACETWrapEncryptionKey__c wrapEncryptionKey = ACETWrapEncryptionKey__c.getValues(orgName + '_EZCommEncryptionKey');
        String encryptionKey = wrapEncryptionKey.Key__c;
        String algorithmName = wrapEncryptionKey.Algorithm_Name__c;
        ACETOrgNameToSwivelEndpointMap__c eZCommWrapURLMap = new ACETOrgNameToSwivelEndpointMap__c();        
        eZCommWrapURLMap =  ACETOrgNameToSwivelEndpointMap__c.getValues(orgName + '_EZCommWrapURL');
        String eZCommWrapURL = eZCommWrapURLMap.Swivel_Endpoint__c;
        System.debug(eZCommWrapURL);
        System.debug('widget'+widget+'bookOfBusiness'+bookOfBusiness+'highlightsPanelInfo'+highlightsPanelInfo);
        User userObj = [SELECT Id,federationIdentifier FROM User Where Id=:UserInfo.getUserId()];
        String idType,recipientType,contextId,productType,agentId = '';
        ACETEZCommConfig__c configParam = ACETEZCommConfig__c.getValues('EZCommAndDCHConfig');
        contextId = configParam.ContextId__c;
        productType = configParam.ProductType__c;
        idType = configParam.IdType__c;
        recipientType = configParam.RecipientType__c;
        agentId = String.isNotBlank(userObj.federationIdentifier)?userObj.federationIdentifier:'';
        String recipientJSON = getRecipientJSON(highlightsPanelInfo,idType,recipientType,memFirstName,memLastName,memDOB,groupId,memberId,landingPageOnMemberDetail);
        System.debug(recipientJSON);
        String encryptedRecipient = ACETURLEncryptionUtility.getEncryptedEZCommRecipientValue(encryptionKey, algorithmName, recipientJSON);
        system.debug(LoggingLevel.INFO, 'before encrypt: ' + recipientJSON + ', after encrypt: ' + encryptedRecipient);
        String eZCommURL = String.format(eZCommWrapURL , new List<String>{agentId,widget,contextId,productType,bookOfBusiness,encryptedRecipient}); 
        System.debug('eZCommURL'+eZCommURL);
        return eZCommURL;
    } 
    public static String getRecipientJSON(ACETLGT_HighlightPanelInfo highlightsPanelInfo,String idType,String recipientType,String memFirstName,String memLastName,string memDOB,String groupId,String memberId,Boolean landingPageOnMemberDetail) {
          String subjectId = '';
          EZCommWrapper ezcommWrapper;
          if(landingPageOnMemberDetail) {
              System.debug('member detail');
              ezcommWrapper = new EZCommWrapper();
              ezcommWrapper.firstName = checkBlankValue(memFirstName);
              ezcommWrapper.lastName = checkBlankValue(memLastName);
              ezcommWrapper.dob = formatDate(memDOB);
              ezcommWrapper.id = checkBlankValue(memberId);
              ezcommWrapper.policyNo = checkBlankValue(groupId);
          }else {
           System.debug('call topic');
          if(highlightsPanelInfo != null){
               ezcommWrapper= new EZCommWrapper();
               ezcommWrapper.dob = formatDate(highlightsPanelInfo.MemberDOB);
               ezcommWrapper.id = checkBlankValue(highlightsPanelInfo.MemberId);
               ezcommWrapper.policyNo = checkBlankValue(highlightsPanelInfo.GroupNumber);
               subjectId = checkBlankValue(highlightsPanelInfo.subjectID);
               if (String.isNotBlank(subjectId)){
                  Contact subRec = [SELECT Name, FirstName, LastName, Birthdate FROM Contact WHERE Id =:subjectId];
                  if(subRec != null) {
                    ezcommWrapper.firstName = getFirstName(subRec);
                    ezcommWrapper.lastName = getLastName(subRec);
                  }
              }  
         }
        }
        JSONGenerator gen = JSON.createGenerator(true);
           gen.writeStartObject();
           gen.writeStringField('firstName', ezcommWrapper.firstName);
           gen.writeStringField('lastName', ezcommWrapper.lastName);
           gen.writeStringField('dob', ezcommWrapper.dob);
           gen.writeStringField('id', ezcommWrapper.id);
           gen.writeStringField('policyNo', ezcommWrapper.policyNo);
           gen.writeStringField('idType', idType);
           gen.writeStringField('recipientType', recipientType);
           gen.writeEndObject();
           String recipientStr = gen.getAsString();
           System.debug(recipientStr);
           return recipientStr;
    }
    public static String getFirstName(Contact subRec) {
          String firstName = checkBlankValue(subRec.FirstName);
          return firstName;
    }
    public static String getLastName(Contact subRec) {
           String lastName =  checkBlankValue(subRec.LastName);
           return lastName;
    }
    public class EZCommWrapper {
        @AuraEnabled public String firstName{get;set;} 
        @AuraEnabled public String lastName{get;set;}  
        @AuraEnabled public String dob{get;set;}
        @AuraEnabled public String id{get;set;}
        @AuraEnabled public String policyNo{get;set;}
    }
    public static String checkBlankValue(String value) {
        return String.isNotBlank(value) ? value : '' ;
    }
	public static String formatDate(String memDOB) {
	    
		if(String.isNotBlank(memDOB)){    
			List<String> dateParts = memDOB.split('/');
			if (dateParts != null && dateParts.size() == 3) {
				return formatDateExt(dateParts);
			}else {
				return memDOB;
			}
		}
		else{
		  return '';
		}
    }
	public static String formatDateExt(list<string> dateParts) {
		String mm = dateParts[0];
		String dd = dateParts[1];
		String yyyy = dateParts[2];
		String formattedMonth,formattedDate;
		if(mm.length() > 0) {
			formattedMonth =  mm.length() == 1 ? '0'+mm:mm;
		}
		if(dd.length() > 0) {
			formattedDate =  dd.length() == 1 ? '0'+dd:dd;
		}
		return formattedMonth +'/' + formattedDate + '/' + yyyy;
	}
}