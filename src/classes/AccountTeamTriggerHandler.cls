/********************************************************************************* 
Class Name     : AccountTeamTriggerHandler.cls
Description    : AccountTeamTriggerHandler to automate backend data for Account Team Member 
Created By     : Srilakshmi Rayala
Created Date   : 12/09/2020

Modification Log:

*********************************************************************************/

public class AccountTeamTriggerHandler { 
        public static String Family_UserProfile = 'Center for Health Navigation';
        Id ProviderAffId,TeamsUserId;
        Set<Id> AccountCntId = new Set<Id>();
        Set<Id> ProvUserAcctId = new Set<Id>();
        Set<Id> ProvUserRecordTypeId = new Set<Id>();
        List<AccountTeamMember> lstAcctTeamMemberAffs = new List<AccountTeamMember>();
        List<AccountContactRelation> lstAcctCntRels = new List<AccountContactRelation>();
        List<Contact> lstCntRels = new List<Contact>();
        List<Account> lstAcctRels = new List<Account>();
        List<AccountTeamMember> lstAcctTeams = new List<AccountTeamMember>();        
        Id proUsrRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Provider User').getRecordTypeId();
	 	Id proTmsRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Provider Team').getRecordTypeId();
        String TeamMemberRole,AccountAccessLevel,OpportunityAccessLevel,CaseAccessLevel,ContactAccessLevel;
    
    Public void RemoveAccountTeams(List<AccountTeamMember> lstRemAcctMemberPrvAff){       
        for (AccountTeamMember acctTemmemAff : lstRemAcctMemberPrvAff)
        {
            ProviderAffId = acctTemmemAff.AccountId;
            TeamsUserId = acctTemmemAff.UserId;
            TeamMemberRole = acctTemmemAff.TeamMemberRole;            
        }
        if (TeamMemberRole == 'Account Team Member'){
             lstAcctCntRels = [SELECT AccountId,Contactid,Relationship__c FROM AccountContactRelation 
                          		where accountId =: ProviderAffId 
                          		AND (Relationship__c = 'Provider User' OR Relationship__c = 'Provider Team')];
        System.debug('>>>lstAcctCntRels' + lstAcctCntRels);
       lstAcctRels = SetRelatedAccounts(lstAcctCntRels);
             System.debug('>>>lstAcctRels' + lstAcctRels);
            for(Account acctPrv: lstAcctRels){
               List<AccountTeamMember> acctTeams = new List<AccountTeamMember>();
               acctTeams = [Select Id From AccountTeamMember Where AccountId =: acctPrv.Id AND UserId =: TeamsUserId];
                if(acctTeams.Size() > 0){
                    for (AccountTeamMember acctMem : acctTeams ){
                        lstAcctTeams.Add(acctMem);
                    }                   
               }                
            }
            if(lstAcctTeams.size() > 0){
                delete lstAcctTeams;  
            }       		          
        }        
    }
    Public list<account> SetRelatedAccounts(List<AccountContactRelation> lstAcctCntRels){
		for (AccountContactRelation acctCntRelAff : lstAcctCntRels)
        {
            AccountCntId.Add(acctCntRelAff.Contactid); 
        }        
        lstCntRels = [Select Name, accountid From Contact where id In: AccountCntId];
        System.debug('>>>lstCntRels' + lstCntRels);
        for (Contact CntRelPrvUser : lstCntRels)
        {
            ProvUserAcctId.Add(CntRelPrvUser.accountid); 
        }
        
        System.debug('>>>ProvUserAcctId' + ProvUserAcctId);
        lstAcctRels = [Select Name, id From Account where id In: ProvUserAcctId AND (RecordTypeId=:proUsrRecordTypeId
                                                                                    OR RecordTypeId=:proTmsRecordTypeId)];
		Return lstAcctRels;
	}
    Public void MapAccountTeams(List<AccountTeamMember> lstAcctMemberPrvAff){
        System.debug('>>>lstAcctMemberPrvAff' + lstAcctMemberPrvAff);  
        for (AccountTeamMember acctTemmemAff : lstAcctMemberPrvAff)
        {
            ProviderAffId = acctTemmemAff.AccountId;
            TeamsUserId = acctTemmemAff.UserId;
            TeamMemberRole = acctTemmemAff.TeamMemberRole;
            AccountAccessLevel = acctTemmemAff.AccountAccessLevel;
            OpportunityAccessLevel = acctTemmemAff.OpportunityAccessLevel;
            CaseAccessLevel = acctTemmemAff.CaseAccessLevel;
            ContactAccessLevel = acctTemmemAff.ContactAccessLevel;
        }
        if (TeamMemberRole == 'Account Team Member'){
            lstAcctCntRels = [SELECT AccountId,Contactid,Relationship__c FROM AccountContactRelation 
                          		where accountId =: ProviderAffId 
                          		AND (Relationship__c = 'Provider User' OR Relationship__c = 'Provider Team')];
        System.debug('>>>lstAcctCntRels' + lstAcctCntRels);
         lstAcctRels = SetRelatedAccounts(lstAcctCntRels);
        for(Account acctPrv: lstAcctRels){
            AccountTeamMember acctTmMem = new AccountTeamMember(
            AccountId = acctPrv.Id, 
            UserId = TeamsUserId, 
            TeamMemberRole = TeamMemberRole,
            AccountAccessLevel = AccountAccessLevel, 
            OpportunityAccessLevel = OpportunityAccessLevel, 
            CaseAccessLevel = CaseAccessLevel, 
            ContactAccessLevel = ContactAccessLevel
        	);
            lstAcctTeams.add(acctTmMem);
        }
            if(lstAcctTeams.size() > 0){
                Insert lstAcctTeams;
            } 
        } 
    }
    // Added by Blinker for US3175939
    public static void validationTeamRole(List<AccountTeamMember> accTeamMembers){
        Set<Id> userSet = new Set<Id>();
        for(AccountTeamMember atm: accTeamMembers){
            System.debug('Add User to Set: ' + atm.UserId);
            userSet.add(atm.UserId);
        }
        List<User> userList = [SELECT Id,Profile.Name FROM User where Id IN: userSet AND Profile.Name !=: Family_UserProfile];
        if(userList.size()>0){
            for(AccountTeamMember atm: accTeamMembers){
                for(Account acc:[SELECT Id,RecordType.Name FROM Account WHERE Id=:atm.AccountId]){
                    if(atm.UserId == userList[0].Id && acc.RecordType.Name =='Provider Affiliation'){
                        atm.UserId.addError(System.Label.Account_Team_Validation);
                    } 
                }
            } 
        }
    }
    //End
}