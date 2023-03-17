@isTest
global class ACETLGT_UtilityTest {
    static testMethod void findAuthorizations() {
        Test.startTest();
        Case c;
        Id coRecordTypeID = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Case Overview').getRecordTypeId();
        //ACETLGT_Utility.getRecordTypeId(c,'Case Overview');
        ACETLGT_Utility.getRecordTypeID('Case','Case Overview');
        ACETLGT_Utility.GetOrgName();
        ACETLGT_Utility.GetUserRoleName();
        ACETLGT_Utility.GetUserProfileName();
        ISL_Webservice_Config__c newobj1=new ISL_Webservice_Config__c();
        newobj1.Name='dev_DynatraceJSURL';
        insert newobj1;
        ACETLGT_Utility.GetDynatraceJSURL();
        newobj1.Name='dev_DynatraceReportURL';
        update newobj1;
        ACETLGT_Utility.GetDynatraceJSURL();
        newobj1.Name='dev_DynatraceConfig';
        update newobj1;
        ACETLGT_Utility.GetDynatraceJSURL();
        ACETOrgNameToSwivelEndpointMap__c newobj2=new ACETOrgNameToSwivelEndpointMap__c();
        newobj2.Swivel_Endpoint__c='https://www.google.com';
        newobj2.Name='d1_ICUEConsumerDashboard';
        insert newobj2;
        ACETLGT_Utility.geICUEURL();
        ACETLGT_Utility.getConsumerDashURL('policy','member','firstname','lastname');
        ACETLGT_Utility.formatDatewithslash('2022/07/28');
        ACETLGT_Utility.formatDateYYYYMMDD('2022/07/28');
        ACETLGT_Utility.formatDateFromDashToSlash('2022/07/28');
        ACETLGT_Utility.formatMMDDYYYYwithSlashToYYYYMMDDwithDash('2022/07/28');
        ACETLGT_Utility.getAgentTypeById(userinfo.getUserId());
        ACETLGT_Utility.escapeHtml('test');
        ACETLGT_Utility.CreateApplicationErrorLog('Origin','Application','https://www.google.com','Success',200);
        Application_Error_Log__c errorlog=ACETLGT_Utility.CreateApplicationExcepLog('Origin','Application','Null Exception','Error','12','Error','Null exception');
        Id errorlogId=errorlog.Id;
        ACETLGT_Utility.CreateAttachment(errorlogId,'document','Body ');
        Map<String, ACETOrgInstanceURLToOrgNameMap__c> OrgInstance2OrgNameMap=new Map<String, ACETOrgInstanceURLToOrgNameMap__c>();
        ACETOrgInstanceURLToOrgNameMap__c newobj=new ACETOrgInstanceURLToOrgNameMap__c();
        newobj.name='UAT_test';
        newobj.Org_Name__c='Tets';
        insert newobj;
        OrgInstance2OrgNameMap.put('test',newobj);
        ACETLGT_Utility.GetOrgName(OrgInstance2OrgNameMap);
        ACETLGT_Utility.GetSwivelEndpointByOrgName('UAT','test');
        ACETLGT_Utility.GetSwivelEndpointByOrgName('UAT','test');
        
        
        Test.stopTest();
    }
}