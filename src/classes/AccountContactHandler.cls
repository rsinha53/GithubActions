public class AccountContactHandler {
    public static void acrAfterInsert(Map<Id, AccountContactRelation> newMap) {
        
        Set<Id> contactIdSet = new Set<Id>();
        Map<Id, Set<Id>> contAccMap = new Map<Id, Set<Id>>();
        
        // Assuming that accounts related to one contact will have the same account owner
        Map<Id, Id> cntAccId = new Map<Id, Id>();
        
      // Get unique Account, Contact Ids 
        for(AccountContactRelation acr: newMap.values()) 
            //accountIdSet.add(acr.AccountId);
            contactIdSet.add(acr.ContactId);
            
            if(!contAccMap.containsKey(acr.ContactId)) { 
                contAccMap.put(acr.ContactId, new Set<Id>());
            }
            contAccMap.get(acr.ContactId).add(acr.AccountId);
        
        }

            String str = '';
            Map<Id, Account> mapAcc = new Map<Id, Account>();
            Account accUpdate;
            
            for(Account pa : [ SELECT Name, Program_Associations__pc, PersonContactId FROM account WHERE PersonContactId IN: contactIdSet ]) {
                
                for(Id accId : contAccMap.get(pa.PersonContactId)) {
                    
                    if(!mapAcc.keySet().contains(accId)) {
                        
                        accUpdate = new Account();
                        accUpdate.Id = accId;
                        accUpdate.EHub_Update_Check__c =  true;
                        
                        if(pa.Program_Associations__pc !=  null) { 
                            str = '<span style="color:black">' + pa.Name + '</span>' + '-' + pa.Program_Associations__pc + '<br/>';// + str + ' ';
                        } else {
                            str = '<span style="color:black">' + pa.Name + '</span>' + '-' + 'None' + '<br/>';// + str + '';
                        }
                        
                        accUpdate.Program_Associations_RichText__c = str + removeNull(accUpdate.Program_Associations_RichText__c);
                        //lsPA.add(accUpdate);
                        
                        mapAcc.put(accId, accUpdate);
                        
                    } else {
                        
                        accUpdate = mapAcc.get(accId);  
                        
                        if(pa.Program_Associations__pc !=  null) { 
                            str = '<span style="color:black">' + pa.Name + '</span>' + '-' + pa.Program_Associations__pc + '<br/>';// + str + ' ';
                        } else {
                            str = '<span style="color:black">' + pa.Name + '</span>' + '-' + 'None' + '<br/>';// + str + '';
                        }
                        
                        accUpdate.Program_Associations_RichText__c = str + removeNull(accUpdate.Program_Associations_RichText__c);
                        
                    }
                    
                }
                
            }
            
            if(mapAcc.size() > 0) update mapAcc.values();
      
        } 

    public static void handleAfterInsert(List<AccountContactRelation> triggerNew, map<id, AccountContactRelation> triggerNewMap){
        List<Id> accountIdList = new List<Id>();
        List<Id> contactIdList = new List<Id>();
        List<AccountContactRelation> accountContactRel = new List<AccountContactRelation>();
        Map<String,List<Account>> accountcontactMap = new Map<String,List<Account>>();
        List<Account> individualAccount = new List<Account>();
        Map<Id, String> accountFinalMap = new Map<Id, String>();
        map<Id,set<id>> accoConMap= new map<Id,set<Id>>();
        set<Id> accountIdset=new set<Id>();
        set<Id> contIdMembers = new set<Id>();
        set<Id> contactIdSet = new set<Id>();
        Map<Id,Boolean> createCaseMapCheck = new Map<Id,Boolean>();
        for(AccountContactRelation accCon: triggerNewMap.values()){
            if(accCon.Relationship__c != 'Provider User' && accCon.Relationship__c != 'Provider Team'){
            accountIdList.add(accCon.AccountId);
            contactIdList.add(accCon.contactId);
            if(!accountIdset.contains(accCon.AccountId)){
                accoConMap.put(accCon.AccountId,new set<id>{accCon.contactId});
                contIdMembers.add(accCon.contactId);
            }
            else{
                //set<id> contactIdSet=accoConMap.get(accCon.AccountId);
                contactIdSet.add(accCon.contactId);
                accoConMap.put(accCon.AccountId,contactIdSet);
                contIdMembers.add(accCon.contactId);
            }
            }
        }
        Id sniRecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Case Overview').getRecordTypeId();
        map<Id,Id> accOwnerMap=new map<Id,Id>();
        List<case> careplanLIst=new List<case>();
        Map<Id,Case> carePlanMap = new Map<Id,Case>();
        User userId = [select id from User where Name ='Unassigned'  and IsActive = true Limit 1];
        for(Account acc:[select ownerid,owner.IsActive from account where id IN :accoConMap.keyset()]){
            if(acc.owner.IsActive){
                accOwnerMap.put(acc.Id, acc.ownerid);
            }
            else{
                accOwnerMap.put(acc.Id, userId.id);
            }
        }
        if(contIdMembers.size() > 0){
            List<Case> caseList = new List<Case>();
            caseList.addAll([select Id,contactid from case where contactid IN : contIdMembers and recordtypeid =:sniRecordTypeId]);
            if(caseList.size() > 0){
                for(Case cas:caseList){
                    if(cas != null){
                        createCaseMapCheck.put(cas.ContactId,false);
                    }
                }
            }else{
                for(Id contactId : contIdMembers){
                    createCaseMapCheck.put(contactId,true);
                }
            }
        }
        system.debug('accoConMap.keyset().size()'+accoConMap.keyset().size());
        system.debug('accoConMap.keyset()'+accoConMap.keyset());
        system.debug('createCaseMapCheck.size()...'+createCaseMapCheck.size());
        system.debug('createCaseMapCheck....'+createCaseMapCheck);
        for(Id accountId:accoConMap.keyset()){
            for(Id contactid:contIdMembers){
            //for(Id contactid:accoConMap.get(accountId)){
                if(createCaseMapCheck.get(contactid) == true){
                    Case c=new case(
                        ownerid = accOwnerMap.get(accountId),
                        ContactId = contactid,
                        status='Open',
                        UHG_Restriction__c = 'No',//Default to no to avoid restriction on the caseoverview and visible to all
                        Onshore_Restriction__c = 'No',
                        recordtypeid=sniRecordTypeId
                    );
                    carePlanMap.put(c.ContactId,c);
                }
            }
        }
        careplanLIst.addAll(carePlanMap.values());
        insert careplanLIst;
        List<CaseTeamMember> ctmList = new List<CaseTeamMember>();

        Map<String,String>caseteamr = new Map<String,String>{};
            for(CaseTeamRole ct:[Select name,id from caseTeamRole]){
                caseteamr.put(ct.Name, ct.Id);
            }
        if(careplanLIst.size()>0){
            for(Case c:careplanLIst){
                CaseTeamMember ctmAdvisor = new CaseTeamMember(
                    ParentId = c.id,
                    MemberId = c.ownerid,
                    TeamRoleId = caseteamr.get('Advisor')
                );
                ctmList.add(ctmAdvisor);
                CaseTeamMember ctmPrimaryCareGiver = new CaseTeamMember(
                    ParentId = c.id,
                    MemberId = c.contactid,
                    TeamRoleId = caseteamr.get('Family Member')
                );
                ctmList.add(ctmPrimaryCareGiver);
            }
            insert ctmList;
        }

        accountContactRel = [Select accountId,contactid from AccountContactRelation where accountId in :accountIdList];
        system.debug('accountContactRel....'+accountContactRel);
        for(AccountContactRelation accCon:accountContactRel){
            contactIdList.add(accCon.contactid);
        }
        Map<String,Account> individualAccountMap = new Map<String,Account>();
        system.debug('contactIdList....'+contactIdList);
        for(Account a:[select PersonContactId,Name,recordType.Name,Program_Associations__pc from account where PersonContactId IN : contactIdList]){
            individualAccountMap.put(a.PersonContactId,a);
        }
        accountContactRel = [Select accountId,contactId  from AccountContactRelation where accountId in :accountIdList];
        system.debug('individualAccountMap..'+individualAccountMap);
        for(AccountContactRelation acc : accountContactRel){
            if(accountcontactMap.containsKey(acc.accountId)){
                List<account> temp = accountcontactMap.get(acc.accountId);
        if(individualAccountMap != null && individualAccountMap.get(acc.contactId) != null){
            temp.add(individualAccountMap.get(acc.contactId));
            accountcontactMap.put(acc.accountId, temp);
        }
            }else {
                accountcontactMap.put(acc.accountId, new List<account> {individualAccountMap.get(acc.contactId)});
            }
        }
        system.debug('accountcontactMap :'+accountcontactMap);

        for(Id a:accountcontactMap.keySet()){
            List<account> temp = accountcontactMap.get(a);
            String str = '';
            for(account acc: temp){
                if(acc!=null && acc.Program_Associations__pc != null){
                    str = '<span style="color:black">'+ acc.Name+'</span>'+'-'+acc.Program_Associations__pc+'<br/>'+str+' ';
                }if(acc!=null && acc.Program_Associations__pc == null){
                    str = '<span style="color:black">'+acc.Name+'</span>'+'-'+'None'+'<br/>'+str+'';
                }
            }
            accountFinalMap.put(a,str);
        }
        individualAccount = new List<Account>();

        for(Id accFin: accountFinalMap.keySet()){
            Account accUpdate = new Account();
            accUpdate.Id = accFin;
            accUpdate.EHub_Update_Check__c= true;
            accUpdate.Program_Associations_RichText__c = accountFinalMap.get(accFin);
            individualAccount.add(accUpdate);
            if(accountcontactMap != null && accountcontactMap.size()>0){
                for(Account memacc: accountcontactMap.get(accFin)){
                    Account memAccUpdate = new Account();
            if(memacc != null && memacc.id != null){
                memAccUpdate.Id = memacc.id;
                memAccUpdate.EHub_Update_Check__c= true;
                individualAccount.add(memAccUpdate);
            }
                }
            }
        }
        if(individualAccount.size() > 0)
            update individualAccount;

    }

    
    // US2720791- by pass for the SNI data migration - Inshar - 08/07/2020
    // commented because not performing any action
    /*
    public static void handleBeforeUpdate(List<AccountContactRelation> triggerNew, map<id, AccountContactRelation> triggerNewMap){
        List<Id> accountIdList = new List<Id>();
        List<Id> contactIdList = new List<Id>();
        List<Account> individualAccount = new List<Account>();
        for(AccountContactRelation accCon: triggerNew){
            accountIdList.add(accCon.AccountId);
            contactIdList.add(accCon.ContactId);
        }
    }*/
    
    public static void handleAfterUpdate(List<AccountContactRelation> triggerNew, map<id, AccountContactRelation> triggerNewMap,map<id, AccountContactRelation> triggerOldMap){
        List<Id> accountIdList = new List<Id>();
        List<Id> contactIdList = new List<Id>();
        List<Account> individualAccount = new List<Account>();
        for(AccountContactRelation accCon: triggerNew){
            string oldRelshipVal = triggerOldMap.get(accCon.id).Relationship__c;
            if(accCon.Relationship__c != oldRelshipVal){    
              accountIdList.add(accCon.AccountId);
              contactIdList.add(accCon.ContactId);
            }
        }
    if(accountIdList.size()>0 && contactIdList.size()>0){
        Map<String,Account> individualAccountMap = new Map<String,Account>();
        for(Account a:[select Id,PersonContactId,Name,recordType.Name,Program_Associations__pc from account where PersonContactId IN : contactIdList]){
            individualAccountMap.put(a.PersonContactId,a);
        }
        individualAccount = new List<Account>();
        for(Id accFin: accountIdList){
            Account accUpdate = new Account();
            accUpdate.Id = accFin;
            accUpdate.EHub_Update_Check__c= true;

            individualAccount.add(accUpdate);
            for(Id memacc: contactIdList){
                Account memAccUpdate = new Account();
                memAccUpdate.Id = individualAccountMap.get(memacc).Id;
                memAccUpdate.EHub_Update_Check__c= true;
                individualAccount.add(memAccUpdate);
            }
        }
        if(individualAccount.size() > 0){
            Map<Id, Account> mapAccount = new Map<Id, Account>();

            for(Account acc : individualAccount){
            mapAccount.put(acc.Id, acc);
            }

            update mapAccount.values();
            }
        }
    }
    public static void handleAfterDelete(List<AccountContactRelation> triggerOld, map<id, AccountContactRelation> triggerOldMap){
        List<Id> accountIdList = new List<Id>();
        List<Id> contactIdList = new List<Id>();
        List<AccountContactRelation> accountContactRel = new List<AccountContactRelation>();
        Map<String,List<Account>> accountcontactMap = new Map<String,List<Account>>();
        List<Account> individualAccount = new List<Account>();
        Map<Id, String> accountFinalMap = new Map<Id, String>();
        for(AccountContactRelation accCon: triggerOld){
            accountIdList.add(accCon.AccountId);
        }
        system.debug('accountIdList...'+accountIdList);
        
        accountContactRel = [Select accountId,contactid from AccountContactRelation where accountId in :accountIdList];
        system.debug('---accountContactRel----'+accountContactRel );
        for(AccountContactRelation accCon:accountContactRel){
            contactIdList.add(accCon.contactid);
        }
        system.debug('contactIdList..'+contactIdList);
        Map<String,Account> individualAccountMap = new Map<String,Account>();
        for(Account a:[select PersonContactId,Name,recordType.Name,Program_Associations__pc from account where PersonContactId IN : contactIdList]){
            individualAccountMap.put(a.PersonContactId,a);
        }
       // accountContactRel = [Select accountId,contactId  from AccountContactRelation where accountId in :accountIdList];
        system.debug('accountContactRel..'+accountContactRel);
        if(accountContactRel.size()>0){
            for(AccountContactRelation acc : accountContactRel){
                if(accountcontactMap.containsKey(acc.accountId)){
                    List<account> temp = accountcontactMap.get(acc.accountId);
            if(individualAccountMap != null && individualAccountMap.get(acc.contactId) != null){
                    temp.add(individualAccountMap.get(acc.contactId));
                    accountcontactMap.put(acc.accountId, temp);
            }
                }else {
                    accountcontactMap.put(acc.accountId, new List<account> {individualAccountMap.get(acc.contactId)});
                }
            }
            for(Id a:accountcontactMap.keySet()){
                List<account> temp = accountcontactMap.get(a);
                String str = '';
                for(account acc: temp){
                    if(acc.Program_Associations__pc != null){
                        str = '<span style="color:black">'+ acc.Name+'</span>'+'-'+acc.Program_Associations__pc+'<br/>'+str+' ';
                    }if(acc.Program_Associations__pc == null){
                        str = '<span style="color:black">'+acc.Name+'</span>'+'-'+'None'+'<br/>'+str+'';
                    }
                }
                accountFinalMap.put(a,str);
            }
            individualAccount = new List<Account>();
            for(Id accFin: accountFinalMap.keySet()){
                Account accUpdate = new Account();
                accUpdate.Id = accFin;
                accUpdate.EHub_Update_Check__c= true;
                accUpdate.Program_Associations_RichText__c = accountFinalMap.get(accFin);
                individualAccount.add(accUpdate);
                if(accountcontactMap != null && accountcontactMap.size()>0){
                    for(Account memacc: accountcontactMap.get(accFin)){
                        Account memAccUpdate = new Account();
                        if(memacc != null && memacc.id != null){
                        memAccUpdate.Id = memacc.id;
                        memAccUpdate.EHub_Update_Check__c= true;
                        individualAccount.add(memAccUpdate);
                        }
                    }
                }
            }
           if(individualAccount.size() > 0){
            Map<Id, Account> mapAccount = new Map<Id, Account>();

            for(Account acc : individualAccount){
            mapAccount.put(acc.Id, acc);
            }

            update mapAccount.values();
        }
        }else{
            individualAccount = new List<Account>();
            for(Id accFin: accountIdList){
                Account accUpdate = new Account();
                accUpdate.Id = accFin;
                accUpdate.EHub_Update_Check__c= true;
                accUpdate.Program_Associations_RichText__c = '';
                individualAccount.add(accUpdate);
                if(accountcontactMap != null && accountcontactMap.size()>0){
                    for(Account memacc: accountcontactMap.get(accFin)){
                        Account memAccUpdate = new Account();
                        if(memacc != null && memacc.id != null){
                        memAccUpdate.Id = memacc.id;
                        memAccUpdate.EHub_Update_Check__c= true;
                        individualAccount.add(memAccUpdate);
                        }
                    }
                }
            }
           if(individualAccount.size() > 0){
            Map<Id, Account> mapAccount = new Map<Id, Account>();

            for(Account acc : individualAccount){
            mapAccount.put(acc.Id, acc);
            }

            update mapAccount.values();
        }
            system.debug('individualAccount...'+individualAccount);
        }

    }
    
    private static CaseTeamMember createCaseTeamMember(Case c, Id roleId, String roleType) {
        CaseTeamMember ctm = new CaseTeamMember();
    ctm.ParentId = c.Id;
        if(roleType == 'Advisor') {
          ctm.MemberId = c.ownerId;    
        } else {
            ctm.MemberId = c.ContactId;
        }
    
    ctm.TeamRoleId = roleId;        
        return ctm;
    }
    
    private static String removeNull(String str) {
        
        if(str == null || str.toLowerCase() == 'null') return '';
        
        return str;
    }
  public static void createCareteam(List<AccountContactRelation> triggerNew, map<id, AccountContactRelation> triggerNewMap){
        
        Id familyAccRecTypId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Family').getRecordTypeId();        
        Id indAccRecTypId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Individual').getRecordTypeId();
        
        Set<Id> persncontIds = new Set<Id>();
        Set<Id> familyIds = new Set<Id>();
        Map<Id,Id> perscontAccIds = new Map<Id,Id>(); //Map person contactId and its related Account Id
        Map<Id,List<SNI_FL_Care_Team_Member__c>> mapFamilyCateteam = new Map<Id,List<SNI_FL_Care_Team_Member__c>>(); //Capture careteam recs for each family
        Map<Id,List<Id>> mapPersonFamily = new Map<Id,List<Id>>(); //Capture Family list for each Individual
        Map<Id,SNI_FL_Care_Team_Member__c> mapfao = new Map<Id,SNI_FL_Care_Team_Member__c>(); //Map family and its related fao rec
        Map<String,SNI_FL_Care_Team_Member__c> mapPersnFamilyCtm = new Map<String,SNI_FL_Care_Team_Member__c>(); //Map persncontact family and its related Care team rec
        Map<Id,List<Id>> mappersncontFamily = new Map<Id,List<Id>>();   //Map for each contact and its related family 
        Map<Id,User> mappersnUsers = new Map<Id,User>(); //Map for each contact and its related User
        
        if(triggerNew!=Null && triggerNew.size()>0){
            for(AccountContactRelation acr: triggerNew){
                persncontIds.add(acr.ContactId);
            }
        } 
        if(persncontIds!=null && persncontIds.size()>0){
            for(User u:[select Id,ContactId,Contact.AccountId from User where ContactId IN:persncontIds]){
                mappersnUsers.put(u.ContactId,u);
            }
        }
        if(persncontIds!=null && persncontIds.size()>0){
            for(AccountContactRelation famacc: [select Id,ContactId,AccountId,contact.AccountId,Account.RecordTypeId from AccountContactRelation where ContactId IN:persncontIds AND Account.RecordTypeId=:familyAccRecTypId]){
                familyIds.add(famacc.AccountId);
                perscontAccIds.put(famacc.ContactId,famacc.contact.AccountId);
                if(mappersncontFamily.containsKey(famacc.ContactId)){
                     List<Id> fmlst = mappersncontFamily.get(famacc.ContactId);
                     fmlst.add(famacc.AccountId);
                     mappersncontFamily.put(famacc.ContactId, fmlst);
                  } else {
                     mappersncontFamily.put(famacc.ContactId,new List<Id>{famacc.AccountId});
                  }
            }
        }
        system.debug('>>>familyIds<<<<'+familyIds);
        //system.debug('>query<<<<'+[select Id,SNI_FL_Family__c,SNI_FL_Primary_Caregiver__c,SNI_FL_Not_Visible_in_Familylink__c,SNI_FL_Status__c,SNI_FL_Member__c,SNI_FL_Member__r.PersonContactId from SNI_FL_Care_Team_Member__c]);
        if(familyIds!=Null && familyIds.size()>0){
            for(SNI_FL_Care_Team_Member__c ctmrec : [select Id,SNI_FL_Family__c,SNI_FL_Primary_Caregiver__c,SNI_FL_Not_Visible_in_Familylink__c,SNI_FL_Status__c,SNI_FL_Member__c,SNI_FL_Member__r.PersonContactId from SNI_FL_Care_Team_Member__c where SNI_FL_Family__c IN:familyIds]){
                if(String.isNotBlank(ctmrec.SNI_FL_Family__c)){
                    
                        if(ctmrec.SNI_FL_Primary_Caregiver__c == true){
                            mapfao.put(ctmrec.SNI_FL_Family__c,ctmrec);
                        }                    
                        if(mapfamilyCateteam.containsKey(ctmrec.SNI_FL_Family__c)){
                            List<SNI_FL_Care_Team_Member__c> ctmlst = mapfamilyCateteam.get(ctmrec.SNI_FL_Family__c);
                            ctmlst.add(ctmrec);
                            mapFamilyCateteam.put(ctmrec.SNI_FL_Family__c, ctmlst);
                        } else {
                            mapFamilyCateteam.put(ctmrec.SNI_FL_Family__c,new List<SNI_FL_Care_Team_Member__c>{ctmrec});
                         }
                    if(String.isNotBlank(ctmrec.SNI_FL_Member__r.PersonContactId)){
                        if(mapPersonFamily.containsKey(ctmrec.SNI_FL_Member__r.PersonContactId)){
                            List<Id> fmlst = mapPersonFamily.get(ctmrec.SNI_FL_Member__r.PersonContactId);
                            fmlst.add(ctmrec.SNI_FL_Family__c);
                            mapPersonFamily.put(ctmrec.SNI_FL_Member__r.PersonContactId, fmlst);
                        }else {
                            mapPersonFamily.put(ctmrec.SNI_FL_Member__r.PersonContactId,new List<Id>{ctmrec.SNI_FL_Family__c});
                         }
                        mapPersnFamilyCtm.put(ctmrec.SNI_FL_Member__c+'~'+ctmrec.SNI_FL_Family__c,ctmrec);
                    }
                }
            }
          
        }    
        List<SNI_FL_Care_Team_Member__c> ctmlstinst = new List<SNI_FL_Care_Team_Member__c>();
        List<SNI_FL_Care_Team_Member__c> ctmlstupdt = new List<SNI_FL_Care_Team_Member__c>();
        
            for(AccountContactRelation acc: triggerNew){
                String personcontact = acc.ContactId;
              if(mappersncontFamily.containsKey(personcontact)){
                List<Id> lstfm = mappersncontFamily.get(personcontact);
                 System.debug('lstfm'+lstfm);
                  //logic for single family 
                if(lstfm!=Null && lstfm.size()==1){
                    //If any Care team record is existed for single family
                    if(mapFamilyCateteam.containsKey(lstfm[0])){
                        SNI_FL_Care_Team_Member__c fao = new SNI_FL_Care_Team_Member__c();
                        if(mapfao.containsKey(lstfm[0])){
                            fao = mapfao.get(lstfm[0]);
                        }
                        if(fao!=Null && fao.SNI_FL_Primary_Caregiver__c==true && fao.SNI_FL_Not_Visible_in_Familylink__c==false){
                            SNI_FL_Care_Team_Member__c careTeam = new SNI_FL_Care_Team_Member__c();
                            careTeam.SNI_FL_Family__c = lstfm[0];
                            careTeam.SNI_FL_Member__c=perscontAccIds.get(personcontact);
                            careTeam.SNI_FL_Not_Visible_in_Familylink__c = false;
                            careTeam.SNI_FL_Status__c='Added';
                            careTeam.SNI_FL_Added_Date__c=System.today();
                            careTeam.SNI_FL_Primary_Caregiver__c=false;
                            careTeam.SNI_FL_Non_Policy_Member__c=false;
                            ctmlstinst.add(careTeam);
                        }
                    } 
                    
                }
                 else if(lstfm!=Null && lstfm.size()>1){  //logic for mulitple family
                    if(mappersnUsers.containsKey(personcontact)){  //User rec is exist with the contact
                        User u =mappersnUsers.get(personcontact);
                        for(Id fmid: lstfm){
                            List<SNI_FL_Care_Team_Member__c> ctmlst;
                            if(mapFamilyCateteam.containsKey(fmid)){
                                ctmlst = mapFamilyCateteam.get(fmid);
                              }
                                if(fmid == acc.AccountId){
                                    if(ctmlst==Null || ctmlst.size()==0){
                                        SNI_FL_Care_Team_Member__c careTeam = new SNI_FL_Care_Team_Member__c();
                                        careTeam.SNI_FL_Family__c = fmid;
                                        careTeam.SNI_FL_Member__c=perscontAccIds.get(personcontact);
                                        careTeam.SNI_FL_Not_Visible_in_Familylink__c = true;
                                        careTeam.SNI_FL_Status__c='Registered';
                                        careTeam.SNI_FL_Registered_Date__c=System.today();
                                        careTeam.SNI_FL_Primary_Caregiver__c=false;
                                        careTeam.SNI_FL_Non_Policy_Member__c=false;
                                        ctmlstinst.add(careTeam);
                                    }else{                                        
                                        SNI_FL_Care_Team_Member__c careTeam = new SNI_FL_Care_Team_Member__c();
                                        careTeam.SNI_FL_Family__c = fmid;
                                        careTeam.SNI_FL_Member__c=perscontAccIds.get(personcontact);
                                        careTeam.SNI_FL_Status__c='Registered';
                                        careTeam.SNI_FL_Registered_Date__c=System.today();
                                        careTeam.SNI_FL_Primary_Caregiver__c=false;
                                        careTeam.SNI_FL_Non_Policy_Member__c=false;
                                        if(mapfao.containsKey(fmid)){
                                           SNI_FL_Care_Team_Member__c fao = mapfao.get(fmid);  
                                            if(fao!=Null && fao.SNI_FL_Not_Visible_in_Familylink__c==false && fao.SNI_FL_Primary_Caregiver__c==true){
                                                careTeam.SNI_FL_Not_Visible_in_Familylink__c = false;
                                            }else{
                                                careTeam.SNI_FL_Not_Visible_in_Familylink__c = true;
                                            }
                                        }else{
                                          careTeam.SNI_FL_Not_Visible_in_Familylink__c = true;
                                        }
                                        ctmlstinst.add(careTeam);
                                    }
                                }else{  //Update the existing recs with Registered status
                                    String s=perscontAccIds.get(personcontact)+'~'+fmid;                                    
                                    if(mapPersnFamilyCtm.containsKey(s)){
                                        SNI_FL_Care_Team_Member__c ctmupd = mapPersnFamilyCtm.get(s);
                                        if(ctmupd!=Null && (ctmupd.SNI_FL_Status__c=='Added'||ctmupd.SNI_FL_Status__c=='Invited')){
                                           ctmupd.SNI_FL_Status__c ='Registered'; 
                                           ctmupd.SNI_FL_Registered_Date__c=System.today();
                                        }
                                        if(mapfao.containsKey(fmid)){
                                           SNI_FL_Care_Team_Member__c fao = mapfao.get(fmid);  
                                           if(fao!=Null && fao.SNI_FL_Not_Visible_in_Familylink__c==false && fao.SNI_FL_Primary_Caregiver__c==true){
                                                ctmupd.SNI_FL_Not_Visible_in_Familylink__c = false;
                                            }else{
                                                ctmupd.SNI_FL_Not_Visible_in_Familylink__c = true;
                                            } 
                                        }else{
                                           ctmupd.SNI_FL_Not_Visible_in_Familylink__c = true; 
                                        }
                                       ctmlstupdt.add(ctmupd); 
                                    }
                                }
                        }
                    }else{
                        for(Id fmid: lstfm){
                            if(fmid == acc.AccountId){
                                SNI_FL_Care_Team_Member__c fao = new SNI_FL_Care_Team_Member__c();
                                if(mapfao.containsKey(fmid)){
                                    fao = mapfao.get(fmid);
                                }
                                if(fao!=Null && fao.SNI_FL_Primary_Caregiver__c==true && fao.SNI_FL_Not_Visible_in_Familylink__c==false){
                                    SNI_FL_Care_Team_Member__c careTeam = new SNI_FL_Care_Team_Member__c();
                                    careTeam.SNI_FL_Family__c = fmid;
                                    careTeam.SNI_FL_Member__c=perscontAccIds.get(personcontact);
                                    careTeam.SNI_FL_Not_Visible_in_Familylink__c = false;
                                    careTeam.SNI_FL_Status__c='Added';
                                    careTeam.SNI_FL_Added_Date__c=System.today();
                                    careTeam.SNI_FL_Primary_Caregiver__c=false;
                                    careTeam.SNI_FL_Non_Policy_Member__c=false;
                                    ctmlstinst.add(careTeam);
                                }
                            }
                        }
                    }
                } 
              }   
            }
        if(ctmlstinst!=Null && ctmlstinst.size()>0){
               insert ctmlstinst;
           } 
        if(ctmlstupdt!=Null && ctmlstupdt.size()>0){
            update ctmlstupdt;
        }
    }
    public static void memAffShareInsertOperation(map<Id,AccountContactRelation> triggerNewMap){
        set<id> contactset = new set<id>();
        set<id> provAffset = new set<id>();
        set<id> userIdset = new set<id>();
        map<Id,Id> contactusrIDs = new map<Id,Id>();
        map<Id,list<Id>> acrMap = new map<Id,list<Id>>();
        map<Id,list<Id>> memAffShrMap = new map<Id,list<Id>>();
        list<Member_Affiliation__Share>memaffshr = new list<Member_Affiliation__Share>();
        Id recordIDpa = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Provider Affiliation').getRecordTypeId();
        set<Id> acrIds = triggerNewMap.keyset();
        for(AccountContactRelation ProvideraffACR : [select Id, AccountId, ContactId, Account.RecordTypeId, Relationship__c from AccountContactRelation where Id in :acrIds and Relationship__c ='Provider User']){
            if(ProvideraffACR.Account.RecordTypeId ==recordIDpa){
                if(acrMap.size() > 0 && acrMap.containskey(ProvideraffACR.AccountId)){ 
                    list<Id> acrtemp = acrMap.get(ProvideraffACR.AccountId);
                    acrtemp.add(ProvideraffACR.contactId);
                    acrMap.put(ProvideraffACR.AccountId, acrtemp);
                }else{
                    list<Id> acrtempadd = new list<Id>();
                    acrtempadd.add(ProvideraffACR.contactId);
                    acrMap.put(ProvideraffACR.AccountId, acrtempadd);
                }
                provAffset.add(ProvideraffACR.AccountId);
                contactset.add(ProvideraffACR.contactId);
            } 
        }
        if(contactset.size()>0){
            for(User u: [select Id, contactId, Profile_Name__c from user where contactId in:contactset and Profile_Name__c ='Care Advisor Connect Provider User' ]){
                userIdset.add(u.Id);
                contactusrIDs.put(u.ContactId,u.Id);
            }  
        } 
        if(contactusrIDs.size()>0){    
            map<id,Member_Affiliation__c> mfRecs = new map<id,Member_Affiliation__c>([select Id, Name, Provider_Affiliation__c from Member_Affiliation__c where Provider_Affiliation__c in :provAffset]);
            if(mfRecs.size()>0){
                for( Member_Affiliation__Share mshare : [select ParentId,UserOrGroupId from Member_Affiliation__Share where ParentId in:mfRecs.keyset() and UserOrGroupId in:userIdset]){
                    if(memAffShrMap.size() > 0 && memAffShrMap.containskey(mshare.ParentId)){ 
                        list<Id> memAfftemp = memAffShrMap.get(mshare.ParentId);
                        memAfftemp.add(mshare.UserOrGroupId);
                        memAffShrMap.put(mshare.ParentId, memAfftemp);
                    }else{
                        list<Id> memAfftempadd = new list<Id>();
                        memAfftempadd.add(mshare.UserOrGroupId);
                        memAffShrMap.put(mshare.ParentId, memAfftempadd);
                    }                                                   
                }
                for(Member_Affiliation__c memA:mfRecs.values()){
                    if(acrMap.containskey(memA.Provider_Affiliation__c)){
                        for(Id contactide :acrMap.get(memA.Provider_Affiliation__c)){
                            if(memAffShrMap.containskey(memA.Id)){
                                if(!memAffShrMap.get(memA.Id).contains(contactusrIDs.get(contactide))){
                                    Member_Affiliation__Share ms = new Member_Affiliation__Share();
                                    ms.ParentId = memA.Id;
                                    ms.UserOrGroupId = contactusrIDs.get(contactide);
                                    ms.AccessLevel = 'Read';
                                    ms.RowCause = Schema.Member_Affiliation__Share.RowCause.Manual;
                                    memaffshr.add(ms);
                                }
                            }else{
                                Member_Affiliation__Share ms = new Member_Affiliation__Share();
                                ms.ParentId = memA.Id;
                                ms.UserOrGroupId = contactusrIDs.get(contactide);
                                ms.AccessLevel = 'Read';
                                ms.RowCause = Schema.Member_Affiliation__Share.RowCause.Manual;
                                memaffshr.add(ms);
                            }
                        }
                    }
                }
                if(memaffshr.size()>0){
                    insert memaffshr;
                }
            }
        }
    }
    
     public static void priorComplexIndicator(AccountContactRelation acr,string accCI){        
        String complexIndicatorFinal;
        string complexIndicatorFromEvisor = accCI==null?'':accCI;
        List<String> ciEvisorLst = complexIndicatorFromEvisor.split(',');
        String complexIndicatorFromEvisorFinal = String.join(ciEvisorLst, '(EVISOR),');
        complexIndicatorFromEvisorFinal = complexIndicatorFromEvisorFinal==''?complexIndicatorFromEvisor:complexIndicatorFromEvisorFinal + '(EVISOR)';
        
        string complexIndicatorFromSens = acr.Complex_Indicator__c==null?'':acr.Complex_Indicator__c;
        List<String> ciSensLst = complexIndicatorFromSens.split(';');
        String complexIndicatorFromSensFinal = String.join(ciSensLst, '(SENS),');
        complexIndicatorFromSensFinal = complexIndicatorFromSens==''?complexIndicatorFromSens:complexIndicatorFromSensFinal + '(SENS)';
         
        complexIndicatorFinal = complexIndicatorFromSensFinal==''?complexIndicatorFromEvisorFinal:(complexIndicatorFromEvisorFinal==''?complexIndicatorFromSensFinal:complexIndicatorFromEvisorFinal + ','+ complexIndicatorFromSensFinal);
        
        acr.Complex_Indicator_Text__c = complexIndicatorFinal;
     }

     public static void updateCIinSENSPublish (List<AccountContactRelation> triggerNew, map<id, AccountContactRelation> triggerOldMap) {
        Map<String, AccountContactRelation> ACRwithUpdCI = new Map<String, AccountContactRelation>();
        for(AccountContactRelation accCon: triggerNew){
            string oldcomplexInd = triggerOldMap.get(accCon.id).Complex_Indicator_Text__c;
            if(accCon.Complex_Indicator_Text__c != oldcomplexInd){ 
                ACRwithUpdCI.put(accCon.Id, accCon);
            }
        }
        
        Map<String, String> mapUniqueMemberIdtoCI = new Map<String, String>();
        Map<String, String> mapMemberIdToDOB = new Map<String, String>();
        
        for (AccountContactRelation acr : [SELECT Id, Contact.AccountId,Contact.BirthDate,Contact.Name, Complex_Indicator_Text__c, Policy_ID__c, Member_ID__c 
                                           from AccountContactRelation WHERE Id IN: ACRwithUpdCI.keySet()]) {
                                               String uniqueMemberIdentification = '';
                                               if ( acr.Member_ID__c != '') {
                                                   uniqueMemberIdentification =  acr.Member_ID__c+'~'+acr.Contact.Name+'~'+acr.Contact.BirthDate;
                                                   mapMemberIdToDOB.put(acr.Member_ID__c, uniqueMemberIdentification);
                                                   mapUniqueMemberIdtoCI.put(uniqueMemberIdentification, acr.Complex_Indicator_Text__c); 
                                               }
                                           }
        
        list<Sens_Publish__c> lstSensPub = new list<Sens_Publish__c>();
        if (mapMemberIdToDOB.values().size() > 0) {
            for (Sens_Publish__c sensP : [SELECT Id, Complex_Indicator__c,First_Name__c,Last_Name__c,DOB__c, Member_ID__c from Sens_Publish__c where Member_ID__c IN:  mapMemberIdToDOB.keySet()]) {
                String uniqueMemberIdentificationFromSensPublish = '';                
                if(sensP.Member_ID__c != null){
                    uniqueMemberIdentificationFromSensPublish = sensP.Member_ID__c+'~'+sensP.First_Name__c+' '+sensP.Last_Name__c+'~'+sensP.DOB__c;
                    if(mapMemberIdToDOB.containsKey(sensP.Member_ID__c) && uniqueMemberIdentificationFromSensPublish == mapMemberIdToDOB.get(sensP.Member_ID__c)){
                        sensP.Complex_Indicator__c = mapUniqueMemberIdtoCI.get(uniqueMemberIdentificationFromSensPublish);
                        lstSensPub.add(sensP);
                    }                    
                }                
            }
        }
        if (lstSensPub.size() > 0) {
            update lstSensPub;
        } 
    }
}