/**
* Author: Team Eagles
* Description: Test class for SNI_FL_EHUBUpdateController
* Date Modified: 09/28/2020
*/
@isTest
public class SNI_FL_EHUBUpdateControllerTest{
    @testSetup
    static void setup() {
        List<RecordType> familyRecord = [SELECT Id FROM RecordType WHERE Name = 'Family'];
        User oUser = [select id,Name,Profile_Name__c,ProfileId,Role_Name__c FROM User Where id =: userInfo.getUserId()];
        Account acc = TestDataFactory.createBulkAccounts().get(0);
        acc.RecordTypeId=Schema.SObjectType.Account.getRecordTypeInfosByName().get('Family').getRecordTypeId();
        acc.OwnerId=oUser.Id;
        acc.EHub_Update_Check__c=true;
        update acc;
        Family_Overview__c fam=new Family_Overview__c();
        fam.Account__c=acc.Id;
        fam.Family_Status__c='Active';
        fam.Family_Needs__c='Low';
        fam.UHG_Restriction__c='No';
        fam.Onshore_Restriction__c='No';
        insert fam;
        fam.Designation__c='Assigned';
        fam.EHub_Update_Check__c=true;
        Update fam;
		Account personAccount = new Account();
        personAccount.firstName = 'PAccEligHubApiFname';
        personAccount.lastName = 'PAccEligHubApiLname';
        personAccount.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Individual').getRecordTypeId();
        insert personAccount;
        Member_Information__c memInfo = new Member_Information__c();
        memInfo.Account__c = personAccount.id ;
        insert memInfo;
        memInfo.Behavioral_Condition__c = 'test';
        memInfo.EHub_Update_Check__c = true;
        update memInfo;
        account pa1 = [select id,personcontactid from account where id =: personAccount.id];
        AccountContactRelation acr = new AccountContactRelation();
        acr.ContactId = pa1.personcontactid;            
        acr.Accountid = acc.id;
        acr.Relationship__c = 'Child/Other';
        insert acr;
    }
    @isTest
    static void fetchAccount() {
        test.startTest();
        User user = SNI_FL_EHUBUpdateController.getUser();
        SNI_FL_EHUBUpdateController.ReturnWrapper retWrap = SNI_FL_EHUBUpdateController.getAccountList(user.Id);
        System.assertEquals(retWrap != null, true);
        ETSBE_SolarisMockupResponse acctResponse = new ETSBE_SolarisMockupResponse(200,
																					'Success',
                                                                                  	'{"status":{"messages":[{"code":"201","name":"SUCCESS","severity":"INFO","description":"Successful Update"}]}}',
                                                                                  	null);
        test.setMock(HttpCalloutMock.class, acctResponse);
        
        List<Account> acct = [select id,Family_ID__c,name,Assigned_Advisor__c FROM Account where EHub_Update_Check__c = true];
        
    	Map<Id, SNI_FL_EHUBUpdateController.AccountWrapper> acctMap = new Map<Id, SNI_FL_EHUBUpdateController.AccountWrapper>();
        SNI_FL_EHUBUpdateController.AccountInfo acctInfo = new SNI_FL_EHUBUpdateController.AccountInfo();
        acctInfo.AccountId = acct[0].Id;
        acctInfo.FamilyID = acct[0].Family_ID__c;
        acctInfo.Name = acct[0].Name;
        acctInfo.AssignedAdvisor = acct[0].Assigned_Advisor__c;
        acctInfo.FamilyStatus = '';
        //accountInfoList.add(acctInfo);
        //set API variable
        SNI_FL_EHUBUpdateController.AccountWrapper acctWrap = new SNI_FL_EHUBUpdateController.AccountWrapper();
        acctWrap.acctInfo = acct[0];
        acctWrap.acrInfoList = new List<AccountContactRelation>();
        acctWrap.famMemberList = new List<Account>();
        acctMap.put(acct[0].Id, acctWrap);
        if(retWrap!=null){
        	SNI_FL_EHUBUpdateController.SearchResultWrapper results = SNI_FL_EHUBUpdateController.sendToEHUB(retWrap.accountMap.get(acct[0].Id), 'Assigned');
        }else{
        	SNI_FL_EHUBUpdateController.SearchResultWrapper results = SNI_FL_EHUBUpdateController.sendToEHUB(acctMap.get(acct[0].Id), 'Assigned');
        }
        test.stopTest();
    }
}