@istest(seealldata=false)
private class SAE_ContentDocLinkTriggerHandlerTest {
    
    static testmethod void contentDocumentLinkErrorTest(){
        
        ContentNote conDocRec = new ContentNote();
        conDocRec.Title = 'Test';
        Insert conDocRec;
        
        Interaction__c interactionRec = new Interaction__c();
        Insert interactionRec;
        
        ContentDocumentLink conDocLinkRec = new ContentDocumentLink();
        conDocLinkRec.ContentDocumentId = conDocRec.Id;
        conDocLinkRec.LinkedEntityId = interactionRec.Id;
        Database.SaveResult result = Database.Insert(conDocLinkRec,false);
        //System.assertEquals('"Add to Records" button is not enabled, copy and paste notes to case comments if needed.',result.getErrors()[0].getMessage());
    }
    
}