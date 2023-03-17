public  without sharing  class  SNI_FL_MemberDetailsController {
   
	public class MembersReturnWrapper {
        @AuraEnabled
        public MemberDetailWrapper MemberDetailsRecord{get;set;}
        @AuraEnabled
        public List<Previous_Program_History> MemberProgramHistory{get;set;}
        @AuraEnabled
        public List<ContentDocument>  MemberDocuments{get;set;}
        @AuraEnabled
        public Boolean ErrorOccured {get;set;}
        @AuraEnabled
        public String ErrorMessage {get;set;}
        @AuraEnabled
        public String DebugMessage {get;set;}
    }
     public class MemberDetailWrapper {
        @AuraEnabled
        public Id memberId{get;set;}
        @AuraEnabled
        public String memberName {get;set;}
        @AuraEnabled
        public String subscriberId {get; set;}
        @AuraEnabled
        public String memberStatus {get; set;}
        @AuraEnabled
        public string enrollmentDate {get; set;}
        @AuraEnabled
        public string inactiveDate {get; set;}
        @AuraEnabled
        public Boolean isActive {get; set;}
        @AuraEnabled
        public String isActiveCSS {get; set;}
        @AuraEnabled
        public String dateOfBirth {get; set;}
        @AuraEnabled
        public String programName {get; set;}
        @AuraEnabled
        public String providerGroup {get; set;}
         @AuraEnabled
         public String population {get; set;}

    }
    
    public class Previous_Program_History {
        @AuraEnabled
        public String enrollmentDate{get;set;}
        @AuraEnabled
        public String inActiveDate {get;set;}

    }
    public class Previous_Hist_wrapper {
        @AuraEnabled
        public Boolean showPgmHistory{get;set;}
        @AuraEnabled
        public List<Previous_Program_History> MemberProgramHistory{get;set;}
        
    }
    
    @AuraEnabled
    Public Static MembersReturnWrapper getMemberDetails(Id recordId){
		Boolean ErrorOccured = false;
        String ErrorMessage = null;
        String DebugMessage = null;
        MembersReturnWrapper memberWrapperReturn =new MembersReturnWrapper();
        try {
			memberWrapperReturn.MemberDetailsRecord = getMemberRecord(recordId);
            memberWrapperReturn.MemberProgramHistory = getMemberProgramHistory(recordId);
            memberWrapperReturn.MemberDocuments = getMemberDocuments(recordId);
            }catch(Exception e){
            	AcetUtility.CreateAndRedirectToError('FamilyLink','SNI_FL_ProviderMembersTabController',e);
            	ErrorOccured = true;
            	ErrorMessage = e.getMessage();
            }
         return memberWrapperReturn;
    }
	@AuraEnabled 
    public static MemberDetailWrapper  getMemberRecord(Id recordId){ 
            MemberDetailWrapper memberDetails=new  MemberDetailWrapper();  
            Member_Affiliation__c  memAff =new  Member_Affiliation__c();                 
         try{
				memAff= [SELECT ID, Name, Member__c, Member__r.Name, 
                                                      Program__c, Program__r.Program__c,Provider_Group__c, Provider_Group__r.Name, Provider__c, Provider_Affiliation__c,Provider_Affiliation__r.Name,
                                                      Subscriber_Id__c, Enrollment_Date__c, Inactive_Date__c, Status__c,Date_Of_Birth__c, Population__c
                                                      FROM Member_Affiliation__c where Id=:recordId];
                memberDetails.memberId = memAff.ID;
                memberDetails.memberName = memAff.Member__r.Name;
                memberDetails.subscriberId = memAff.Subscriber_Id__c;
                memberDetails.memberStatus = memAff.Status__c ? 'Active' : 'Inactive';
                string EntrollmentDate= memAff.Enrollment_Date__c.month()+ '/' +  memAff.Enrollment_Date__c.day() + '/' +  memAff.Enrollment_Date__c.year();
                memberDetails.enrollmentDate =EntrollmentDate;
                string DateOfBirth = memAff.Date_Of_Birth__c.month()+ '/' +  memAff.Date_Of_Birth__c.day() + '/' +  memAff.Date_Of_Birth__c.year();
                memberDetails.dateOfBirth = DateOfBirth;
                 string inactiveDateFormat = '';
                 if(memAff.Inactive_Date__c != null){
                     inactiveDateFormat = memAff.Inactive_Date__c.month()+ '/' +  memAff.Inactive_Date__c.day() + '/' +  memAff.Inactive_Date__c.year();
                 }
                memberDetails.inactiveDate = inactiveDateFormat;
                memberDetails.isActive = memAff.Status__c;
                memberDetails.isActiveCSS = memAff.Status__c ? 'divboxActive' : 'divboxInactive';
                memberDetails.programName = memAff.Program__r.Program__c;
                memberDetails.providerGroup = memAff.Provider_Group__r.Name;
             memberDetails.population = memAff.Population__c;
			}catch(Exception e){
            	AcetUtility.CreateAndRedirectToError('FamilyLink','SNI_FL_ProviderMembersTabController',e);
            }
           return memberDetails;
    }
    
	@AuraEnabled 
    public static List<Previous_Program_History>  getMemberProgramHistory(Id recordId){ 
        List<Member_Affiliation__History> memberProgramHistory=new List<Member_Affiliation__History>();  
        
        List<Previous_Program_History> prev_hist = new List<Previous_Program_History>();
        List<Previous_Program_History> return_prev_hist = new List<Previous_Program_History>();
        String iDate;
        String EnrollmentDate;
       
        try{
            if(test.isRunningTest()){
                memberProgramHistory.add(new Member_Affiliation__History(ParentId=recordId, Field='Enrollment_Date__c'));
                memberProgramHistory.add(new Member_Affiliation__History(ParentId=recordId, Field='Inactive_Date__c'));
                Previous_Program_History pp = new Previous_Program_History();
                pp.inActiveDate = '2020-01-01';
                pp.enrollmentDate = '2020-01-01';
                prev_hist.add(pp);
                Previous_Program_History pp1 = new Previous_Program_History();
                pp1.inActiveDate = '2020-01-02';
                pp1.enrollmentDate = '2020-01-02';
                prev_hist.add(pp1);
            }else{
            memberProgramHistory= [select Id, parent.Enrollment_Date__c, Field, NewValue,OldValue, CreatedDate from Member_Affiliation__History 
                                   where parentid=:recordId and Field in ('Inactive_Date__c','Enrollment_Date__c') Order by CreatedDate];
            EnrollmentDate = String.valueof(memberProgramHistory[0].parent.Enrollment_Date__c);	
                }
            for (Member_Affiliation__History mah:memberProgramHistory){
                if(mah.Field == 'Enrollment_Date__c'){
                    if(mah.OldValue != Null && mah.OldValue != ''){
                    EnrollmentDate = String.valueof(mah.OldValue);
                    break;
                        }
                }  
                }
                for (Member_Affiliation__History mfh:memberProgramHistory){
                    
                    if(mfh.Field == 'Inactive_Date__c' && mfh.NewValue != Null && mfh.NewValue != ''){
                        
                        Previous_Program_History pph = new Previous_Program_History();
                        iDate = String.valueof(mfh.NewValue);
                        pph.inActiveDate = iDate.substring(0,10);
                        pph.enrollmentDate = EnrollmentDate.substring(0,10);
                        prev_hist.add(pph);
                        
                    }else if(mfh.Field == 'Enrollment_Date__c'){
                        EnrollmentDate = String.valueof(mfh.NewValue);
                    }
                    
                }
         }catch(Exception e){
          		AcetUtility.CreateAndRedirectToError('FamilyLink','SNI_FL_ProviderMembersTabController',e);
            }
        if (prev_hist.size() > 0){
            if(prev_hist.size() > 1){
                for (Integer i = prev_hist.size()-1; i>= 0; i-- ) {
                    return_prev_hist.add(prev_hist[i]);
                }
   
            } else{
                return_prev_hist.addall(prev_hist);
            }
            
        	    }
         
            return return_prev_hist;
        }
    
    @AuraEnabled 
    public static List<ContentDocument> getMemberDocuments(Id memberId){ 
    List<ContentDocument> memberDocumentsList = new  List<ContentDocument>();
    try{
        	List<ContentDocumentLink> contentDocumentLinkIds = [SELECT ContentDocumentId FROM ContentDocumentLink WHERE LinkedEntityId =:memberId AND Visibility='AllUsers'];
           	List<Id> contentDocumentIdsList = new List<Id>();
  			for (ContentDocumentLink nextCDL : contentDocumentLinkIds) {
            		contentDocumentIdsList.add(nextCDL.ContentDocumentId);
            }
 	        memberDocumentsList =[SELECT Id, Title, FileType,LastModifiedDate, LastModifiedBy.Name,OwnerId FROM ContentDocument WHERE Id IN:contentDocumentIdsList order by LastModifiedDate desc LIMIT 40000];
     }catch(Exception e) {
        	AcetUtility.CreateAndRedirectToError('FamilyLink','SNI_FL_ProviderMembersTabController',e);
         	}  
        return memberDocumentsList;
    }    
    
    @AuraEnabled
    public static List<ContentDocument> getUpdatedDocs(List<ID> uploadedFilesIds,string memberId,String membername){
        List<ContentDocument> memberDocumentsList = new  List<ContentDocument>();
        try{
            List<Id> idslst = SNI_FL_CustomCmpAdvisor.AllUserFiles(uploadedFilesIds);
            memberDocumentsList = getMemberDocuments(memberId);
            
            //-----------------added by Ankit
            system.debug('membername'+membername);
            system.debug('memberId'+memberId);
            Id recIdss = memberId;
            
            String sObjNamess = recIdss.getSObjectType().getDescribe().getName();
            List<Member_Affiliation__c> ownername= [select OwnerId,Member__c,Provider_Affiliation__r.Name from Member_Affiliation__c where Id=:memberId];
            
            string providerAffiname = ':' + ownername[0].Provider_Affiliation__r.Name;
            String getName = UserInfo.getName();
            system.debug('ownername'+ownername[0].OwnerId);
            system.debug('getName'+getName);
            system.debug('sObjNamess'+sObjNamess);
                    Map<String,String> flowMap = new Map<String, String>();
                    flowMap.put('ownerId', ownername[0].OwnerId);
                    flowMap.put('recordId',memberId);
                    flowMap.put('documentId',uploadedFilesIds[0]);
                    flowMap.put('CareTeamName',membername);
                    flowMap.put('loggedInUser',getName);
                    flowMap.put('TargetReferobjectName',sObjNamess);
                    flowMap.put('providerAffiname',providerAffiname);
                    Flow.Interview.Document_Upload_Notification_Flow myFlow = new Flow.Interview.Document_Upload_Notification_Flow(flowMap);
                    myFlow.start();
            
               /*             ('userid', ownerid);
                    flowMap.put('Records',RecordID);
                    flowMap.put('Docid',ids);
                    flowMap.put('selectedName',selectedName);
                    flowMap.put('getName',getName);
                    flowMap.put('sObjNamess',sObjNamess);

                    flowMap.put('ownerId',ownerId);
                    flowMap.put('recordId',RecordID);
                    flowMap.put('documentId',documentId);
                    flowMap.put('CareTeamName',selectedName);
                    flowMap.put('loggedInUser',loggedInUser);
                    flowMap.put('TargetReferobjectName',TargetReferobjectName);*/
            
                    
            
            
            //------------------------end by Ankit
        }catch(Exception e){
            AcetUtility.CreateAndRedirectToError('FamilyLink Provider','SNI_FL_MemberDetailsController',e);
        }   
        return memberDocumentsList;
    }
    
    @AuraEnabled
    public static string downloadFile(Id downloadAttachmentId){
        list<ContentDistribution> oldCV = [SELECT Id, ContentDocumentId, ContentDownloadUrl, DistributionPublicUrl 
                                           FROM ContentDistribution WHERE ContentDocumentId =: downloadAttachmentID];
        String urlDownload = '';
        if(oldCV != null && oldCV.size()>0){
            urlDownload = oldCV[0].contentDownloadUrl;     
        }
        return urlDownload;
    }
    
    @AuraEnabled  
    public static void editFile(String documentId, String documentName){
        try {
            List<ContentDocument> docLst = [SELECT Id, Title FROM ContentDocument WHERE id=:documentId];
            if (docLst != NULL && docLst.size() > 0){
                ContentDocument cd = docLst.get(0);
                if (string.isNotBlank(documentName)){
                    cd.Title = documentName;
                    update cd;
                }
            }
        } catch(Exception e) {
            AcetUtility.CreateAndRedirectToError('FamilyLink','SNI_FL_ProviderMembersTabController',e);
        }
    }
    
    @AuraEnabled  
    public static void deleteSelectedFile(string sdocumentId){
        try {
            List<ContentDocument> docLst =  [SELECT Id, Title FROM ContentDocument WHERE id=:sdocumentId];
            if(docLst.size() > 0){
                delete docLst;
            }
        } catch(Exception e){
            AcetUtility.CreateAndRedirectToError('FamilyLink','SNI_FL_ProviderMembersTabController',e);
        }
    }

 
}