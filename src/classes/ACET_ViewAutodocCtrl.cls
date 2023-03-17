public class ACET_ViewAutodocCtrl {
    
    @AuraEnabled
    public static String getAutoDocInfo(String CaseId){
        String autoDocBody = '';
		ContentDocumentLink attachAutoDoc = new ContentDocumentLink();															  
        try{
            Case caseRec = [Select Id, CreatedDate,Recordtype.DeveloperName From Case WHERE Id=:CaseId];
            String newAutodocDate = Label.ACET_NewAutodocDate;
            if(caseRec.CreatedDate >= Date.valueOf(newAutodocDate)) {
			if(caseRec.Recordtype.DeveloperName == 'Motion'){
                	attachAutoDoc = [select ContentDocumentId,LinkedEntityId,contentDocument.LastModifiedDate,contentDocument.Title from ContentDocumentLink where LinkedEntityId=:caseId AND contentDocument.Title LIKE '%Autodoc%' ORDER BY contentDocument.LastModifiedDate DESC LIMIT 1];   
                }else{
                	attachAutoDoc = [select ContentDocumentId,LinkedEntityId from ContentDocumentLink where LinkedEntityId=:caseId];
                }
                if(attachAutoDoc != null){
                    ContentVersion conVer = [select ContentDocumentId,VersionData from ContentVersion where ContentDocumentId =:attachAutoDoc.ContentDocumentId];
                    if(conVer != null){
                        autoDocBody = conVer.VersionData.toString();
                    }
                }
            }
        } catch(QueryException qe) {
            System.debug('no autodoc content available'+qe.getStackTraceString());
        }
        return autoDocBody;
    }
}