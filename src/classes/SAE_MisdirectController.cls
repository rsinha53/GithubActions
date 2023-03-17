public class SAE_MisdirectController {
    @AuraEnabled
    public static List<String> getMisdirectReasonValues() {
        List<String> options = new List<String>();
        Schema.DescribeFieldResult fieldResult = Case.SAE_Misdirect_Reasons__c.getDescribe();
        List<Schema.PicklistEntry> pList = fieldResult.getPicklistValues();
        for (Schema.PicklistEntry p: pList) {
            options.add(p.getLabel());
        }
        return options;
    }
    
    
	// US1889740 - Sarma (Date: 1st Aug 2019) - Misdirect Case creation
	// Updated previous case creation code with case wrapper
	// US2903847
    //US1970508 - Ravindra
    @AuraEnabled 
    public static String createCase(String strWrapper,String commentString, boolean isVCCD,string VCCDRecordId,ACET_ExplorePageCtrl.FlowDetails flowDetails) {
        try{
  
            SAETTSCaseWrapper caseWrapper = (SAETTSCaseWrapper)JSON.deserialize(strWrapper, SAETTSCaseWrapper.class);
             
            // Load relevent 'SAE Provider' record type
            RecordType recordType = [ SELECT Id, Name FROM RecordType WHERE sObjectType='case' AND name = 'SAE Provider' ];
            
            Case caseObj = new Case();
            // Case 
            //US1970508 - Ravindra - start
            if(caseWrapper.Interaction != null) {
                Interaction__c Interaction = SAEUtils.queryInteraction(caseWrapper.Interaction);
                caseObj.Interaction__c = Interaction.Id;
            } else {
                Interaction__c interaction = new Interaction__c();
                string originatorType = getOriginatorType(caseWrapper.OriginatorType);
				//US2740876 - Sravan - Start
				String originatorName = caseWrapper.OriginatorName;
                String providerFirstName = '';
                String providerLastName = '';
                String providerId = '';
                Boolean noProviderToSearch = false;
                Boolean providerNotFound = false;
                Boolean noMemberToSearch = false;
                Boolean isOtherSearch = false;

                List<String> originatorList = new List<String>();
                if(String.isNotBlank(originatorName)){
                	originatorList = originatorName.split(' ');
                }
                if(originatorList != null && !originatorList.isEmpty()){
                    if(originatorList.size() > 1){
                    	providerFirstName =  originatorList[0];
                        providerLastName = originatorList[1];
                    }
                    else{
                        providerFirstName = originatorList[0];
                    }
                }
                 	noProviderToSearch = caseWrapper.noProviderToSearch;
                 	providerNotFound = caseWrapper.providerNotFound;
               	noMemberToSearch = caseWrapper.noMemberToSearch;
                isOtherSearch = caseWrapper.isOtherSearch;
                providerId = getProviderId(caseWrapper.providerId);


				interaction = createInteraction(providerFirstName,'',providerLastName,caseWrapper.OriginatorPhone,'',providerId,'','','',noProviderToSearch,providerNotFound,noMemberToSearch,caseWrapper.mnf,isOtherSearch,
                '','','',isVCCD,VCCDRecordId,flowDetails);

                //US2740876 - Sravan - End

                caseObj.Interaction__c = interaction.Id;
            }
            //US1970508 - Ravindra - end
            caseObj.Status = caseWrapper.Status;
            caseObj.RecordTypeId = recordType.Id;

            //DE441126  - Avish
            if (nullCheck(caseWrapper.onShoreRestriction)) {
                caseObj.Onshore_Restriction__c = caseWrapper.onShoreRestriction;
            }
            
            if (nullCheck(caseWrapper.uhgRestriction)) {
                caseObj.UHG_Restriction__c = caseWrapper.uhgRestriction;
            }
            //DE441126  - Ends
            
            // Originator 
            caseObj.Originator_name__c = caseWrapper.OriginatorName;
            caseObj.PC_External_Contact_Phone__c = getContactNumber(caseWrapper.contactNumber,caseWrapper.contactExt);
            caseObj.Originator_Relationship__c = caseWrapper.OriginatorRelationship;
            // caseObj.Originator_Type__c = caseWrapper.OriginatorType;
            caseObj.OriginatorPhone__c = caseWrapper.OriginatorPhone;
            caseObj.OriginatorEmail__c = caseWrapper.OriginatorEmail;
            caseObj.Caller__c = caseWrapper.OriginatorContactName;
            
            // Subject
            caseObj.Subject_Name__c = caseWrapper.SubjectName;
            caseObj.Subject_Type__c = caseWrapper.SubjectType;
            caseObj.DOB__c = caseWrapper.SubjectDOB;
            caseObj.ID__c = caseWrapper.SubjectId;
            caseObj.Subject_Group_ID__c = caseWrapper.SubjectGroupId;
            caseObj.SourceCode__c = caseWrapper.strSourceCode;//US2740876 - Sravan

            // Additional Information
            caseObj.SAE_Misdirect_Reasons__c = caseWrapper.MisdirectReason;
            caseObj.Topic__c = caseWrapper.AddInfoTopic;
            caseObj.Original_Type__c = caseWrapper.AddInfoOrginType;
            caseObj.Original_Subtype__c = caseWrapper.AddInfoOrginSubType;
            
            INSERT caseObj;
            system.debug('MIsdirect CaseObj@@ ' + CaseObj);
            case caseRecord = [SELECT id,CaseNumber FROM Case WHERE id = :CaseObj.Id];
            commentString = 'ORS created for ACET Case Number '+ caseRecord.CaseNumber + '\n' + commentString;
            addCaseComment(CaseObj.Id,commentString);
            return caseObj.Id;
            
        } catch(Exception e){
            System.debug('SAE_MisdirectController:createCase() - ' + e.getStackTraceString());
            throw new AuraHandledException(e.getMessage());
        }
    }
    
    @AuraEnabled
    public static String CreateORSRecord(String strRecord, String caseId) {
        // Thanish - Bug fix - 25th Jun 2020
        List<SAECaseCreationController.ORSResultWrapper> orsId = SAECaseCreationController.CreateORSRecord(strRecord, caseId);
        return '';
    }
    
    public static void addCaseComment(String caseId, String cc){
        if(!String.isEmpty(cc)){
            CaseComment objcc = new CaseComment();
            objcc.CommentBody = cc;
            objcc.ParentId = caseId;
            if(CaseComment.SObjectType.getDescribe().isCreateable()) {  //code added as per the Checkmarx improvement -Rahul
                insert objcc;   
            }         
        }
    }



    public static Boolean nullCheck(String value){
    	Boolean nullCheck = false;
        if(value != null && String.isNotBlank(value)){
        	nullCheck = true;
        }
        return nullCheck;
    }

    public static String getContactNumber(String contactNumber,String contactExt){
        String contactNumberVal = '';
        if(String.isNotBlank(contactNumber)){
            if(String.isNotBlank(contactExt)){
                   contactNumberVal = contactNumber + '	Ext ' + contactExt;
             }else{
                  contactNumberVal = contactNumber;
             }
       	}
        return contactNumberVal;
    }

    public static String getOriginatorType(String originatorType){
        String originatorTypeVal = 'Provider';
        originatorTypeVal = String.isNotBlank(originatorType) ? originatorType : 'Provider';
        return originatorTypeVal;
    }

    public static String getProviderId(String providerId){
        String providerIdVal = '';
        if(nullCheck(providerId)){
           providerIdVal = providerId;
        }
        return providerIdVal;
    }

    //US2705857 - Sravan - Start
    @AuraEnabled
    public static Map<String,String> getCaseDetails(String caseId){
        Map<String,String> caseParams = new Map<String,String>();
        if(caseId != null && String.isNotBlank(caseId)){
            List<Case> caseList = [Select Id,Caller__c,PC_External_Contact_Phone__c,Originator_name__c,Originator_Type__c,Subject_Name__c,DOB__c,Subject_Type__c,ID__c,Subject_Group_ID__c,Interaction__c from Case where Id=: caseId];
            if(caseList != null && !caseList.isEmpty()){
                List<String> callerName = new List<String>();
                List<String> callerContact = new List<String>();
                caseParams.put('ContactName',caseList[0].Caller__c);
                callerName = caseList[0].Caller__c.split(' ');
                if(caseList[0].PC_External_Contact_Phone__c != null && String.isNotBlank(caseList[0].PC_External_Contact_Phone__c)){
                    callerContact = caseList[0].PC_External_Contact_Phone__c.split('Ext');
                }
                if(callerName != null && !callerName.isEmpty()){
                    if(callerName.Size() == 1){
                        caseParams.put('ContactFirstName',callerName[0]);
                    }
                    //DE407256 - Sravan
                    else if(callerName.Size() == 2){
                        caseParams.put('ContactFirstName',callerName[0]);
                        caseParams.put('ContactLastName',callerName[1]);
                    }
                    else if(callerName.Size() > 2){
                        Integer postion = 0;
                        postion = callerName.Size() - 1;
                        caseParams.put('ContactFirstName',callerName[0]);
                        caseParams.put('ContactLastName',callerName[postion]);
                    }
                }
                if(callerContact != null && !callerContact.isEmpty()){
                    if(callerContact.Size() == 1){
                        caseParams.put('PhoneNumber',callerContact[0]);
                    }
                    else{
                        caseParams.put('PhoneNumber',callerContact[0]);
                        caseParams.put('Ext',callerContact[1]);
                    }

                }
                caseParams.put('OriginatorName',caseList[0].Originator_name__c);
                caseParams.put('OriginatorType',caseList[0].Originator_Type__c);
                caseParams.put('SubjectName',caseList[0].Subject_Name__c);
                caseParams.put('SubjectType',caseList[0].Subject_Type__c);
                caseParams.put('SubjectDOB',caseList[0].DOB__c);
                caseParams.put('SubjectID',caseList[0].ID__c);
                caseParams.put('SubjectGrpID',caseList[0].Subject_Group_ID__c);
                caseParams.put('InteractionId',caseList[0].Interaction__c);
            }
        }
        system.debug('Case Params'+ caseParams);
        return caseParams;

    }
    //US2705857 - Sravan - End

    @AuraEnabled
    public static string getCallHandlingOneSourceURL(){
        string strRedirectURL = '';
        Map<String, ACETOrgNameToSwivelEndpointMap__c> WSConfigurations = ACETOrgNameToSwivelEndpointMap__c.getAll();
        if(WSConfigurations.get('CallHandlingOneSource') != NULL){
            strRedirectURL = WSConfigurations.get('CallHandlingOneSource').Swivel_Endpoint__c;
        }
        return strRedirectURL;
    }

public static Interaction__c createInteraction(String providerFN, String providerMN, String providerLN, String providerPhone, String providerNameID, String providerId, String interactionType, String interactionIDParam, String originatorType, Boolean noProviderToSearch, Boolean providerNotFound, Boolean noMemberToSearch, String mnf, Boolean isOtherSearch,
    String memberFirstName, String memberLastName, String otherContactType,boolean isVCCD,string VCCDRecordId,ACET_ExplorePageCtrl.FlowDetails flowDetails) {
		Interaction__c interaction = new Interaction__c();
		if(!noProviderToSearch && !providerNotFound && !noMemberToSearch && !isOtherSearch){
			interaction = SAEUtils.createInteraction('', '', '', '', originatorType, '', false,isVCCD,VCCDRecordId,flowDetails);
		}
		else{
			interaction = SAEUtils.createAccountContact(providerFN,'',providerLN,providerPhone,'',providerId,'','','',noProviderToSearch,providerNotFound,noMemberToSearch,mnf,isOtherSearch,
                '','','',isVCCD,VCCDRecordId,flowDetails);
		}
		return interaction;
	}
}