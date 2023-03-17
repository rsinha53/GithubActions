//US2812235: This apex class return the fields of Family Contact Custom object associated with current Family
//Author Name : Derek DuChene (Team Eagles)
public without sharing class SNI_FL_RecordsController {
	@AuraEnabled
    public static contactWrapperReturn getContacts(String familyId){
        list<contactWrapper> lstcontactwrapper = new list<contactWrapper>();
        boolean ErrorOccured = false;
        string ErrorMessage = null;
        string DebugMessage = null;
        boolean isFLAccOwner =false;
        contactWrapperReturn objcontactWrapperReturn = new contactWrapperReturn();
                          
        try{
            Family_Overview__c[] familyOverView = [select Name,id from Family_Overview__c where Account__c =: familyId];
            List<Family_Contact__c> fcon= [select Id, Name, Email__c, Phone__c,Relationship__c, Address__c from Family_Contact__c where Status__c ='Active' and Family__c IN: familyOverView order by CreatedDate desc] ;
            

                 for(Family_Contact__c c : fcon) 
                 {
                 contactWrapper contact = new contactWrapper();
                    contact.contactID = c.Id;
                    contact.contactName = c.Name;
                    contact.contactEmail = c.Email__c;
                    contact.contactPhone = c.Phone__c;
                    contact.contactRelationship = c.Relationship__c;
                    contact.contactAddress = c.Address__c;
                    lstcontactwrapper.add(contact);
           

     }     
            objcontactWrapperReturn.lstcontactWrap = lstcontactwrapper;
            objcontactWrapperReturn.ErrorOccured = ErrorOccured;
            objcontactWrapperReturn.ErrorMessage = ErrorMessage;
            objcontactWrapperReturn.DebugMessage = DebugMessage;
        }
        catch(Exception e){
            AcetUtility.CreateAndRedirectToError('FamilyLink','SNI_FL_ContactController',e);
            ErrorOccured = true;
            ErrorMessage = e.getMessage();
        }

        return objcontactWrapperReturn;
    }
    
    @AuraEnabled
    public static contactWrapperReturn addContacts(String selContactName, String selContactEmail, String selContactPhone, String selContactAddress, String selContactRelationship, String familyId) {
    	contactWrapperReturn objcontactWrapperReturn = new contactWrapperReturn();
    	Family_Contact__c selContact = new Family_Contact__c();
    	boolean ErrorOccured = false;
        string ErrorMessage = null;
        try{
	    	if(familyId != null && familyId != ''){
	    		Family_Overview__c familyOverView = [select Name,id from Family_Overview__c where Account__c=:familyId];
	    		if(selContactName!=null && selContactName != '') {
	    			selContact.Name = selContactName;
	    			selContact.Phone__c = selContactPhone;
	    			selContact.Email__c = selContactEmail;
	    			selContact.Address__c = selContactAddress;
	    			selContact.Relationship__c = selContactRelationship;
		        	selContact.Status__c = 'Active';
		        	selContact.Family__c = familyOverView.id;
		            upsert selContact;
		        }
	    	}
        } catch(Exception e){
            AcetUtility.CreateAndRedirectToError('FamilyLink','SNI_FL_RecordsController',e);
            ErrorOccured = true;
            ErrorMessage = e.getMessage();
        }
        objcontactWrapperReturn.ErrorOccured = ErrorOccured;
        objcontactWrapperReturn.ErrorMessage = ErrorMessage;
        objcontactWrapperReturn.selContact = selContact;
        return objcontactWrapperReturn;
    }
    
    public class contactWrapperReturn {
        @AuraEnabled
        public list<contactWrapper> lstcontactWrap{get; set;}
        @AuraEnabled
        public Family_Contact__c selContact{get; set;}
        @AuraEnabled
        public boolean ErrorOccured {get;set;}
        @AuraEnabled
        public string ErrorMessage {get;set;}
        @AuraEnabled
        public string DebugMessage {get;set;}
    }
    
    public class contactWrapper {       
         @AuraEnabled
        public String contactID {get;set;}
        @AuraEnabled
        public string contactName{get;set;}
        @AuraEnabled
        public string contactEmail{get;set;}
        @AuraEnabled
        public string contactPhone{get;set;}
        @AuraEnabled
        public string contactRelationship{get;set;}
        @AuraEnabled
        public string contactAddress{get;set;}
        @AuraEnabled
        public string contactFormattedPhone {get;set;}
        @AuraEnabled
        public string contactphoto{get;set;}
    }
    
    
 @AuraEnabled
    public static RxMedWrapperReturn FetchRXMed(String familyId){
        list<RxMedWrapper> lstRxMedwrapper = new list<RxMedWrapper>();
        boolean ErrorOccured = false;
        string ErrorMessage = null;
        string DebugMessage = null;
       
        RxMedWrapperReturn objRxMedWrapperReturn = new RxMedWrapperReturn();
           try{
            Family_Overview__c[] familyOverView = [select Name,id from Family_Overview__c where Account__c =: familyId]; 
              List<Family_Link_Rx_Medication__c> fl_rxLst=  [select Id, Name, Pill_Size__c, Directions__c, Rx_Number__c, Refill_Date__c, Pharmacy__c, Pharmacy_Phone_Number__c from Family_Link_Rx_Medication__c where Status__c ='Active' and Family__c IN :familyOverView order by CreatedDate desc] ; 
           
               for( Family_Link_Rx_Medication__c f :fl_rxLst)
              {
                   RxMedWrapper rx = new RxMedWrapper();
                    rx.RxMedID = f.Id;
                    rx.RxName = f.Name;
                    rx.PillSize = f.Pill_Size__c;
                    rx.Directions = f.Directions__c;
                    rx.RxNumber = f.Rx_Number__c;
                 
                    rx.RefillDate =f.Refill_Date__c;
                     rx.Pharmacy=f.Pharmacy__c;
                     rx.PharmacyPhoneNumber= f.Pharmacy_Phone_Number__c;
                    lstRxMedwrapper.add(rx);
                
              }
            
            objRxMedWrapperReturn.lstRxMedWrap = lstRxMedwrapper;
            objRxMedWrapperReturn.ErrorOccured = ErrorOccured;
            objRxMedWrapperReturn.ErrorMessage = ErrorMessage;
            objRxMedWrapperReturn.DebugMessage = DebugMessage;
        }
        catch(Exception e){
            AcetUtility.CreateAndRedirectToError('FamilyLink','SNI_FL_RecordsController',e);
            ErrorOccured = true;
            ErrorMessage = e.getMessage();
        }
        return objRxMedWrapperReturn;
    }
    
             
         

     public class RxMedWrapperReturn {
        @AuraEnabled
        public list<RxMedWrapper> lstRxMedWrap{get; set;}
         @AuraEnabled
         public Family_Link_Rx_Medication__c addedRxMedRecord {get; set;}
        @AuraEnabled
        public boolean ErrorOccured {get;set;}
        @AuraEnabled
        public string ErrorMessage {get;set;}
        @AuraEnabled
        public string DebugMessage {get;set;}
    }
    public class RxMedWrapper {
        @AuraEnabled
        public String RxMedID {get;set;}
         @AuraEnabled
        public String RxName {get;set;}
        @AuraEnabled
        public string PillSize{get;set;}
        @AuraEnabled
        public string Directions{get;set;}
        @AuraEnabled
        public string RxNumber{get;set;}
        @AuraEnabled
        public Date RefillDate{get;set;}
         @AuraEnabled
        public string Pharmacy{get;set;}
        @AuraEnabled
        public string PharmacyPhoneNumber{get;set;}
       
    }
    
     @AuraEnabled
    public static RxMedWrapperReturn addRxMeds(String selRxName, String selPillSize, String selDirections, String selRxNum, date selRefillDate, String selPharmacy, String selPharmacyPhone, String familyId) {
       
        RxMedWrapperReturn objRxMedWrapperReturn = new RxMedWrapperReturn();
    	Family_Link_Rx_Medication__c RxMed = new Family_Link_Rx_Medication__c();
    	boolean ErrorOccured = false;
        string ErrorMessage = null;
        
        try{
	    	if(familyId != null && familyId != ''){
               
	    		Family_Overview__c familyOverView = [select Name,id from Family_Overview__c where Account__c=:familyId limit 1];
	    		if(RxMed!=null) {
                    
	    			RxMed.Name = selRxName;
	    			RxMed.Pill_Size__c = selPillSize;
                    RxMed.Directions__c = selDirections;
                    RxMed.Rx_Number__c = selRxNum;
                    if(selRefillDate != null)
                    {
                	RxMed.Refill_Date__c=  selRefillDate;
                    }
                    RxMed.Pharmacy__c = selPharmacy;
                    RxMed.Pharmacy_Phone_Number__c = selPharmacyPhone;
		        	RxMed.Status__c = 'Active';
		        	RxMed.Family__c = familyOverView.id;
                    
		            upsert RxMed;
                    
		        }
	    	}
        } catch(Exception e){
            AcetUtility.CreateAndRedirectToError('FamilyLink','SNI_FL_RecordsController',e);
            ErrorOccured = true;
            ErrorMessage = e.getMessage();
        }
        objRxMedWrapperReturn.ErrorOccured = ErrorOccured;
        objRxMedWrapperReturn.ErrorMessage = ErrorMessage;
        objRxMedWrapperReturn.addedRxMedRecord = RxMed;
        return objRxMedWrapperReturn;
    }
    public class membWrapper {       
        @AuraEnabled
        public String membId {get;set;}
        @AuraEnabled
        public string membName {get;set;}
    }     
   
    @AuraEnabled
    public static List<membWrapper> getMembers(String familyId){
        
        List<membWrapper> memblst = new List<membWrapper>();
        List<Member_Information__Share> membsharelst = new List<Member_Information__Share>();
        List<Family_Overview__Share> fmosharelst = new List<Family_Overview__Share>();
        set<string> membshareset = new set<string>();
        String userid = UserInfo.getUserId();
        Id familyAccRecTypId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Family').getRecordTypeId();        
        set<Id> persnAccIds = new set<Id>();
        Family_Overview__c fmovrec;
        set<Id> membeIds = new set<Id>();
		
		 try{        
        if(string.isNotBlank(familyId)){
            for(AccountContactRelation acc:[Select ContactId,AccountId,contact.AccountId,Account.RecordTypeId from AccountContactRelation where AccountId=:familyId AND Account.RecordTypeId=:familyAccRecTypId]){
                persnAccIds.add(acc.contact.AccountId);
            }
            fmovrec = [select Id,Account__c,Account__r.Name from Family_Overview__c where Account__c=:familyId limit 1];
            if(fmovrec!=Null){
                membWrapper memb = new membWrapper();
                memb.membId = fmovrec.Id;
                memb.membName = fmovrec.Account__r.Name+' '+'Family';
                memblst.add(memb);
                
                 List<Family_Overview__Share> oldfmo = [select ParentId,UserOrGroupId from Family_Overview__Share where ParentId=:fmovrec.Id AND UserOrGroupId=:userid limit 1];
                 if(oldfmo==Null || oldfmo.size()==0){
                     Family_Overview__Share fmosh  = new Family_Overview__Share();
                     fmosh.ParentId = fmovrec.Id;
                     fmosh.UserOrGroupId = userid;
                     fmosh.AccessLevel = 'Read';
                     fmosh.RowCause = Schema.Family_Overview__Share.RowCause.Sharing_the_associated_Documents__c;
                     fmosharelst.add(fmosh);
                 }
            } 
        }
        if(persnAccIds!=Null && persnAccIds.size()>0){
            for(Member_Information__c membInfo: [select Id,Account__c,Name from Member_Information__c where Account__c IN:persnAccIds]){
                membWrapper memb = new membWrapper();
                memb.membId = membInfo.Id;
                memb.membName = membInfo.Name;
                memblst.add(memb);
                membeIds.add(membInfo.Id);
            }
        }
        //Giving the read permission to recs for the logged in user to upload the documents in FL 
        if(membeIds!=Null && membeIds.size()>0){
            for(Member_Information__Share membsh : [select ParentId,UserOrGroupId from Member_Information__Share where ParentId IN:membeIds AND UserOrGroupId=:userid]){
                membshareset.add(membsh.ParentId);
            }
            for(string membId: membeIds){
                if(!membshareset.contains(membId)){
                     Member_Information__Share membsh  = new Member_Information__Share();
                     membsh.ParentId = membId;
                     membsh.UserOrGroupId = userid;
                     membsh.AccessLevel = 'Read';
                     membsh.RowCause = Schema.Member_Information__Share.RowCause.Sharing_the_associated_Documents__c;
                     membsharelst.add(membsh);

                }
            }
        }
        if(membsharelst!=Null && membsharelst.size()>0){
            insert membsharelst;
        }
        if(fmosharelst!=Null && fmosharelst.size()>0){
            insert fmosharelst;
        }
       }catch(Exception e){
            AcetUtility.CreateAndRedirectToError('FamilyLink','SNI_FL_RecordsController',e);
        }
        return memblst;
    }
    @AuraEnabled
    public static SNI_FL_DocumentsController.familyDocumentWrapper getUpdatedDocs(List<ID> uploadedFilesIds,string familyId,String RecordID,String selectedName){
        SNI_FL_DocumentsController.familyDocumentWrapper docwrap = new SNI_FL_DocumentsController.familyDocumentWrapper();
        try{
            List<Id> idslst = SNI_FL_CustomCmpAdvisor.AllUserFiles(uploadedFilesIds);
            docwrap = SNI_FL_DocumentsController.getdocuments(familyId);
            
            //Code added by ANKIT
            set<Id> accOwnerIds = new set<Id>();
            Id recIdss = RecordID;
            String TargetReferobjectName = recIdss.getSObjectType().getDescribe().getName();
            if(string.isNotBlank(RecordID)){ //logic for multiple families
                Id familyAccRecTypId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Family').getRecordTypeId();        
                Id recId = RecordID;
                system.debug('recId'+recId);
                String sObjName = recId.getSObjectType().getDescribe().getName();
                system.debug('--------sObjName----'+sObjName);
                if(sObjName!=Null && sObjName!='' && sObjName.equalsIgnoreCase('Member_Information__c')){
                    Member_Information__c memb =[select Id,Account__c from Member_Information__c where Id=:RecordID];
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
            }
            
            system.debug('accOwnerIds'+accOwnerIds);
            system.debug('familyId'+familyId);
            String str;
            List<Account> fca= [select Id,OwnerId from Account where Id=:familyId];
            accOwnerIds.add(fca[0].OwnerId);
            system.debug('fca'+fca);
            String loggedInUser = UserInfo.getName();
            system.debug('getName'+loggedInUser);
            system.debug('selectedName'+selectedName);
            string providerAffiname='';
            //Creating a Map to pass parameters to the flow for notification. 
            for(Id documentId:uploadedFilesIds){
                for(Id ownerId: accOwnerIds){
                    Map<String,String> flowMap = new Map<String, String>();
                    flowMap.put('ownerId',ownerId);
                    flowMap.put('recordId',RecordID);
                    flowMap.put('documentId',documentId);
                    flowMap.put('CareTeamName',selectedName);
                    flowMap.put('loggedInUser',loggedInUser);
                    flowMap.put('TargetReferobjectName',TargetReferobjectName);
                    flowMap.put('providerAffiname',' ');
                    
                    
                    
                    Flow.Interview.Document_Upload_Notification_Flow myFlow = new Flow.Interview.Document_Upload_Notification_Flow(flowMap);
                    myFlow.start();
                    
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