@isTest
public class ACET_DeleteVCCDResponseBatchTest{

    @isTest
    static void testBatch(){
        //VCCD Response Creation
        VCCD_Response__c vccdRes = new VCCD_Response__c();
        vccdRes.isActive__c = false;
        insert vccdRes;
        
        Test.startTest();
        Database.executeBatch(new ACET_DeleteVCCDResponseBatch());
        Test.stopTest();
    }

}