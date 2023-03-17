@isTest
public class SNI_FL_ProviderMembersTabControllerTest {
    
    @testSetup
    static void membersTabControllerSetup() {
        //https://help.salesforce.com/articleView?id=000330124&type=1&mode=1
        UserRole userrole = [Select Id, DeveloperName From UserRole Where DeveloperName = 'System_Administrator' Limit 1];
        
        User adminUser = [Select Id, UserRoleId From User Where Profile.Name='System Administrator' AND isActive = TRUE Limit 1];
        
        adminUser.UserRoleId = userRole.Id;
        update adminUser;
        
        System.runAs(adminUser){
            
			Id provGroupRTId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Provider Group').getRecordTypeId();
            Id provUserRTId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Provider User').getRecordTypeId();
            Account ac = new Account();
            ac.Name = 'ProviderGroup';
            ac.RecordTypeId = provGroupRTId;
            insert ac;
            
            Account provUser = new Account(
                Salutation = 'Mr.',
                FirstName = 'Provider',
                LastName = 'User',
                PersonEmail = 'MrProviderUser@email.com',
                Provider_Group__c = ac.Id,
                RecordTypeId = provUserRTId
            );
            
            insert provUser;
            
            
            Contact c = [SELECT Id FROM Contact WHERE AccountId =: provUser.Id];
            
            User user = new User();
            user.ProfileID = [Select Id From Profile Where Name='Care Advisor Connect Provider User'].id;
            user.EmailEncodingKey = 'ISO-8859-1';
            user.LanguageLocaleKey = 'en_US';
            user.TimeZoneSidKey = 'America/New_York';
            user.LocaleSidKey = 'en_US';
            user.FirstName = 'first';
            user.LastName = 'last';
            user.Username = 'ABCD1234XYZ@optum.com.acet';
            user.CommunityNickname = 'testUser123';
            user.Alias = 't1';
            user.Email = 'no@email.com';
            user.IsActive = true;
            user.ContactId = c.Id;
            
            insert user;
        
        
        // Provider Group -> Provider Affiliation -> Provider User -> Provider Team
        // Member Affiliation
        // 
        // "all members enrolled into the program offered by this provider user or 
        // offered by provider team where provider user is part of should be displayed."
        // 
        // ToDo: Create member affiliations under Provider User and Provider Team - logged 
        // in Provider Member should see all of them.
        
        Id provAffRTId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Provider Affiliation').getRecordTypeId();
        Id provTeamRTId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Provider Team').getRecordTypeId();
        //Id provUserRTId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Provider User').getRecordTypeId();
        //Id provGroupRTId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Provider Group').getRecordTypeId();
        
       
        Account acff = new Account();
        acff.Name = 'ProviderAffiliation';
        acff.RecordTypeId = provAffRTId;
                
        insert acff;
        
        Account ac5 = [SELECT Id FROM Account WHERE RecordTypeId =: provGroupRTId LIMIT 1];
       
        User usr = [SELECT Id, ContactId FROM User WHERE Username ='ABCD1234XYZ@optum.com.acet' LIMIT 1];
        Account provUserr = [SELECT Id FROM Account WHERE RecordTypeId =: provUserRTId LIMIT 1];
       

        
 		Account provTeam = new Account(
            Salutation = 'Mr.',
            FirstName = 'Provider',
            LastName = 'Team',
            Provider_Group_Team__c = ac5.Id,
			RecordTypeId = provTeamRTId);             
        
        insert provTeam;
        
        // Account Contact Relation (Provider Program Affiliation)
        AccountContactRelation acrPPA = new AccountContactRelation();
        acrPPA.AccountId = acff.id;
        acrPPA.ContactId = usr.ContactId;
        insert acrPPA;
        
        
        // Account Contact Relation
        AccountContactRelation acr = new AccountContactRelation();
        acr.AccountId = provTeam.id;
        acr.ContactId = usr.ContactId;
        insert acr;
        
        // ACR lists 
        List<program__c> programList=new List<program__c>();
        Program__c pgm = new Program__c();
        pgm.Program__c = 'Complex Care';
        programList.add(pgm);
        insert programList;
        
        List<Member_Affiliation__c> memberAffilList = new List<Member_Affiliation__c>();
        
        // Member Affiliations related to Provider User through Provider_Affiliation__c
        for (Integer i = 0; i < 5; i++) {
            Member_Affiliation__c mAffil = new Member_Affiliation__c();
            mAffil.Provider__c = provTeam.Id;
            mAffil.Population__c = 'Adult';
            mAffil.Program__c = pgm.Id;
            mAffil.Provider_Affiliation__c = acff.Id;
            mAffil.Email__c='Person3Email' + i + '@gmail.com';
            mAffil.Enrollment_Date__c = system.today();
            mAffil.Date_Of_Birth__c = System.today();
            mAffil.Member__c=ac.Id;
            mAffil.Status__c=true;    
            memberAffilList.add(mAffil);
        }
        
        // Member Affiliation related to provider User through Provider_Affiliation__C No Program Member Affiliation records
        for (Integer k = 0; k < 5; k++) {
            Member_Affiliation__c mAffil = new Member_Affiliation__c();
            mAffil.Provider__c = provUserr.Id;
            mAffil.Population__c = 'Adult';
            mAffil.Provider_Affiliation__c = acff.Id;
            mAffil.Email__c='Person3Email' + k + '@gmail.com';
            mAffil.Enrollment_Date__c = system.today();
            mAffil.Date_Of_Birth__c = System.today();
            mAffil.Member__c=ac.Id;
            mAffil.Status__c=true;    
            memberAffilList.add(mAffil);
        }
        
               
        insert memberAffilList;
        
        }
    }
    
    @isTest 
    static void getRelatedMembers() {
        // Confirm all related members are grabbed by the query.
         Test.startTest();
        User u = [SELECT Id FROM User WHERE Username = 'ABCD1234XYZ@optum.com.acet' Limit 1];
        Id provAffRTId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Provider Affiliation').getRecordTypeId();
        Account acc = [Select Id from Account Where RecordTypeId =: provAffRTId limit 1 ];
        System.runAs(u) {
            SNI_FL_ProviderMembersTabController.MembersReturnWrapper memberList = SNI_FL_ProviderMembersTabController.getMemberDetails(acc.Id);
            List<SNI_FL_ProviderMembersTabController.MemberDetailWrapper> memberDetailList = memberList.memberDetails;
            //memberDetailList.sort();
            System.assertEquals(10, memberDetailList.size());
            SNI_FL_ProviderMembersTabController.MembersReturnWrapper memberList2 = SNI_FL_ProviderMembersTabController.getMemberDetails(NULL);
            List<SNI_FL_ProviderMembersTabController.MemberDetailWrapper> memberDetailList2 = memberList2.memberDetails;
            System.assertEquals(0, memberDetailList2.size());
        }
        test.stoptest();
    }

}