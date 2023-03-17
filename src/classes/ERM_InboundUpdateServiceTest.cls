@isTest
public class ERM_InboundUpdateServiceTest {
    
    @isTest
    static void upsertStatusCaseCommentTest(){
        
        Case cas = new Case(Status ='New', Priority = 'Medium', Origin = 'Email', External_Reference_ID__c='246800'); 
        insert cas;
        
        Stream_Request_Details__c reqDet=new Stream_Request_Details__c();
        reqDet.Plat_form__c='PRIME';
        reqDet.RequestType__c='Add';
        reqDet.Estimated_Transactions__c=2;
        reqDet.Effective_Date__c=Date.valueOf('1960-01-02');
        reqDet.Case__c=cas.id;
        reqDet.Vendor__c='Chennai';
        reqDet.Family_Selection__c='Employee';
        reqDet.Pended_Reason__c='Billing access not showing under Broker/Employer; Broker/Employer Address mismatch';
        insert reqDet;
        System.assertEquals('Chennai', reqDet.Vendor__c);
        
        
        
        
        List<CaseComment> caseCommentLst=new List<CaseComment>();
        CaseComment   tComment = new CaseComment();
        tComment.ParentId = cas.Id;
        tComment.CommentBody = 'Some Comment';
        tComment.IsPublished = TRUE;      
        
        CaseComment   tComment1 = new CaseComment();
        tComment1.ParentId = cas.Id;
        tComment1.CommentBody = 'Some Comment test1';
        tComment1.IsPublished = FALSE; 
        
        caseCommentLst.add(tComment);
        caseCommentLst.add(tComment1);               
        insert caseCommentLst;
        
        Test.startTest();
        
        ERM_InboundUpdateService.CustomReq custmRequest=new ERM_InboundUpdateService.CustomReq();
        
        custmRequest.requestNumber=cas.External_Reference_ID__c;
        custmRequest.status=cas.Status;
       
        
        System.assertEquals(TRUE, caseCommentLst[0].IsPublished, 'True');
        
        custmRequest.commentCase=new List<ERM_InboundUpdateService.Comment>();
        
        ERM_InboundUpdateService.Comment commentWrap=new ERM_InboundUpdateService.Comment();
        List<ERM_InboundUpdateService.Comment> commentWrapLst=new List<ERM_InboundUpdateService.Comment>();
                
        for(integer i=0;i<=caseCommentLst.size();i++){
            
            commentWrap.Body=caseCommentLst[0].CommentBody;
            commentWrapLst.add(commentWrap);
        }
        
        custmRequest.commentCase.addAll(commentWrapLst);
        
        
        String myJSON = JSON.serialize(custmRequest);
        
        RestRequest request = new RestRequest();
        request.requestUri ='https://acet-uhg--streamdev.my.salesforce.com/services/apexrest/ermAPI/';
        request.httpMethod = 'PUT';
        request.requestBody = Blob.valueof(myJSON);
        
        RestContext.request = request;
         ERM_InboundUpdateService.upsertStatusCaseComment();
        Test.stopTest();
    }
}