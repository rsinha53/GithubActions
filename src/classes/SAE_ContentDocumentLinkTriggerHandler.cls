public class SAE_ContentDocumentLinkTriggerHandler {
    
    List<ContentDocumentLink> newContentLinks;
    
    public SAE_ContentDocumentLinkTriggerHandler(List<ContentDocumentLink> newTriggerContentDocumentLinks) {
        newContentLinks = newTriggerContentDocumentLinks;
    }
    
    public void contentDocumentLinkError() {
        Set<Id> contentDocIds = new Set<Id>();
        
        for(ContentDocumentLink conDocLinkRec : newContentLinks){
            system.debug('conDocLinkRec::'+conDocLinkRec);
            if(conDocLinkRec.LinkedEntityId != null && !String.valueof(conDocLinkRec.LinkedEntityId).startswith('005')){
                contentDocIds.add(conDocLinkRec.ContentDocumentId);
            } 
        }
        
        List<ContentDocument> contentDocList = [Select Id, FileType from ContentDocument where Id In:contentDocIds and FileType = 'SNOTE'];
        
        for(ContentDocumentLink conDocLinkRec: newContentLinks){
            for(ContentDocument contentDocRec : contentDocList){
                if(contentDocRec.Id == conDocLinkRec.ContentDocumentId){
                    system.debug('contentDocRec::'+contentDocRec.Id);
                    conDocLinkRec.adderror('"Add to Records" button is not enabled, copy and paste notes to case comments if needed.');
                }
            }   
        }
    }
}