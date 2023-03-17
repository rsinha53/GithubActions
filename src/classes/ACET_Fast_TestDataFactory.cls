/*****************************************************************************************************
ACET_Fast_TestDataFactory
Author: Shaik Mohammad Yaseen
Date: 10/30/2020
Description: This is a test class where we will have reusable methods for test classes. 
Initial: Shaik Mohammad Yaseen
*****************************************************************************************************/
@isTest(SeeAllData=false)
public class ACET_Fast_TestDataFactory {
    public static final String USER_NAME = 'standarduser@ecm.com';
    
    public static profile getSysAdminPrf(){
        profile p = new profile();
        p = [SELECT Id FROM Profile WHERE name = 'System Administrator'];
        return p;
    }
    public static profile getstdUserPrf(){
        profile p = new profile();
        p = [SELECT Id FROM Profile WHERE name = 'Standard User'];
        return p;
    }
    public static User getUserRecord(id prfId){
        user u = new User(Alias = 'standt', Email= USER_NAME,
            			  EmailEncodingKey='UTF-8', LastName='Testing', 
                          LanguageLocaleKey='en_US', LocaleSidKey='en_US', 
                          ProfileId = prfId, timeZoneSidKey='America/Los_Angeles', 
                          UserName= USER_NAME);
        return u;
    }

    public static User getUserRecordWithRole(id prfId, id roleId){
        user u = new User(Alias = 'standt', Email= USER_NAME,
            			  EmailEncodingKey='UTF-8', LastName='Testing', 
                          LanguageLocaleKey='en_US', LocaleSidKey='en_US', 
                          ProfileId = prfId, timeZoneSidKey='America/Los_Angeles', 
                          UserName= USER_NAME, UserRoleId= roleId);
        return u;
    }

    public static UserRole getRole(string roleName){
        UserRole r;
        List<UserRole> rList = new List<UserRole>();
        rList=[SELECT Id FROM UserRole WHERE name = :roleName];
        if(rList.size()>0){
            r= rList[0];
        }
        return r;
    }

    public static profile getProfile(string profileName){
        profile p = new profile();
        p = [SELECT Id FROM Profile WHERE name = :profileName];
        return p;
    }

    public static PIR_Resolution_Partner__c getPIRRPRec(id caseId){
        Provider_Matrix__c pmatrix =new Provider_Matrix__c(name='test',CrossWalk_Case_RPI__c='test');
        insert pmatrix;
        
        PIR_Resolution_Partner__c rpRec = new PIR_Resolution_Partner__c(
            Case__c = caseId,
            Provider_Matrix_Reactive__c = pmatrix.id,
            Escalation_Notes__c = 'test',
            SLA_Routed_Date__c = Date.today()
        );        
        return rpRec;
    }

   public static List<Account> getAccountRecords(){
        ID accRecordTypeId = ACET_Fast_ProviderContactCtrl.getRecordTypeIdbyDevName('Account','PersonAccount');
        List<Account> accRecs = new List<Account>();
        for(integer i=0; i<100; i++){
            Account acc = new Account();
            acc.LastName = 'Test '+i;
            acc.recordTypeId = accRecordTypeId;
            acc.tax_id__c =  String.valueOf(Math.round((Math.random() * (900000000) + 100000000)));
            acc.EID__c = acc.tax_id__c +  String.valueOf(Math.round((Math.random() * (9000) + 1000)));
            accRecs.add(acc);
        }
        return accRecs;
    }
    public static task getTaskRecord(string recordTypeName, id relatedRecId, string subjectStr, date activityDate, string statusStr, string priority){
       	id recTpeId = ACET_Fast_TestDataFactory.getRecordTypeIdbyDevName('Task',recordTypeName); 
        task t = new task(whatId=relatedRecId,recordtypeId=recTpeId,
                         subject=subjectStr, ActivityDate= activityDate,
                         Status=statusStr, Priority=priority);
        return t;
    }

    public static case getCaseRecord(string recordTypeName, string statusStr){
        id recTpeId = ACET_Fast_TestDataFactory.getRecordTypeIdbyDevName('case',recordTypeName);
        case caseRec = new case(Status=statusStr,Subject='Test Subject',
                               Description='Test Description',PC_Provider_TIN__c='061330992',
                               recordtypeId=recTpeId, Origin='PDAR',
                               FAST_PIP_Markets__c='Alabama',PC_Internal_Contact_Name__c='test Contact Name',
                               PC_Internal_Contact_Phone__c='1111111111',PC_Internal_Contact_Email__c='test@123.com',
                              PC_External_Contact_Name__c='test Ext', PC_External_Contact_Phone__c='1231231230',PC_External_Contact_Email__c='test@123.com',
                                Submitting_Department__c='Appeals',Original_Received_Date__c= system.today()+1);
        return caseRec;
    }
    public static PIR_Detail__c getPIRRec(id caseId){
        PIR_Detail__c pir = new PIR_Detail__c(Formal_Complaint_Filed__c='Yes',
                                              Remark_Explanation_Code__c='test',Case__c=caseId,
                                              Status__c='Open',
                                              Issue_Category__c='First Time Visit',Issue_Subcategory__c='Additional Info Needed',
                                              Interest_Bearing__c='No',Specialty_Team__c='Region V',
                                              Region_V_Work_Type__c='Accounts Receivable',LA_C_S_Reason_for_Provider_Issue__c='Reimbursement Rates',
                                              Line_of_Business__c='Community and State',
                                              Platform__c='CSP Facets',Claim_Type__c='NDC',
                                              Submitter_to_Contact_Provider_at_Closure__c='Yes',Reason_for_Submission_Delay__c='Submitter PTO/Weekend/Holiday',
                                              Provider_Contact__c='Test',Provider_Contact_Preference__c='Both',
                                              Par_Provider__c='Yes',Claims_Overturned__c='Overturned',
                                              Will_this_be_closed_in_Practice_Mgmt__c='Yes',Provider_Was_contacted__c='Submitter to Contact Provider',
                                              Exact_Count_Unknown_Multiple_Claims__c=true, No_Reference_Facilitated_Referral__c=true);
        return pir;
    }
    public static Id getRecordTypeIdbyDevName(String objectName, String strRecordTypeDevName)
    {
        return  Schema.getGlobalDescribe().get(objectName).getDescribe().getRecordTypeInfosByDeveloperName().get(strRecordTypeDevName).getRecordTypeId();
    }
}