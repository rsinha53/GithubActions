/****************************************************************************** 
Class Name     : SNI_FL_CaseManagementController.apxc
Description    : 
Created By     : Sameera De Silva - ACDC
Created Date   : 11/5/2020
******************************************************************************/


//Performs business logic related to case
//Author:Sameera De Silva ACDC
public with sharing class SNI_FL_CaseManagementController {

    private static final String accessType='READABLE';
    private static final String teamName = 'ACDC Error';
    private static final String lineNumber = 'Line Number';
    private static final String methodName = 'MethodName';
    

    //Retrieve list of cases that are belongs to familylink user and ROI singed user cases for 
    //familylink user
    //Author:Sameera De Silva ACDC
    public static List<SNI_FL_CaseManagementController.CaseObjectWrapper> getCasesWithROISignedCases(String familyLinkUserID,String familyAccountID){

        try{
            List<ID> lstContactID = new List<ID>();
            Map<ID,Case> openAndcloseCases = new Map<ID,Case>();
            List<SNI_FL_CaseManagementController.CaseObjectWrapper> lstCaseObjects = new List<SNI_FL_CaseManagementController.CaseObjectWrapper>();
            List<SNI_FL_CaseManagementController.CaseCommentWrapper> lstCaseComments;
            SNI_FL_CaseManagementController.CaseCommentWrapper caseComment;
            SNI_FL_CaseManagementController.CaseObjectWrapper caseObject;
            
            User userRecord = getPersonAccountIDForFamilyLinkUser(familyLinkUserID);//Get user record for logged in user
            List<SNI_FL_Members_ROI__c> lstMemberROIrecords = SNI_FL_CaseManagementROIController.getActiveROIRecords(userRecord,familyAccountID);//Retrives ROI records for matching careteam record based on personAccountID and familyID
            System.debug('****lstMemberROIrecords---'+lstMemberROIrecords);                
            //setup a list of contactIDs to match cases
            lstContactID.add(userRecord.ContactId);
            for(SNI_FL_Members_ROI__c memberROI:lstMemberROIrecords){
                lstContactID.add(memberROI.SNI_FL_Account__r.PersonContactId);
            }
            
            //Merge open and close cases to a sing map
            Map<Id,Case> closedCasesWithComments = getClosedCaseDetails(lstContactID);
            Map<Id,Case> openCasesWithComments = getOpenCaseDetails(lstContactID);
            openAndcloseCases.putAll(openCasesWithComments);
            openAndcloseCases.putAll(closedCasesWithComments);

            Map<Id,List<ContentDistribution>> caseAttachments = getCaseAttachments(openAndcloseCases);//Retrieve case attachments
            Map<Id,List<SNI_FL_CaseManagementController.CaseAttachmentWrapper>> attachmentWrapperList = getCaseAttachmentWrapper(caseAttachments);//Retrieve case attachment wrapper object list
            System.debug('***openAndcloseCases---'+openAndcloseCases);
            for(Case caseRecord:openAndcloseCases.values()){
                
                lstCaseComments = new  List<SNI_FL_CaseManagementController.CaseCommentWrapper>();
              
                for(CaseComment caseCommentRecord:caseRecord.CaseComments)
                {
                    caseComment = new SNI_FL_CaseManagementController.CaseCommentWrapper();
                     
                    caseComment.caseID = caseRecord.id;
                    caseComment.caseComment = caseCommentRecord.CommentBody;
                    caseComment.caseCommentedDateTime = caseCommentRecord.CreatedDate;
                    caseComment.caseCommentedUserId = caseCommentRecord.CreatedById;
                    caseComment.caseCommentedUserName = caseCommentRecord.CreatedBy.Name;
                    // Added by Bilinkers Team for DE409891
                    if(caseComment.caseCommentedUserName != null || caseComment.caseCommentedUserName ==''){
                        String fName = caseComment.caseCommentedUserName;
                        String lName = fName.Substring(fName.indexOf(' '),fName.length());
                        String flName = lName.Substring(0,2);
                        fName = fName.Substring(0,fName.indexOf(' '));
                        caseComment.caseCommentedUserName = fName +' '+flName;
                    }
                    // End
                    
                    lstCaseComments.add(caseComment);
                }

                caseObject = new SNI_FL_CaseManagementController.CaseObjectWrapper();
                caseObject.caseID = caseRecord.id;
                caseObject.caseNumber = caseRecord.isSet(Case.CaseNumber)?caseRecord.CaseNumber:null;
                //caseObject.caseNumber = isSetStringField(caseRecord,'Case_Name__c');
                caseObject.caseName = caseRecord.isSet(Case.Case_Name__c)?caseRecord.Case_Name__c:null;
                caseObject.caseType = caseRecord.isSet(Case.Case_Type__c) && caseRecord.Case_Type__c=='Opportunity'?'SENS Case':null;
                caseObject.caseStatus = caseRecord.isSet(Case.Status)?caseRecord.Status:null;
                caseObject.caseAssignToUserName = caseRecord.isSet(Case.OwnerId)?caseRecord.Owner.Name:null;
                // Added by Bilinkers Team for US3116919
                if(caseObject.caseAssignToUserName != null || caseObject.caseAssignToUserName ==''){
                    String fName = caseObject.caseAssignToUserName;
                    String lName = '';
                    String flName = '';
                    if(fName.containsWhitespace()){
                        lName = fName.Substring(fName.indexOf(' '),fName.length());
                    	flName = lName.Substring(0,2);
                    	fName = fName.Substring(0,fName.indexOf(' '));
                	}
                    if(flName != '')
                    	caseObject.caseAssignToUserName = fName +' '+flName;
               		else
                        caseObject.caseAssignToUserName = fName;
                }
                // End
                caseObject.caseAssignToUserID = caseRecord.isSet(Case.OwnerId)?caseRecord.OwnerId:null;
                caseObject.caseAboutUser = caseRecord.isSet(Case.ContactId)?caseRecord.Contact.Name:null;
                caseObject.caseAboutUserID = caseRecord.isSet(Case.ContactId)?caseRecord.ContactId:null; 
                caseObject.caseCreatedDateTime = caseRecord.isSet(Case.CreatedDate)?caseRecord.CreatedDate:null;
                caseObject.caseClosedDateTime = caseRecord.isSet(Case.ClosedDate)?caseRecord.ClosedDate:null;
                caseObject.caseComments = lstCaseComments;  
                caseObject.caseAttachments = attachmentWrapperList.get(caseRecord.id);

                lstCaseObjects.add(caseObject);

            }
            System.debug('****lstCaseObjects---'+lstCaseObjects);

            return lstCaseObjects;
            

        }catch(Exception ex){
            System.debug(teamName+' '+ex.getMessage()+' '+lineNumber+' '+ex.getLineNumber()+' '+methodName+' :getCasesWithROISignedCases');
            return null;
        }
        
        
    }

/*
    //Check whether string field is set afer stripping inaccesibles
    //Author:Sameera De Silva ACDC
    public static String isSetStringField(Case caseRecord,String fieldApiName){
        
        String value = caseRecord+'.'+fieldApiName;
        if(caseRecord.isSet(caseRecord+'.'+fieldApiName)){
            return value;
        }else{
            return null;
        }
        
    }
*/
    //Get user record for logged in user
    //Author:Sameera De Silva ACDC
    public static User getPersonAccountIDForFamilyLinkUser(String id){

        try{
            return (User)enforceApexSecurity([SELECT Id, AccountId, ContactId FROM User WHERE Id=:id],accessType)[0];
        }catch(Exception ex){
            System.debug(teamName+' '+ex.getMessage()+' '+lineNumber+' '+ex.getLineNumber()+' '+methodName+' :getClosedCaseDetails');
            return null;
        }
        
    }


    //Retrives top 10 closed cases 
    //Author: Sameera De Silva ACDC
    public static Map<ID,Case> getClosedCaseDetails(List<ID> lstContactIDs){
        try{
            ID caseCloseRecordType = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('Case_Close').getRecordTypeId();
            Map<Id,Case> cases = new Map<Id,Case>((List<Case>)enforceApexSecurity([SELECT id, Case_Type__c,CaseNumber, Case_Name__c,Status,OwnerId,Owner.Name,ContactId,Contact.Name,ClosedDate,CreatedDate,(SELECT CommentBody,CreatedBy.Name,CreatedById,CreatedDate  FROM CaseComments WHERE IsPublished=true ORDER BY CreatedDate DESC) FROM Case WHERE ContactId IN :lstContactIDs AND RecordTypeId =:caseCloseRecordType  AND Community__c = true AND Case_Type__c='Opportunity' AND Status='Closed' ORDER BY ClosedDate DESC LIMIT  10],accessType));

            return cases;
        }catch(Exception ex){
            System.debug(teamName+' '+ex.getMessage()+' '+lineNumber+' '+ex.getLineNumber()+' '+methodName+' :getClosedCaseDetails');
            return null;
        }
        
        
    }

    //Retrieve wrapper obejcts for case attachments
    //Author:Sameera De Silva ACDC
    public static Map<Id,List<SNI_FL_CaseManagementController.CaseAttachmentWrapper>> getCaseAttachmentWrapper(Map<Id,List<ContentDistribution>> caseAttachments){
        try{
            SNI_FL_CaseManagementController.CaseAttachmentWrapper caseAttachment;
            List<SNI_FL_CaseManagementController.CaseAttachmentWrapper> lstcaseAttachment;
            Map<Id,List<SNI_FL_CaseManagementController.CaseAttachmentWrapper>> caseAttachmentWrapper = new Map<Id,List<SNI_FL_CaseManagementController.CaseAttachmentWrapper>>();

            for(Id caseID:caseAttachments.keySet()){

                    lstcaseAttachment = new List<SNI_FL_CaseManagementController.CaseAttachmentWrapper>();

                    if(caseAttachments.get(caseID) != NULL)
                    {
                        for(ContentDistribution cdRecords:caseAttachments.get(caseID)){
    
                            caseAttachment = new SNI_FL_CaseManagementController.CaseAttachmentWrapper();
                            caseAttachment.caseAttachmentDownloadURl = cdRecords.isSet(ContentDistribution.ContentDownloadUrl)?cdRecords.ContentDownloadUrl:null;
                            caseAttachment.caseAttachmentName = cdRecords.isSet(ContentDistribution.Name)?cdRecords.Name:null;
                            caseAttachment.caseId = caseID;
                            caseAttachment.caseAttachmentDateTime = cdRecords.isSet(ContentDistribution.CreatedDate)?cdRecords.CreatedDate:null;
                            
                            lstcaseAttachment.add(caseAttachment);
                        }
                        caseAttachmentWrapper.put(caseID,lstcaseAttachment);
                    }
                
            }

            return caseAttachmentWrapper;
        }catch(Exception ex){
            System.debug(teamName+' '+ex.getMessage()+' '+lineNumber+' '+ex.getLineNumber()+' '+methodName+' :getCaseAttachmentWrapper');
            return null;  
        }
    }

    //Retrieves case attachments which a visible to all users
    //Author: Sameera De Silva ACDC
    public static Map<Id,List<ContentDistribution>> getCaseAttachments(Map<ID,Case> cases){
            
        try{

            Map<Id,Id> lstContentDocumentIDs = new Map<Id,Id>();
            Map<Id,List<ContentDistribution>> contentDistributionRecords = new Map<Id,List<ContentDistribution>>();

            List<ContentDocumentLink> lstContentDocumentlinks = (List<ContentDocumentLink>)enforceApexSecurity([SELECT ContentDocumentId,LinkedEntityId,Visibility FROM ContentDocumentLink WHERE LinkedEntityId IN:cases.keyset() AND Visibility='AllUsers'],accessType);
            for(ContentDocumentLink cdlrecord:lstContentDocumentlinks){
                lstContentDocumentIDs.put(cdlrecord.ContentDocumentId,cdlrecord.LinkedEntityId);
            }
            
            list<ContentDistribution> lstContentDistributionRecords = (List<ContentDistribution>)enforceApexSecurity([SELECT Id,ContentDocumentId,ContentDownloadUrl,DistributionPublicUrl,Name,CreatedDate FROM ContentDistribution where ContentDocumentId IN :lstContentDocumentIDs.keyset() ORDER BY CreatedDate DESC],accessType);
            for(ContentDistribution cdRecord:lstContentDistributionRecords){
                Id linkedEntityID = lstContentDocumentIDs.get(cdRecord.ContentDocumentId);
                if((linkedEntityID != null) && (contentDistributionRecords.containsKey(linkedEntityID))){
                    List<ContentDistribution> lstDistribution = contentDistributionRecords.get(linkedEntityID);
                    lstDistribution.add(cdRecord);
                    contentDistributionRecords.put(linkedEntityID,lstDistribution);
                }else if((linkedEntityID != null) && (!contentDistributionRecords.containsKey(linkedEntityID))){
                    List<ContentDistribution> lstCDRecords = new List<ContentDistribution>();
                    lstCDRecords.add(cdRecord);
                    contentDistributionRecords.put(linkedEntityID,lstCDRecords);
                }
            }

            return contentDistributionRecords;

        }catch(Exception ex){
            System.debug(teamName+' '+ex.getMessage()+' '+lineNumber+' '+ex.getLineNumber()+' '+methodName+' :getCaseAttachments');
            return null;
        }
    }

    //Retrives open cases 
    //Author: Sameera De Silva ACDC
    public static Map<ID,Case> getOpenCaseDetails(List<ID> lstContactIDs){
        
        try{
            ID ecmRecordType = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('ECM').getRecordTypeId();
            Map<Id,Case> cases = new Map<Id,Case>((List<Case>)enforceApexSecurity([SELECT id, Case_Type__c,CaseNumber, Case_Name__c,Status,OwnerId,Owner.Name,ContactId,Contact.Name,ClosedDate,CreatedDate,(SELECT CommentBody,CreatedBy.Name,CreatedById,CreatedDate  FROM CaseComments WHERE IsPublished=true ORDER BY CreatedDate DESC) FROM Case WHERE ContactId IN :lstContactIDs AND RecordTypeId =:ecmRecordType  AND Community__c = true AND Case_Type__c='Opportunity' AND Status !='Closed' ORDER BY CreatedDate   DESC],accessType));
        
            return cases;
        }catch(Exception ex){
            System.debug(teamName+' '+ex.getMessage()+' '+lineNumber+' '+ex.getLineNumber()+' '+methodName+' :getOpenCaseDetails');
            return null;
        }
        
    }
    
    
    //Check field level and object level permissions for apex becuase apex runs in system context and 
    //not considering Object and FLS.
    //Author:Sameera De Silva ACDC
    public static List<sObject> enforceApexSecurity(List<sObject> lstrecords,String accessType){
        try{

            if(accessType == 'READABLE'){
                SObjectAccessDecision decision = Security.stripInaccessible(System.AccessType.READABLE,lstrecords,true);
                return decision.getRecords();
            }
            return null;
        }catch(Exception ex){
            System.debug(teamName+' '+ex.getMessage()+' '+lineNumber+' '+ex.getLineNumber()+' sObject Recieved '+lstrecords.getSObjectType()+' '+methodName+' :enforceApexSecurity');
            return null;
        }
    }



    //Wrapper to store case related details
    //Author:Sameera De Silva ACDC
    public class CaseObjectWrapper{

        @AuraEnabled public String caseID{get;set;}
        @AuraEnabled public String caseNumber{get;set;}
        @AuraEnabled public String caseName{get;set;}
        @AuraEnabled public String caseType{get;set;}
        @AuraEnabled public String caseStatus{get;set;}
        @AuraEnabled public String caseAssignToUserName{get;set;}
        @AuraEnabled public String caseAssignToUserID{get;set;}
        @AuraEnabled public String caseAboutUser{get;set;}
        @AuraEnabled public String caseAboutUserID{get;set;}
        @AuraEnabled public DateTime caseCreatedDateTime{get;set;}
        @AuraEnabled public DateTime caseClosedDateTime{get;set;}
        @AuraEnabled public List<CaseCommentWrapper> caseComments{get;set;}
        @AuraEnabled public List<CaseAttachmentWrapper> caseAttachments{get;set;}
        
    }

    //Wrapper to store case attachment related details
    //Author:Sameera De Silva ACDC
    public class CaseAttachmentWrapper{

        @AuraEnabled public String caseAttachmentDownloadURl{get;set;}
        @AuraEnabled public String caseAttachmentName{get;set;}
        @AuraEnabled public String caseId{get;set;}
        @AuraEnabled public DateTime caseAttachmentDateTime{get;set;}
    }

    //Wrapper to store case comment related details
    //Author:Sameera De Silva ACDC
    public class CaseCommentWrapper{

        @AuraEnabled public String caseID{get;set;}
        @AuraEnabled public String caseComment{get;set;}
        @AuraEnabled public DateTime caseCommentedDateTime{get;set;}
        @AuraEnabled public String caseCommentedUserId{get;set;}
        @AuraEnabled public String caseCommentedUserName{get;set;}

    }

}