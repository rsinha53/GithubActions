@isTest
public class SNI_FL_AddFamilyMemControllerTest {
    @isTest 
    static void getCareTeamMembersTest(){
        Id recordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Family').getRecordTypeId();
        List<Account> accList=new List<Account>();
        List<SNI_FL_Care_Team_Member__c> teamlist=new List<SNI_FL_Care_Team_Member__c>();
        Account ac = new Account();
        ac.Member_ID__c = '453543154';
        ac.Policy_ID__c = '0070154';
        ac.Name =   'FLTestAcc154';
        ac.RecordTypeId = recordTypeId;
        accList.add(ac);
        
        Id personAccRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Individual').getRecordTypeId();
        Account pa =new account();
        pa.PersonBirthdate = date.valueOf(ACETUtility.formatDateFutureDate('6/17/1979'));
        pa.firstName = 'Community'; 
        pa.lastName = 'FLCreteamTestUser'; 
        pa.RecordTypeId = personAccRecordTypeId;
        accList.add(pa);       
        
        Account pa2 =new account();
        pa2.PersonBirthdate = date.valueOf(ACETUtility.formatDateFutureDate('6/7/1979'));
        pa2.firstName = 'Community'; 
        pa2.lastName = 'FLCreteamTestUser1'; 
        pa2.RecordTypeId = personAccRecordTypeId;
        accList.add(pa2);       
        insert accList;
        date dt = system.today().addYears(-1);
        SNI_FL_AddFamilyMemController.getCareTeamMembers('firsname11','lastname11',dt,ac.id,'');
        dt = dt.addYears(-2);
        SNI_FL_AddFamilyMemController.getCareTeamMembers('firsname12','lastname12',dt,ac.id,pa.id);
    }
}