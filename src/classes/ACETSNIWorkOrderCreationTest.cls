@isTest
public class ACETSNIWorkOrderCreationTest {

    @isTest static void checkExistingWOTestMethod1(){
        test.startTest();
        Id priorAuthRecordType = Schema.SObjectType.WorkOrder.getRecordTypeInfosByName().get('Prior Authorization').getRecordTypeId();           
        Id familyRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Family').getRecordTypeId();
        Id personAccRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Individual').getRecordTypeId();
        List<Account> accList=new List<Account>();
            Account ac = new Account();
            ac.Member_ID__c = '453543145';
            ac.Policy_ID__c = '0070145';
            ac.Name =   'Member1 Bourne Family';
            ac.RecordTypeId = familyRecordTypeId;
            accList.add(ac);
            
            Account pa =new account();
            pa.PersonBirthdate = date.valueOf(ACETUtility.formatDateFutureDate('6/17/1979'));
            pa.firstName = 'Member1'; 
            pa.lastName = 'Bourne'; 
            pa.RecordTypeId = personAccRecordTypeId;
            accList.add(pa);       
            
            Account pa2 =new account();
            pa2.PersonBirthdate = date.valueOf(ACETUtility.formatDateFutureDate('6/7/1979'));
            pa2.firstName = 'Member2'; 
            pa2.lastName = 'Bourne'; 
            pa2.RecordTypeId = personAccRecordTypeId;
            accList.add(pa2);       
            insert accList;
        
            pa=[Select id,personcontactid,personcontact.birthdate,PersonBirthdate,firstName,lastName from account where id=:pa.Id];
            pa2=[Select id,personcontactid,personcontact.birthdate,PersonBirthdate,firstName,lastName from account where id=:pa2.Id];
        
            Member_Information__c mem1=new Member_Information__c();
            mem1.Account__c=pa2.id;
            mem1.Onshore_Restriction__c='Yes';
            mem1.UHG_Restriction__c='No';
            insert mem1;

            System.debug('personcontact.birthdate='+pa.personcontact.birthdate);
        
            List<AccountContactRelation> acrList=new list<AccountContactRelation>();
            AccountContactRelation acr = new AccountContactRelation();
            System.debug('pa2.personcontactid='+pa2.personcontactid);
            acr.ContactId = pa2.personcontactid;            
            acr.Accountid = accList[0].id;
            acr.Relationship__c = 'Child/Other';
            acrList.add(acr);
        
            AccountContactRelation acr1 = new AccountContactRelation();
            System.debug('pa.personcontactid='+pa.personcontactid);
            acr1.ContactId = pa.personcontactid;            
            acr1.Accountid = accList[0].id;
            acr1.Relationship__c = 'Subscriber/Recipient';
            acrList.add(acr1);
            insert acrList;
        
        ACETSNIICUEDataParser wrap=new ACETSNIICUEDataParser();
        wrap.policy='0070145';
        wrap.memberId = '453543145';
        wrap.memberDOB='1979-06-07';
        wrap.memFirstName='Member2';
        wrap.memLastName='Bourne';
        wrap.serviceRef='testclass_123456';
        wrap.HSCId='testHSCId';
        wrap.xrefID='testXrefID';
        wrap.statusDetail='Decision has been made';
        wrap.reviewPriority='Concurrent Expedited';
        wrap.serviceSetting='important';
        wrap.hostSystemTimeStamp='2003-02-15';
        wrap.startDate = '2020-02-23';
        wrap.endDate = '2020-03-23';
        wrap.expectedAdmissionDate = '2020-02-23';
        wrap.expectedDischargeDate = '2020-03-23';
        wrap.actualAdmissionDate = '2020-02-23';
        //wrap.actualdDischargeDate = '2020-02-23';
        wrap.diagnosisCodes=  new List<String>{ ('123'), ('456')};
        ACETSNIICUEDataParser.ServiceLine sl=new ACETSNIICUEDataParser.ServiceLine();
        sl.serviceLinkUniqueId = '123';
        sl.decisionOutCome = 'Covered/Approved - Clinical';
        sl.decisionSubType = 'Test';
        sl.decisionReason = 'Claims Processing Error';
        sl.procedureCode = 'procedureCode';
        sl.procedureDescription = 'procedureDescription';
        wrap.serviceLines=new list<ACETSNIICUEDataParser.ServiceLine>{sl};
            
        ACETSNIICUEDataParser.ProviderInfo pr=new ACETSNIICUEDataParser.ProviderInfo();
        pr.providerUniqueID = '1234';
        pr.providerNetworkStatus = '56789';
        pr.providerName = 'providerName';
        pr.providerRole= new list<String>{('Servicing')};
        wrap.providerInfos=new list<ACETSNIICUEDataParser.ProviderInfo>{pr};
         
        ACETSNIWorkOrderCreation.checkExistingWO(wrap);
        wrap.startDate = '2020-02-24';
        ACETSNIWorkOrderCreation.checkExistingWO(wrap);
        test.stopTest();
    }
    
     //Need to include mock response for link here to get overall coverage
     @isTest static void checkExistingWOTestMethod2(){
        test.startTest();
        ACETSNIICUEDataParser wrap=new ACETSNIICUEDataParser();
        wrap.policy='0070148';
        wrap.memberId = '453543146';
        wrap.memberDOB='1979-06-07';
        wrap.memFirstName='Member3';
        wrap.memLastName='Bourne';
        wrap.serviceRef='testclass_1234567';
        wrap.HSCId='testHSCId1';
        wrap.xrefID='testXrefID1';
        wrap.statusDetail='Decision has been made';
        wrap.reviewPriority='Concurrent Expedited';
        wrap.serviceSetting='important';
        wrap.hostSystemTimeStamp='2003-02-15';
        wrap.startDate = '2020-02-23';
        wrap.endDate = '2020-03-23';
        wrap.expectedAdmissionDate = '2020-02-23';
        wrap.expectedDischargeDate = '2020-03-23';
        wrap.actualAdmissionDate = '2020-02-23';
        //wrap.actualdDischargeDate = '2020-02-23';
        wrap.diagnosisCodes=  new List<String>{ ('123'), ('456')};
        ACETSNIICUEDataParser.ServiceLine sl=new ACETSNIICUEDataParser.ServiceLine();
        sl.serviceLinkUniqueId = '123890';
        sl.decisionOutCome = 'Covered/Approved - Clinical';
        sl.decisionSubType = 'Test';
        sl.decisionReason = 'Claims Processing Error';
        sl.procedureCode = 'procedureCode';
        sl.procedureDescription = 'procedureDescription';
        wrap.serviceLines=new list<ACETSNIICUEDataParser.ServiceLine>{sl};
            
        ACETSNIICUEDataParser.ProviderInfo pr=new ACETSNIICUEDataParser.ProviderInfo();
        pr.providerUniqueID = '1234890';
        pr.providerNetworkStatus = '56789';
        pr.providerName = 'providerName';
        pr.providerRole= new list<String>{('Servicing')};
        wrap.providerInfos=new list<ACETSNIICUEDataParser.ProviderInfo>{pr};
         
        ACETSNIWorkOrderCreation.checkExistingWO(wrap);
        wrap.startDate = '2020-02-24';
        ACETSNIWorkOrderCreation.checkExistingWO(wrap);
        test.stopTest();
    }

}