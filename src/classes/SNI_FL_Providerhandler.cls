/********************************************************************************* 
Class Name     : SNI_FL_Providerhandler.cls
Description    : This class used fetch the Provider Affliation/Teams and Users record
Created By     : Balakrishnan
Created Date   : 11/25/2020
*********************************************************************************/
public class SNI_FL_Providerhandler {

    @AuraEnabled(cacheable=true)
    public static Map<String, Id> getData_NewProviderAffiliation() {
        Map<String, Id> returnMap = new Map<String, Id>();
        returnMap.put('RecordTypeId', Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Provider_Affiliation').getRecordTypeId());
        Map<String, Id> programs = new Map<String, Id>();
        for(Program__c program : [select Id, Program__c from Program__c]) {
            returnMap.put(program.Program__c, program.Id);
        }
        return returnMap;
    }
    
    @AuraEnabled
    public static String createAccount(String population, Id programId, Id parentId, String parentAccountName){
        String programName = [Select Id, Program__c from Program__c where Id =: programId Limit 1].Program__c;
        String accountName = parentAccountName + '-' + programName + population;
        Id ProviderRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Provider Affiliation').getRecordTypeId();
        
        Account affiliateAccount = new Account(
            Name = parentAccountName + '-' + programName + '-' + population,
            ParentId = parentId,
            Population__c = population,
            Program__c = programId,
			RecordTypeId = ProviderRecordTypeId             
        );
        insert affiliateAccount;
        
        Account parentAccount = [Select Id, Programs_Offered__c,Population_Offered__c from Account where Id =: parentId];
        Set<String> currentProgramsOffered = NULL == parentAccount.Programs_Offered__c ? new Set<String>() : new Set<String>(parentAccount.Programs_Offered__c.split(';'));
        Set<String> currentPopulationOffered = NULL == parentAccount.Population_Offered__c ? new Set<String>() : new Set<String>(parentAccount.Population_Offered__c.split(';'));
        if(!currentProgramsOffered.contains(programName)) {
            currentProgramsOffered.add(programName);
            parentAccount.Programs_Offered__c = String.join(new List<String>(currentProgramsOffered), ';');
        }
        if(!currentPopulationOffered.contains(population)) {
            currentPopulationOffered.add(population);
            parentAccount.Population_Offered__c = String.join(new List<String>(currentPopulationOffered), ';');
        }
            //parentAccount.Population__c=population;
            update parentAccount;
       
            
        return JSON.serialize(affiliateAccount);
    }
    
    @AuraEnabled
    public static String createProviderTeam(id ProviderAffiliation,  String TeamName){
        Id ProviderRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Provider Team').getRecordTypeId();
        Account Providerteam= new Account(
            LastName = TeamName,
            Team_Name__c=TeamName,
            RecordTypeId = ProviderRecordTypeId);             
        
        insert Providerteam;
        if(Providerteam.id !=null){
            Contact Teamcontactid = [select id from contact where AccountId =:Providerteam.ID];
            AccountContactRelation AccountContactRelationTeam= new AccountContactRelation(
            
            AccountId = ProviderAffiliation,
            ContactId = Teamcontactid.id,
            Relationship__c = 'Provider Team'); 
            insert AccountContactRelationTeam;
        }
        return JSON.serialize(Providerteam);
    }
    
    @AuraEnabled
    public static String createProviderUser(id providerAffilition, String Salutation, String FirstName, String LastName,String Email){
         
       String providerGrp = [Select Id, ParentId,name from Account where Id =: providerAffilition Limit 1].ParentId;
     
       Id ProviderRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Provider User').getRecordTypeId();
        
       Account Provideruser= new Account(
            Salutation =Salutation,
            FirstName = FirstName,
            LastName = LastName,
            PersonEmail = Email,
            Provider_Group__c = providerGrp,
			RecordTypeId = ProviderRecordTypeId);
        
        insert Provideruser;
        
        if(Provideruser.id !=null){
            Contact userContactid = [select id from contact where AccountId =:Provideruser.ID];
            AccountContactRelation AccountContactRelationUser= new AccountContactRelation(
            
            AccountId = providerAffilition,
            ContactId = userContactid.id,
            Relationship__c = 'Provider User'); 
            insert AccountContactRelationUser;
        }
        return JSON.serialize(Provideruser);
    }
	 
    @AuraEnabled
    public static List<account> getchildaccountFromId(Id accountId){
    List<account> accountList = new List<account>();
        accountList = [select id,Name  from account where ParentId =:accountId and RecordType.Name = 'Provider Affiliation'];
        return accountList;    
    }
    @AuraEnabled
    public static List<account> getTeamaccountFromId(Id accountId){
    List<account> accountList = new List<account>();
        accountList = [select id,Name  from account where ParentId =:accountId and RecordType.Name = 'Provider Affiliation'];
        return accountList;    
    }
    @AuraEnabled
    public static wrapperProviderUser getProviderUserAff(Id ProviderAfiliationid){
    try{
            //Set<id> ProvideruserContactId = new Set<id>();
            Set<id> ProvideruserselectedContactId = new Set<id>();
            List<contact> Acrselectedobj = new List<contact>();
        	List<contact> allProviderUserobj = new List<contact>();
            List<String> AcrselectedStr = new List<String>();
        	List<String> allProviderUserStr = new List<String>();
            wrapperProviderUser objWrap = new  wrapperProviderUser(); 
            account acc = [select parentid from account where id=:ProviderAfiliationid];
            List<contact> ProvideruserContactId = [select id  from contact where account.RecordType.Name = 'Provider User' And account.Provider_Group__c =:acc.ParentId];
	        List<AccountContactRelation> ProviderUserselected = [Select ContactId  from AccountContactRelation where AccountId =: ProviderAfiliationid And Relationship__c = 'Provider User' and ContactId =:ProvideruserContactId];
            
			if(!ProviderUserselected.isEmpty()){	
            	for (AccountContactRelation ProviderUserId1 : ProviderUserselected){
                 ProvideruserselectedContactId.add(ProviderUserId1.ContactId);
                }
            }
            if(!ProvideruserselectedContactId.isEmpty()){	
               Acrselectedobj= [select id,Name,AccountId from contact where id in: ProvideruserselectedContactId];
            }
        	if(!Acrselectedobj.isEmpty()){	
               for(contact con: Acrselectedobj){
                  AcrselectedStr.add(con.Name);
               }
            }
            allProviderUserobj= [select id,AccountId,Name from contact where id in: ProvideruserContactId];  
        	if(!allProviderUserobj.isEmpty()){	
           	  for(contact con1: allProviderUserobj){
                 allProviderUserStr.add(con1.Name);
              }
            }
            objWrap.Acrselectedobj = Acrselectedobj;
            objWrap.allProviderUserobj = allProviderUserobj;
            objWrap.AcrselectedStr = AcrselectedStr;
            objWrap.allProviderUserStr = allProviderUserStr;
            return objWrap;
        }catch (DmlException e){
            system.debug('Something went wrong: '+ e.getMessage());
        }
        return null;
    }
    //US3169458 start
    //This method is created for to get the Provider user related to Provider Affilition linked as ACR with Provider Team
    @AuraEnabled
    public static wrapperProviderUser getProviderUser(Id TeamId){
    try{
            Set<id> ProvideruserContactId = new Set<id>();
            Set<id> ProvideruserselectedContactId = new Set<id>();
            List<contact> Acrselectedobj = new List<contact>();
        	List<contact> allProviderUserobj = new List<contact>();
            List<String> AcrselectedStr = new List<String>();
        	List<String> allProviderUserStr = new List<String>();
            wrapperProviderUser objWrap = new  wrapperProviderUser();    
    		contact TeamContactId = [select id from contact where AccountId =:TeamId Limit 1];
			AccountContactRelation ProviderAffId = [select AccountId from AccountContactRelation where ContactId =:TeamContactId.ID Limit 1];
			List<AccountContactRelation> ProviderUserId = [Select ContactId  from AccountContactRelation where AccountId =: ProviderAffId.AccountId And Relationship__c = 'Provider User'];
        	
            if(!ProviderUserId.isEmpty()){	
            	for (AccountContactRelation proivderusrid: ProviderUserId){    
                ProvideruserContactId.add(proivderusrid.ContactId);
                }
             }
            List<AccountContactRelation> ProviderUserselected = [Select ContactId  from AccountContactRelation where AccountId =: TeamId And ContactId in :ProvideruserContactId And Relationship__c = 'Provider User'];
    		
        	if(!ProviderUserselected.isEmpty()){	
            	for (AccountContactRelation ProviderUserId1 : ProviderUserselected){
                 ProvideruserselectedContactId.add(ProviderUserId1.ContactId);
                }
            }
            if(!ProvideruserselectedContactId.isEmpty()){	
               Acrselectedobj= [select id,Name,AccountId from contact where id in: ProvideruserselectedContactId];
            }
        	if(!Acrselectedobj.isEmpty()){	
               for(contact con: Acrselectedobj){
                  AcrselectedStr.add(con.Name);
               }
            }
            allProviderUserobj= [select id,AccountId,Name from contact where id in: ProvideruserContactId];  
        	if(!allProviderUserobj.isEmpty()){	
           	  for(contact con1: allProviderUserobj){
                 allProviderUserStr.add(con1.Name);
              }
            }
            objWrap.Acrselectedobj = Acrselectedobj;
            objWrap.allProviderUserobj = allProviderUserobj;
            objWrap.AcrselectedStr = AcrselectedStr;
            objWrap.allProviderUserStr = allProviderUserStr;
            return objWrap;
            
        }catch (DmlException e){
            system.debug('Something went wrong: '+ e.getMessage());
        }
        return null;
    }
    
    @AuraEnabled
    public static String AddRemoveProviderUser(Id TeamId,List<contact> AllProviderUser,List<contact> selectedProviderUserList,List<String> SelectedProviderUserStr){
    Boolean reccreted = false;
    Boolean recdeleted = false;
    try{
         Set<id> acrdelete = new Set<id>();
         List<AccountContactRelation> acrcreateList = new List<AccountContactRelation>();
         List<AccountContactRelation> acrdeleteList = new List<AccountContactRelation>();
         Set<string> selectedUser = new Set<String>();
         for(String conName: SelectedProviderUserStr){
          selectedUser.add(conName);
         }
         if(!selectedProviderUserList.isEmpty()){
          for(contact con: selectedProviderUserList){
           if(selectedUser.Contains(con.Name)){
             selectedUser.remove(con.Name); 
           }else{
		     acrdelete.add(con.Id);
         }
         }
        }
        
         for(contact con: AllProviderUser){
          if(selectedUser.Contains(con.Name)){
            AccountContactRelation acr = new AccountContactRelation();
            acr.AccountId = TeamId;
            acr.ContactId = con.Id;
            acr.Relationship__c = 'Provider User';
            acrcreateList.add(acr); 
          }
         }
         for (AccountContactRelation acrdel : [Select id  from AccountContactRelation where AccountId =: TeamId And ContactId in:acrdelete And Relationship__c = 'Provider User']){
                acrdeleteList.add(acrdel);
         }
         if(!acrcreateList.isEmpty()){
           reccreted = true;
           Insert acrcreateList;
         }
         if(!acrdeleteList.isEmpty()){
           recdeleted = true;
           Delete acrdeleteList;
         }    
        }catch (DmlException e){
            system.debug('Something went wrong: '+ e.getMessage());
        }
		
        if (reccreted && recdeleted){
          return 'Provider User ACR is Created and Removed';
        }else if (reccreted){
          return 'Provider User ACR is Created';
        }    
        else if (recdeleted){
          return 'Provider User ACR is Removed';
        }
        
		return null;
    }
    @AuraEnabled
    public static boolean isManageProviderGroup(){        
	Permissionset memPermission = [SELECT id, Name From Permissionset Where Name = 'Manager_External_User' Limit 1];
    if(memPermission.id != null){
    List<PermissionSetAssignment> memSetAssignments =  [Select id, Assigneeid, PermissionSetId From PermissionSetAssignment Where PermissionSetId =:memPermission.Id];
        if(memSetAssignments.size()>0){            
            for(PermissionSetAssignment memSetAssignment : memSetAssignments){
               if(memSetAssignment.Assigneeid == UserInfo.getUserId()){
                    return true;
                }
            }
        }    
      }   
      return false;
    }   
    public class wrapperProviderUser{
        @AuraEnabled public list<contact> Acrselectedobj;
        @AuraEnabled Public list<contact> allProviderUserobj;
        @AuraEnabled public list<String> AcrselectedStr;
        @AuraEnabled Public list<String> allProviderUserStr;
    }
   //US3169458 end
}