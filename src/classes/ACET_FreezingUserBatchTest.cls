@isTest
private class ACET_FreezingUserBatchTest {
     @testSetup
     static void setup() {
         Profile p = [SELECT Id
                        FROM Profile
                       WHERE Name = 'Center for Health Navigation'];

         List<User> users = new List<User>();

         for(Integer i = 0; i < 10; i++){
             users.add(new User(Alias = 'Test' + i,
                                Email = 'Test' + i + '@testorg.com ',
                                EmailEncodingKey = 'UTF-8',
                                LastName = 'last',
                                LanguageLocaleKey = 'en_US',
                                LocaleSidKey = 'en_US',
                                ProfileId = p.Id,
                                TimeZoneSidKey = 'America/Los_Angeles',
                                UserName = 'Testlast000' + i + '@testorg.com'));
         }
         insert users;
     }

     static testmethod void testBatch(){
         ACET_FreezingUserBatch c = new ACET_FreezingUserBatch();
         Test.startTest();
         Database.executeBatch(c);
         Test.stopTest();
     }
    
    static testmethod void testScheduler(){
        String cronExpr = '0 0 1 * * ? *';
        
        ACET_FreezingUserBatchScheduler schdFrz = new ACET_FreezingUserBatchScheduler();
        String jobId = System.schedule('Test ACET_FreezingUserBatchScheduler', cronExpr, schdFrz);
        schdFrz.execute(null);
    }
}