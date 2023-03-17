public without sharing class ACET_InteractionOverviewCtrl {

    @AuraEnabled
    public static Interaction__c createInteraction(ACET_ExplorePageCtrl.FlowDetails flowDetails,
                                                   ACET_ProviderSearchCtrl.ProviderDetails providerDetails,
                                                   ACET_MemberSearchCtrl.ExplorePageMemberDetailsResponse memberResponseData,
                                                  Boolean isVCCD,
                                                  String VCCDRecordId) {
        try {
            System.debug('@@ ACET_InteractionOverviewCtrl: createInteraction: flowDetails: ' + flowDetails);
            System.debug('@@ ACET_InteractionOverviewCtrl: createInteraction: providerDetails: ' + providerDetails);
            System.debug('@@ ACET_InteractionOverviewCtrl: createInteraction: memberResponseData: ' + memberResponseData);
            Id personAccountRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('PersonAccount').getRecordTypeId();
            Account memberAccount;
            Account providerAccount;
            Third_Party__c thirdParty = new Third_Party__c();
            Interaction__c interaction = new Interaction__c();
            String memberDOBWithSlash;
            if (memberResponseData != null) {
                memberDOBWithSlash = memberResponseData.dob.contains('-') ? SAEUtils.formatDate(memberResponseData.dob) : memberResponseData.dob;
            }
            if (providerDetails.isNoProviderToSearch) {
                if (memberResponseData.isValidMember) {
                    interaction = new Interaction__c(
                        Originator_Name__c = memberResponseData.firstName + ' ' + memberResponseData.lastName,
                        Originator_Type__c = 'Member',
                        Interaction_Type__c = flowDetails.interactionType
                    );
                    memberAccount = new Account(
                        RecordTypeId = personAccountRecordTypeId,
                        FirstName = memberResponseData.firstName,
                        LastName = memberResponseData.lastName,
                        EID__c = memberResponseData.firstName + ' ' + memberResponseData.lastName + ' ' + memberDOBWithSlash.remove('/') + ' ' + memberResponseData.memberId + ' ' + memberResponseData.groupNumber,
                        PersonBirthdate = Date.parse(memberDOBWithSlash),
                        Phone = memberResponseData.phoneNumber
                    );
                    Database.upsert(memberAccount, Account.Fields.EID__c);
                    System.debug('@@ ACET_InteractionOverviewCtrl: createInteraction: memberAccount: ' + memberAccount);
                    interaction.Originator__c = getPersonContactId(memberAccount.Id);
                } else if (memberResponseData != null && memberResponseData.isMemberNotFound) {
                    thirdParty = new Third_Party__c(
                        FullName__c = memberResponseData.firstName + ' ' + memberResponseData.lastName,
                        First_Name__c = memberResponseData.firstName,
                        LastName__c = memberResponseData.lastName,
                        DOB__c = Date.parse(memberDOBWithSlash),
                        Phone_Number__c = memberResponseData.phoneNumber
                    );
                    Database.upsert(thirdParty);
                    interaction.Third_Party__c = thirdParty.Id;
                    //US3172545 - No Provider to Search to MNF - Sravan - Start
                    interaction.Interaction_Type__c = flowDetails.interactionType;
                    //US3172545 - No Provider to Search to MNF - Sravan - End
                    if(string.isBlank(interaction.Originator_Type__c)) interaction.Originator_Type__c = 'Member';
                }
            } else if (providerDetails.isValidProvider) {
                providerAccount = new Account(
                    RecordTypeId = personAccountRecordTypeId,
                    FirstName = providerDetails.firstName,
                    LastName = providerDetails.lastName,
                    EID__c = providerDetails.providerId,
                    Tax_Id__c = providerDetails.taxId,
                    Phone = providerDetails.phoneNumber
                );
                Database.upsert(providerAccount, Account.Fields.EID__c);
                interaction = new Interaction__c(
                    Originator__c = getPersonContactId(providerAccount.Id),
                    Originator_Name__c = providerDetails.firstName + ' ' + providerAccount.lastName,
                    Originator_Type__c = 'Provider',
                    Interaction_Type__c = flowDetails.interactionType
                );
                /* if (memberResponseData.isValidMember) {
                    providerAccount = new Account(
                    RecordTypeId = personAccountRecordTypeId,
                    FirstName = memberResponseData.firstName,
                    LastName = memberResponseData.lastName,
                    EID__c = memberResponseData.firstName + ' ' + memberResponseData.lastName + ' ' + memberDOBWithSlash.remove('/') + ' ' + memberResponseData.memberId + ' ' + memberResponseData.groupNumber,
                    PersonBirthdate = Date.parse(memberDOBWithSlash),
                    Phone = memberResponseData.phoneNumber
                    );
                    Database.upsert(providerAccount, Account.Fields.EID__c);
                    System.debug('@@ ACET_InteractionOverviewCtrl: createInteraction: valid provider and member: providerAccount: ' + providerAccount);

                } else */
                if (memberResponseData != null && memberResponseData.isMemberNotFound) {
                    thirdParty = new Third_Party__c(
                        FullName__c = memberResponseData.firstName + ' ' + memberResponseData.lastName,
                        First_Name__c = memberResponseData.firstName,
                        LastName__c = memberResponseData.lastName,
                        DOB__c = Date.parse(memberDOBWithSlash),
                        Phone_Number__c = memberResponseData.phoneNumber
                    );
                    Database.upsert(thirdParty);
                    interaction.Third_Party__c = thirdParty.Id;
                }
            } else if (providerDetails.isProviderNotFound) {
                thirdParty = new Third_Party__c(
                    FullName__c = providerDetails.firstName + ' ' + providerDetails.lastName,
                    First_Name__c = providerDetails.firstName,
                    LastName__c = providerDetails.lastName,
                    Phone_Number__c = providerDetails.phoneNumber
                );
                Database.upsert(thirdParty);
                interaction = new Interaction__c(
                    Third_Party__c = thirdParty.Id,
                    Originator_Name__c = providerDetails.firstName + ' ' + providerDetails.lastName,
                    Originator_Type__c = 'Provider',
                    Interaction_Type__c = flowDetails.interactionType
                );
            } else if (providerDetails.isOther) {
				//DE356886 added by vinay
                List<String> orginatorName = new List<String>();
                String firstName,lastName;
                if(String.isNotBlank(flowDetails.contactName)){
                    orginatorName = flowDetails.contactName.split(' ');
                    if(orginatorName.size() > 0){
                        firstName = orginatorName[0];
                        lastName = orginatorName[1];
                    }
                }
                thirdParty = new Third_Party__c(
                    FullName__c = flowDetails.contactName,
					First_Name__c = firstName, 
                    LastName__c = lastName,
                    Phone_Number__c = flowDetails.contactNumber
                );
                Database.upsert(thirdParty);
                interaction = new Interaction__c(
                    Third_Party__c = thirdParty.Id,
                    Originator_Name__c = flowDetails.contactName,
                    Originator_Type__c = 'Other',
                    Interaction_Type__c = flowDetails.interactionType
                );
            }

            interaction = transformationVCCD(interaction,isVCCD,VCCDRecordId,flowDetails);//US2903847
            Database.insert(interaction);
            System.debug('@@ ACET_InteractionOverviewCtrl: createInteraction: interaction: ' + interaction);
            Interaction__c interactionRecord = [SELECT Id, Name, Originator__c FROM Interaction__c WHERE Id =: interaction.Id];
            System.debug('@@ ACET_InteractionOverviewCtrl: createInteraction: interactionRecord: ' + interactionRecord);
            return interactionRecord;
        } catch (exception e) {
            system.debug('exception::' + e.getStackTraceString());
            return null;
        }

    }

    @AuraEnabled
    public static Interaction__c updateInteraction(ACET_ExplorePageCtrl.FlowDetails flowDetails,
                                                   ACET_ProviderSearchCtrl.ProviderDetails providerDetails,
                                                   String interactionId,
                                                          Boolean isVCCD,
                                                  String VCCDRecordId) {
        System.debug('@@ ACET_InteractionOverviewCtrl: createInteraction: interactionId: ' + flowDetails);
        System.debug('@@ ACET_InteractionOverviewCtrl: createInteraction: interactionId: ' + providerDetails);
        System.debug('@@ ACET_InteractionOverviewCtrl: createInteraction: interactionId: ' + interactionId);
        Id personAccountRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('PersonAccount').getRecordTypeId();
        Account providerAccount;
        Third_Party__c thirdParty = new Third_Party__c();
        Interaction__c interaction;
        if (providerDetails.isValidProvider) {
            providerAccount = new Account(
                RecordTypeId = personAccountRecordTypeId,
                FirstName = providerDetails.firstName,
                LastName = providerDetails.lastName,
                EID__c = providerDetails.providerId,
                Tax_Id__c = providerDetails.taxId,
                Phone = providerDetails.phoneNumber
            );
            Database.upsert(providerAccount, Account.Fields.EID__c);
            interaction = new Interaction__c(
                Originator__c = getPersonContactId(providerAccount.Id),
                Originator_Name__c = providerDetails.firstName + ' ' + providerAccount.lastName,
                Originator_Type__c = 'Provider',
                Interaction_Type__c = flowDetails.interactionType
            );
        } else if (providerDetails.isProviderNotFound) {
            thirdParty = new Third_Party__c(
                FullName__c = providerDetails.firstName + ' ' + providerDetails.lastName,
                First_Name__c = providerDetails.firstName,
                LastName__c = providerDetails.lastName,
                Phone_Number__c = providerDetails.phoneNumber
            );
            Database.upsert(thirdParty);
            interaction = new Interaction__c(
                Third_Party__c = thirdParty.Id,
                Originator_Name__c = providerDetails.firstName + ' ' + providerDetails.lastName,
                Originator_Type__c = 'Provider',
                Interaction_Type__c = flowDetails.interactionType
            );
        } else if (providerDetails.isOther) {
			//DE356886 added by vinay
                List<String> orginatorName = new List<String>();
                String firstName,lastName;
                if(String.isNotBlank(flowDetails.contactName)){
                    orginatorName = flowDetails.contactName.split(' ');
                    if(orginatorName.size() > 0){
                        firstName = orginatorName[0];
                        lastName = orginatorName[1];
                    }
                }
            thirdParty = new Third_Party__c(
                FullName__c = flowDetails.contactName,
				First_Name__c = firstName,
                LastName__c = lastName,
                Phone_Number__c = flowDetails.contactNumber
            );
            Database.upsert(thirdParty);
            interaction = new Interaction__c(
                Third_Party__c = thirdParty.Id,
                Originator_Name__c = flowDetails.contactName,
                Originator_Type__c = 'Other',
                Interaction_Type__c = flowDetails.interactionType
            );
        }
        if (!providerDetails.isNoProviderToSearch) {
            interaction.Id = interactionId;
            interaction = transformationVCCD(interaction,isVCCD,VCCDRecordId,flowDetails);//US2903847
            Database.update(interaction);
        }
        interaction = [SELECT Id, Name, Originator__c FROM Interaction__c WHERE Id =: interactionId];
        System.debug('@@ ACET_InteractionOverviewCtrl: updateInteraction: interaction: ' + interaction);
        return interaction;
    }

    //US2903847
    public static Interaction__c transformationVCCD(Interaction__c intRecord,Boolean isVCCD, string VCCDRecordId,ACET_ExplorePageCtrl.FlowDetails flowDetails){
         //US2631703 - Durga- 08th June 2020
         Interaction__c interaction = intRecord;
        //US2903847 -START
        if(isVCCD && string.isNotBlank(VCCDRecordId)){
                List<VCCD_Response__c> VCCDRecord = [SELECT Id,Ani__c, ClaimId__c, ClaimsDOSMD__c, MemberId__c, MSID__c, NPI__c, ProductType__c, QuestionType__c, SubjectDOB__c,
                QuestionTypeTopic__c, TaxId__c, TFN__c, Ucid__c FROM VCCD_Response__c WHERE Id= :VCCDRecordId];
                if(!VCCDRecord.isEmpty()){
                    interaction.Tax_Id__c = VCCDRecord[0].TaxId__c != null  ? VCCDRecord[0].TaxId__c :  '--';
                    interaction.Caller_Type__c = VCCDRecord[0].ProductType__c;
                    interaction.TFN_Toll_Free_Number__c = VCCDRecord[0].TFN__c != null  ? VCCDRecord[0].TFN__c  : '--';
                    interaction.Caller_Id_ANI__c  = VCCDRecord[0].Ani__c != null ? VCCDRecord[0].Ani__c : '--';
                    interaction.Member_Id__c      = VCCDRecord[0].MemberId__c != null ? VCCDRecord[0].MemberId__c : '--';
                    interaction.NPI__c = VCCDRecord[0].NPI__c != null ? VCCDRecord[0].NPI__c : '--';
                    interaction.Group_ID__c  =  '--';
                    interaction.Question_Type__c  = VCCDRecord[0].QuestionTypeTopic__c != null ? VCCDRecord[0].QuestionTypeTopic__c : '--';
                    interaction.Claim_Authorization_Referral_Number__c  = VCCDRecord[0].ClaimId__c != null ? VCCDRecord[0].ClaimId__c : '--';
                    interaction.Member_Date_of_Birth__c  =  VCCDRecord[0].SubjectDOB__c;
                    delete VCCDRecord[0];
                }
            }
        else if(!isVCCD && flowDetails != null && flowDetails.isGenesys && String.isNotBlank(String.valueof(flowDetails.IVRinfo))){
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
        return interaction;
    }

    public static Id getPersonContactId(Id personAccountId) {
        return [SELECT Id, FirstName, LastName, PersonContactId FROM Account WHERE Id =: personAccountId].PersonContactId;
    }
    
    @AuraEnabled
    public static String getHippaGuideLinesUrl(){
       String endPoint = SAEUtils.getHippaGuideLinesUrl();
        return endPoint;
    }

}