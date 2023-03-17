@isTest
public class SNI_FL_CareTeamTriggerHandlerTest {
     @testSetup static void testSetupCareTeamData(){
        Id recordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Family').getRecordTypeId();
            List<Account> accList=new List<Account>();
            List<SNI_FL_Care_Team_Member__c> teamlist=new List<SNI_FL_Care_Team_Member__c>();
            Account ac = new Account();
            ac.Member_ID__c = '453543145';
            ac.Policy_ID__c = '0070145';
            ac.Name =   'FLTestAcc145';
            ac.RecordTypeId = recordTypeId;
            accList.add(ac);
            
            Id personAccRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Individual').getRecordTypeId();
            Account pa =new account();
            pa.PersonBirthdate = date.valueOf(ACETUtility.formatDateFutureDate('6/17/1979'));
            pa.firstName = 'Community'; 
            pa.lastName = 'FLCreteamTestUser'; 
            pa.RecordTypeId = personAccRecordTypeId;
            pa.MultiPolicyCheck__c=true;
            accList.add(pa);       
            
            Account pa2 =new account();
            pa2.PersonBirthdate = date.valueOf(ACETUtility.formatDateFutureDate('6/7/1979'));
            pa2.firstName = 'Community'; 
            pa2.lastName = 'FLCreteamTestUser1'; 
            pa2.RecordTypeId = personAccRecordTypeId;
            pa2.MultiPolicyCheck__c=true;
            accList.add(pa2);   
            insert accList;
         
            set<id> accSet=new set<id>{(pa.Id),(pa2.Id)};
            Id contactId,contactId1;
            for(Contact con:[SELECT id,accountId from contact where accountId in : accSet]){
             if(con.accountId==pa.Id)
                contactId=con.id;
              else
                contactId1=con.id; 
            }
            List<AccountContactRelation> acrList=new List<AccountContactRelation>();
            AccountContactRelation acr=new AccountContactRelation();
            acr.AccountId=ac.id;
            acr.contactID= contactId;
            acrList.add(acr);
         
            AccountContactRelation acr1=new AccountContactRelation();
            acr1.AccountId=ac.id;
            acr1.contactID= contactId1;
            acrList.add(acr1);
         
            insert acrList;
            
         	SNI_FL_Care_Team_Member__c teamMemb = new SNI_FL_Care_Team_Member__c();
          	teamMemb.SNI_FL_Primary_Caregiver__c = false;
            teamMemb.SNI_FL_Status__c='Registered';
            teamMemb.SNI_FL_Family__c = ac.Id;
            teamMemb.SNI_FL_Member__c = pa.Id;
            teamMemb.SNI_FL_Not_Visible_in_Familylink__c = true;
            teamlist.add(teamMemb);
         
           	SNI_FL_Care_Team_Member__c teamMemb1 = new SNI_FL_Care_Team_Member__c();
          	teamMemb1.SNI_FL_Primary_Caregiver__c = false;
            teamMemb1.SNI_FL_Family__c = ac.Id;
            teamMemb1.SNI_FL_Member__c = pa.Id;
            teamMemb1.SNI_FL_Status__c='Registered';
            teamMemb1.SNI_FL_Not_Visible_in_Familylink__c = true;
            teamlist.add(teamMemb1);
            insert teamlist;
            
            List<Profile> pList = [SELECT Id,Name FROM Profile WHERE Name =: 'Care Advisor Connect Community User']; 
          User thisUser = [Select Id From User Where Id =:UserInfo.getUserId()];
         System.runAs(thisUser){
         	User u = new User(Alias = 'standt', Email='flCareTeamtest@testorg.com', 
                          EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
                          LocaleSidKey='en_US', ProfileId = pList.get(0).id, contactId =contactId,
                          TimeZoneSidKey='America/Los_Angeles',MobilePhone='9000000001', UserName='flCareTeamtest@testorg.com',IsActive=true);
            insert u;
         }
    }
    
    @isTest static void getFamilyInfoTest(){
        Test.startTest();
                User u = [SELECT Id ,Email,contact.accountid from User where UserName='flCareTeamtest@testorg.com' LIMIT 1];
         		SNI_FL_Care_Team_Member__c peracc = [SELECT Id,SNI_FL_Family__c,SNI_FL_Member__c,SNI_FL_Not_Visible_in_Familylink__c from SNI_FL_Care_Team_Member__c where SNI_FL_Member__c =: u.contact.accountid LIMIT 1];       		
        		peracc.SNI_FL_Not_Visible_in_Familylink__c=false;
                update peracc;
       Test.stopTest();
    }

}