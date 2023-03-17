@isTest
public class ACET_QuestionnaireControllerTest {
    static testmethod void getQuestionnairesTest(){
        
        ACET_QuestionnaireController.QuestionnairesRes res = ACET_QuestionnaireController.getQuestionnaires('PA Check','Q1'); 
    }
}