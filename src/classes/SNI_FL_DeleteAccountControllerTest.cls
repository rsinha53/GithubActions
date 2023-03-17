@isTest
public class SNI_FL_DeleteAccountControllerTest {
   
    @isTest static void deactivateUserTest(){
        Test.startTest();
            List<String> careTeamLst = new List<String>();
            Id recordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Family').getRecordTypeId();
            List<Account> accList=new List<Account>();
            Account ac = new Account();
            ac.Member_ID__c = '453543543';
            ac.Policy_ID__c = '0070145';
            ac.Name =   'SampleTestFLAcc1';
            ac.RecordTypeId = recordTypeId;
            accList.add(ac);
            
            Id personAccRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Individual').getRecordTypeId();
            Account pa =new account();
            pa.PersonBirthdate = date.valueOf(ACETUtility.formatDateFutureDate('6/17/1979'));
            pa.firstName = 'Community'; 
            pa.lastName = 'TestUser'; 
            pa.RecordTypeId = personAccRecordTypeId;
            accList.add(pa);
        
            Account pa2 =new account();
            pa2.PersonBirthdate = date.valueOf(ACETUtility.formatDateFutureDate('6/17/1979'));
            pa2.firstName = 'paLastSample1'; 
            pa2.lastName = 'paFirstSample1'; 
            pa2.RecordTypeId = personAccRecordTypeId;
            accList.add(pa2);
        
            insert accList;
            List<Contact> conId = [SELECT id from contact where accountId =: pa.Id];
            List<Profile> pList = [SELECT Id,Name FROM Profile WHERE Name =: 'Care Advisor Connect Community User']; 
            User u = new User(Alias = 'standt', Email='fec@testorg.com', 
                              EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
                              LocaleSidKey='en_US', ProfileId = pList.get(0).id, contactId =conId[0].Id,
                              TimeZoneSidKey='America/Los_Angeles', UserName='fec@acettest.com',IsActive=true);
            

            
            List<SNI_FL_Care_Team_Member__c> ctmList = new List<SNI_FL_Care_Team_Member__c>();
        List<String> ctmwithPrimary = new List<String>();
            SNI_FL_Care_Team_Member__c ctm = new SNI_FL_Care_Team_Member__c();
            ctm.SNI_FL_Family__c = ac.Id;
            ctm.SNI_FL_Member__c = pa.Id;
            ctm.SNI_FL_Status__c = 'Registered';
            ctm.SNI_FL_Primary_Caregiver__c = true;
            ctm.SNI_FL_Not_Visible_in_Familylink__c= false;
            ctmList.add(ctm);
            SNI_FL_Care_Team_Member__c ctm2 = new SNI_FL_Care_Team_Member__c();
            ctm2.SNI_FL_Family__c = ac.Id;
            ctm2.SNI_FL_Member__c = pa2.Id;
            ctm2.SNI_FL_Status__c = 'Registered';
            ctm2.SNI_FL_Primary_Caregiver__c = true;
            ctm2.SNI_FL_Not_Visible_in_Familylink__c = false;
            ctmList.add(ctm2);
            insert ctmList; 
        	ctmwithPrimary.add(ctmList[0].SNI_FL_Member__c);
            for(SNI_FL_Care_Team_Member__c ctmMem : ctmList){
                careTeamLst.add(ctmMem.Id);
            }
            system.runAs(u){
                SNI_FL_DeleteAccountController.deactivateUser(accList[0].Id);
                SNI_FL_DeleteAccountController.careTeamUpdate(accList[0].Id);
                SNI_FL_DeleteAccountController.careTeamUpdateStatus(careTeamLst);
                SNI_FL_DeleteAccountController.updateUserRec(careTeamLst,accList[0].Id);
                SNI_FL_DeleteAccountController.updateUserRecForFamily(ctmwithPrimary,ac.Id);
                SNI_FL_DeleteAccountController.HSIDmemUrls();
            }
       Test.stopTest();
    }

}