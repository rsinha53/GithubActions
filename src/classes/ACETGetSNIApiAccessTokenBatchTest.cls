@isTest
public class ACETGetSNIApiAccessTokenBatchTest {
    @isTest
    
    public static void testMethod1(){
       
         Test.setMock(HttpCalloutMock.class, new MockHttpTokenResponseGenerator('empty'));
        Database.executeBatch(new ACETGetSNIApiAccessTokenBatch());
    }
     @isTest
    public static void testMethod2(){
          ISL_Webservice_Config__c newCustomSetting = new ISL_Webservice_Config__c();
            newCustomSetting.Name = 'SNIAPIAccessToken';
            newCustomSetting.Value__c = '';
			newCustomSetting.ACET_Common_Name__c = 'SNIApiEndpoint';
        insert newCustomSetting;
          Test.setMock(HttpCalloutMock.class, new MockHttpTokenResponseGenerator('response'));
        Database.executeBatch(new ACETGetSNIApiAccessTokenBatch());
       
    }
     @isTest
    public static void testMethod3(){
       ACETGetSNIAPIAccessTokenScheduler obj = new ACETGetSNIAPIAccessTokenScheduler();
        SchedulableContext sc;
        obj.execute(sc);
    }
    @isTest
    public static void testMethod4(){
          ISL_Webservice_Config__c newCustomSetting = new ISL_Webservice_Config__c();
            newCustomSetting.Name = 'SNIAPIAccessToken';
            newCustomSetting.Value__c = '';
			newCustomSetting.ACET_Common_Name__c = 'SNIApiEndpoint';
        insert newCustomSetting;
          Test.setMock(HttpCalloutMock.class, new MockHttpTokenResponseGenerator('expiry'));
        Database.executeBatch(new ACETGetSNIApiAccessTokenBatch());
       
    }
    
}