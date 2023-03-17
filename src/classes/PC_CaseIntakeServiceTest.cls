@isTest
private class PC_CaseIntakeServiceTest {

    static testMethod void testCPMOpertaionPositive1() {
      String jsonBody = '{"Data":[{"Claim_ICN":"1003;1002;1001","Id":"a0eK0000004472VIAQ","Case__r.UHC_Provider_Contact__r.Phone":"(833) 456-9991","Case__r.UHC_Provider_Contact__r.Full_Name__c":"Suman Kundu","Case__r.UHC_Submitter_Contacts_Provider_at_Close__c":"false","Case__r.UHC_R_Code__c":null,"Case__r.UHC_Submitter_Received_Date__c":"2018-10-03 00:00:00","Case__r.CaseNumber":"00672437","Case__r.Submitter_Contact__r.Full_Name__c":"Bhanu Jain","Case__r.UHC_System_Reference_Update_ID__c":null,"Case__r.UHC_What_will_it_take_to_close_in_Prac_M__c":"NA","Resolution_Partner__r.Name":"CPM Level 1","Case__r.UHC_Date_of_Service_Start__c":"2018-10-30 00:00:00","Case__r.UHC_Is_this_a_State_Directed_Correction__c":"Yes","Case__r.UHC_Platform__c":"COSMOS","Case__r.Account.Organization_Type__c":"ACO","Case__r.Root_Cause__c":null,"Case__r.Submitter_Contact__r.Email":"bhanu.p.jain@email.com","Case__r.Markets__c":"Alabama","Case__r.UHC_Related_to_a_Provider_System_Update__c":"false","Case__r.Subject":"SUBJECT","Case__r.Account_TIN__c":"009002322","Case__r.UHC_Is_this_in_relation_to_a_UHC_error__c":null,"Case__r.UHC_Date_of_Service_End__c":"2018-11-02 00:00:00","Case__r.UHC_Line_of_Business__c":"Employer and Individual","Case__r.Description":"Text","Case__r.Account.Name":"Nick ACET Provider","Case__c":"500K000000GR2ZSIA1","Case__r.Submitter_Contact__r.Phone":"(988) 123-8802","Case__r.UHC_Provider_Contact__r.Email":"suman.k@pwc.com"}],"RequestHeader":{"Operation":"PUSH","Type":"CPM","SourceSystem":"IMPACT"}}';  
      RestRequest req = new RestRequest(); 
      RestResponse res = new RestResponse();
           
      req.requestURI = '/IntakeProcess';  //Request URL
      req.httpMethod = 'POST';//HTTP Request Type
      req.requestBody = Blob.valueof(jsonBody);
      RestContext.request = req;
      RestContext.response= res; 
      
      PC_CaseIntakeService.doPost();
    } 
    static testMethod void testCPMOpertaionPositive2() {
      String jsonBody = '{"Data":[{"Claim_ICN":"1003;1002;1001","Id":"a0eK0000004472VIAQ","Case__r.UHC_Provider_Contact__r.Phone":"(833) 456-9991","Case__r.UHC_Provider_Contact__r.Full_Name__c":"Suman Kundu","Case__r.UHC_Submitter_Contacts_Provider_at_Close__c":"false","Case__r.UHC_R_Code__c":null,"Case__r.UHC_Submitter_Received_Date__c":"2018-10-03 00:00:00","Case__r.CaseNumber":"00672437","Case__r.Submitter_Contact__r.Full_Name__c":"Bhanu Jain","Case__r.UHC_System_Reference_Update_ID__c":null,"Case__r.UHC_What_will_it_take_to_close_in_Prac_M__c":"NA","Resolution_Partner__r.Name":"CPM Level 2","Case__r.UHC_Date_of_Service_Start__c":"2018-10-30 00:00:00","Case__r.UHC_Is_this_a_State_Directed_Correction__c":null,"Case__r.UHC_Platform__c":"PULSE","Case__r.Account.Organization_Type__c":"ACO","Case__r.Root_Cause__c":null,"Case__r.Submitter_Contact__r.Email":"bhanu.p.jain@email.com","Case__r.Markets__c":"Alabama;Alaska","Case__r.UHC_Related_to_a_Provider_System_Update__c":"false","Case__r.Subject":"SUBJECT","Case__r.Account_TIN__c":"009002322","Case__r.UHC_Is_this_in_relation_to_a_UHC_error__c":null,"Case__r.UHC_Date_of_Service_End__c":"2018-11-02 00:00:00","Case__r.UHC_Line_of_Business__c":"Medicare and Retirement","Case__r.Description":"Text","Case__r.Account.Name":"Nick ACET Provider","Case__c":"500K000000GR2ZSIA1","Case__r.Submitter_Contact__r.Phone":"(988) 123-8802","Case__r.UHC_Provider_Contact__r.Email":"suman.k@pwc.com"}],"RequestHeader":{"Operation":"PUSH","Type":"CPM","SourceSystem":"IMPACT"}}';  
      RestRequest req = new RestRequest(); 
      RestResponse res = new RestResponse();
            
      req.requestURI = '/IntakeProcess';  //Request URL
      req.httpMethod = 'POST';//HTTP Request Type
      req.requestBody = Blob.valueof(jsonBody);
      RestContext.request = req;
      RestContext.response= res; 
      
      PC_CaseIntakeService.doPost();
    }
    static testMethod void testCPMOpertaionPositive3() {
      String jsonBody = '{"Data":[{"Claim_ICN":"1003;1002;1001","Id":"a0eK0000004472VIAQ","Case__r.UHC_Provider_Contact__r.Phone":"(833) 456-9991","Case__r.UHC_Provider_Contact__r.Full_Name__c":"Suman Kundu","Case__r.UHC_Submitter_Contacts_Provider_at_Close__c":"false","Case__r.UHC_R_Code__c":null,"Case__r.UHC_Submitter_Received_Date__c":"2018-10-03 00:00:00","Case__r.CaseNumber":"00672437","Case__r.Submitter_Contact__r.Full_Name__c":"Bhanu Jain","Case__r.UHC_System_Reference_Update_ID__c":null,"Case__r.UHC_What_will_it_take_to_close_in_Prac_M__c":"NA","Resolution_Partner__r.Name":"CPM-Adjustment Ready","Case__r.UHC_Date_of_Service_Start__c":"2018-10-30 00:00:00","Case__r.UHC_Is_this_a_State_Directed_Correction__c":null,"Case__r.UHC_Platform__c":"CIRRUS","Case__r.Account.Organization_Type__c":"ACO","Case__r.Root_Cause__c":"Provider Error","Case__r.Submitter_Contact__r.Email":"bhanu.p.jain@email.com","Case__r.Markets__c":"Alabama","Case__r.UHC_Related_to_a_Provider_System_Update__c":"false","Case__r.Subject":"SUBJECT","Case__r.Account_TIN__c":"009002322","Case__r.UHC_Is_this_in_relation_to_a_UHC_error__c":"Yes","Case__r.UHC_Date_of_Service_End__c":"2018-11-02 00:00:00","Case__r.UHC_Line_of_Business__c":"Community and State","Case__r.Description":"Text","Case__r.Account.Name":"Nick ACET Provider","Case__c":"500K000000GR2ZSIA1","Case__r.Submitter_Contact__r.Phone":"(988) 123-8802","Case__r.UHC_Provider_Contact__r.Email":"suman.k@pwc.com"}],"RequestHeader":{"Operation":"PUSH","Type":"CPM","SourceSystem":"IMPACT"}}';  
      RestRequest req = new RestRequest(); 
      RestResponse res = new RestResponse();
            
      req.requestURI = '/IntakeProcess';  //Request URL
      req.httpMethod = 'POST';//HTTP Request Type
      req.requestBody = Blob.valueof(jsonBody);
      RestContext.request = req;
      RestContext.response= res; 
      
      PC_CaseIntakeService.doPost();
    }
    static testMethod void testCPMOpertaionPositive4() {
      String jsonBody = '{"Data":[{"Claim_ICN":"1003;1002;1001","Id":"a0eK0000004472VIAQ","Case__r.UHC_Provider_Contact__r.Phone":"(833) 456-9991","Case__r.UHC_Provider_Contact__r.Full_Name__c":"Suman Kundu","Case__r.UHC_Submitter_Contacts_Provider_at_Close__c":"false","Case__r.UHC_R_Code__c":null,"Case__r.UHC_Submitter_Received_Date__c":"2018-10-03 00:00:00","Case__r.CaseNumber":"00672437","Case__r.Submitter_Contact__r.Full_Name__c":"Bhanu Jain","Case__r.UHC_System_Reference_Update_ID__c":null,"Case__r.UHC_What_will_it_take_to_close_in_Prac_M__c":"NA","Resolution_Partner__r.Name":"CPM-Adjustment Ready","Case__r.UHC_Date_of_Service_Start__c":"2018-10-30 00:00:00","Case__r.UHC_Is_this_a_State_Directed_Correction__c":null,"Case__r.UHC_Platform__c":"NICE","Case__r.Account.Organization_Type__c":"ACO","Case__r.Root_Cause__c":"Provider Error","Case__r.Submitter_Contact__r.Email":"bhanu.p.jain@email.com","Case__r.Markets__c":"Alabama","Case__r.UHC_Related_to_a_Provider_System_Update__c":"false","Case__r.Subject":"SUBJECT","Case__r.Account_TIN__c":"009002322","Case__r.UHC_Is_this_in_relation_to_a_UHC_error__c":"Yes","Case__r.UHC_Date_of_Service_End__c":"2018-11-02 00:00:00","Case__r.UHC_Line_of_Business__c":"Community and State","Case__r.Description":"Text","Case__r.Account.Name":"Nick ACET Provider","Case__c":"500K000000GR2ZSIA1","Case__r.Submitter_Contact__r.Phone":"(988) 123-8802","Case__r.UHC_Provider_Contact__r.Email":"suman.k@pwc.com"}],"RequestHeader":{"Operation":"PUSH","Type":"CPM","SourceSystem":"IMPACT"}}';  
      RestRequest req = new RestRequest(); 
      RestResponse res = new RestResponse();
            
      req.requestURI = '/IntakeProcess';  //Request URL
      req.httpMethod = 'POST';//HTTP Request Type
      req.requestBody = Blob.valueof(jsonBody);
      RestContext.request = req;
      RestContext.response= res; 
      
      PC_CaseIntakeService.doPost();
    }
    static testMethod void testRESCUOpertaionPositive() {
        String jsonBody = '{"Data":[{"Attachments":[{"Body":"Q29udGVudA==","Name":"Test.txt"},{"Body":"Q29udGVudA==","Name":"Test21.txt"}],"Id":"500K000000FHeruIAD","Parent.If_Urgent_why__c":"Claims IMPACT","Description":"DESC","Date_Submitted_to_PCDM__c":"2018-11-12 00:00:00","CaseNumber":"00673118","Parent.Account.Region__c":"Central","Synergy_RNOP__c":null,"LOBs__c":"C&S","Parent.Account.Name":"Nick ACET Provider","Parent.Delegated__c":"false","Phycon__c":"PR-0000810","Owner.Name":"suman","MPINs_in_Project__c":null,"Account_TIN__c":"009002322","Subject":"SUB004","Parent.Account.State__c":"MN","Parent.Priority":"Urgent"}],"RequestHeader":{"Operation":"PUSH","Type":"RESCU","SourceSystem":"IMPACT"}}';  
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();              
        req.requestURI = '/IntakeProcess';  //Request URL
        req.httpMethod = 'POST';//HTTP Request Type
        req.requestBody = Blob.valueof(jsonBody);
        RestContext.request = req;
        RestContext.response= res; 
        
        PC_CaseIntakeService.doPost();
      }    
      static testMethod void testCaseItemPositive() {
        String jsonBody = '{"Data" : [ { "ClaimsData" : [ { "UHC_Total_Billed_Charges__c" : "100.00","Claim_Processing_Status__c" : "Claim Adjusted","UHC_Member_First_Name__c" : "Ganesh 1","UHC_ORS_Tracking_Number__c" : "123456" }, {"UHC_Total_Billed_Charges__c" : "100.00","Claim_Processing_Status__c" : "Claim Adjusted","UHC_Member_First_Name__c" : "Ganesh 2","UHC_ORS_Tracking_Number__c" : "23456789"} ],"Claim_ICN" : "222222;111111","Attachments" : [ {"Body" : "UEsDBBQABgAIAAAAIQCq91ikeQEAABQGA","Name" : "Latest SENS Classification.xlsx"} ],"Subject" : "Missing/incomplete/invalid referring provider primary identifier- Denials","TAXID__c" : "123123123","Origin" : "Impact System","Markets__c" : "Kentucky","UHC_Provider_Contact__r.Email" : "ganesh@external.com","Id" : "50005000001jqZcAAI","Description" : "Claim denied stating: Missing/incomplete/invalid referring provider primary identifier."} ],"RequestHeader" : {"Operation" : "PUSH","Type" : "SPIRE","SourceSystem" : "IMPACT_FAST"}}';  
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
              
        req.requestURI = '/IntakeProcess';  //Request URL
        req.httpMethod = 'POST';//HTTP Request Type
        req.requestBody = Blob.valueof(jsonBody);
        RestContext.request = req;
        RestContext.response= res; 
        
        PC_CaseIntakeService.doPost();
      }
}