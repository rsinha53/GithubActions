global class ETSBE_InteractionFileArchiveBatch implements Database.Batchable<sObject>,Database.AllowsCallouts {
    global List<ContentDocumentLink> start(Database.BatchableContext BC) {
        String tempquery = 'SELECT ContentDocumentId, LinkedEntityId  '+
            'FROM ContentDocumentLink '+
            'WHERE LinkedEntityId in (SELECT Id FROM Interaction__c WHERE Evt_Recvd_Dt_Time__c != null) AND ContentDocument.isarchived = false' ;
        
        
        return Database.query(tempquery ); 
    }
    
    global void execute(Database.BatchableContext BC, List<ContentDocumentLink> scope) {
        map<Id,string> contentDocIds = new map<Id,string>();
        transient List<Attachments__c> attchList = new List<Attachments__c>();
        transient set<string> uploadeddocids = new set<string>(); 
        for(ContentDocumentLink doclinks : scope){
            contentDocIds.put(doclinks.ContentDocumentId,doclinks.LinkedEntityId);
        }
        
        ETSBE_FileArchiveWebservice fileser = new ETSBE_FileArchiveWebservice('Interaction__c');
        fileser.getOAuthToken();  
        fileser.getEndpoint();
        List<ContentVersion> ContentVersionList =  [SELECT VersionData,PathOnClient,ContentDocumentId,contentdocument.description  FROM ContentVersion
                                                    WHERE ContentDocumentId in: contentDocIds.keyset()   
                                                    AND IsLatest = true
                                                    AND contentdocument.IsArchived=false];
        
        for(ContentVersion versiondata : ContentVersionList){
            try{
                transient map<string,Attachments__c> filedata = fileser.uploadFile( versiondata,contentDocIds.get(versiondata.ContentDocumentId));
                attchList.add(filedata.values());
                uploadeddocids.addall(filedata.keyset());
            }
            catch(Exception e){
                system.debug('Exception occurred ' + e.getMessage());
            }
        }
        
        if(attchList.size()>0)
            insert attchList;
        List<ContentDocument> updatearchiveList = new List<ContentDocument>();
        
        if(uploadeddocids.size()>0){
            for(string docid :uploadeddocids){
                ContentDocument docu = new ContentDocument();
                docu.id=docid;
                docu.isarchived=true;
                updatearchiveList.add(docu);
            }
            update  updatearchiveList;
            
        } 
        
    }   
    
    global void finish(Database.BatchableContext BC) {
    }
}