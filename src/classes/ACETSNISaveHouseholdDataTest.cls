@isTest
public class ACETSNISaveHouseholdDataTest {
    public static String datest = '10/14/2011, 11:46:00';
    public static String addressst = '1018 WILLOWBROOK DRIVE';
    @isTest static void sniNotEligibleWithoutAcc()
    {
        ACETServiceRelationshipMap__c rel = new ACETServiceRelationshipMap__c();
        rel.name = 'Subscriber/Recipient';
        rel.Service_Relationship__c = 'Subscriber/Recipient';
        insert rel;
        Id recordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Family').getRecordTypeId();
        Account ac = new Account();
        ac.Member_ID__c = '453543543';
        ac.Policy_ID__c = '0070145';
        ac.Name =   'familyAccFNname12';
        ac.RecordTypeId = recordTypeId;
        insert ac;
        ACETHouseHoldWrapper wrplist = new ACETHouseHoldWrapper();
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
            //Creation of workorder start
            WorkOrder wo= new WorkOrder();
            wo.First_Name__c='ConTest1';
            wo.Last_Name__c='ConTest2';
            wo.Date_of_Birth__c= ACETUtility.parseDate('6/17/1977');
            wo.Policy_ID__c='0070145';
            wo.Member_ID__c='453543543';
            wo.Add_Member__c=true;
            wo.Status_Detail__c='Clinical Review';
            wo.Host_System_Date_and_Time__c=ACETUtility.parseDateTime(datest);
            insert wo;
            try{ 
                ACETHouseHoldWrapper.memberDetails meber = ACETSNISaveHouseholdData.getSaveHouseHoldData(hhList,'6/17/1977',wo.Id,'453543543','advFull1','not eligible','0070145','0070145','assignTo','E&I','SNI','National Team','123456');
            }catch(Exception e){
                
            }
        }
        
    }
    @isTest static void sniNotEligibleWithAcc()
    {
        ACETServiceRelationshipMap__c rel = new ACETServiceRelationshipMap__c();
        rel.name = 'Subscriber/Recipient';
        rel.Service_Relationship__c = 'Subscriber/Recipient';
        insert rel;
        ACETHouseHoldWrapper wrplist = new ACETHouseHoldWrapper();
        ACETHouseHoldWrapper.HouseHold[] hhList = new ACETHouseHoldWrapper.HouseHold[]{};
            ACETHouseHoldWrapper.HouseHold hhObj = new ACETHouseHoldWrapper.HouseHold();
        hhObj.dob = '6/17/1977' ; //date.valueOf(ACETUtility.formatDateFutureDate('6/17/1977'));
        hhObj.firstName = 'ConTest1';
        hhObj.lastName =  'ConTest2';
        hhObj.fullName = 'familyAccFNname12';
        hhObj.memberId = '00Q453543543';
        hhObj.policyId = '0070145';
        hhObj.relationship = 'Subscriber/Recipient';
        hhList.add(hhObj);
        list<user> u = [select id from user where profile.name = 'System Administrator' and isactive = true limit 1];
        system.runAs(u[0]){
            Id recordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Family').getRecordTypeId();
            Account ac = new Account();
            ac.Member_ID__c = '00Q453543543';
            ac.Policy_ID__c = '0070145';
            ac.Name =   'SampleTEstFLAcc1';
            ac.RecordTypeId = recordTypeId;
            
            insert ac;
            //Creation of workorder start
            WorkOrder wo= new WorkOrder();
            wo.First_Name__c='ConTest1';
            wo.Last_Name__c='ConTest2';
            wo.Date_of_Birth__c= ACETUtility.parseDate('6/17/1977');
            wo.Policy_ID__c='0070145';
            wo.Member_ID__c='453543543';
            wo.Add_Member__c=true;
            wo.Status_Detail__c='Clinical Review';
            wo.Host_System_Date_and_Time__c=ACETUtility.parseDateTime(datest);
            insert wo;
            try{
                //ACETHouseHoldWrapper.memberDetails meber = ACETSNISaveHouseholdData.getSaveHouseHoldData(ACETHouseHoldWrapper.HouseHold[] houseHoldData,String dob,String memberId,string advFullName,String sniEligibleStatus,String policyId,String policyIdOrignal,String assignTo){
                ACETHouseHoldWrapper.memberDetails meber = ACETSNISaveHouseholdData.getSaveHouseHoldData(hhList,'6/17/1977',wo.Id,'00Q453543543','advFull1','not eligible','0070145','0070145','assignTo','E&I','SNI','National Team','123456');
                //ACETHouseHoldWrapper.memberDetails meber1 = ACETSNISaveHouseholdData.getSaveHouseHoldData(hhList,'6/17/1977','453543543','advFull1','eligible','0070145','0070145','assignTo');
                
            }catch(Exception e){
                
            }
            
        }
        
    }
    
    @isTest static void sniEligibleWithoutAcc()
    {
        ACETServiceRelationshipMap__c rel = new ACETServiceRelationshipMap__c();
        rel.name = 'Subscriber/Recipient';
        rel.Service_Relationship__c = 'Subscriber/Recipient';
        insert rel;
        
        ACETHouseHoldWrapper wrplist = new ACETHouseHoldWrapper();
        ACETHouseHoldWrapper.HouseHold[] hhList = new ACETHouseHoldWrapper.HouseHold[]{};
            ACETHouseHoldWrapper.HouseHold hhObj = new ACETHouseHoldWrapper.HouseHold();
        hhObj.dob = '6/17/1977' ; //date.valueOf(ACETUtility.formatDateFutureDate('6/17/1977'));
        hhObj.firstName = 'ConTest1';
        hhObj.lastName =  'ConTest2';
        hhObj.fullName = 'familyAccFNname12';
        hhObj.memberId = '453543543';
        hhObj.policyId = '0070145';
        hhObj.relationship = 'Subscriber/Recipient';
        hhObj.CHNEligibile = false;
        hhObj.CHNQualified = true;
        hhList.add(hhObj);
        list<user> u = [select id from user where profile.name = 'System Administrator' and isactive = true limit 1];
        //Creation of workorder start
        WorkOrder wo= new WorkOrder();
        wo.First_Name__c='ConTest1';
        wo.Last_Name__c='ConTest2';
        wo.Date_of_Birth__c= ACETUtility.parseDate('6/17/1977');
        wo.Policy_ID__c='0070145';
        wo.Member_ID__c='453543543';
        wo.Add_Member__c=true;
        wo.Status_Detail__c='Clinical Review';
        wo.Host_System_Date_and_Time__c=ACETUtility.parseDateTime(datest);
        insert wo;
        system.runAs(u[0]){
            try{
                ACETHouseHoldWrapper.memberDetails meber1 = ACETSNISaveHouseholdData.getSaveHouseHoldData(hhList,'6/17/1977',wo.Id,'453543543','advFull1','eligible','0070145','0070145','assignTo','E&I','SNI','National Team','123456');
            }catch(Exception e){
                system.debug('error--'+e);
            }  
        }
        
    }
    @isTest static void sniEligibleWithAcc()
    {
        ACETServiceRelationshipMap__c rel = new ACETServiceRelationshipMap__c();
        rel.name = 'Subscriber/Recipient';
        rel.Service_Relationship__c = 'Subscriber/Recipient';
        insert rel;
        
        ACETHouseHoldWrapper wrplist = new ACETHouseHoldWrapper();
        ACETHouseHoldWrapper.HouseHold[] hhList = new ACETHouseHoldWrapper.HouseHold[]{};
            ACETHouseHoldWrapper.HouseHold hhObj = new ACETHouseHoldWrapper.HouseHold();
        hhObj.dob = '6/17/1977' ; //date.valueOf(ACETUtility.formatDateFutureDate('6/17/1977'));
        hhObj.firstName = 'ConTest1';
        hhObj.lastName =  'ConTest2';
        hhObj.fullName = 'familyAccFNname12';
        hhObj.memberId = '00Q453543543';
        hhObj.policyId = '0070145';
        hhObj.relationship = 'Subscriber/Recipient';
        hhList.add(hhObj);
        
        list<user> u = [select id from user where profile.name = 'System Administrator' and isactive = true limit 1];
        system.runAs(u[0]){
            Id recordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Family').getRecordTypeId();
            Account ac = new Account();
            ac.Member_ID__c = '00Q453543543';
            ac.Policy_ID__c = '0070145';
            ac.Name =   'SampleTEstFLAcc1';
            ac.RecordTypeId = recordTypeId;
            
            insert ac;
            //Creation of workorder start
            WorkOrder wo= new WorkOrder();
            wo.First_Name__c='ConTest1';
            wo.Last_Name__c='ConTest2';
            wo.Date_of_Birth__c= ACETUtility.parseDate('6/17/1977');
            wo.Policy_ID__c='0070145';
            wo.Member_ID__c='453543543';
            wo.Add_Member__c=true;
            wo.Status_Detail__c='Clinical Review';
            wo.Host_System_Date_and_Time__c=ACETUtility.parseDateTime(datest);
            insert wo;
            try{
                ACETHouseHoldWrapper.memberDetails meber1 = ACETSNISaveHouseholdData.getSaveHouseHoldData(hhList,'6/17/1977',wo.Id,'00Q453543543','advFull1','eligible','0070145','0070145','assignTo','E&I','SNI','National Team','123456');
            }catch(Exception e){
                
            }
        }
        
    }
    @isTest static void sniEligibleWithAccWithpAc(){
        ACETServiceRelationshipMap__c rel = new ACETServiceRelationshipMap__c();
        rel.name = 'Subscriber/Recipient';
        rel.Service_Relationship__c = 'Subscriber/Recipient';
        insert rel;
        /*   ACETServiceRelationshipMap__c rel1 = new ACETServiceRelationshipMap__c();
rel1.name = 'Child/Other';
rel1.Service_Relationship__c = 'Child/Other';
insert rel1;
*/
        ACETHouseHoldWrapper wrplist = new ACETHouseHoldWrapper();
        ACETHouseHoldWrapper.HouseHold[] hhList = new ACETHouseHoldWrapper.HouseHold[]{};
            ACETHouseHoldWrapper.HouseHold hhObj = new ACETHouseHoldWrapper.HouseHold();
        hhObj.dob = '6/17/1977' ; //date.valueOf(ACETUtility.formatDateFutureDate('6/17/1977'));
        hhObj.firstName = 'ConTest1';
        hhObj.lastName =  'ConTest2';
        hhObj.fullName = 'familyAccFNname12';
        hhObj.memberId = '453543543';
        hhObj.policyId = '0070145';
        hhObj.relationship = 'Subscriber/Recipient';
        hhObj.CHNEligibile =false;
        hhObj.CHNQualified =false;
        hhList.add(hhObj);
        
        list<user> u = [select id from user where profile.name = 'System Administrator' and isactive = true limit 1];
        system.runAs(u[0]){
            
            Id recordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Family').getRecordTypeId();
            Account ac = new Account();
            ac.Member_ID__c = '453543543';
            ac.Policy_ID__c = '0070145';
            ac.Name =   'SampleTEstFLAcc1';
            ac.RecordTypeId = recordTypeId;
            ac.UHG_Restriction__c = 'No';
            ac.Onshore_Restriction__c = 'No';
            insert ac;
            
            Family_Overview__c fmo = new Family_Overview__c();
            fmo.account__c = ac.id;
            fmo.UHG_Restriction__c = 'Yes';
            fmo.Onshore_Restriction__c = 'Yes';
            insert fmo;
            
            
            Id personAccRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Individual').getRecordTypeId();
            Account pa =new account();
            pa.PersonBirthdate = date.valueOf(ACETUtility.formatDateFutureDate('6/17/1979'));
            pa.firstName = 'paLastSample1';
            pa.lastName = 'paFirstSample1';
            pa.RecordTypeId = personAccRecordTypeId;
            pa.CHN_Eligible__c = false;
            pa.CHN_Qualified__c = false;
            insert pa;
            
            account pa1 = [select id,personcontactid from account where id =: pa.id];
            AccountContactRelation acr = new AccountContactRelation();
            acr.ContactId = pa1.personcontactid;
            acr.Accountid = ac.id;
            acr.Relationship__c = 'Child/Other';
            insert acr;
            //Creation of workorder start
            WorkOrder wo= new WorkOrder();
            wo.First_Name__c='ConTest1';
            wo.Last_Name__c='ConTest2';
            //wo.Date_of_Birth__c= ACETUtility.parseDate('6/17/1977');
            wo.Policy_ID__c='0070145';
            wo.Member_ID__c='453543543';
            wo.Add_Member__c=true;
            wo.Status_Detail__c='Clinical Review';
            wo.Host_System_Date_and_Time__c=ACETUtility.parseDateTime(datest);
            insert wo;
            
            try{
                ACETHouseHoldWrapper.memberDetails meber1 = ACETSNISaveHouseholdData.getSaveHouseHoldData(hhList,'6/17/1979',wo.Id,'453543543','advFull1','eligible','0070145','0070145','assignTo','E&I','SNI','National Team','123456');
            }catch(exception e){}
            
        }
        
    }
    @isTest static void sniEligibleWithAccWithpAc1(){
        ACETServiceRelationshipMap__c rel = new ACETServiceRelationshipMap__c();
        rel.name = 'Subscriber/Recipient';
        rel.Service_Relationship__c = 'Subscriber/Recipient';
        insert rel;
        /*   ACETServiceRelationshipMap__c rel1 = new ACETServiceRelationshipMap__c();
rel1.name = 'Child/Other';
rel1.Service_Relationship__c = 'Child/Other';
insert rel1;
*/
        ACETHouseHoldWrapper wrplist = new ACETHouseHoldWrapper();
        ACETHouseHoldWrapper.HouseHold[] hhList = new ACETHouseHoldWrapper.HouseHold[]{};
            ACETHouseHoldWrapper.HouseHold hhObj = new ACETHouseHoldWrapper.HouseHold();
        //hhObj.dob = '6/17/1977' ; //date.valueOf(ACETUtility.formatDateFutureDate('6/17/1977'));
        hhObj.firstName = 'ConTest1';
        hhObj.lastName =  'ConTest2';
        hhObj.fullName = 'familyAccFNname12';
        hhObj.memberId = '453543543';
        hhObj.policyId = '0070145';
        hhObj.relationship = 'Subscriber/Recipient';
        hhObj.CHNEligibile =false;
        hhObj.CHNQualified =false;
        hhList.add(hhObj);
        ACETHouseHoldWrapper.HouseHold hhObj1 = new ACETHouseHoldWrapper.HouseHold();
        //hhObj1.dob = '6/17/1979' ; //date.valueOf(ACETUtility.formatDateFutureDate('6/17/1977'));
        hhObj1.firstName = 'ConTest1';
        hhObj1.lastName =  'ConTest2';
        //hhObj.fullName = 'familyAccFNname12';
        // hhObj.memberId = '453543543';
        // hhObj.policyId = '0070145';
        hhObj1.relationship = 'Child/Other';
        hhObj1.CHNEligibile =false;
        hhObj1.CHNQualified =false;
        hhList.add(hhObj1);
        
        list<user> u = [select id from user where profile.name = 'System Administrator' and isactive = true limit 1];
        system.runAs(u[0]){
            
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
            pa.CHN_Eligible__c = false;
            pa.CHN_Qualified__c = false;
            insert pa;
            
            account pa1 = [select id,personcontactid from account where id =: pa.id];
            AccountContactRelation acr = new AccountContactRelation();
            acr.ContactId = pa1.personcontactid;
            acr.Accountid = ac.id;
            acr.Relationship__c = 'Child/Other';
            insert acr;
            //Creation of workorder start
            WorkOrder wo= new WorkOrder();
            wo.First_Name__c='ConTest1';
            wo.Last_Name__c='ConTest2';
            //wo.Date_of_Birth__c= ACETUtility.parseDate('6/17/1977');
            wo.Policy_ID__c='0070145';
            wo.Member_ID__c='453543543';
            wo.Add_Member__c=true;
            wo.Status_Detail__c='Clinical Review';
            wo.Host_System_Date_and_Time__c=ACETUtility.parseDateTime(datest);
            insert wo;
            
            try{
                ACETHouseHoldWrapper.memberDetails meber1 = ACETSNISaveHouseholdData.getSaveHouseHoldData(hhList,'6/17/1979',wo.Id,'453543543','advFull1','eligible','0070145','0070145','assignTo','E&I','SNI','National Team','123456');
            }catch(exception e){}
            
        }
        
    }
    
        @isTest static void sniEligibleWithAccWithpAc2(){
        ACETServiceRelationshipMap__c rel = new ACETServiceRelationshipMap__c();
        rel.name = 'Subscriber/Recipient';
        rel.Service_Relationship__c = 'Subscriber/Recipient';
        insert rel;
        ACETServiceRelationshipMap__c rel1 = new ACETServiceRelationshipMap__c();
        rel1.name = 'Child/Other';
        rel1.Service_Relationship__c = 'Child/Other';
        insert rel1;

        ACETHouseHoldWrapper wrplist = new ACETHouseHoldWrapper();
        ACETHouseHoldWrapper.HouseHold[] hhList = new ACETHouseHoldWrapper.HouseHold[]{};
        ACETHouseHoldWrapper.HouseHold hhObj = new ACETHouseHoldWrapper.HouseHold();
        hhObj.dob = '1977-06-17' ; //date.valueOf(ACETUtility.formatDateFutureDate('6/17/1977'));
        hhObj.firstName = 'ConTest1';
        hhObj.lastName =  'ConTest2';
        hhObj.fullName = 'familyAccFNname12';
        hhObj.memberId = '453543543';
        hhObj.policyId = '0070145';
        hhObj.relationship = 'Subscriber/Recipient';
        hhObj.CHNEligibile =false;
        hhObj.CHNQualified =false;
        hhList.add(hhObj);
        ACETHouseHoldWrapper.HouseHold hhObj2 = new ACETHouseHoldWrapper.HouseHold();
        hhObj2.dob = '1999-06-17' ; //date.valueOf(ACETUtility.formatDateFutureDate('6/17/1977'));
        hhObj2.firstName = 'ConTest11';
        hhObj2.lastName =  'ConTest21';
        hhObj2.fullName = 'familyAccFNname121';
        hhObj2.memberId = '453543543';
        hhObj2.policyId = '0070145';
        hhObj2.relationship = 'Child/Other';
        hhObj2.CHNEligibile =false;
        hhObj2.CHNQualified =false;
        hhList.add(hhObj2);
        list<user> u = [select id from user where profile.name = 'System Administrator' and isactive = true limit 1];
        system.runAs(u[0]){
            
            Id recordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Family').getRecordTypeId();
            Account ac = new Account();
            ac.Member_ID__c = '453543543';
            ac.Policy_ID__c = '0070145';
            ac.Name =   'SampleTEstFLAcc1';
            ac.RecordTypeId = recordTypeId;
            ac.UHG_Restriction__c = 'No';
            ac.Onshore_Restriction__c = 'No';
            insert ac;
            
            Family_Overview__c fmo = new Family_Overview__c();
            fmo.account__c = ac.id;
            fmo.UHG_Restriction__c = 'Yes';
            fmo.Onshore_Restriction__c = 'Yes';
            insert fmo;
            
            
            Id personAccRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Individual').getRecordTypeId();
            Account pa =new account();
            pa.PersonBirthdate = date.valueOf(ACETUtility.formatDateFutureDate('6/17/1979'));
            pa.firstName = 'paLastSample1';
            pa.lastName = 'paFirstSample1';
            pa.RecordTypeId = personAccRecordTypeId;
            pa.CHN_Eligible__c = false;
            pa.CHN_Qualified__c = false;
            insert pa;
            
            account pa1 = [select id,personcontactid from account where id =: pa.id];
            AccountContactRelation acr = new AccountContactRelation();
            acr.ContactId = pa1.personcontactid;
            acr.Accountid = ac.id;
            acr.Relationship__c = 'Child/Other';
            insert acr;
            //Creation of workorder start
            WorkOrder wo= new WorkOrder();
            wo.First_Name__c='ConTest1';
            wo.Last_Name__c='ConTest2';
            //wo.Date_of_Birth__c= ACETUtility.parseDate('6/17/1977');
            wo.Policy_ID__c='0070145';
            wo.Member_ID__c='453543543';
            wo.Add_Member__c=true;
            wo.Status_Detail__c='Clinical Review';
            wo.Host_System_Date_and_Time__c=ACETUtility.parseDateTime(datest);
            insert wo;
            
            try{
                ACETHouseHoldWrapper.memberDetails meber1 = ACETSNISaveHouseholdData.getSaveHouseHoldData(hhList,'6/17/1979',wo.Id,'453543543','advFull1','eligible','0070145','0070145','assignTo','E&I','SNI','National Team','123456');
            }catch(exception e){}
            
        }
        
    }
    /*@isTest static void sniEligibleWithAccWithpAc1()
    {
        ACETServiceRelationshipMap__c rel = new ACETServiceRelationshipMap__c();
        rel.name = 'Subscriber/Recipient';
        rel.Service_Relationship__c = 'Subscriber/Recipient';
        insert rel;

        ACETHouseHoldWrapper wrplist = new ACETHouseHoldWrapper();
        ACETHouseHoldWrapper.HouseHold[] hhList = new ACETHouseHoldWrapper.HouseHold[]{};
            ACETHouseHoldWrapper.HouseHold hhObj = new ACETHouseHoldWrapper.HouseHold();
        //hhObj.dob = '6/17/1977' ; //date.valueOf(ACETUtility.formatDateFutureDate('6/17/1977'));
        hhObj.firstName = 'ConTest1';
        hhObj.lastName =  'ConTest2';
        hhObj.fullName = 'familyAccFNname12';
        hhObj.memberId = '453543543';
        hhObj.policyId = '0070145';
        hhObj.relationship = 'Subscriber/Recipient';
        hhObj.CHNEligibile =false;
        hhObj.CHNQualified =false;
        hhList.add(hhObj);
        ACETHouseHoldWrapper.HouseHold hhObj1 = new ACETHouseHoldWrapper.HouseHold();
        //hhObj1.dob = '6/17/1979' ; //date.valueOf(ACETUtility.formatDateFutureDate('6/17/1977'));
        hhObj1.firstName = 'ConTest12';
        hhObj1.lastName =  'ConTest22';
        //hhObj.fullName = 'familyAccFNname12';
        // hhObj.memberId = '453543543';
        // hhObj.policyId = '0070145';
        hhObj1.relationship = 'Child/Other';
        hhObj1.CHNEligibile =false;
        hhObj1.CHNQualified =false;
        
        hhList.add(hhObj1);
        ACETHouseHoldWrapper.HouseHold hhObj2 = new ACETHouseHoldWrapper.HouseHold();
        //hhObj2.dob = '6/17/1980' ; //date.valueOf(ACETUtility.formatDateFutureDate('6/17/1977'));
        hhObj2.firstName = 'ConTest13';
        hhObj2.lastName =  'ConTest23';
        hhObj2.CHNEligibile =false;
        hhObj2.CHNQualified =false;
        //hhObj.fullName = 'familyAccFNname12';
        // hhObj.memberId = '453543543';
        // hhObj.policyId = '0070145';
        hhObj2.relationship = 'Child/Other';
        
        hhList.add(hhObj2);
        
        list<user> u = [select id from user where profile.name = 'System Administrator' and isactive = true limit 1];
        system.runAs(u[0]){
            
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
            pa.firstName = 'ConTest13';
            pa.lastName = 'ConTest23';
            pa.RecordTypeId = personAccRecordTypeId;
            pa.CHN_Eligible__c = false;
            pa.CHN_Qualified__c = false;
            insert pa;
            
            account pa1 = [select id,personcontactid from account where id =: pa.id];
            AccountContactRelation acr = new AccountContactRelation();
            acr.ContactId = pa1.personcontactid;
            acr.Accountid = ac.id;
            acr.Relationship__c = 'Child/Other';
            insert acr;
            //Creation of workorder start
            WorkOrder wo= new WorkOrder();
            wo.First_Name__c='ConTest1';
            wo.Last_Name__c='ConTest2';
            wo.Date_of_Birth__c= ACETUtility.parseDate('6/17/1977');
            wo.Policy_ID__c='0070145';
            wo.Member_ID__c='453543543';
            wo.Add_Member__c=true;
            wo.Status_Detail__c='Clinical Review';
            wo.Host_System_Date_and_Time__c=ACETUtility.parseDateTime(datest);
            insert wo;
            
            ACETHouseHoldWrapper.memberDetails meber1 = ACETSNISaveHouseholdData.getSaveHouseHoldData(hhList,'6/17/1980',wo.Id,'453543543','advFull1','eligible','0070145','0070145','assignTo','E&I','SNI','National Team','123456');
            
        }
        
    }*/
    @isTest static void saveHouseHoldDateMethods()
    {
        WorkOrder wo= new WorkOrder();
        wo.First_Name__c='ConTest1';
        wo.Last_Name__c='ConTest2';
        wo.Date_of_Birth__c= ACETUtility.parseDate('6/17/1977');
        wo.Policy_ID__c='0070145';
        wo.Member_ID__c='453543543';
        wo.Add_Member__c=true;
        wo.Status_Detail__c='Clinical Review';
        wo.Host_System_Date_and_Time__c=ACETUtility.parseDateTime(datest);
        insert wo;
        
        Id recordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Family').getRecordTypeId();
        Account ac = new Account();
        ac.Member_ID__c = '453543543';
        ac.Policy_ID__c = '0070145';
        ac.Name =   'familyAccFNname12';
        ac.RecordTypeId = recordTypeId;
        insert ac;
        
        Id personAccRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Individual').getRecordTypeId();
        Account pa =new account();
        pa.PersonBirthdate = date.valueOf(ACETUtility.formatDateFutureDate('6/17/1979'));
        pa.firstName = 'paLastSample1'; 
        pa.lastName = 'paFirstSample1'; 
        pa.RecordTypeId = personAccRecordTypeId;
        pa.RecordTypeId = personAccRecordTypeId;
        pa.CHN_Eligible__c = false;
        pa.CHN_Qualified__c = false;
        insert pa;
        
        account pa2 = [select id,personcontactid from account where id =: pa.id];
        AccountContactRelation acr = new AccountContactRelation();
        acr.ContactId = pa2.personcontactid;            
        Map<string,AccountContactRelation> acrmap=new Map<string,AccountContactRelation>();  
        acrmap.put(pa2.personcontactid, acr);
        Map<string,string> relationmap=new Map<string,string>();
        relationmap.put(pa2.personcontactid, 'Subscriber/Recipient');
        ACETHouseHoldWrapper wrplist = new ACETHouseHoldWrapper();
        ACETHouseHoldWrapper.addressInfo address = new ACETHouseHoldWrapper.addressInfo();
        ACETHouseHoldWrapper.HouseHold[] hhList = new ACETHouseHoldWrapper.HouseHold[]{};
            ACETHouseHoldWrapper.HouseHold hhObj = new ACETHouseHoldWrapper.HouseHold();
        address.city = 'SCHERERVILLE';
        address.country = 'US';
        address.state='IN';
        address.street=addressst;
        address.zip ='46375';
        hhObj.dob = '6/17/1977' ; //date.valueOf(ACETUtility.formatDateFutureDate('6/17/1977'));
        hhObj.firstName = 'ConTest1';
        hhObj.lastName =  'ConTest2';
        hhObj.fullName = 'familyAccFNname12';
        hhObj.memberId = '453543543';
        hhObj.policyId = '0070145';
        hhObj.sourceCode = 'CO';
        hhObj.cosmosDivision = 'KEN';
        hhObj.isMainMember = true;
        hhObj.relationship = 'Subscriber/Recipient';
        hhObj.address =address;
        hhObj.CHNEligibile =false;
        hhObj.CHNQualified =false;
       	Date dobirth = ACETUtility.parseDate(hhObj.dob);
        hhObj.UniqueIdentifier = hhObj.firstName+'~'+hhObj.lastName+'~-~'+ACETUtility.format(dobirth);
        hhList.add(hhObj);
        
        Account familyAcc = new Account();
        
        list<string> detailToSearch = new List<String>();
        //Date dobirth = ACETUtility.parseDate(hhObj.dob); 
        detailToSearch.add(hhObj.firstName+'~'+hhObj.lastName+'~-~'+hhObj.dob);
        
        map<string,string> mapPersonAccnts = new map<string,string>();
        mapPersonAccnts.put(ac.id,ac.Id);
        Test.StartTest();
        //ACETSNISaveHouseholdData asni = new ACETSNISaveHouseholdData();
        boolean val = ACETSNISaveHouseholdData.isCommunity();
        string stVal = ACETSNISaveHouseholdData.SaveUpdateAcetMember( new Map<String,sObject>(),'123123123', '12312312','dasdsadasd',new Map<String,string>(),'assignTo',hhList,'123456',wo.Id);
        ACETSNISaveHouseholdData.careteAcrnMembInfo('test'+'@'+ac.Id, acrmap,relationmap,'0070145','123123123', false,wo.Id);
        
        ACETSNISaveHouseholdData.memberSearchACET(detailToSearch,'453543543','0070145','test'+'@'+ac.Id,relationmap,'assignTo',hhList,false,wo.Id);
        //ACETSNISaveHouseholdData.createNewMemACR(detailToSearch,'453543543','0070145',ac.Id,relationmap,'assignTo',hhList,false,wo.Id);
        //ACETSNISaveHouseholdData.createACRaddressmatch(mapPersonAccnts,'453543543','0070145',ac.Id,relationmap,'assignTo',hhList,false,wo.Id);
        
        ACETHouseHoldWrapper.memberDetails  met = ACETSNISaveHouseholdData.SaveSearchInACET(new Map<String,sObject>(),'123123123', '123123123','23123dsdas',new Map<String,string>(),'assignTo',hhList,'123456',wo.Id);
        Boolean onshoreRestriction = ACETSNISaveHouseholdData.checkOnshoreRestriction(hhList, '1234567');
        hhList[0].sourceCode = 'CS';
        onshoreRestriction = ACETSNISaveHouseholdData.checkOnshoreRestriction(hhList, '01234567');
        Test.StopTest();
    }
    @isTest static void matchaddress()
    {
        WorkOrder wo= new WorkOrder();
        wo.First_Name__c='ConTest1';
        wo.Last_Name__c='ConTest2';
        wo.Date_of_Birth__c= ACETUtility.parseDate('6/17/1977');
        wo.Policy_ID__c='0070145';
        wo.Member_ID__c='453543543';
        wo.Add_Member__c=true;
        wo.Status_Detail__c='Clinical Review';
        wo.Host_System_Date_and_Time__c=ACETUtility.parseDateTime(datest);
        insert wo;
        
        Id recordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Family').getRecordTypeId();
        Account ac = new Account();
        ac.Member_ID__c = '453543543';
        ac.Policy_ID__c = '0070145';
        ac.Name =   'familyAccFNname12';
        ac.RecordTypeId = recordTypeId;
        insert ac;
        
        Id personAccRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Individual').getRecordTypeId();
        Account pa =new account();
        pa.PersonBirthdate = date.valueOf(ACETUtility.formatDateFutureDate('6/17/1979'));
        pa.firstName = 'paLastSample11'; 
        pa.lastName = 'paFirstSample11'; 
        pa.RecordTypeId = personAccRecordTypeId;
        pa.PersonMailingCity = 'SCHERERVILLE';
        pa.PersonMailingCountry = 'US';
        pa.PersonMailingState ='IN';
        pa.PersonMailingStreet=addressst;
        pa.PersonMailingPostalCode ='46375';
        insert pa;
        
        account pa2 = [select id,personcontactid from account where id =: pa.id];
        AccountContactRelation acr = new AccountContactRelation();
        acr.ContactId = pa2.personcontactid;            
        Map<string,AccountContactRelation> acrmap=new Map<string,AccountContactRelation>();  
        acrmap.put(pa2.personcontactid, acr);
        Map<string,string> relationmap=new Map<string,string>();
        relationmap.put(pa2.personcontactid, 'Subscriber/Recipient');
        ACETHouseHoldWrapper wrplist = new ACETHouseHoldWrapper();
        ACETHouseHoldWrapper.addressInfo address = new ACETHouseHoldWrapper.addressInfo();
        ACETHouseHoldWrapper.HouseHold[] hhList = new ACETHouseHoldWrapper.HouseHold[]{};
            ACETHouseHoldWrapper.HouseHold hhObj = new ACETHouseHoldWrapper.HouseHold();
        address.city = 'SCHERERVILLE';
        address.country = 'US';
        address.state='IN';
        address.street='1018 WILLOWBROOK DRIVE';
        address.zip ='46375';
        hhObj.dob = '6/17/1979' ; //date.valueOf(ACETUtility.formatDateFutureDate('6/17/1977'));
        hhObj.firstName = 'paLastSample11';
        hhObj.lastName =  'paFirstSample11';
        hhObj.fullName = 'familyAccFNname12';
        hhObj.memberId = '453543543';
        hhObj.policyId = '0070146';
        hhObj.sourceCode = 'CO';
        hhObj.cosmosDivision = 'KEN';
        hhObj.isMainMember = true;
        hhObj.relationship = 'Subscriber/Recipient';
        hhObj.address =address;
        hhObj.CHNEligibile = false;
        hhObj.CHNQualified = false;
        hhObj.CHNReferralIdentifier = 'test';
        Date dobirth = ACETUtility.parseDate(hhObj.dob); 
        hhObj.UniqueIdentifier = hhObj.firstName+'~'+hhObj.lastName+'~-~'+hhObj.dob;
        hhList.add(hhObj);
        
        Account familyAcc = new Account();
        
        list<string> detailToSearch = new List<String>();
        //Date dobirth = ACETUtility.parseDate(hhObj.dob); 
        detailToSearch.add(hhObj.firstName+'~'+hhObj.lastName+'~-~'+hhObj.dob);
        system.debug(detailToSearch);
        map<string,string> mapPersonAccnts = new map<string,string>();
        mapPersonAccnts.put(ac.id,ac.Id);
        Test.StartTest();
        //ACETSNISaveHouseholdData asni = new ACETSNISaveHouseholdData();
        boolean val = ACETSNISaveHouseholdData.isCommunity();
        string stVal = ACETSNISaveHouseholdData.SaveUpdateAcetMember( new Map<String,sObject>(),'123123123', '12312312','dasdsadasd',new Map<String,string>(),'assignTo',hhList,'123456',wo.Id);
        ACETSNISaveHouseholdData.careteAcrnMembInfo('test'+'@'+ac.Id, acrmap,relationmap,'0070145','123123123', false,wo.Id);
        
        try{
            ACETSNISaveHouseholdData.memberSearchACET(detailToSearch,'453543543','0070146','test'+'@'+ac.Id,relationmap,'assignTo',hhList,false,wo.Id);
        }catch(Exception e){}
        //ACETSNISaveHouseholdData.createNewMemACR(detailToSearch,'453543543','0070145',ac.Id,relationmap,'assignTo',hhList,false,wo.Id);
        //ACETSNISaveHouseholdData.createACRaddressmatch(mapPersonAccnts,'453543543','0070145',ac.Id,relationmap,'assignTo',hhList,false,wo.Id);
        
        ACETHouseHoldWrapper.memberDetails  met = ACETSNISaveHouseholdData.SaveSearchInACET(new Map<String,sObject>(),'123123123', '123123123','23123dsdas',new Map<String,string>(),'assignTo',hhList,'123456',wo.Id);
        Boolean onshoreRestriction = ACETSNISaveHouseholdData.checkOnshoreRestriction(hhList, '1234567');
        hhList[0].sourceCode = 'CS';
        onshoreRestriction = ACETSNISaveHouseholdData.checkOnshoreRestriction(hhList, '01234567');
        Test.StopTest();
    }
    @isTest static void saveHouseHoldUpdateMembers()
    {
        test.starttest();
        WorkOrder wo= new WorkOrder();
        wo.First_Name__c='ConTest1';
        wo.Last_Name__c='ConTest2';
        wo.Date_of_Birth__c= ACETUtility.parseDate('6/17/1977');
        wo.Policy_ID__c='0070145';
        wo.Member_ID__c='453543543';
        wo.Add_Member__c=true;
        wo.Status_Detail__c='Clinical Review';
        wo.Host_System_Date_and_Time__c=ACETUtility.parseDateTime(datest);
        insert wo;
        
        Id recordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Family').getRecordTypeId();
        Account ac = new Account();
        ac.Member_ID__c = '453543543';
        ac.Policy_ID__c = '0070145';
        ac.Name =   'familyAccFNname12';
        ac.RecordTypeId = recordTypeId;
        insert ac;
        
        Id personAccRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Individual').getRecordTypeId();
        Account pa =new account();
        pa.PersonBirthdate = date.valueOf(ACETUtility.formatDateFutureDate('6/17/1979'));
        pa.firstName = 'paLastSample1'; 
        pa.lastName = 'paFirstSample1'; 
        pa.RecordTypeId = personAccRecordTypeId;
        insert pa;
        
        account pa2 = [select id,personcontactid from account where id =: pa.id];
        contact con = [select Id from contact where Id=:pa2.personcontactid];
        AccountContactRelation acr = new AccountContactRelation();
        acr.ContactId = pa2.personcontactid;  
        acr.Accountid = ac.id;
        acr.Relationship__c = 'Child/Other';
        insert acr;
        Map<string,AccountContactRelation> acrmap=new Map<string,AccountContactRelation>();  
        acrmap.put(acr.Id, acr);
        Map<string,string> relationmap=new Map<string,string>();
        relationmap.put(acr.Id, 'Subscriber/Recipient');
        Map<string,contact> conmap=new Map<string,contact>();
        conmap.put(pa.firstName+'~'+pa.lastName+'~-~'+ACETUtility.format(pa.PersonBirthdate),con);
        ACETSNISaveHouseholdData.updateMembers(conmap,acrmap,relationmap,'123123123','dewsvvffas','assignTo','123123123', false,wo.Id);
        test.stoptest();
    }
    
    @isTest static void WithioutAcc()
    {
        ACETServiceRelationshipMap__c rel = new ACETServiceRelationshipMap__c();
        rel.name = 'Subscriber/Recipient';
        rel.Service_Relationship__c = 'Subscriber/Recipient';
        insert rel;
        
        ACETHouseHoldWrapper wrplist = new ACETHouseHoldWrapper();
        ACETHouseHoldWrapper.HouseHold[] hhList = new ACETHouseHoldWrapper.HouseHold[]{};
        ACETHouseHoldWrapper.HouseHold hhObj = new ACETHouseHoldWrapper.HouseHold();
        hhObj.dob = '6/17/1977' ; //date.valueOf(ACETUtility.formatDateFutureDate('6/17/1977'));
        hhObj.firstName = 'ConTest1';
        hhObj.lastName =  'ConTest2';
        hhObj.fullName = 'familyAccFNname12';
        hhObj.memberId = '00Q453543543';
        hhObj.policyId = '0070145';
        hhObj.relationship = 'Subscriber/Recipient';
        hhObj.CHNEligibile = false;
        hhObj.CHNQualified = false;
        hhObj.CHNReferralIdentifier = 'test';
        hhList.add(hhObj);

            try{
                ACETHouseHoldWrapper.memberDetails meber1 = ACETSNISaveHouseholdData.getSaveHouseHoldData(hhList,'6/17/1977','','00Q453543543','advFull1','eligible','0070145','0070145','assignTo','E&I','SNI','National Team','123456');
            }catch(Exception e){
                
            }
    }
}