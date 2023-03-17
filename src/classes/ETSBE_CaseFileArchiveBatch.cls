global class ETSBE_CaseFileArchiveBatch implements Database.Batchable<sObject>,Database.AllowsCallouts {
    global List<ContentDocumentLink> start(Database.BatchableContext BC) {
        List<ContentDocumentLink> cdlList=[SELECT id,LinkedEntityId,ContentDocumentId
                                            FROM ContentDocumentLink WHERE LinkedEntityId in (SELECT Id FROM Case where recordtype.name='BEO' or recordtype.name='BEO Closed' )
                                            limit 40000 ];
                                            System.debug('cdlList=='+cdlList);
        List<ContentDocumentLink> cdlEmailAttchmntList = [SELECT id,LinkedEntityId,ContentDocumentId
                                                          FROM ContentDocumentLink
                                                          WHERE LinkedEntityId IN (SELECT ID From EmailMessage) limit 10000];
        
        cdlList.addAll(cdlEmailAttchmntList);
        return cdlList;
    }
    global void execute(Database.BatchableContext BC, List<ContentDocumentLink> scope) {
        try{
            map<Id,string> contentDocIds = new map<Id,string>();
            transient List<Attachments__c> attchList = new List<Attachments__c>();
            transient set<string> uploadeddocids = new set<string>();
            map<String,string> contentIds = new map<string,string>();
            transient map<string,Attachments__c> filedata = new map<string,Attachments__c>();
            set<Id> linkentityIds=new set<Id>();
            for(ContentDocumentLink doc :scope){
                linkentityIds.add(doc.LinkedEntityId);
            }
            for(EmailMessage msg:[select id,parentid from emailmessage where id in: linkentityIds]){
                contentIds.put(msg.id,msg.parentid);
            }
            for(ContentDocumentLink doclinks : scope){
                if(String.valueof(doclinks.LinkedEntityId).substring(0,3) !='02s' ){
                    contentDocIds.put(doclinks.ContentDocumentId,doclinks.LinkedEntityId);
                }
                else {
                    if(contentIds.containskey(doclinks.LinkedEntityId)){
                        contentIds.put(doclinks.ContentDocumentId,contentIds.get(doclinks.LinkedEntityId));
                    }}
            }
            ETSBE_CaseFileArchiveWebservice fileser = new ETSBE_CaseFileArchiveWebservice();
            fileser.getOAuthToken();
            fileser.getEndpoint();
            
            for(ContentVersion versiondata : [SELECT VersionData,PathOnClient,ContentDocumentId,contentdocument.description FROM ContentVersion
                                              WHERE ContentDocumentId in: contentDocIds.keyset()
                                              AND IsLatest = true and contentdocument.IsArchived=false]){
                                                  
                                                  string file64 = EncodingUtil.base64Encode(versiondata.VersionData);
                                                  System.debug('file64==='+file64 + ':::' +file64.length());
                                                  transient integer file64Length = file64.length();
                                                  if(file64Length<12000000){
                                                      if(limits.getHeapSize()<10000000) {
                                                          filedata = fileser.uploadFile( versiondata,contentDocIds.get(versiondata.ContentDocumentId));
                                                          if(filedata != null){
                                                              if(filedata.values().size()>0){
                                                                  attchList.add(filedata.values());
                                                                  uploadeddocids.addall(filedata.keyset());
                                                              }
                                                          }
                                                      }
                                                  }
                                              }
            if(attchList.size()>0 &&!test.isRunningTest())
                insert attchList;
            List<ContentDocument> updatearchiveList = new List<ContentDocument>();
            if(uploadeddocids.size()>0){
                for(string docid :uploadeddocids){
                    ContentDocument docu = new ContentDocument();
                    docu.id=docid;
                    docu.isarchived=true;
                    updatearchiveList.add(docu);
                }
                if(updatearchiveList.size()>0 && !test.isRunningTest())
                    update updatearchiveList;
                
            }
        }catch(exception e){}
    }
    global void finish(Database.BatchableContext BC) {
    }
}