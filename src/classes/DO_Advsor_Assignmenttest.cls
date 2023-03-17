@isTest
public class DO_Advsor_Assignmenttest {
    @testsetup
    public static void settestup(){
         UserRole portalRole = [Select Id From UserRole Where PortalType = 'None' Limit 1];
        Profile profile1 = [Select Id from Profile where name = 'System Administrator'];
        User portalAccountOwner1 = new User(
            UserRoleId = portalRole.Id,
            ProfileId = profile1.Id,
            Username = System.now().millisecond() + 'zzznpDOadv99trig@optum.com.acet',
            Alias = 'batman',
            Email='zzznpzDOadvtrig@optum.com.acet',
            EmailEncodingKey='UTF-8',
            Firstname='yarroat',
            Lastname='yavanoat',
            LanguageLocaleKey='en_US',
            LocaleSidKey='en_US',
            TimeZoneSidKey='America/Chicago');
        Database.insert(portalAccountOwner1);
        System.runAs ( portalAccountOwner1 ){
            Round_Robin_Queue__c rrq = new Round_Robin_Queue__c();
            rrq.Last_Assigned_Advisor__c = '';
            insert rrq;
            User user = new User();
            user.UserRoleID = [Select Id From UserRole Where Name = 'FEC - Family Advisor - UHG' Limit 1].id;
            user.ProfileID = [Select Id From Profile Where Name='Center for Health Navigation'].id;
            user.EmailEncodingKey = 'ISO-8859-1';
            user.LanguageLocaleKey = 'en_US';
            user.TimeZoneSidKey = 'America/New_York';
            user.LocaleSidKey = 'en_US';
            user.FirstName = 'advonet';
            user.LastName = 'advonet';
            user.Username = 'ABCD1234DOadva99t@optum.com.acet';
            user.CommunityNickname = 'testUser123radv99t';
            user.Alias = 't11';
            user.Email = 'noyarroDOadva99t@optum.com.acet';
            user.IsActive = true;
            insert user;
            User user1 = new User();
            user1.UserRoleID = [Select Id From UserRole Where Name = 'FEC - Family Advisor - UHG' Limit 1].id;
            user1.ProfileID = [Select Id From Profile Where Name='Center for Health Navigation'].id;
            user1.EmailEncodingKey = 'ISO-8859-1';
            user1.LanguageLocaleKey = 'en_US';
            user1.TimeZoneSidKey = 'America/New_York';
            user1.LocaleSidKey = 'en_US';
            user1.FirstName = 'advtwot';
            user1.LastName = 'advtwot';
            user1.Username = 'ABCD1234DOadva99t1@optum.com.acet';
            user1.CommunityNickname = 'testUser123radv99t1';
            user1.Alias = 't12';
            user1.Email = 'noyarroDOadva99t1@optum.com.acet';
            user1.IsActive = true;
            insert user1;
            DigitalOnboardingAdvisorAssignment__c doa = new DigitalOnboardingAdvisorAssignment__c();
            doa.Name__c = user.Id;
            insert doa;
            DigitalOnboardingAdvisorAssignment__c doa1 = new DigitalOnboardingAdvisorAssignment__c();
            doa1.Name__c = user1.Id;
            insert doa1;
            User user2 = new User();
            user2.UserRoleID = [Select Id From UserRole Where Name = 'FEC - Family Advisor - UHG' Limit 1].id;
            user2.ProfileID = [Select Id From Profile Where Name='Center for Health Navigation'].id;
            user2.EmailEncodingKey = 'ISO-8859-1';
            user2.LanguageLocaleKey = 'en_US';
            user2.TimeZoneSidKey = 'America/New_York';
            user2.LocaleSidKey = 'en_US';
            user2.FirstName = 'advthreet';
            user2.LastName = 'advthreet';
            user2.Username = 'ABCD1234DOadva99t2@optum.com.acet';
            user2.CommunityNickname = 'testUser123radv99t2';
            user2.Alias = 't13';
            user2.Email = 'noyarroDOadva99t2@optum.com.acet';
            user2.IsActive = true;
            insert user2;
            DigitalOnboardingAdvisorAssignment__c doa2 = new DigitalOnboardingAdvisorAssignment__c();
            doa2.Name__c = user2.Id;
            insert doa2;
        }
    }
	@isTest
    public static void getCovered(){
        UserRole portalRole = [Select Id From UserRole Where PortalType = 'None' Limit 1];
        Profile profile1 = [Select Id from Profile where name = 'System Administrator'];
        User portalAccountOwner1 = new User(
            UserRoleId = portalRole.Id,
            ProfileId = profile1.Id,
            Username = System.now().millisecond() + 'zzznpDOadv@optum.com.acet',
            Alias = 'batman',
            Email='zzznpzDOadv@optum.com.acet',
            EmailEncodingKey='UTF-8',
            Firstname='yarroa',
            Lastname='yavanoa',
            LanguageLocaleKey='en_US',
            LocaleSidKey='en_US',
            TimeZoneSidKey='America/Chicago');
        Database.insert(portalAccountOwner1);
        System.runAs ( portalAccountOwner1 ){
            User user = new User();
            user.UserRoleID = [Select Id From UserRole Where Name = 'FEC - Family Advisor - UHG' Limit 1].id;
            user.ProfileID = [Select Id From Profile Where Name='Center for Health Navigation'].id;
            user.EmailEncodingKey = 'ISO-8859-1';
            user.LanguageLocaleKey = 'en_US';
            user.TimeZoneSidKey = 'America/New_York';
            user.LocaleSidKey = 'en_US';
            user.FirstName = 'yarroa';
            user.LastName = 'yevvanohea';
            user.Username = 'ABCD1234DOadva@optum.com.acet';
            user.CommunityNickname = 'testUser123radv';
            user.Alias = 't12';
            user.Email = 'noyarroDOadva@optum.com.acet';
            user.IsActive = true;
            insert user;
            DigitalOnboardingAdvisorAssignment__c doa = new DigitalOnboardingAdvisorAssignment__c();
            doa.Name__c = user.Id;
            insert doa;
            //system.assertEquals(user.Id,[select User_Id__c from DigitalOnboardingAdvisorAssignment__c where Id =:doa.Id].User_Id__c);
        }
    }
    @isTest
    public static void coverDeleteFn(){
        list<DigitalOnboardingAdvisorAssignment__c> listDoa = [select Id, name from DigitalOnboardingAdvisorAssignment__c order by name asc];
        Round_Robin_Queue__c roundRobin = Round_Robin_Queue__c.getOrgDefaults();
        roundRobin.Last_Assigned_Advisor__c=[select name from DigitalOnboardingAdvisorAssignment__c where id =:listDoa[1].Id].name;
        update roundRobin;
        delete listDoa[1];
        Round_Robin_Queue__c roundRobin1 = Round_Robin_Queue__c.getOrgDefaults();
        //system.assertEquals(roundRobin1.Last_Assigned_Advisor__c,listDoa[0].name);
        delete listDoa[0];
        Round_Robin_Queue__c roundRobin2 = Round_Robin_Queue__c.getOrgDefaults();
        //system.assertEquals(roundRobin2.Last_Assigned_Advisor__c,null);
        delete listDoa[2];
    }
    @isTest
    public static void coverDeleteFn1(){
        list<DigitalOnboardingAdvisorAssignment__c> listDoa = [select Id, name from DigitalOnboardingAdvisorAssignment__c order by name asc];
        Round_Robin_Queue__c roundRobin = Round_Robin_Queue__c.getOrgDefaults();
        roundRobin.Last_Assigned_Advisor__c=[select name from DigitalOnboardingAdvisorAssignment__c where id =:listDoa[2].Id].name;
        update roundRobin;
        delete listDoa[2]; 
        Round_Robin_Queue__c roundRobin1 = Round_Robin_Queue__c.getOrgDefaults();
        //system.assertEquals(roundRobin1.Last_Assigned_Advisor__c,listDoa[1].name);
        delete listDoa[1];
        Round_Robin_Queue__c roundRobin2 = Round_Robin_Queue__c.getOrgDefaults();
        //system.assertEquals(roundRobin2.Last_Assigned_Advisor__c,listDoa[0].name);
        delete listDoa[0];
        Round_Robin_Queue__c roundRobin3 = Round_Robin_Queue__c.getOrgDefaults();
        //system.assertEquals(roundRobin3.Last_Assigned_Advisor__c,null);
    }
    @isTest
    public static void coverDeleteFn2(){
        list<DigitalOnboardingAdvisorAssignment__c> listDoa = [select Id, name from DigitalOnboardingAdvisorAssignment__c order by name asc];
        Round_Robin_Queue__c roundRobin = Round_Robin_Queue__c.getOrgDefaults();
        roundRobin.Last_Assigned_Advisor__c=[select name from DigitalOnboardingAdvisorAssignment__c where id =:listDoa[0].Id].name;
        update roundRobin;
        delete listDoa[0]; 
        Round_Robin_Queue__c roundRobin1 = Round_Robin_Queue__c.getOrgDefaults();
        //system.assertEquals(roundRobin1.Last_Assigned_Advisor__c,listDoa[2].name);
    }
}