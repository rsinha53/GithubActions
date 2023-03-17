@isTest
public class SNI_FL_ProviderRelatedListControllerTest {

    @isTest static void fetchRecord()
    {
         Id proTeamrecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Provider Team').getRecordTypeId();
        Id proUserrecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Provider User').getRecordTypeId();
            
        Account a=new Account();
        a.FirstName='test';       
        a.LastName = 'ProviderUser';
        a.RecordTypeId = proUserrecordTypeId;
        insert a;
        Account acteam = new Account();
            acteam.LastName =   'ProviderTeam';
            acteam.RecordTypeId = proTeamrecordTypeId;
        insert acteam;
        account acUser1 = [select id,personcontactid from account where id =: acteam.id];
        AccountContactRelation acrrec = new AccountContactRelation();
        acrrec.ContactId = acUser1.personcontactid;             
        acrrec.Accountid =  a.id;
        acrrec.Relationship__c = 'Provider User';
        insert acrrec;
		       
        test.startTest();
        SNI_FL_ProviderRelatedListController.getProviderUserList(a.Id);
        SNI_FL_ProviderRelatedListController.getProiverTeamList(acteam.Id);
        test.stopTest();
        
    }
   
}