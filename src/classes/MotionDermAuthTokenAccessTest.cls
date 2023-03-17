@isTest
private class MotionDermAuthTokenAccessTest{

    @isTest
    
    public static void testDermAccessTokenGeneration(){
        Test.setMock(HttpCalloutMock.class, new MockHttpDermAPITokenResponseGenerator('empty'));
        MotionDermAuthTokenAccess authAccessToken = new MotionDermAuthTokenAccess();        
        Test.startTest();
        authAccessToken.getAccessToken();
        Test.stopTest();

    }   
    
    @TestSetup
    static void makeData(){
        ISL_Webservice_Config__c apiCustomSetting = new ISL_Webservice_Config__c();
        apiCustomSetting.Name = 'MotionDermOauthGrantType';
        apiCustomSetting.ACET_Common_Name__c= 'MotionDerm';
        apiCustomSetting.Value__c = 'client_credentials';
        insert apiCustomSetting;
        apiCustomSetting = new ISL_Webservice_Config__c();
        apiCustomSetting.Name = 'MotionDermOauthClientId';
        apiCustomSetting.ACET_Common_Name__c= 'MotionDerm';
        apiCustomSetting.Value__c = 'uhc';
        insert apiCustomSetting;
        apiCustomSetting = new ISL_Webservice_Config__c();
        apiCustomSetting.Name = 'MotionDermOauthClientSecret';
        apiCustomSetting.ACET_Common_Name__c= 'MotionDerm';
        apiCustomSetting.Value__c = 'zC7I3v.,QOjA';
        insert apiCustomSetting;
        apiCustomSetting = new ISL_Webservice_Config__c();
        apiCustomSetting.Name = 'MotionDermAccessTokenApiEndpoint';
        apiCustomSetting.ACET_Common_Name__c= 'MotionDerm';
        apiCustomSetting.Value__c = 'https://model.connect.unitedhealthcaremotion.com/connect/token';
        insert apiCustomSetting;
    }

}