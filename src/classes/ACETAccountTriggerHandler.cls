public without sharing class ACETAccountTriggerHandler {
    // These variables store Trigger.oldMap and Trigger.newMap
    Map<Id, Account> oldAccs;
    Map<Id, Account> newAccs;
    
    // This is the constructor
    // A map of the old and new records is expected as inputs
    public ACETAccountTriggerHandler(
        Map<Id, Account> oldTriggerAccounts,
        Map<Id, Account> newTriggerAccounts) {
            oldAccs = oldTriggerAccounts;
            newAccs = newTriggerAccounts;
        }
    
    public void updateEligibilyApiField(list<Account> lstAcc){
        //Family account record type check to do the below things
        Id famRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Family').getRecordTypeId();
        Id individualRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Individual').getRecordTypeId();
        if(oldAccs != null){
            for(Account acc: lstAcc){
                if(acc.recordtypeid==famRecordTypeId){
                    /* Commented this logic as this is not part of MVP for BBY - Vamshee Vunyala
if(!test.isRunningTest() && !acc.Bypass_LOB_Validation__c 
&& (((acc.Service_Group__c != oldAccs.get(acc.id).Service_Group__c)
&& String.isBlank(acc.Service_Group__c)) || 
((acc.Line_of_Business__c != oldAccs.get(acc.id).Line_of_Business__c)
&& String.isBlank(acc.Line_of_Business__c)) ||
((acc.Product_Type__c != oldAccs.get(acc.id).Product_Type__c)
&& String.isBlank(acc.Product_Type__c))))
acc.addError('Line of Business/Product Type/Service Group cannot be blank');
acc.Bypass_LOB_Validation__c=false;//to reset the bypass field */
                    /* (newAccs.get(acc.id).Policy_ID__c != oldAccs.get(acc.id).Policy_ID__c) ||
(newAccs.get(acc.id).Member_ID__c != oldAccs.get(acc.id).Member_ID__c) ||*/
                    if((newAccs.get(acc.id).OwnerId != oldAccs.get(acc.id).OwnerId) || 
                       (acc.Line_of_Business__c != oldAccs.get(acc.id).Line_of_Business__c)||
                       acc.Product_Type__c != oldAccs.get(acc.id).Product_Type__c) {
                           acc.EHub_Update_Check__c = true;
                       }
                    
                }
                if (acc.recordtypeid==individualRecordTypeId && 
                    ((acc.FirstName != oldAccs.get(acc.id).FirstName)||
                     (acc.LastName != oldAccs.get(acc.id).LastName) || 
                     (acc.PersonBirthdate != oldAccs.get(acc.id).PersonBirthdate))) {
                         System.debug('It came here for person account change');    
                         acc.EHub_Update_Check__c = true; 
                     }
                
            }
        }else{
            for(Account acc: lstAcc){
                if(acc.recordtypeid==famRecordTypeId || acc.recordtypeid==individualRecordTypeId)
                    acc.EHub_Update_Check__c = true;
            }
        }
    }
    public void workorderStatusUpdate() {
        Map<Id,String> accountStatusMap = new Map<Id,String>();
        Map<Id,String> accountUHGRestriction = new Map<Id,String>();
        List<WorkOrder> woList = new List<WorkOrder>();
        Id devRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Family').getRecordTypeId();
        for(AccountContactRelation accConRel:[select accountId,account.Special_Needs_Status__c,account.UHG_Restriction__c,account.recordtypeid,contact.accountId from AccountContactRelation where accountId IN :newAccs.keySet() ]){
            if(accConRel.account.recordtypeid == devRecordTypeId && (accConRel.account.Special_Needs_Status__c != oldAccs.get(accConRel.AccountId).Special_Needs_Status__c || accConRel.account.UHG_Restriction__c != oldAccs.get(accConRel.AccountId).UHG_Restriction__c)){
                accountStatusMap.put(accConRel.contact.accountId,accConRel.account.Special_Needs_Status__c);
                accountUHGRestriction.put(accConRel.contact.accountId,accConRel.account.UHG_Restriction__c);
            }
            
        }
        if(accountStatusMap.keySet() != Null){
            for(WorkOrder wo:[select Special_Needs_Status__c,UHG_Restriction__c,Id,AccountId from WorkOrder where AccountId IN :accountStatusMap.keySet()]){
                wo.Special_Needs_Status__c = accountStatusMap.get(wo.AccountId);
                wo.UHG_Restriction__c = accountUHGRestriction.get(wo.AccountId);
                woList.add(wo);
            }
        }
        if(woList.size()>0){
            update woList;
        }
    }
    
    Public Static void changeOwnerValidation(map<id,Account> newAccMap, Map<Id, Account> oldAccMap){
        Boolean SNIProfileCheck=AcetUtility.fetchUser();
        if(SNIProfileCheck) {
            List<Id> accIds = new List<Id>();
            Id unassignedUser = [select id from User where Name Like '%Unassigned%'].Id;
            list<Family_Overview__c> lstFamOvrVw = new list<Family_Overview__c>();
            Map<id,id> accOwnerMap=new Map<id,id>();
            Map<id,id> oldAccOwnerMap=new Map<id,id>();
            //List<String> newAdvisor = new List<String>();
            lstFamOvrVw = [select id,Designation__c,Family_Needs__c,First_Family_Contact_Into_Center__c,Account__r.ownerId from Family_Overview__c where account__c in : oldAccMap.keyset() order by lastmodifieddate desc limit 1];
            //Code added -US2556794
            Id userId = userinfo.getUserId();
            boolean restrictedUser=false;
            User userDetails =[SELECT UserRole.Name FROM User where Id=:userId ];
            if(userDetails != null && userDetails.UserRole.Name != null){
                string loginRole = userDetails.UserRole.Name.trim();
                if(RecursiveTriggerHandler.restrictOwnerChange && String.isNotBlank(loginRole) && !(loginRole.contains('Supervisor') || loginRole.contains('System Administrator')))
                    restrictedUser= true;
                system.debug('current user role  is--------'+loginRole +' With restrction:'+restrictedUser);
            }
            //Code End -US2556794
            Id famRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Family').getRecordTypeId();
            for (Account acc : newAccMap.values())
            {
                if(acc.RecordTypeId==famRecordTypeId && oldAccMap.get(acc.Id) !=null && oldAccMap.get(acc.Id).OwnerId != acc.OwnerId && oldAccMap.get(acc.Id).OwnerId == unassignedUser &&
                   (lstFamOvrVw.size() > 0 && (lstFamOvrVw[0].Designation__c == 'Attempted' ||  lstFamOvrVw[0].Designation__c == 'Worked' || lstFamOvrVw[0].Designation__c =='Removed' || lstFamOvrVw[0].Designation__c == 'Deferred' || lstFamOvrVw[0].Designation__c == 'Dormant'))) {
                       System.debug('Existing Validation');
                       acc.addError('Cannot change the Account Owner.',false);
                   }
                //Code added -US2556794
                else if(acc.RecordTypeId==famRecordTypeId && restrictedUser && oldAccMap.get(acc.Id) !=null && oldAccMap.get(acc.Id).OwnerId != acc.OwnerId
                        && (oldAccMap.get(acc.Id).OwnerId != unassignedUser || acc.OwnerId!=userId)){
                            System.debug('New Validation');
                            acc.addError('Cannot change the Account Owner.',false);
                        }
                //Code end -US2556794
                /*else if(oldAccMap.get(acc.Id) !=null && oldAccMap.get(acc.Id).OwnerId != acc.OwnerId){
newAdvisor.add(acc.OwnerId);
} Code commented By Chandan -As issue is coming*/
                /*
* Author: Chandan
* Us: US2287501
* Description :Reassign Families to a new Family Advisor
* date: 01/22/2020
* */
                else{
                    if(acc.recordTypeId ==famRecordTypeId && acc.OwnerId!=oldAccMap.get(acc.id).OwnerId){
                        accOwnerMap.put(acc.Id, acc.ownerid);
                        oldAccOwnerMap.put(acc.Id, oldAccMap.get(acc.id).OwnerId);
                    }
                }
            }
            /*
* Us: US2341841
* Description :Reassign Families to a new Family Advisor
* date: 01/22/2020
* */
            //try{
            if(accOwnerMap!=null && accOwnerMap.size()>0){
                List<User> newAdvisorUserRec = [SELECT ID,UHG_Access__c,Agent_Type__c FROM USER where ID in : accOwnerMap.values()];
                for (Account acc : newAccMap.values())
                {
                    if(newAdvisorUserRec.size()>0 && newAdvisorUserRec[0].UHG_Access__c == 'No' && acc.UHG_Restriction__c == 'Yes' && !test.isRunningTest()){
                        acc.addError('This is a UHG restricted group. You are not able to change owner to this user.',false);
                    }
                    /* else if(newAdvisorUserRec.size()>0 && newAdvisorUserRec[0].Agent_Type__c == 'Offshore' && !test.isRunningTest() ){
acc.addError('This is a globally restricted group. You are not able to change owner to this user.',false);
}*/
                }
                
                System.debug('It came here accOwnerMap:'+accOwnerMap);
                
                Map<Id,Id> personAccoFamMap=new Map<Id,Id>();
                for(AccountContactRelation acr:[Select accountid,contact.accountid from AccountContactRelation where accountid in:accOwnerMap.keySet()]){
                    personAccoFamMap.put(acr.contact.accountid,acr.accountid);
                }
                System.debug('personAccoFamMap='+personAccoFamMap);
                Map<String,String>caseteamr = new Map<String,String>{};
                    for(CaseTeamRole ct:[Select name,id from caseTeamRole]){
                        caseteamr.put(ct.Name, ct.Id);
                    }
                //System.debug('caseteamr='+caseteamr);
                List<Case> caseList=new List<Case>();
                List<CaseTeamMember> caseTmList=new List<CaseTeamMember>();
                List<CaseTeamMember> delCaseTeam =new List<CaseTeamMember>();
                List<task> activityLst = new List<task>();
                List<String> recordTypeList=new List<String>{'ECM','Case Overview','Support Request'};
                    Map<Id,Case> CaseMap=new Map<Id,Case>([Select id,ownerId,Case_Type__c,Onshore_Restriction__c,accountid,contactId,recordtype.name,(SELECT MemberID,id FROM TeamMembers where TeamRoleId =: caseteamr.get('Advisor'))
                                                           from Case where accountid in: personAccoFamMap.keySet()
                                                           and recordtype.name in: recordTypeList and status!='Closed']);
                Map<Id,Id> casewithNewOwnerId = new Map<Id,Id>();
                for(Case c:CaseMap.values()){
                    Id newOwnerId=accOwnerMap.get(personAccoFamMap.get(c.accountid));
                    casewithNewOwnerId.put(c.Id, newOwnerId);
                    Id oldOwnerId=oldAccOwnerMap.get(personAccoFamMap.get(c.accountid));
                    
                    System.debug('AccountId='+personAccoFamMap.get(c.accountid)+'and oldOwnerId='+newOwnerId);
                    if((c.recordtype.name=='ECM' && c.Case_Type__c =='Opportunity') ||c.recordtype.name=='Case Overview' ||(c.recordtype.name=='Support Request' && c.OwnerId==oldOwnerId)){
                        Case cs=new case(id=c.id,ownerId=newOwnerId);
                        if(c.recordtype.name=='Support Request')
                            cs.Account_Owner_Change_Indicator__c = true ;
                        caseList.add(cs);
                        CaseTeamMember ctmAdvisor = new CaseTeamMember(
                            ParentId = c.id,
                            MemberId = newOwnerId,
                            TeamRoleId = caseteamr.get('Advisor')
                        );
                        caseTmList.add(ctmAdvisor);
                        if(c.TeamMembers!=null && c.TeamMembers.size()>0)
                            delCaseTeam.add(c.TeamMembers);
                    }
                }
                //To update the case tasks to case owner when account owner change
                for(task activty : [SELECT Id,OwnerId,whatId FROM Task where whatId IN:casewithNewOwnerId.keySet() AND Status != 'Completed']){
                    activty.OwnerId = casewithNewOwnerId.get(activty.whatId);
                    activityLst.add(activty);
                }
                
                
                
                if(caseList!=null && caseList.size()>0) {
                    Database.SaveResult[] srList = Database.update(caseList, false);
                    
                    // Iterate through each returned result
                    for(Integer i=0;i<srList.size();i++){
                        if(!srList.get(i).isSuccess()){
                            system.debug('Failed Case ID'+caseList.get(i).Id);
                            Database.Error error = srList.get(i).getErrors().get(0);
                            System.debug('error.getMessage()'+error.getMessage());
                            if(error.getMessage().contains('This is a globally restricted group. You are not able to change owner to this user')){
                                Id accountId=CaseMap.get(caseList.get(i).id).accountId;
                                if(accountId!=null){
                                    Account acc=newAccMap.get(personAccoFamMap.get(accountId));//failed record from the list
                                    if(acc!=null)
                                        acc.addError('This is a globally restricted group. You are not able to change owner to this user.',false);
                                }
                            }
                        }
                    }
                    
                }
                
                if(delCaseTeam!=null && delCaseTeam.size()>0)
                    delete delCaseTeam;
                if(caseTmList!=null && caseTmList.size()>0)
                    insert caseTmList;
                if(activityLst!=null && activityLst.size()>0) 
                    update activityLst;
                //Update the owner of member information tasks while the owner is getting updated
                // US3034530: SNI-Enhancement to Tasks to Update on Member Information         
                Map<Id,Id> m_membrInfoId = new Map<Id,Id>();        
                for(Member_Information__c memInfo  : [Select Id,account__c from Member_Information__c where account__c in :personAccoFamMap.keyset()])
                {
                    Id newOwnerId=accOwnerMap.get(personAccoFamMap.get(memInfo.account__c));
                    Id oldOwnerId=oldAccOwnerMap.get(personAccoFamMap.get(memInfo.account__c));
                    m_membrInfoId.put(memInfo.Id, newOwnerId);
                }
                for(task activty : [SELECT Id,OwnerId,whatId FROM Task where whatId IN:m_membrInfoId.keySet() AND Status != 'Completed']){
                    activty.OwnerId = m_membrInfoId.get(activty.WhatId);
                    activityLst.add(activty);
                    
                }
                if(activityLst!=null && activityLst.size()>0) 
                    update activityLst;
            }
            //US3034530: SNI-Enhancement to Tasks to Update on Member Information   
            //}
            /*catch(Exception e){
System.debug('Exception Occured='+e.getMessage());
}//Code End By Chandan-US2287501*/
        }
    }
    /*
* Author: Priyanka
* Us: DE332852
* Description :Member Search/Name Change
* date: 06/03/2020
*
*/
    Public void nameChangeValidation(List<Account> lstAcc, Map<Id, Account> oldAccMap){
        Set<String> authorizedProfiles = new Set<String>{ 'Insurance Tracking Engine',
            'ITE Communities User Profile',
            'Center for Health Navigation'
            };
                Id profileId = userInfo.getProfileId();
        String profileName = [SELECT Name FROM Profile WHERE Id = :profileId ].Name;
        Id famRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Family').getRecordTypeId();
        Id individualRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Individual').getRecordTypeId();
        for (Account acc : lstAcc)
        {
            
            //This validation throws when the user tries to update the Account name from UI
            if(RecursiveTriggerHandler.nameChangeEnabled == false && (acc.RecordTypeId == famRecordTypeId || acc.RecordTypeId == individualRecordTypeId)){
                if(oldAccMap.get(acc.Id) !=null && (oldAccMap.get(acc.Id).FirstName != acc.FirstName || oldAccMap.get(acc.Id).lastName != acc.lastName || oldAccMap.get(acc.Id).Name != acc.Name)
                   && authorizedProfiles.contains(profileName)){
                       acc.addError('You do not have permission to edit the Account Name',false);
                   }
            }
        }
    }
    /*
* Author: Srilakshmi
* Us: US3063915
* Description: Provider Group: Validation Rule (Duplicate Record Error Message) Part 2
* date: 12/07/2020
*
*/
    
    Public void DuplicateNameCheckname(List<Account> lstAcc){
        Id proAffRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Provider Affiliation').getRecordTypeId();
        Id proGrpRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Provider Group').getRecordTypeId();
        Id proUsrRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Provider User').getRecordTypeId();
        Id proTmsRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Provider Team').getRecordTypeId();
        Id accRecordTypeId;
        List<Account> lstAccts = new List<Account>();
        for (Account acc : lstAcc)
        {
            if(acc.RecordTypeId == proAffRecordTypeId 
               || acc.RecordTypeId == proGrpRecordTypeId 
               ||  acc.RecordTypeId == proUsrRecordTypeId 
               ||  acc.RecordTypeId == proTmsRecordTypeId)
            {
                lstAccts.add(acc);
                System.debug('>>>' + acc);
                accRecordTypeId = acc.RecordTypeId;
            }       
        }    
        
        if(lstAccts.size() > 0 )
        {
            List<Account> lstAccount = [SELECT Id, Name, Salutation, FirstName, LastName From Account where RecordTypeId =: accRecordTypeId];           
            Map<String ,Account> mapNameWiseAccount = new Map<String,Account>();
            string accName;
            For(Account acc: lstAccount)
            {
                mapNameWiseAccount.put(acc.Name.toUpperCase() ,acc);                
                System.debug('>>>' + acc.Name);                
            }
            System.debug('>>>mapNameWiseAccount' + mapNameWiseAccount); 
            For(Account acc : lstAcc)
            { 
                if(!String.isBlank(acc.FirstName)){
                    accName = acc.FirstName + ' ' + acc.LastName;
                }
                else {
                    accName = acc.LastName;                  
                }
                if(!String.isBlank(accName) && mapNameWiseAccount.containsKey(accName.toUpperCase())){
                    acc.Name.addError('Account Name already Exist'); 
                }
                if(!String.isBlank(acc.Name) && mapNameWiseAccount.containsKey(acc.Name.toUpperCase()))
                {                   
                    acc.Name.addError('Account Name already Exist');
                }
            }
        }
    }
    /*
* Author: Aarti Garg
* US: US2692279
* Description: Following function update same email address on Person account page which email used by advocate to create new user
* Date: 07/30/2020
*/
    public static void getEmail(List<Account> Triggernew, Map<id,Account> triggeroldMap)
    {
        
        boolean recCheck = RecursiveTriggerHandler.userEmailCheck;
        RecursiveTriggerHandler.userEmailCheck= false;
        Map<id, String> AccountidEmailMap = new Map<id,String>();
        
        
        for(Account acc : Triggernew)
        {
            if(acc.PersonEmail !=NULL && acc.PersonEmail != triggeroldMap.get(acc.Id).personEmail && !recCheck)
            {
                AccountidEmailMap.put(acc.Id, acc.PersonEmail);
            }
        }
        if(AccountidEmailMap.size()>0){
            setEmail(AccountidEmailMap);
        }
        
    }
    @future
    public static void setEmail( Map<id, String> AccountidEmailMap)
    {
        
        list<User> lstUser= new List<User>();
        String emailstr='';
        List<User>  userlist= [select Email, Profile_Name__c, AccountID from User where AccountID IN : AccountidEmailMap.keySet()];
        for(User us: userlist)
        {
            emailstr=AccountidEmailMap.get(us.AccountID) ;
            //Code added -US3150317
            if(emailstr != us.Email &&  (us.Profile_Name__c=='Care Advisor Connect Community User' || us.Profile_Name__c=='Care Advisor Connect Provider User'))
            {
                us.Email= emailstr;
                lstUser.add(us);
            }
            //Code end -US3150317
        }
        if(lstUser.size()>0)
        {
            RecursiveTriggerHandler.emailcheck= true;   
            update lstUser; 
            
        }       
    }
    
    /*  US2732016: Care Team - Display Care Team on Family Page -Populated*/
    /**This Code is build for single policy modifications required for multiple policy scenario**/
    /** Commented as Code got merged to createCareTeamList method for multi policy

public static void createCareTeamMembers(List<Account> lstAcc, Map<Id, Account> oldAccMap){
List<Id> famId = new List<Id>();
List<Id> currentPersonAccount = new List<Id>();
List<SNI_FL_Care_Team_Member__c> careTeamLst = new List<SNI_FL_Care_Team_Member__c>();
List<SNI_FL_Care_Team_Member__c> careTeamUpdate = new List<SNI_FL_Care_Team_Member__c>();
Map<id,SNI_FL_Care_Team_Member__c> careTeamPersonAccFamilyAccMap = new Map<Id,SNI_FL_Care_Team_Member__c>();
Boolean CheckPrimaryCaregiver = false;
List<Id> memberIds = new List<Id>();
Id individualRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Individual').getRecordTypeId();
//Check the personAccounts related to familylink and registration date is filled
//List all the family Ids related to the account
for(Account acc : lstAcc){
if(acc.RecordTypeId == individualRecordTypeId && oldAccMap.get(acc.Id) !=null && oldAccMap.get(acc.Id).FamilyLink_Registration_Date__c == null  && (oldAccMap.get(acc.Id).FamilyLink_Registration_Date__c != acc.FamilyLink_Registration_Date__c)){
for(SNI_FL_Care_Team_Member__c cteam : [SELECT ID,SNI_FL_Family__c,SNI_FL_Member__c,SNI_FL_Status__c,SNI_FL_Registered_Date__c FROM SNI_FL_Care_Team_Member__c WHERE SNI_FL_Member__c =:acc.Id]){
famId.add(cteam.SNI_FL_Family__c);
currentPersonAccount.add(acc.Id); 
}
}
}
//Based on the FamilyId fetch the care team records
if(famId.size()>0){
for(SNI_FL_Care_Team_Member__c careTeam : [SELECT ID,SNI_FL_Family__c,SNI_FL_Member__c,SNI_FL_Status__c,SNI_FL_Registered_Date__c,SNI_FL_Primary_Caregiver__c FROM SNI_FL_Care_Team_Member__c WHERE SNI_FL_Family__c in :famId]){
careTeamPersonAccFamilyAccMap.put(careTeam.SNI_FL_Member__c,careTeam);
}
//Iterate over the Acr and compare the existing Care team records.. update existing else insert the new as added
for(AccountContactRelation acr : [SELECT ID,Contact.accountId,AccountId FROM AccountContactRelation WHERE AccountId in :famId]){
//if the record exists in Care team records 
if(careTeamPersonAccFamilyAccMap.containsKey(acr.Contact.accountId)){
//Capture the Primary caregiver for family is already in system
if(careTeamPersonAccFamilyAccMap.get(acr.Contact.accountId).SNI_FL_Primary_Caregiver__c){
CheckPrimaryCaregiver = true;
}
//Update the record to registered for the current member performing registration action
if(currentPersonAccount.contains(acr.Contact.accountId) && careTeamPersonAccFamilyAccMap.get(acr.contact.AccountId).SNI_FL_Family__c == acr.AccountId){
memberIds.add(acr.Contact.accountId);
SNI_FL_Care_Team_Member__c careTeam =  careTeamPersonAccFamilyAccMap.get(acr.Contact.accountId);
careTeam.SNI_FL_Status__c = 'Registered';
careTeam.SNI_FL_Registered_Date__c = System.Today();
careTeamLst.add(careTeam);
}
}
//create records for rest of the members in care team as added
else{
SNI_FL_Care_Team_Member__c careTeam=  new  SNI_FL_Care_Team_Member__c();
careTeam.SNI_FL_Family__c =acr.AccountId;
careTeam.SNI_FL_Member__c = acr.Contact.AccountId;
careTeam.SNI_FL_Status__c = 'Added';
careTeam.SNI_FL_Added_Date__c = System.today();
careTeamLst.add(careTeam);
}
}
}
if(careTeamLst.size()>0){
upsert careTeamLst;
}
//once the updation is done if the primary caregiver doesnot exist fro family iterate over current personrecords and update the corresponding care team reocrd as primary account owner
if(!CheckPrimaryCaregiver){
for(SNI_FL_Care_Team_Member__c careTeam :  [SELECT ID,SNI_FL_Family__c,SNI_FL_Member__c,SNI_FL_Status__c,SNI_FL_Registered_Date__c,SNI_FL_Primary_Caregiver__c FROM SNI_FL_Care_Team_Member__c WHERE SNI_FL_Member__c in :memberIds]){
if(careTeam.SNI_FL_Status__c == 'Registered'){
careTeam.SNI_FL_Primary_Caregiver__c = true;
careTeamUpdate.add(careTeam);
}
}
if(careTeamUpdate.size()>0){
update careTeamUpdate;
}   
}

} **/
    
    //MultiPle Policy
    //US2736623: Care Team - Multi Policy Pop Up - Family Advisor select FLAO Families
    public static void createCareTeamList(Map<Id, Account> newAccMap, Map<Id, Account> oldAccMap){
        system.debug('createCareTeamList----');
        List<Id> paccId = new List<Id>();
        Id individualRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Individual').getRecordTypeId();
        system.debug('individualRecordTypeId--'+individualRecordTypeId);
        for(Account acc : newAccMap.values()){
            system.debug('acc--'+acc);
            system.debug('oldAccMap.get(acc.Id).FamilyLink_Registration_Date__c  '+oldAccMap.get(acc.Id).FamilyLink_Registration_Date__c);
            if(acc.RecordTypeId == individualRecordTypeId && oldAccMap.get(acc.Id).FamilyLink_Registration_Date__c == null  && (oldAccMap.get(acc.Id).FamilyLink_Registration_Date__c != acc.FamilyLink_Registration_Date__c)){
                system.debug('inside id');
                paccId.add(acc.id);
            }
        }
        Map<Id,Set<Id>> existingMemberMap =new Map<Id,Set<Id>>();
        Map<Id,boolean> primaryCareGiverMap =new Map<Id,boolean>();
        set<Id> famId=new set<Id>();
        List<SNI_FL_Care_Team_Member__c> notVisibleCTM=new List<SNI_FL_Care_Team_Member__c>();
        List<SNI_FL_Care_Team_Member__c> ctmList= new List<SNI_FL_Care_Team_Member__c>();
        for(SNI_FL_Care_Team_Member__c ctm: [SELECT ID,SNI_FL_Family__c,SNI_FL_Not_Visible_in_Familylink__c FROM SNI_FL_Care_Team_Member__c
                                             WHERE SNI_FL_Member__c in :paccId ]){//and SNI_FL_Not_Visible_in_Familylink__c=false
                                                 system.debug('ctm '+ctm);
                                                 if(!ctm.SNI_FL_Not_Visible_in_Familylink__c)//As we dont want to create careteam if the member itslef is not visible
                                                     famId.add(ctm.SNI_FL_Family__c);
                                                 else
                                                     notVisibleCTM.add(ctm);//As we need register this member too
                                                 
                                             }
        system.debug('famId---'+famId);
        if(famId!=null && famId.size()>0){
            ctmList=[SELECT ID,SNI_FL_Family__c,SNI_FL_Member__c,SNI_FL_Status__c,SNI_FL_Registered_Date__c,
                     SNI_FL_Primary_Caregiver__c,SNI_FL_Not_Visible_in_Familylink__c
                     FROM SNI_FL_Care_Team_Member__c WHERE SNI_FL_Family__c in :famId];
            system.debug('ctmList----'+ ctmList);
            if(ctmList!=null && ctmList.size()>0){
                for(SNI_FL_Care_Team_Member__c ctm: ctmList){ 
                    if((!primaryCareGiverMap.keySet().contains(ctm.SNI_FL_Family__c))||(!primaryCareGiverMap.get(ctm.SNI_FL_Family__c)))
                        primaryCareGiverMap.put(ctm.SNI_FL_Family__c,ctm.SNI_FL_Primary_Caregiver__c);
                } 
                for(SNI_FL_Care_Team_Member__c ctm: ctmList){
                    ctm.SNI_FL_Not_Visible_in_Familylink__c=false;//We are forcefully making visible here so that that member can be visible for that family
                    RecursiveTriggerHandler.careTeam_FirstTime=false;//So that careteam trigger does not fire
                    if(newAccMap.keyset().contains(ctm.SNI_FL_Member__c)){
                        boolean isPrimaryExist= primaryCareGiverMap.get(ctm.SNI_FL_Family__c);
                        System.debug('isPrimaryExist='+isPrimaryExist);
                        ctm.SNI_FL_Status__c = 'Registered';
                        ctm.SNI_FL_Registered_Date__c = Date.parse(DateTime.now().format('MM/dd/yyyy HH:mm:ss', 
                                                                                         'CST').substring(0,10));
                        ctm.SNI_FL_Primary_Caregiver__c=isPrimaryExist!=null && isPrimaryExist?false:true;
                    }
                    if(!existingMemberMap.keySet().contains(ctm.SNI_FL_Family__c)){
                        existingMemberMap.put(ctm.SNI_FL_Family__c, new set<ID>{ctm.SNI_FL_Member__c});                                   
                    }
                    else{
                        set<ID> memIdSet=existingMemberMap.get(ctm.SNI_FL_Family__c);
                        memIdSet.add(ctm.SNI_FL_Member__c);
                        existingMemberMap.put(ctm.SNI_FL_Family__c, memIdSet);                                   
                    } 
                }
            }
            
            List<AccountContactRelation> acrList = [SELECT ID,AccountId,contact.accountId from AccountContactRelation where AccountId in :famId];
            if(acrList!=null && acrList.size()>0){
                for(AccountContactRelation acr:acrList){
                    set<id> existingMemId=existingMemberMap.get(acr.AccountId); 
                    if(!existingMemId.contains(acr.contact.accountId)){
                        SNI_FL_Care_Team_Member__c ctm=  new  SNI_FL_Care_Team_Member__c();
                        ctm.SNI_FL_Family__c =acr.AccountId;
                        ctm.SNI_FL_Member__c = acr.contact.accountId;
                        ctm.SNI_FL_Status__c = 'Added';
                        ctm.SNI_FL_Not_Visible_in_Familylink__c=false;
                        ctm.SNI_FL_Added_Date__c = Date.parse(DateTime.now().format('MM/dd/yyyy HH:mm:ss', 
                                                                                    'CST').substring(0,10));
                        ctmList.add(ctm);
                    }
                }
            }
            if(notVisibleCTM!=null && notVisibleCTM.size()>0){
                for(SNI_FL_Care_Team_Member__c ctm :notVisibleCTM){
                    ctm.SNI_FL_Status__c = 'Registered';
                    ctm.SNI_FL_Registered_Date__c = Date.parse(DateTime.now().format('MM/dd/yyyy HH:mm:ss', 
                                                                                     'CST').substring(0,10));
                }
                ctmList.addall(notVisibleCTM);
            }
            
            if(ctmList!=null && ctmList.size()>0)
                upsert ctmList;
        }
    }
    
    //Multiple policies
    /**Build in Progress**/
    //Modification to above code for multiple policies
    public static void createCareTeamMembersDuplicate(List<Account> lstAcc, Map<Id, Account> oldAccMap){
        List<Id> famId = new List<Id>();
        List<Id> currentPersonAccount = new List<Id>();
        List<SNI_FL_Care_Team_Member__c> careTeamLst = new List<SNI_FL_Care_Team_Member__c>();
        List<SNI_FL_Care_Team_Member__c> careTeamUpdate = new List<SNI_FL_Care_Team_Member__c>();
        Map<id,id> acrPersonAccFamilyAccMap = new Map<Id,Id>();
        Map<id,List<SNI_FL_Care_Team_Member__c>> careTeamPersonAccFamilyAccMap = new Map<Id,List<SNI_FL_Care_Team_Member__c>>();
        Map<Id,Boolean> CheckPrimaryCaregiver = new Map<Id,Boolean>();
        List<Id> memberIds = new List<Id>();
        //Id unassignedUser = [select id from User where Name ='Unassigned' and isActive= true Limit 1].Id;
        Id individualRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Individual').getRecordTypeId();
        for(Account acc : lstAcc){
            if(acc.RecordTypeId == individualRecordTypeId && oldAccMap.get(acc.Id) !=null && oldAccMap.get(acc.Id).FamilyLink_Registration_Date__c == null  && (oldAccMap.get(acc.Id).FamilyLink_Registration_Date__c != acc.FamilyLink_Registration_Date__c)){
                for(SNI_FL_Care_Team_Member__c cteam : [SELECT ID,SNI_FL_Family__c,SNI_FL_Member__c,SNI_FL_Status__c,SNI_FL_Registered_Date__c FROM SNI_FL_Care_Team_Member__c WHERE SNI_FL_Member__c =:acc.Id]){
                    famId.add(cteam.SNI_FL_Family__c);
                    currentPersonAccount.add(acc.Id); 
                }
            }
        }
        if(famId.size()>0){
            for(SNI_FL_Care_Team_Member__c careTeam : [SELECT ID,SNI_FL_Family__c,SNI_FL_Member__c,SNI_FL_Status__c,SNI_FL_Registered_Date__c,SNI_FL_Primary_Caregiver__c FROM SNI_FL_Care_Team_Member__c WHERE SNI_FL_Family__c in :famId]){
                if(careTeamPersonAccFamilyAccMap.containsKey(careTeam.SNI_FL_Member__c)){
                    careTeamPersonAccFamilyAccMap.get(careTeam.SNI_FL_Member__c).add(careTeam);
                }
                else
                    careTeamPersonAccFamilyAccMap.put(careTeam.SNI_FL_Member__c,new list<SNI_FL_Care_Team_Member__c>{careTeam});
                
            }
            system.debug('famid++'+famid);
            for(AccountContactRelation acr : [SELECT ID,Contact.accountId,AccountId FROM AccountContactRelation WHERE AccountId in :famId]){
                system.debug('acr++'+acr); 
                if(careTeamPersonAccFamilyAccMap.containsKey(acr.Contact.accountId)){
                    system.debug('acr++loop'+acr.Contact.accountId);
                    system.debug('list+'+careTeamPersonAccFamilyAccMap.get(acr.Contact.accountId));
                    for(SNI_FL_Care_Team_Member__c ctm : careTeamPersonAccFamilyAccMap.get(acr.Contact.accountId)){
                        system.debug('ctm++'+ctm);
                        if(ctm.SNI_FL_Primary_Caregiver__c){
                            CheckPrimaryCaregiver.put(ctm.SNI_FL_Family__c ,true);
                        }
                        if(currentPersonAccount.contains(acr.Contact.accountId) && ctm.SNI_FL_Family__c == acr.AccountId){
                            memberIds.add(acr.Contact.accountId);
                            SNI_FL_Care_Team_Member__c careTeam =  ctm;
                            careTeam.SNI_FL_Status__c = 'Registered';
                            careTeam.SNI_FL_Registered_Date__c = Date.parse(DateTime.now().format('MM/dd/yyyy HH:mm:ss', 
                                                                                                  'CST').substring(0,10));
                            careTeamLst.add(careTeam);
                        }else if(!currentPersonAccount.contains(acr.Contact.accountId) && (ctm.SNI_FL_Family__c != acr.AccountId  && ctm.SNI_FL_Member__c == acr.Contact.AccountId)){
                            SNI_FL_Care_Team_Member__c careTeam=  new  SNI_FL_Care_Team_Member__c();
                            careTeam.SNI_FL_Family__c =acr.AccountId;
                            careTeam.SNI_FL_Member__c = acr.Contact.AccountId;
                            careTeam.SNI_FL_Status__c = 'Added';
                            careTeam.SNI_FL_Added_Date__c = Date.parse(DateTime.now().format('MM/dd/yyyy HH:mm:ss', 
                                                                                             'CST').substring(0,10));
                            careTeamLst.add(careTeam);
                        }
                    }
                }
                else{
                    SNI_FL_Care_Team_Member__c careTeam=  new  SNI_FL_Care_Team_Member__c();
                    careTeam.SNI_FL_Family__c =acr.AccountId;
                    careTeam.SNI_FL_Member__c = acr.Contact.AccountId;
                    careTeam.SNI_FL_Status__c = 'Added';
                    careTeam.SNI_FL_Added_Date__c = Date.parse(DateTime.now().format('MM/dd/yyyy HH:mm:ss', 
                                                                                     'CST').substring(0,10));
                    careTeamLst.add(careTeam);
                }
            }
        }
        if(careTeamLst.size()>0){
            upsert careTeamLst;
        }
        System.debug('memberIds+'+memberIds);
        system.debug('CheckPrimaryCaregiver+'+CheckPrimaryCaregiver);
        for(SNI_FL_Care_Team_Member__c careTeam :  [SELECT ID,SNI_FL_Family__c,SNI_FL_Member__c,SNI_FL_Status__c,SNI_FL_Registered_Date__c,SNI_FL_Primary_Caregiver__c FROM SNI_FL_Care_Team_Member__c WHERE SNI_FL_Member__c in :memberIds]){
            system.debug('careTeam++'+careTeam);
            if(CheckPrimaryCaregiver.get(careTeam.SNI_FL_Family__c) == null && careTeam.SNI_FL_Status__c == 'Registered'){
                careTeam.SNI_FL_Primary_Caregiver__c = true;
                careTeamUpdate.add(careTeam);
            }
        }
        if(careTeamUpdate.size()>0){
            update careTeamUpdate;
        }   
    }
    //Srilakshmi
    public static void getEmailIdAndDob(List<Account> Triggernew, Map<id,Account> triggeroldMap)
    {
     
    Map<id,Account>Selected_accounts= new Map<id,Account>();
        Id individualRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Individual').getRecordTypeId();          
        //List<Member_Affiliation__c> LstMemberAff = new List<Member_Affiliation__c>();
        List<Member_Affiliation__c> LstUpdMemberAff = new List<Member_Affiliation__c>();
      
        for(Account acc : Triggernew)
        {
            if(acc.recordtypeId ==individualRecordTypeId)
            {    
                //Account lstacc = [SELECT Id, Name, PersonEmail, PersonBirthdate from Account where ID = :acc.Id Limit 1 ];                  
                //LstMemberAff = [SELECT Id, email__c from Member_Affiliation__c Where Member__r.id =:acc.Id];
                 

             selected_accounts.put(acc.id,acc);
             
           
            }
        }
    for(Member_Affiliation__c memAff:[SELECT Id,Date_Of_Birth__c,email__c,Member__r.id from Member_Affiliation__c Where Member__r.id IN :selected_accounts.keyset()]){
                    memAff.Email__C = selected_accounts.get(memaff.Member__r.id).PersonEmail;
                    memAff.Date_Of_Birth__c = selected_accounts.get(memaff.Member__r.id).PersonBirthDate;
                
                    LstUpdMemberAff.add(memAff);
                } 
        if(LstUpdMemberAff.size()>0){
            update LstUpdMemberAff;
        }
    }
    //End
    
    //Sameera De Silva (ACDC) DE397810
    //This code is covered from SNI_FL_CheckMessageStatusTest.cls
    public static void executeBatch(Map<Id,Account> newMap,Map<Id,Account> oldMap){
        
        Map<ID,ID> changedAccounts = new Map<ID,ID>();
        Id familyRecordTypedID = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Family').getRecordTypeId();
        
        try{
            for(Account act:newMap.values()){
                
                if(act.RecordTypeId==familyRecordTypedID && act.OwnerId != oldMap.get(act.id).OwnerId){
                    changedAccounts.put(act.id,act.OwnerId);
                }
            }
            
            if(changedAccounts.size()>0){
                
                Database.executeBatch(new SNI_FL_MessageStatusChecker(changedAccounts),200);
            }
        }catch(Exception ex){
            System.debug('ACDC-Method:executeBatch'+ex.getMessage()+' '+ex.getLineNumber());
        }
    }

    //meghana
    public void updateComplexIndicator(List<Account> lstAcc, Map<Id, Account> oldAccMap){
        Set<Id> accIds = new Set<Id>();
        for(Account acc:lstAcc){
            Account oldAcc = oldAccMap.get(acc.id)==null?null:oldAccMap.get(acc.id);
            if((oldAcc == null && oldAcc.Complex_Indicator__c !=null) || (oldAcc!=null && acc.Complex_Indicator__c != oldAcc.Complex_Indicator__c)){
                accIds.add(acc.Id);
            }
        }
        Map<Id,AccountContactRelation> acrMap = new Map<Id,AccountContactRelation>();
        List<AccountContactRelation> acrLst = [SELECT Id,
                                               Complex_Indicator_Text__c,
                                               account.Complex_Indicator__c,
                                               Complex_Indicator__c,
                                               Contact.AccountId 
                                               FROM AccountContactRelation 
                                               WHERE Contact.AccountId IN:accIds];
        system.debug('acrLst'+acrLst);
        for(AccountContactRelation acr: acrLst){
            acrMap.put(acr.contact.AccountId,acr);
        }
        List<AccountContactRelation> updateacrlst=new List<AccountContactRelation>();
        String complexIndicatorFinal,  complexIndicatorFromEvisor,complexIndicatorFromEvisorFinal,
               complexIndicatorFromSens,complexIndicatorFromSensFinal;
        List<String> ciEvisorLst,ciSensLst;
        if(acrMap.values().size()>0){
            for(Account acc:lstAcc){
                if(acrMap.containsKey(acc.id) && acc.Complex_Indicator__c != oldAccMap.get(acc.id).Complex_Indicator__c){
                    complexIndicatorFromEvisor = acc.Complex_Indicator__c==null?'':acc.Complex_Indicator__c;
                    ciEvisorLst = complexIndicatorFromEvisor.split(',');
                    complexIndicatorFromEvisorFinal = String.join(ciEvisorLst, '(EVISOR),');
                    complexIndicatorFromEvisorFinal = complexIndicatorFromEvisorFinal == ''?complexIndicatorFromEvisor:complexIndicatorFromEvisorFinal + '(EVISOR)';
                    
                    complexIndicatorFromSens = acrMap.get(acc.id).Complex_Indicator__c==null?'':acrMap.get(acc.id).Complex_Indicator__c;
                    ciSensLst = complexIndicatorFromSens.split(';');
                    complexIndicatorFromSensFinal = String.join(ciSensLst, '(SENS),');
                    complexIndicatorFromSensFinal = complexIndicatorFromSens == ''?complexIndicatorFromSens:complexIndicatorFromSensFinal + '(SENS)';
                    
                    complexIndicatorFinal = complexIndicatorFromSensFinal == ''?complexIndicatorFromEvisorFinal:complexIndicatorFromEvisorFinal + ','+ complexIndicatorFromSensFinal;
                    updateacrlst.add(new AccountContactRelation(id = acrMap.get(acc.id).Id,Complex_Indicator_Text__c = complexIndicatorFinal)); 
                }
             }
        } 
        if(updateacrlst.size()>0){
            update updateacrlst; 
        }
    }
    
}