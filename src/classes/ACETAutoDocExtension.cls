public with sharing class ACETAutoDocExtension {
    public ContentDocumentLink attachAutoDoc{get;set;}
    public ContentVersion conVer{get;set;}
    public boolean autoDocRenderer{get;set;}
    public String autoDocBody{get;set;}
	public boolean lightningAutodoc{get;set;}
    public ACETAutoDocExtension(ApexPages.StandardController controller) {
        //Blob cryptoKey = Crypto.generateAesKey(256);
        lightningAutodoc = false;
        attachAutoDoc = new ContentDocumentLink();
        id caseId=apexpages.currentpage().getparameters().get('Id');
        if(caseId != Null){
            String autoDocDate = Label.ACETAutodocDate;
            case cId = [select id,createdDate from case where id=:caseId];
            if(cId.createdDate < Date.valueOf(autoDocDate)){
                autoDocRenderer = false;
            }else{
                autoDocRenderer = true;
                try{
				attachAutoDoc = [select ContentDocumentId,LinkedEntityId from ContentDocumentLink where LinkedEntityId=:caseId ];
                if(attachAutoDoc != null){
                    String contentDocumentId = String.isBlank(attachAutoDoc.ContentDocumentId)?attachAutoDoc.ContentDocumentId : String.escapeSingleQuotes(attachAutoDoc.ContentDocumentId); //US3666255 : Checkmarx fix
                    conVer = [select ContentDocumentId,VersionData from ContentVersion where ContentDocumentId =:contentDocumentId];
                    if(conVer != null){
                        autoDocBody = conVer.VersionData.toString();
                    }
                    //DE306920 - Regression - Sanka
                    if(autoDocBody.contains('lightningHighlightspanel') || autoDocBody.contains('autodocValue') || autoDocBody.contains('card_padding')){
                        lightningAutodoc = true;
                    }
                }
                }Catch(QueryException qe){
                    System.debug('There is no autodoc content available');
                }


            }
            }

    }
}