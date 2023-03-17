@isTest
public class SAE_CallTopicControllerTest {
	 @testSetup static void setup() {
        // Create common test accounts
        
        List<Call_Topic_Access__c> testTopics = new List<Call_Topic_Access__c>();
        for(Integer i=0;i<5;i++) {
            testTopics.add(new Call_Topic_Access__c(Name = 'Call Topic'+i, Detail_Page__c = 'Member Detail'));
        }
        testTopics.add(new Call_Topic_Access__c(Name = 'Call Topic exclude', Detail_Page__c = 'Member Detail')); 
        insert testTopics;        
    }
    
    static testMethod void test_fetchLookUpValues() {
        Test.startTest();
        List<Call_Topic_Access__c> testTopics = new List<Call_Topic_Access__c>();
        testTopics.add(new Call_Topic_Access__c(Name = 'Plan Benefits'));
        insert testTopics;
        List < Call_Topic_Access__c > returnList = SAE_CallTopicController.fetchLookUpValues('','Call_Topic_Access__c',testTopics,'Member Detail','Member');
        
        System.assertEquals(testTopics[0].Name,'Plan Benefits');
        Test.stopTest();
    }

    static testmethod void getCallTopicOptionsTest(){
        Test.startTest();
        Profile profileId = [SELECT Id FROM Profile WHERE Name = 'System Administrator' LIMIT 1];
        Group testgroup=[SELECT Id,DeveloperName FROM Group WHERE DeveloperName='Spire_Pilot_Team' LIMIT 1];

        User testUser = new User(LastName = 'testP',
                           FirstName='testP',
                           Alias = 'tp',
                           Email = 'aceagenttest6677656@ac.com',
                           Username = 'aceagenttest6677656@ac.com',
                           ProfileId = profileId.id,
                           TimeZoneSidKey = 'GMT',
                           LanguageLocaleKey = 'en_US',
                           EmailEncodingKey = 'UTF-8',
                           LocaleSidKey = 'en_US'
                           );
        insert testUser;

        GroupMember testMember=new GroupMember();
        testMember.GroupId=testgroup.Id;
        testMember.UserOrGroupId=testUser.Id;
        insert testMember;

        List <Call_Topic_Access__c> returnList= new  List <Call_Topic_Access__c>();
        system.runAs(testUser){

            List<Call_Topic_Access__c> testCallTopics = new List<Call_Topic_Access__c>();
            testCallTopics.add(new Call_Topic_Access__c(Name = 'View Claims',Limit_to_Public__c='Spire_Pilot_Team',Detail_Page__c='Member Snapshot',Originator_Type__c='Provider'));
            insert testCallTopics;

            List<Call_Topic_Access__c> excludeTopics = new List<Call_Topic_Access__c>();
            excludeTopics.add(new Call_Topic_Access__c(Name = 'Plan Benefits'));
            insert excludeTopics;

            returnList =SAE_CallTopicController.fetchLookUpValues('View Claims','Call_Topic_Access__c',excludeTopics,'Member Snapshot','Provider');
            system.debug('Return value '+ returnList);
            System.assertEquals(returnList[0].Name,'View Claims');

        }
        Test.stopTest();
    }
    
}