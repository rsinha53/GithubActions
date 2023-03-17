public without sharing class SNI_FL_DocumentsController {
 public class familyDocumentWrapper{
     @AuraEnabled
     public List<contentDocWrapper> familyDocuments{get;set;}
     @AuraEnabled
     public List<membDocumentWrapper> membDocwrapper{get;set;}
 }
 public class membDocumentWrapper {
        @AuraEnabled
        public String membId {get;set;}
        @AuraEnabled
        public String membName{get;set;}
        @AuraEnabled
        public List<contentDocWrapper> membDocuments{get;set;}
    }
  public class contentDocWrapper implements Comparable {
     @AuraEnabled
     public ContentDocument contdoc;
     public contentDocWrapper(ContentDocument cd) {
         contdoc = cd;
     }
     public Integer compareTo(Object compareTo) {
        contentDocWrapper ctw = (contentDocWrapper) compareTo;
        if (contdoc.LastModifiedDate < ctw.contdoc.LastModifiedDate) return +1;
        if (contdoc.LastModifiedDate > ctw.contdoc.LastModifiedDate) return -1;
        return 0;
    }
  }
    @AuraEnabled
    public static familyDocumentWrapper getdocuments(String familyaccId){
        
        Id familyAccRecTypId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Family').getRecordTypeId();
        familyDocumentWrapper docwrap = new familyDocumentWrapper();
        List<membDocumentWrapper> doclst = new List<membDocumentWrapper>();
        set<Id> persnAccIds = new set<Id>();
        Map<string,string> membNameMap = new Map<string,string>();
        Set<Id> authorizedIds = new  Set<Id>();
        try{
            Id currentUser = UserInfo.getUserId();
            List<user> uslist = [SELECT contactId,contact.accountid,isactive
                                 FROM User
                                 WHERE Id =:currentUser AND isactive = true AND contactId!=NULL LIMIT 1];
            
            //To get all the members who has authorized for their info to be shared with the requester
            List<SNI_FL_Members_ROI__c> authorizedMembersLst = [SELECT SNI_FL_Account__c,SNI_FL_ROI_Signed_With__r.SNI_FL_Member__c 
                                                                FROM SNI_FL_Members_ROI__c
                                                                WHERE SNI_FL_ROI_Signed_With__r.SNI_FL_Member__c =: uslist[0].contact.accountid AND SNI_FL_Status__c = 'Active'];
            for(SNI_FL_Members_ROI__c roi : authorizedMembersLst){
                persnAccIds.add(roi.SNI_FL_Account__c );    
            }
            persnAccIds.add(uslist[0].contact.accountid);
            system.debug('persnAccIds--'+persnAccIds);
            
            //Cherry - commenting the below code because it queries all the preson account of the family, we want to query only the ones who has authorized.
            /*if(string.isNotBlank(familyaccId)){
                for(AccountContactRelation acc:[Select ContactId,AccountId,contact.AccountId,contact.Account.Name,Account.RecordTypeId from AccountContactRelation where AccountId=:familyaccId AND Account.RecordTypeId=:familyAccRecTypId]){
                    persnAccIds.add(acc.contact.AccountId);
                }
            }*/
            
            if(persnAccIds!=Null && persnAccIds.size()>0){
                for(Member_Information__c membInfo: [select Id,Account__c,Name from Member_Information__c where Account__c IN:persnAccIds]){
                    membNameMap.put(membInfo.Id,membInfo.Name);
                }
            }
            List<contentDocWrapper> alldocs = new List<contentDocWrapper>();
            List<contentDocWrapper> cndlst = getFamilyDocs(familyaccId);
            List<membDocumentWrapper> cdlst = new List<membDocumentWrapper>();
            if(cndlst!=Null && cndlst.size()>0){
                alldocs.addAll(cndlst);
                Family_Overview__c fmovrec = [select Id,Account__c,Account__r.Name from Family_Overview__c where Account__c=:familyaccId limit 1];
                if(fmovrec!=Null){
                    membDocumentWrapper memb = new membDocumentWrapper();
                    memb.membId = fmovrec.Id;
                    memb.membName = fmovrec.Account__r.Name+' '+'Family';
                    memb.membDocuments = cndlst;
                    doclst.add(memb);
                }
                
            }
            if(membNameMap!=Null && membNameMap.size()>0){
                cdlst=  SNI_FL_DocumentsController.getMemberDocs(membNameMap);
                if(cdlst!=Null && cdlst.size()>0){
                    doclst.addAll(cdlst);
                }
            }
            
            if(cdlst!=Null && cdlst.size()>0){
                for(membDocumentWrapper wrp:cdlst){
                    alldocs.addAll(wrp.membDocuments);
                }
            }
            
            if(alldocs.size()>0){
                alldocs.sort();
                docwrap.familyDocuments = alldocs;
            }
            if(doclst.size()>0){
                docwrap.membDocwrapper=doclst;
            }
            
            
        }catch(Exception e){
            AcetUtility.CreateAndRedirectToError('FamilyLink','SNI_FL_DocumentsController',e);
        }
        return docwrap;
    }

   @AuraEnabled
    public static List<membDocumentWrapper> getMemberDocs(Map<string,string>  mapval){
        Map<string,string> mapmembIds = mapval;
        List<membDocumentWrapper> membdoclst = new List<membDocumentWrapper>();
        if(mapmembIds!=Null && mapmembIds.size()>0){

            Map<Id,List<Id>> mapcdlinks = new Map<Id,List<Id>>();
            Map<Id,ContentDocument> mapdocs = new Map<Id,ContentDocument>();
            Set<Id> cdIds = new Set<Id>();
            for(ContentDocumentLink cdLink : [SELECT ContentDocumentId,LinkedEntityId,Visibility FROM ContentDocumentLink WHERE LinkedEntityId IN :mapmembIds.keyset() AND Visibility='AllUsers']){
                cdIds.add(cdLink.ContentDocumentId);
                if(mapcdlinks.containsKey(cdLink.LinkedEntityId)){
                    List<Id> ctmlst = mapcdlinks.get(cdLink.LinkedEntityId);
                    ctmlst.add(cdLink.ContentDocumentId);
                    mapcdlinks.put(cdLink.LinkedEntityId, ctmlst);
                }else{
                    mapcdlinks.put(cdLink.LinkedEntityId,new List<Id>{cdLink.ContentDocumentId});
                }
            }

            for(ContentDocument contdoc: [SELECT Id, Title, FileType,LastModifiedDate,OwnerId FROM ContentDocument WHERE Id IN :cdIds order by LastModifiedDate desc LIMIT 40000]){
                    mapdocs.put(contdoc.Id,contdoc);
            }

            if(mapcdlinks!=Null && mapcdlinks.size()>0){
                for(String membrecid: mapcdlinks.keyset()){
                    List<string> doclst=mapcdlinks.get(membrecid);
                    if(doclst!=Null && doclst.size()>0){
                        membDocumentWrapper membdoc = new membDocumentWrapper();
                        membdoc.membId=membrecid;
                        membdoc.membName=mapmembIds.get(membrecid);
                        List<contentDocWrapper> contdoclst = new List<contentDocWrapper>();
                        for(String contdocId: doclst){
                            ContentDocument contdoc = mapdocs.get(contdocId);
                            contdoclst.add(new contentDocWrapper(contdoc));
                        }
                        contdoclst.sort();
                        membdoc.membDocuments=contdoclst;
                        membdoclst.add(membdoc);
                    }
                }
            }
        }
        return membdoclst;
    }

    @AuraEnabled
    public static List<contentDocWrapper> getFamilyDocs(Id  familyAccId){
        List<contentDocWrapper> familydocs = new List<contentDocWrapper>();
        set<Id> cdIds = new set<Id>();
        if(string.isNotBlank(familyAccId)){
            List<Family_Overview__c> fmoreclist = [select Id,Account__c from Family_Overview__c where Account__c=:familyAccId];
            List<Id> famoverId = new List<Id>();
            if(fmoreclist != null){
                for(Family_Overview__c famover : fmoreclist){
                    famoverId.add(famover.Id);
                }
                for(ContentDocumentLink cdLink : [SELECT ContentDocumentId,LinkedEntityId,Visibility FROM ContentDocumentLink WHERE LinkedEntityId IN : famoverId AND Visibility='AllUsers']){
                    cdIds.add(cdLink.ContentDocumentId);
                }
            }
        }
        if(cdIds!=Null && cdIds.size()>0){
            for(ContentDocument contdoc: [SELECT Id, Title, FileType,LastModifiedDate,OwnerId FROM ContentDocument WHERE Id IN:cdIds order by LastModifiedDate desc LIMIT 40000]){
                familydocs.add(new contentDocWrapper(contdoc));
            }
        }
        return familydocs;
    }
    @AuraEnabled
    public static string DownloadAttachment(Id DownloadAttachmentID){
       list<ContentDistribution> oldCV = [Select Id,ContentDocumentId,ContentDownloadUrl,DistributionPublicUrl from ContentDistribution where ContentDocumentId=:DownloadAttachmentID];
       String URlDownload = '';
       if(oldCV != null && oldCV.size()>0){
          URlDownload = oldCV[0].ContentDownloadUrl;
          system.debug('URlDownload' + oldCV[0].ContentDownloadUrl);
       }
    return URlDownload;
    }
    @AuraEnabled
    public static void deleteFiles(string sdocumentId){
        try{
        List<ContentDocument> docLst =  [SELECT Id,Title from ContentDocument WHERE id=:sdocumentId];
            if(docLst.size()>0){
                delete docLst;
            }
        }catch(Exception e){
        }
    }

    @AuraEnabled
    public static void editFile(string documentId,string documentName){
        try{
        List<ContentDocument> docLst =  [SELECT Id,Title from ContentDocument WHERE id=:documentId];
            if(docLst!=Null && docLst.size()>0){
                ContentDocument cd = docLst.get(0);
                if(string.isNotBlank(documentName)){
                    cd.Title=documentName;
                    update cd;
                }
            }
        }catch(Exception e){
            AcetUtility.CreateAndRedirectToError('FamilyLink','SNI_FL_DocumentsController',e);
        }
    }

}