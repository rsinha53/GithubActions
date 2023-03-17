@IsTest
public class SNI_DataMigrationCaseCreationBatchTest {
    Static testmethod void SNI_DataMigrationCaseCreationBatchTestMethod(){
        Test.StartTest(); 
        List<String> lsSNImigrationUsers = Label.SNI_DataMigration_Users.split(',');
        List<User> usrList = [select id from user where Id in :lsSNImigrationUsers];
        system.runas(usrList[0]){
            Account acc = new Account();
            acc.name = 'Test';
            insert acc;
            Contact con = new contact();
            con.lastname = 'testlast';
            con.AccountId = acc.Id;
            insert con;
            Contact con2 = new contact();
            con2.lastname = 'testlast1';
            con2.AccountId = acc.Id;
            insert con2;
            List<case> CSList = [select id from case where contactid = :con2.Id];
            delete CSList;
        }
        SNI_DataMigrationCaseCreationBatch batch = new SNI_DataMigrationCaseCreationBatch ();
        ID batchprocessid = database.Executebatch(batch); 
        Test.StopTest();
    }
    
}