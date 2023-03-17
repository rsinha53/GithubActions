/*------------------------------------------------------------
Author:        Harshini Thotakura
Description:   Test class for ManageActivitiesApex Class 
History
Date           Author               Comments
-------------------------------------------------------------
29-11-2022     Harshini Thotakura   Created 
------------------------------------------------------------*/
@isTest
public class ManageActivitiesControllerTest{
    
    private static final String memberId = '453543543'; 
    
    
    @isTest 
    static void testSuccess() 
    {
        
        Id personAccRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Individual').getRecordTypeId();
        Id recordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Family').getRecordTypeId();
        
        Account ac = new Account();
        ac.Member_ID__c = memberId;
        ac.Policy_ID__c = '0070145';
        ac.Name =   'SampleTestFLAcc1';
        ac.RecordTypeId = recordTypeId;
        insert ac;
        
        Account pa =new account();
        pa.firstName = 'paLastSample1'; 
        pa.lastName = 'paFirstSample1';
        pa.Policy_ID__c = '0070145';
        pa.Member_ID__c = memberId;
        pa.RecordTypeId = personAccRecordTypeId;
        insert pa;
        
        pa = [SELECT Id,PersonContactId FROM Account WHERE Id =:pa.Id];
        
        AccountContactRelation acr = new AccountContactRelation();
        acr.ContactId = pa.PersonContactId;            
        acr.Accountid = ac.id;
        acr.Relationship__c = 'Child/Other';
        insert acr;
        
        Map<String,String> resultMap = (Map<String,String>) ManageActivitiesController.getAccountDetails(string.valueOf(pa.Id));
        system.assert(resultMap.get('memberId') == memberId, 'Error fetching member id'); 
    }
    
    /**
     * Testing error scenario with invalid Account Id
     */ 
    @isTest 
    static void testError() 
    {
        try{
            ManageActivitiesController.getAccountDetails('invalidAcctId');
        }catch(Exception ex){
            system.assert(ex.getTypeName() == 'System.AuraHandledException' , 'Error handling the exception');
        }
    }
    
}