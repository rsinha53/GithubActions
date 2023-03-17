/********************************************************************************* 
Class Name     : SNI_FL_MemberAffiliation.cls
Description    : SNI_FL_MemberAffiliation controller to handle backend data
Created By     : Adupa Bindu
Created Date   : 11/18/2020

Modification Log:

*********************************************************************************/
public class SNI_FL_MemberAffiliation {
    @AuraEnabled
    public static Map<String, Id> getData_NewMemberAffiliation() {
        Map<String, Id> returnMap = new Map<String, Id>();
        Map<String, Id> programs = new Map<String, Id>();
        for(Program__c program : [select Id, Program__c from Program__c]) {
            returnMap.put(program.Program__c, program.Id);
        }
        return returnMap;
    }
    @AuraEnabled
    public static String createAccount(string programValue,string populationSelected,string providergroup,string strIdProgram,date DateOfBirth,string strCurrentId,string providerAffiliation){
        Id ProviderRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Provider Group').getRecordTypeId();
        List<Account> acc=[select id,Member_ID__c from Account where id=:strCurrentId ];
        List<Member_Affiliation__c> lstMemberAffs = new  List<Member_Affiliation__c>();
        List<Member_Affiliation__c> MemAff = new  List<Member_Affiliation__c>();
        MemAff = [SELECT ID, Name From Member_Affiliation__c Where  Program__c =:strIdProgram AND Population__c =: populationSelected AND Provider_Group__c =: providergroup AND Member__c=: strCurrentId AND Provider_Affiliation__c =: providerAffiliation];
        if(!MemAff.isEmpty()){
            String memid =MemAff[0].id; 
            return 'A record already exists for this Member/'+memid; 
        }
        // Added for US3178726 Member Affiliation: Display Member ID field                                   
        Id  conId = [Select id,AccountId  from contact where AccountId=:strCurrentId].Id;
        List<String> accountIdList = new List<String>();                                  
        for(Account a : [SELECT Id,Member_Id__c,(SELECT Id,AccountId,ContactId FROM AccountContactRelations WHERE ContactId=:conId) FROM Account WHERE Id IN(SELECT AccountId FROM AccountContactRelation WHERE ContactId=:conId) AND Member_Id__c != Null]){
            if(a.AccountContactRelations.size()>0){
                accountIdList.add(a.Member_Id__c);
            }                                   
        }
        System.debug('accountIdList'+accountIdList);
        // End 
        Member_Affiliation__c Maffiliate = new Member_Affiliation__c(
            Population__c = populationSelected,
            Program__c = strIdProgram,
            Provider_Affiliation__c = providerAffiliation,
            Enrollment_Date__c=system.today(),
            Date_Of_Birth__c=DateOfBirth,
            Member__c=strCurrentId,
            Provider_Group__c = providergroup,
            Status__c=true            
        );
        // Added for US3178726 Member Affiliation: Display Member ID field                                  
        if(accountIdList.size()>1){
            Maffiliate.Member_ID__c = '';
        }else{
            Maffiliate.Member_ID__c = accountIdList[0]; 
        }
        // End                                  
        insert Maffiliate;
        
        return JSON.serialize(Maffiliate);
    }
    @AuraEnabled
    public static List<account> getchildaccountFromId(Id accountId){
        List<account> accountList = new List<account>();
        accountList = [select id,Name  from account where ParentId =:accountId and RecordType.Name = 'Provider Group' And IsActive__c = true];
        return accountList;    
    }
    @AuraEnabled
    public static wrapperFetchLookUp fetchLookUpValues(string programValue,string populationSelected,string providergroup) {
        try{
            wrapperFetchLookUp objWrap = new  wrapperFetchLookUp();
            List<Account> lstAccounts;
            List<Account> lstProviderAff;
            list<Account> lstProviderAccounts;
            if(string.isNotBlank(providergroup) && string.isNotBlank(populationSelected) && string.isNotBlank(programValue)){
                lstAccounts = [SELECT Id,ParentId,Name,Program_Name__c,Population__c  FROM account WHERE Id =:providergroup AND RecordType.Name = 'Provider Group'  AND Programs_Offered__c INCLUDES(:programValue)  AND Population_Offered__c INCLUDES(:populationSelected) ];
                lstProviderAff = [SELECT Id,ParentId,Name,Program_Name__c,Population__c  FROM account WHERE ParentId =: providergroup AND RecordType.Name = 'Provider Affiliation' AND Program_Name__c Like : '%'+programValue+'%'  AND Population__c =:populationSelected ];// AND Programs_Offered__c INCLUDES(:programValue)  AND Population__c =:populationSelected 
                lstProviderAccounts = [SELECT Id,Name,FirstName,LastName,PersonEmail,Provider_Group__c,Provider_Group_Team__c  FROM account WHERE Provider_Group__c =: providergroup or Provider_Group_Team__c =: providergroup];// AND Programs_Offered__c INCLUDES(:programValue)  AND Population__c =:populationSelected 
                system.debug('lstProviderAff'+lstProviderAff);
            }
            if(lstProviderAff.size()>0){
                objWrap.isTrue = lstAccounts?.size()>0?true:false;
                objWrap.ProviderAff = !lstProviderAff.isempty()?lstProviderAff[0]?.Id:null;
                return objWrap;
            }else{
                objWrap.isTrue = false;
                return objwrap;
            }
        }catch (DmlException e){
            system.debug('Something went wrong: '+ e.getMessage());
        }
        return null;
    }
    @AuraEnabled
    public static List<Account> fetchLookUp(Id programSelected , String populationSelected,Id ParentId) {
        List<Account> returnMap = new List<Account>();
        List<Account> acc = new List<Account>();
        for(Account account : [SELECT Id,ParentId,Name,Program_Name__c,Population__c  FROM account WHERE ParentId =: ParentId AND RecordType.Name = 'Provider Affiliation' AND Population__c =:populationSelected AND Program__c =:programSelected])
        {
            returnMap.add(account);
        }
        system.debug('>>returnMap'+returnMap);
        return returnMap;
    }
    @AuraEnabled
    public static String deletememberaffiliation(Id recId){
        List<Member_Affiliation__c> mac = [SELECT Id, Name FROM Member_Affiliation__c WHERE Id=:recId];
        if(mac.size()>0){
            Delete mac;
        }
        return 'Success.';
    }
    /*
* Author: Srilakshmi
*  US315532: Provider Group: Create New Permisson Set (Enroll Member/Member Affiliation Creation)
* date: 12/23/2020
*/
    // Permission Set for Enroll Member//
    @AuraEnabled
    public static boolean isFecPro(){ 
        //boolean enroll = false;
        Permissionset memPermission = [SELECT id, Name From Permissionset Where Name = 'Manage_Enroll_Member' Limit 1];
        if(memPermission.id != null){
            List<PermissionSetAssignment> memSetAssignments =  [Select id, Assigneeid, PermissionSetId From PermissionSetAssignment Where PermissionSetId =:memPermission.Id];
            if(memSetAssignments.size()>0){            
                for(PermissionSetAssignment memSetAssignment : memSetAssignments){
                    system.debug(' UserInfo.getUserId'+ UserInfo.getUserId());
                    system.debug(' memSetAssignment.Assigneeid'+ memSetAssignment.Assigneeid);
                    if(memSetAssignment.Assigneeid == UserInfo.getUserId()){
                        //enroll = true;
                        return true;
                    }
                }
            }    
        } 
        //return enroll;
        return false;
    }  
    public class wrapperFetchLookUp{
        @AuraEnabled public Boolean isTrue;
        @AuraEnabled Public string ProviderAff;
    }
}