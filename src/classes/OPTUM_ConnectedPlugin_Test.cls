/************************************
    * Createdby: Prasad kammella
    * @Classname: OPTUM_ConnectedPlugin_Test
    * Description:US3381292 -'WEX' Deep Link - Member Level - Member Page
    ************************************/
@isTest
public class OPTUM_ConnectedPlugin_Test {
@isTest
    public static void customAttributesTest(){
        Map<String,String> mapstr = new Map<String,String>();
          RecordType newRecord = [SELECT Id FROM RecordType WHERE Name = 'Person Account' and SObjectType = 'Account'];
        Account accountTest = new Account();
        accountTest.FirstName = 'Test Contact FN1';
        accountTest.LastName = 'Test Contact LN1';
        accountTest.EID__c = 'TestEID1';
        accountTest.EID__pc = 'TestEID1';
        accountTest.ParticipantEmployeeExternalId__c = '0006851714';
        accountTest.ParticipantEmployerCode__c = 'OPT';
	    accountTest.ParticipantAdminAlias__c = 'J17894';
        accountTest.RecordTypeId = newRecord.Id;
        insert accountTest;
        list<account> acclist= [Select Id, Name, EID__c, SRK_KeyChain__c, ParticipantAdminAlias__c, ParticipantEmployeeExternalId__c, ParticipantEmployerCode__c from Account where id=:accountTest.id];                                                
        system.debug('acclist' +acclist);
        mapstr.put('ParticipantEmployeeExternalId', acclist[0].ParticipantEmployeeExternalId__c );
        mapstr.put('ParticipantEmployerCode', acclist[0].ParticipantAdminAlias__c );
        mapstr.put('ParticipantAdminAlias', acclist[0].ParticipantEmployerCode__c );
        mapstr.put('AccountType', 'Admin-DL');
        mapstr.put('SsoUserId', UserInfo.getUserId());
        mapstr.put('STARTPAGE',  'CONSUMER_SUPPORT_SUMMARY');
        List<ConnectedApplication> connectedApp = [select Id from ConnectedApplication where Name Like '%WEX Health SSO%' LIMIT 1];
          String connectedAppId = '';
        if(connectedApp.size() > 0){
            connectedAppId = connectedApp[0].Id;
        }
        Test.startTest();
         OPTUM_ConnectedAppPluginWEX  cap = new OPTUM_ConnectedAppPluginWEX ();
          cap.customAttributes(UserInfo.getUserId(),connectedAppId,mapstr,Auth.InvocationContext.SAML_ASSERTION);
        Test.stopTest();
    }
}