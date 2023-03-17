@isTest(seealldata=false)
private class ACET_SpecialityValuesSchedulerTest {
    
    @isTest static void specialityValuesSchedulerTest() {
        
        ISL_Webservice_Config__c apiEndpointSetting = new ISL_Webservice_Config__c(Name='dev_SpecialityServiceEndPoint',
                                                                                   Value__c='zwdsk9VPXJASohgqS2zqXD0UxD9MEa5g');
        Insert apiEndpointSetting;
        
        ISL_Webservice_Config__c authToken = new ISL_Webservice_Config__c(Name='SNIAPIAccessToken',
                                                                                   Value__c='zwdsk9VPXJASohgqS2zqXD0UxD9MEa5g');
        Insert authToken;
        
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new SAEHttpCalloutMock.SAESpecialityValueMock());
        System.schedule('testjob', '0 45 * * * ?', new ACET_SpecialityValuesScheduler());
        Test.stopTest(); 
    }
}