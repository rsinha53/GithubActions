/*
 Name           : OPTUM_MemberAccountController
 Created By     : Dimpy Arora
 Created Date   : Oct 10, 2020
 Description    : Controller for do all salesforce platform records  */
public with sharing class OPTUM_MemberAccountController {
 Public static String SRKKeyChain=null;
// Modified By Prasad -US3381292 -'WEX' Deep Link - Member Level - Member Page
     @AuraEnabled 
    public static Account addPersonAccount(String firstName,String lastName,String dob,String eid,String participantEmployeeExternalId,String participantEmployerCode,String participantAdminAlias ){
        Id PersonAccrecTypeId = getPersonAccountRecordType();
        Account ACETAccount = new Account();
        List<Account> ACETAccountList = [SELECT id,FirstName,LastName,SRK_KeyChain__c,SRK_KeyChain__pc,EID__c,EID__pc,PersonBirthdate,RecordTypeId,ParticipantAdminAlias__c,ParticipantEmployeeExternalId__c,ParticipantEmployerCode__c FROM Account WHERE EID__c =: EID ];
        system.debug('---ACCOUNTLIST-->'+ ACETAccountList);
        if( ACETAccountList.isEmpty() && SRKKeyChain != null && SRKKeyChain != ''){
            Boolean accountfirst = true;
            String accountQuery = 'Select Id,EID__c,SRK_KeyChain__c,ParticipantAdminAlias__c,ParticipantEmployeeExternalId__c,ParticipantEmployerCode__c from Account';
            if(SRKKeyChain.indexOf(',') != -1){
                for(String sk : SRKKeyChain.split(',')){
                        if(!accountfirst){
                            accountQuery = accountQuery + ' OR';
                        } else {
                            accountQuery = accountQuery + ' WHERE';
                        }
                    accountQuery = accountQuery + ' Account.SRK_KeyChain__c LIKE \'%' + sk + '%\'';
                    accountQuery = accountQuery + ' or EID__c= \''+ EID+'\'';
                    accountfirst = false;
                }
            }else{
                accountQuery = accountQuery + ' WHERE Account.SRK_KeyChain__c LIKE \'%' + SRKKeyChain + '%\'';
                accountQuery = accountQuery + ' or EID__c= \''+ EID+'\'';
            }
            List<Account> ACETAccountListMatchingSRK = Database.query(accountQuery);
            if( ACETAccountListMatchingSRK.isEmpty()){
                ACETAccount = new Account(
                        FirstName = firstName,
                        LastName  = lastName,
                        SRK_KeyChain__c=SRKKeyChain,
                        SRK_KeyChain__pc=SRKKeyChain,
                        EID__c=eid,
                        EID__pc = eid,
						ParticipantEmployeeExternalId__c = participantEmployeeExternalId,
						ParticipantEmployerCode__c = participantEmployerCode,
						ParticipantAdminAlias__c = participantAdminAlias,
                        PersonBirthdate = formatDatewithslash(dob) != null ? Date.valueOf(formatDatewithslash(dob)): null,
                        RecordTypeId = PersonAccrecTypeId
                        );
                if(ACETAccount != null && ACETAccount.lastName != null && ACETAccount.EID__c != null){
                    Database.upsert(ACETAccount, Account.Fields.EID__c);
                    ACETAccount.FirstName = firstName;
                    ACETAccount.LastName  = lastName;
                    ACETAccount.SRK_KeyChain__pc=SRKKeyChain;
                    ACETAccount.ParticipantEmployeeExternalId__c = participantEmployeeExternalId;
					ACETAccount.ParticipantEmployerCode__c = participantEmployerCode;
					ACETAccount.ParticipantAdminAlias__c = participantAdminAlias;
                    ACETAccount.PersonBirthdate = formatDatewithslash(dob) != null ? Date.valueOf(formatDatewithslash(dob)): null;
                    ACETAccount.RecordTypeId = PersonAccrecTypeId;
                    Update ACETAccount;
                } 
            }else{
               ACETAccount = new Account(
                                     	FirstName = firstName,
                                        LastName  = lastName,
                                        SRK_KeyChain__c=SRKKeyChain,
                                        SRK_KeyChain__pc=SRKKeyChain,
                                        EID__c=eid,
                                        EID__pc = eid,
										ParticipantEmployeeExternalId__c = participantEmployeeExternalId,
						                ParticipantEmployerCode__c = participantEmployerCode,
						                ParticipantAdminAlias__c = participantAdminAlias,
                                        PersonBirthdate = formatDatewithslash(dob) != null ? Date.valueOf(formatDatewithslash(dob)): null,
                                      	RecordTypeId = PersonAccrecTypeId
                                     );
                if(ACETAccount != null && ACETAccount.LastName != null && ACETAccount.EID__c != null){
                    Database.upsert(ACETAccount, Account.Fields.EID__c);
                    ACETAccount.FirstName = firstName;
                    ACETAccount.LastName  = lastName;
					ACETAccount.ParticipantEmployeeExternalId__c = participantEmployeeExternalId;
					ACETAccount.ParticipantEmployerCode__c = participantEmployerCode;
					ACETAccount.ParticipantAdminAlias__c = participantAdminAlias;
                    ACETAccount.SRK_KeyChain__pc=SRKKeyChain;
                    ACETAccount.PersonBirthdate = formatDatewithslash(dob) != null ? Date.valueOf(formatDatewithslash(dob)): null;
                    ACETAccount.RecordTypeId = PersonAccrecTypeId;
                    Update ACETAccount;
                }  
            }
        }else if(ACETAccountList != null && !ACETAccountList.isEmpty() ){
            ACETAccount.Id = ACETAccountList.get(0).Id;
            if(SRKKeyChain != null && SRKKeyChain != '')
            	ACETAccount.SRK_KeyChain__c=SRKKeyChain;
            ACETAccount.EID__c=eid;
            if(ACETAccount != null && ACETAccount.EID__c != null){
                Database.upsert(ACETAccount, Account.Fields.EID__c);  
                Account ACETContact = getPersonAccounts(ACETAccount.EID__c);
                if(ACETContact != null){
                    ACETContact.FirstName = firstName;
                    ACETContact.LastName  = lastName;
                    if(SRKKeyChain != null && SRKKeyChain != '')
                    	ACETContact.SRK_KeyChain__pc=SRKKeyChain;
                    ACETContact.EID__pc = eid;
					ACETContact.ParticipantEmployeeExternalId__c = participantEmployeeExternalId;
					ACETContact.ParticipantEmployerCode__c = participantEmployerCode;
					ACETContact.ParticipantAdminAlias__c = participantAdminAlias;
                    ACETContact.PersonBirthdate = formatDatewithslash(dob) != null ? Date.valueOf(formatDatewithslash(dob)): null;
                    ACETContact.RecordTypeId = PersonAccrecTypeId;
                    if(ACETContact != null && ACETContact.LastName != null && ACETContact.EID__pc != null){
                        Database.update(ACETContact) ;
                    }
                } 
            }
        }else{
            ACETAccount = new Account(
                                     	FirstName = firstName,
                                        LastName  = lastName,
                                        SRK_KeyChain__c=SRKKeyChain,
                                        SRK_KeyChain__pc=SRKKeyChain,
                                        EID__c=eid,
                                        EID__pc = eid,
										ParticipantEmployeeExternalId__c = participantEmployeeExternalId,
						                ParticipantEmployerCode__c = participantEmployerCode,
						                ParticipantAdminAlias__c = participantAdminAlias,
                                        PersonBirthdate = formatDatewithslash(dob) != null ? Date.valueOf(formatDatewithslash(dob)): null,
                                      	RecordTypeId = PersonAccrecTypeId
                                     );
            if(ACETAccount != null && ACETAccount.LastName != null && ACETAccount.EID__c != null){
            	Database.upsert(ACETAccount, Account.Fields.EID__c);
            }
        }
        return ACETAccount;
    }
  
    // Added By Prasad -US3381292 -'WEX' Deep Link - Member Level - Member Page
    public static Id getPersonAccountRecordType(){
    
        RecordType personAccRecordType =  [SELECT Id FROM RecordType WHERE Name = 'Person Account' and SObjectType = 'Account'];
        return personAccRecordType.Id;
    }
    // Added By Prasad -US3381292 -'WEX' Deep Link - Member Level - Member Page
    @AuraEnabled 
    public static Account getPersonAccounts(string eid){
        List<Account> ACETPAList = [SELECT FirstName,LastName,id,EID__c FROM Account WHERE EID__pc =: eid ];
        if(ACETPAList != null && ACETPAList.size() > 0)
        	return ACETPAList.get(0);
        else
            return null;
    }
	// Added By Prasad -US3381292 -'WEX' Deep Link - Member Level - Member Page
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
     // Added memberDetails parameter as part of US3329760 by Venkat
       @AuraEnabled
    public static Interaction__c createInteraction(String interactionType, String originatorType,Account con, String question,Object memberDetails){
        Interaction__c interaction = new Interaction__c();
        Interaction.Interaction_Type__c = interactionType;
        Interaction.Originator_Type__c = originatorType;
         Account personContact = [SELECT id, PersonContactId,Name FROM Account where id=: con.id];
            interaction.Originator__c = personContact.PersonContactId;
            interaction.Originator_Name__c = personContact.Name;
            interaction.Originator_Type__c = originatorType;
            Database.insert(interaction); 
  //Added by Prasad US3029205: Create Originator - Third party creation
         Third_Party__c thirdaccount = new Third_Party__c();
          thirdaccount = new Third_Party__c(
           LastName__c = personContact.Name,
           First_Name__c  = personContact.Name 
        );
        try{
            Database.insert(thirdaccount);          
            if(thirdaccount.Id != null ){
               interaction.Third_Party__c = thirdaccount.Id;
                Update interaction;
                if(interaction.Id != null){
                    interaction= queryInteraction(interaction.Id);                    
                }
            }

            // Added as part of US3329760 by Venkat
            createPlatformCache( interaction,con,memberDetails);

        }catch(Exception ex){
            System.debug(ex.getMessage());
        }
        return interaction;
    }

    // Created Method as part of US3329760 by Venkat
    /************************************
    * @MethodName: createPlatformCache
    * @Return Type: boolean
    * @Parameters: Interaction__c,Account,Object
    ************************************/
   @AuraEnabled
    public static boolean createPlatformCache(Interaction__c objIintRec, Account con, Object memberDetails){
        Boolean memberDetailsChached=false;
        Cache.SessionPartition sessionPart = Cache.Session.getPartition('local.OPTUMMemberSearchResultsCache');

        if(sessionPart!=null && objIintRec!=null && con !=null ){
            Map<String,Object> mapOfData = new Map<String,Object>();
            mapOfData.put('INTERACTION',objIintRec);
            mapOfData.put('MEMBERDETAILS',memberDetails);
            mapOfData.put('ACCOUNT',con);
            sessionPart.put(con.Id, mapOfData);
            system.debug('### createPlatformCache==>:'+sessionPart);
            memberDetailsChached = true;
        }else{
            memberDetailsChached = false;
        }

        return  memberDetailsChached;
    }
    // Created Method as part of US3329760 by Venkat
    /************************************
    * @MethodName: getPlatformCacheResponse
    * @Return Type: Map<String,Object>
    * @Parameters: personAccID
    ************************************/
     @AuraEnabled
    public static  Map<String,Object> getPlatformCacheResponse(string personAccID){
        Map<String,Object> mapOfDataRes = new Map<String,Object>();
        try{
            Cache.SessionPartition sessionPart = Cache.Session.getPartition('local.OPTUMMemberSearchResultsCache');
        if(String.isNOTBlank(personAccID)){
            mapOfDataRes= (Map<String,Object>)sessionPart.Get(String.valueOf(personAccID));
            if (mapOfDataRes == null) {
                //US3507212 Load Member Details via Accounts
                Map<String,Object> mapOfDataResult = new Map<String,Object>();
                List<Account> personAccList = new List<Account>();
                personAccList = [SELECT id,EID__c FROM Account WHERE Id =:personAccID];
                String faroID = personAccList[0].EID__c;
                OPTUM_MemberSearchReponse returnVall =  (OPTUM_MemberSearchReponse)OPTUM_VCCDBridgeController.getMemberDetails(faroID);
                mapOfDataResult.put('MEMBERDETAILS', returnVall.result.data);
                mapOfDataRes = mapOfDataResult;
            }
        }else{
            mapOfDataRes=null;
        }
        }catch(exception e){
           System.debug('### exception in getPlatformCacheResponse ==>:'+e.getMessage());
        }

        return mapOfDataRes;
    }
      @AuraEnabled 
    public static user getUser(){
     // query current user information  
      User oUser = [select id,Name,Agent_Type__c,Profile_Name__c,Role_Name__c FROM User Where id =: userInfo.getUserId()];
        system.debug('oUser:: '+oUser);
        return oUser;
    }
	 //For Originator screen- Added by prasad: US2967182
    @AuraEnabled
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
 //Added by Prasad US3039766: Get Org Name
    @AuraEnabled 
    public static  Organization getorg(){
     // query to get Organization
	 Organization org =OPTUM_MemberSearchService.getorg();
        return org;
    }
	//Added by DImpy
    @AuraEnabled
    public static OPTUM_MemberSearchReponse searchMemberWithSSN(String faroId) {
      OPTUM_MemberSearchReponse responseWrapper = new OPTUM_MemberSearchReponse();
      HttpResponse response;
      ACET_WebserviceCalloutFramework wsCallOutFW = new ACET_WebserviceCalloutFramework('OptumVCCDMemberSearch', '',null);
      wsCallOutFW.certificateName = OPTUM_MemberSearchService.certName;
      wsCallOutFW.faroID = faroId;
      response = wsCallOutFW.getResponse();
      system.debug('response'+response);
      if(response.getStatusCode() == 200) {
          responseWrapper = OPTUM_MemberSearchReponse.parse(response.getBody());
      } else {
          responseWrapper.responseCode = String.valueOf(response.getStatusCode());
          responseWrapper.responseMsg = response.getStatus();
      }
      return responseWrapper; 
    }	
	
	  // Created by Dimpy for originator Issue
    /************************************
    * @MethodName: createPlatformCache
    * @Return Type: boolean
    * @Parameters: String,String,String
    ************************************/
	
	 @AuraEnabled 
    public static ACETLGT_HighlightPanelInfo updateIntOriginator(String originatorId, String subjectID,
                                          String tpRel){
       ACETLGT_HighlightPanelInfo hpInfo = new ACETLGT_HighlightPanelInfo();
        hpInfo.subjectID = subjectID;
           if (subjectID != null && subjectID != ''){
                    hpInfo.subjectID = subjectID;
                }
                                              if(tpRel!= null && tpRel!=''){
                                                  hpInfo.originatorRel = tpRel;}else {
                                                  hpInfo.originatorRel ='';    
                                                  }
                if (originatorId != null && originatorId != '' && originatorId != 'Third Party'){
                   		string orgiId = String.valueOf(originatorId) ;
                        hpInfo.originatorID = orgiId;
                        System.debug('=========orgiId=======>>'+orgiId);                        
                        String originatorName;
                        
                        if (orgiId.startsWith('003')){
                        	originatorName = [SELECT id,Name FROM Contact WHERE id =:orgiId  LIMIT 1].Name;
                             System.debug('-----originatorName 003----->'+originatorName);
                          hpInfo.originatorName = originatorName;
                        }
                        else{
                            originatorName = String.valueOf(originatorId);
                        System.debug('-----originatorName----->'+originatorName);
                        hpInfo.originatorName = originatorName;
                        }
                       
                     
                }
        return (ACETLGT_HighlightPanelInfo) System.JSON.deserialize(JSON.serialize(hpInfo), ACETLGT_HighlightPanelInfo.class);
    }
	
}