@isTest
public class ACETAccountTriggerHandlerTest {
    static testMethod void ACETAccountTriggerHandlerTestMethod1(){
        Test.startTest();
        RecordType myRecordType = [select id from RecordType where SobjectType='Account' AND IsPersonType=True limit 1];
        
        Account acc = new Account(
            FirstName='test',
            LastName='Acc',
            PersonEmail='' ,
            Recordtypeid=myRecordType.Id);
        insert acc;
        
        // create Contact
        
        Contact objContact = [Select id, FirstName, LastName from Contact where AccountId=:acc.Id];
        // Setup test data
        // This code runs as the system user
        
        UserRole ur=[select id,name from userrole where name='ACET Front Office' limit 1];
        Profile p = [SELECT Id FROM Profile WHERE Name = 'Care Advisor Connect Community User' LIMIT 1];
        User usr = new User(
            LastName = 'testP',
            FirstName='testP',
            Alias = 'tp',
            Email = 'abc@optum.com',
            Username = 'abc@optum.com',
            profileId=p.Id,
            TimeZoneSidKey = 'GMT',
            LanguageLocaleKey = 'en_US',
            EmailEncodingKey = 'UTF-8',
            LocaleSidKey = 'en_US',
            Agent_Type__c='Offshore',
            ContactId = objContact.Id,
            UserRole=ur
            
        );
        System.runAs ( new User(Id = UserInfo.getUserId()) ) {
            insert usr; }
        
        acc.PersonEmail='er@abc.com';
        update acc;
        Id personAccRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Individual').getRecordTypeId();
        
        List<Account> accList=new List<Account>();
        Account pa =new account();
        pa.PersonBirthdate = date.valueOf(ACETUtility.formatDateFutureDate('6/17/1979'));
        pa.firstName = 'Community';
        pa.lastName = 'FLViewAuthTestUser';
        pa.RecordTypeId = personAccRecordTypeId;
        accList.add(pa);
        
        insert accList;
        SNI_FL_Care_Team_Member__c careTeam = new SNI_FL_Care_Team_Member__c();
        careTeam.SNI_FL_Member__c = accList[0].id;
        careTeam.SNI_FL_Not_Visible_in_Familylink__c = false;
        careTeam.SNI_FL_Family__c = acc.Id;
        insert careTeam;
        List<Contact> conId = [SELECT id from contact where accountId =: accList[0].Id];
        AccountContactRelation accConRelation = new AccountContactRelation();
        accConRelation.AccountId = acc.Id;
        accConRelation.ContactId = conId[0].Id;
        insert accConRelation;
        pa.FamilyLink_Registration_Date__c = Date.newInstance(2020, 03, 08);
        Map<Id,Account> mapAccount = new Map<Id,Account>([Select id,FamilyLink_Registration_Date__c from Account Where id =: accList[0].Id]);
        update accList[0];
        ACETAccountTriggerHandler.createCareTeamMembersDuplicate(accList, mapAccount);
        
       /*  Map<Id,AccountContactRelation> acrMap = new Map<Id,AccountContactRelation>();
        List<AccountContactRelation> acrLst = [SELECT Id,
                                               Complex_Indicator_Text__c,
                                               account.Complex_Indicator__c,
                                               Complex_Indicator__c,
                                               Contact.AccountId 
                                               FROM AccountContactRelation 
                                               WHERE Contact.AccountId IN:accIds];
        ACETAccountTriggerHandler.updateComplexIndicator(accList, acrLst); */
        
        Test.stopTest();
    }
    
    @istest static void accOwnerchecktest(){
         Id farmrec = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Family').getRecordTypeId();
        Id proTmsRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Provider Team').getRecordTypeId();
        map<id,Account> accnewmap= new map<id,Account>();
        map<id,Account> accoldmap= new map<id,Account>();
        map<id,Account> accnewmap1= new map<id,Account>();
        map<id,Account> accoldmap1= new map<id,Account>();
        set<id> uidset= new set<id>();
       // uidset.add(userinfo.getUserId());
        User thisUser = [Select Id,profileId From User Where Id =:UserInfo.getUserId()];
        System.runAs(thisUser){
            userrole r = new userrole(developername = 'testRole',Name = 'Test FEC - Supervisor');
            user u = new User(Alias = 'standt', Email='fltest@testorg.com', 
                              EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
                              LocaleSidKey='en_US', ProfileId = thisUser.profileId,userroleId = r.Id,
                              TimeZoneSidKey='America/Los_Angeles',MobilePhone='8876543456', UserName='fltest@testorg.com',IsActive=true);
            insert u;
        
       // User us = [Select id from user where isActive =true and Profile.Name='System Administrator' and Id NOT IN :uidset LIMIT 1];
        Account ac = new Account();
        ac.Name =   'ProviderGroup23';
        ac.RecordTypeId = farmrec;
        ac.OwnerId=thisUser.id;
        insert ac;
            
            Id personAccRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Individual').getRecordTypeId();
            Account pa =new account();
            pa.PersonBirthdate = date.valueOf(ACETUtility.formatDateFutureDate('6/17/1979'));
            pa.firstName = 'Community';
            pa.lastName = 'FLViewAuthTestUser';
            pa.RecordTypeId = personAccRecordTypeId;
           // accList.add(pa);
            insert pa;
        accoldmap1.put(pa.id,pa);
       
        accoldmap.put(ac.id,ac);
            account ac2= [select id,OwnerId,recordTypeId,UHG_Restriction__c from account where Id=:ac.Id];
		ac2.OwnerId= u.id;
        update ac2;
        accnewmap.put(ac2.id,ac2);
            Test.starttest();
            
            contact c= new contact(Lastname='eee');
            insert c;
            
            SNI_FL_Care_Team_Member__c careTeam = new SNI_FL_Care_Team_Member__c();
            careTeam.SNI_FL_Member__c = pa.id;
            careTeam.SNI_FL_Not_Visible_in_Familylink__c = false;
            careTeam.SNI_FL_Family__c = pa.Id;
            insert careTeam;
            List<Contact> conId = [SELECT id from contact where accountId =: pa.Id];
            AccountContactRelation accConRelation = new AccountContactRelation();
            accConRelation.AccountId = ac2.Id;
            accConRelation.ContactId = conId[0].Id;
            insert accConRelation;
            
            /*AccountContactRelation acr2 = accConRelation.clone(false,false,false,false);
            acr2.AccountId=pa.Id;
            acr2.ContactId = c.Id;
            insert acr2;*/
       // system.assertEquals(ac.OwnerId, ac2.OwnerId);
        ACETAccountTriggerHandler.changeOwnerValidation(accnewmap,accoldmap);
            ACETAccountTriggerHandler.executeBatch(accnewmap,accoldmap);
            try{
                Account ac3 = new Account();
                ac3.Name =   'ProviderGroup23';
                ac3.RecordTypeId = proTmsRecordTypeId;                
                insert ac3;
                
                ACETAccountTriggerHandler act= new ACETAccountTriggerHandler(accnewmap,accnewmap);
                act.DuplicateNameCheckname(new list<Account>{ac3});
                                
                
            }catch (exception e){}
            account Pac1= [select id,OwnerId,recordTypeId,UHG_Restriction__c,FamilyLink_Registration_Date__c from account where Id=:pa.Id];
           Pac1.FamilyLink_Registration_Date__c=Date.Today();
            update Pac1;
            accnewmap1.put(Pac1.id,Pac1);
            ACETAccountTriggerHandler.createCareTeamList(accnewmap1,accoldmap1);
            Test.stopTest();
        }
    }
    @istest static void dupicateNameChecktest(){
        Id progrouprecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Provider Group').getRecordTypeId();
        Id proAffrecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Provider Affiliation').getRecordTypeId();
        Id proTeamrecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Provider Team').getRecordTypeId();
        Id proUserrecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Provider User').getRecordTypeId();
        
       
        List<Account> accList=new List<Account>();
        Account ac = new Account();
        ac.Name =   'ProviderGroup';
        ac.RecordTypeId = progrouprecordTypeId;
        accList.add(ac);
        Account acff = new Account();
        acff.Name =   'ProviderAffiliation';
        acff.RecordTypeId = proAffrecordTypeId;
        accList.add(acff);
        insert accList;
        
        
        List<program__c> programList=new List<program__c>();
        Program__c pgm = new Program__c();
        pgm.Program__c = 'Complex Care';
        programList.add(pgm);
        insert programList;
        
        
        ACETAccountTriggerHandler acctTrigger = new ACETAccountTriggerHandler(null,null);
        acctTrigger.DuplicateNameCheckname(accList);
        
        
    }
    @isTest
    Public static void testChangeOwnerValidation(){
        
        Id recordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Family').getRecordTypeId();
        List<Account> accList=new List<Account>();
        Account ac = new Account();
        ac.Member_ID__c = '123543987';
        ac.Policy_ID__c = '1230987';
        ac.Name = 'FLTestAcc123';
        ac.RecordTypeId = recordTypeId;
        Insert ac;
        Id personAccRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Individual').getRecordTypeId();
        Account pa =new account();
        pa.PersonBirthdate = date.valueOf(ACETUtility.formatDateFutureDate('6/17/1979'));
        pa.firstName = 'Community';
        pa.lastName = 'FLViewAuthTestUser';
        pa.RecordTypeId = personAccRecordTypeId;
        accList.add(pa);
        insert accList;
        
        List<Contact> conId = [SELECT id from contact where accountId =: pa.Id];
        AccountContactRelation accConRelation = new AccountContactRelation();
        accConRelation.AccountId = ac.Id;
        accConRelation.ContactId = conId[0].Id;
        insert accConRelation;
        
        Family_Overview__c fo = new Family_Overview__c();
        fo.Name='test';
        fo.Account__c = ac.Id;
        insert fo;
        
        Member_Information__c mi = new Member_Information__c();
        mi.Name = 'test';
        mi.Account__c = pa.Id;
        insert mi;
        Test.startTest();
        Id ecmRecordTypeID = Schema.SObjectType.Case.getRecordTypeInfosByName().get('ECM').getRecordTypeId();
        Case ecmCas = TestDataFactory.createCases(1)[0];
        ecmCas.RecordTypeId =ecmRecordTypeID;
        ecmCas.Topic__c = 'Appeals - Post Service';
        ecmCas.AccountId = pa.Id;
        ecmCas.ContactId = conId[0].Id;
        ecmCas.UHG_Restriction__c = 'No';
        ecmCas.DOB__c = '1999/08/09';
        //ecmCas.ID__c = '';
        ecmCas.Onshore_Restriction__c = 'No';
        ecmCas.Subject_Name__c = 'ECM Test case' ;
        ecmCas.Subject_Group_ID__c = '0915181';
        ecmCas.status='Open';
        insert ecmCas;
        List<task> tskLst = new List<Task>();
        Task t = new Task();
        t.OwnerId = userinfo.getuserId();
        t.WhatId = ecmCas.Id;
        t.subject = 'Email Response';
        tskLst.add(t);
        Task t1 = new Task();
        t1.OwnerId = userinfo.getuserId();
        t1.WhatId = mi.Id;
        t1.subject = 'Email Response';
        tskLst.add(t1);
        insert tskLst;
        List<Profile> pList = [SELECT Id,Name FROM Profile WHERE Name =: 'Care Advisor Connect Community User'];
        User thisUser = [Select Id,profileId From User Where Id =:UserInfo.getUserId()];
        System.runAs(thisUser){
            userrole r = new userrole(developername = 'testRole',Name = 'Test FEC - Supervisor');
            user u = new User(Alias = 'standt', Email='fltest@testorg.com', 
                              EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
                              LocaleSidKey='en_US', ProfileId = thisUser.profileId,userroleId = r.Id,
                              TimeZoneSidKey='America/Los_Angeles',MobilePhone='8876543456', UserName='fltest@testorg.com',IsActive=true);
            insert u;
            //User us = [Select id from user where isActive =true and userrole.name like  '%FEC - Supervisor%' LIMIT 1];
            system.runAs(u)
            {
                ac.OwnerId = u.Id;
                Update ac;
            }
            Test.stopTest();
        }
    }
    
    @isTest
    Public static void testChangeOwnerValidation2(){
        Id myRecordType = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Family').getRecordTypeId();
        Id unassignedUser = [select id from User where Name ='Unassigned'].Id;
        Account acc = new Account(
            Name = 'TestRat',
            PersonEmail='' ,
            OwnerId = unassignedUser,
            Recordtypeid=myRecordType);
        insert acc;
        
        Family_Overview__c fo = new Family_Overview__c();
        fo.Name='test';
        fo.Account__c = acc.Id;
        fo.Designation__c = 'Removed';
        insert fo;
        User thisUser = [Select Id,profileId From User Where Id =:UserInfo.getUserId()];
        System.runAs(thisUser){
            userrole r = new userrole(developername = 'testRole',Name = 'Test FEC - Supervisor');
            user u = new User(Alias = 'standt', Email='fltest@testorg.com', 
                              EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
                              LocaleSidKey='en_US', ProfileId = thisUser.profileId,userroleId = r.Id,
                              TimeZoneSidKey='America/Los_Angeles',MobilePhone='8876543456', UserName='fltest@testorg.com',IsActive=true);
            insert u;
            //User us = [Select id from user where isActive =true and userrole.name like  '%FEC - Supervisor%' LIMIT 1];
            
            Test.startTest();
            
            system.runAs(u)
            {
                acc.OwnerId = u.Id;
                try{
                    Update acc;
                }
                catch(Exception e){
                    System.assertEquals(true, e.getMessage().contains('Cannot change the Account Owner.'));
                }
            }
            Test.stopTest();
        }
    }
}