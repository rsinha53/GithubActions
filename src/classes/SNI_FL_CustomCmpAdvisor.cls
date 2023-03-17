public class SNI_FL_CustomCmpAdvisor {
    
    @AuraEnabled  
    public static List<ContentDocument> getFiles(string recordId){ 
        Set<Id> recordIds=new Set<Id>{recordId};
        Set<Id> documentIds = new Set<Id>(); 
        List<ContentDocumentLink> cdl=[SELECT id,LinkedEntityId,ContentDocumentId,Visibility FROM ContentDocumentLink WHERE LinkedEntityId IN:recordIds AND Visibility='InternalUsers'];  
        for(ContentDocumentLink cdLink:cdl){  
            documentIds.add(cdLink.ContentDocumentId);
            System.debug('Visibility+++'+ cdLink.Visibility);
        }     
            
            
        List<ContentDocument> l_contentDocument = [SELECT Id,Title,format(LastModifiedDate) ,Owner.Name,LastModifiedBy.Name FROM ContentDocument WHERE id IN: documentIds Order by LastModifiedDate desc];    
        return l_contentDocument;  
    }
    
    @AuraEnabled 
    public static List<ContentDocument> getallFiles(string recordId){ 
        
        Set<Id> recordIds=new Set<Id>{recordId};
        Set<Id> documentIds = new Set<Id>(); 
        List<ContentDocumentLink> cdl=[SELECT id,LinkedEntityId,ContentDocumentId,Visibility FROM ContentDocumentLink WHERE LinkedEntityId IN:recordIds AND Visibility='AllUsers'];  
        for(ContentDocumentLink cdLink:cdl){  
            documentIds.add(cdLink.ContentDocumentId);
            System.debug('Visibility+++'+ cdLink.Visibility);
        }      
         List<ContentDocument> l_contentDocument = [SELECT Id,Title,format(LastModifiedDate),Owner.Name,LastModifiedBy.Name FROM ContentDocument WHERE id IN: documentIds Order by LastModifiedDate desc];
        return l_contentDocument;  
    }
    
    @AuraEnabled  
    public static void deleteFiles(string sdocumentId){ 
        delete [SELECT Id,Title from ContentDocument WHERE id=:sdocumentId];       
    } 
    
    @AuraEnabled
    public static string DownloadAttachment(Id DownloadAttachmentID)
   {
    list<ContentVersion> oldCV = [Select Id,Title from ContentVersion Where ContentDocumentId=:DownloadAttachmentID];
    //System.Debug('Old LV INitial :'+ oldCV.Id);
    //System.Debug('Old Lock :'+ oldCV.Locked__c);
    String fullFileURL = URL.getSalesforceBaseUrl().toExternalForm();
      system.debug('fullFileURL'+ fullFileURL);
       String URlDownload = '';
       if(oldCV != null && oldCV.size()>0){
          URlDownload = fullFileURL+'/sfc/servlet.shepherd/version/download/'+oldCV[0].Id;
       }
    system.debug('Download URL:' +URlDownload);
    return URlDownload;
    } 
    @AuraEnabled
    public static List<Id> AllUserFiles(List<ID> uploadedFilesIds)
   {
    //   List<ContentDocument> l_contentDocument = (List<ContentDocument>)JSON.deserializeUntyped(uploadedFiles);
     //  List<ContentDocument> l_contentDocument =(List<ContentDocument>)JSON.deserialize(uploadedFiles, List<ContentDocument>.class);
     //  System.debug('Uploaded Files+ '+ l_contentDocument[0].id);
      // System.debug('Size'+l_contentDocument.size());
      // Set<Id> ContentDocumentIds = new Set<Id>();
       List<ContentDocumentLink> l_contentDocumentLink = new List<ContentDocumentLink>();
     /*  if(!l_contentDocument.isEmpty()){
       for(ContentDocument cd:l_contentDocument){
           ContentDocumentIds.add(cd.Id);
       }
       }*/
       String contentid = '';
       if(uploadedFilesIds.size()>0 ){
       List<ContentDocumentLink> cdl=[SELECT id,LinkedEntityId,ContentDocumentId,Visibility FROM ContentDocumentLink WHERE ContentDocumentId IN:uploadedFilesIds];
        
           if(cdl.size()>0 && !cdl.isEmpty()){
               for(ContentDocumentLink cdLink:cdl){  
            //documentIds.add(cdLink.ContentDocumentId);
            cdLink.Visibility = 'AllUsers';
            l_contentDocumentLink.add(cdLink);
            System.debug('Visibility+++'+ cdLink.Visibility);
               }}
           try{
               update l_contentDocumentLink;
           }catch(Exception e){
               System.debug('Exception '+ e.getMessage());
           }
           
       }
       return uploadedFilesIds;
    } 
    
    @AuraEnabled
    public static string editDocumentName(String sdocumentId,String Editedname){
            system.debug('title: ' +Editedname);
            system.debug('sdocumentId: ' +sdocumentId);
            ContentDocument cd = [select id,title from ContentDocument where Id=:sdocumentId]; // Getting files from Parent record 	     
            cd.Title = Editedname;  // Changing file Title with user entered title	 
        	/*try{
                update cd;
            } catch (Exception e){
                 system.debug('Exception has occurred! ' +e.getMessage());  
            }*/
       new UpdateRecord().updateRecordWithoutSharing(cd);
        return 'true';
    }
    
    public without sharing class UpdateRecord {
        public void updateRecordWithoutSharing(ContentDocument cd){
            try{
                update cd;
            } catch (Exception e){
                 system.debug('Exception has occurred! ' +e.getMessage());  
            }
        }
    }
    
     @AuraEnabled
    public static SNI_FL_DocumentsController.familyDocumentWrapper getUpdatedDocs(List<ID> uploadedFilesIds,string familyId,String RecordID,String selectedName){
        System.debug('114');
       User accountIdOfUser =[ select Id , AccountId from User where Id = :UserInfo.getUserId()];
        system.debug('in 116 '+accountIdOfUser);
       familyId =  accountIdOfUser.AccountId;
        system.debug('familyid::'+ familyId);
        string emailtoSend;
        string accountId;
        SNI_FL_DocumentsController.familyDocumentWrapper docwrap = new SNI_FL_DocumentsController.familyDocumentWrapper();
        try{
            List<Id> idslst = SNI_FL_CustomCmpAdvisor.AllUserFiles(uploadedFilesIds);
            docwrap = SNI_FL_DocumentsController.getdocuments(familyId);
            
            //Code added by ANKIT
            set<Id> accOwnerIds = new set<Id>();
            Id recIdss = RecordID;
            system.debug('recordId #127 ::'+RecordID);
            String TargetReferobjectName = recIdss.getSObjectType().getDescribe().getName();
            if(string.isNotBlank(RecordID)){ //logic for multiple families
                Id familyAccRecTypId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Family').getRecordTypeId();        
                Id recId = RecordID;
                system.debug('recId'+recId);
                String sObjName = recId.getSObjectType().getDescribe().getName();
                system.debug('--------sObjName----'+sObjName);
                if(sObjName!=Null && sObjName!='' && sObjName.equalsIgnoreCase('Member_Information__c')){
                    Member_Information__c memb =[select Id,Account__c,Account__r.PersonEmail from Member_Information__c where Id=:RecordID];
                     emailtoSend = memb.Account__r.PersonEmail;
                    accountId = memb.Account__c;
                    
                    system.debug('memb123'+memb);
                    if(memb!=Null && String.isNotBlank(memb.Account__c)){
                        List<Contact> conId = [SELECT id from Contact where accountId =: memb.Account__c];
                        system.debug('conId'+conId);
                        if(conId!=Null && conId.size()>0){
                            for(AccountContactRelation famacc: [select Id,ContactId,AccountId,Account.RecordTypeId,Account.OwnerId from AccountContactRelation where ContactId =:conId[0].Id AND Account.RecordTypeId=:familyAccRecTypId]){
                           		accOwnerIds.add(famacc.Account.OwnerId);
                                system.debug('----------famacc-----'+famacc.AccountId);
                            }
                        }
                    }
                }
                 else if(sObjName!=Null && sObjName!='' && sObjName.equalsIgnoreCase('Family_Overview__c')){
                    Family_Overview__c memb =[select Id,Account__c,Account__r.PersonEmail from Family_Overview__c where Id=:RecordID];
                     emailtoSend = memb.Account__r.PersonEmail;
                    accountId = memb.Account__c;
                    if(memb!=Null && String.isNotBlank(memb.Account__c)){
                        List<Contact> conId = [SELECT id from Contact where accountId =: memb.Account__c];
                        system.debug('conId'+conId);
                        if(conId!=Null && conId.size()>0){
                            for(AccountContactRelation famacc: [select Id,ContactId,AccountId,Account.RecordTypeId,Account.OwnerId from AccountContactRelation where ContactId =:conId[0].Id AND Account.RecordTypeId=:familyAccRecTypId]){
                           		accOwnerIds.add(famacc.Account.OwnerId);
                                system.debug('----------famacc-----'+famacc.AccountId);
                            }
                        }
                    }
                }
                /* else(sObjName!=Null && sObjName!='' && sObjName.equalsIgnoreCase('Case')){
                    Case memb =[select Id,AccountId from Case where Id=:RecordID];
                    // emailtoSend = memb.Account__r.PersonEmail;
                    accountId = memb.AccountId;
                    if(memb!=Null && String.isNotBlank(memb.AccountId)){
                        List<Contact> conId = [SELECT id from Contact where accountId =: memb.AccountId];
                        system.debug('conId'+conId);
                        if(conId!=Null && conId.size()>0){
                            for(AccountContactRelation famacc: [select Id,ContactId,AccountId,Account.RecordTypeId,Account.OwnerId from AccountContactRelation where ContactId =:conId[0].Id AND Account.RecordTypeId=:familyAccRecTypId]){
                           		accOwnerIds.add(famacc.Account.OwnerId);
                                system.debug('----------famacc-----'+famacc.AccountId);
                            }
                        }
                    }
                }*/
                
            }
            
            system.debug('accOwnerIds'+accOwnerIds);
            system.debug('familyId'+familyId);
           // List<Account> personAccountId= [SELECT Id, AccountId FROM User WHERE AccountId ID= :accountIdOfUser.AccountId ];
           String str;
           // List<Account> fca= [select Id,OwnerId from Account where Id=:familyId];
           // accOwnerIds.add(fca[0].OwnerId);
            //system.debug('fca'+fca);
            String loggedinuser = UserInfo.getName();
            system.debug('getName'+loggedinuser);
            system.debug('selectedName'+selectedName);
            system.debug('email to send'+emailtoSend);
            string providerAffiname='';
            string memberEmail= emailtoSend;
            
            
            //Creating a Map to pass parameters to the flow for notification. 
            for(Id documentId:uploadedFilesIds){
                for(Id ownerId: accOwnerIds){
                    Map<String,String> flowMap = new Map<String, String>();
                    flowMap.put('ownerId',ownerId);
                    flowMap.put('recordId',RecordID);
                    flowMap.put('documentId',documentId);
                    flowMap.put('CareTeamName',selectedName);
                   flowMap.put('loggedinuser',loggedinuser);
                    flowMap.put('memberEmail',memberEmail);
                    flowMap.put('TargetReferobjectName',TargetReferobjectName);
                    flowMap.put('providerAffiname',' ');
					system.debug('#183 '+accountId);                    
                  SNI_FL_Notification_Center.SendNotification(accountId);
                    
                  // SNI_FLDirectMessageUtil.sendEmailOrSMSNotifications(accountIdOfUser);
                    
                 /* Flow.Interview.Send_email_to_Community_Users myFlow = new Flow.Interview.Send_email_to_Community_Users(flowMap);
                 myFlow.start(); */
                    
                    //Getting Output parameters from the flow
                   //String localOutputParameter = (String)myFlow .getVariableValue('outputParameter');
            	}
            } 
            //Code end Ankit
        }catch(Exception e){
            AcetUtility.CreateAndRedirectToError('FamilyLink','SNI_FL_RecordsController',e);
        }   
        return docwrap;  
    }
}