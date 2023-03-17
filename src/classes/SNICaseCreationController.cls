/**
@Desc: TTS Modal Case Creation Controller. A new file created!
@Date: 01-08-2019

**/
public class SNICaseCreationController {

    static final String CASE_RECORD_TYPE_SAE_PROVIDER = 'SAE Provider';
    static final String NONE_OPTION = '--None--';

    /**
    @Desc: Get the Type List based on the Call Topic
    **/
    @AuraEnabled
    public static list<String> getTTSFilterMapKeyStr(string callTopic){
        system.debug('========calltopic===='+callTopic+'----'+ACETCallTopicsPicklistUtility.getTTSFilter(callTopic));
        list<string> keylist = new list<string>();
        for(string str:ACETCallTopicsPicklistUtility.getTTSFilterMap(callTopic).keyset()){
            keylist.add(str);
        }
        return keylist;
    }
    @AuraEnabled
    public static Map<String,String> GetAvailableRecordTypeAccount()
    {
        Map<String,String> recordTypeMap = new Map<String,String>();
        Schema.DescribeSObjectResult R = Account.SObjectType.getDescribe();
        List<Schema.RecordTypeInfo> RT = R.getRecordTypeInfos();

        for(RecordType rec : [SELECT Id,  Name, DeveloperName, Description FROM RecordType WHERE SobjectType = 'Case']) {
            recordTypeMap.put(rec.Id, rec.Name);
        }
        return recordTypeMap;
    }
    /**
    @Desc: Get the Sub Type List based on the Call Topic and selected Type
    **/
    @AuraEnabled
    public static List<String> getTTSFilterMapValueStr(string callTopic, string keystr){
        system.debug('========calltopic===='+callTopic+'----'+ACETCallTopicsPicklistUtility.getTTSFilter(callTopic));
        string caseSubtype = ACETCallTopicsPicklistUtility.getTTSFilterMap(callTopic).get(keystr);

        // US2091974 - Sanka - Case Creation
        //List<string> caseSubtypes = caseSubtype.split(';');
        List<String> caseSubtypes = new List<String>();
        if(caseSubtype != null){
            caseSubtypes = caseSubtype.split(';');
        }
        return caseSubtypes;
    }
    @AuraEnabled
    public static List<String> getParentCaseFields(Id caseId){
        List<String> caseVal = new List<String>();
        if(caseId !=null){
            List<Case> cseLst = [SELECT ID ,Topic__c,Original_Type__c,Original_Subtype__c FROM CASE WHERE id =: caseId];
            if(cseLst.size()>0){
            caseVal.add(cseLst[0].Topic__c);
            caseVal.add(cseLst[0].Original_Type__c);
            caseVal.add(cseLst[0].Original_Subtype__c);
            }
        }
       return  caseVal;
    }
    // US2526182: SNI Core - Select Policy when creating a new case - Vishal Yelisetti|04/25/2020
    @AuraEnabled
    public static List<String> getMemberIDs(Id caseId) {
        List<Case> lsCase = [ SELECT ContactId FROM Case WHERE id =: caseid ];
        User currentUser = [SELECT UHG_Access__c, Agent_Type__c FROM User WHERE Id =: UserInfo.getUserId() LIMIT 1];
        String uhgAccessUser = currentUser.UHG_Access__c;
        String agentTypeUser = currentUser.Agent_Type__c; 
        Set<String> uhgAccessSet = new Set<String>();
        Set<String> agentTypeAccessSet = new Set<String>();
        if (uhgAccessUser == 'Yes') {
            uhgAccessSet.add('Yes');
        }
        uhgAccessSet.add('No');
        if (agentTypeUser == 'Onshore') {
            agentTypeAccessSet.add('Yes');
        }
        agentTypeAccessSet.add('No');
       	List<AccountContactRelation> lsACR = [ SELECT Account.Member_ID__c, Account.Policy_ID__c FROM AccountContactRelation WHERE ContactId =: lsCase.get(0).ContactId 
												AND Account.UHG_Restriction__c IN: uhgAccessSet AND Account.Onshore_Restriction__c IN: agentTypeAccessSet];
        List<String> memList = new List<String>();
        memList.add(NONE_OPTION);
        if (!lsACR.isEmpty() && lsACR.size() > 0) {
			for(AccountContactRelation acr : lsACR) {
                if (acr.Account.Member_ID__c != null && acr.Account.Policy_ID__c != null)
            		memList.add(acr.Account.Member_ID__c + ' - ' + acr.Account.Policy_ID__c);
        	}
        }
        return memList;
    }
	// US2964058: CHS - Add fields to Case Detail record
    @AuraEnabled
    public static Account getAccountInfo(Id caseId) {
        List<Case> lsCase = [ SELECT ContactId FROM Case WHERE id =: caseid ];
       	List<AccountContactRelation> lsACR = [SELECT id,AccountId FROM AccountContactRelation WHERE ContactId =: lsCase.get(0).ContactId Limit 1];
        if (!lsACR.isEmpty() && lsACR.size() > 0) {
			List<Account> accList = [SELECT Policy_ID__c,OwnerId,Owner.Name,Line_of_Business__c,Service_Group__c,Product_Type__c FROM Account WHERE Id =: lsACR.get(0).AccountId ];
       		if (!accList.isEmpty() && accList.size() > 0) {
                return accList.get(0);
        	 }
        }
        return null;
    }
   // US2526182: SNI Core - Select Policy when creating a new case - Vishal Yelisetti|04/25/2020
   //Modification History: Code Modified By Chandan for -US2556134
   //Owner Id added 
    @AuraEnabled
    public static Account getGroupId(String memberID, String policyID) {
		Id familyRecordTypedID = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Family').getRecordTypeId(); // added by Cherry so that we only get Account Owner of Family Account
        List<Account> accList = [ SELECT Policy_ID__c,OwnerId,Owner.Name,Line_of_Business__c,Service_Group__c,Product_Type__c FROM Account WHERE Member_ID__c =: memberID and Policy_ID__c =:policyID and RecordTypeId =: familyRecordTypedID];
        if (!accList.isEmpty() && accList.size() > 0) {
        	return accList.get(0);
        }
        return null;
    }
    /**
    @Desc: US1875495 : Case creation
    **/
    //US1970508 - Ravindra
    @AuraEnabled
    public static String saveTTSCase(String strRecord, Boolean isProvider) {

        System.debug('####RAW-REC:'+strRecord);

        String strCreatedCaseId = '';

        try{

            SAETTSCaseWrapper caseWrapper = (SAETTSCaseWrapper)JSON.deserialize(strRecord, SAETTSCaseWrapper.class);
        	RecordType recordType = [ SELECT Id, Name FROM RecordType WHERE sObjectType='case' AND name =: CASE_RECORD_TYPE_SAE_PROVIDER ];
            User userDetails =[SELECT Id, UserRole.Name FROM User where Id =: UserInfo.getUserId()];

        	Case caseObj = new Case();

            String strCaseStatus = 'Open';  // US2148602 - Case Creation - Status of Case Open : Removing 2nd condition - 28/10/2019 - Sarma.
            if(caseWrapper.AddInfoOrginType.equals('Issue Resolved')){
                strCaseStatus = 'Closed';
            }

            // US1753077 - Pilot Enhancement - Save Case - Validations and Additional Functionality: Kavinda - START
            // Here need to change Topic Type Based on the change which will be given today's scrumm - 2019/09/30
            if(caseWrapper.AddInfoOrginType.equals('System Unavailable')){
                if(caseWrapper.CaseCreationFrom != NULL && caseWrapper.CaseCreationFrom.equals('Member_Snapshot_Policies') ){
                    if(caseWrapper.PolicyCount != NULL && caseWrapper.PolicyCount == 0){
                        strCaseStatus = 'Open';
                    }
                }
            }
            // US1753077 - Pilot Enhancement - Save Case - Validations and Additional Functionality: Kavinda - END

            // US2091974 - Sanka - Case Creation
            //caseObj.Status = caseWrapper.OriginatorType == 'Provider' ? 'Closed' : strCaseStatus;
            //US1921739 - Commenting above line and adding new logic to make status open during MNF flow - Sarma
            // US2148602 - Case Creation - Status of Case Open : Commenting the following code block according the US - 28/10/2019 - Sarma.
           /* if(caseWrapper.OriginatorType.equals('Provider')){
                if(caseWrapper.AddInfoTopic.equals('Member Not Found')){
                    caseObj.Status = strCaseStatus;
                } else{
                    caseObj.Status = 'Closed' ;
                }
            } */
	    //US1970508 - Ravindra - start
            // Originator
            caseObj.Originator_name__c = caseWrapper.OriginatorName;
            caseObj.Originator_Relationship__c = caseWrapper.OriginatorRelationship;
            //caseObj.Originator_Type__c = caseWrapper.OriginatorType; // Since this is formular field we don't want to manually assign values
            caseObj.OriginatorPhone__c = caseWrapper.OriginatorPhone;
            caseObj.OriginatorEmail__c = caseWrapper.OriginatorEmail;
            caseObj.Caller__c = caseWrapper.OriginatorContactName;

            // Subject
            caseObj.Subject_Name__c = caseWrapper.SubjectName;
            caseObj.Subject_Type__c = caseWrapper.SubjectType;

            if(caseWrapper.noProviderToSearch) {
                if(caseWrapper.noMemberToSearch){
                } else if(caseWrapper.mnf == 'mnf') {
                } else {
                    //caseObj.Originator_name__c = '';
                    caseObj.ID__c = caseWrapper.SubjectId;
                    caseObj.ContactId = caseWrapper.memberContactId;
                    caseObj.Subject_Name__c = caseWrapper.OriginatorName;
                }
                /*if(caseWrapper.xRefId != null && caseWrapper.xRefId != ''){
                    caseObj.XRefId__c = caseWrapper.xRefId;
                    caseObj.ContactId = caseWrapper.memberContactId;
                }*/
            } else if(caseWrapper.providerNotFound) {
                //Provider not found
                // Originator
                caseObj.ContactId = caseWrapper.providerContactId;
                caseObj.TaxID__c = caseWrapper.TaxId;
                if(caseWrapper.noMemberToSearch){
                    caseObj.Subject_Type__c = 'Provider';
                } else if(caseWrapper.mnf == 'mnf') {
                    caseObj.Subject_Name__c = caseWrapper.SubjectName;
                    caseObj.ContactId = caseWrapper.memberContactId;
                } else {
                    caseObj.ID__c = caseWrapper.SubjectId;
                    caseObj.ContactId = caseWrapper.memberContactId;
                    //caseObj.XRefId__c = caseWrapper.xRefId;
                }
            } else if(caseWrapper.isOtherSearch != null && caseWrapper.isOtherSearch) {
                if(caseWrapper.noMemberToSearch){
                    caseObj.Subject_Name__c = caseWrapper.OriginatorName;
                } else if(caseWrapper.mnf == 'mnf') {
                    caseObj.ContactId = caseWrapper.memberContactId;
                    caseObj.Subject_Name__c = caseWrapper.SubjectName;
                } else {
                    caseObj.ContactId = caseWrapper.memberContactId;
                }
            } else {
                System.debug('@@ valid provider search');
                if(isProvider){
                    caseObj.Subject_Type__c = 'Provider';
                    caseObj.Subject_Name__c = caseWrapper.OriginatorName;
                }
                // Originator
                //caseObj.ContactId = caseWrapper.providerContactId;
                caseObj.ID__c = caseWrapper.providerId;
                if(caseWrapper.noMemberToSearch){
                    System.debug('@@ valid provider search with noMemberToSearch');
                    caseObj.ContactId = caseWrapper.providerContactId;
                } else if(caseWrapper.mnf == 'mnf') {
                    System.debug('@@ valid provider search with mnf');
                    if(isProvider){
                        caseObj.ID__c = '';
                        caseObj.ContactId = caseWrapper.providerContactId;
                    } else {
                        caseObj.ContactId = caseWrapper.memberContactId;
                    }
                } else {
                    System.debug('@@ valid provider search with valid member search');
                    //caseObj.ID__c = caseWrapper.SubjectId;
                    if(isProvider){
                        caseObj.ContactId = caseWrapper.providerContactId;
                    } else {
                        caseObj.ID__c = caseWrapper.SubjectId;
                        caseObj.ContactId = caseWrapper.memberContactId;
                    }
                    //caseObj.XRefId__c = caseWrapper.xRefId;
                }
                // Group/Family ID
                caseObj.TaxID__c = caseWrapper.TaxId;
            }

            if(caseWrapper.noMemberToSearch){

            } else if(caseWrapper.mnf == 'mnf') {
                 caseObj.Surrogate_Key__c = caseWrapper.SubjectName.remove(' ') + caseWrapper.SubjectDOB.remove('/');
            } else {
                if(!isProvider){
                    caseObj.Surrogate_Key__c = caseWrapper.SubjectName.remove(' ') + caseWrapper.SubjectDOB.remove('/') + caseWrapper.SubjectId + caseWrapper.SubjectGroupId;
                }
            }
	    //US1970508 - Ravindra - end
            caseObj.Status = strCaseStatus;

            caseObj.Interaction__c = caseWrapper.Interaction != '' ?  caseWrapper.Interaction : null;

            //Workflow fix - Sarma - 08/11/2019
			/* Commented by Lahiru: Sarma and Vinay to collaborate
            if(caseObj.Interaction__c != null){
             	Interaction__c interaction = SAEUtils.queryInteraction(caseObj.Interaction__c);
                System.debug('Interaction rec '+ interaction);
                System.debug('Originator Account Id '+ interaction.Originator__c);
                //ID personContact = [SELECT id, PersonContactId FROM Account where id=: interaction.Originator__c].PersonContactId;
                Id conId = [SELECT id FROM Contact WHERE id =: interaction.Originator__c].id;
               	System.debug('Contact ID '+ conId);
               	caseObj.ContactId = conId;
            }
			*/

            //caseObj.Status = caseWrapper.Status;
            caseObj.RecordTypeId = recordType.Id;
            //US1970508 - Ravindra - start
            /* // Originator
            caseObj.Originator_name__c = caseWrapper.OriginatorName;
            caseObj.Originator_Relationship__c = caseWrapper.OriginatorRelationship;
            //caseObj.Originator_Type__c = caseWrapper.OriginatorType; // Since this is formular field we don't want to manually assign values
            caseObj.OriginatorPhone__c = caseWrapper.OriginatorPhone;
            caseObj.OriginatorEmail__c = caseWrapper.OriginatorEmail;
            caseObj.Caller__c = caseWrapper.OriginatorContactName;

            // Subject
            caseObj.Subject_Name__c = caseWrapper.SubjectName;
            caseObj.Subject_Type__c = caseWrapper.SubjectType; */
	    //US1970508 - Ravindra - end
            // US1974034 - Thanish (23rd Aug 2019) - to show subject DOB in MM/DD/YYYY format
            //Adding null check - 23/10/2019 - Sarma
            if(caseWrapper.SubjectDOB != null){
                 if(caseWrapper.SubjectDOB.contains('/')) {
                caseObj.DOB__c = caseWrapper.SubjectDOB;
                } else {
                    caseObj.DOB__c =  SAEUtils.formatDate(caseWrapper.SubjectDOB);
                }
            }

             if(isProvider){
                 caseObj.Subject_Group_ID__c = '';
             }else{
                 caseObj.Subject_Group_ID__c = caseWrapper.SubjectGroupId;
             }


            // Additional Information
            //ii - dummy start
            if(caseWrapper.mnf == 'mnf'){
                caseObj.Topic__c = 'Member Not Found';
                caseObj.Type__c = 'Issue Resolved';

            } else {
                //keep this code
                caseObj.Topic__c = caseWrapper.AddInfoTopic;
                caseObj.Type__c = caseWrapper.ttsType;
                caseObj.Subtype__c = caseWrapper.ttsSubType;
            }
            //ii - dummy end

            caseObj.Original_Type__c = caseWrapper.AddInfoOrginType;
            caseObj.Original_Subtype__c = caseWrapper.AddInfoOrginSubType;

            caseObj.Created_By_Role__c = userDetails.UserRole.Name;

            // US2091974 - Sanka - Case Creation
            caseObj.TaxID__c = caseWrapper.TaxId;
            System.debug('####OBJ: before insert'+caseObj);
            insert caseObj;
            System.debug('####OBJ:'+caseObj);
            strCreatedCaseId = caseObj.Id;

            //US2038277 - Autodoc Integration - Sanka
            if(!String.isEmpty(caseWrapper.AutoDoc)){
                addFilesToCase(caseObj.Id , caseWrapper.AutoDoc);
            }

            // US2119574 - Thanish - 26th Nov 2019 - Added external IDf or empty caseItemsInfo
            String extID = ' ';
            if(!String.isEmpty(caseWrapper.TaxId)){
                extID = caseWrapper.TaxId;
            }

            addCaseItems(caseObj.Id, caseWrapper.AutoDocCaseItems,caseWrapper.ttsType,caseWrapper.ttsSubType, extID);
            //End

            System.debug('####CASE-ID:'+strCreatedCaseId);
        }
        catch(Exception e) {
            System.debug(LoggingLevel.ERROR,'####ERROR:'+e.getMessage());
            System.debug(LoggingLevel.ERROR,'####ERROR LINE:'+e.getLineNumber());
        }

        return strCreatedCaseId;

    }

    //US2038277 - Autodoc Integration - Sanka
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

    //US2038277 - Autodoc Integration - Sanka.
    // US2119574 - Thanish - 26th Nov 2019 - Added external IDf or empty caseItemsInfo
    public static void addCaseItems(String caseId, String caseItemsInfo,String ttsType,String ttsSubType, String extID){
        case cse = [select id, Type__c, subtype__c from Case where id =:caseId];
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
                    ci.ExternalID__c = keyIdParts[0];
                    ci.tax_id__c = keyIdParts[1];
                }else{
                    ci.ExternalID__c = keyId;
                }
                //ci.Resolved__c = Boolean.valueOf(keyIdMap.get(keyId));
                ci.Resolved__c = true;
                ci.Resolved_Reason__c = 'Resolved';
                ci.Type__c = ttsType;
                ci.Subtype__c = ttsSubType;
                //adding default resolved reason if Case Item is Resolved [Genesis:added10/19/2017- US793868]
                if(Boolean.valueOf(keyIdMap.get(keyId))) {
                    ci.Resolved_Reason__c = 'Resolved';
                }
                caseItems.add(ci);
            }
        }else{
            //create a dummy case item
            Case_Item__c ci = new Case_Item__c();
            ci.Case__c = caseId;
            ci.Resolved__c = true;
            ci.Type__c = ttsType;
            ci.Subtype__c = ttsSubType;
            //adding default resolved reason [Genesis:added10/19/2017- US793868]
            ci.ExternalID__c = extID; // US2119574 - Thanish - 26th Nov 2019 - Added external IDf or empty caseItemsInfo
            ci.Resolved_Reason__c = 'Resolved';
            caseItems.add(ci);
        }
        if(Case_Item__c.SObjectType.getDescribe().isCreateable()) {  //code added as per the Checkmarx improvement -Rahul
            insert caseItems;
        }
    }
    @AuraEnabled
    public static Id getCaseId(string caseNum){
       Case cse = [SELECT Id FROM CASE WHERE CaseNumber =: caseNum Limit 1];
       if(cse != null)
       	  return  cse.Id;
       else
          return null;
    }
    @AuraEnabled
    public static Id getContactId(string accId){
        Contact cont =new Contact();
        if(string.isNotBlank(accId)){
           cont = [SELECT Id from contact where accountId =: accId Limit 1];
        }
       if(cont != null)
       	  return  cont.Id;
       else
          return null;
    }
	@AuraEnabled
    public static Id createCase(Case obj){
        system.debug('inside contr:::' + obj.original_type__c);
        insert (case)obj;
        system.debug('inside contr:::' + obj.id);
        return obj.id;
    }
    // Cherry - for Feature flag to display Case Origin field
    @AuraEnabled
    public static Boolean showComponent(String featureName){
    	return FeatureFlagService.isFeatureEnabledAura(featureName);
    }
}