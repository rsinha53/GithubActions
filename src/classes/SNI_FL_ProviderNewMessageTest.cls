/****************************************************************************** 
Class Name     : SNI_FL_ProviderNewMessageTest
Description    : Convers provider new message create functionality
Created By     : Sameera - ACDC US3128731,US3128709
Created Date   : 20/1/2020
******************************************************************************/
@isTest(SeeAllData=true)
public with sharing class SNI_FL_ProviderNewMessageTest {

    //Have to use SeeAllData becuase method covers ConnectAPI(Salesforce standard) method
    //if not use this error comes "ACDC Exception ConnectApi methods are not supported in data siloed tests. Please use @IsTest(SeeAllData=true)"
    @isTest
    static void advisorNewMessageWithAttachments(){

        UserRole userrole = [SELECT Id, DeveloperName FROM UserRole WHERE DeveloperName = 'System_Administrator' Limit 1];
        Id adminProfile = [SELECT id FROM profile WHERE name='System Administrator' LIMIT 1].id;
        User adminUser = [SELECT ID FROM User WHERE ProfileId =:adminProfile AND IsActive =true LIMIT 1 ];
        adminUser.UserRoleId = userRole.Id;
        update adminUser;

        System.runAs(adminUser){

        Map<Object,Object> m = new Map<Object,Object>();
        List<Object> toList = new List<Object>();
        
        Id providerGroup = SNI_FL_DirectMessageTestDataFactory.getProviderGroup();
        Id providerAffliations = SNI_FL_DirectMessageTestDataFactory.getProviderAffliations(providerGroup);
        Id conDoc = SNI_FL_DirectMessageTestDataFactory.getDocumentID();
        Id providerUserId = SNI_FL_DirectMessageTestDataFactory.getProviderUserRecord(SNI_FL_DirectMessageTestDataFactory.getProviderUser(providerGroup));
        Id relatedMember = SNI_FL_DirectMessageTestDataFactory.getMember();
        
        Id providerteampersonAct = SNI_FL_DirectMessageTestDataFactory.getProviderUserForProviderTeam(providerGroup);
        Id providerTeamUser = SNI_FL_DirectMessageTestDataFactory.getProviderTeamUserRecord(providerteampersonAct);
        Id providerTeamact = SNI_FL_DirectMessageTestDataFactory.getProviderTeam(providerGroup);
        Id contactID = [SELECT Id, ContactId FROM User WHERE id=:providerTeamUser LIMIT 1].ContactId;
        SNI_FL_DirectMessageTestDataFactory.getACR(providerTeamact,contactID);

        Account providerAff = [SELECT Id,Name FROM Account WHERE Id=:providerAffliations LIMIT 1];
        Account member = [SELECT Id,Name FROM Account WHERE Id=:relatedMember LIMIT 1];
        User prodivderUser = [SELECT Id,AccountId,Account.Name FROM User WHERE Id=:providerUserId LIMIT 1];

        Account providerTeam = [SELECT Id,Name FROM Account WHERE id=:providerTeamact LIMIT 1];
        
        toList.add(new Map<Object,Object>{'label'=>prodivderUser.Account.Name,'userType'=>'PU','value'=>prodivderUser.Id});
        toList.add(new Map<Object,Object>{'label'=>providerTeam.Name,'userType'=>'PT','value'=>providerTeam.Id});

        m.put('recipients',toList);
        m.put('providerAffliation',new Map<Object,Object>{'label'=>providerAff.Name,'value'=>providerAff.id});
        m.put('relatedToUsers',new Map<Object,Object>{'label'=>member.Name,'value'=>member.Id});
        m.put('messageBody','test');
        m.put('fileId',conDoc);
        m.put('subject','test');
        m.put('isBackupAgentView',true);

        SNI_FL_ProviderMessageUtil.createProviderMessage(m);

        }

    }

    @isTest
    static void advisorNewMessageWithOutAttachments(){

        UserRole userrole = [SELECT Id, DeveloperName FROM UserRole WHERE DeveloperName = 'System_Administrator' Limit 1];
        Id adminProfile = [SELECT id FROM profile WHERE name='System Administrator' LIMIT 1].id;
        User adminUser = [SELECT ID FROM User WHERE ProfileId =:adminProfile AND IsActive =true LIMIT 1 ];
        adminUser.UserRoleId = userRole.Id;
        update adminUser;

        System.runAs(adminUser){

        Map<Object,Object> m = new Map<Object,Object>();
        List<Object> toList = new List<Object>();
        
        Id providerGroup = SNI_FL_DirectMessageTestDataFactory.getProviderGroup();
        Id providerAffliations = SNI_FL_DirectMessageTestDataFactory.getProviderAffliations(providerGroup);
        Id providerUserId = SNI_FL_DirectMessageTestDataFactory.getProviderUserRecord(SNI_FL_DirectMessageTestDataFactory.getProviderUser(providerGroup));
        Id relatedMember = SNI_FL_DirectMessageTestDataFactory.getMember();
        
        Id providerteampersonAct = SNI_FL_DirectMessageTestDataFactory.getProviderUserForProviderTeam(providerGroup);
        Id providerTeamUser = SNI_FL_DirectMessageTestDataFactory.getProviderTeamUserRecord(providerteampersonAct);
        Id providerTeamact = SNI_FL_DirectMessageTestDataFactory.getProviderTeam(providerGroup);
        Id contactID = [SELECT Id, ContactId FROM User WHERE id=:providerTeamUser LIMIT 1].ContactId;
        SNI_FL_DirectMessageTestDataFactory.getACR(providerTeamact,contactID);

        Account providerAff = [SELECT Id,Name FROM Account WHERE Id=:providerAffliations LIMIT 1];
        Account member = [SELECT Id,Name FROM Account WHERE Id=:relatedMember LIMIT 1];
        User prodivderUser = [SELECT Id,AccountId,Account.Name FROM User WHERE Id=:providerUserId LIMIT 1];

        Account providerTeam = [SELECT Id,Name FROM Account WHERE id=:providerTeamact LIMIT 1];
        
        toList.add(new Map<Object,Object>{'label'=>prodivderUser.Account.Name,'userType'=>'PU','value'=>prodivderUser.Id});
        toList.add(new Map<Object,Object>{'label'=>providerTeam.Name,'userType'=>'PT','value'=>providerTeam.Id});

        m.put('recipients',toList);
        m.put('providerAffliation',new Map<Object,Object>{'label'=>providerAff.Name,'value'=>providerAff.id});
        m.put('relatedToUsers',new Map<Object,Object>{'label'=>member.Name,'value'=>member.Id});
        m.put('messageBody','test');
        m.put('subject','test');
        m.put('isBackupAgentView',true);

        SNI_FL_ProviderMessageUtil.createProviderMessage(m);

        }
    }

    @isTest
    static void backupadvisorNewMessageAttachmentAndText(){

        UserRole userrole = [SELECT Id, DeveloperName FROM UserRole WHERE DeveloperName = 'System_Administrator' Limit 1];
        Id adminProfile = [SELECT id FROM profile WHERE name='System Administrator' LIMIT 1].id;
        User adminUser = [SELECT ID FROM User WHERE ProfileId =:adminProfile AND IsActive =true LIMIT 1 ];
        adminUser.UserRoleId = userRole.Id;
        update adminUser;

        System.runAs(adminUser){

        Map<Object,Object> m = new Map<Object,Object>();
        List<Object> toList = new List<Object>();
        
        Id providerGroup = SNI_FL_DirectMessageTestDataFactory.getProviderGroup();
            system.debug('#122'+providerGroup);
        Id providerAffliations = SNI_FL_DirectMessageTestDataFactory.getProviderAffliations(providerGroup);
        Id providerUserId = SNI_FL_DirectMessageTestDataFactory.getProviderUserRecord(SNI_FL_DirectMessageTestDataFactory.getProviderUser(providerGroup));
             system.debug('#125'+providerUserId);
        Id relatedMember = SNI_FL_DirectMessageTestDataFactory.getMember();
        Id conDoc = SNI_FL_DirectMessageTestDataFactory.getDocumentID();
        
        Id providerteampersonAct = SNI_FL_DirectMessageTestDataFactory.getProviderUserForProviderTeam(providerGroup);
        Id providerTeamUser = SNI_FL_DirectMessageTestDataFactory.getProviderTeamUserRecord(providerteampersonAct);
        Id providerTeamact = SNI_FL_DirectMessageTestDataFactory.getProviderTeam(providerGroup);
        Id contactID = [SELECT Id, ContactId FROM User WHERE id=:providerTeamUser LIMIT 1].ContactId;
        SNI_FL_DirectMessageTestDataFactory.getACR(providerTeamact,contactID);

        Account providerAff = [SELECT Id,Name FROM Account WHERE Id=:providerAffliations LIMIT 1];
        Account member = [SELECT Id,Name FROM Account WHERE Id=:relatedMember LIMIT 1];
        User prodivderUser = [SELECT Id,AccountId,Account.Name FROM User WHERE Id=:providerUserId LIMIT 1];

        Account providerTeam = [SELECT Id,Name FROM Account WHERE id=:providerTeamact LIMIT 1];
        
        toList.add(new Map<Object,Object>{'label'=>prodivderUser.Account.Name,'userType'=>'PU','value'=>prodivderUser.Id});
        toList.add(new Map<Object,Object>{'label'=>providerTeam.Name,'userType'=>'PT','value'=>providerTeam.Id});

        m.put('recipients',toList);
        m.put('providerAffliation',new Map<Object,Object>{'label'=>providerAff.Name,'value'=>providerAff.id});
        m.put('relatedToUsers',new Map<Object,Object>{'label'=>member.Name,'value'=>member.Id});
        m.put('messageBody','test');
        m.put('fileId',conDoc);
        m.put('subject','test');
        m.put('isBackupAgentView',false);

        SNI_FL_ProviderMessageUtil.createProviderMessage(m);

        }
    }

    @isTest
    static void backupadvisorNewMessageWithoutAttachments(){

        UserRole userrole = [SELECT Id, DeveloperName FROM UserRole WHERE DeveloperName = 'System_Administrator' Limit 1];
        Id adminProfile = [SELECT id FROM profile WHERE name='System Administrator' LIMIT 1].id;
        User adminUser = [SELECT ID FROM User WHERE ProfileId =:adminProfile AND IsActive =true LIMIT 1 ];
        adminUser.UserRoleId = userRole.Id;
        update adminUser;

        System.runAs(adminUser){

        Map<Object,Object> m = new Map<Object,Object>();
        List<Object> toList = new List<Object>();
        
        Id providerGroup = SNI_FL_DirectMessageTestDataFactory.getProviderGroup();
        Id providerAffliations = SNI_FL_DirectMessageTestDataFactory.getProviderAffliations(providerGroup);
        Id providerUserId = SNI_FL_DirectMessageTestDataFactory.getProviderUserRecord(SNI_FL_DirectMessageTestDataFactory.getProviderUser(providerGroup));
        Id relatedMember = SNI_FL_DirectMessageTestDataFactory.getMember();
        
        
        Id providerteampersonAct = SNI_FL_DirectMessageTestDataFactory.getProviderUserForProviderTeam(providerGroup);
        Id providerTeamUser = SNI_FL_DirectMessageTestDataFactory.getProviderTeamUserRecord(providerteampersonAct);
        Id providerTeamact = SNI_FL_DirectMessageTestDataFactory.getProviderTeam(providerGroup);
        Id contactID = [SELECT Id, ContactId FROM User WHERE id=:providerTeamUser LIMIT 1].ContactId;
        SNI_FL_DirectMessageTestDataFactory.getACR(providerTeamact,contactID);

        Account providerAff = [SELECT Id,Name FROM Account WHERE Id=:providerAffliations LIMIT 1];
        Account member = [SELECT Id,Name FROM Account WHERE Id=:relatedMember LIMIT 1];
        User prodivderUser = [SELECT Id,AccountId,Account.Name FROM User WHERE Id=:providerUserId LIMIT 1];

        Account providerTeam = [SELECT Id,Name FROM Account WHERE id=:providerTeamact LIMIT 1];
        
        toList.add(new Map<Object,Object>{'label'=>prodivderUser.Account.Name,'userType'=>'PU','value'=>prodivderUser.Id});
        toList.add(new Map<Object,Object>{'label'=>providerTeam.Name,'userType'=>'PT','value'=>providerTeam.Id});

        m.put('recipients',toList);
        m.put('providerAffliation',new Map<Object,Object>{'label'=>providerAff.Name,'value'=>providerAff.id});
        m.put('relatedToUsers',new Map<Object,Object>{'label'=>member.Name,'value'=>member.Id});
        m.put('messageBody','test');
        m.put('subject','test');
        m.put('isBackupAgentView',false);

        SNI_FL_ProviderMessageUtil.createProviderMessage(m);
        
        }
    }

    @isTest
    static void familyLinkUserEmptySubjectMessage(){

        Account providerAff;
        Map<Object,Object> m = new Map<Object,Object>();

        UserRole userrole = [SELECT Id, DeveloperName FROM UserRole WHERE DeveloperName = 'System_Administrator' Limit 1];
        Id adminProfile = [SELECT id FROM profile WHERE name='System Administrator' LIMIT 1].id;
        User adminUser = [SELECT ID FROM User WHERE ProfileId =:adminProfile AND IsActive =true LIMIT 1 ];
        adminUser.UserRoleId = userRole.Id;
        update adminUser;

        System.runAs(adminUser){

        
        List<Object> toList = new List<Object>();
        
        Id providerGroup = SNI_FL_DirectMessageTestDataFactory.getProviderGroup();
        Id providerAffliations = SNI_FL_DirectMessageTestDataFactory.getProviderAffliations(providerGroup);
        Id providerUserId = SNI_FL_DirectMessageTestDataFactory.getProviderUserRecord(SNI_FL_DirectMessageTestDataFactory.getProviderUser(providerGroup));
        Id relatedMember = SNI_FL_DirectMessageTestDataFactory.getMember();
        
        
        Id providerteampersonAct = SNI_FL_DirectMessageTestDataFactory.getProviderUserForProviderTeam(providerGroup);
        Id providerTeamUser = SNI_FL_DirectMessageTestDataFactory.getProviderTeamUserRecord(providerteampersonAct);
        Id providerTeamact = SNI_FL_DirectMessageTestDataFactory.getProviderTeam(providerGroup);
        Id contactID = [SELECT Id, ContactId FROM User WHERE id=:providerTeamUser LIMIT 1].ContactId;
        SNI_FL_DirectMessageTestDataFactory.getACR(providerTeamact,contactID);

        providerAff = [SELECT Id,Name FROM Account WHERE Id=:providerAffliations LIMIT 1];
        Account member = [SELECT Id,Name FROM Account WHERE Id=:relatedMember LIMIT 1];
        User prodivderUser = [SELECT Id,AccountId,Account.Name FROM User WHERE Id=:providerUserId LIMIT 1];

        Account providerTeam = [SELECT Id,Name FROM Account WHERE id=:providerTeamact LIMIT 1];
        
        toList.add(new Map<Object,Object>{'label'=>prodivderUser.Account.Name,'userType'=>'PU','value'=>prodivderUser.Id});
        toList.add(new Map<Object,Object>{'label'=>providerTeam.Name,'userType'=>'PT','value'=>providerTeam.Id});

        m.put('recipients',toList);
        m.put('providerAffliation',new Map<Object,Object>{'label'=>providerAff.Name,'value'=>providerAff.id});
        m.put('relatedToUsers',new Map<Object,Object>{'label'=>member.Name,'value'=>member.Id});
        m.put('messageBody','test');
        m.put('subject','');
        m.put('isBackupAgentView',false);

        }

        Id communityProfileID = [SELECT id FROM profile WHERE name='Care Advisor Connect Provider User' LIMIT 1].id;
        User communityUser = [SELECT ID FROM User WHERE ProfileId =:communityProfileID AND IsActive =true LIMIT 1 ];
        System.runAs(communityUser){
            SNI_FL_ProviderMessageUtil.createProviderMessage(m);
        }
        
    }

    @isTest
    static void familyLinkUserWithSubjectMessage(){

        Account providerAff;
        Map<Object,Object> m = new Map<Object,Object>();

        UserRole userrole = [SELECT Id, DeveloperName FROM UserRole WHERE DeveloperName = 'System_Administrator' Limit 1];
        Id adminProfile = [SELECT id FROM profile WHERE name='System Administrator' LIMIT 1].id;
        User adminUser = [SELECT ID FROM User WHERE ProfileId =:adminProfile AND IsActive =true LIMIT 1 ];
        adminUser.UserRoleId = userRole.Id;
        update adminUser;

        System.runAs(adminUser){

        
        List<Object> toList = new List<Object>();
        
        Id providerGroup = SNI_FL_DirectMessageTestDataFactory.getProviderGroup();
        Id providerAffliations = SNI_FL_DirectMessageTestDataFactory.getProviderAffliations(providerGroup);
        Id providerUserId = SNI_FL_DirectMessageTestDataFactory.getProviderUserRecord(SNI_FL_DirectMessageTestDataFactory.getProviderUser(providerGroup));
        Id relatedMember = SNI_FL_DirectMessageTestDataFactory.getMember();
        
        
        Id providerteampersonAct = SNI_FL_DirectMessageTestDataFactory.getProviderUserForProviderTeam(providerGroup);
        Id providerTeamUser = SNI_FL_DirectMessageTestDataFactory.getProviderTeamUserRecord(providerteampersonAct);
        Id providerTeamact = SNI_FL_DirectMessageTestDataFactory.getProviderTeam(providerGroup);
        Id contactID = [SELECT Id, ContactId FROM User WHERE id=:providerTeamUser LIMIT 1].ContactId;
        SNI_FL_DirectMessageTestDataFactory.getACR(providerTeamact,contactID);

        providerAff = [SELECT Id,Name FROM Account WHERE Id=:providerAffliations LIMIT 1];
        Account member = [SELECT Id,Name FROM Account WHERE Id=:relatedMember LIMIT 1];
        User prodivderUser = [SELECT Id,AccountId,Account.Name FROM User WHERE Id=:providerUserId LIMIT 1];

        Account providerTeam = [SELECT Id,Name FROM Account WHERE id=:providerTeamact LIMIT 1];
        
        toList.add(new Map<Object,Object>{'label'=>prodivderUser.Account.Name,'userType'=>'PU','value'=>prodivderUser.Id});
        toList.add(new Map<Object,Object>{'label'=>providerTeam.Name,'userType'=>'PT','value'=>providerTeam.Id});

        m.put('recipients',toList);
        m.put('providerAffliation',new Map<Object,Object>{'label'=>providerAff.Name,'value'=>providerAff.id});
        m.put('relatedToUsers',new Map<Object,Object>{'label'=>member.Name,'value'=>member.Id});
        m.put('messageBody','test');
        m.put('subject','Test');
        m.put('isBackupAgentView',false);

        }

        Id communityProfileID = [SELECT id FROM profile WHERE name='Care Advisor Connect Provider User' LIMIT 1].id;
        User communityUser = [SELECT ID FROM User WHERE ProfileId =:communityProfileID AND IsActive =true LIMIT 1 ];
        System.runAs(communityUser){
            SNI_FL_ProviderMessageUtil.createProviderMessage(m);
        }
    }

    @isTest
    static void familyLinkUserLargeSubjectMessage(){

        Account providerAff;
        Map<Object,Object> m = new Map<Object,Object>();

        UserRole userrole = [SELECT Id, DeveloperName FROM UserRole WHERE DeveloperName = 'System_Administrator' Limit 1];
        Id adminProfile = [SELECT id FROM profile WHERE name='System Administrator' LIMIT 1].id;
        User adminUser = [SELECT ID FROM User WHERE ProfileId =:adminProfile AND IsActive =true LIMIT 1 ];
        adminUser.UserRoleId = userRole.Id;
        update adminUser;

        System.runAs(adminUser){

        
        List<Object> toList = new List<Object>();
        
        Id providerGroup = SNI_FL_DirectMessageTestDataFactory.getProviderGroup();
        Id providerAffliations = SNI_FL_DirectMessageTestDataFactory.getProviderAffliations(providerGroup);
        Id providerUserId = SNI_FL_DirectMessageTestDataFactory.getProviderUserRecord(SNI_FL_DirectMessageTestDataFactory.getProviderUser(providerGroup));
        Id relatedMember = SNI_FL_DirectMessageTestDataFactory.getMember();
        
        
        Id providerteampersonAct = SNI_FL_DirectMessageTestDataFactory.getProviderUserForProviderTeam(providerGroup);
        Id providerTeamUser = SNI_FL_DirectMessageTestDataFactory.getProviderTeamUserRecord(providerteampersonAct);
        Id providerTeamact = SNI_FL_DirectMessageTestDataFactory.getProviderTeam(providerGroup);
        Id contactID = [SELECT Id, ContactId FROM User WHERE id=:providerTeamUser LIMIT 1].ContactId;
        SNI_FL_DirectMessageTestDataFactory.getACR(providerTeamact,contactID);

        providerAff = [SELECT Id,Name FROM Account WHERE Id=:providerAffliations LIMIT 1];
        Account member = [SELECT Id,Name FROM Account WHERE Id=:relatedMember LIMIT 1];
        User prodivderUser = [SELECT Id,AccountId,Account.Name FROM User WHERE Id=:providerUserId LIMIT 1];

        Account providerTeam = [SELECT Id,Name FROM Account WHERE id=:providerTeamact LIMIT 1];
        
        toList.add(new Map<Object,Object>{'label'=>prodivderUser.Account.Name,'userType'=>'PU','value'=>prodivderUser.Id});
        toList.add(new Map<Object,Object>{'label'=>providerTeam.Name,'userType'=>'PT','value'=>providerTeam.Id});

        m.put('recipients',toList);
        m.put('providerAffliation',new Map<Object,Object>{'label'=>providerAff.Name,'value'=>providerAff.id});
        m.put('relatedToUsers',new Map<Object,Object>{'label'=>member.Name,'value'=>member.Id});
        m.put('messageBody','test');
        m.put('subject','aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa');
        m.put('isBackupAgentView',false);
       
        }

        Id communityProfileID = [SELECT id FROM profile WHERE name='Care Advisor Connect Provider User' LIMIT 1].id;
        User communityUser = [SELECT ID FROM User WHERE ProfileId =:communityProfileID AND IsActive =true LIMIT 1 ];
        System.runAs(communityUser){
            SNI_FL_ProviderMessageUtil.createProviderMessage(m);
        }
        
    }

    
}