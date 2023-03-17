public class SAEUtils {
    //US1921739 - Adding new String param  originatorType - 18/10/2019 - Sarma
    //US1970508 - Ravindra - start
    //US2631703 - Durga- 08th June 2020  - Added VCCD Parameters
    @AuraEnabled
    public static Interaction__c createAccountContact(String providerFN, String providerMN, String providerLN, String providerPhone, String providerNameID, String providerId, String interactionType, String interactionIDParam, String originatorType, Boolean noProviderToSearch, Boolean providerNotFound, Boolean noMemberToSearch, String mnf, Boolean isOtherSearch,
    String memberFirstName, String memberLastName, String otherContactType,boolean isVCCD,string VCCDRecordId,ACET_ExplorePageCtrl.FlowDetails flowDetails) {
        System.debug('isVCCD@@ ' + isVCCD + ' @@VCCDRecordId@@ ' + VCCDRecordId + ' providerFN@@ ' + providerFN + ' @@providerMN@@ ' + providerMN + ' @@providerLN@@ ' + providerLN + ' @@providerNameID@@ ' + providerNameID + ' @@providerId@@ ' + providerId + ' @@interactionType@@ ' + interactionType + ' @@interactionIDParam@@ ' + interactionIDParam + ' @@originatorType@@ ' + originatorType + ' @@noProviderToSearch@@ ' + noProviderToSearch + ' @@providerNotFound@@ ' + providerNotFound + ' @@noMemberToSearch@@ ' + noMemberToSearch + ' @@mnf@@ ' + mnf + ' @@isOtherSearch@@ ' + isOtherSearch + ' @@memberFirstName@@ ' + memberFirstName + ' @@memberLastName@@ ' + memberLastName + ' @@otherContactType@@ ' + otherContactType);
        Id personAccountRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('PersonAccount').getRecordTypeId();
        Account acc = new Account();
        Third_Party__c thirdParty = new Third_Party__c();
        Interaction__c interaction = new Interaction__c();
        if(noProviderToSearch) {
            if(mnf != 'mnf') {
                //Member standalone - create while opening member snapshot page
                interaction = createInteraction(interactionIDParam, interactionType, '', memberFirstName + ' ' + memberLastName, 'Member', '', false,isVCCD,VCCDRecordId,flowDetails);
            } else if(mnf == 'mnf') {
                //Member Not Found standalone - create while opening member snapshot page
                //create member third party record
                /*thirdParty.First_Name__c = providerFN;
                thirdParty.LastName__c = providerLN;
                thirdParty.Tax_ID__c = providerNameID;
                Database.upsert(thirdParty);*/
                interaction = createInteraction(interactionIDParam, interactionType, '', memberFirstName + ' ' + memberLastName, 'Member', '', true,isVCCD,VCCDRecordId,flowDetails);
            }
        } else if(providerNotFound) {
            //Provider not found
            //create provider third party record
            thirdParty.FullName__c = providerFN + ' ' + providerFN;
            thirdParty.First_Name__c = providerFN;
            thirdParty.LastName__c = providerLN;
            if(providerPhone != null) {
                thirdParty.Phone_Number__c = providerPhone.remove('-');
            }
            thirdParty.Tax_ID__c = providerNameID;
            Database.upsert(thirdParty);

            //create interaction
            interaction = createInteraction(interactionIDParam, interactionType, thirdParty.Id, providerFN + ' ' + providerLN, 'Provider', providerNameID, true,isVCCD,VCCDRecordId,flowDetails);
        } else if(isOtherSearch) {
            thirdParty.FullName__c = providerFN + ' ' + providerFN;
            thirdParty.First_Name__c = providerFN;
            thirdParty.LastName__c = providerLN;
			thirdParty.Tax_ID__c = providerNameID;
            if(providerPhone != null) {
            	thirdParty.Phone_Number__c = providerPhone.remove('-');
            }
			Database.upsert(thirdParty);
            Third_Party_Originator__c thirdPartyOriginator = new Third_Party_Originator__c(
                Name = otherContactType,
                Third_Party__c = thirdParty.Id,
                Other_Originator__c = otherContactType
            );
			//create interaction
            interaction = createInteraction(interactionIDParam, interactionType, thirdParty.Id, providerFN + ' ' + providerLN, 'Other', providerNameID, true,isVCCD,VCCDRecordId,flowDetails);
		} else {
			acc.FirstName = providerFN;
            acc.LastName = providerLN;
            acc.EID__c = providerId;
            acc.Tax_Id__c = providerNameID;
            acc.Tax_ID__pc = providerNameID;
            if(providerPhone != null) {
            	acc.Phone = providerPhone.remove('-');
            }
			acc.RecordTypeId = personAccountRecordTypeId;
			Database.upsert(acc, Account.Fields.EID__c);

			//create interaction
			Account personContact = [SELECT Id, PersonContactId FROM Account WHERE Id = :acc.Id];
            interaction = createInteraction(interactionIDParam, interactionType, personContact.PersonContactId, acc.Name, 'Provider', providerNameID, false,isVCCD,VCCDRecordId,flowDetails);
			return queryInteraction(interaction.Id);
        }
		System.debug('@@ SAEUtils: createAccountContact: interaction: ' + interaction);
        return queryInteraction(interaction.Id);
	}

    public static Interaction__c createInteraction(String interactionId, String interactionType, String originatorId, String originatorName,
    String originatorType, String taxId, Boolean isThirdParty,Boolean isVCCD, String VCCDRecordId,ACET_ExplorePageCtrl.FlowDetails flowDetails) {
		Interaction__c interaction = new Interaction__c();
		if(interactionId != null && interactionId != '') {
			interaction.Id = interactionId;
		}
		if (originatorId != '') {
			if(isThirdParty) {
				System.debug('@@ inside third party');
				interaction.Third_Party__c = originatorId;
			} else {
				System.debug('@@ inside third party else');
				interaction.Originator__c = originatorId;
			}
		}
		interaction.Interaction_Type__c = interactionType;
		interaction.Originator_Type__c = originatorType;
		interaction.Originator_Name__c = originatorName;
        //US2631703 - Durga- 08th June 2020
        //US2903847 -START
        if(isVCCD && string.isNotBlank(VCCDRecordId)){
                List<VCCD_Response__c> VCCDRecord = [SELECT Id,Ani__c, ClaimId__c, ClaimsDOSMD__c, MemberId__c, MSID__c, NPI__c, ProductType__c, QuestionType__c, SubjectDOB__c,
                TaxId__c, TFN__c, Ucid__c FROM VCCD_Response__c WHERE Id= :VCCDRecordId];
                if(!VCCDRecord.isEmpty()){
                    interaction.Tax_Id__c = VCCDRecord[0].TaxId__c != null  ? VCCDRecord[0].TaxId__c :  '--';
                    interaction.Caller_Type__c = VCCDRecord[0].ProductType__c;
                    interaction.TFN_Toll_Free_Number__c = VCCDRecord[0].TFN__c != null  ? VCCDRecord[0].TFN__c  : '--';
                    interaction.Caller_Id_ANI__c  = VCCDRecord[0].Ani__c != null ? VCCDRecord[0].Ani__c : '--';
                    interaction.Member_Id__c      = VCCDRecord[0].MemberId__c != null ? VCCDRecord[0].MemberId__c : '--';
                    interaction.NPI__c = VCCDRecord[0].NPI__c != null ? VCCDRecord[0].NPI__c : '--';
                    interaction.Group_ID__c  =  '--';
                    interaction.Question_Type__c  = VCCDRecord[0].QuestionType__c != null ? VCCDRecord[0].QuestionType__c : '--';
                    interaction.Claim_Authorization_Referral_Number__c  = VCCDRecord[0].ClaimId__c != null ? VCCDRecord[0].ClaimId__c : '--';
                    interaction.Member_Date_of_Birth__c  =  VCCDRecord[0].SubjectDOB__c;
                    delete VCCDRecord[0];
                }
            }
        else if(!isVCCD && flowDetails != null && flowDetails.isGenesys && String.isNotBlank(String.valueof(flowDetails.IVRinfo)) ){
            string respstr= json.serialize(flowDetails.IVRinfo);
            Map<String, Object> responseMap = (Map<String, Object>)JSON.deserializeUntyped(respstr);
            if(responseMap != null && !responseMap.isEmpty()){
                interaction.Tax_Id__c = responseMap.get('TaxId__c') != NULL ? (string) responseMap.get('TaxId__c') : '--';
                if(responseMap.get('ProductType__c') != NULL) interaction.Caller_Type__c = (string) responseMap.get('ProductType__c');
                interaction.TFN_Toll_Free_Number__c = responseMap.get('TFN__c') != NULL ? (string) responseMap.get('TFN__c') : '--';
                interaction.Caller_Id_ANI__c  =  responseMap.get('Ani__c') != NULL ? (string) responseMap.get('Ani__c') : '--';
                interaction.Member_Id__c     = responseMap.get('MemberId__c') != NULL ? (string) responseMap.get('MemberId__c') : '--';
                interaction.NPI__c = responseMap.get('NPI__c') != NULL ? (string) responseMap.get('NPI__c') : '--';
                interaction.Group_ID__c  =  '--';
                interaction.Question_Type__c  = string.isNotBlank(flowDetails.GeneysysQuestionType) ? flowDetails.GeneysysQuestionType : '--';
                interaction.Claim_Authorization_Referral_Number__c = responseMap.get('ClaimId__c') != NULL ? (string) responseMap.get('ClaimId__c') : '--';
                if(responseMap.get('SubjectDOB__c') != NULL){
                    if(string.valueof(responseMap.get('SubjectDOB__c')).contains('-')){
                        interaction.Member_Date_of_Birth__c  = Date.valueof(string.valueof(responseMap.get('SubjectDOB__c')));
                    }
                    else{
                        string DOB= string.valueof(responseMap.get('SubjectDOB__c'));
                        if(string.isNotBlank(DOB) && DOB.length() == 8 ) interaction.Member_Date_of_Birth__c = Date.valueof(DOB.substring(0,4)+'-'+ DOB.substring(4,6)+'-'+DOB.substring(6,8));
                    }
                }
            }
        }
        else{
            interaction.Tax_Id__c = '--';
            interaction.TFN_Toll_Free_Number__c = '--';
            interaction.Caller_Id_ANI__c  = '--';
            interaction.Member_Id__c      = '--';
            interaction.NPI__c = '--';
            interaction.Group_ID__c  = '--';
            interaction.Question_Type__c  = '--';
            interaction.Claim_Authorization_Referral_Number__c  = '--';

        }
        //US2903847 -END
        //US2631703 - Durga- 08th June 2020
		//Database.insert(interaction);
		Database.upsert(interaction);
		return interaction;
	}

	/*@AuraEnabled
	public static Interaction__c createAccountContact(String providerFN, String providerMN, String providerLN, String providerNameID, String interactionType, String interactionIDParam, String originatorType, String mnf) {
		System.debug('providerFN@@ ' + providerFN + ' @@providerMN@@ ' + providerMN + ' @@providerLN@@ ' + providerLN + ' @@providerNameID@@ ' + providerNameID + ' @@interactionType@@ ' + interactionType);
		Interaction__c interaction;
		Account acc = new Account();
		if (mnf != 'mnf') {
			Id personAccountRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('PersonAccount').getRecordTypeId();

			acc.FirstName = providerFN;
			acc.LastName = providerLN;

			if (!String.isBlank(providerNameID)) {
				acc.EID__c = providerNameID;
				acc.EID__pc = providerNameID;
			}
			acc.RecordTypeId = personAccountRecordTypeId;
			Database.upsert(acc, Account.Fields.EID__c);

			if (String.isBlank(interactionIDParam)) {
				interaction = createInteraction(interactionType, acc, mnf, null, originatorType);
				interaction = queryInteraction(interaction.id);
			} else {
				interaction = queryInteraction(interactionIDParam);
			}
			return interaction;
		} else {
			System.debug('interactionIDParam Else@@@ ' + interactionIDParam);
			if (String.isBlank(interactionIDParam)) {
				Third_Party__c thirdParty = new Third_Party__c();
				thirdParty.First_Name__c = providerFN;
				thirdParty.LastName__c = providerLN;
				//thirdParty.DOB__c =
				//thirdParty.NPI__c = providerNameID;                
				Database.upsert(thirdParty);
				System.debug('thirdParty Else@@@ ' + thirdParty);
				interaction = createInteraction(interactionType, null, mnf, thirdParty, originatorType);
				interaction = queryInteraction(interaction.id);
			} else {
				interaction = queryInteraction(interactionIDParam);
			}
			return interaction;
		}
	}*/
	//US1970508 - Ravindra - end
    
    public static Interaction__c createInteraction(String interactionType,Account con,String mnf,Third_Party__c thirdParty,String originatorType){
        Interaction__c interaction = new Interaction__c();
        if(mnf != 'mnf'){
            Account personContact = [SELECT id, PersonContactId FROM Account where id=: con.id];
            
            interaction.Originator__c = personContact.PersonContactId;
            interaction.Interaction_Type__c = interactionType;
            interaction.Originator_Type__c = originatorType;
            interaction.Originator_Name__c = con.Name;
            Database.insert(interaction);                          
        }else{
            interaction.Interaction_Type__c = interactionType;
            interaction.Originator_Type__c = originatorType;
            interaction.Third_Party__c = thirdParty.id;
            Database.insert(interaction);
        }
        return interaction;
    }
    
    public static Interaction__c queryInteraction(String InteractionId){        
        
        system.debug('query>>>'+InteractionId);
        Interaction__c Interaction = new Interaction__c();
        List<Interaction__c> InteractionList = new List<Interaction__c>();
        if (InteractionId != null && InteractionId !='')
        {
            
            InteractionList = [SELECT Id, Name, Interaction_Type__c, Provider_ID__c, Group_ID__c, Originator_Type__c, Originator_Name__c,Contact_Name__c, Caller_Type__c, Highlight_Panel_GroupInfo__c,Originator__c, Originator__r.EID__c, Originator__r.Tax_ID__c, Originator__r.NPI__c, 
                               Originator__r.Name,Id__c, Originator__r.LastName, Originator__r.FirstName, Originator__r.AccountId,Originator__r.Account.Name,Originator__r.Birthdate,Originator__r.mailingState,Originator__r.mailingPostalCode,Originator__r.Phone, Third_Party__c, Third_Party__r.Tax_ID__c, Third_Party__r.NPI__c, 
                               Third_Party__r.FullName__c, Provider_Address_Id__c , Provider_Address_Type__c, Third_Party__r.LastName__C,Third_Party__r.Producer_Name__C, Third_Party__r.First_Name__c,Third_Party__r.Employer_Name__c, Third_Party__r.Phone_Number__c, Third_Party__r.Email__c
                               FROM Interaction__c WHERE Id =:InteractionId];
        }  
        system.debug('queryresult>>>'+InteractionList);
        
        if(InteractionList.size() > 0){
            Interaction = InteractionList[0];
            return Interaction;
        }else{
            return null;
        }                
    }
    
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
    
    
    public static String getAgeFromBirthday(String birthDate) {
	try {
		if (String.isBlank(birthDate)) return null;
		Date d = Date.valueOf(birthDate);
		//DE449735: Member age is showing incorrect on snapshot member details- Swapnil
	        Integer ageValue= Date.today().year() - d.year();
	        Integer monthsValue= Date.today().month() - d.month();
	        if( monthsValue < 0 || ( monthsValue == 0 && (Date.today().day() < d.day() ))) ageValue--;
	        return String.valueOf(ageValue);
	} catch(Exception e) {
		System.debug('Exception Happened=' + e);
		return null;
	}
    }
    
    public static String getAgeFromBirthDate(String birthDate){
        try{
            String age = '';
            if(String.isBlank(birthDate)) return null;
            Date d = Date.valueOf(birthDate);
	    //DE449735: Member age is showing incorrect on snapshot member details- Swapnil
            Integer ageValue= Date.today().year() - d.year();
            Integer monthsValue= Date.today().month() - d.month();
            if( monthsValue < 0 || ( monthsValue == 0 && (Date.today().day() < d.day() ))) ageValue--;
            if(agevalue < 1){
                age = ' '+string.valueOf(d.monthsBetween(Date.today())) + ' Months';
            }else{
                age = ' '+string.valueOf(ageValue) + ' Years';
            }
            return age;
        }catch(Exception e){
            System.debug('Exception Happened='+e); 
            return null;
        }
    }
    //vishnu- 30/04/2020
    Public static string getOrgName()
    {
        string OrgName;
        Map<String, ISL_Webservice_Config__c> WSConfigurations = ISL_Webservice_Config__c.getAll();
        Map<String, ACETOrgInstanceURLToOrgNameMap__c> OrgInstance2OrgNameMap = ACETOrgInstanceURLToOrgNameMap__c.getAll();
        
        return OrgName = Test.isRunningTest() ? 'dev' : ACETUtility.GetOrgName(OrgInstance2OrgNameMap);
    }
	
    public static HttpResponse getResponse(String searchparameter){
        String responseStr;
        HttpResponse response=new HttpResponse();
        
		try{
                   List<AcetLinkStaticResponse__mdt> LinkEllStaticResList =[SELECT label,isAvailable__c,isDowntime__c,Error_Code__c,FileName__c FROM AcetLinkStaticResponse__mdt where label=:searchparameter];
						if(LinkEllStaticResList!=null && LinkEllStaticResList.size()==1){
                        AcetLinkStaticResponse__mdt LinkEllStaticRes=LinkEllStaticResList.get(0);
                        if(String.isNotBlank(LinkEllStaticRes.FileName__c) && (!LinkEllStaticRes.isDowntime__c))
                            responseStr =getStaticResponse(LinkEllStaticRes.FileName__c);

                        if(String.isNotBlank(responseStr)){
                            
                            response.setBody(responseStr);
                            response.setStatusCode(200);
                        }
                        else{
                            	response.setStatusCode(String.isNotBlank(LinkEllStaticRes.Error_Code__c.trim())?Integer.valueOf(LinkEllStaticRes.Error_Code__c.trim()):999);
                           }
                    }
			
		}catch(Exception e)
        {
            System.debug(Logginglevel.ERROR, '### READ-AUTH-EXCEPTION:' + e.getStackTraceString() + ' - ' + e.getMessage());
            response.setStatusCode(900);
            response.setBody('Sample');
            
            return response;
        }
        return response;
    }
	
	public static Boolean getMockStatus() {
        Boolean isStaticResponseChecked = false;
        try {
            isStaticResponseChecked = [SELECT Label, isAvailable__c FROM AcetLinkStaticResponse__mdt WHERE label='GetStaticResponse' LIMIT 1].isAvailable__c;
            if('prd'== SAEUtils.getOrgName()) {
                isStaticResponseChecked = false;
            } else if (isStaticResponseChecked && !(Organization_Properties__c.getInstance(UserInfo.getProfileId()).OverrideEnableMock__c || Organization_Properties__c.getInstance(UserInfo.getUserId()).OverrideEnableMock__c)) {
                isStaticResponseChecked = true;
            } else {
                isStaticResponseChecked = false;
            }
        } catch(Exception e) {
            System.debug(LoggingLevel.ERROR,e.getMessage());
        }
        return isStaticResponseChecked;
    }
	
    //US3219740 - Sravan
    @AuraEnabled
    public static String getProviderNotification(){
        String orgName = ACETUtility.GetOrgName();
        system.debug('Org Name'+ orgName);
        String swivelSysName = SAEConstants.PROVIDER_NOTIFICATION_TOOL;
        system.debug('Swivel Sys Name'+ swivelSysName);
        String endPoint = ACETUtility.GetSwivelEndpointByOrgName(orgName,swivelSysName);
        return endPoint;
    }

    public Static String getStaticResponse(String StaticResourceName){
       
        String responseStr;
        StaticResource responseJSONSR = [SELECT Body FROM StaticResource WHERE Name = :StaticResourceName limit 1];        
        responseStr = responseJSONSR!=null?responseJSONSR.Body.toString():'';  
       
        return responseStr;
    }


    //US2076634 - HIPAA Guidelines Button - Sravan
    @AuraEnabled
    public static String getHippaGuideLinesUrl(){
        String orgName = ACETUtility.GetOrgName();
        String swivelSysName = SAEConstants.KNOWLEDGE_CENTRAL_URL;
        String endPoint = ACETUtility.GetSwivelEndpointByOrgName(orgName,swivelSysName);
        return endPoint;
    }

    //US3583813
    @AuraEnabled
    public static string getSopLink(){
        String sopLink = '';
        String orgName = ACETUtility.GetOrgName();
        String swivelSysName = SAEConstants.SOP_LINK;
        sopLink = ACETUtility.GetSwivelEndpointByOrgName(orgName,swivelSysName);
        return sopLink;
}

    //US3583813
    @AuraEnabled
    public static string getToolTip(String delegatedValue,Boolean isToolTipVal){ 
        String toolTip = '';
            String delegationValue = delegatedValue.Trim();
            List<Tool_Tip__c> toolTipList = [Select Tip__c,Tool_Tip_Type__c,Value__c,SOP_or_Document_Name__c from Tool_Tip__c where Tool_Tip_Type__c='Delegated'];
            if(toolTipList != null && !toolTipList.isEmpty()){
                for(Tool_Tip__c t : toolTipList){
                   String value = t.Value__c.Trim();
                   if(value == delegationValue){
                        if(isToolTipVal){
                            toolTip = t.Tip__c;
                        }
                        else{
                            toolTip = t.SOP_or_Document_Name__c; 
                        }
                        
                        break;
                   }
                 }
            }
        system.debug('Tool Tip Value'+ toolTip); 
        return toolTip;
    }

    @AuraEnabled
    public static ACET_SAECalloutResult  getSPInsString(spInsInp inpReq){
        system.debug('=inpReq='+inpReq);
        ACET_BenefitSpInService.BenefitSIReq req= new ACET_BenefitSpInService.BenefitSIReq();

        req.clientId = 'acet';
        List<ACET_BenefitSpInService.codeWrapper> clist= new List<ACET_BenefitSpInService.codeWrapper>();
        ACET_BenefitSpInService.codeWrapper cd = new ACET_BenefitSpInService.codeWrapper();
        cd.diagnosisCode = inpReq.diagnosisCode;
        cd.procedureCode= inpReq.procedureCode;
        clist.add(cd);
        req.codeList = clist;
        req.dateOfService = inpReq.dateOfService;
        ACET_BenefitSpInService.memberPWrapper  mpc = new ACET_BenefitSpInService.memberPWrapper();
        mpc.marketType = inpReq.marketType;
        mpc.productCode = inpReq.productCode;
        req.memberProductCodes = mpc;
        req.productGroup = inpReq.productGroup;
        req.provState = inpReq.provState;
        req.siteOfService = inpReq.siteOfService;

		ACET_SAECalloutResult result= ACET_BenefitSpInService.callBenfitSpInService(req);
        return result;
    }

    public class spInsInp{
        @AuraEnabled public string diagnosisCode {get;set;}
        @AuraEnabled public string procedureCode {get;set;}
        @AuraEnabled public string dateOfService {get;set;}
        @AuraEnabled public string marketType {get;set;}
        @AuraEnabled public string productCode {get;set;}
        @AuraEnabled public string productGroup {get;set;}
        @AuraEnabled public string provState {get;set;}
        @AuraEnabled public string siteOfService {get;set;}
    }
}