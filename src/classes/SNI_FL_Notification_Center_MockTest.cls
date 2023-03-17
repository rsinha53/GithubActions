@isTest
public class SNI_FL_Notification_Center_MockTest {
    @isTest
    public static void testMethod1(){
        HTTPRequest req = new HTTPRequest();
        req.setEndpoint('https://gateway-stage.optum.com/auth/oauth2/cached/token');
         Test.startTest();
        SNI_FL_Notification_Center_MockCallout flnotfication = new SNI_FL_Notification_Center_MockCallout();
        flnotfication.respond(req);
        Test.stopTest();
    }
    @isTest
    public static void testMethod2(){
        HTTPRequest req = new HTTPRequest();
        req.setEndpoint('https://gateway-stage.optum.com/api/test/ccs/comm/communications/electronic-mails/v2');
         Test.startTest();
        SNI_FL_Notification_Center_MockCallout flnotfication = new SNI_FL_Notification_Center_MockCallout();
        flnotfication.respond(req);
        Test.stopTest();
    }
    @isTest
    public static void testMethod3(){
        HTTPRequest req = new HTTPRequest();
        req.setEndpoint('https://gateway-stage.optum.com/api/test/ccs/comm/communications/text-messages/v2');
        Test.startTest();
        SNI_FL_Notification_Center_MockCallout flnotfication = new SNI_FL_Notification_Center_MockCallout();
        flnotfication.respond(req);
        Test.stopTest();
    }
    
}