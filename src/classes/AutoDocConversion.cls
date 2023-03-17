public class AutoDocConversion implements Database.Batchable<sObject>{
	
    
    public Database.querylocator start(Database.BatchableContext BC){
        Date autoDocStartDate = Date.valueOf(Label.ACETAutodocDate);
        if(!Test.isRunningTest()){
            return Database.getQueryLocator([select id,CaseNumber, AutoDoc__c from case where createdDate<=:autoDocStartDate]);
        }else{
        	return Database.getQueryLocator([select id,CaseNumber, AutoDoc__c from case limit 100]);
        }
		
    }

    public void execute(Database.BatchableContext BC, List<Case> scope){
        map<id,ContentVersion> contentVersionWithCaseMap = new map<id, ContentVersion>();
        
        for(Case cs : scope){
            if(cs.AutoDoc__c != null){
                ContentVersion cv = new ContentVersion();
                cv.ContentLocation = 'S';
                cv.PathOnClient = 'autodoc.html';
                cv.Title = 'Autodoc '+cs.CaseNumber;
                cv.VersionData =  blob.valueof(cs.AutoDoc__c);
                contentVersionWithCaseMap.put(cs.id,cv);
            }
        }
        if(contentVersionWithCaseMap.size() > 0 /*&& !test.isRunningTest()*/){
            insert contentVersionWithCaseMap.values();
        }
        set<id> contentVersionIds = new set<id>();
        for(ContentVersion cv : contentVersionWithCaseMap.values()){
            contentVersionIds.add(cv.id);
        }
        map<id,ContentVersion> contentVersionMap = new map<id, ContentVersion>();
        contentVersionMap = new map<id, ContentVersion>([select id,ContentDocumentId from ContentVersion where id In:contentVersionIds]);
        List<ContentDocumentLink> contentdocLink = new List<ContentDocumentLink>();
            
        for(Id caseId : contentVersionWithCaseMap.keySet()){      
            ContentDocumentLink cd = new ContentDocumentLink();
            cd.LinkedEntityId = caseId;
            cd.ShareType = 'I';
            if(contentVersionWithCaseMap.get(caseId) != null){ 
                if(contentVersionMap.get(contentVersionWithCaseMap.get(caseId).id) != null){
                    cd.ContentDocumentId = contentVersionMap.get(contentVersionWithCaseMap.get(caseId).id).ContentDocumentId;                
                	contentdocLink.add(cd);
                }
                
            }  
        }
        if(contentdocLink.size() > 0){
            insert contentdocLink;
        }
  
    }
    
    public void finish(Database.BatchableContext BC){

    }
}