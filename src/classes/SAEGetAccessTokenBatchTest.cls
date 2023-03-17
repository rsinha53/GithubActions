@isTest
public class SAEGetAccessTokenBatchTest {
    @isTest
    
    public static void testMethod1(){
        
      /*  Test.setMock(HttpCalloutMock.class, new MockHttpTokenResponseGenerator('empty'));
        Database.executeBatch(new SAEGetAccessTokenBatch()); */
    }
   /* @isTest
    public static void testMethod2(){
        List<Token_Generation__c> lstTokenGen = new List<Token_Generation__c>([SELECT Id, Name, Value__c,Token_Name__c  
                                                                               FROM Token_Generation__c WHERE Token_Name__c =: 'ISLConAccessToken']);
        Test.setMock(HttpCalloutMock.class, new MockHttpTokenResponseGenerator('response'));
        Database.executeBatch(new SAEGetAccessTokenBatch());
        
    }
    @isTest
    public static void testMethod3(){
        SAEGetAccessTokenScheduler  obj = new SAEGetAccessTokenScheduler ();
        SchedulableContext sc;
        obj.execute(sc);
    } */
}