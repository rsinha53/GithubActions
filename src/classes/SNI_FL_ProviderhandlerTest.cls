/********************************************************************************* 
Class Name     : SNI_FL_ProviderhandlerTest.cls
Description    : This is test class for SNI_FL_Providerhandler
Created By     : Balakrishnan
Created Date   : 11/26/2020
*********************************************************************************/
@IsTest
public class SNI_FL_ProviderhandlerTest {

    @istest static void providerHandlertest(){
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
        SNI_FL_Providerhandler.getTeamaccountFromId(acff.id);
        SNI_FL_Providerhandler.getData_NewProviderAffiliation();
        SNI_FL_Providerhandler.createAccount('Adult', pgm.id, ac.id, ac.Name);
        SNI_FL_Providerhandler.createProviderTeam(ac.id,'LastName');
        SNI_FL_Providerhandler.createProviderUser(ac.id,'Mr.','FirstName','LastName','Test@gmail.com');
        SNI_FL_Providerhandler.getchildaccountFromId(acff.id);
      }
    
    @istest static void acrTest(){
        Id progrouprecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Provider Group').getRecordTypeId();
        Id proAffrecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Provider Affiliation').getRecordTypeId();
        Id proTeamrecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Provider Team').getRecordTypeId();
        Id proUserrecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Provider User').getRecordTypeId();
        List<AccountContactRelation> acrList = new List<AccountContactRelation>();
            List<Account> accList=new List<Account>();
            Account ac = new Account();
            ac.Name =   'ProviderGroup';
            ac.RecordTypeId = progrouprecordTypeId;
            accList.add(ac);
            Account acff = new Account();
            acff.Name =   'ProviderAffiliation';
            acff.RecordTypeId = proAffrecordTypeId;
            acff.parentId=ac.id;
            accList.add(acff);
            Account acteam = new Account();
            acteam.LastName =   'ProviderTeam';
            acteam.RecordTypeId = proTeamrecordTypeId;
            accList.add(acteam);
            Account acUser = new Account();
            acUser.LastName =   'ProviderUser';
            acUser.RecordTypeId = proUserrecordTypeId;
            acUser.Provider_Group__c = ac.id;
            accList.add(acUser);
            Account acUser2 = new Account();
            acUser2.LastName =   'ProviderUser2';
            acUser2.RecordTypeId = proUserrecordTypeId;
            acUser2.Provider_Group__c = ac.id;
            accList.add(acUser2);
            insert accList;
           List<program__c> programList=new List<program__c>();
            Program__c pgm = new Program__c();
            pgm.Program__c = 'Complex Care';
            programList.add(pgm);
            insert programList;
        List<contact> AllProviderUser = new List<contact>();
        List<contact> selectedProviderUserList = new List<contact>();
        List<String> SelectedProviderUserStr = new List<String>();
        account acUsercon = [select id,personcontactid from account where id =: acUser.id];
        contact userconId = [select id,AccountId,Name from contact where id =: acUsercon.personcontactid];
        AllProviderUser.add(userconId);
        selectedProviderUserList.add(userconId);
        SelectedProviderUserStr.add(userconId.Name);
        AccountContactRelation acrrec = new AccountContactRelation();
        acrrec.ContactId = acUsercon.personcontactid;             
        acrrec.Accountid = acff.id;
        acrrec.Relationship__c = 'Provider User';
        acrList.add(acrrec);
        account acUsercon2 = [select id,personcontactid from account where id =: acUser2.id];
        contact userconId2 = [select id,AccountId,Name from contact where id =: acUsercon2.personcontactid];
        AllProviderUser.add(userconId2);
        SelectedProviderUserStr.add(userconId2.Name);
        account acteam1 = [select id,personcontactid from account where id =: acteam.id];
        AccountContactRelation acrrec3 = new AccountContactRelation();
        acrrec3.ContactId = acteam1.personcontactid;            
        acrrec3.Accountid = acff.id;
        acrrec3.Relationship__c = 'Provider Team';
        acrList.add(acrrec3);
        insert acrList;
        test.startTest();        
        SNI_FL_Providerhandler.getProviderUserAff(acff.id);
        SNI_FL_Providerhandler.getProviderUser(acteam.id);
        SNI_FL_Providerhandler.AddRemoveProviderUser(acteam.id,AllProviderUser,selectedProviderUserList,SelectedProviderUserStr);
        test.stopTest();
                
    }
}