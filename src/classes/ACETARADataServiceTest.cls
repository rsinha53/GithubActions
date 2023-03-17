@isTest
public class ACETARADataServiceTest {
 /* Method Name: insertCaseDataTest
    *  Description: Method is to test the insertCaseData
    */
      static testMethod void insertCaseDataTest(){ 
          List<Account> accList=new List<Account>();
          Id recordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Family').getRecordTypeId();
            Account ac = new Account();
            ac.Member_ID__c = '973833845';
            ac.Policy_ID__c = '0016058';
            ac.Name =   'SampleTEstFLAcc1';
            ac.RecordTypeId = recordTypeId;
            insert ac;
            Id personAccRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Individual').getRecordTypeId();
            Account pa =new account();
            pa.PersonBirthdate = date.valueOf(ACETUtility.formatDateFutureDate('6/17/1979'));
            pa.firstName = 'Owen';
            pa.lastName = 'FLViewAuthTestUser';
            pa.RecordTypeId = personAccRecordTypeId;
            accList.add(pa);
            insert accList;
            
            List<Contact> conId = [SELECT id from contact where accountId =: pa.Id];
            AccountContactRelation accConRelation = new AccountContactRelation();
            accConRelation.AccountId = ac.Id;
            accConRelation.ContactId = conId[0].Id;
            insert accConRelation;
            
            Family_Overview__c fo = new Family_Overview__c();
            fo.Name='test';
            fo.Account__c = ac.Id;
            insert fo;
            String json = '{"subscriber_nbr":"000351263","policy_id":"16058","alt_id":"00973833845","birthdate":"1979-06-17","patient_name":"HART,OWEN","alert_type":"NLIM","alert_shared_date":"2018-05-09","benefit_therapy_indicator":"H","coverage_type":"PT","total_benefit_limit":"50","benefit_limit_used":"26","percent_benefit_used":"23","limit_exceeded_claim_proc_date":"2018-04-18","benefit_start_date":"2018-04-12","benefit_end_date":"2022-06-09","plan_type":"AH","benefit_network_type":"0","soft_or_hard_limit" :"soft Limit"}';
            RestRequest req = new RestRequest();
            req.requestBody =Blob.valueof(json);
            RestContext.request = req;
			Test.startTest();
            ACETARADataService.insertCaseData();
            Test.stopTest();
    }
   }