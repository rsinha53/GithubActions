@isTest
public class ACETFamilyStoryGuideUIControllerTest {
    @isTest
    public static void test1(){
         Family_Story_Guide__c fsg1 = ACETFamilyStoryGuideUIControllerTest.createFSG1();  
        Family_Story_Guide_Questionare__c qs1 = ACETFamilyStoryGuideUIControllerTest.createQuestion('Insurance and Finance',1.1,'1.1','A) Yes');
        Family_Story_Guide_Questionare__c qs2 = ACETFamilyStoryGuideUIControllerTest.createQuestion('Social Determinants',3.1,'3.1','A) Food');
        Family_Story_Guide_Questionare__c qs3 = ACETFamilyStoryGuideUIControllerTest.createQuestion('Social Determinants',3.1,'3.1','B) Medicine');
        Family_Story_Guide_Questionare__c qs4 = ACETFamilyStoryGuideUIControllerTest.createQuestion('Insurance and Finance',6.1,'6.1','B) No');
        Family_Story_Guide_Answers__c anw1 = ACETFamilyStoryGuideUIControllerTest.createANswer(fsg1.id,qs1.id);
		Family_Story_Guide_Answers__c anw2 = ACETFamilyStoryGuideUIControllerTest.createANswer(fsg1.id,qs2.id);
        list<string> lstStr = ACETFamilyStoryGuideUIController.getPickListValuesIntoList();
        
        List<ACETFamilyStoryGuideUIController.wrapperQuestions> lstWrap = ACETFamilyStoryGuideUIController.getTopicQuestions('Insurance and Finance');
        List<ACETFamilyStoryGuideUIController.wrapperQuestions> lstWrap1 = ACETFamilyStoryGuideUIController.getDefaultTopicQuestions();
        
        
        string fsg = ACETFamilyStoryGuideUIController.getFsgStatus(fsg1.id);
        list<string> lstStr1 = ACETFamilyStoryGuideUIController.getSavedInterventions(fsg1.id);
        list<Family_Story_Guide_Answers__c> lstAnsw =  ACETFamilyStoryGuideUIController.getSavedAnswers(fsg1.id);
        map<string,list<ACETFamilyStoryGuideUIController.wrapperAnswers>> mapansw = ACETFamilyStoryGuideUIController.forNotesSection(fsg1.id, new list<string>{'Insurance and Finance'});
		map<string,list<ACETFamilyStoryGuideUIController.wrapperAnswers>> mapansw1 = ACETFamilyStoryGuideUIController.forNotesSection(fsg1.id, new list<string>{'Social Determinants'});
        ACETFamilyStoryGuideUIController.saveDeleteAnswers(string.valueOf(fsg1.id),string.valueOf(qs1.id),'','','2.1');
        ACETFamilyStoryGuideUIController.saveDeleteAnswers(string.valueOf(fsg1.id),string.valueOf(qs2.id),'','','3.1');
		ACETFamilyStoryGuideUIController.saveDeleteAnswers(string.valueOf(fsg1.id),string.valueOf(qs2.id)+';'+string.valueOf(qs3.id),'','','3.1');
        ACETFamilyStoryGuideUIController.saveDeleteAnswers(string.valueOf(fsg1.id),string.valueOf(qs1.id),'','','6.1');
		ACETFamilyStoryGuideUIController.saveDeleteAnswers(string.valueOf(fsg1.id),string.valueOf(qs1.id),'','','6.2');
        ACETFamilyStoryGuideUIController.saveDeleteAnswers(string.valueOf(fsg1.id),string.valueOf(qs1.id),'','','1.3');
        list<string> lstcomplddata = ACETFamilyStoryGuideUIController.getCompletedData(fsg1.id);
    }
    public static Family_Story_Guide__c createFSG1(){
        Family_Story_Guide__c fsg = new Family_Story_Guide__c();
        fsg.Status__c = 'Not Offered';
        insert fsg;
        return fsg;
    }
    public static Family_Story_Guide_Questionare__c createQuestion(string topic,decimal qOrd, string qNum,string response){
        Family_Story_Guide_Questionare__c qs1 = new Family_Story_Guide_Questionare__c();
        qs1.Topic__c = topic;
        qs1.Question__c = 'Many families need help paying for healthcare needs. Insurance, government programs, private foundations and grants can be possible sources for such help. Have you had the opportunity to see if your child might be eligible for these kinds of supports?';
        qs1.Question_Order__c = qOrd;
        qs1.QuestionNumber__c = qNum;
        qs1.Response__c = response;
        insert qs1;
        return qs1;
    }
    public static Family_Story_Guide_Answers__c createANswer(string fsgId, string fsgQsid){
        Family_Story_Guide_Answers__c fsgAn = new Family_Story_Guide_Answers__c();
        fsgAn.Family_Story_Guide__c = fsgId;
        fsgAn.Family_Story_Guide_Questionare__c = fsgQsid;
        insert fsgAn;
        return fsgAn;
    }
}