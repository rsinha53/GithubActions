@istest
public class ACETCreatePCPReferralControllertest {

    static testMethod void  ACETLaunchConsumerDashboardtestmethod1() {
        try{
            Interaction__c inte = TestDataFactory.createInteraction();
            account accountObj = new account();
            accountObj.Name = 'Test account';
            insert accountObj;
            
            RecordType newRecord = [SELECT Id FROM RecordType WHERE Name = 'Person Account' and SObjectType = 'Account'];
        
          Account accountTest = new Account();
          accountTest.FirstName = 'Test';
          accountTest.LastName = 'Contact';
          accountTest.EID__c = 'PIN';
          accountTest.EID__pc = 'PIN';
          accountTest.RecordTypeId = newRecord.Id;
          insert accountTest;
            
            Account acc = [SELECT Id,personcontactid from Account where Id=:accountTest.Id];
            Contact contactObj = [SELECT Id,LastName,FirstName,EID__c,AccountId from Contact where Id=:acc.personcontactid];
            ACETOrgNameToSwivelEndpointMap__c SwivelEndpoint = new ACETOrgNameToSwivelEndpointMap__c();
            SwivelEndpoint.name ='dev_ICUEPCPReferral';
            SwivelEndpoint.Swivel_Endpoint__c = 'test';
            insert SwivelEndpoint;
            
            ACETOrgInstanceURLToOrgNameMap__c orgnamemap = new ACETOrgInstanceURLToOrgNameMap__c();
            orgnamemap.Name = 'https://devacet--acetdev.cs26';
            orgnamemap.Org_Name__c = 'dev';
            insert orgnamemap;
            
            ACETWrapEncryptionKey__c encryptKey = new ACETWrapEncryptionKey__c();
            encryptKey.name ='dev_ICUEEncryptionKey';
            encryptKey.Key__c = 'tbC2KA36qE1psxs9mozyfOmy7GdrI3I9';
            insert encryptKey ;
            
            Map<String, String> mapTestCaseDetails = new Map<String, String>();
            //mapTestCaseDetails.put('AccountId', accountObj.Id);
            mapTestCaseDetails.put('ContactId', inte.Originator__c);
            mapTestCaseDetails.put('Interaction__c', inte.Id);
            mapTestCaseDetails.put('Status', 'Canceled');
            mapTestCaseDetails.put('Origin', 'Phone');
            mapTestCaseDetails.put('Topic__c', 'View Consumer Dashboard');
            Case TestCase = ACETTestDataUtility.CreateTestCase(mapTestCaseDetails); 
            
            Test.startTest();
            
            insert TestCase;
            string additional = '{"OriginatorRelationship":"Test","Relationship":"Test","SitusState":"Test","DOB":"Test","EndDate":"Test","EffectiveDate":"Test","PolicyNumber":"Test","GroupName":"Test","Product":"Test","ProductType":"Test","Network":"Test","ConsumerAccountIndicator":"Test"}';

            pagereference vfpage = page.ACETCreatePCPReferral;
            test.setcurrentpagereference(vfpage);
            apexpages.currentpage().getparameters().put('additionalInfo',additional);
            apexpages.currentpage().getparameters().put('contactId',contactObj.id);
            apexpages.currentpage().getparameters().put('SRK','testkey');
            apexpages.currentpage().getparameters().put('interactionId',inte.Id);
            apexpages.currentpage().getparameters().put('surrogateKey','123l3l3');
  
            Profile profileId = [SELECT Id,name FROM Profile WHERE Name = 'Research User' LIMIT 1];

            ACETCreatePCPReferralController ACETCreatePCP = new ACETCreatePCPReferralController();
            ACETCreatePCP.Topic  = 'Create PCPReferral';          
            ACETCreatePCP.refNumber= 'test1234';
            ACETCreatePCP.surrogateKey='123errff';
            ACETCreatePCP.updateWrapper();
            Test.stopTest();
            
        }
        catch(Exception ex)
        {
            system.debug('Exception is '+ex.getMessage()+'at line '+ex.getLineNumber()+'cause '+ex.getCause());
        }
    }
}