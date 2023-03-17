@isTest
public class AccountContactHandlerTest {
    @isTest 
    static void AccountContactHandlerTest() 
    {
        Id recordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Family').getRecordTypeId();
        Account ac = new Account();
        ac.Member_ID__c = '453543543';
        ac.Policy_ID__c = '0070145';
        ac.Name =   'SampleTEstFLAcc1';
        ac.RecordTypeId = recordTypeId;
        insert ac;
        
        Id personAccRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Individual').getRecordTypeId();
        Account pa =new account();
        pa.PersonBirthdate = date.valueOf(ACETUtility.formatDateFutureDate('6/17/1979'));
        pa.firstName = 'paLastSample1'; 
        pa.lastName = 'paFirstSample1'; 
        pa.RecordTypeId = personAccRecordTypeId;
        insert pa;
        
        Account pa1 =new account();
        pa1.PersonBirthdate = date.valueOf(ACETUtility.formatDateFutureDate('6/17/1979'));
        pa1.firstName = 'paLastSample1'; 
        pa1.lastName = 'paFirstSample1'; 
        pa1.RecordTypeId = personAccRecordTypeId;
        insert pa1;
        
        account pa2 = [select id,personcontactid from account where id =: pa.id];
        List<AccountContactRelation> acrList = new List<AccountContactRelation>();
        map<id, AccountContactRelation> triggerOldMap = new map<id, AccountContactRelation>();
        AccountContactRelation acr = new AccountContactRelation();
        acr.ContactId = pa2.personcontactid;            
        acr.Accountid = ac.id;
        acr.Relationship__c = 'Child/Other';
        acr.Complex_Indicator__c = 'Referral';
        insert acr;
        acrList.add(acr);
        triggerOldMap.put(acr.id,acr);
        
        contact cont = [select Id from contact where accountId =: pa.Id];
        Id ecmRecordTypeID = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Case Overview').getRecordTypeId();
        Case ecmCas = TestDataFactory.createCases(1)[0];
        ecmCas.RecordTypeId =ecmRecordTypeID;
        ecmCas.AccountId = ac.Id;
        ecmCas.ContactId = cont.Id;
        Insert ecmCas;
        
        contact cont1 = [select Id from contact where accountId =: pa1.Id];
        Case ecmCas1 = TestDataFactory.createCases(1)[0];
        ecmCas1.RecordTypeId =ecmRecordTypeID;
        ecmCas1.AccountId = ac.Id;
        ecmCas1.ContactId = cont1.Id;
        Insert ecmCas1;
        
        Map<String,String> caseteamr = new Map<String,String>{};
            for(CaseTeamRole ct:[Select name,id from caseTeamRole]){
                caseteamr.put(ct.Name, ct.Id);
            }
        CaseTeamMember ctmAdvisor = new CaseTeamMember(
            ParentId = ecmCas.id,
            MemberId = ecmCas.contactid,
            TeamRoleId = caseteamr.get('Advisor')
        );
        insert ctmAdvisor;
        CaseTeamMember ctmPrimaryCareGiver = new CaseTeamMember(
            ParentId = ecmCas.id,
            MemberId = ecmCas1.contactid,
            TeamRoleId = caseteamr.get('Family Member')
        );
        insert ctmPrimaryCareGiver;
        List<SNI_FL_Care_Team_Member__c> careteamMemList = new List<SNI_FL_Care_Team_Member__c>();
        SNI_FL_Care_Team_Member__c careteamMem = new SNI_FL_Care_Team_Member__c();
        careteamMem.SNI_FL_Member__c = ac.id;
        careteamMem.SNI_FL_Not_Visible_in_Familylink__c = false;
        careteamMem.SNI_FL_Family__c = ac.Id; 
        careteamMem.SNI_FL_Primary_Caregiver__c = true;
        careteamMemList.add(careteamMem);
        
        SNI_FL_Care_Team_Member__c careteamMem1 = new SNI_FL_Care_Team_Member__c();
        careteamMem1.SNI_FL_Member__c = ac.id;
        careteamMem1.SNI_FL_Not_Visible_in_Familylink__c = false;
        careteamMem1.SNI_FL_Family__c = ac.Id; 
        careteamMem1.SNI_FL_Primary_Caregiver__c = true; 
        careteamMemList.add(careteamMem1);
        insert careteamMemList;
        
        system.debug('careteamMem'+careteamMem.SNI_FL_Family__c);
        system.debug('careteamMem1'+careteamMem.id);
                
        update acr;
         Map<Id, AccountContactRelation> newMap = new Map<Id, AccountContactRelation>();
        newMap.put(acr.id,acr);
        AccountContactHandler.createCareteam(acrList,newMap);
        AccountContactHandler.acrAfterInsert(newMap);
        AccountContactHandler.handleAfterDelete(acrList,triggerOldMap);
        delete acr;
        AccountContactHandler.acrAfterInsert(newMap);         
    }
    @istest public static void testmethod4(){
        UserRole portalRole = [Select Id From UserRole Where PortalType = 'None' Limit 1];
        Profile profile1 = [Select Id from Profile where name = 'System Administrator'];
        User portalAccountOwner1 = new User(
            UserRoleId = portalRole.Id,
            ProfileId = profile1.Id,
            Username = System.now().millisecond() + 'zzznpz1@optum.com.acet',
            Alias = 'batman',
            Email='zzznpz1234@optum.com.acet',
            EmailEncodingKey='UTF-8',
            Firstname='yarroa',
            Lastname='yavanoa',
            LanguageLocaleKey='en_US',
            LocaleSidKey='en_US',
            TimeZoneSidKey='America/Chicago');
        Database.insert(portalAccountOwner1);
        System.runAs ( portalAccountOwner1 ) {
            Id provGroupRTId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Provider Group').getRecordTypeId();
            Id provUserRTId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Provider User').getRecordTypeId();
            Account ac = new Account();
            ac.Name = 'ProviderGroupyarroa';
            ac.RecordTypeId = provGroupRTId;
            insert ac;
            Account provUser = new Account(
                Salutation = 'Mr.',
                FirstName = 'Providera',
                LastName = 'yarroa',
                PersonEmail = 'yarroyevanoa@optum.com.acet',
                Provider_Group__c = ac.Id,
                RecordTypeId = provUserRTId
            );
            insert provUser;
            Account provUser1 = new Account(
                Salutation = 'Mr.',
                FirstName = 'Providerb',
                LastName = 'yarrob',
                PersonEmail = 'yarroyevanob@optum.com.acet',
                Provider_Group__c = ac.Id,
                RecordTypeId = provUserRTId
            );
            insert provUser1;
            Id provAffRTId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Provider Affiliation').getRecordTypeId();
            Account acff = new Account(); 
            acff.Name = 'ProviderAffyarroa';
            acff.RecordTypeId = provAffRTId;
            insert acff;
            Contact c = [SELECT Id FROM Contact WHERE AccountId =: provUser.Id];
            Program__c pgm = new Program__c();
            pgm.Program__c = 'Complex Care';
            insert pgm;
            List<Member_Affiliation__c> memberAffilList = new List<Member_Affiliation__c>();
            for (Integer i = 0; i < 5; i++) {
                Member_Affiliation__c mAffil = new Member_Affiliation__c();
                mAffil.Provider__c = provUser.Id;
                mAffil.Population__c = 'Adult';
                mAffil.Program__c = pgm.Id;
                mAffil.Provider_Affiliation__c = acff.Id;
                mAffil.Email__c='yarroyevanoa' + i + '@optum.com.acet';
                mAffil.Enrollment_Date__c = system.today();
                mAffil.Date_Of_Birth__c = System.today();
                mAffil.Member__c=ac.Id;
                mAffil.Status__c=true;    
                memberAffilList.add(mAffil);
            }
            for (Integer i = 0; i < 5; i++) {
                Member_Affiliation__c mAffil = new Member_Affiliation__c();
                mAffil.Provider__c = provUser1.Id;
                mAffil.Population__c = 'Adult';
                mAffil.Program__c = pgm.Id;
                mAffil.Provider_Affiliation__c = acff.Id;
                mAffil.Email__c='yarroyevanob' + i + '@optum.com.acet';
                mAffil.Enrollment_Date__c = system.today();
                mAffil.Date_Of_Birth__c = System.today();
                mAffil.Member__c=ac.Id;
                mAffil.Status__c=true;    
                memberAffilList.add(mAffil);
            }
            insert memberAffilList;
            test.starttest();
            User user = new User();
            user.ProfileID = [Select Id From Profile Where Name='Care Advisor Connect Provider User'].id;
            user.EmailEncodingKey = 'ISO-8859-1';
            user.LanguageLocaleKey = 'en_US';
            user.TimeZoneSidKey = 'America/New_York';
            user.LocaleSidKey = 'en_US';
            user.FirstName = 'yarroa';
            user.LastName = 'yevvanohea';
            user.Username = 'ABCD1234rrr@optum.com.acet';
            user.CommunityNickname = 'testUser123rrr';
            user.Alias = 't12';
            user.Email = 'noyarro@optum.com.acet';
            user.IsActive = true;
            user.ContactId = c.Id;
            insert user;
            Contact c1 = [SELECT Id FROM Contact WHERE AccountId =: provUser1.Id];
            User user1 = new User();
            user1.ProfileID = [Select Id From Profile Where Name='Care Advisor Connect Provider User'].id;
            user1.EmailEncodingKey = 'ISO-8859-1';
            user1.LanguageLocaleKey = 'en_US';
            user1.TimeZoneSidKey = 'America/New_York';
            user1.LocaleSidKey = 'en_US';
            user1.FirstName = 'yarrob';
            user1.LastName = 'yevvanoheb';
            user1.Username = 'ABCD1234rrrb@optum.com.acet';
            user1.CommunityNickname = 'testUser123rrrb';
            user1.Alias = 't12b';
            user1.Email = 'noyarrob@optum.com.acet';
            user1.IsActive = true;
            user1.ContactId = c1.Id;
            insert user1;
            list<Member_Affiliation__share> mshrlist = new list<Member_Affiliation__share>();
            Member_Affiliation__share msr = new Member_Affiliation__share();
            msr.ParentId = memberAffilList[0].id;
            msr.UserOrGroupId = user.id;
            msr.AccessLevel = 'Read';
            msr.RowCause = Schema.Member_Affiliation__Share.RowCause.Manual;
            mshrlist.add(msr);
            Member_Affiliation__share msr1 = new Member_Affiliation__share();
            msr1.ParentId = memberAffilList[0].id;
            msr1.UserOrGroupId = user1.id;
            msr1.AccessLevel = 'Read';
            msr1.RowCause = Schema.Member_Affiliation__Share.RowCause.Manual;
            mshrlist.add(msr1);
            Member_Affiliation__share msr2 = new Member_Affiliation__share();
            msr2.ParentId = memberAffilList[1].id;
            msr2.UserOrGroupId = user.id;
            msr2.AccessLevel = 'Read';
            msr2.RowCause = Schema.Member_Affiliation__Share.RowCause.Manual;
            mshrlist.add(msr2);
            insert mshrlist;
            list<AccountContactRelation> acrlist = new list<AccountContactRelation>();
            AccountContactRelation acrPPA = new AccountContactRelation();
            acrPPA.AccountId = acff.id;
            acrPPA.ContactId = c.id;
            acrPPA.Relationship__c = 'Provider User';
            AccountContactRelation acrPPAb = new AccountContactRelation();
            acrPPAb.AccountId = acff.id;
            acrPPAb.ContactId = c1.id;
            acrPPAb.Relationship__c = 'Provider User';
            acrlist.add(acrPPA);
            acrlist.add(acrPPAb);
            insert acrlist;
            map<id, AccountContactRelation> triggerNewMap = new map<id, AccountContactRelation>();
            triggerNewMap.put(acrlist[0].id,acrlist[0]);
            /*SNI_FL_Care_Team_Member__c careteamMem = new SNI_FL_Care_Team_Member__c(SNI_FL_Family__c = acff.id); 
            insert careteamMem;*/
            
            
            //AccountContactHandler.createCareteam(acrlist,triggerNewMap);
            test.stoptest();
            //system.assertEquals(20, [select count() from Member_Affiliation__share where UserOrGroupId in(:user.Id,:user1.Id)]);
        }
    }
    @isTest 
    static void AccountContactHandlerTest1() 
    {
        
        Id recordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Family').getRecordTypeId();
        Account ac = new Account();
        ac.Member_ID__c = '453543543';
        ac.Policy_ID__c = '0070145';
        ac.Name =   'SampleTEstFLAcc1';
        ac.RecordTypeId = recordTypeId;
        insert ac;
        
        Account ac1 = new Account();
        ac1.Member_ID__c = '453543543';
        ac1.Policy_ID__c = '0070145';
        ac1.Name =   'SampleTEstFLAcc1';
        ac1.RecordTypeId = recordTypeId;
        insert ac1;
        
        Id personAccRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Individual').getRecordTypeId();
        Account pa =new account();
        pa.PersonBirthdate = date.valueOf(ACETUtility.formatDateFutureDate('6/17/1979'));
        pa.firstName = 'paLastSample1'; 
        pa.lastName = 'paFirstSample1'; 
        pa.RecordTypeId = personAccRecordTypeId;
        insert pa;
        
        Account pa1 =new account();
        pa1.PersonBirthdate = date.valueOf(ACETUtility.formatDateFutureDate('6/17/1979'));
        pa1.firstName = 'paLastSample1'; 
        pa1.lastName = 'paFirstSample1'; 
        pa1.RecordTypeId = personAccRecordTypeId;
        insert pa1;
        
        account pa2 = [select id,personcontactid from account where id =: pa.id];
        
        Account pa3 =new account();
        pa3.PersonBirthdate = date.valueOf(ACETUtility.formatDateFutureDate('6/17/1979'));
        pa3.firstName = 'paLastSample111'; 
        pa3.lastName = 'paFirstSample122'; 
        pa3.RecordTypeId = personAccRecordTypeId;
        insert pa3;
        
        Account pa4 =new account();
        pa4.PersonBirthdate = date.valueOf(ACETUtility.formatDateFutureDate('6/17/1979'));
        pa4.firstName = 'paLastSample111'; 
        pa4.lastName = 'paFirstSample122'; 
        pa4.RecordTypeId = personAccRecordTypeId;
        insert pa4;
        
        account pa5 = [select id,personcontactid from account where id =: pa3.id];
        account pa6 = [select id,personcontactid from account where id =: pa4.id];
        system.debug('pa5'+pa5.personcontactid);
        system.debug('pa6'+pa6.personcontactid);
        
        List<AccountContactRelation> acrList = new List<AccountContactRelation>();
        map<id, AccountContactRelation> triggerOldMap = new map<id, AccountContactRelation>();
        AccountContactRelation acr = new AccountContactRelation();
        acr.ContactId = pa2.personcontactid;            
        acr.Accountid = ac.id;
        acr.Relationship__c = 'Child/Other';
        test.startTest();
        insert acr;
        acrList.add(acr);
        triggerOldMap.put(acr.id,acr);
        
        AccountContactRelation acr1 = new AccountContactRelation();
        acr1.ContactId = pa5.personcontactid;            
        acr1.Accountid = ac1.id;
        acr1.Relationship__c = 'Child/Other';
        insert acr1;
        acrList.add(acr1);
        //insert acrList;
        
        AccountContactRelation acr2 = new AccountContactRelation();
        acr2.ContactId = pa5.personcontactid;            
        acr2.Accountid = ac.id;
        acr2.Relationship__c = 'Child/Other';
        insert acr2;
        acrList.add(acr2);
        //insert acrList;
        
        contact cont = [select Id from contact where accountId =: pa.Id];
        Id ecmRecordTypeID = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Case Overview').getRecordTypeId();
        Case ecmCas = TestDataFactory.createCases(1)[0];
        ecmCas.RecordTypeId =ecmRecordTypeID;
        ecmCas.AccountId = ac.Id;
        ecmCas.ContactId = cont.Id;
        Insert ecmCas;
        
        contact cont1 = [select Id from contact where accountId =: pa1.Id];
        Case ecmCas1 = TestDataFactory.createCases(1)[0];
        ecmCas1.RecordTypeId =ecmRecordTypeID;
        ecmCas1.AccountId = ac.Id;
        ecmCas1.ContactId = cont1.Id;
        Insert ecmCas1;
        
        Map<String,String> caseteamr = new Map<String,String>{};
            for(CaseTeamRole ct:[Select name,id from caseTeamRole]){
                caseteamr.put(ct.Name, ct.Id);
            }
        CaseTeamMember ctmAdvisor = new CaseTeamMember(
            ParentId = ecmCas.id,
            MemberId = ecmCas.contactid,
            TeamRoleId = caseteamr.get('Advisor')
        );
        insert ctmAdvisor;
        CaseTeamMember ctmPrimaryCareGiver = new CaseTeamMember(
            ParentId = ecmCas.id,
            MemberId = ecmCas1.contactid,
            TeamRoleId = caseteamr.get('Family Member')
        );
        insert ctmPrimaryCareGiver;
        List<SNI_FL_Care_Team_Member__c> careteamMemList = new List<SNI_FL_Care_Team_Member__c>();
        SNI_FL_Care_Team_Member__c careteamMem = new SNI_FL_Care_Team_Member__c();
        careteamMem.SNI_FL_Member__c = ac.id;
        careteamMem.SNI_FL_Not_Visible_in_Familylink__c = false;
        careteamMem.SNI_FL_Family__c = ac.Id; 
        careteamMem.SNI_FL_Primary_Caregiver__c = true;
        careteamMemList.add(careteamMem);
        
        SNI_FL_Care_Team_Member__c careteamMem1 = new SNI_FL_Care_Team_Member__c();
        careteamMem1.SNI_FL_Member__c = ac.id;
        careteamMem1.SNI_FL_Not_Visible_in_Familylink__c = false;
        careteamMem1.SNI_FL_Family__c = ac.Id; 
        careteamMem1.SNI_FL_Primary_Caregiver__c = true; 
        careteamMemList.add(careteamMem1);
        insert careteamMemList;
        
        system.debug('careteamMem'+careteamMem.SNI_FL_Family__c);
        system.debug('careteamMem1'+careteamMem.id);
                
        //update acr;
         Map<Id, AccountContactRelation> newMap = new Map<Id, AccountContactRelation>();
        newMap.put(acr.id,acr);
        
            AccountContactHandler.createCareteam(acrList,newMap);
        test.stopTest();        
    }
}