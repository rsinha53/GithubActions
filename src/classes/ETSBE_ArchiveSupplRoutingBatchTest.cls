@isTest
public class ETSBE_ArchiveSupplRoutingBatchTest {
    
    public static testMethod void testDelSupplRoutingRecs() {
        
        Supplemental_Routing__c supplRoutingRecObj = new Supplemental_Routing__c();
        supplRoutingRecObj.Policy_Number__c = '702676';
        supplRoutingRecObj.Platform_Desc__c = 'UNET';
        supplRoutingRecObj.Policy_Nm__c = 'MICRO DEVICES';
        supplRoutingRecObj.Routing_Partner_ID__c = 'test@uhc.com';
        supplRoutingRecObj.Policy_Category_Desc__c = 'DENTAL CLAIMS DED';
        supplRoutingRecObj.Routing_Option_Desc__c = 'email';
        supplRoutingRecObj.End_Date__c = date.today().addDays(-30);
        
        insert supplRoutingRecObj;
        
        Test.StartTest();
        Supplemental_Routing__c supplRoutingRec = [Select Id FROM Supplemental_Routing__c];
        System.debug('TEST RECORD1: ' + supplRoutingRec);
        ETSBE_ArchiveSupplRoutingBatch batchObj = new ETSBE_ArchiveSupplRoutingBatch();
        Database.executeBatch(batchObj);        
        Test.StopTest();
        
    }

}