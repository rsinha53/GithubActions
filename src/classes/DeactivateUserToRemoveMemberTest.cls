/*------------------------------------------------------------
Description:   Test class for DeactivateUserToRemoveMember  

History
Date            Author              Comments
-------------------------------------------------------------
14-NOV-2022     Geeta Koli      	Created
------------------------------------------------------------*/
@isTest
public class DeactivateUserToRemoveMemberTest {

    static testMethod void deactivateUserTestPositive(){
        List<SNI_FL_Care_Team_Member__c> careTeamMember = new List<SNI_FL_Care_Team_Member__c>();
        List<Account> memberLst = new List<Account>();
        Id personRecTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Individual').getRecordTypeId();
        Id familyRecTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Family').getRecordTypeId();
        Account famAcc = new Account(Name = 'test', 
                                     Member_Id__c = '11223344',
                                     recordtypeId = familyRecTypeId);
        memberLst.add(famAcc);       
        INSERT memberLst;
        Account personAcc = new Account(FirstName = 'test', 
                                        lastName = 'test', 
                                        ParentId = famAcc.Id,
                                        recordtypeId = personRecTypeId);
        memberLst.add(personAcc);
        SNI_FL_Care_Team_Member__c ctmMember = new SNI_FL_Care_Team_Member__c(SNI_FL_Member__c = personAcc.id,
                                                                              SNI_FL_Status__c = 'Added',
                                                                              SNI_FL_Family__c = famAcc.Id,
                                                                              SNI_FL_Primary_Caregiver__c = true,
                                                                              Email__c = 'test@test.com');
        
        careTeamMember.add(ctmMember);
        INSERT careTeamMember;
        List<String> memberList = new List<String>();
        memberList.add(personAcc.Id);
        test.startTest();
        DeactivateUserToRemoveMember obj = new DeactivateUserToRemoveMember(memberList,famAcc.Id);
        System.enqueueJob(obj); 
        test.stopTest();
    }
}