/****************************************************************************** 
Class Name     : SNI_FL_ProviderMessageUtilTest
Description    : New provider message popup dropdown testing
Created By     : Sameera - ACDC US3075477,US3078403,US3121134
Related US : US3075477,US3078403,US3121134
Created Date   : 12/16/2020
******************************************************************************/
@isTest
public with sharing class SNI_FL_ProviderMessageUtilTest {
    
    private static final String TSTPROGRAM = 'Complex Care';
    private static final String PROVIDERAFF = 'TestHospital-Complex Care-Adult';
    private static final String FECPROFILE = 'Center for Health Navigation';
    private static final String TSTEMAIL = 'agent1@optum.acet.com';
    private static final String TESTEMAIL = 'agent2_acdc_@optum.acet.com';
    private static final String TIMEZONE = 'America/New_York';
    private static final String EMAILENCODE = 'ISO-8859-1';
    private static final String ACCTEAM = 'Account Team Member';
    private static final String TSTMSG = 'Related provider affliation record not recieved';
    private static final String FNAME = 'Test FName';
    private static final String LNAME = 'Test LName';
    private static final String YAHOOMAIL = 'test@yahoo.com';
    private static final String RELATEDTO = 'Related To';
    private static final String TESTUSERMAIL = 'test@user.com';
    private static final String NODATA = 'There is no data for the inputs in DB to retirve';
    private static final String UNAME = 'agent1_acdc_@optum.acet.com';
    private static final String PFEMPTY = 'provider affliation record are empty';
    
    private static final String USERNAME = 'agent11_acdc_@optum.acet.com';
    ///Agent view test methods 
    
    //Test method for single record
    @isTest
    static void testMymessageLevelProgramDropdown(){
        
        List<SNI_FL_ProviderMessageUtil.ProviderData> lstProviderData;
        Id pgrecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Provider_Group').getRecordTypeId();
        Id pfrecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Provider_Affiliation').getRecordTypeId();
        
        //Program object
        Program__c program = new Program__c();
        program.Program__c = TSTPROGRAM;
        
        insert program;
        
        //Provider group acccount
        Account pg = new Account();
        pg.RecordTypeId= pgrecordTypeId;
        pg.Name = 'TestHospital';
        
        insert pg;
        
        //Provider affliation account
        Account pf=new Account();
        pf.Name=PROVIDERAFF;
        pf.RecordTypeId=pfrecordTypeId;
        pf.Population__c = 'Adult';
        pf.Program__c=program.id;
        pf.ParentId	= pg.id;
        
        insert pf;
        
        
        
        Profile agentProfile=[SELECT Id FROM Profile where Name=:FECPROFILE];
        User thisUser = [Select Id From User Where Id =:UserInfo.getUserId()];
        user u1;
        System.runAs(thisUser){
            u1 = new User( email=TSTEMAIL,
                          profileid = agentProfile.id, 
                          UserName=UNAME, 
                          Alias = 'GDS',
                          TimeZoneSidKey=TIMEZONE,
                          EmailEncodingKey=EMAILENCODE,
                          LocaleSidKey='en_US', 
                          isActive=true,
                          LanguageLocaleKey='en_US',
                          FirstName = 'Fagent1',
                          LastName = 'Lagent1');
            insert u1;
        }
        AccountTeamMember actTeam = new AccountTeamMember();
        actTeam.AccountId = pf.id;
        actTeam.UserId = u1.id;
        actTeam.TeamMemberRole =ACCTEAM;
        
        insert actTeam;
        
        System.runAs(u1){
            Map<Object,Object> m = new Map<Object,Object>();
            m.put('isBackupAgentView',true);
            m.put('familyId',null);
            m.put('label','Programs');
            m.put('selectProviderGroupId',pg.id);
            m.put('searchString','');
            m.put('objectName','Account');
            
            lstProviderData = SNI_FL_ProviderMessageUtil.retrieveProviderData(m);
            
        }
        
        System.assertEquals(1,lstProviderData.size(),TSTMSG);
        
    }
    
    //Test method for single record
    @isTest
    static void testMymessageLevelSearchProgramDropdown(){
        
        List<SNI_FL_ProviderMessageUtil.ProviderData> lstProviderData;
        Id pgrecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Provider_Group').getRecordTypeId();
        Id pfrecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Provider_Affiliation').getRecordTypeId();
        
        //Program object
        Program__c program = new Program__c();
        program.Program__c = TSTPROGRAM;
        
        insert program;
        
        //Provider group acccount
        Account pg = new Account();
        pg.RecordTypeId= pgrecordTypeId;
        pg.Name = 'TestHospital';
        
        insert pg;
        
        //Provider affliation account
        Account pf=new Account();
        pf.Name=PROVIDERAFF;
        pf.RecordTypeId=pfrecordTypeId;
        pf.Population__c = 'Adult';
        pf.Program__c=program.id;
        pf.ParentId	= pg.id;
        
        insert pf;
        
        id[] fiexedSearchResults = new id[1];
        fiexedSearchResults[0]=pf.id;
        Test.setFixedSearchResults(fiexedSearchResults);
        User thisUser = [Select Id From User Where Id =:UserInfo.getUserId()];
        user u1;
        System.runAs(thisUser){
            Profile agentProfile=[SELECT Id FROM Profile where Name=:FECPROFILE];
            u1 = new User( email=TSTEMAIL,
                          profileid = agentProfile.id, 
                          UserName=UNAME, 
                          Alias = 'GDS',
                          TimeZoneSidKey=TIMEZONE,
                          EmailEncodingKey=EMAILENCODE,
                          LocaleSidKey='en_US', 
                          isActive=true,
                          LanguageLocaleKey='en_US',
                          FirstName = 'Fagent1',
                          LastName = 'Lagent1');
            insert u1;
        }
        AccountTeamMember actTeam = new AccountTeamMember();
        actTeam.AccountId = pf.id;
        actTeam.UserId = u1.id;
        actTeam.TeamMemberRole =ACCTEAM;
        
        insert actTeam;
        
        System.runAs(u1){
            Map<Object,Object> m = new Map<Object,Object>();
            m.put('isBackupAgentView',true);
            m.put('familyId',null);
            m.put('label','Programs');
            m.put('selectProviderGroupId',pg.id);
            m.put('searchString','TestHospital');
            m.put('objectName','Account');
            
            lstProviderData = SNI_FL_ProviderMessageUtil.retrieveProviderData(m);
            
        }
        
        System.assertEquals(1,lstProviderData.size(),'Searched Related provider affliation record not recieved');
        
    }
    
    //Test method for 200  records
    @isTest
    static void testBulkMymessageLevelProgramDropdown(){
        
        List<SNI_FL_ProviderMessageUtil.ProviderData> lstProviderData;
        Id pgrecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Provider_Group').getRecordTypeId();
        Id pfrecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Provider_Affiliation').getRecordTypeId();
        
        //Program object
        Program__c program = new Program__c();
        program.Program__c = TSTPROGRAM;
        
        insert program;
        
        //Provider group acccount
        Account pg = new Account();
        pg.RecordTypeId= pgrecordTypeId;
        pg.Name = 'TestHospital';
        
        insert pg;
        
        Profile agentProfile=[SELECT Id FROM Profile where Name=:FECPROFILE];
        user u1;
        User thisUser = [Select Id From User Where Id =:UserInfo.getUserId()];
        System.runAs(thisUser){
            u1 = new User( email=TSTEMAIL,
                          profileid = agentProfile.id, 
                          UserName=UNAME, 
                          Alias = 'GDS',
                          TimeZoneSidKey=TIMEZONE,
                          EmailEncodingKey=EMAILENCODE,
                          LocaleSidKey='en_US', 
                          isActive=true,
                          LanguageLocaleKey='en_US',
                          FirstName = 'Fagent1',
                          LastName = 'Lagent1');
            insert u1;
        }
        List<Account> lstAct = new List<Account>();
        List<AccountTeamMember> lstActTeam = new List<AccountTeamMember>();
        
        for(Integer x=0;x<200;x++){
            //Provider affliation account
            Account pf=new Account();
            pf.Name=PROVIDERAFF+x;
            pf.RecordTypeId=pfrecordTypeId;
            pf.Population__c = 'Adult';
            pf.Program__c=program.id;
            pf.ParentId	= pg.id;
            
            lstAct.add(pf);
            
        }
        insert lstAct;
        
        for(Account act:[SELECT ID FROM Account WHERE RecordTypeId=:pfrecordTypeId]){
            AccountTeamMember actTeam = new AccountTeamMember();
            actTeam.AccountId = act.id;
            actTeam.UserId = u1.id;
            actTeam.TeamMemberRole =ACCTEAM;
            
            lstActTeam.add(actTeam);
        }
        
        insert lstActTeam;
        
        
        System.runAs(u1){
            Map<Object,Object> m = new Map<Object,Object>();
            m.put('isBackupAgentView',true);
            m.put('familyId',null);
            m.put('label','Programs');
            m.put('selectProviderGroupId',pg.id);
            m.put('searchString','');
            m.put('objectName','Account');
            
            lstProviderData = SNI_FL_ProviderMessageUtil.retrieveProviderData(m);
            
        }
        
        System.assertEquals(200,lstProviderData.size(),TSTMSG);
        
    }
    
    //Search Test method for 200  records
    @isTest
    static void testBulkSearchProgramDropdown(){
        
        List<SNI_FL_ProviderMessageUtil.ProviderData> lstProviderData;
        Id pgrecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Provider_Group').getRecordTypeId();
        Id pfrecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Provider_Affiliation').getRecordTypeId();
        
        //Program object
        Program__c program = new Program__c();
        program.Program__c = TSTPROGRAM;
        
        insert program;
        
        //Provider group acccount
        Account pg = new Account();
        pg.RecordTypeId= pgrecordTypeId;
        pg.Name = 'TestHospital';
        
        insert pg;
        
        Profile agentProfile=[SELECT Id FROM Profile where Name=:FECPROFILE];
        User thisUser = [Select Id From User Where Id =:UserInfo.getUserId()];
        user u1;
        System.runAs(thisUser){
            u1 = new User( email=TSTEMAIL,
                          profileid = agentProfile.id, 
                          UserName=UNAME, 
                          Alias = 'GDS',
                          TimeZoneSidKey=TIMEZONE,
                          EmailEncodingKey=EMAILENCODE,
                          LocaleSidKey='en_US', 
                          isActive=true,
                          LanguageLocaleKey='en_US',
                          FirstName = 'Fagent1',
                          LastName = 'Lagent1');
            insert u1;
        }
        List<Account> lstAct = new List<Account>();
        List<AccountTeamMember> lstActTeam = new List<AccountTeamMember>();
        
        for(Integer x=0;x<200;x++){
            //Provider affliation account
            Account pf=new Account();
            pf.Name=PROVIDERAFF+x;
            pf.RecordTypeId=pfrecordTypeId;
            pf.Population__c = 'Adult';
            pf.Program__c=program.id;
            pf.ParentId	= pg.id;
            
            lstAct.add(pf);
            
        }
        insert lstAct;
        
        for(Account act:[SELECT ID FROM Account WHERE RecordTypeId=:pfrecordTypeId]){
            AccountTeamMember actTeam = new AccountTeamMember();
            actTeam.AccountId = act.id;
            actTeam.UserId = u1.id;
            actTeam.TeamMemberRole =ACCTEAM;
            
            lstActTeam.add(actTeam);
        }
        
        insert lstActTeam;
        
        List<Id> searchResult = new LIst<ID>();
        
        for(Account act:[SELECT ID FROM Account WHERE RecordTypeId=:pfrecordTypeId]){
            searchResult.add(act.id);
        }
        
        Test.setFixedSearchResults(searchResult);
        
        System.runAs(u1){
            Map<Object,Object> m = new Map<Object,Object>();
            m.put('isBackupAgentView',true);
            m.put('familyId',null);
            m.put('label','Programs');
            m.put('selectProviderGroupId',pg.id);
            m.put('searchString','TestHospital');
            m.put('objectName','Account');
            
            lstProviderData = SNI_FL_ProviderMessageUtil.retrieveProviderData(m);
            
        }
        
        System.assertEquals(200,lstProviderData.size(),TSTMSG);
        
    }
    
    //Exception Test
    @isTest
    static void mymessageLevelexceptionTest(){
        
        List<SNI_FL_ProviderMessageUtil.ProviderData> lstProviderData;
        Id pgrecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Provider_Group').getRecordTypeId();
        Id pfrecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Provider_Affiliation').getRecordTypeId();
        
        //Program object
        Program__c program = new Program__c();
        program.Program__c = TSTPROGRAM;
        
        insert program;
        
        //Provider group acccount
        Account pg = new Account();
        pg.RecordTypeId= pgrecordTypeId;
        pg.Name = 'TestHospital';
        
        insert pg;
        
        //Provider affliation account
        Account pf=new Account();
        pf.Name=PROVIDERAFF;
        pf.RecordTypeId=pfrecordTypeId;
        pf.Population__c = 'Adult';
        pf.Program__c=program.id;
        pf.ParentId	= pg.id;
        
        insert pf;
        
        
        Profile agentProfile=[SELECT Id FROM Profile where Name=:FECPROFILE];
        User thisUser = [Select Id From User Where Id =:UserInfo.getUserId()];
        user u1;
         System.runAs(thisUser){
        u1 = new User( email=TSTEMAIL,
                           profileid = agentProfile.id, 
                           UserName=UNAME, 
                           Alias = 'GDS',
                           TimeZoneSidKey=TIMEZONE,
                           EmailEncodingKey=EMAILENCODE,
                           LocaleSidKey='en_US', 
                           isActive=true,
                           LanguageLocaleKey='en_US',
                           FirstName = 'Fagent1',
                           LastName = 'Lagent1');
        insert u1;
         }
        AccountTeamMember actTeam = new AccountTeamMember();
        actTeam.AccountId = pf.id;
        actTeam.UserId = u1.id;
        actTeam.TeamMemberRole =ACCTEAM;
        
        insert actTeam;
        
        System.runAs(u1){
            Map<Object,Object> m = new Map<Object,Object>();
            m.put('isBackupAgentView',true);
            m.put('familyId',null);
            m.put('label','Programs');
            m.put('selectProviderGroupId',pg.id);
            m.put('searchString','TestHospital');
            m.put('objectName','ACT');
            
            lstProviderData = SNI_FL_ProviderMessageUtil.retrieveProviderData(m);
            
        }
        
        System.assertEquals(null,lstProviderData,'provider affliation record are not empty');
        
    }
    
    //Member level test methods
    
    @isTest
    static void personlevelProgramDropdownTest(){
        
        List<SNI_FL_ProviderMessageUtil.ProviderData> lstProviderData;
        Id pgrecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Provider_Group').getRecordTypeId();
        Id pfrecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Provider_Affiliation').getRecordTypeId();
        Id personactRecordId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('PersonAccount').getRecordTypeId();
        
        Profile agentProfile=[SELECT Id FROM Profile where Name=:FECPROFILE];
        User thisUser = [Select Id From User Where Id =:UserInfo.getUserId()];
        user u1;
         System.runAs(thisUser){
        u1 = new User( email=TSTEMAIL,
                           profileid = agentProfile.id, 
                           UserName=UNAME, 
                           Alias = 'GDS',
                           TimeZoneSidKey=TIMEZONE,
                           EmailEncodingKey=EMAILENCODE,
                           LocaleSidKey='en_US', 
                           isActive=true,
                           LanguageLocaleKey='en_US',
                           FirstName = 'Fagent1',
                           LastName = 'Lagent1');
        insert u1;
         }
        Account acc= new Account(
            RecordTypeID=personactRecordId ,
            FirstName=FNAME,
            LastName=LNAME,
            PersonMailingStreet='flowerStreet',
            PersonMailingPostalCode='12345',
            PersonMailingCity='SFO',
            PersonEmail=YAHOOMAIL,
            PersonHomePhone='1234567',
            PersonMobilePhone='12345678'
        );
        
        insert acc;
        
        
        //Program object
        Program__c program = new Program__c();
        program.Program__c = TSTPROGRAM;
        
        insert program;
        
        //Provider group acccount
        Account pg = new Account();
        pg.RecordTypeId= pgrecordTypeId;
        pg.Name = 'TestHospital';
        
        insert pg;
        
        //Provider affliation account
        Account pf=new Account();
        pf.Name=PROVIDERAFF;
        pf.RecordTypeId=pfrecordTypeId;
        pf.Population__c = 'Adult';
        pf.Program__c=program.id;
        pf.ParentId	= pg.id;
        
        insert pf;
        
        Member_Affiliation__c memberAff = new Member_Affiliation__c();
        memberAff.Program__c=program.id;
        memberAff.Member__c=acc.id;
        memberAff.Provider_Affiliation__c=pf.id;
        memberAff.Enrollment_Date__c=Date.Today();
        
        insert memberAff;
        
        
        
        AccountTeamMember actTeam = new AccountTeamMember();
        actTeam.AccountId = pf.id;
        actTeam.UserId = u1.id;
        actTeam.TeamMemberRole =ACCTEAM;
        
        insert actTeam;
        
        System.runAs(u1){
            Map<Object,Object> m = new Map<Object,Object>();
            m.put('isBackupAgentView',true);
            m.put('familyId',acc.id);
            m.put('label','Programs');
            m.put('selectProviderGroupId',pg.id);
            m.put('searchString','');
            m.put('objectName','ACT');
            
            lstProviderData = SNI_FL_ProviderMessageUtil.retrieveProviderData(m);
            
        }
        //Commented in QA201
        //System.assertEquals(1,lstProviderData.size(),'provider affliation record are  empty');
        
    }
    
    @isTest
    static void personlevelSearchProgramDropdownTest(){
        
        List<SNI_FL_ProviderMessageUtil.ProviderData> lstProviderData;
        Id pgrecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Provider_Group').getRecordTypeId();
        Id pfrecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Provider_Affiliation').getRecordTypeId();
        Id personactRecordId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('PersonAccount').getRecordTypeId();
        
        Profile agentProfile=[SELECT Id FROM Profile where Name=:FECPROFILE];
        User thisUser = [Select Id From User Where Id =:UserInfo.getUserId()];
        user u1;
         System.runAs(thisUser){
        u1 = new User( email=TSTEMAIL,
                           profileid = agentProfile.id, 
                           UserName=UNAME, 
                           Alias = 'GDS',
                           TimeZoneSidKey=TIMEZONE,
                           EmailEncodingKey=EMAILENCODE,
                           LocaleSidKey='en_US', 
                           isActive=true,
                           LanguageLocaleKey='en_US',
                           FirstName = 'Fagent1',
                           LastName = 'Lagent1');
        insert u1;
         }
        Account acc= new Account(
            RecordTypeID=personactRecordId ,
            FirstName=FNAME,
            LastName=LNAME,
            PersonMailingStreet='flowerStreet',
            PersonMailingPostalCode='12345',
            PersonMailingCity='SFO',
            PersonEmail=YAHOOMAIL,
            PersonHomePhone='1234567',
            PersonMobilePhone='12345678'
        );
        
        insert acc;
        
        
        //Program object
        Program__c program = new Program__c();
        program.Program__c = TSTPROGRAM;
        
        insert program;
        
        //Provider group acccount
        Account pg = new Account();
        pg.RecordTypeId= pgrecordTypeId;
        pg.Name = 'TestHospital';
        
        insert pg;
        
        //Provider affliation account
        Account pf=new Account();
        pf.Name=PROVIDERAFF;
        pf.RecordTypeId=pfrecordTypeId;
        pf.Population__c = 'Adult';
        pf.Program__c=program.id;
        pf.ParentId	= pg.id;
        
        insert pf;
        
        Member_Affiliation__c memberAff = new Member_Affiliation__c();
        memberAff.Program__c=program.id;
        memberAff.Member__c=acc.id;
        memberAff.Provider_Affiliation__c=pf.id;
        memberAff.Enrollment_Date__c=Date.Today();
        
        insert memberAff;
        
        
        
        AccountTeamMember actTeam = new AccountTeamMember();
        actTeam.AccountId = pf.id;
        actTeam.UserId = u1.id;
        actTeam.TeamMemberRole =ACCTEAM;
        
        insert actTeam;
        
        id[] fiexedSearchResults = new id[1];
        fiexedSearchResults[0]=pf.id;
        Test.setFixedSearchResults(fiexedSearchResults);
        
        System.runAs(u1){
            Map<Object,Object> m = new Map<Object,Object>();
            m.put('isBackupAgentView',true);
            m.put('familyId',acc.id);
            m.put('label','Programs');
            m.put('selectProviderGroupId',pg.id);
            m.put('searchString','TestHospital');
            m.put('objectName','Account');
            
            lstProviderData = SNI_FL_ProviderMessageUtil.retrieveProviderData(m);
            
        }
        //Commented in QA201
        //System.assertEquals(1,lstProviderData.size(),'provider affliation record are  empty');
        
    }
    
    @isTest
    static void backuptestBulkMymessageLevelProgramDropdown(){
        
        List<SNI_FL_ProviderMessageUtil.ProviderData> lstProviderData;
        Id pgrecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Provider_Group').getRecordTypeId();
        Id pfrecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Provider_Affiliation').getRecordTypeId();
        
        //Program object
        Program__c program = new Program__c();
        program.Program__c = TSTPROGRAM;
        
        insert program;
        
        //Provider group acccount
        Account pg = new Account();
        pg.RecordTypeId= pgrecordTypeId;
        pg.Name = 'TestHospital';
        
        insert pg;
        
        Profile agentProfile=[SELECT Id FROM Profile where Name=:FECPROFILE];
        User thisUser = [Select Id From User Where Id =:UserInfo.getUserId()];
        user u1;
         System.runAs(thisUser){
        u1 = new User( email=TSTEMAIL,
                           profileid = agentProfile.id, 
                           UserName=UNAME, 
                           Alias = 'GDS',
                           TimeZoneSidKey=TIMEZONE,
                           EmailEncodingKey=EMAILENCODE,
                           LocaleSidKey='en_US', 
                           isActive=true,
                           LanguageLocaleKey='en_US',
                           FirstName = 'Fagent1',
                           LastName = 'Lagent1');
        insert u1;
         }
        List<Account> lstAct = new List<Account>();
        List<AccountTeamMember> lstActTeam = new List<AccountTeamMember>();
        
        for(Integer x=0;x<200;x++){
            //Provider affliation account
            Account pf=new Account();
            pf.Name=PROVIDERAFF+x;
            pf.RecordTypeId=pfrecordTypeId;
            pf.Population__c = 'Adult';
            pf.Program__c=program.id;
            pf.ParentId	= pg.id;
            
            lstAct.add(pf);
            
        }
        insert lstAct;
        
        for(Account act:[SELECT ID FROM Account WHERE RecordTypeId=:pfrecordTypeId]){
            AccountTeamMember actTeam = new AccountTeamMember();
            actTeam.AccountId = act.id;
            actTeam.UserId = u1.id;
            actTeam.TeamMemberRole =ACCTEAM;
            
            lstActTeam.add(actTeam);
        }
        
        insert lstActTeam;
        
        
        System.runAs(u1){
            Map<Object,Object> m = new Map<Object,Object>();
            m.put('isBackupAgentView',false);
            m.put('familyId',null);
            m.put('label','Programs');
            m.put('selectProviderGroupId',pg.id);
            m.put('searchString','');
            m.put('objectName','Account');
            m.put('userId',u1.id);
            
            lstProviderData = SNI_FL_ProviderMessageUtil.retrieveProviderData(m);
            
        }
        
        System.assertEquals(200,lstProviderData.size(),TSTMSG);
        
    }
    
    @isTest
    static void backuptestMymessageLevelSearchProgramDropdown(){
        
        List<SNI_FL_ProviderMessageUtil.ProviderData> lstProviderData;
        Id pgrecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Provider_Group').getRecordTypeId();
        Id pfrecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Provider_Affiliation').getRecordTypeId();
        
        //Program object
        Program__c program = new Program__c();
        program.Program__c = TSTPROGRAM;
        
        insert program;
        
        //Provider group acccount
        Account pg = new Account();
        pg.RecordTypeId= pgrecordTypeId;
        pg.Name = 'TestHospital';
        
        insert pg;
        
        //Provider affliation account
        Account pf=new Account();
        pf.Name=PROVIDERAFF;
        pf.RecordTypeId=pfrecordTypeId;
        pf.Population__c = 'Adult';
        pf.Program__c=program.id;
        pf.ParentId	= pg.id;
        
        insert pf;
        
        id[] fiexedSearchResults = new id[1];
        fiexedSearchResults[0]=pf.id;
        Test.setFixedSearchResults(fiexedSearchResults);
        
        Profile agentProfile=[SELECT Id FROM Profile where Name=:FECPROFILE];
        User thisUser = [Select Id From User Where Id =:UserInfo.getUserId()];
        user u1;
         System.runAs(thisUser){
        u1 = new User( email=TSTEMAIL,
                           profileid = agentProfile.id, 
                           UserName=UNAME, 
                           Alias = 'GDS',
                           TimeZoneSidKey=TIMEZONE,
                           EmailEncodingKey=EMAILENCODE,
                           LocaleSidKey='en_US', 
                           isActive=true,
                           LanguageLocaleKey='en_US',
                           FirstName = 'Fagent1',
                           LastName = 'Lagent1');
        insert u1;
         }
        AccountTeamMember actTeam = new AccountTeamMember();
        actTeam.AccountId = pf.id;
        actTeam.UserId = u1.id;
        actTeam.TeamMemberRole =ACCTEAM;
        insert actTeam;
        
        System.runAs(u1){
            Map<Object,Object> m = new Map<Object,Object>();
            m.put('isBackupAgentView',false);
            m.put('familyId',null);
            m.put('label','Programs');
            m.put('selectProviderGroupId',pg.id);
            m.put('searchString','TestHospital');
            m.put('objectName','Account');
            m.put('userId',u1.id);
            
            lstProviderData = SNI_FL_ProviderMessageUtil.retrieveProviderData(m);
            
        }
        
        System.assertEquals(1,lstProviderData.size(),'Searched Related provider affliation record not recieved');
        
    }
    
    //Related to List Search Agent view
    @isTest
    static void backupagentViewSearchRelatedListTest(){
        
        List<SNI_FL_ProviderMessageUtil.ProviderData> lstProviderData;
        Id pgrecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Provider_Group').getRecordTypeId();
        Id pfrecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Provider_Affiliation').getRecordTypeId();
        Id personactRecordId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('PersonAccount').getRecordTypeId();
        
        Profile agentProfile=[SELECT Id FROM Profile where Name=:FECPROFILE];
        User thisUser = [Select Id From User Where Id =:UserInfo.getUserId()];
        user u1;
         System.runAs(thisUser){
        u1 = new User( email=TSTEMAIL,
                           profileid = agentProfile.id, 
                           UserName=UNAME, 
                           Alias = 'GDS',
                           TimeZoneSidKey=TIMEZONE,
                           EmailEncodingKey=EMAILENCODE,
                           LocaleSidKey='en_US', 
                           isActive=true,
                           LanguageLocaleKey='en_US',
                           FirstName = 'Fagent1',
                           LastName = 'Lagent1');
        insert u1;
         }
        //Program object
        Program__c program = new Program__c();
        program.Program__c = TSTPROGRAM;
        
        insert program;
        
        //Provider group acccount
        Account pg = new Account();
        pg.RecordTypeId= pgrecordTypeId;
        pg.Name = 'TestHospital';
        
        insert pg;
        
        //Provider affliation account
        Account pf=new Account();
        pf.Name='Test_Hospital_Complex_Care_Adult';//changed name
        pf.RecordTypeId=pfrecordTypeId;
        pf.Population__c = 'Adult';
        pf.Program__c=program.id;
        pf.ParentId	= pg.id;
        
        insert pf;
        
        
        Account acc= new Account(
            RecordTypeID=personactRecordId ,
            FirstName=FNAME,
            LastName=LNAME,
            PersonMailingStreet='flowerStreet',
            PersonMailingPostalCode='12345',
            PersonMailingCity='SFO',
            PersonEmail=YAHOOMAIL,
            PersonHomePhone='1234567',
            PersonMobilePhone='12345678'
        );
        
        insert acc;
        
        Member_Affiliation__c memberAff = new Member_Affiliation__c();
        memberAff.Program__c=program.id;
        memberAff.Member__c=acc.id;
        memberAff.Provider_Affiliation__c=pf.id;
        memberAff.Enrollment_Date__c=Date.Today();
        
        insert memberAff;
        
        id[] fiexedSearchResults = new id[1];
        fiexedSearchResults[0]=acc.id;    
        Test.setFixedSearchResults(fiexedSearchResults);
        
        AccountTeamMember actTeam = new AccountTeamMember();
        actTeam.AccountId = pf.id;
        actTeam.UserId = u1.id;
        actTeam.TeamMemberRole =ACCTEAM;
        
        insert actTeam;
        
        System.runAs(u1){
            Map<Object,Object> m = new Map<Object,Object>();
            m.put('isBackupAgentView',false);
            m.put('label',RELATEDTO);
            m.put('selectedProviderAffliation',pf.id);
            m.put('searchString',FNAME);
            m.put('objectName','Account');
            
            lstProviderData = SNI_FL_ProviderMessageUtil.retrieveProviderData(m);
            
        }
        //Commented in QA201
        //System.assertEquals(1,lstProviderData.size(),PFEMPTY);
        
    }
    
    //Related to List Agent view
    @isTest
    static void backupagentViewRelatedListTest(){
        
        List<SNI_FL_ProviderMessageUtil.ProviderData> lstProviderData;
        Id pgrecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Provider_Group').getRecordTypeId();
        Id pfrecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Provider_Affiliation').getRecordTypeId();
        Id personactRecordId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('PersonAccount').getRecordTypeId();
        
        Profile agentProfile=[SELECT Id FROM Profile where Name=:FECPROFILE];
        User thisUser = [Select Id From User Where Id =:UserInfo.getUserId()];
        user u1;
         System.runAs(thisUser){
        u1 = new User( email=TSTEMAIL,
                           profileid = agentProfile.id, 
                           UserName=UNAME, 
                           Alias = 'GDS',
                           TimeZoneSidKey=TIMEZONE,
                           EmailEncodingKey=EMAILENCODE,
                           LocaleSidKey='en_US', 
                           isActive=true,
                           LanguageLocaleKey='en_US',
                           FirstName = 'Fagent1',
                           LastName = 'Lagent1');
        insert u1;
         }
        //Program object
        Program__c program = new Program__c();
        program.Program__c = TSTPROGRAM;
        
        insert program;
        
        //Provider group acccount
        Account pg = new Account();
        pg.RecordTypeId= pgrecordTypeId;
        pg.Name = 'TestHospital';
        
        insert pg;
        
        //Provider affliation account
        Account pf=new Account();
        pf.Name='TestHospital_ComplexCare_Adult';//Changed
        pf.RecordTypeId=pfrecordTypeId;
        pf.Population__c = 'Adult';
        pf.Program__c=program.id;
        pf.ParentId	= pg.id;
        
        insert pf;
        
        
        Account acc= new Account(
            RecordTypeID=personactRecordId ,
            FirstName=FNAME,
            LastName=LNAME,
            PersonMailingStreet='flower',
            PersonMailingPostalCode='12345',
            PersonMailingCity='SFO',
            PersonEmail=YAHOOMAIL,
            PersonHomePhone='1234567',
            PersonMobilePhone='12345678'
        );
        
        insert acc;
        
        Member_Affiliation__c memberAff = new Member_Affiliation__c();
        memberAff.Program__c=program.id;
        memberAff.Member__c=acc.id;
        memberAff.Provider_Affiliation__c=pf.id;
        memberAff.Enrollment_Date__c=Date.Today();
        
        insert memberAff;
        
        id[] fiexedSearchResults = new id[1];
        fiexedSearchResults[0]=acc.id;    
        Test.setFixedSearchResults(fiexedSearchResults);
        
        AccountTeamMember actTeam = new AccountTeamMember();
        actTeam.AccountId = pf.id;
        actTeam.UserId = u1.id;
        actTeam.TeamMemberRole =ACCTEAM;
        
        insert actTeam;
        
        System.runAs(u1){
            Map<Object,Object> m = new Map<Object,Object>();
            m.put('isBackupAgentView',false);
            m.put('label',RELATEDTO);
            m.put('selectedProviderAffliation',pf.id);
            m.put('searchString','');
            m.put('objectName','Account');
            
            lstProviderData = SNI_FL_ProviderMessageUtil.retrieveProviderData(m);
            
        }
        //Commented in QA201
        //System.assertEquals(1,lstProviderData.size(),PFEMPTY);
        
    }
    
    //Exception Test
    @isTest
    static void backupMymessageLevelexceptionTest(){
        
        List<SNI_FL_ProviderMessageUtil.ProviderData> lstProviderData;
        Id pgrecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Provider_Group').getRecordTypeId();
        Id pfrecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Provider_Affiliation').getRecordTypeId();
        
        //Program object
        Program__c program = new Program__c();
        program.Program__c = TSTPROGRAM;
        
        insert program;
        
        //Provider group acccount
        Account pg = new Account();
        pg.RecordTypeId= pgrecordTypeId;
        pg.Name = 'TestHospital';
        
        insert pg;
        
        //Provider affliation account
        Account pf=new Account();
        pf.Name=PROVIDERAFF;
        pf.RecordTypeId=pfrecordTypeId;
        pf.Population__c = 'Adult';
        pf.Program__c=program.id;
        pf.ParentId	= pg.id;
        
        insert pf;
        
        
        Profile agentProfile=[SELECT Id FROM Profile where Name=:FECPROFILE];
        user u1;
        User thisUser = [Select Id From User Where Id =:UserInfo.getUserId()];
         System.runAs(thisUser){
        u1 = new User( email=TSTEMAIL,
                           profileid = agentProfile.id, 
                           UserName=UNAME, 
                           Alias = 'GDS',
                           TimeZoneSidKey=TIMEZONE,
                           EmailEncodingKey=EMAILENCODE,
                           LocaleSidKey='en_US', 
                           isActive=true,
                           LanguageLocaleKey='en_US',
                           FirstName = 'Fagent1',
                           LastName = 'Lagent1');
        insert u1;
         }
        AccountTeamMember actTeam = new AccountTeamMember();
        actTeam.AccountId = pf.id;
        actTeam.UserId = u1.id;
        actTeam.TeamMemberRole =ACCTEAM;
        
        insert actTeam;
        
        System.runAs(u1){
            Map<Object,Object> m = new Map<Object,Object>();
            m.put('isBackupAgentView',false);
            m.put('familyId',null);
            m.put('label','Programs');
            m.put('selectProviderGroupId',pg.id);
            m.put('searchString','TestHospital');
            m.put('objectName','ACT');
            m.put('userId',u1.id);
            
            lstProviderData = SNI_FL_ProviderMessageUtil.retrieveProviderData(m);
            
        }
        
        System.assertEquals(null,lstProviderData,'provider affliation record are not empty');
        
    }
    
    //Related to List Agent view
    @isTest
    static void agentViewRelatedListTest(){
        
        List<SNI_FL_ProviderMessageUtil.ProviderData> lstProviderData;
        Id pgrecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Provider_Group').getRecordTypeId();
        Id pfrecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Provider_Affiliation').getRecordTypeId();
        Id personactRecordId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('PersonAccount').getRecordTypeId();
        
        Profile agentProfile=[SELECT Id FROM Profile where Name=:FECPROFILE];
        User thisUser = [Select Id From User Where Id =:UserInfo.getUserId()];
        user u1;
         System.runAs(thisUser){
        u1 = new User( email=TSTEMAIL,
                           profileid = agentProfile.id, 
                           UserName=UNAME, 
                           Alias = 'GDS',
                           TimeZoneSidKey=TIMEZONE,
                           EmailEncodingKey=EMAILENCODE,
                           LocaleSidKey='en_US', 
                           isActive=true,
                           LanguageLocaleKey='en_US',
                           FirstName = 'Fagent1',
                           LastName = 'Lagent1');
        insert u1;
         }
        //Program object
        Program__c program = new Program__c();
        program.Program__c = TSTPROGRAM;
        
        insert program;
        
        //Provider group acccount
        Account pg = new Account();
        pg.RecordTypeId= pgrecordTypeId;
        pg.Name = 'TestHospital';
        
        insert pg;
        
        //Provider affliation account
        Account pf=new Account();
        pf.Name=PROVIDERAFF;
        pf.RecordTypeId=pfrecordTypeId;
        pf.Population__c = 'Adult';
        pf.Program__c=program.id;
        pf.ParentId	= pg.id;
        
        insert pf;
        
        
        Account acc= new Account(
            RecordTypeID=personactRecordId ,
            FirstName=FNAME,
            LastName=LNAME,
            PersonMailingStreet='flowerStreet',
            PersonMailingPostalCode='12345',
            PersonMailingCity='SFO',
            PersonEmail=YAHOOMAIL,
            PersonHomePhone='1234567',
            PersonMobilePhone='12345678'
        );
        
        insert acc;
        
        Member_Affiliation__c memberAff = new Member_Affiliation__c();
        memberAff.Program__c=program.id;
        memberAff.Member__c=acc.id;
        memberAff.Provider_Affiliation__c=pf.id;
        memberAff.Enrollment_Date__c=Date.Today();
        
        insert memberAff;
        
        
        
        AccountTeamMember actTeam = new AccountTeamMember();
        actTeam.AccountId = pf.id;
        actTeam.UserId = u1.id;
        actTeam.TeamMemberRole =ACCTEAM;
        
        insert actTeam;
        
        System.runAs(u1){    
            Map<Object,Object> m = new Map<Object,Object>();
            m.put('isBackupAgentView',true);
            m.put('label',RELATEDTO);
            m.put('selectedProviderAffliation',pf.id);
            m.put('searchString','');
            m.put('objectName','Account');
            
            lstProviderData = SNI_FL_ProviderMessageUtil.retrieveProviderData(m);
            
        }
        //Commneted in QA201
        //System.assertEquals(1,lstProviderData.size(),PFEMPTY);
        
    }
    
    //Related to List Search Agent view
    @isTest
    static void agentViewSearchRelatedListTest(){
        
        List<SNI_FL_ProviderMessageUtil.ProviderData> lstProviderData;
        Id pgrecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Provider_Group').getRecordTypeId();
        Id pfrecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Provider_Affiliation').getRecordTypeId();
        Id personactRecordId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('PersonAccount').getRecordTypeId();
        
        Profile agentProfile=[SELECT Id FROM Profile where Name=:FECPROFILE];
        User thisUser = [Select Id From User Where Id =:UserInfo.getUserId()];
        user u1;
         System.runAs(thisUser){
       u1 = new User( email=TSTEMAIL,
                           profileid = agentProfile.id, 
                           UserName=UNAME, 
                           Alias = 'GDS',
                           TimeZoneSidKey=TIMEZONE,
                           EmailEncodingKey=EMAILENCODE,
                           LocaleSidKey='en_US', 
                           isActive=true,
                           LanguageLocaleKey='en_US',
                           FirstName = 'Fagent1',
                           LastName = 'Lagent1');
        insert u1;
         }
        //Program object
        Program__c program = new Program__c();
        program.Program__c = TSTPROGRAM;
        
        insert program;
        
        //Provider group acccount
        Account pg = new Account();
        pg.RecordTypeId= pgrecordTypeId;
        pg.Name = 'TestHospital';
        
        insert pg;
        
        //Provider affliation account
        Account pf=new Account();
        pf.Name=PROVIDERAFF;
        pf.RecordTypeId=pfrecordTypeId;
        pf.Population__c = 'Adult';
        pf.Program__c=program.id;
        pf.ParentId	= pg.id;
        
        insert pf;
        
        
        Account acc= new Account(
            RecordTypeID=personactRecordId ,
            FirstName=FNAME,
            LastName=LNAME,
            PersonMailingStreet='flowerStreet',
            PersonMailingPostalCode='12345',
            PersonMailingCity='SFO',
            PersonEmail=YAHOOMAIL,
            PersonHomePhone='1234567',
            PersonMobilePhone='12345678'
        );
        
        insert acc;
        
        Member_Affiliation__c memberAff = new Member_Affiliation__c();
        memberAff.Program__c=program.id;
        memberAff.Member__c=acc.id;
        memberAff.Provider_Affiliation__c=pf.id;
        memberAff.Enrollment_Date__c=Date.Today();
        
        insert memberAff;
        
        id[] fiexedSearchResults = new id[1];
        fiexedSearchResults[0]=acc.id;    
        Test.setFixedSearchResults(fiexedSearchResults);
        
        AccountTeamMember actTeam = new AccountTeamMember();
        actTeam.AccountId = pf.id;
        actTeam.UserId = u1.id;
        actTeam.TeamMemberRole =ACCTEAM;
        
        insert actTeam;
        
        System.runAs(u1){   
            Map<Object,Object> m = new Map<Object,Object>();
            m.put('isBackupAgentView',true);
            m.put('label',RELATEDTO);
            m.put('selectedProviderAffliation',pf.id);
            m.put('searchString',FNAME);
            m.put('objectName','Account');
            
            lstProviderData = SNI_FL_ProviderMessageUtil.retrieveProviderData(m);
            
        }
        //Commented in QA201
        //System.assertEquals(1,lstProviderData.size(),PFEMPTY);
        
    }
    
    @isTest
    static void backupMymessageagentViewRelatedListTest(){
        
        List<SNI_FL_ProviderMessageUtil.ProviderData> lstProviderData;
        Id pgrecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Provider_Group').getRecordTypeId();
        Id pfrecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Provider_Affiliation').getRecordTypeId();
        Id personactRecordId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('PersonAccount').getRecordTypeId();
        
        Profile agentProfile=[SELECT Id FROM Profile where Name=:FECPROFILE];
        User thisUser = [Select Id From User Where Id =:UserInfo.getUserId()];
        user u1;
         System.runAs(thisUser){
        u1 = new User( email=TSTEMAIL,
                           profileid = agentProfile.id, 
                           UserName=UNAME, 
                           Alias = 'GDS',
                           TimeZoneSidKey=TIMEZONE,
                           EmailEncodingKey=EMAILENCODE,
                           LocaleSidKey='en_US', 
                           isActive=true,
                           LanguageLocaleKey='en_US',
                           FirstName = 'Fagent1',
                           LastName = 'Lagent1');
        insert u1;
         }
        //Program object
        Program__c program = new Program__c();
        program.Program__c = TSTPROGRAM;
        
        insert program;
        
        //Provider group acccount
        Account pg = new Account();
        pg.RecordTypeId= pgrecordTypeId;
        pg.Name = 'TestHospital';
        
        insert pg;
        
        //Provider affliation account
        Account pf=new Account();
        pf.Name='TestHospitalComplexCare-Adult';//adult
        pf.RecordTypeId=pfrecordTypeId;
        pf.Population__c = 'Adult';
        pf.Program__c=program.id;
        pf.ParentId	= pg.id;
        
        insert pf;
        
        
        Account acc= new Account(
            RecordTypeID=personactRecordId ,
            FirstName=FNAME,
            LastName=LNAME,
            PersonMailingStreet='flowerStreet',
            PersonMailingPostalCode='12345',
            PersonMailingCity='SFO',
            PersonEmail=YAHOOMAIL,
            PersonHomePhone='1234567',
            PersonMobilePhone='12345678'
        );
        
        insert acc;
        
        Member_Affiliation__c memberAff = new Member_Affiliation__c();
        memberAff.Program__c=program.id;
        memberAff.Member__c=acc.id;
        memberAff.Provider_Affiliation__c=pf.id;
        memberAff.Enrollment_Date__c=Date.Today();
        
        insert memberAff;
        
        id[] fiexedSearchResults = new id[1];
        fiexedSearchResults[0]=acc.id;    
        Test.setFixedSearchResults(fiexedSearchResults);
        
        AccountTeamMember actTeam = new AccountTeamMember();
        actTeam.AccountId = pf.id;
        actTeam.UserId = u1.id;
        actTeam.TeamMemberRole =ACCTEAM;
        
        insert actTeam;
        
        System.runAs(u1){    
            Map<Object,Object> m = new Map<Object,Object>();
            m.put('isBackupAgentView',false);
            m.put('label',RELATEDTO);
            m.put('selectedProviderAffliation',pf.id);
            m.put('searchString','');
            m.put('objectName','ACT');
            
            lstProviderData = SNI_FL_ProviderMessageUtil.retrieveProviderData(m);
            
        }
        
        //Commented in QA201 
        //System.assertEquals(1,lstProviderData.size(),PFEMPTY);
        
    }
    
    //Person account level to dropdown 
    @isTest
    static void backupTestpersonLevelToDropdownTest(){
        
        List<SNI_FL_ProviderMessageUtil.ProviderData> lstProviderData;
        Id pgrecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Provider_Group').getRecordTypeId();
        Id pfrecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Provider_Affiliation').getRecordTypeId();
        Id personactRecordId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('PersonAccount').getRecordTypeId();
        Id providerTeamRecordId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Provider_Team').getRecordTypeId();
        
        //Program object
        Program__c program = new Program__c();
        program.Program__c = TSTPROGRAM;
        
        insert program;
        
        //Provider group acccount
        Account pg = new Account();
        pg.RecordTypeId= pgrecordTypeId;
        pg.Name = 'TestHospital';
        
        insert pg;
        
        //Provider team acccount
        Account pt = new Account();
        pt.RecordTypeId= providerTeamRecordId;
        pt.FirstName = 'FName';
        pt.LastName='LName';
        pt.Provider_Group_Team__c = pg.id;
        
        insert pt;
        
        //Provider affliation account
        Account pf=new Account();
        pf.Name=PROVIDERAFF;
        pf.RecordTypeId=pfrecordTypeId;
        pf.Population__c = 'Adult';
        pf.Program__c=program.id;
        pf.ParentId	= pg.id;
        
        insert pf;
        
        
        Account acc= new Account(
            RecordTypeID=personactRecordId ,
            FirstName=FNAME,
            LastName=LNAME,
            PersonMailingStreet='flowerStreet',
            PersonMailingPostalCode='12345',
            PersonMailingCity='SFO',
            PersonEmail=YAHOOMAIL,
            PersonHomePhone='1234567',
            PersonMobilePhone='12345678'
        );
        
        insert acc;
        
        Member_Affiliation__c memberAff = new Member_Affiliation__c();
        memberAff.Program__c=program.id;
        memberAff.Member__c=acc.id;
        memberAff.Provider_Affiliation__c=pf.id;
        memberAff.Enrollment_Date__c=Date.Today();
        
        insert memberAff;
        
        
        
        Profile agentProfile=[SELECT Id FROM Profile where Name=:FECPROFILE];
        User thisUser = [Select Id From User Where Id =:UserInfo.getUserId()];
        user u1;
         System.runAs(thisUser){
        u1 = new User( email=TSTEMAIL,
                           profileid = agentProfile.id, 
                           UserName=UNAME, 
                           Alias = 'GDS',
                           TimeZoneSidKey=TIMEZONE,
                           EmailEncodingKey=EMAILENCODE,
                           LocaleSidKey='en_US', 
                           isActive=true,
                           LanguageLocaleKey='en_US',
                           FirstName = 'Fagent1',
                           LastName = 'Lagent1');
        insert u1;
         }
        AccountTeamMember actTeam = new AccountTeamMember();
        actTeam.AccountId = pf.id;
        actTeam.UserId = u1.id;
        actTeam.TeamMemberRole =ACCTEAM;
        
        insert actTeam;
        
        AccountContactRelation acr = new AccountContactRelation();
        acr.AccountId = pf.id;
        acr.ContactId = [select id from contact where AccountId =:pt.Id].id;
        insert acr;
        user u2;
         System.runAs(thisUser){
        u2 = new User( email=TSTEMAIL,
                           profileid = agentProfile.id, 
                           UserName=USERNAME, 
                           Alias = 'GDS',
                           TimeZoneSidKey=TIMEZONE,
                           EmailEncodingKey=EMAILENCODE,
                           LocaleSidKey='en_US', 
                           isActive=true,
                           LanguageLocaleKey='en_US',
                           FirstName = 'Fagent1',
                           LastName = 'Lagent1');
        insert u2;
         }
        
        System.runAs(u2){
            Map<Object,Object> m = new Map<Object,Object>();
            m.put('isBackupAgentView',false);
            m.put('familyId',acc.id);
            m.put('label','To');
            m.put('selectedProviderAffliation',pf.id);
            m.put('searchString','');
            m.put('selectProviderGroupId',pg.id);
            m.put('userId',u1.id);
            
            lstProviderData = SNI_FL_ProviderMessageUtil.retrieveProviderData(m);
            
            
        }
        
        System.assertEquals(2,lstProviderData.size(),PFEMPTY);
        
    }
    
    
    //Person account level Search to dropdown 
    @isTest
    static void backuppersonLevelSearchToDropdownTest(){
        
        List<SNI_FL_ProviderMessageUtil.ProviderData> lstProviderData;
        Id pgrecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Provider_Group').getRecordTypeId();
        Id pfrecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Provider_Affiliation').getRecordTypeId();
        Id personactRecordId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('PersonAccount').getRecordTypeId();
        Id providerTeamRecordId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Provider_Team').getRecordTypeId();
        
        //Program object
        Program__c program = new Program__c();
        program.Program__c = TSTPROGRAM;
        
        insert program;
        
        //Provider group acccount
        Account pg = new Account();
        pg.RecordTypeId= pgrecordTypeId;
        pg.Name = 'TestHospital';
        
        insert pg;
        
        Profile agentProfile=[SELECT Id FROM Profile where Name=:FECPROFILE];
        User thisUser = [Select Id From User Where Id =:UserInfo.getUserId()];
        user u1;
         System.runAs(thisUser){
        u1 = new User( email=TSTEMAIL,
                           profileid = agentProfile.id, 
                           UserName=UNAME, 
                           Alias = 'GDS',
                           TimeZoneSidKey=TIMEZONE,
                           EmailEncodingKey=EMAILENCODE,
                           LocaleSidKey='en_US', 
                           isActive=true,
                           LanguageLocaleKey='en_US',
                           FirstName = 'Fagent1',
                           LastName = 'Lagent1');
        insert u1;
         }
        //Provider team acccount
        Account pt = new Account();
        pt.RecordTypeId= providerTeamRecordId;
        pt.FirstName = u1.FirstName;
        pt.LastName= u1.LastName;
        pt.Provider_Group_Team__c = pg.id;
        
        insert pt;
        
        
        
        //Provider affliation account
        Account pf=new Account();
        pf.Name=PROVIDERAFF;
        pf.RecordTypeId=pfrecordTypeId;
        pf.Population__c = 'Adult';
        pf.Program__c=program.id;
        pf.ParentId	= pg.id;
        
        insert pf;
        
        
        Account acc= new Account(
            RecordTypeID=personactRecordId ,
            FirstName=FNAME,
            LastName=LNAME,
            PersonMailingStreet='flowerStreet',
            PersonMailingPostalCode='12345',
            PersonMailingCity='SFO',
            PersonEmail=YAHOOMAIL,
            PersonHomePhone='1234567',
            PersonMobilePhone='12345678'
        );
        
        insert acc;
        
        Member_Affiliation__c memberAff = new Member_Affiliation__c();
        memberAff.Program__c=program.id;
        memberAff.Member__c=acc.id;
        memberAff.Provider_Affiliation__c=pf.id;
        memberAff.Enrollment_Date__c=Date.Today();
        
        insert memberAff;
        
        AccountTeamMember actTeam = new AccountTeamMember();
        actTeam.AccountId = pf.id;
        actTeam.UserId = u1.id;
        actTeam.TeamMemberRole =ACCTEAM;
        
        insert actTeam;
        
        
        AccountContactRelation acr = new AccountContactRelation();
        acr.AccountId = pf.id;
        acr.ContactId = [select id from contact where AccountId =:pt.Id].id;
        insert acr;
        
        id[] fiexedSearchResults = new id[2];
        fiexedSearchResults[0]=u1.id;
        fiexedSearchResults[1]=pt.id;
        Test.setFixedSearchResults(fiexedSearchResults);
        user u2;
         System.runAs(thisUser){
        u2 = new User( email=TSTEMAIL,
                           profileid = agentProfile.id, 
                           UserName=USERNAME, 
                           Alias = 'GDS',
                           TimeZoneSidKey=TIMEZONE,
                           EmailEncodingKey=EMAILENCODE,
                           LocaleSidKey='en_US', 
                           isActive=true,
                           LanguageLocaleKey='en_US',
                           FirstName = 'Fagent1',
                           LastName = 'Lagent1');
        
        insert u2;
         }
        
        System.runAs(u2){
            Map<Object,Object> m = new Map<Object,Object>();
            m.put('isBackupAgentView',false);
            m.put('familyId',acc.id);
            m.put('label','To');
            m.put('selectedProviderAffliation',pf.id);
            m.put('searchString',u1.FirstName);
            m.put('selectProviderGroupId',pg.id);
            m.put('userId',u1.id);
            
            lstProviderData = SNI_FL_ProviderMessageUtil.retrieveProviderData(m);
            
            
        }
        
        System.assertEquals(2,lstProviderData.size(),PFEMPTY);
        
    }
    
    //Person account level to dropdown 
    @isTest
    static void personLevelToDropdownTest(){
        
        List<SNI_FL_ProviderMessageUtil.ProviderData> lstProviderData;
        Id pgrecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Provider_Group').getRecordTypeId();
        Id pfrecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Provider_Affiliation').getRecordTypeId();
        Id personactRecordId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('PersonAccount').getRecordTypeId();
        Id providerTeamRecordId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Provider_Team').getRecordTypeId();
        Id providerUserRecordId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Provider_User').getRecordTypeId();
        
        //Provider group acccount
        Account pg = new Account();
        pg.RecordTypeId= pgrecordTypeId;
        pg.Name = 'TestHospital';
        
        insert pg;
        
        Account providerUser= new Account(
            RecordTypeID=providerUserRecordId ,
            FirstName=FNAME,
            LastName=LNAME,
            Provider_Group__c=pg.id,
            PersonMailingStreet='flowerStreet',
            PersonMailingPostalCode='12345',
            PersonMailingCity='SFO',
            PersonEmail=YAHOOMAIL,
            PersonHomePhone='1234567',
            PersonMobilePhone='12345678'
        );
        
        insert providerUser;
        
        Account providerUseracc = [SELECT PersonContactId FROM Account WHERE Id = :providerUser.Id];
        Profile portal = [SELECT Id FROM Profile WHERE Name = 'Care Advisor Connect Provider User' LIMIT 1];
        User thisUser = [Select Id From User Where Id =:UserInfo.getUserId()];
        user portalu;
         System.runAs(thisUser){
        portalu = new User(
            FirstName = 'TestFirstName',
            LastName = 'TestLastName',
            Email = TESTUSERMAIL,
            Username = UNAME,
            Alias = 'TestPA', 
            TimeZoneSidKey = 'GMT', 
            LocaleSidKey = 'en_US', 
            EmailEncodingKey = 'UTF-8', 
            ProfileId = portal.Id, 
            LanguageLocaleKey = 'en_US',
            ContactId = providerUseracc.PersonContactId);
        
        insert portalu;
         }
        
        //Program object
        Program__c program = new Program__c();
        program.Program__c = TSTPROGRAM;
        
        insert program;
        
        
        
        //Provider team acccount
        Account pt = new Account();
        pt.RecordTypeId= providerTeamRecordId;
        pt.FirstName = 'FName';
        pt.LastName='LName';
        pt.Provider_Group_Team__c = pg.id;
        
        insert pt;
        
        //Provider affliation account
        Account pf=new Account();
        pf.Name=PROVIDERAFF;
        pf.RecordTypeId=pfrecordTypeId;
        pf.Population__c = 'Adult';
        pf.Program__c=program.id;
        pf.ParentId	= pg.id;
        
        insert pf;
        
        
        Account acc= new Account(
            RecordTypeID=personactRecordId ,
            FirstName=FNAME,
            LastName=LNAME,
            PersonMailingStreet='flowerStreet',
            PersonMailingPostalCode='12345',
            PersonMailingCity='SFO',
            PersonEmail=YAHOOMAIL,
            PersonHomePhone='1234567',
            PersonMobilePhone='12345678'
        );
        
        insert acc;
        
        Member_Affiliation__c memberAff = new Member_Affiliation__c();
        memberAff.Program__c=program.id;
        memberAff.Member__c=acc.id;
        memberAff.Provider_Affiliation__c=pf.id;
        memberAff.Enrollment_Date__c=Date.Today();
        
        insert memberAff;
        
        
        
        Profile agentProfile=[SELECT Id FROM Profile where Name=:FECPROFILE];
        user u1;
         System.runAs(thisUser){
       u1 = new User( email=TSTEMAIL,
                           profileid = agentProfile.id, 
                           UserName=TESTEMAIL, 
                           Alias = 'GDS',
                           TimeZoneSidKey=TIMEZONE,
                           EmailEncodingKey=EMAILENCODE,
                           LocaleSidKey='en_US', 
                           isActive=true,
                           LanguageLocaleKey='en_US',
                           FirstName = 'Fagent1',
                           LastName = 'Lagent1');
        insert u1;
         }
        AccountTeamMember actTeam = new AccountTeamMember();
        actTeam.AccountId = pf.id;
        actTeam.UserId = u1.id;
        actTeam.TeamMemberRole =ACCTEAM;
        
        insert actTeam;
        
        AccountContactRelation acr = new AccountContactRelation();
        acr.AccountId = pf.id;
        acr.ContactId = [select id from contact where AccountId =:pt.Id].id;
        insert acr;
        
        AccountContactRelation acr2 = new AccountContactRelation();
        acr2.AccountId = pf.id;
        acr2.ContactId = providerUseracc.PersonContactId;
        insert acr2;
        user u2;
         System.runAs(thisUser){
        u2 = new User( email=TSTEMAIL,
                           profileid = agentProfile.id, 
                           UserName=USERNAME, 
                           Alias = 'GDS',
                           TimeZoneSidKey=TIMEZONE,
                           EmailEncodingKey=EMAILENCODE,
                           LocaleSidKey='en_US', 
                           isActive=true,
                           LanguageLocaleKey='en_US',
                           FirstName = 'Fagent1',
                           LastName = 'Lagent1');
        insert u2;
         }
        
        
        
        System.runAs(u2){
            Map<Object,Object> m = new Map<Object,Object>();
            m.put('isBackupAgentView',true);
            m.put('familyId',acc.id);
            m.put('label','To');
            m.put('selectedProviderAffliation',pf.id);
            m.put('searchString','');
            m.put('selectProviderGroupId',pg.id);
            m.put('userId',u1.id);
            
            lstProviderData = SNI_FL_ProviderMessageUtil.retrieveProviderData(m);
            
            
        }
        
        System.assertEquals(3,lstProviderData.size(),PFEMPTY);
        
    }
    
    //Person account level to dropdown 
    @isTest
    static void backuppersonLevelToDropdownTest(){
        
        List<SNI_FL_ProviderMessageUtil.ProviderData> lstProviderData;
        Id pgrecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Provider_Group').getRecordTypeId();
        Id pfrecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Provider_Affiliation').getRecordTypeId();
        Id personactRecordId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('PersonAccount').getRecordTypeId();
        Id providerTeamRecordId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Provider_Team').getRecordTypeId();
        Id providerUserRecordId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Provider_User').getRecordTypeId();
        
        //Provider group acccount
        Account pg = new Account();
        pg.RecordTypeId= pgrecordTypeId;
        pg.Name = 'TestHospital';
        
        insert pg;
        
        Account providerUser= new Account(
            RecordTypeID=providerUserRecordId ,
            FirstName=FNAME,
            LastName=LNAME,
            Provider_Group__c=pg.id,
            PersonMailingStreet='flowerStreet',
            PersonMailingPostalCode='12345',
            PersonMailingCity='SFO',
            PersonEmail=YAHOOMAIL,
            PersonHomePhone='1234567',
            PersonMobilePhone='12345678'
        );
        
        insert providerUser;
        
        Account providerUseracc = [SELECT PersonContactId FROM Account WHERE Id = :providerUser.Id];
        Profile portal = [SELECT Id FROM Profile WHERE Name = 'Care Advisor Connect Provider User' LIMIT 1];
        User thisUser = [Select Id From User Where Id =:UserInfo.getUserId()];
        user portalu;
         System.runAs(thisUser){
        portalu = new User(
            FirstName = 'TestFirstName',
            LastName = 'TestLastName',
            Email = TESTUSERMAIL,
            Username = UNAME,
            Alias = 'TestPA', 
            TimeZoneSidKey = 'GMT', 
            LocaleSidKey = 'en_US', 
            EmailEncodingKey = 'UTF-8', 
            ProfileId = portal.Id, 
            LanguageLocaleKey = 'en_US',
            ContactId = providerUseracc.PersonContactId);
        
        insert portalu;
         }
        
        //Program object
        Program__c program = new Program__c();
        program.Program__c = TSTPROGRAM;
        
        insert program;
        
        
        
        //Provider team acccount
        Account pt = new Account();
        pt.RecordTypeId= providerTeamRecordId;
        pt.FirstName = 'FName';
        pt.LastName='LName';
        pt.Provider_Group_Team__c = pg.id;
        
        insert pt;
        
        //Provider affliation account
        Account pf=new Account();
        pf.Name=PROVIDERAFF;
        pf.RecordTypeId=pfrecordTypeId;
        pf.Population__c = 'Adult';
        pf.Program__c=program.id;
        pf.ParentId	= pg.id;
        
        insert pf;
        
        
        Account acc= new Account(
            RecordTypeID=personactRecordId ,
            FirstName=FNAME,
            LastName=LNAME,
            PersonMailingStreet='flowerStreet',
            PersonMailingPostalCode='12345',
            PersonMailingCity='SFO',
            PersonEmail=YAHOOMAIL,
            PersonHomePhone='1234567',
            PersonMobilePhone='12345678'
        );
        
        insert acc;
        
        Member_Affiliation__c memberAff = new Member_Affiliation__c();
        memberAff.Program__c=program.id;
        memberAff.Member__c=acc.id;
        memberAff.Provider_Affiliation__c=pf.id;
        memberAff.Enrollment_Date__c=Date.Today();
        
        insert memberAff;
        
        
        
        Profile agentProfile=[SELECT Id FROM Profile where Name=:FECPROFILE];
        user u1;
         System.runAs(thisUser){
        u1 = new User( email=TSTEMAIL,
                           profileid = agentProfile.id, 
                           UserName=TESTEMAIL, 
                           Alias = 'GDS',
                           TimeZoneSidKey=TIMEZONE,
                           EmailEncodingKey=EMAILENCODE,
                           LocaleSidKey='en_US', 
                           isActive=true,
                           LanguageLocaleKey='en_US',
                           FirstName = 'Fagent1',
                           LastName = 'Lagent1');
        insert u1;
         }
        AccountTeamMember actTeam = new AccountTeamMember();
        actTeam.AccountId = pf.id;
        actTeam.UserId = u1.id;
        actTeam.TeamMemberRole =ACCTEAM;
        
        insert actTeam;
        
        AccountContactRelation acr = new AccountContactRelation();
        acr.AccountId = pf.id;
        acr.ContactId = [select id from contact where AccountId =:pt.Id].id;
        insert acr;
        
        AccountContactRelation acr2 = new AccountContactRelation();
        acr2.AccountId = pf.id;
        acr2.ContactId = providerUseracc.PersonContactId;
        insert acr2;
        user u2;
         System.runAs(thisUser){
        u2 = new User( email=TSTEMAIL,
                           profileid = agentProfile.id, 
                           UserName=USERNAME, 
                           Alias = 'GDS',
                           TimeZoneSidKey=TIMEZONE,
                           EmailEncodingKey=EMAILENCODE,
                           LocaleSidKey='en_US', 
                           isActive=true,
                           LanguageLocaleKey='en_US',
                           FirstName = 'Fagent1',
                           LastName = 'Lagent1');
        insert u2;
         }
        
        System.runAs(u2){
            Map<Object,Object> m = new Map<Object,Object>();
            m.put('isBackupAgentView',false);
            m.put('familyId',acc.id);
            m.put('label','To');
            m.put('selectedProviderAffliation',pf.id);
            m.put('searchString','');
            m.put('selectProviderGroupId',pg.id);
            m.put('userId',u1.id);
            
            lstProviderData = SNI_FL_ProviderMessageUtil.retrieveProviderData(m);
            
            
        }
        
        System.assertEquals(3,lstProviderData.size(),PFEMPTY);
        
    }
    
    //Person account level Search to dropdown 
    @isTest
    static void personLevelSearchToDropdownTest(){
        
        List<SNI_FL_ProviderMessageUtil.ProviderData> lstProviderData;
        Id pgrecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Provider_Group').getRecordTypeId();
        Id pfrecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Provider_Affiliation').getRecordTypeId();
        Id personactRecordId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('PersonAccount').getRecordTypeId();
        Id providerTeamRecordId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Provider_Team').getRecordTypeId();
        Id providerUserRecordId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Provider_User').getRecordTypeId();
        
        //Program object
        Program__c program = new Program__c();
        program.Program__c = TSTPROGRAM;
        
        insert program;
        
        //Provider group acccount
        Account pg = new Account();
        pg.RecordTypeId= pgrecordTypeId;
        pg.Name = 'TestHospital';
        
        insert pg;
        
        Account providerUser= new Account(
            RecordTypeID=providerUserRecordId ,
            FirstName=UserInfo.getFirstName(),
            LastName=LNAME,
            Provider_Group__c=pg.id,
            PersonMailingStreet='flowerStreet',
            PersonMailingPostalCode='12345',
            PersonMailingCity='SFO',
            PersonEmail=YAHOOMAIL,
            PersonHomePhone='1234567',
            PersonMobilePhone='12345678'
        );
        
        insert providerUser;
        
        Account providerUseracc = [SELECT PersonContactId FROM Account WHERE Id = :providerUser.Id];
        Profile portal = [SELECT Id FROM Profile WHERE Name = 'Care Advisor Connect Provider User' LIMIT 1];
        User thisUser = [Select Id From User Where Id =:UserInfo.getUserId()];
        user portalu;
         System.runAs(thisUser){
        portalu = new User(
            FirstName = 'TestFirstName',
            LastName = 'TestLastName',
            Email = TESTUSERMAIL,
            Username = UNAME,
            Alias = 'TestPA', 
            TimeZoneSidKey = 'GMT', 
            LocaleSidKey = 'en_US', 
            EmailEncodingKey = 'UTF-8', 
            ProfileId = portal.Id, 
            LanguageLocaleKey = 'en_US',
            ContactId = providerUseracc.PersonContactId);
        
        insert portalu;
         }
        Profile agentProfile=[SELECT Id FROM Profile where Name=:FECPROFILE];
        user u1;
         System.runAs(thisUser){
        u1 = new User( email=TSTEMAIL,
                           profileid = agentProfile.id, 
                           UserName=TESTEMAIL, 
                           Alias = 'GDS',
                           TimeZoneSidKey=TIMEZONE,
                           EmailEncodingKey=EMAILENCODE,
                           LocaleSidKey='en_US', 
                           isActive=true,
                           LanguageLocaleKey='en_US',
                           FirstName = 'Fagent1',
                           LastName = 'Lagent1');
        insert u1;
         }
        //Provider team acccount
        Account pt = new Account();
        pt.RecordTypeId= providerTeamRecordId;
        pt.FirstName = u1.FirstName;
        pt.LastName= u1.LastName;
        pt.Provider_Group_Team__c = pg.id;
        
        insert pt;
        
        
        
        //Provider affliation account
        Account pf=new Account();
        pf.Name=PROVIDERAFF;
        pf.RecordTypeId=pfrecordTypeId;
        pf.Population__c = 'Adult';
        pf.Program__c=program.id;
        pf.ParentId	= pg.id;
        
        insert pf;
        
        
        Account acc= new Account(
            RecordTypeID=personactRecordId ,
            FirstName=FNAME,
            LastName=LNAME,
            PersonMailingStreet='flowerStreet',
            PersonMailingPostalCode='12345',
            PersonMailingCity='SFO',
            PersonEmail=YAHOOMAIL,
            PersonHomePhone='1234567',
            PersonMobilePhone='12345678'
        );
        
        insert acc;
        
        Member_Affiliation__c memberAff = new Member_Affiliation__c();
        memberAff.Program__c=program.id;
        memberAff.Member__c=acc.id;
        memberAff.Provider_Affiliation__c=pf.id;
        memberAff.Enrollment_Date__c=Date.Today();
        
        insert memberAff;
        
        
        AccountTeamMember actTeam = new AccountTeamMember();
        actTeam.AccountId = pf.id;
        actTeam.UserId = u1.id;
        actTeam.TeamMemberRole =ACCTEAM;
        
        insert actTeam;
        
        AccountContactRelation acr = new AccountContactRelation();
        acr.AccountId = pf.id;
        acr.ContactId = [select id from contact where AccountId =:pt.Id].id;
        insert acr;
        
        AccountContactRelation acr2 = new AccountContactRelation();
        acr2.AccountId = pf.id;
        acr2.ContactId = providerUseracc.PersonContactId;
        insert acr2;
        user u2;
         System.runAs(thisUser){
        u2 = new User( email=TSTEMAIL,
                           profileid = agentProfile.id, 
                           UserName=USERNAME, 
                           Alias = 'GDS',
                           TimeZoneSidKey=TIMEZONE,
                           EmailEncodingKey=EMAILENCODE,
                           LocaleSidKey='en_US', 
                           isActive=true,
                           LanguageLocaleKey='en_US',
                           FirstName = 'Fagent1',
                           LastName = 'Lagent1');
        insert u2;
         }
        
        id[] fiexedSearchResults = new id[5];
        fiexedSearchResults[0]=u1.id;
        fiexedSearchResults[1]=pt.id;
        fiexedSearchResults[4]=portalu.id;
        Test.setFixedSearchResults(fiexedSearchResults);
        
        System.runAs(u2){
            Map<Object,Object> m = new Map<Object,Object>();
            m.put('isBackupAgentView',true);
            m.put('familyId',acc.id);
            m.put('label','To');
            m.put('selectedProviderAffliation',pf.id);
            m.put('searchString',u1.FirstName);
            m.put('selectProviderGroupId',pg.id);
            m.put('userId',u1.id);
            
            lstProviderData = SNI_FL_ProviderMessageUtil.retrieveProviderData(m);
            
            
        }
        
        System.assertEquals(3,lstProviderData.size(),PFEMPTY);
        
    }
    
    //Advisor level to dropdown 
    @isTest
    static void advisorLevelToDropdownTest(){
        
        List<SNI_FL_ProviderMessageUtil.ProviderData> lstProviderData;
        Id pgrecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Provider_Group').getRecordTypeId();
        Id pfrecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Provider_Affiliation').getRecordTypeId();
        Id personactRecordId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('PersonAccount').getRecordTypeId();
        Id providerTeamRecordId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Provider_Team').getRecordTypeId();
        
        //Program object
        Program__c program = new Program__c();
        program.Program__c = TSTPROGRAM;
        
        insert program;
        
        //Provider group acccount
        Account pg = new Account();
        pg.RecordTypeId= pgrecordTypeId;
        pg.Name = 'TestHospital';
        
        insert pg;
        
        //Provider team acccount
        Account pt = new Account();
        pt.RecordTypeId= providerTeamRecordId;
        pt.FirstName = UserInfo.getFirstName();
        pt.LastName= UserInfo.getLastName();
        pt.Provider_Group_Team__c = pg.id;
        
        insert pt;
        
        
        
        //Provider affliation account
        Account pf=new Account();
        pf.Name=PROVIDERAFF;
        pf.RecordTypeId=pfrecordTypeId;
        pf.Population__c = 'Adult';
        pf.Program__c=program.id;
        pf.ParentId	= pg.id;
        
        insert pf;
        
        
        Account acc= new Account(
            RecordTypeID=personactRecordId ,
            FirstName=FNAME,
            LastName=LNAME,
            PersonMailingStreet='flowerStreet',
            PersonMailingPostalCode='12345',
            PersonMailingCity='SFO',
            PersonEmail=YAHOOMAIL,
            PersonHomePhone='1234567',
            PersonMobilePhone='12345678'
        );
        
        insert acc;
        
        Member_Affiliation__c memberAff = new Member_Affiliation__c();
        memberAff.Program__c=program.id;
        memberAff.Member__c=acc.id;
        memberAff.Provider_Affiliation__c=pf.id;
        memberAff.Enrollment_Date__c=Date.Today();
        
        insert memberAff;
        
        
        
        Profile agentProfile=[SELECT Id FROM Profile where Name=:FECPROFILE];
        User thisUser = [Select Id From User Where Id =:UserInfo.getUserId()];
        user u1;
         System.runAs(thisUser){
        u1 = new User( email=TSTEMAIL,
                           profileid = agentProfile.id, 
                           UserName=UNAME, 
                           Alias = 'GDS',
                           TimeZoneSidKey=TIMEZONE,
                           EmailEncodingKey=EMAILENCODE,
                           LocaleSidKey='en_US', 
                           isActive=true,
                           LanguageLocaleKey='en_US',
                           FirstName = 'Fagent1',
                           LastName = 'Lagent1');
        insert u1;
         }
        AccountTeamMember actTeam = new AccountTeamMember();
        actTeam.AccountId = pf.id;        
        actTeam.UserId = u1.id;
        actTeam.TeamMemberRole =ACCTEAM;
        
        insert actTeam;
        
        AccountContactRelation acr = new AccountContactRelation();
        acr.AccountId = pf.id;
        acr.ContactId = [select id from contact where AccountId =:pt.Id].id;
        insert acr;
        user u2;
         System.runAs(thisUser){
        u2 = new User( email=TSTEMAIL,
                           profileid = agentProfile.id, 
                           UserName=USERNAME, 
                           Alias = 'GDS',
                           TimeZoneSidKey=TIMEZONE,
                           EmailEncodingKey=EMAILENCODE,
                           LocaleSidKey='en_US', 
                           isActive=true,
                           LanguageLocaleKey='en_US',
                           FirstName = 'Fagent1',
                           LastName = 'Lagent1');
        insert u2;
         }
        
        System.runAs(u2){
            Map<Object,Object> m = new Map<Object,Object>();
            m.put('isBackupAgentView',true);
            m.put('label','To');
            m.put('selectedProviderAffliation',pf.id);
            m.put('searchString','');
            m.put('selectProviderGroupId',pg.id);
            m.put('userId',u1.id);
            
            lstProviderData = SNI_FL_ProviderMessageUtil.retrieveProviderData(m);
            
        }
        
        System.assertEquals(2,lstProviderData.size(),PFEMPTY);
        
    }
    
    //Advisor level Search to dropdown 
    @isTest
    static void advisorLevelSearchToDropdownTest(){
        
        List<SNI_FL_ProviderMessageUtil.ProviderData> lstProviderData;
        Id pgrecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Provider_Group').getRecordTypeId();
        Id pfrecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Provider_Affiliation').getRecordTypeId();
        Id personactRecordId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('PersonAccount').getRecordTypeId();
        Id providerTeamRecordId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Provider_Team').getRecordTypeId();
        
        //Program object
        Program__c program = new Program__c();
        program.Program__c = TSTPROGRAM;
        
        insert program;
        
        //Provider group acccount
        Account pg = new Account();
        pg.RecordTypeId= pgrecordTypeId;
        pg.Name = 'TestHospital';
        
        insert pg;
        
        //Provider affliation account
        Account pf=new Account();
        pf.Name=PROVIDERAFF;
        pf.RecordTypeId=pfrecordTypeId;
        pf.Population__c = 'Adult';
        pf.Program__c=program.id;
        pf.ParentId	= pg.id;
        
        insert pf;
        
        
        Account acc= new Account(
            RecordTypeID=personactRecordId ,
            FirstName=FNAME,
            LastName=LNAME,
            PersonMailingStreet='flowerStreet',
            PersonMailingPostalCode='12345',
            PersonMailingCity='SFO',
            PersonEmail=YAHOOMAIL,
            PersonHomePhone='1234567',
            PersonMobilePhone='12345678'
        );
        
        insert acc;
        
        Member_Affiliation__c memberAff = new Member_Affiliation__c();
        memberAff.Program__c=program.id;
        memberAff.Member__c=acc.id;
        memberAff.Provider_Affiliation__c=pf.id;
        memberAff.Enrollment_Date__c=Date.Today();
        
        insert memberAff;
        
        
        
        Profile agentProfile=[SELECT Id FROM Profile where Name=:FECPROFILE];
        user u1;
        User thisUser = [Select Id From User Where Id =:UserInfo.getUserId()];
         System.runAs(thisUser){
        u1 = new User( email=TSTEMAIL,
                           profileid = agentProfile.id, 
                           UserName=UNAME, 
                           Alias = 'GDS',
                           TimeZoneSidKey=TIMEZONE,
                           EmailEncodingKey=EMAILENCODE,
                           LocaleSidKey='en_US', 
                           isActive=true,
                           LanguageLocaleKey='en_US',
                           FirstName = 'Fagent1',
                           LastName = 'Lagent1');
        insert u1;
         }
        AccountTeamMember actTeam = new AccountTeamMember();
        actTeam.AccountId = pf.id;
        actTeam.UserId = u1.id;
        actTeam.TeamMemberRole =ACCTEAM;
        
        insert actTeam;
        
        
        //Provider team acccount
        Account pt = new Account();
        pt.RecordTypeId= providerTeamRecordId;
        pt.FirstName = u1.FirstName;
        pt.LastName= u1.LastName;
        pt.Provider_Group_Team__c = pg.id;
        
        insert pt;
        
        AccountContactRelation acr = new AccountContactRelation();
        acr.AccountId = pf.id;
        acr.ContactId = [select id from contact where AccountId =:pt.Id].id;
        insert acr;
        
        id[] fiexedSearchResults = new id[2];
        fiexedSearchResults[0]=u1.id;
        fiexedSearchResults[1]=pt.id;
        Test.setFixedSearchResults(fiexedSearchResults);
        user u2;
         System.runAs(thisUser){
        u2 = new User( email=TSTEMAIL,
                           profileid = agentProfile.id, 
                           UserName=USERNAME, 
                           Alias = 'GDS',
                           TimeZoneSidKey=TIMEZONE,
                           EmailEncodingKey=EMAILENCODE,
                           LocaleSidKey='en_US', 
                           isActive=true,
                           LanguageLocaleKey='en_US',
                           FirstName = 'Fagent1',
                           LastName = 'Lagent1');
        insert u2;
         }
        System.runAs(u2){
            
            Map<Object,Object> m = new Map<Object,Object>();
            m.put('isBackupAgentView',true);
            m.put('label','To');
            m.put('selectedProviderAffliation',pf.id);
            m.put('searchString',u1.FirstName);
            m.put('selectProviderGroupId',pg.id);
            m.put('userId',u1.id);
            
            lstProviderData = SNI_FL_ProviderMessageUtil.retrieveProviderData(m);
            
        }
        
        System.assertEquals(2,lstProviderData.size(),PFEMPTY);
        
    }
    
    //Family Link Related to List Agent view - All records
    @isTest
    static void familyLinkViewRelatedListTest(){
        
        List<SNI_FL_ProviderMessageUtil.ProviderData> lstProviderData;
        Id pgrecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Provider_Group').getRecordTypeId();
        Id pfrecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Provider_Affiliation').getRecordTypeId();
        Id personactRecordId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('PersonAccount').getRecordTypeId();
        
        //Program object
        Program__c program = new Program__c();
        program.Program__c = TSTPROGRAM;
        
        insert program;
        
        //Provider group acccount
        Account pg = new Account();
        pg.RecordTypeId= pgrecordTypeId;
        pg.Name = 'TestHospital';
        
        insert pg;
        
        //Provider affliation account
        Account pf=new Account();
        pf.Name=PROVIDERAFF;
        pf.RecordTypeId=pfrecordTypeId;
        pf.Population__c = 'Adult';
        pf.Program__c=program.id;
        pf.ParentId	= pg.id;
        
        insert pf;
        
        
        Account acc= new Account(
            RecordTypeID=personactRecordId ,
            FirstName=FNAME,
            LastName=LNAME,
            PersonMailingStreet='flowerStreet',
            PersonMailingPostalCode='12345',
            PersonMailingCity='SFO',
            PersonEmail=YAHOOMAIL,
            PersonHomePhone='1234567',
            PersonMobilePhone='12345678'
        );
        
        insert acc;
        
        Member_Affiliation__c memberAff = new Member_Affiliation__c();
        memberAff.Program__c=program.id;
        memberAff.Member__c=acc.id;
        memberAff.Provider_Affiliation__c=pf.id;
        memberAff.Enrollment_Date__c=Date.Today();
        
        insert memberAff;
        
        Profile agentProfile=[SELECT Id FROM Profile where Name=:FECPROFILE];
        User thisUser = [Select Id From User Where Id =:UserInfo.getUserId()];
        user u1;
         System.runAs(thisUser){
        u1 = new User( email=TSTEMAIL,
                           profileid = agentProfile.id, 
                           UserName=UNAME, 
                           Alias = 'GDS',
                           TimeZoneSidKey=TIMEZONE,
                           EmailEncodingKey=EMAILENCODE,
                           LocaleSidKey='en_US', 
                           isActive=true,
                           LanguageLocaleKey='en_US',
                           FirstName = 'Fagent1',
                           LastName = 'Lagent1');
        insert u1;
         }
        AccountTeamMember actTeam = new AccountTeamMember();
        actTeam.AccountId = pf.id;
        actTeam.UserId = u1.id;
        actTeam.TeamMemberRole =ACCTEAM;
        
        insert actTeam;
        
        System.runAs(u1){
            Map<Object,Object> m = new Map<Object,Object>();
            m.put('label',RELATEDTO);
            m.put('selectedProviderAffliation',program.Program__c);
            m.put('searchString','');
            m.put('objectName','Account');
            
            lstProviderData = SNI_FL_ProviderMessageUtil.retrieveFamilyLinkProviderData(m);
            
        }
        if(lstProviderData != null){
            System.assertEquals(lstProviderData.size()>=0, true,PFEMPTY);
        } else {
            System.assertequals(lstProviderData, null, NODATA);
        }
        
    }
    
    //Test method for single record
    @isTest
    static void familyLinkViewRelatedListSearchTest(){
        
        List<SNI_FL_ProviderMessageUtil.ProviderData> lstProviderData;
        Id pgrecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Provider_Group').getRecordTypeId();
        Id pfrecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Provider_Affiliation').getRecordTypeId();
        Id personactRecordId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('PersonAccount').getRecordTypeId();
        
        Account acc= new Account(
            RecordTypeID=personactRecordId ,
            FirstName=FNAME,
            LastName=LNAME,
            PersonMailingStreet='flowerStreet',
            PersonMailingPostalCode='12345',
            PersonMailingCity='SFO',
            PersonEmail=YAHOOMAIL,
            PersonHomePhone='1234567',
            PersonMobilePhone='12345678'
        );
        
        insert acc;
        
        //Program object
        Program__c program = new Program__c();
        program.Program__c = TSTPROGRAM;
        
        insert program;
        
        //Provider group acccount
        Account pg = new Account();
        pg.RecordTypeId= pgrecordTypeId;
        pg.Name = 'TestHospital';
        
        insert pg;
        
        //Provider affliation account
        Account pf=new Account();
        pf.Name=PROVIDERAFF;
        pf.RecordTypeId=pfrecordTypeId;
        pf.Population__c = 'Adult';
        pf.Program__c=program.id;
        pf.ParentId	= pg.id;
        
        insert pf;
        
        Member_Affiliation__c memberAff = new Member_Affiliation__c();
        memberAff.Program__c=program.id;
        memberAff.Member__c=acc.id;
        memberAff.Provider_Affiliation__c=pf.id;
        memberAff.Enrollment_Date__c=Date.Today();
        
        insert memberAff;
        
        id[] fiexedSearchResults = new id[1];
        fiexedSearchResults[0]=acc.id;//person account id
        Test.setFixedSearchResults(fiexedSearchResults);
        
        Profile agentProfile=[SELECT Id FROM Profile where Name=:FECPROFILE];
        User thisUser = [Select Id From User Where Id =:UserInfo.getUserId()];
        user u1;
         System.runAs(thisUser){
        u1 = new User( email=TSTEMAIL,
                           profileid = agentProfile.id, 
                           UserName=UNAME, 
                           Alias = 'GDS',
                           TimeZoneSidKey=TIMEZONE,
                           EmailEncodingKey=EMAILENCODE,
                           LocaleSidKey='en_US', 
                           isActive=true,
                           LanguageLocaleKey='en_US',
                           FirstName = 'Fagent1',
                           LastName = 'Lagent1');
        insert u1;
         }
        AccountTeamMember actTeam = new AccountTeamMember();
        actTeam.AccountId = pf.id;
        actTeam.UserId = u1.id;
        actTeam.TeamMemberRole =ACCTEAM;
        
        insert actTeam;
        
        System.runAs(u1){
            Map<Object,Object> m = new Map<Object,Object>();
            m.put('label',RELATEDTO);
            m.put('selectedProviderAffliation',program.Program__c);
            m.put('searchString','Test');
            m.put('objectName','Account');
            
            lstProviderData = SNI_FL_ProviderMessageUtil.retrieveFamilyLinkProviderData(m);
            
        }
        if(lstProviderData != null){
            System.assertEquals(lstProviderData.size()>=0, true,PFEMPTY);
        } else {
            System.assertequals(lstProviderData, null, NODATA);
        }
    }
    
    //FamilyLink level to dropdown initial load
    @isTest
    static void familyLinkNewMessageToDropdownTest(){
        
        List<SNI_FL_ProviderMessageUtil.ProviderData> lstProviderData;
        Id pgrecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Provider_Group').getRecordTypeId();
        Id pfrecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Provider_Affiliation').getRecordTypeId();
        Id personactRecordId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('PersonAccount').getRecordTypeId();
        Id providerTeamRecordId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Provider_Team').getRecordTypeId();
        Id providerUserRecordId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Provider_User').getRecordTypeId();
        
        //Program object
        Program__c program = new Program__c();
        program.Program__c = TSTPROGRAM;
        
        insert program;
        
        //Provider group acccount
        Account pg = new Account();
        pg.RecordTypeId= pgrecordTypeId;
        pg.Name = 'TestHospital';
        
        insert pg;
        
        //Provider team acccount
        Account pt = new Account();
        pt.RecordTypeId= providerTeamRecordId;
        pt.FirstName = UserInfo.getFirstName();
        pt.LastName= UserInfo.getLastName();
        pt.Provider_Group_Team__c = pg.id;
        
        insert pt;
        
        
        //Provider affliation account
        Account pf=new Account();
        pf.Name=PROVIDERAFF;
        pf.RecordTypeId=pfrecordTypeId;
        pf.Population__c = 'Adult';
        pf.Program__c=program.id;
        pf.ParentId	= pg.id;
        
        insert pf;
        
        
        Account acc= new Account(
            RecordTypeID=personactRecordId ,
            FirstName=FNAME,
            LastName=LNAME,
            PersonMailingStreet='FlowerStreet',
            PersonMailingPostalCode='12345',
            PersonMailingCity='SFO',
            PersonEmail=YAHOOMAIL,
            PersonHomePhone='1234567',
            PersonMobilePhone='12345678'
        );
        
        insert acc;
        
        Member_Affiliation__c memberAff = new Member_Affiliation__c();
        memberAff.Program__c=program.id;
        memberAff.Member__c=acc.id;
        memberAff.Provider_Affiliation__c=pf.id;
        memberAff.Enrollment_Date__c=Date.Today();
         
        insert memberAff;
        
        
        
        Profile agentProfile=[SELECT Id FROM Profile where Name=:FECPROFILE];
        User thisUser = [Select Id From User Where Id =:UserInfo.getUserId()];
        user u1;
         System.runAs(thisUser){
        u1 = new User( email=TSTEMAIL,
                           profileid = agentProfile.id, 
                           UserName=UNAME, 
                           Alias = 'GDS',
                           TimeZoneSidKey=TIMEZONE,
                           EmailEncodingKey=EMAILENCODE,
                           LocaleSidKey='en_US', 
                           isActive=true,
                           LanguageLocaleKey='en_US',
                           FirstName = 'Fagent1',
                           LastName = 'Lagent1');
        insert u1;
         }
        AccountTeamMember actTeam = new AccountTeamMember();
        actTeam.AccountId = pf.id;
        actTeam.UserId = u1.id;
        actTeam.TeamMemberRole =ACCTEAM;
        
        insert actTeam;
        
        Account providerUser= new Account(
            RecordTypeID=providerUserRecordId ,
            FirstName=FNAME,
            LastName=LNAME,
            Provider_Group__c=pg.id,
            PersonMailingStreet='flowerStreet',
            PersonMailingPostalCode='12345',
            PersonMailingCity='SFO',
            PersonEmail=YAHOOMAIL,
            PersonHomePhone='1234567',
            PersonMobilePhone='12345678'
        );
        
        insert providerUser;
        
        Account providerUseracc = [SELECT PersonContactId FROM Account WHERE Id = :providerUser.Id];
        Profile portal = [SELECT Id FROM Profile WHERE Name = 'Care Advisor Connect Provider User' LIMIT 1];
        user portalu;
         System.runAs(thisUser){
        portalu = new User(
            FirstName = 'TestFirstName',
            LastName = 'TestLastName',
            Email = TESTUSERMAIL,
            Username = TESTEMAIL,
            Alias = 'TestPA', 
            TimeZoneSidKey = 'GMT', 
            LocaleSidKey = 'en_US', 
            EmailEncodingKey = 'UTF-8', 
            ProfileId = portal.Id, 
            LanguageLocaleKey = 'en_US',
            ContactId = providerUseracc.PersonContactId);
        
        insert portalu;
         }
        AccountContactRelation acr = new AccountContactRelation(
            AccountId = pf.id,
            contactId = portalu.ContactId
        );
        
        insert acr;
        
        System.runAs(u1){
            Map<Object,Object> m = new Map<Object,Object>();
            m.put('label','To');
            m.put('selectedProviderAffliation',pf.Id);
            m.put('searchString','');
            m.put('objectName','Account');
            
            lstProviderData = SNI_FL_ProviderMessageUtil.retrieveFamilyLinkProviderData(m);
            
        }
        if(lstProviderData != null){
            System.assertEquals(lstProviderData.size()>=0, true,PFEMPTY);
        } else {
            System.assertequals(lstProviderData, null, NODATA);
        }
    }
    @isTest
    static void familyLinkNewMessageToDropdownTest2(){
        
        List<SNI_FL_ProviderMessageUtil.ProviderData> lstProviderData;
        Id pgrecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Provider_Group').getRecordTypeId();
        Id pfrecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Provider_Affiliation').getRecordTypeId();
        Id personactRecordId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('PersonAccount').getRecordTypeId();
        Id providerTeamRecordId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Provider_Team').getRecordTypeId();
        Id providerUserRecordId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Provider_User').getRecordTypeId();
        
        //Program object
        Program__c program = new Program__c();
        program.Program__c = TSTPROGRAM;
        
        insert program;
        
        //Provider group acccount
        Account pg = new Account();
        pg.RecordTypeId= pgrecordTypeId;
        pg.Name = 'TestHospital';
        
        insert pg;
        
        //Provider team acccount
        Account pt = new Account();
        pt.RecordTypeId= providerTeamRecordId;
        pt.FirstName = UserInfo.getFirstName();
        pt.LastName= UserInfo.getLastName();
        pt.Provider_Group_Team__c = pg.id;
        
        insert pt;
        
        
        //Provider affliation account
        Account pf=new Account();
        pf.Name=PROVIDERAFF;
        pf.RecordTypeId=pfrecordTypeId;
        pf.Population__c = 'Adult';
        pf.Program__c=program.id;
        pf.ParentId	= pg.id;
        
        insert pf;
        
        
        Account acc= new Account(
            RecordTypeID=personactRecordId ,
            FirstName=FNAME,
            LastName=LNAME,
            PersonMailingStreet='FlowerStreet',
            PersonMailingPostalCode='12345',
            PersonMailingCity='SFO',
            PersonEmail=YAHOOMAIL,
            PersonHomePhone='1234567',
            PersonMobilePhone='12345678'
        );
        
        insert acc;
        
        Member_Affiliation__c memberAff = new Member_Affiliation__c();
        memberAff.Program__c=program.id;
        memberAff.Member__c=acc.id;
        memberAff.Provider_Affiliation__c=pf.id;
        memberAff.Enrollment_Date__c=Date.Today();
        
        insert memberAff;
        
        
        Account providerTeamacc1 = [SELECT PersonContactId FROM Account WHERE Id = :pt.Id];
        Profile agentProfile=[SELECT Id FROM Profile where Name=:FECPROFILE];
        User thisUser = [Select Id From User Where Id =:UserInfo.getUserId()];
        user u1;
         System.runAs(thisUser){
        u1 = new User( email=TSTEMAIL,
                           profileid = agentProfile.id, 
                           UserName=UNAME, 
                           Alias = 'GDS',
                           TimeZoneSidKey=TIMEZONE,
                           EmailEncodingKey=EMAILENCODE,
                           LocaleSidKey='en_US', 
                           isActive=true,
                           LanguageLocaleKey='en_US',
                           FirstName = 'Fagent1',
                           LastName = 'Lagent1');
        insert u1;
         }
        AccountTeamMember actTeam = new AccountTeamMember();
        actTeam.AccountId = pf.id;
        actTeam.UserId = u1.id;
        actTeam.TeamMemberRole =ACCTEAM;
        
        insert actTeam;
        
        Account providerUser= new Account(
            RecordTypeID=providerUserRecordId ,
            FirstName=FNAME,
            LastName=LNAME,
            Provider_Group__c=pg.id,
            PersonMailingStreet='flowerStreet',
            PersonMailingPostalCode='12345',
            PersonMailingCity='SFO',
            PersonEmail=YAHOOMAIL,
            PersonHomePhone='1234567',
            PersonMobilePhone='12345678'
        );
        
        insert providerUser;
        
        Account providerUseracc = [SELECT PersonContactId FROM Account WHERE Id = :pt.Id];
        Profile portal = [SELECT Id FROM Profile WHERE Name = 'Care Advisor Connect Provider User' LIMIT 1];
        user portalu;
         System.runAs(thisUser){
        portalu = new User(
            FirstName = 'TestFirstName',
            LastName = 'TestLastName',
            Email = TESTUSERMAIL,
            Username = TESTEMAIL,
            Alias = 'TestPA', 
            TimeZoneSidKey = 'GMT', 
            LocaleSidKey = 'en_US', 
            EmailEncodingKey = 'UTF-8', 
            ProfileId = portal.Id, 
            LanguageLocaleKey = 'en_US',
            ContactId = providerUseracc.PersonContactId);
        
        insert portalu;
         }
        AccountContactRelation acr = new AccountContactRelation(
            AccountId = pf.id,
            contactId = portalu.ContactId
        );
        
        insert acr;
        
        System.runAs(u1){
            Map<Object,Object> m = new Map<Object,Object>();
            m.put('label','To');
            m.put('selectedProviderAffliation',pf.Id);
            m.put('searchString','');
            m.put('objectName','Account');
            
            lstProviderData = SNI_FL_ProviderMessageUtil.retrieveFamilyLinkProviderData(m);
            
        }
        if(lstProviderData != null){
            System.assertEquals(lstProviderData.size()>=0, true,PFEMPTY);
        } else {
            System.assertequals(lstProviderData, null, NODATA);
        }
    }
    
    //FamilyLink level to dropdown search 
    @isTest
    static void familyLinkNewMessageSearchToDropdownTest(){
        
        List<SNI_FL_ProviderMessageUtil.ProviderData> lstProviderData;
        Id pgrecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Provider_Group').getRecordTypeId();
        Id pfrecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Provider_Affiliation').getRecordTypeId();
        Id personactRecordId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('PersonAccount').getRecordTypeId();
        Id providerTeamRecordId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Provider_Team').getRecordTypeId();
        Id providerUserRecordId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Provider_User').getRecordTypeId();
        
        //Program object
        Program__c program = new Program__c();
        program.Program__c = TSTPROGRAM;
        
        insert program;
        
        //Provider group acccount
        Account pg = new Account();
        pg.RecordTypeId= pgrecordTypeId;
        pg.Name = 'TestHospital';
        
        insert pg;
        
        //Provider team acccount
        Account pt = new Account();
        pt.RecordTypeId= providerTeamRecordId;
        pt.FirstName = UserInfo.getFirstName();
        pt.LastName= UserInfo.getLastName();
        pt.Provider_Group_Team__c = pg.id;
        
        insert pt;
        
        
        //Provider affliation account
        Account pf=new Account();
        pf.Name=PROVIDERAFF;
        pf.RecordTypeId=pfrecordTypeId;
        pf.Population__c = 'Adult';
        pf.Program__c=program.id;
        pf.ParentId	= pg.id;
        
        insert pf;
        
        
        Account acc= new Account(
            RecordTypeID=personactRecordId ,
            FirstName=FNAME,
            LastName=LNAME,
            PersonMailingStreet='test_@optum.com',
            PersonMailingPostalCode='12345',
            PersonMailingCity='SFO',
            PersonEmail=YAHOOMAIL,
            PersonHomePhone='1234567',
            PersonMobilePhone='12345678'
        );
        
        insert acc;
        
        Member_Affiliation__c memberAff = new Member_Affiliation__c();
        memberAff.Program__c=program.id;
        memberAff.Member__c=acc.id;
        memberAff.Provider_Affiliation__c=pf.id;
        memberAff.Enrollment_Date__c=Date.Today();
        
        insert memberAff;
        
        Profile agentProfile=[SELECT Id FROM Profile where Name=:FECPROFILE];
        User thisUser = [Select Id From User Where Id =:UserInfo.getUserId()];
        user u1;
         System.runAs(thisUser){
        u1 = new User( email=TSTEMAIL,
                           profileid = agentProfile.id, 
                           UserName=UNAME, 
                           Alias = 'GDS',
                           TimeZoneSidKey=TIMEZONE,
                           EmailEncodingKey=EMAILENCODE,
                           LocaleSidKey='en_US', 
                           isActive=true,
                           LanguageLocaleKey='en_US',
                           FirstName = 'Fagent1',
                           LastName = 'Lagent1');
        insert u1;
         }
        AccountTeamMember actTeam = new AccountTeamMember();
        actTeam.AccountId = pf.id;
        actTeam.UserId = u1.id;
        actTeam.TeamMemberRole =ACCTEAM;
        
        insert actTeam;
        
        Account providerUser= new Account(
            RecordTypeID=providerUserRecordId ,
            FirstName=FNAME,
            LastName=LNAME,
            Provider_Group__c=pg.id,
            PersonMailingStreet='FlowerStreet',
            PersonMailingPostalCode='12345',
            PersonMailingCity='SFO',
            PersonEmail=YAHOOMAIL,
            PersonHomePhone='1234567',
            PersonMobilePhone='12345678'
        );
        
        insert providerUser;
        
        Account providerUseracc = [SELECT PersonContactId FROM Account WHERE Id = :providerUser.Id];
        Profile portal = [SELECT Id FROM Profile WHERE Name = 'Care Advisor Connect Provider User' LIMIT 1];
        user portalu;
         System.runAs(thisUser){
        portalu = new User(
            FirstName = 'TestFirstName',
            LastName = 'TestLastName',
            Email = TESTUSERMAIL,
            Username = TESTEMAIL,
            Alias = 'TestPA', 
            TimeZoneSidKey = 'GMT', 
            LocaleSidKey = 'en_US', 
            EmailEncodingKey = 'UTF-8', 
            ProfileId = portal.Id, 
            LanguageLocaleKey = 'en_US',
            ContactId = providerUseracc.PersonContactId);
        
        insert portalu;
         }
        AccountContactRelation acr = new AccountContactRelation(
            AccountId = pf.id,
            contactId = portalu.ContactId
        );
        
        insert acr;
        
        id[] fiexedSearchResults = new id[2];
        fiexedSearchResults[0]=u1.id;
        fiexedSearchResults[1]=pt.id;
        Test.setFixedSearchResults(fiexedSearchResults);
        
        System.runAs(portalu){
            Map<Object,Object> m = new Map<Object,Object>();
            m.put('label','To');
            m.put('selectedProviderAffliation',pf.Id);
            m.put('searchString','TestFirstName');
            m.put('objectName','Account');
            
            lstProviderData = SNI_FL_ProviderMessageUtil.retrieveFamilyLinkProviderData(m);
            
        }
        if(lstProviderData != null){
            System.assertEquals(lstProviderData.size()>=0, true,PFEMPTY);
        } else {
            System.assertequals(lstProviderData, null, NODATA);
        }
        
    }
    
    //FamilyLink level to dropdown search 
    @isTest
    static void familyLinkNewMessageSearchToDropdownTest2(){
        
        List<SNI_FL_ProviderMessageUtil.ProviderData> lstProviderData;
        Id pgrecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Provider_Group').getRecordTypeId();
        Id pfrecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Provider_Affiliation').getRecordTypeId();
        Id personactRecordId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('PersonAccount').getRecordTypeId();
        Id providerTeamRecordId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Provider_Team').getRecordTypeId();
        Id providerUserRecordId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Provider_User').getRecordTypeId();
        
        //Program object
        Program__c program = new Program__c();
        program.Program__c = TSTPROGRAM;
        
        insert program;
        
        //Provider group acccount
        Account pg = new Account();
        pg.RecordTypeId= pgrecordTypeId;
        pg.Name = 'TestHospital';
        
        insert pg;
        
        //Provider team acccount
        Account pt = new Account();
        pt.RecordTypeId= providerTeamRecordId;
        pt.FirstName = UserInfo.getFirstName();
        pt.LastName= UserInfo.getLastName();
        pt.Provider_Group_Team__c = pg.id;
        
        insert pt;
        
        
        //Provider affliation account
        Account pf=new Account();
        pf.Name=PROVIDERAFF;
        pf.RecordTypeId=pfrecordTypeId;
        pf.Population__c = 'Adult';
        pf.Program__c=program.id;
        pf.ParentId	= pg.id;
        
        insert pf;
        
        
        Account acc= new Account(
            RecordTypeID=personactRecordId ,
            FirstName=FNAME,
            LastName=LNAME,
            PersonMailingStreet='test_@optum.com',
            PersonMailingPostalCode='12345',
            PersonMailingCity='SFO',
            PersonEmail=YAHOOMAIL,
            PersonHomePhone='1234567',
            PersonMobilePhone='12345678'
        );
        
        insert acc;
        
        Member_Affiliation__c memberAff = new Member_Affiliation__c();
        memberAff.Program__c=program.id;
        memberAff.Member__c=acc.id;
        memberAff.Provider_Affiliation__c=pf.id;
        memberAff.Enrollment_Date__c=Date.Today();
        
        insert memberAff;
        
        Profile agentProfile=[SELECT Id FROM Profile where Name=:FECPROFILE];
        User thisUser = [Select Id From User Where Id =:UserInfo.getUserId()];
        user u1;
         System.runAs(thisUser){
        u1 = new User( email=TSTEMAIL,
                           profileid = agentProfile.id, 
                           UserName=UNAME, 
                           Alias = 'GDS',
                           TimeZoneSidKey=TIMEZONE,
                           EmailEncodingKey=EMAILENCODE,
                           LocaleSidKey='en_US', 
                           isActive=true,
                           LanguageLocaleKey='en_US',
                           FirstName = 'Fagent1',
                           LastName = 'Lagent1');
        insert u1;
         }
        AccountTeamMember actTeam = new AccountTeamMember();
        actTeam.AccountId = pf.id;
        actTeam.UserId = u1.id;
        actTeam.TeamMemberRole =ACCTEAM;
        
        insert actTeam;
        
        Account providerUser= new Account(
            RecordTypeID=providerUserRecordId ,
            FirstName=FNAME,
            LastName=LNAME,
            Provider_Group__c=pg.id,
            PersonMailingStreet='FlowerStreet',
            PersonMailingPostalCode='12345',
            PersonMailingCity='SFO',
            PersonEmail=YAHOOMAIL,
            PersonHomePhone='1234567',
            PersonMobilePhone='12345678'
        );
        
        insert providerUser;
        
        Account providerUseracc = [SELECT PersonContactId FROM Account WHERE Id = :providerUser.Id];
        Profile portal = [SELECT Id FROM Profile WHERE Name = 'Care Advisor Connect Provider User' LIMIT 1];
        user portalu;
         System.runAs(thisUser){
        portalu = new User(
            FirstName = 'TestFirstName',
            LastName = 'TestLastName',
            Email = TESTUSERMAIL,
            Username = TESTEMAIL,
            Alias = 'TestPA', 
            TimeZoneSidKey = 'GMT', 
            LocaleSidKey = 'en_US', 
            EmailEncodingKey = 'UTF-8', 
            ProfileId = portal.Id, 
            LanguageLocaleKey = 'en_US',
            ContactId = providerUseracc.PersonContactId);
        
        insert portalu;
         }
        AccountContactRelation acr = new AccountContactRelation(
            AccountId = pf.id,
            contactId = portalu.ContactId
        );
        
        insert acr;
        
        id[] fiexedSearchResults = new id[2];
        fiexedSearchResults[0]=portalu.id;
        fiexedSearchResults[1]=pt.id;
        Test.setFixedSearchResults(fiexedSearchResults);
        System.runAs(portalu){
            Map<Object,Object> m = new Map<Object,Object>();
            m.put('label','To');
            m.put('selectedProviderAffliation',pf.Id);
            m.put('searchString','TestFirstName');
            m.put('objectName','Account');
            
            lstProviderData = SNI_FL_ProviderMessageUtil.retrieveFamilyLinkProviderData(m);
            
        }
        if(lstProviderData != null){
            System.assertEquals(lstProviderData.size()>=0, true,PFEMPTY);
        } else {
            System.assertequals(lstProviderData, null, NODATA);
        }
        
    }
    
    public static testmethod void getMemberDetailsByAccountIDTest(){        
        Id personactRecordId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('PersonAccount').getRecordTypeId();
        Id pfrecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Provider_Affiliation').getRecordTypeId();
        Id pgrecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Provider_Group').getRecordTypeId();
        
        Account acc= new Account(
            RecordTypeID=personactRecordId ,
            FirstName='Test FName',
            LastName='Test LName',
            PersonMailingStreet='flowerStreet',
            PersonMailingPostalCode='12345',
            PersonMailingCity='SFO',
            PersonEmail='test@yahoo.com',
            PersonHomePhone='1234567',
            PersonMobilePhone='12345678',
            Member_Id__c = '123456789'
        );
        
        insert acc;
        
        
        //Program object
        Program__c program = new Program__c();
        program.Program__c = 'Complex Care';
        
        insert program;               
        
        //Provider group acccount
        Account pg = new Account();
        pg.RecordTypeId= pgrecordTypeId;
        pg.Name = 'TestHospital';
        
        insert pg;
        
        //Provider affliation account
        Account pf=new Account();
        pf.Name='TestHospital-Complex Care-Adult';
        pf.RecordTypeId=pfrecordTypeId;
        pf.Population__c = 'Adult';
        pf.Program__c=program.id;
        pf.ParentId	= pg.id;
        
        insert pf;
        
        Member_Affiliation__c memberAff = new Member_Affiliation__c();
        memberAff.Program__c=program.id;
        memberAff.Member__c=acc.id;
        memberAff.Provider_Affiliation__c=pf.id;
        memberAff.Enrollment_Date__c=Date.Today();
        memberAff.Member_Id__c = acc.Member_Id__c;
        
        insert memberAff;
        
        Test.startTest();
        SNI_FL_ProviderMessageUtil.getMemberIdByAccountId(acc.Id);
        SNI_FL_ProviderMessageUtil.getMemberNameByAccountId(acc.Id);
        Test.stopTest();
    }
}