@isTest
public class ACET_CreateSrnProviderCardControllerTest {
    
	static testMethod void test_MandR(){
        Test.startTest();
        // adding additional params for getMAndRProviderStatus - US3244384 Integration for Member Div to Provider Div Mapping - Sarma - 01/03/2021
        ACET_CreateSrnProviderCardController.getMAndRProviderStatus('','','','','','','','');//US3574032
    }
    
    static testMethod void test_NetworkKey(){
        Test.startTest();
        ACET_CreateSrnProviderCardController.getNetworkKeyStatus('','','','');
    }
    
    static testMethod void test_EandI(){
        Test.startTest();
        ACET_CreateSrnProviderCardController.getEAndIProviderStatus('','','','','','','');
    }
    
    
}