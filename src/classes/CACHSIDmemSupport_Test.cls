@isTest
public class CACHSIDmemSupport_Test {
    @isTest
    public static void HSIDmemUrls() {
        Id recordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Provider_Affiliation').getRecordTypeId();
        List<Account> accList = new List<Account>();
        Account ac = new Account();
        ac.Member_ID__c = '453543543';
        ac.Policy_ID__c = '0070145';
        ac.Name =   'SampleTEstFLAcc1';
        ac.RecordTypeId = recordTypeId;
        accList.add(ac);
        
        Account ac1 = new Account();
        ac1.Member_ID__c = '453543542';
        ac1.Policy_ID__c = '0070142';
        ac1.Name =   'SampleTEstFLAcc2';
        ac1.RecordTypeId = recordTypeId;
        accList.add(ac1);
        
        Account ac3 = new Account();
        ac3.Member_ID__c = '453543543';
        ac3.Policy_ID__c = '0070145';
        ac3.Name =   'SampleTEstFLAcc3';
        ac3.RecordTypeId = recordTypeId;
        accList.add(ac3);
        insert accList;
        
        Id personAccRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Individual').getRecordTypeId();
        
        Account pa =new account();
        pa.firstName = 'paLastSample1'; 
        pa.lastName = 'paFirstSample1'; 
        pa.RecordTypeId = personAccRecordTypeId;
        insert pa;
        
        Account pa1 =new account(); 
        pa1.firstName = 'paLastSample2'; 
        pa1.lastName = 'paFirstSample2'; 
        pa1.RecordTypeId = personAccRecordTypeId;
        insert pa1;
        
        account pa2 = [select id,personcontactid from account where id =: pa.id];
        Profile p = [SELECT Id FROM Profile WHERE Name='Care Advisor Connect Community User']; 
        User u;
        system.runAs(new user(Id = userinfo.getUserId())){
            u = new User(Alias = 'standt', Email='standarduser@testorg.com.acet', 
                         EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
                         LocaleSidKey='en_US', ProfileId = p.Id, 
                         TimeZoneSidKey='America/Los_Angeles', UserName='standarduser45454@testorg.com');
            u.ContactId = pa2.personcontactid;
            insert u;      
        }
        
        AccountContactRelation acr = new AccountContactRelation();
        acr.ContactId = pa2.personcontactid;            
        acr.Accountid = accList[0].id;
        acr.Relationship__c = 'Child/Other';
        insert acr;
        List<program__c> programList=new List<program__c>();
        Program__c pgm = new Program__c();
        pgm.Program__c = 'Complex Care';
        programList.add(pgm);
        insert programList;
        system.debug('Userdetails--'+acr);
        System.runAs(u){
            CACHSIDmemSupport.HSIDmemUrls();
        }
    }
    @isTest
    public static void getCustMetaData(){
        FeatureFlagConfig__mdt fetConf = [select Id,MasterLabel,isEnabled__c from FeatureFlagConfig__mdt where MasterLabel = 'OpenHSIDurls'];
        CACHSIDmemSupport.getCustMetaData();
    }
}