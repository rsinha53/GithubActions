/*
ACET_Fast_ProviderContactCtrl_Test
Testing Class Name:  ACET_Fast_ProviderContactCtrl
Author: Manohar Reddy
Date: 11/09/2020
Description: This is test class and used to get test coverage for ACET_Fast_ProviderContactCtrl. 
Initial: Manohar Reddy 
*/

@isTest
public class ACET_Fast_ProviderContactCtrl_Test {
    public static final String PERSON_ACC = 'PersonAccount';
    public static final String FNAME = 'Test first';
    public static final String LNAME = 'Test last';
    public static final String FOREIGN_PROVIDER = 'FOREIGN PROVIDER';
    public static final String REACTIVE_RESOLUTION = 'Reactive Resolution';
    
    public static testMethod void accountRec(){
        Profile sysAdminPrf = ACET_Fast_TestDataFactory.getSysAdminPrf();
        user sysAdminUser = ACET_Fast_TestDataFactory.getUserRecord(sysAdminPrf.id);
        insert sysAdminUser;
        System.runAs(sysAdminUser){
			List<Account> accRecs = ACET_Fast_TestDataFactory.getAccountRecords();
           	Database.insert(accRecs,false);
          	ACET_Fast_ProviderContactCtrl.providerAccountWrapper wrapcls = new ACET_Fast_ProviderContactCtrl.providerAccountWrapper();
            wrapcls.firstName = FNAME;
            wrapcls.lastName = LNAME;
            wrapcls.corpMPIN = '111111111';
            wrapcls.corporateOwnerLastName = 'Marcus';
            wrapcls.isNoProviderToSearch = 'true';
            wrapcls.noSearchtaxIdOrNPI = '999999999';
            wrapcls.zip = '55555';
            wrapcls.state = 'AZ';
            wrapcls.taxidornpi = '999999999';
            wrapcls.isProviderNotFound = 'true';
            ACET_Fast_ProviderContactCtrl.wrapperClass wrap = new ACET_Fast_ProviderContactCtrl.wrapperClass();
            wrap.caseRecordType = REACTIVE_RESOLUTION;
            wrap.noAccountTaxId = '999999999';
            wrap.accountInteractionWrap = wrapcls;
            wrap.noAccountInteractionWrap = wrapcls;
            String str = JSON.serialize(wrap);
            ACET_Fast_ProviderContactCtrl.saveProviderContact(str);
        }        
    }
    
    public static testMethod void thirdPartyRec(){
        Profile sysAdminPrf = ACET_Fast_TestDataFactory.getSysAdminPrf();
        user sysAdminUser = ACET_Fast_TestDataFactory.getUserRecord(sysAdminPrf.id);
        insert sysAdminUser;
        System.runAs(sysAdminUser){
            Account acc = new Account();
            acc.RecordTypeId = ACET_Fast_ProviderContactCtrl.getRecordTypeIdbyDevName('Account',PERSON_ACC);
            acc.LastName = 'Test';
            insert acc;
          ACET_Fast_ProviderContactCtrl.providerAccountWrapper wrapcls = new ACET_Fast_ProviderContactCtrl.providerAccountWrapper();
            wrapcls.firstName = FNAME;
            wrapcls.lastName = LNAME;
            wrapcls.corpMPIN = '111111111';
            wrapcls.corporateOwnerLastName = 'Marcus';
            wrapcls.isNoProviderToSearch = 'true';
            wrapcls.noSearchtaxIdOrNPI = '999999999';
            wrapcls.zip = '55555';
            wrapcls.state = 'AZ';
            wrapcls.taxidornpi = '';
            wrapcls.isProviderNotFound = 'true';            
            ACET_Fast_ProviderContactCtrl.wrapperClass wrap = new ACET_Fast_ProviderContactCtrl.wrapperClass();
            wrap.caseRecordType = REACTIVE_RESOLUTION;
            wrap.noAccountTaxId = '999999999';
            wrap.accountInteractionWrap = wrapcls;
            wrap.noAccountInteractionWrap = wrapcls;
            String str = JSON.serialize(wrap);
            ACET_Fast_ProviderContactCtrl.saveProviderContact(str);            
        }
    }
    
    public static testMethod void accountRecWhenNoCorpName(){
        Profile sysAdminPrf = ACET_Fast_TestDataFactory.getSysAdminPrf();
        user sysAdminUser = ACET_Fast_TestDataFactory.getUserRecord(sysAdminPrf.id);
        insert sysAdminUser;
        System.runAs(sysAdminUser){
            Account acc = new Account();
            acc.RecordTypeId = ACET_Fast_ProviderContactCtrl.getRecordTypeIdbyDevName('Account',PERSON_ACC);
            acc.LastName = 'Test';
            insert acc;
         ACET_Fast_ProviderContactCtrl.providerAccountWrapper wrapcls = new ACET_Fast_ProviderContactCtrl.providerAccountWrapper();
            wrapcls.firstName = FNAME;
            wrapcls.lastName = LNAME;
            wrapcls.corpMPIN = '111111111';
            wrapcls.corporateOwnerLastName = '';
            wrapcls.isNoProviderToSearch = 'true';
            wrapcls.noSearchtaxIdOrNPI = '999999999';
            wrapcls.zip = '55555';
            wrapcls.state = 'AZ';
            wrapcls.taxidornpi = '999999999';
            wrapcls.isProviderNotFound = 'true';            
            ACET_Fast_ProviderContactCtrl.wrapperClass wrap = new ACET_Fast_ProviderContactCtrl.wrapperClass();
            wrap.caseRecordType = 'Proactive Action';
            wrap.noAccountTaxId = '';
            wrap.accountInteractionWrap = wrapcls;
            wrap.noAccountInteractionWrap = wrapcls;
            String str = JSON.serialize(wrap);
            ACET_Fast_ProviderContactCtrl.saveProviderContact(str);            
        }
    }
    public static testMethod void updateAccountRecWithProviderContact(){
        Profile sysAdminPrf = ACET_Fast_TestDataFactory.getSysAdminPrf();
        user sysAdminUser = ACET_Fast_TestDataFactory.getUserRecord(sysAdminPrf.id);
        insert sysAdminUser;
        System.runAs(sysAdminUser){
            Account acc = new Account();
            acc.RecordTypeId = ACET_Fast_ProviderContactCtrl.getRecordTypeIdbyDevName('Account',PERSON_ACC);
            acc.LastName = FOREIGN_PROVIDER;
            acc.EID__c = '001490295111111111';
            acc.Tax_Id__c = '111111111';
            acc.Provider_Contact__c = '';
            acc.Provider_Contact_Email__c= '';
            acc.Provider_Contact_Phone__c= '';
            acc.Provider_Contact_Preference__c= '';
            acc.Par_Provider__c= '';
            insert acc;
         ACET_Fast_ProviderContactCtrl.providerAccountWrapper wrapcls = new ACET_Fast_ProviderContactCtrl.providerAccountWrapper();
           wrapcls.lastName = FOREIGN_PROVIDER;
            wrapcls.corpMPIN = '001490295';
            wrapcls.corporateOwnerLastName = FOREIGN_PROVIDER;
            wrapcls.isNoProviderToSearch = 'true';
            wrapcls.noSearchtaxIdOrNPI = '111111111';
            wrapcls.zip = '55555';
            wrapcls.state = 'AZ';
            wrapcls.taxidornpi = '111111111';
            wrapcls.isProviderNotFound = 'true';
            ACET_Fast_ProviderContactCtrl.wrapperClass wrap = new ACET_Fast_ProviderContactCtrl.wrapperClass();
            wrap.caseRecordType = REACTIVE_RESOLUTION;
            wrap.noAccountTaxId = '111111111';
            wrap.accountRec.Provider_Contact_Email__c = 'test@test.com';
            wrap.accountRec.Provider_Contact_Phone__c = '1234567890';
            wrap.accountRec.Provider_Contact_Preference__c = 'Email';
            wrap.accountRec.Provider_Contact__c = 'Test Name';
            wrap.accountRec.Par_Provider__c = 'Yes';
            wrap.accountInteractionWrap = wrapcls;
            wrap.noAccountInteractionWrap = wrapcls;
            String str = JSON.serialize(wrap);
            ACET_Fast_ProviderContactCtrl.saveProviderContact(str);
        }        
    }
}