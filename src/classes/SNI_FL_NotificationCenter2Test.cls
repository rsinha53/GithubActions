@isTest
public class SNI_FL_NotificationCenter2Test {
    
    
	private static void setupData()
    {
        WebserviceConfigurations__c newrec=new WebserviceConfigurations__c();
        newrec.active__c=true;
        newrec.name='SMS GeneratePhoneId';
        newrec.Method__c='POST';
        newrec.Headers__c='[{"key":"Authorization","value":"Bearer <:AUTH_TOKEN:>"},{"key":"Content-Type","value":"application/json"},{"key":"actor","value":"ACET"}]';
        newrec.JSONBodyWithMergeFields__c='{\n\"id\": \"00411796502\",\n\"idType\": \"searchid\",\n\"dateOfBirth\": \"1995-11-21\"\n}';
        newrec.EndpointPath__c='https://api-stg.uhg.com/api/identity/user/individuals/v1/search';
        insert newrec;
         WebserviceConfigurations__c newrec1=new WebserviceConfigurations__c();
        newrec1.active__c=true;
        newrec1.name='SMS Authorization';
        newrec1.Method__c='POST';
        newrec1.Headers__c='[{"key":"Authorization","value":"Bearer <:AUTH_TOKEN:>"},{"key":"Content-Type","value":"application/json"},{"key":"actor","value":"ACET"}]';
        newrec1.JSONBodyWithMergeFields__c='{\n\"id\": \"00411796502\",\n\"idType\": \"searchid\",\n\"dateOfBirth\": \"1995-11-21\"\n}';
        newrec1.EndpointPath__c='https://api-stg.uhg.com/api/identity/user/individuals/v1/search';
        insert newrec1;
         WebserviceConfigurations__c newrec2=new WebserviceConfigurations__c();
        newrec2.active__c=true;
        newrec2.name='SMS subscribePhoneID';
        newrec2.Method__c='POST';
        newrec2.Headers__c='[{"key":"Authorization","value":"Bearer <:AUTH_TOKEN:>"},{"key":"Content-Type","value":"application/json"},{"key":"actor","value":"ACET"}]';
        newrec2.JSONBodyWithMergeFields__c='{\n\"id\": \"00411796502\",\n\"idType\": \"searchid\",\n\"dateOfBirth\": \"1995-11-21\"\n}';
        newrec2.EndpointPath__c='https://api-stg.uhg.com/api/identity/user/individuals/v1/search';
        insert newrec2;
         WebserviceConfigurations__c newrec3=new WebserviceConfigurations__c();
        newrec3.active__c=true;
        newrec3.name='SMS getPhoneIdValue';
        newrec3.Method__c='POST';
        newrec3.Headers__c='[{"key":"Authorization","value":"Bearer <:AUTH_TOKEN:>"},{"key":"Content-Type","value":"application/json"},{"key":"actor","value":"ACET"}]';
        newrec3.JSONBodyWithMergeFields__c='{\n\"id\": \"00411796502\",\n\"idType\": \"searchid\",\n\"dateOfBirth\": \"1995-11-21\"\n}';
        newrec3.EndpointPath__c='https://api-stg.uhg.com/api/identity/user/individuals/v1/search';
        insert newrec3;
        WebserviceConfigurations__c newrec4=new WebserviceConfigurations__c();
        newrec4.active__c=true;
        newrec4.name='SMS Notification';
        newrec4.Method__c='POST';
        newrec4.Headers__c='[{"key":"Authorization","value":"Bearer <:AUTH_TOKEN:>"},{"key":"Content-Type","value":"application/json"},{"key":"actor","value":"ACET"}]';
        newrec4.JSONBodyWithMergeFields__c='{\n\"id\": \"00411796502\",\n\"idType\": \"searchid\",\n\"dateOfBirth\": \"1995-11-21\"\n}';
        newrec4.EndpointPath__c='https://api-stg.uhg.com/api/identity/user/individuals/v1/search';
        insert newrec4;
        
        WebserviceConfigurations__c newrec5=new WebserviceConfigurations__c();
        newrec5.active__c=true;
        newrec5.name='SMS getSubscriptionStatus';
        newrec5.Method__c='POST';
        newrec5.Headers__c='[{"key":"Authorization","value":"Bearer <:AUTH_TOKEN:>"},{"key":"Content-Type","value":"application/json"},{"key":"actor","value":"ACET"}]';
        newrec5.JSONBodyWithMergeFields__c='{\n\"id\": \"00411796502\",\n\"idType\": \"searchid\",\n\"dateOfBirth\": \"1995-11-21\"\n}';
        newrec5.EndpointPath__c='https://api-stg.uhg.com/api/identity/user/individuals/v1/search';
        insert newrec5;
        
        WebserviceConfigurations__c newrec6=new WebserviceConfigurations__c();
        newrec6.active__c=true;
        newrec6.name='SMS UnsubscribePhoneID';
        newrec6.Method__c='POST';
        newrec6.Headers__c='[{"key":"Authorization","value":"Bearer <:AUTH_TOKEN:>"},{"key":"Content-Type","value":"application/json"},{"key":"actor","value":"ACET"}]';
        newrec6.JSONBodyWithMergeFields__c='{\n\"id\": \"00411796502\",\n\"idType\": \"searchid\",\n\"dateOfBirth\": \"1995-11-21\"\n}';
        newrec6.EndpointPath__c='https://api-stg.uhg.com/api/identity/user/individuals/v1/search';
        insert newrec6;
    }
    @isTest
    public static void test()
    {
        setupData();
       
        Test.startTest();
        Test.setMock(HttpCalloutMock.class,new ExampleCalloutMock());
       SNI_FL_NotificationCenter2.isSubscribed=true;
        SNI_FL_NotificationCenter2.sendSMS('8317687698','This is message from CHN');
          
        Test.stopTest();
    
    }
      @isTest
    public static void test2()
    {
        setupData();
       
        Test.startTest();
        Test.setMock(HttpCalloutMock.class,new ExampleCalloutMock1());
       
        SNI_FL_NotificationCenter2.sendSMS('8317687698','This is message from CHN');
          
        Test.stopTest();
    
    }

    @isTest
    public static void UnsubscribePhoneIDTest()
    {
        setupData();
        Test.startTest();
        Test.setMock(HttpCalloutMock.class,new ExampleCalloutMock());
        SNI_FL_NotificationCenter2.isSubscribed=true;
        SNI_FL_NotificationCenter2.UnsubscribePhoneID('8317687698');
        Test.stopTest();
    }
    
    @isTest
    public static void subscribePhoneIDUITest()
    {
        setupData();
        Test.startTest();
        Test.setMock(HttpCalloutMock.class,new ExampleCalloutMock());
      
        SNI_FL_NotificationCenter2.subscribePhoneIDUI('8317687698');
        SNI_FL_NotificationCenter2.getPhoneIdValue('ABCDEFGHIOYVJG66873VGt','8317687698');
       // SNI_FL_NotificationCenter2.getSubscriptionStatus('ABCDEFGHIOYVJG66873VGt','8317687698','507273');
               // SNI_FL_NotificationCenter2.getPhoneIdValue('8317687698'); 

        Test.stopTest();
    }
 @isTest
    public static void subscribePhoneIDUITest1()
    {
        setupData();
        Test.startTest();
        Test.setMock(HttpCalloutMock.class,new ExampleCalloutMock2());
         SNI_FL_NotificationCenter2.getSubscriptionStatus('ABCDEFGHIOYVJG66873VGt','8317687698','507273');

        Test.stopTest();
    }

  @isTest
    public static void errorTest()
    {
     	setupData();
          
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new ExampleCalloutErrorMock());
        SNI_FL_NotificationCenter2.sendSMS('8317687698','Hello');
        Test.stopTest();
    } 
}