@RestResource(urlMapping='/ermAPI/*')
global without sharing class ERM_InboundUpdateService {
    
    @HTTPPut
    global static String upsertStatusCaseComment() { 
        
        Case caseRec=new Case();
        List<CaseComment> caseCommentLst=new List<CaseComment>();
        List<Stream_Request_Details__c> reqDetailLst=new List<Stream_Request_Details__c>();
        try{
            RestRequest req = RestContext.request;
            CustomReq commentWrap = (CustomReq)JSON.deserialize(req.requestbody.tostring(),CustomReq.class);
            System.debug('commentWrap=='+commentWrap);
            
            if(!String.isBlank(commentWrap.requestNumber)){
                caseRec=[Select id,External_Reference_ID__c,Status,IsEscalated,(Select id,Pended_Reason__c from Request_Details__r ) from Case where External_Reference_ID__c=:commentWrap.requestNumber LIMIT 1];
                System.Debug('caseRec===='+caseRec);
            }else{
                return 'No Matches found';
            }
            
            if(caseRec!=null){
                caseRec.Status=commentWrap.status;
                caseRec.No_More_Comments__c=true;
                Update caseRec;
            }                        
            List<comment> commentString = commentWrap.commentCase;  
            List<PendedReason> pendedReasonLstString=commentWrap.pendedReason;
            
            for(integer i=0;i<commentString.size();i++){
                CaseComment newComnt = new CaseComment();
                newComnt.CommentBody=commentString[i].Body;
                newComnt.IsPublished = TRUE;
                newComnt.ParentId = caseRec.Id;
                caseCommentLst.add(newComnt);            
            }
            insert caseCommentLst;
            
            if(caseRec.Request_Details__r!=null){
                for(Stream_Request_Details__c reqRec:caseRec.Request_Details__r){
                    
                    List<String> resonStr=new List<String>();                   
                    for(integer i=0;i<pendedReasonLstString.size();i++){
                        resonStr.addall(pendedReasonLstString[i].Reason.split(','));                    
                    }             
                    reqRec.Pended_Reason__c=String.join(resonStr, ';');
                    reqRec.Bypass_Validation_Rule__c=true;
                    reqDetailLst.add(reqRec);
                } 
                  update reqDetailLst;
            }   
            return 'Success';  
        }catch(Exception e) {
            System.debug('An unexpected error has occurred: ' + e.getMessage());
            return +e.getMessage();
        }
        
    }      
    
    global class CustomReq{
        Public String requestNumber;
        Public String status;
        Public List<Comment> commentCase;
        public List<PendedReason> pendedReason;
    }
    
    global class Comment{
        public string Body;
    }
    
    global class PendedReason{
        public string Reason;
    }
}