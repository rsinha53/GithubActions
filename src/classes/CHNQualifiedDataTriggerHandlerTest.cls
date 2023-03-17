@isTest
public class CHNQualifiedDataTriggerHandlerTest {
    
    public static testMethod void populateComplexIndicatorOnAccount() {
        test.startTest();
		String familyRecordTypeID = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Family').getRecordTypeId();

        Account acc = new Account(recordtypeid = familyRecordTypeID);
        acc.EID__c = '1057070455';
        acc.Name='test';
        //acc.LastName='Acc';
        insert acc;
        
        CHN_Qualified_Data__c  qulDt = new CHN_Qualified_Data__c ();
        qulDt.EID__c = '1057070455';
        qulDt.Last_Name__c = 'test last name';
        qulDt.Policy_Number__c = '123456';
        qulDt.Subscriber_Member_ID__c = '55555';
        qulDt.Complex_Indicator__c = 'test';
        
        insert qulDt;
        
        qulDt.Complex_Indicator__c = 'test test';
        qulDt.EID__c = '1057070455';
        update qulDt;
        
        Contact con = new Contact(AccountId = acc.Id,firstname='test',lastname='test');
        insert con;
        
        //AccountContactRelation acr = new AccountContactRelation(AccountId = acc.id,contactId = con.Id, complex_Indicator_text__c = 'Health Care(Evisor), Health Risk(SENS)');
        //insert acr;
        
        Sens_Publish__c sensPub = new Sens_Publish__c();
        sensPub.Account__c = acc.id;
        sensPub.EID__c = '1057070455';
        insert sensPub; 
        test.stopTest();
    }

}