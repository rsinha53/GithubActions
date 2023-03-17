public class ETSBE_AttchmtUploadController {   
    @AuraEnabled
    Public static string fetchSingleFile(String fileId,String attchId){
        String returnData;
        if(attchId != null){
            List<Attachments__c> attch=[SELECT Id, Name, FDS_File_Name__c, File_Name__c, Content_Type__c, CreatedDate 
                                  FROM Attachments__c where id=:attchId];
            if(attch.size()>0){
                Attachments__c atch= attch[0];
                ETSBE_AttchmtWrapper aw = new ETSBE_AttchmtWrapper();
            aw.fileId = atch.File_Name__c;
            aw.fileName = atch.Name;
            aw.attchId = atch.id;
            aw.fdsFileName = atch.FDS_File_Name__c;
            aw.createdDate = atch.CreatedDate;
            aw.fileType = atch.Content_Type__c;
            aw.isContent = false;
            aw.isAttachment = true;  
                returnData= json.serialize(aw);
            }
        }else{
            List<ContentDocument> doc = [SELECT Id,Title,FileType,Description, CreatedDate FROM ContentDocument WHERE id=:fileId];
        	if(doc.size()>0){
                ContentDocument fdoc = doc[0];
                ETSBE_AttchmtWrapper aw = new ETSBE_AttchmtWrapper();
            aw.fileId = fdoc.Id;
            aw.fileName = fdoc.Title;
            aw.createdDate = fdoc.CreatedDate;
            aw.fileType = fdoc.FileType;
            aw.isContent = true;
            aw.isAttachment = false;
            aw.Description = fdoc.Description ;
                returnData= json.serialize(aw);
            }
        }
        return returnData;
    }
    @AuraEnabled
    Public static string updateFiles(String file){
        String statusMessage='';
        ETSBE_AttchmtWrapper updateFile = (ETSBE_AttchmtWrapper)json.deserialize(file, ETSBE_AttchmtWrapper.class);
        String sObjName = id.valueof(updateFile.fileId).getSObjectType().getDescribe().getName(); 
        if(sObjName == 'ContentDocument'){
            ContentDocument doc = new ContentDocument();
            doc.id=updateFile.fileId;
            doc.description = updateFile.Description;
            Update doc;
        }else{
            
            Attachments__c attchFile = new Attachments__c();
            attchFile.id=updateFile.attchId;
            attchFile.Description__c=updateFile.Description;
            update attchFile;
        }
        
        return statusMessage;
    }
    @AuraEnabled  
    public static List<ETSBE_AttchmtWrapper> fetchFiles(string recordId){ 
        Set<Id> recordIds=new Set<Id>{recordId};
        Set<Id> contentDocIds = new Set<Id>(); 
        List<ContentDocumentLink> cdlList=[SELECT id,LinkedEntityId,ContentDocumentId 
                                           FROM ContentDocumentLink 
                                           WHERE LinkedEntityId IN:recordIds];
        List<ContentDocumentLink> cdlEmailAttchmntList = [SELECT id,LinkedEntityId,ContentDocumentId 
                                           				  FROM ContentDocumentLink 
         								   				  WHERE LinkedEntityId IN (SELECT ID From EmailMessage WHERE ParentId IN :recordIds)];
        
        cdlList.addAll(cdlEmailAttchmntList);
        for(ContentDocumentLink cdLink:cdlList){  
            contentDocIds.add(cdLink.ContentDocumentId);  
        }   
        
        List<ETSBE_AttchmtWrapper> attchmntWrapperList = new List<ETSBE_AttchmtWrapper>();
        for(ContentDocument cd:[SELECT Id,Title,FileType,Description, CreatedDate FROM ContentDocument WHERE id IN: contentDocIds and IsArchived = false order by createddate desc]){
        	ETSBE_AttchmtWrapper aw = new ETSBE_AttchmtWrapper();
            aw.fileId = cd.Id;
            aw.fileName = cd.Title;
            aw.createdDate = cd.CreatedDate;
            aw.fileType = cd.FileType;
            aw.isContent = true;
            aw.isAttachment = false;
            aw.Description = cd.Description ;
            attchmntWrapperList.add(aw);
        }
        for(Attachments__c attch : [SELECT Id, Name, FDS_File_Name__c,description__c, File_Name__c,
                                    Content_Type__c, CreatedDate FROM Attachments__c WHERE document_id__c = null and
                                    (Case__c IN :recordIds OR Interaction__c IN :recordIds)]){
        	ETSBE_AttchmtWrapper aw = new ETSBE_AttchmtWrapper();
            aw.fileId = attch.File_Name__c;
            aw.fileName = attch.Name;
            aw.attchId = attch.id;
            aw.fdsFileName = attch.FDS_File_Name__c;
            aw.createdDate = attch.CreatedDate;
            aw.fileType = attch.Content_Type__c;
            aw.isContent = false;
            aw.isAttachment = true;    
            aw.description = attch.description__c;
            attchmntWrapperList.add(aw);            
        }
              
        return attchmntWrapperList;
    } 
    
    @AuraEnabled  
    public static void deleteFiles(string sdocumentId){ 
        delete [SELECT Id,Title,FileType from ContentDocument WHERE id=:sdocumentId];       
    } 
    @AuraEnabled
    Public static boolean disableAttachment(string caseId){
        boolean disableattachment=false;
        
        List<Stream_Request_Details__c> details = [select id,Plat_form__c,Communication_Center_Only__c,INactivate_the_user_profile_abo__c,All_users_have_same_permission_as_policy__c,Subscriber_CPTIN__c,Count_of_Reports_Requested__c,
                                             case__r.casenumber,Effective_Date__c,Estimated_Transactions__c,Case__c,RequestType__c,Report_Needed__c
                                             from Stream_Request_Details__c where case__c=: caseId];
        if(details.size()>0){
            Stream_Request_Details__c recorddata = details[0];
            system.debug('/////////////'+details[0].RequestType__c);
            if(recorddata.RequestType__c == 'Standard Alt-ID Change'){
                disableattachment = true;
            }
        }
        return disableattachment;
    }
    @AuraEnabled  
    public static List<String> fetchAcceptedFormats(string Caseid){ 
        List<String> acceptedFormats = new List<String>();
        Case fetchCase = [select id,recordtype.name,status from case where id=: caseid];
        if(fetchCase.recordtype.name =='BEO'){
            acceptedFormats = System.label.FDS_File_Upload_Formats.split(',');
            
                }else if (fetchCase.recordtype.name =='Stream'){
                     if(fetchCase.status=='Closed'){
            			acceptedFormats = new List<String>();
        			}
                    else{
       
                    acceptedFormats = system.label.ERM_FDS_File_Upload_Formats.split(',');
                    }
                }
        
        return acceptedFormats;
       
    }    
   
 }