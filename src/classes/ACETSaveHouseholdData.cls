public class ACETSaveHouseholdData {
    @AuraEnabled
    public static String getSaveHouseHoldData(ACETHouseHoldWrapper.HouseHold[] houseHoldData,String dob,String memberId,string advFullName,String sniEligibleStatus,String policyId,String policyIdOrignal,String assignTo){
        system.debug('houseHoldData****'+houseHoldData);
        system.debug('sniEligibleStatus****'+sniEligibleStatus);
        system.debug('policyId******'+policyId);
        system.debug('policyIdOrignal******'+policyIdOrignal);
        system.debug('assignTo******'+assignTo);
        String accountId;
        List<String> relationshipStatus = new List<String>();
        List<String> eligibilityStatus = new List<String>();
        Schema.DescribeFieldResult statusResult = Account.Special_Needs_Status__c.getDescribe();
        List<Schema.PicklistEntry> res = statusResult.getPicklistValues();
        for( Schema.PicklistEntry statusVal : res){
            eligibilityStatus.add(statusVal.getValue());
        }
        System.debug('eligibilityStatus....'+eligibilityStatus);
        //Schema.DescribeFieldResult fieldResult = AccountContactRelation.Relationship__c.getDescribe();
        // List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues(); commeneted for code design changes
        map<String,String>  relationshipMetaData = ACETUtility.getHouseholdRelationshipMap();
        Boolean isPolicyUhg = ACETUtility.checkUHGPolicy(policyIdOrignal);//US2367595-Code Added By Chandan

        // Need to write the logic if a household exist in the system but later on became ineligible so need to update the same in the current system. In order to do
        // that we need to bind the policy separately and not in household.
        system.debug('acetSaveHoluseholdData-----------'+sniEligibleStatus);
        if(sniEligibleStatus == 'not eligible'){
            system.debug('acetSaveHoluseholdData--------inn--11---');

            Account[] acc = [select id, Name, Member_ID__c, Special_Needs_Status__c from account where  Member_ID__c =: memberId and Policy_ID__c  =: policyIdOrignal]; // Also add the logic to put policy number for query
            // system.debug('acetSaveHoluseholdData--------inn--22---');
            Account a = new Account();
            if(acc != null && acc.size() > 0){
                //   system.debug('acetSaveHoluseholdData--------inn--33---');
                for(String stats:eligibilityStatus){
                    if(stats.contains(sniEligibleStatus)){
                        a.Special_Needs_Status__c = stats;
                    }
                }

                string oldStatus = acc[0].Special_Needs_Status__c;
                a.id = acc[0].Id;
                //US2367595-Code Added By Chandan-Start
                if(isPolicyUhg){
                    a.UHG_Restriction__c	 = 'Yes';
                }
                else{
                    a.UHG_Restriction__c	 = 'No';
                }
                //US2367595-Code End By Chandan
                update a;

                system.debug('acetSaveHoluseholdData-------oldStatus----'+oldStatus);

                if(oldStatus == 'engaged' || oldStatus == 'eligible'){
                    string fName = '' ; string lname = '';
                    for(ACETHouseHoldWrapper.HouseHold h:houseHoldData){
                        if(h.isMainMember){
                            //houseDataTempUpdate.dob = h.dob;
                            fName = h.firstName;
                            lname = h.lastName;
                        }
                    }

                    List<Id> conId = new List<Id>();
                    for(AccountContactRelation i:[Select ContactId,accountId from AccountContactRelation where accountId =:acc[0].Id]){
                        conId.add(i.ContactId);
                    }
                    Id personAccId ;
                    if( fName != '' && lname != ''){
                        for(Account ac : [Select Id, FirstName, LastName from account where PersonContactId IN :conId]){
                            if(ac.FirstName == fName && ac.LastName == lname){
                                personAccId = ac.Id;
                                //return false;
                            }
                        }
                    }
                    system.debug('acetSaveHoluseholdData-------personAccId----'+personAccId);
                    if(personAccId != null)
                        accountId = acc[0].Id+'@'+personAccId;
                    else
                        accountId = '';

                }
                else
                    accountId = '';

            }

        }
        else{
            ACETHouseHoldWrapper.HouseHold houseDataTemp = new ACETHouseHoldWrapper.HouseHold();
            List<String> newServiceRelation = new List<String>();
            if(houseHoldData != null && dob != null && memberId != null){
                for(ACETHouseHoldWrapper.HouseHold h:houseHoldData){
                    //if(h.relationship == 'Subscriber'){
                    if(relationshipMetaData!=null && relationshipMetaData.get(h.relationship)!=null && relationshipMetaData.get(h.relationship)=='Subscriber/Recipient'){
                        houseDataTemp.dob = h.dob;
                        houseDataTemp.firstName = h.firstName;
                        houseDataTemp.memberId = h.memberId;
                        houseDataTemp.fullName = h.fullName;
                        houseDataTemp.lastName = h.lastName;
                        houseDataTemp.relationship = h.relationship;
                        houseDataTemp.policyId = policyIdOrignal;
                    }

                }
                Id familyAccRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Family').getRecordTypeId();
                Id personAccRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Individual').getRecordTypeId();
                Account[] acc = [select id, Name, FirstName, LastName, Member_ID__c from account where  Member_ID__c =: houseDataTemp.memberId and Policy_ID__c  =: houseDataTemp.policyId]; // Also add the logic to put policy number for query
                User[] unassignedUser = [select id from User where Name ='Unassigned'];
                User[] advisor;
                if(String.isEmpty(assignTo)){
                    advisor = unassignedUser;
                }
                if((sniEligibleStatus == 'engaged' || sniEligibleStatus == 'eligible') && !String.isEmpty(assignTo)){
                    advisor = [select id, Name from User where FederationIdentifier =:assignTo  and IsActive = true];
                    if(advisor.size() == 0 || advisor == null){
                        advisor = unassignedUser;
                    }
                }
                system.debug('advisor.......'+advisor);
                if(acc.size() == 0){
                    Account a = new Account();
                    a.Name = houseDataTemp.fullName;
                    a.Member_ID__c = houseDataTemp.memberId;
                    a.Policy_ID__c = policyIdOrignal;
                    for(String stats:eligibilityStatus){
                        if(stats.equals(sniEligibleStatus)){
                            a.Special_Needs_Status__c = stats;
                        }
                    }
                    a.RecordTypeId = familyAccRecordTypeId;
                    a.OwnerId = advisor[0].Id;
                    //US2367595-Code Added By Chandan-Start
                    if(isPolicyUhg){
                        a.UHG_Restriction__c	 = 'Yes';
                    }
                    else{
                        a.UHG_Restriction__c	 = 'No';
                    }
                    //US2367595-Code End By Chandan
                    Account personAccount = new Account();
                    String relationVal ;
                    Boolean newRelationval = true ;
                    for(ACETHouseHoldWrapper.HouseHold h:houseHoldData){
                        if(date.parse(h.dob) == date.valueOf(ACETUtility.formatDateFutureDate(dob)) && h.isMainMember){
                            personAccount.PersonBirthdate = date.valueOf(ACETUtility.formatDateFutureDate(dob));
                            personAccount.firstName = h.firstName;
                            personAccount.lastName = h.lastName;
                            personAccount.RecordTypeId = personAccRecordTypeId;
                            //personAccount.OwnerId = advisor[0].Id;
                            //personAccount.Relationship__pc = h.relationship;
                            //Get the ACET Relationship Mapping from the ACETServiceRelationshipMap__c
                            for(String s:relationshipMetaData.keyset()){
                                if( s != null && s.equalsIgnoreCase(h.relationship)){
                                     newRelationval = false;
                                    relationVal = relationshipMetaData.get(s);
                                    newServiceRelation.add(h.relationship);
                                }
                            }
                          //If a new value is received in relationship then insert into the ACETServiceRelationshipMap__c Object
                         //And The ACET value will be Unknown
                          if(newRelationval){
                                    ACETUtility.insertHouseholdRelationshipData(newServiceRelation);
                                    relationVal = 'Unknown';
                                }
                            /*for(String s:relationshipStatus){
                            if(s.contains(h.relationship)){
                            personAccount.Relationship__pc = s;
                            }
                            }*/
                        }
                    }
                    insert a;
                    insert personAccount;
                    String conId = [select PersonContactId from account where Id =:personAccount.Id].PersonContactId;
                    AccountContactRelation accConRelation = new AccountContactRelation();
                    accConRelation.AccountId = a.Id;
                    accConRelation.ContactId = conId;
                    accConRelation.Relationship__c =relationVal;
                    accConRelation.Member_ID__c =houseDataTemp.memberId;
                    accConRelation.Policy_ID__c = policyIdOrignal;
                    insert accConRelation;
                    accountId = a.Id+'@'+conId;
                }else{
                    ACETHouseHoldWrapper.HouseHold houseDataTempUpdate = new ACETHouseHoldWrapper.HouseHold();
                    for(ACETHouseHoldWrapper.HouseHold h:houseHoldData){
                        if(h.isMainMember){
                            houseDataTempUpdate.dob = h.dob;
                            houseDataTempUpdate.firstName = h.firstName;
                            houseDataTempUpdate.memberId = h.memberId;
                            houseDataTempUpdate.fullName = h.fullName;
                            houseDataTempUpdate.lastName = h.lastName;
                            houseDataTempUpdate.relationship = h.relationship;
                            houseDataTempUpdate.policyId = policyIdOrignal;
                            houseDataTempUpdate.isMainMember = h.isMainMember;
                        }
                    }
                    system.debug('houseDataTemp....if exist'+houseDataTempUpdate);
                    Account a = new Account();
                    a.Id = acc[0].Id;
                    //a.OwnerId = advisor[0].Id;
                    a.Name = houseDataTemp.fullName;
                    for(String stats:eligibilityStatus){
                        if(stats.equals(sniEligibleStatus)){
                            a.Special_Needs_Status__c = stats;
                        }
                    }
                    //US2367595-Code Added By Chandan-Start
                    if(isPolicyUhg){
                        a.UHG_Restriction__c	 = 'Yes';
                    }
                    else{
                        a.UHG_Restriction__c	 = 'No';
                    }
                    //US2367595-Code End By Chandan
                    update a;
                    List<AccountContactRelation> accountContactList = new List<AccountContactRelation>();
                    List<Id> conId = new List<Id>();
                    List<Account> personAccount = new List<Account>();
                    Map<String,Account> personAccountInsertMap = new Map<String,Account>();
                    Map<String,Account> personAccountInsertDOBMap = new Map<String,Account>();
                    List<Account> personAccountList = new List<Account>();
                    List<Account> personAccountUpdate = new List<Account>();
                    Account personAccountRecordInsert = new Account();
                    Account personAccountRecord = new Account();
                    Boolean newRelationval = true ;
                    Map<String,AccountContactRelation> acrRelationVal =  new Map<String,AccountContactRelation>();
                    List<AccountContactRelation> insertAcrList = new List<AccountContactRelation>();
                     List<AccountContactRelation> updateAcrList = new List<AccountContactRelation>();
                    String relationVal ;
                    Date personBirthdate ;
                    if(houseDataTempUpdate.dob!=null)
                        personBirthdate = date.valueOf(ACETUtility.formatDateFutureDate(houseDataTempUpdate.dob));
                    if(!String.isEmpty(houseDataTempUpdate.firstName) && !String.isEmpty(houseDataTempUpdate.lastName)
                       && !String.isEmpty(houseDataTempUpdate.relationship) && personBirthdate!=null)
                    {
                        accountContactList = [Select ContactId,accountId,Relationship__c from AccountContactRelation where accountId =:acc[0].Id];
                        for(AccountContactRelation i:accountContactList){
                            conId.add(i.ContactId);
                            acrRelationVal.put(i.ContactId,i);
                        }
                        System.debug('service relationship='+houseDataTempUpdate.relationship);
                        //Get the ACET Relationship Mapping from the ACETServiceRelationshipMap__c
                        for(String s:relationshipMetaData.keyset()){
                            if( s != null && s.equalsIgnoreCase(houseDataTempUpdate.relationship)){
                                newRelationval = false;
                                houseDataTempUpdate.relationship = relationshipMetaData.get(s);
                                newServiceRelation.add(houseDataTempUpdate.relationship);
                            }
                        }
                        //If a new value is received in relationship then insert into the ACETServiceRelationshipMap__c Object
                        //And The ACET value will be Unknown
                        if(newRelationval){
                            ACETUtility.insertHouseholdRelationshipData(newServiceRelation);
                            houseDataTempUpdate.relationship = 'Unknown';
                        }
                        personAccount = [Select Id,PersonContactId, FirstName, LastName, PersonBirthdate from account where PersonContactId IN :conId];
                        if(personAccount.size() > 0){
                            for(Account acnt: personAccount){
                                String rel=acrRelationVal.get(acnt.PersonContactId)!=null?acrRelationVal.get(acnt.PersonContactId).Relationship__c:'';
                                if(String.isNotBlank(rel)){
                                    personAccountInsertMap.put(acnt.FirstName+acnt.LastName+rel,acnt);
                                }
                                if(acnt.PersonBirthdate!=null)
                                    personAccountInsertDOBMap.put(acnt.FirstName+acnt.LastName+acnt.PersonBirthdate,acnt);
                            }
                            System.debug('houseDataTempUpdate.relationship='+houseDataTempUpdate.relationship);
                            System.debug('personBirthdate='+personBirthdate);
                            system.debug(personAccountInsertMap.get(houseDataTempUpdate.firstName+houseDataTempUpdate.lastName+houseDataTempUpdate.relationship));
                            if(personAccountInsertMap.get(houseDataTempUpdate.firstName+houseDataTempUpdate.lastName+houseDataTempUpdate.relationship) == null){
                               system.debug('From personAccountInsertDOBMap'+personAccountInsertDOBMap.get(houseDataTempUpdate.firstName+houseDataTempUpdate.lastName+personBirthdate));

                                if(personAccountInsertDOBMap.get(houseDataTempUpdate.firstName+houseDataTempUpdate.lastName+personBirthdate)==null){
                                    personAccountRecordInsert.PersonBirthdate = personBirthdate;
                                    personAccountRecordInsert.firstName = houseDataTempUpdate.firstName;
                                    personAccountRecordInsert.lastName = houseDataTempUpdate.lastName;
                                    //personAccountRecordInsert.OwnerId = advisor[0].Id;
                                    personAccountRecordInsert.RecordTypeId = personAccRecordTypeId;
                                    //personAccountRecordInsert.Relationship__pc =houseDataTempUpdate.relationship; commentd as part of design chage priyanka
                                    //relationVal = houseDataTempUpdate.relationship;

                                    AccountContactRelation accConRelation = new AccountContactRelation();
                                    accConRelation.AccountId = a.Id;
                                    accConRelation.Relationship__c =houseDataTempUpdate.relationship;
                                    accConRelation.Member_ID__c =houseDataTempUpdate.memberId;
                                    accConRelation.Policy_ID__c = houseDataTempUpdate.policyId;
                                    insertAcrList.add(accConRelation);

                                    /*for(String s:relationshipStatus){
                                    if(s.contains(houseDataTempUpdate.relationship)){
                                    personAccountRecordInsert.Relationship__pc = s;
                                    }
                                    }*/
                                    personAccountList.add(personAccountRecordInsert);
                                }
                                else{
                                    system.debug('Else From personAccountInsertDOBMap'+personAccountInsertDOBMap.get(houseDataTempUpdate.firstName+houseDataTempUpdate.lastName+personBirthdate));
                                    personAccountRecord.Id = personAccountInsertDOBMap.get(houseDataTempUpdate.firstName+houseDataTempUpdate.lastName+PersonBirthdate).Id;
                                    personAccountRecord.PersonBirthdate =personBirthdate;
                                    personAccountRecord.firstName = houseDataTempUpdate.firstName; //updated for the name change personAccountInsertMap.get(houseDataTempUpdate.firstName+houseDataTempUpdate.lastName).firstName;
                                    personAccountRecord.lastName = houseDataTempUpdate.lastName; //updated for the name change personAccountInsertMap.get(houseDataTempUpdate.firstName+houseDataTempUpdate.lastName).lastName;
                                    //personAccountRecord.OwnerId = advisor[0].Id;
                                   // relationVal = houseDataTempUpdate.relationship;
                                    AccountContactRelation personRelation = acrRelationVal.get(personAccountInsertDOBMap.get(houseDataTempUpdate.firstName+houseDataTempUpdate.lastName+PersonBirthdate).PersonContactId);
                                    personRelation.Relationship__c = houseDataTempUpdate.relationship ;
                                    updateAcrList.add(personRelation);
                                    System.debug('relationVal=='+relationVal);
                                    personAccountUpdate.add(personAccountRecord);

                                }
                            }else{
                                personAccountRecord.Id = personAccountInsertMap.get(houseDataTempUpdate.firstName+houseDataTempUpdate.lastName+houseDataTempUpdate.relationship).Id;
                                personAccountRecord.PersonBirthdate = date.valueOf(ACETUtility.formatDateFutureDate(dob));
                                personAccountRecord.firstName = houseDataTempUpdate.firstName; //updated for the name change personAccountInsertMap.get(houseDataTempUpdate.firstName+houseDataTempUpdate.lastName).firstName;
                                personAccountRecord.lastName = houseDataTempUpdate.lastName; //updated for the name change personAccountInsertMap.get(houseDataTempUpdate.firstName+houseDataTempUpdate.lastName).lastName;
                                //personAccountRecord.OwnerId = advisor[0].Id;
                               // relationVal = houseDataTempUpdate.relationship;
                                AccountContactRelation personRelation = acrRelationVal.get(personAccountInsertDOBMap.get(houseDataTempUpdate.firstName+houseDataTempUpdate.lastName+PersonBirthdate).PersonContactId);
                                personRelation.Relationship__c = houseDataTempUpdate.relationship ;
                                updateAcrList.add(personRelation);
                                personAccountUpdate.add(personAccountRecord);
                            }
                        }
                        else if(personAccount.size() == 0){
                            if(!String.isEmpty(houseDataTempUpdate.firstName) && !String.isEmpty(houseDataTempUpdate.lastName) && !String.isEmpty(houseDataTempUpdate.relationship) && houseDataTempUpdate.isMainMember){
                                personAccountRecordInsert.PersonBirthdate = date.valueOf(ACETUtility.formatDateFutureDate(dob));
                                personAccountRecordInsert.firstName = houseDataTempUpdate.firstName;
                                personAccountRecordInsert.lastName = houseDataTempUpdate.lastName;
                                //personAccountRecordInsert.OwnerId = advisor[0].Id;
                                personAccountRecordInsert.RecordTypeId=personAccRecordTypeId;

                                AccountContactRelation accConRelation = new AccountContactRelation();
                                accConRelation.AccountId = a.Id;
                                accConRelation.Relationship__c =houseDataTempUpdate.relationship;
                                accConRelation.Member_ID__c =houseDataTempUpdate.memberId;
                                accConRelation.Policy_ID__c = houseDataTempUpdate.policyId;
                                insertAcrList.add(accConRelation);
                                personAccountList.add(personAccountRecordInsert);
                            }
                        }
                    }
                    system.debug('personAccountUpdateMap....'+personAccountUpdate);
                    system.debug('personAccountList....'+personAccountList);
                    if(personAccountList.size() > 0){
                        insert personAccountList;
                        system.debug('======='+insertAcrList);
                        if(insertAcrList.size() >0){
                        String conId1 = [select PersonContactId from account where Id =:personAccountList[0].Id].PersonContactId;
                        insertAcrList[0].ContactId = conId1;
                        insert insertAcrList;
                        accountId = a.Id+'@'+conId1;
                        }
                    }
                    if(personAccountUpdate.size() > 0){
                        system.debug('personAccountUpdate....'+personAccountUpdate);
                        update personAccountUpdate;
                        system.debug('updateAcrList....'+updateAcrList);
                        if(updateAcrList.size() > 0){
                        update updateAcrList;
                        }
                        accountId = a.Id+'@'+personAccountUpdate[0].Id;
                    }
                }
            }
        }

        return accountId;
    }
    @AuraEnabled
    public static boolean isCommunity(){
        Id siteId = Site.getSiteId(); // take a look at the apex class Site, you may find more useful method concerning site/community
        system.debug('siteId....'+siteId);
        if (siteId != null) {
            return true;
        }
        return false;
    }
}