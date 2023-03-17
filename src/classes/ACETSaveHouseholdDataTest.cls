@istest(seealldata=false)
public class ACETSaveHouseholdDataTest {
    
    @isTest static void sniNotEligibleWithoutAcc() 
    {
        ACETHouseHoldWrapper.HouseHold[] hhList = new ACETHouseHoldWrapper.HouseHold[]{};
        ACETHouseHoldWrapper.HouseHold hhObj = new ACETHouseHoldWrapper.HouseHold();
        hhObj.dob = '6/17/1977' ; //date.valueOf(ACETUtility.formatDateFutureDate('6/17/1977'));
        hhObj.firstName = 'ConTest1';                   
        hhObj.lastName =  'ConTest2';    
        hhObj.fullName = 'familyAccFNname12';
        hhObj.memberId = '453543543';                   
        hhObj.policyId = '0070145';                   
        hhObj.relationship = 'Subscriber'; 
        hhObj.isMainMember = true;                 
        hhList.add(hhObj);
        list<user> u = [select id from user where profile.name = 'System Administrator' and isactive = true limit 1];
        system.runAs(u[0]){
            Test.startTest();
            ACETServiceRelationshipMap__c serviceRelations = new ACETServiceRelationshipMap__c();
            serviceRelations.Name ='Subscriber/Recipient';
            serviceRelations.Service_Relationship__c = 'Subscriber';
            insert serviceRelations;
            String accountId = ACETSaveHouseholdData.getSaveHouseHoldData(hhList,'6/17/1977','453543543','advFull1','not eligible','0070145','0070145','assignTo');
            Test.stopTest();
            System.assertEquals(null, accountId);
        }
        
    }
    @isTest static void sniNotEligibleWithAcc() 
    {
        ACETHouseHoldWrapper.HouseHold[] hhList = new ACETHouseHoldWrapper.HouseHold[]{};
        ACETHouseHoldWrapper.HouseHold hhObj = new ACETHouseHoldWrapper.HouseHold();
        hhObj.dob = '6/17/1977' ; //date.valueOf(ACETUtility.formatDateFutureDate('6/17/1977'));
        hhObj.firstName = 'ConTest1';                   
        hhObj.lastName =  'ConTest2';    
        hhObj.fullName = 'familyAccFNname12';
        hhObj.memberId = '453543543';                   
        hhObj.policyId = '0070145';                   
        hhObj.relationship = 'Subscriber/Recipient';                   
        hhList.add(hhObj);
        list<user> u = [select id from user where profile.name = 'System Administrator' and isactive = true limit 1];
        system.runAs(u[0]){
            Test.startTest();
            ACETServiceRelationshipMap__c rel = new ACETServiceRelationshipMap__c();
            rel.name = 'Subscriber/Recipient';
            rel.Service_Relationship__c = 'Subscriber/Recipient';
            insert rel;
            Id recordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Family').getRecordTypeId();
            Account ac = new Account();
            ac.Member_ID__c = '453543543';
            ac.Policy_ID__c = '0070145';
            ac.Name =   'SampleTEstFLAcc1';
            ac.RecordTypeId = recordTypeId;
            insert ac;
            String accountId = ACETSaveHouseholdData.getSaveHouseHoldData(hhList,'6/17/1977','453543543','advFull1','not eligible','0070145','0070145','assignTo');
            Test.stopTest();
            System.assertNotEquals(null, accountId);
        }
        
    }
    
    @isTest static void sniEligibleWithAcc() 
    {
        ACETHouseHoldWrapper.HouseHold[] hhList = new ACETHouseHoldWrapper.HouseHold[]{};
        ACETHouseHoldWrapper.HouseHold hhObj = new ACETHouseHoldWrapper.HouseHold();
        hhObj.dob = '6/17/1977' ; //date.valueOf(ACETUtility.formatDateFutureDate('6/17/1977'));
        hhObj.firstName = 'ConTest1';                   
        hhObj.lastName =  'ConTest2';    
        hhObj.fullName = 'familyAccFNname12';
        hhObj.memberId = '453543543';                   
        hhObj.policyId = '0070145';                   
        hhObj.relationship = 'Subscriber/Recipient';
        hhObj.isMainMember = true;
        hhList.add(hhObj);
        
        list<user> u = [select id from user where profile.name = 'System Administrator' and isactive = true limit 1];
        system.runAs(u[0]){
            Test.startTest();
            ACETServiceRelationshipMap__c rel = new ACETServiceRelationshipMap__c();
            rel.name = 'Subscriber/Recipient';
            rel.Service_Relationship__c = 'Subscriber/Recipient';
            insert rel;
            
            Id recordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Family').getRecordTypeId();
            Account ac = new Account();
            ac.Member_ID__c = '453543543';
            ac.Policy_ID__c = '0070145';
            ac.Name =   'SampleTEstFLAcc1';
            ac.RecordTypeId = recordTypeId;
            insert ac;
            String accountId = ACETSaveHouseholdData.getSaveHouseHoldData(hhList,'6/17/1977','453543543','advFull1','eligible','0070145','0070145','assignTo');
            Test.stopTest();
            System.assertNotEquals(null, accountId);
        }
        
    }
    @isTest static void sniEligibleWithAccWithpAc() 
    {
        ACETHouseHoldWrapper.HouseHold[] hhList = new ACETHouseHoldWrapper.HouseHold[]{};
        ACETHouseHoldWrapper.HouseHold hhObj = new ACETHouseHoldWrapper.HouseHold();
        hhObj.dob = '6/17/1977' ; //date.valueOf(ACETUtility.formatDateFutureDate('6/17/1977'));
        hhObj.firstName = 'ConTest1';                   
        hhObj.lastName =  'ConTest2';    
        hhObj.fullName = 'familyAccFNname12';
        hhObj.memberId = '453543543';                   
        hhObj.policyId = '0070145';                   
        hhObj.relationship = 'Subscriber/Recipient'; 
        hhObj.isMainMember = true;
        hhList.add(hhObj);
        ACETHouseHoldWrapper.HouseHold hhObj1 = new ACETHouseHoldWrapper.HouseHold();
        hhObj1.dob = '6/17/1979' ; //date.valueOf(ACETUtility.formatDateFutureDate('6/17/1977'));
        hhObj1.firstName = 'ConTest1';                   
        hhObj1.lastName =  'ConTest2';    
        hhObj1.relationship = 'Child/Other';
        hhObj1.isMainMember = false;        
        hhList.add(hhObj1);
        
        list<user> u = [select id from user where profile.name = 'System Administrator' and isactive = true limit 1];
        system.runAs(u[0]){
            Test.startTest();
            ACETServiceRelationshipMap__c rel = new ACETServiceRelationshipMap__c();
            rel.name = 'Subscriber/Recipient';
            rel.Service_Relationship__c = 'Subscriber/Recipient';
            insert rel;
            
            Id recordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Family').getRecordTypeId();
            Account ac = new Account();
            ac.Member_ID__c = '453543543';
            ac.Policy_ID__c = '0070145';
            ac.Name =   'SampleTEstFLAcc1';
            ac.RecordTypeId = recordTypeId;
            insert ac;
            Id personAccRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Individual').getRecordTypeId();
            Account pa =new account();
            pa.PersonBirthdate = date.valueOf(ACETUtility.formatDateFutureDate('6/17/1979'));
            pa.firstName = 'paLastSample1'; 
            pa.lastName = 'paFirstSample1'; 
            pa.RecordTypeId = personAccRecordTypeId;
            insert pa;
            account pa1 = [select id,personcontactid from account where id =: pa.id];
            AccountContactRelation acr = new AccountContactRelation();
            acr.ContactId = pa1.personcontactid;            
            acr.Accountid = ac.id;
            acr.Relationship__c = 'Child/Other';
            insert acr;
            String accountId = ACETSaveHouseholdData.getSaveHouseHoldData(hhList,'6/17/1979','453543543','advFull1','eligible','0070145','0070145','assignTo');
            Test.stopTest();
            System.assertNotEquals(null, accountId);
            
        }
        
    }
    @isTest static void sniEligibleWithAccWithpAc1() 
    {
        ACETHouseHoldWrapper.HouseHold[] hhList = new ACETHouseHoldWrapper.HouseHold[]{};
        ACETHouseHoldWrapper.HouseHold hhObj = new ACETHouseHoldWrapper.HouseHold();
        hhObj.dob = '6/17/1977' ; //date.valueOf(ACETUtility.formatDateFutureDate('6/17/1977'));
        hhObj.firstName = 'ConTest1';                   
        hhObj.lastName =  'ConTest2';    
        hhObj.fullName = 'familyAccFNname12';
        hhObj.memberId = '453543543';                   
        hhObj.policyId = '0070145';                   
        hhObj.relationship = 'Subscriber'; 
        hhObj.isMainMember = true;
        hhList.add(hhObj);
        ACETHouseHoldWrapper.HouseHold hhObj1 = new ACETHouseHoldWrapper.HouseHold();
        hhObj1.dob = '6/17/1979' ; //date.valueOf(ACETUtility.formatDateFutureDate('6/17/1977'));
        hhObj1.firstName = 'ConTest12';                   
        hhObj1.lastName =  'ConTest22';    
        hhObj1.relationship = 'Child/Other';
        hhObj1.isMainMember = false;
        hhList.add(hhObj1);
        
        
        list<user> u = [select id from user where profile.name = 'System Administrator' and isactive = true limit 1];
        system.runAs(u[0]){
            Test.startTest();
            ACETServiceRelationshipMap__c serviceRelations = new ACETServiceRelationshipMap__c();
            serviceRelations.Name ='Subscriber/Recipient';
            serviceRelations.Service_Relationship__c = 'Subscriber';
            insert serviceRelations;
            Id recordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Family').getRecordTypeId();
            Account ac = new Account();
            ac.Member_ID__c = '453543543';
            ac.Policy_ID__c = '0070145';
            ac.Name =   'SampleTEstFLAcc1';
            ac.RecordTypeId = recordTypeId;
            insert ac;
            
            Id personAccRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Individual').getRecordTypeId();
            Account pa =new account();
            pa.PersonBirthdate = date.valueOf(ACETUtility.formatDateFutureDate('6/17/1977'));
            pa.firstName = 'ConTest1'; 
            pa.lastName = 'ConTest2'; 
            pa.RecordTypeId = personAccRecordTypeId;
            insert pa;
            
            account pa1 = [select id,personcontactid from account where id =: pa.id];
            AccountContactRelation acr = new AccountContactRelation();
            acr.ContactId = pa1.personcontactid;            
            acr.Accountid = ac.id;
            acr.Relationship__c = 'Subscriber/Recipient';
            insert acr;
            
            String accountId = ACETSaveHouseholdData.getSaveHouseHoldData(hhList,'6/17/1977','453543543','advFull1','eligible','0070145','0070145','assignTo');
            Test.stopTest();
            System.assertNotEquals(null, accountId);        
        }
    }
    @isTest static void sniEligibleWithAccWithpAc2() 
    {
        ACETHouseHoldWrapper.HouseHold[] hhList = new ACETHouseHoldWrapper.HouseHold[]{};
        ACETHouseHoldWrapper.HouseHold hhObj = new ACETHouseHoldWrapper.HouseHold();
        hhObj.dob = '6/17/1977' ; //date.valueOf(ACETUtility.formatDateFutureDate('6/17/1977'));
        hhObj.firstName = 'ConTest1';                   
        hhObj.lastName =  'ConTest2';    
        hhObj.fullName = 'familyAccFNname12';
        hhObj.memberId = '453543543';                   
        hhObj.policyId = '0070145';                   
        hhObj.relationship = 'Subscriber'; 
        hhObj.isMainMember = true;
        hhList.add(hhObj);
        ACETHouseHoldWrapper.HouseHold hhObj1 = new ACETHouseHoldWrapper.HouseHold();
        hhObj1.dob = '6/17/1979' ; //date.valueOf(ACETUtility.formatDateFutureDate('6/17/1977'));
        hhObj1.firstName = 'ConTest12';                   
        hhObj1.lastName =  'ConTest22';    
        hhObj1.relationship = 'Child';
        hhObj1.isMainMember = false;
        hhList.add(hhObj1);
        list<user> u = [select id from user where profile.name = 'System Administrator' and isactive = true limit 1];
        system.runAs(u[0]){
            Test.startTest();
            ACETServiceRelationshipMap__c serviceRelations = new ACETServiceRelationshipMap__c();
            serviceRelations.Name ='Subscriber/Recipient';
            serviceRelations.Service_Relationship__c = 'Subscriber';
            insert serviceRelations;
            Id recordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Family').getRecordTypeId();
            Account ac = new Account();
            ac.Member_ID__c = '453543543';
            ac.Policy_ID__c = '0070145';
            ac.Name =   'SampleTEstFLAcc1';
            ac.RecordTypeId = recordTypeId;
            insert ac;
            
            Id personAccRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Individual').getRecordTypeId();
            Account pa =new account();
            pa.PersonBirthdate = date.valueOf(ACETUtility.formatDateFutureDate('6/17/1977'));
            pa.firstName = 'ConTest1'; 
            pa.lastName = 'ConTest2'; 
            pa.RecordTypeId = personAccRecordTypeId;
            insert pa;
            
            account pa1 = [select id,personcontactid from account where id =: pa.id];
            AccountContactRelation acr = new AccountContactRelation();
            acr.ContactId = pa1.personcontactid;            
            acr.Accountid = ac.id;
            acr.Relationship__c = 'Child/Other';
            insert acr;
            
            String accountId = ACETSaveHouseholdData.getSaveHouseHoldData(hhList,'6/17/1977','453543543','advFull1','eligible','0070145','0070145','assignTo');
            Test.stopTest();
            System.assertNotEquals(null, accountId);
        }
    }
    @isTest static void sniEligibleWithoutAcc() 
    {
        ACETHouseHoldWrapper.HouseHold[] hhList = new ACETHouseHoldWrapper.HouseHold[]{};
        ACETHouseHoldWrapper.HouseHold hhObj = new ACETHouseHoldWrapper.HouseHold();
        hhObj.dob = '6/17/1977' ; //date.valueOf(ACETUtility.formatDateFutureDate('6/17/1977'));
        hhObj.firstName = 'ConTest1';                   
        hhObj.lastName =  'ConTest2';    
        hhObj.fullName = 'familyAccFNname12';
        hhObj.memberId = '453543543';                   
        hhObj.policyId = '0070145';                   
        hhObj.relationship = 'Subscriber'; 
        hhObj.isMainMember = true;
        hhList.add(hhObj);
        list<user> u = [select id from user where profile.name = 'System Administrator' and isactive = true limit 1];
        system.runAs(u[0]){
            Test.startTest();
            ACETServiceRelationshipMap__c serviceRelations = new ACETServiceRelationshipMap__c();
            serviceRelations.Name ='Subscriber/Recipient';
            serviceRelations.Service_Relationship__c = 'Subscriber';
            insert serviceRelations;
            String accountId = ACETSaveHouseholdData.getSaveHouseHoldData(hhList,'6/17/1977','453543543','advFull1','eligible','0070145','0070145','assignTo');
            Test.stopTest();
            System.assertNotEquals(null, accountId);
        }
        
    }
    
}