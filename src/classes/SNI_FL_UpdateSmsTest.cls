@isTest
private class SNI_FL_UpdateSmsTest {
    
    static testMethod void updatePersonAccountPost() {
        Id recordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Family').getRecordTypeId();
        List<Account> accList=new List<Account>();
        List<SNI_FL_Care_Team_Member__c> teamlist=new List<SNI_FL_Care_Team_Member__c>();
        Account ac = new Account();
        ac.Member_ID__c = '453543145';
        ac.Policy_ID__c = '0070145';
        ac.Name =   'FLTestAcc';
        ac.RecordTypeId = recordTypeId;
        accList.add(ac);
        
        
        Id personAccRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Individual').getRecordTypeId();
        Account pa =new account();
        pa.PersonBirthdate = date.valueOf(ACETUtility.formatDateFutureDate('6/17/1979'));
        pa.firstName = 'Community'; 
        pa.lastName = 'FLCreteamTestUser'; 
        pa.RecordTypeId = personAccRecordTypeId;
        pa.MultiPolicyCheck__c=true;
        pa.Policy_ID__c='0070145';
        pa.Member_ID__c='453543145';
        pa.Text_Message_SMS_Notification__c = true;
        accList.add(pa);       
        
        insert accList;
        
        set<id> accSet=new set<id>{(pa.Id)};
            Id contactId,contactId1;
        for(Contact con:[SELECT id,accountId from contact where accountId in : accSet]){
            if(con.accountId==pa.Id)
                contactId=con.id;
            else
                contactId1=con.id; 
        }
        List<Contact> conId = [SELECT id from contact where accountId =: pa.Id];
        List<Profile> pList = [SELECT Id,Name FROM Profile WHERE Name =: 'Care Advisor Connect Community User']; 
        User thisUser = [Select Id From User Where Id =:UserInfo.getUserId()];
        user u;
        System.runAs(thisUser){
            u = new User(Alias = 'standt', Email='flCareTeamtest@testorg.com', 
                         EmailEncodingKey='UTF-8', FirstName='Test007',LastName='Testing', LanguageLocaleKey='en_US', 
                         LocaleSidKey='en_US', ProfileId = pList.get(0).id, contactId =conId[0].Id,
                         TimeZoneSidKey='America/Los_Angeles',MobilePhone='(201) 747-5600', UserName='flCareTeamtest@testorg.com',IsActive=true);
            insert u;
        }
        RestRequest req = new RestRequest();
        req.requestUri = System.URL.getSalesforceBaseUrl().toExternalForm() +
            '/services/apexrest/SNI/PersonAccount';
        
        req.httpMethod = 'POST';
        req.addHeader('Content-Type', 'application/json');
        req.requestBody = Blob.valueOf('{"Phone_number": "+12017475600"}'); 
        RestContext.request = req;
        //update method:
        SNI_FL_UpdateSmsPreferenceService.updatePersonAccount();
        
        List<user> updatedRecord = [select id,MobilePhone,Email,Contact.Account.Id,Contact.Account.Email_Notification__c,Contact.Account.Text_Message_SMS_Notification__c,
                                    Contact.Account.Last_Notification_Timestamp__c,FirstName,LastName,Profile.Name
                                    from User where MobilePhone = '(201) 747-5600'];
        System.assert(updatedRecord[0].Contact.Account.Text_Message_SMS_Notification__c== false);
        
    }
    
    
}