@isTest
public class MemberInformationHandlerTest {
    @isTest static void MemberInformationTest() {
        account accFam = new account();
        string recTypeId = [select id from recordtype where name= 'Family'].id;
        accFam.recordtypeid = recTypeId;
        accFam.Name = 'FamilymemberTest1';
        insert accFam;
        
        account accPerson = new account();
        string recTypeId1 = [select id from recordtype where name= 'Individual'].id;
        accPerson.recordtypeid = recTypeId1;
        accPerson.LastName = 'PersonmemberTest1';
        insert accPerson;
        
        string conId = [select PersonContactid from Account where id =: accPerson.id].PersonContactid;
        
        AccountContactRelation accCon = new AccountContactRelation();
        accCon.accountId = accFam.id;
        accCon.contactid = conId;
        insert accCon;
        
        Member_Information__c memInform = new Member_Information__c();
        memInform.Program_Associations__c = 'Complex Care_Pediatric Home Services;Neurodegenerative';
        memInform.Account__c = accPerson.id;
        insert memInform;
        
        memInform.Program_Associations__c = 'Serious Illness Support;Neurodegenerative';
        update memInform;
    }

}