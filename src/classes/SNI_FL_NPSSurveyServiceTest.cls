@isTest
public class SNI_FL_NPSSurveyServiceTest {

    static testMethod void getNPSdata() {
            NPS_Data__c npsdata = new NPS_Data__c(
                              Member_Name__c= 'memberName',
                              Agent_Name__c= 'agentName'
                           );
            insert npsdata;
   			RestRequest req = new RestRequest();
   			req.requestUri = System.URL.getSalesforceBaseUrl().toExternalForm() +
                     '/services/apexrest/SNI/NPSSurvey/'+npsdata.id;
                     
   			req.httpMethod = 'POST';
  			req.addHeader('Content-Type', 'application/json');
 		    RestContext.request = req;
    		//update method:
   		    SNI_FL_NPSSurveyService.getAgentMemberName();
           
            //System.assert(updatedRecord[0].Contact.Account.Text_Message_SMS_Notification__c== false);
    
    }
    static testMethod void getNPSdataerror() {
            NPS_Data__c npsdata = new NPS_Data__c(
                              Member_Name__c= 'memberName',
                              Agent_Name__c= 'agentName'
                           );
            insert npsdata;
   			RestRequest req = new RestRequest();
   			req.requestUri = System.URL.getSalesforceBaseUrl().toExternalForm() +
                     '/services/apexrest/SNI/NPSSurvey/';
                     
   			req.httpMethod = 'POST';
  			req.addHeader('Content-Type', 'application/json');
 		    RestContext.request = req;
    		//update method:
   		    SNI_FL_NPSSurveyService.getAgentMemberName();
           
            //System.assert(updatedRecord[0].Contact.Account.Text_Message_SMS_Notification__c== false);
    
    }
}