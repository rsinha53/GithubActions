@isTest
public class ChatterAnswersTest {
	@istest()
    static void createAccountTest(){  
        ChatterAnswers ca = new ChatterAnswers();
        ca.createAccount('fname','lname',userinfo.getUserId());
    }
}