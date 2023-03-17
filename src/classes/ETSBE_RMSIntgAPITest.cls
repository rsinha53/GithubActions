@isTest
public class ETSBE_RMSIntgAPITest {
	static testmethod void callRMSAPI() {        
        Id rectypId = Schema.sObjectType.Case.getRecordTypeInfosByName().get('BEO').getRecordTypeId();
        Interaction__c intract = new Interaction__c();
		insert intract;
        Case cas =new Case();
        cas.status= 'Open';
        cas.RecordTypeId = rectypId;
        cas.Interaction__c = intract.Id;
        insert cas;
        
        
        Case caseinfo = new Case();
        caseinfo =[select Id,CaseNumber,RecordType.Name from case where Id=:cas.Id];
        
        caseComment caseComm = new caseComment();
        caseComm.CommentBody = 'Testing';
        caseComm.ParentId = caseinfo.Id;
        insert caseComm;
        
        Test.startTest();
        system.debug('------casenumber----'+caseinfo.CaseNumber);
        system.debug('------casenumber----'+caseinfo.RecordType.Name);
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        //req.requestURI = '/services/apexrest/ETSBECaseInfo'; 
        req.requestURI = '/services/apexrest/ETSBECaseInfo/'+caseinfo.CaseNumber;
        req.params.put('caseno', caseinfo.CaseNumber);
        req.httpMethod = 'GET';
        req.addHeader('Content-Type', 'application/json'); 
        RestContext.request = req;
        RestContext.response = res;
        String s = ETSBE_RMSIntgAPI.fetchCase();      
       Test.stopTest();   

    }
}