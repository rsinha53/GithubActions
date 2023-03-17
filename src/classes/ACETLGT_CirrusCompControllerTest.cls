@IsTest
public class ACETLGT_CirrusCompControllerTest {
    static testMethod void test(){
	ACETLGT_CirrusCompController obj = new ACETLGT_CirrusCompController();
        String orgName = ACETUtility.GetOrgName();
        ACETOrgNameToSwivelEndpointMap__c sem = new ACETOrgNameToSwivelEndpointMap__c();
        sem.Name = orgName+'_CIRRUSWrapURL';
        sem.Swivel_Endpoint__c = 'https://g.com?RelayState=anc&affiliationExternalID=123456';
        insert sem;
        ACETWrapEncryptionKey__c ACETWrapEncryptionKey = new ACETWrapEncryptionKey__c();
        ACETWrapEncryptionKey.Name = OrgName + '_CirrusEncryptionKey';
        ACETWrapEncryptionKey.Key__c = 'CAR 100000000000';
        ACETWrapEncryptionKey.Algorithm_Name__c = 'AES128';
        insert ACETWrapEncryptionKey;
        ACETLGT_CirrusCompController.CIRRUSURL='';
   	    obj.landingPageinCirrus='';
        obj.MemberId='';
        obj.subjectTyp='';
        ACETLGT_CirrusCompController.topicName='';
        ACETLGT_CirrusCompController.GenerateCIRRUS('', 'memberDetail', 'Group/Employer','Enroll Subscriber', '');
        ACETLGT_CirrusCompController.GenerateCIRRUS('', 'memberDetail', 'Group/Employer','', '');
    }
}