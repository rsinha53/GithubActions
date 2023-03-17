public class ETSBE_FileArchiveWebservice extends AcetWebservice{
    public String GrantType;
    public String AccessToken;
    public String ClientId ;
    public String ClientSecret ;
    public String RequestBodyStr;
    public String FDSendpoint;
    public String SObj;
     public ETSBE_FileArchiveWebservice(String Sobj){
        this.SObj = Sobj;
    }
    public void getTokenEndpoint(){
        GetEndpointDetail('GetFDSTokenEndpoint');
        BaseURL = '';
        FDSendpoint ='';
    }
    public override void getEndpoint(){
        GetEndpointDetail('GetFDSUploadEndpoint');
        if (WSConfigurations.containsKey(OrgName + '_GetFDSBaseURL')){
            BaseURL = WSConfigurations.get(OrgName + '_GetFDSBaseURL').Value__c; //https://solaris-lightning--TEST.cs29.my.salesforce.com
        }
        
        if(WSConfigurations.containsKey(OrgName + '_GetFDSUploadEndpoint')){
            FDSendpoint = WSConfigurations.get(OrgName + '_GetFDSUploadEndpoint').Value__c; //50f766e3-c685-4e7d-a7d6-423c76b24cd5
        }
        
    }
    public void getRequestBodyWS(String searchNumber, String searchType) {
        RequestBody = 'searchStr='+searchNumber.trim()+'&type='+searchType;      
    }
    
    public String getOAuthToken(){
        
        if (WSConfigurations.containsKey('ISLConAccessToken'))  {
            OAuthConfig = WSConfigurations.get('ISLConAccessToken');
        }
        
        ETSBE_FDSApiOAuthWebservice oAuth = new ETSBE_FDSApiOAuthWebservice();
        
        AccessToken = oAuth.GetAccessToken();
        
        OAuthConfig.Value__c = AccessToken;
        
        System.debug('INSIDE TOKEN GEN3' + OAuthConfig);
        
        return accesstoken;
    }
    Public Map<string,Attachments__c> uploadFile(ContentVersion fileData,String SobjId ){
        Attachments__c attachmentdata = new Attachments__c();
        Map<string,Attachments__c> attachdoccontentDoc= new Map<String,Attachments__c>();
        
        
        transient string Boundary = '1ff13444ed8140c7a32fc4e6451aa76d';
        transient string contentType = ETSBE_HttpFileFormBuilder.GetContentType();
        
        transient string form64 = '';
        if(limits.getHeapSize()<10000000) {
        form64 += ETSBE_HttpFileFormBuilder.WriteBoundary();
        
        ETSBE_HttpFileFormBuilder.WriteFileResult result = ETSBE_HttpFileFormBuilder.WriteFile('file_007', fileData.PathOnClient, 'application/octet-stream', filedata.VersionData);
        
        form64 += result.Content;
        form64 += ETSBE_HttpFileFormBuilder.WriteBoundary(result.EndingType);
        
        blob formBlob = EncodingUtil.base64Decode(form64);
        string contentLength = string.valueOf(formBlob.size());
        HttpRequest docreq =new HttpRequest();
        docreq.setHeader('Content-Type','multipart/form-data; charset="UTF-8"; boundary="' + Boundary + '"');
        docreq.setTimeout(120000);
        docreq .setEndpoint(FDSendpoint );
        
        docreq.setHeader('Authorization','Bearer '+AccessToken);
        docreq.setMethod('POST');
        docreq.setBodyasblob(formBlob);
        Http dochttp =new Http();
        HTTPResponse docres = dochttp.send(docreq );
        
        if(docres.getStatusCode() == 200) {
            dataList docData =
                
                (dataList)JSON.deserialize(docres.getbody(), dataList.class);
            
            if(docData.attachment.size()>0){
                Attachments__c attchdata = new Attachments__c();
                attchdata.File_Name__c = docData.attachment[0].Id ; //HYPERLINK('https://ap1.salesforce.com/', docData.attachment[0].file_name, '_self');
                attchdata.FDS_File_Name__c = '<a href=/lightning/ETSBE_FetchFDSFile?c__fileID='+docData.attachment[0].Id+' >'+  docData.attachment[0].file_name+'</a>';
                 if(docData.attachment[0].file_name.length()>80){
                     attchdata.Name = docData.attachment[0].file_name.substring(0,79);
                 }
                else{
                    attchdata.Name = docData.attachment[0].file_name;
                }
				attchdata.Description__c = fileData.ContentDocument.description;
                attchdata.Content_Type__c = docData.attachment[0].content_type;
                
                if(Sobj.equalsIgnoreCase('Case')){
                    attchdata.case__c =SobjId;
                }else if(Sobj.equalsIgnoreCase('Interaction__c')){
                    attchdata.Interaction__c =SobjId;
                }
                 
                attachmentdata = attchdata;
                attachdoccontentDoc.put(fileData.ContentDocumentId,attchdata);
            }
        }
        }
        
        return attachdoccontentDoc;
    }
    public class dataList{
        
        Public List<attachmentdata> attachment;
    }
    Public class attachmentdata {
        Public string id;
        Public string status;
        Public string file_name;
        Public string file_size;
        Public string content_type;
    }
}