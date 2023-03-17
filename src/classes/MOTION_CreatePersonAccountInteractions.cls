public class MOTION_CreatePersonAccountInteractions {
    
	/**
     * Search and Create personAccount request from Acet Motion
     */
    @AuraEnabled 
    public static Account createAccount(String FirstName,String LastName,String DOB,String email,String interactType, String mbrRegisteredId, String mbrEligibleId, String phone){
                                                                                             
        Id PersonAccrecTypeId = ACETLGT_CreateConstituents.getPersonAccountRecordType();
        Account ACETAccount = new Account();
        system.debug('--createAccount-dermID-->'+ mbrRegisteredId);
        String personAccQuery = 'SELECT Id,FirstName,LastName,PersonBirthdate,PersonEmail,Phone,RecordTypeId,Motion_Registered_Member_ID__c,Motion_Eligible_Member_ID__c FROM Account ';
        if(String.isNotEmpty(mbrRegisteredId) && String.isNotEmpty(mbrEligibleId)){
            personAccQuery = personAccQuery + 'WHERE Motion_Registered_Member_ID__c =: mbrRegisteredId OR Motion_Eligible_Member_ID__c =: mbrEligibleId';
        } else if(String.isNotEmpty(mbrRegisteredId)){
         	personAccQuery = personAccQuery + 'WHERE Motion_Registered_Member_ID__c =: mbrRegisteredId';
        } else if(String.isNotEmpty(mbrEligibleId)){
			personAccQuery = personAccQuery + 'WHERE Motion_Eligible_Member_ID__c =: mbrEligibleId';            
        }
		System.debug('personAccQuery>>>'+personAccQuery);
        List<Account> ACETAccountList = Database.query(personAccQuery);
        String fmtDOB = ACETLGT_CreateConstituents.formatDatewithslash(DOB);
        system.debug('---ACCOUNTLIST-->'+ ACETAccountList);
        if( ACETAccountList.isEmpty() && (String.isNotEmpty(mbrRegisteredId) || String.isNotEmpty(mbrEligibleId))){
              System.debug('Inserting Account record.');
            Boolean accountfirst = true;           
            ACETAccount = new Account(                
                FirstName = FirstName,
                LastName  = LastName,                
                PersonBirthdate = fmtDOB != null ? Date.valueOf(fmtDOB): null,
                Motion_Registered_Member_ID__c = mbrRegisteredId,
                Motion_Eligible_Member_ID__c = mbrEligibleId,
				Contact_Type__pc = interactType,
                PersonEmail = MotionCommonUtil.validEmailconversion(email),
                OwnerID = UserInfo.getUserId(),
                RecordTypeId = PersonAccrecTypeId,
                Phone = phone
            );
            try{       
                Database.insert(ACETAccount);
                if(ACETAccount.Id != null && ACETAccount.Id!=''){
                    Interaction__c interaction = createInteraction(interactType, 'Member', ACETAccount, '');
                    if(interaction.Id != null){
                        System.debug('Interaction record created successfully: '+ interaction.Id);
                    }
                }
            }catch(Exception ex){
                System.debug(ex.getMessage());
            }            
            
        } else if(ACETAccountList != null && !ACETAccountList.isEmpty() ){          
            ACETAccount = ACETAccountList.get(0);
            ACETAccount.Id = ACETAccountList.get(0).Id;
            System.debug('Updating Account record.');
            System.debug('Existing email id:  '+ACETAccount.PersonEmail +'From account:'+ACETAccount);
            if(ACETAccount != null && ACETAccount.Id != null){
                
                if(mbrEligibleId != null && ACETAccount.Motion_Eligible_Member_ID__c != mbrEligibleId){                  
                    ACETAccount.Motion_Eligible_Member_ID__c = mbrEligibleId;
                }
                if(mbrRegisteredId != null && ACETAccount.Motion_Registered_Member_ID__c != mbrRegisteredId){                  
                    ACETAccount.Motion_Registered_Member_ID__c = mbrRegisteredId;
                }
                if(FirstName!= null && ACETAccount.FirstName != FirstName){                  
                    ACETAccount.FirstName = FirstName;
                }
                if(FirstName!= null && ACETAccount.FirstName != FirstName){                  
                    ACETAccount.LastName = LastName;
                }
                if(fmtDOB!= null && ACETAccount.PersonBirthdate != Date.valueOf(fmtDOB)){                  
                    ACETAccount.PersonBirthdate = Date.valueOf(fmtDOB);
                }
                if(email!= null & ACETAccount.PersonEmail != email){                  
                    ACETAccount.PersonEmail = email;
                }
                if(String.isNotEmpty(interactType)){
                    ACETAccount.Contact_Type__pc = interactType;
                }
                if(phone!= null & ACETAccount.Phone != phone){                  
                    ACETAccount.Phone = phone;
                }
            }
            try{       
                Database.update(ACETAccount);                
            }catch(Exception ex){
                System.debug(ex.getMessage());
            }
        }           
        return ACETAccount;
    }

    @AuraEnabled
    public static Interaction__c createInteraction(String InteractionType, String OriginatorType, Account con, String thirdPartyId){
      Interaction__c interaction = new Interaction__c();
        interaction.Interaction_Type__c = InteractionType;        
        if(con!= null){
        Account personContact = [SELECT id, PersonContactId,Name FROM Account where id=: con.id];
        interaction.Originator__c = personContact.PersonContactId;
        interaction.Originator_Name__c = personContact.Name;
        }
        if(String.isNotEmpty(originatorType)){
            interaction.Originator_Type__c = originatorType;
        }
        if(String.isNotEmpty(thirdPartyId)){
            
            interaction.Third_Party__c = thirdPartyId;
        }        
        interaction.OwnerID = UserInfo.getUserId();
        Database.insert(interaction);
                
        if(interaction.Id != null){
            System.debug('Interaction record created successfully: '+ interaction.Id);
       }
        return interaction;            
    }
    @AuraEnabled
     public static Interaction__c queryInteraction(String InteractionId){        
       system.debug('query>>>'+InteractionId);
       Interaction__c Interaction = new Interaction__c();
       List<Interaction__c> InteractionList = new List<Interaction__c>();
        if (InteractionId != null && InteractionId !='')
        {
        InteractionList = [SELECT Id, Name, Interaction_Type__c, Provider_ID__c, Group_ID__c, Originator_Type__c, Originator_Name__c,Contact_Name__c, Caller_Type__c, Highlight_Panel_GroupInfo__c,Originator__c, Originator__r.EID__c, Originator__r.Tax_ID__c, Originator__r.NPI__c, 
            Originator__r.Name,Id__c, Originator__r.LastName, Originator__r.FirstName, Originator__r.AccountId,Originator__r.Account.Name,Originator__r.Birthdate,Originator__r.mailingState,Originator__r.mailingPostalCode,Originator__r.Phone, Third_Party__c, Third_Party__r.Tax_ID__c, Third_Party__r.NPI__c, 
            Third_Party__r.FullName__c, Provider_Address_Id__c , Provider_Address_Type__c, Third_Party__r.LastName__C,Third_Party__r.Producer_Name__C, Third_Party__r.First_Name__c,Third_Party__r.Employer_Name__c, Third_Party__r.Phone_Number__c, Third_Party__r.Email__c,
            Third_Party__r.DOB__C, Third_Party__r.Group_Number__c,Third_Party__r.Group_Name__c,Third_Party__r.Mailing_PostalCode__c,Third_Party__r.Mailing_State__c            
            FROM Interaction__c WHERE Id =:InteractionId];
        }         
              
        if(InteractionList.size() > 0){
            Interaction = InteractionList[0];
            return Interaction;
        }else{
            return null;
        }
     }
     
     @AuraEnabled
     public static Interaction__c creatThirdPartyAndInteraction(String firstName, String lastName, string emailaddress, string phone, String groupname, string groupnumber, string dob, String state, string zip, string inttype){
         
        Interaction__c interaction = new Interaction__c();
        String fmtDOB = ACETLGT_CreateConstituents.formatDatewithslash(dob);         
         Third_Party__c thirdaccount = new Third_Party__c();
          thirdaccount = new Third_Party__c(
           LastName__c = lastName,
             First_Name__c  = firstName,            
             Email__c = emailaddress,
             Phone_Number__c = phone,
             Group_Name__c = groupname,
             DOB__c = (fmtDOB != null?Date.valueOf(fmtDOB):null),
             Group_Number__c = groupnumber,
             Mailing_State__c = state,
             Mailing_PostalCode__c=zip
             
        );
        try{

            Database.insert(thirdaccount);          
            if(thirdaccount.Id != null ){
                interaction = createInteraction(inttype, 'Other', null, thirdaccount.id);
             
                if(interaction.Id != null){
                    interaction= queryInteraction(interaction.Id);                    
                }
            }
        }catch(Exception ex){
            System.debug(ex.getMessage());
        }
        return interaction;            
     }
    
}