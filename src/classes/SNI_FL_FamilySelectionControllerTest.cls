@istest(seealldata=false)
public class SNI_FL_FamilySelectionControllerTest {
    @isTest static void getFamilyDetails(){
        Id personAccRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Individual').getRecordTypeId();
        Account pa =new account();
        pa.PersonBirthdate = date.valueOf(ACETUtility.formatDateFutureDate('6/17/1979'));
        pa.firstName = 'Community'; 
        pa.lastName = 'TestUser'; 
        pa.RecordTypeId = personAccRecordTypeId;
        insert pa;
        List<Contact> conId = [SELECT id from contact where accountId =: pa.Id];
        
            Id recordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Family').getRecordTypeId();
            Account ac = new Account();
            ac.Member_ID__c = '453543543';
            ac.Policy_ID__c = '0070145';
            ac.Name =   'SampleTestFLAcc1';
            ac.RecordTypeId = recordTypeId;
            insert ac;
            Account pa2 =new account();
            pa2.PersonBirthdate = date.valueOf(ACETUtility.formatDateFutureDate('6/17/1979'));
            pa2.firstName = 'paLastSample1'; 
            pa2.lastName = 'paFirstSample1'; 
            pa2.RecordTypeId = personAccRecordTypeId;
            insert pa2;
            List<SNI_FL_Care_Team_Member__c> ctmList = new List<SNI_FL_Care_Team_Member__c>();
            SNI_FL_Care_Team_Member__c ctm = new SNI_FL_Care_Team_Member__c();
            ctm.SNI_FL_Family__c = ac.Id;
            ctm.SNI_FL_Member__c = pa.Id;
            ctm.SNI_FL_Status__c = 'Registered';
            ctm.SNI_FL_Primary_Caregiver__c = true;
            ctm.SNI_FL_Not_Visible_in_Familylink__c = false;
            ctmList.add(ctm);
            SNI_FL_Care_Team_Member__c ctm2 = new SNI_FL_Care_Team_Member__c();
            ctm2.SNI_FL_Family__c = ac.Id;
            ctm2.SNI_FL_Member__c = pa2.Id;
            ctm2.SNI_FL_Status__c = 'Registered';
            ctm2.SNI_FL_Not_Visible_in_Familylink__c = false;
            ctmList.add(ctm2);
			insert ctmList;
        Profile p = [SELECT Id FROM Profile WHERE Name='Care Advisor Connect Community User'];
        User thisUser = [Select Id From User Where Id =:UserInfo.getUserId()];
         System.runAs(thisUser){
        User u = new User(Alias = 'standt', Email='fec@testorg.com', 
                          EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
                          LocaleSidKey='en_US', ProfileId = p.Id, contactId =conId[0].Id,
                          TimeZoneSidKey='America/Los_Angeles', UserName='fec@acettest.com');
         
            system.runAs(u){ // Making changes as the account owner cannot be a community user 
            Test.startTest();
            SNI_FL_FamilySelectionController.getFamilyDetails();
            Test.stopTest();
            }
        }
    }
}