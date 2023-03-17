@isTest
public class ACETUtilityTest {

    @testSetup
    static void prepareData(){
    	ACETOrgInstanceURLToOrgNameMap__c obj = new ACETOrgInstanceURLToOrgNameMap__c(name='cs14',Org_Name__c='cs14');
    	insert obj;

    	ACETOrgNameToSwivelEndpointMap__c swive1= new ACETOrgNameToSwivelEndpointMap__c(name='dev_dev', Swivel_Endpoint__c='acet');
    	ACETOrgNameToSwivelEndpointMap__c swive2 = new ACETOrgNameToSwivelEndpointMap__c(name='d1_ICUEConsumerDashboard', Swivel_Endpoint__c='acet');
    	insert new list<ACETOrgNameToSwivelEndpointMap__c>{swive1,swive2};


    	ACETOrgInstanceURLToOrgNameMap__c org = new ACETOrgInstanceURLToOrgNameMap__c(name='dev_DynatraceJSURL', Org_Name__c='acet');
    	insert org;
    }



    static testMethod void testMethods(){
    	string recordtypeId = ACETUtility.getRecordTypeId('Case','ECM');
    	id recordtpeId = ACETUtility.getRecordTypeID('Case','ECM');
    	string orgName = ACETUtility.GetOrgName();
    	string userRoleName = ACETUtility.GetUserRoleName();
    	string userProfileName = ACETUtility.GetUserProfileName();
    	string swivelEndpointByOrgName = ACETUtility.GetSwivelEndpointByOrgName('dev','dev');
    	ACETUtility.GetDynatraceJSURL();

    	string dt = ACETUtility.formatDatewithslash('10/10/2017');
    	dt = ACETUtility.formatDateFromDashToSlash('10-10-2017');
    	dt = ACETUtility.formatDateYYYYMMDD('10-10-2017');

    	Application_Error_Log__c eLog = ACETUtility.CreateApplicationErrorLog('Origin', 'tring Application', 'String Endpoint', 'String StatusMessage', 10);
    	insert eLog;
    	Attachment at = ACETUtility.CreateAttachment(eLog.id,'','');

    	string consumeDashURL= ACETUtility.getConsumerDashURL('String policynum' , 'string memberId' , 'String firstName' , 'string lastName');

    	String geICUEURL = ACETUtility.geICUEURL();
    	dt = ACETUtility.formatMMDDYYYYwithSlashToYYYYMMDDwithDash('10/10/2017');



    }
    static testMethod void searchMemberTest() {
        Test.startTest();
        ACETUtility.formatDate('01-01-1990');
        ACETUtility.formatDate('');
        ACETUtility.formatDate('01-01');
        ACETUtility.formatDateRequest('01-01-1990');
        ACETUtility.formatDateRequest('');
        ACETUtility.formatDateRequest('01-01');
        ACETUtility.formatDateFutureDate('01-01-1990');
        ACETUtility.formatDateFutureDate('');
        ACETUtility.formatDateFutureDate('01-01');
        ACETUtility.getAgeFromBirthday('01-01-1990');
        ACETUtility.getAgeFromBirthday('1990-01-01');
        Test.stopTest();
    }

	static testMethod void offShoreTest() {
	Test.startTest();
	List <String> strinLst = new List<String>();
	Boolean boolRes;
        boolRes = ACETUtility.isOffShoreUser();
        strinLst = ACETUtility.getPolicyRestrictionLevel('MR','24478-008-E_33-1');

        Test.stopTest();
    }
       static testMethod void testutilityMethods(){
        Test.startTest();
             ACETServiceRelationshipMap__c sr = new ACETServiceRelationshipMap__c();
         sr.name = 'srname';
         sr.Service_Relationship__c ='relsr';
         list<string> newRelationValList = new list<string>();
                   ACETUtility.insertHouseholdRelationshipData(newRelationValList);

        Test.stopTest();
        
        
    }
     static testMethod void testutilityMethodtwo(){
        Test.startTest();
        
           Profile p = [SELECT Id FROM Profile WHERE Name=:'ACET Member']; 
    /*  User u = new User(Alias = 'standt', Email='standarduser@testorg.com', 
      EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
      LocaleSidKey='en_US', ProfileId = p.Id, 
      TimeZoneSidKey='America/Los_Angeles', UserName= string.valueof(p.Id).trim()+'@testorg.com',Agent_Type__c =SObjectType.user.Fields.Agent_Type__c.PicklistValues[0].getValue());*/
      ACETServiceRelationshipMap__c sr = new ACETServiceRelationshipMap__c();
         sr.name = 'srname';
         sr.Service_Relationship__c ='relsr';
         list<string> newRelationValList = new list<string>();
         newRelationValList.add('relsr');
           SObjectType stype = account.getSObjectType();
        ACETUtility.getRecordTypeId(stype,'Family');
          ACETUtility.julianFormatDate();
         ACETUtility.getErrorMessage('GN200');
         ACETUtility.escapeHtml('test');
         ACETUtility.checkUHGPolicy('pilid');
         ACETUtility.checkUserUhgAccess();
         ACETUtility.getHouseholdRelationshipMap();
         ACETUtility.insertHouseholdRelationshipData('relsr');
         ACETUtility.insertHouseholdRelationshipData(newRelationValList);
         ACETUtility.fetchUser();
         ACETUtility.policyRefactor('^0+123');
         ACETUtility.IDRefactorCheck('stertest','12serf');
         ACETUtility.compareData('test','test',2);
         ACETUtility.getStaticResponseCheck('memberId','memberDOB','test','memberLN','memberGrpN','MemberIDNameGroupNumberDateOfBirth','transactionId','orgName');
     ACETUtility.CreateApplicationExcepLog ('Origin','Application', 'errorcause','StatusMessage','errorline','errormessage', 'errortype');
	    ACETUtility.format(System.now());
        ACETUtility.format(Date.today());
		ACETUtility.formatStrict(System.now());
        ACETUtility.formatStrict(Date.today());
        Test.stopTest();
        
        
    }
}