public without sharing class SNI_FL_ActivitiesController {
    
    @AuraEnabled
    public static activitiesWrapper getDashboardData(string famAccId){
        activitiesWrapper activtyWrapper = new activitiesWrapper();
        list<AllActionsInfoWrapper> allActions = new list<AllActionsInfoWrapper>();
        boolean ErrorOccured = false;
        system.debug('getDashboardData---');
        system.debug('getDashboardData---famAccId----'+famAccId);
        // famAccId = '001R000001dIz8eIAC'; // david
       // famAccId = '001R000001ebyDwIAI'; // frank
        try{
            if(famAccId != null){
               List<User> userHis = getCommunityUsersOfFamily(famAccId);
                system.debug('Activities userHis------'+userHis);
                if(userHis != null){
                    for(User uh : userHis){
                        allActions.add(new AllActionsInfoWrapper(uh.createdBy.Name,null,null,null,uh.CreatedDate,'User',null,uh,getDateFormat(uh.CreatedDate),false, null, null));
                }
            } 
                /*
                List<ContentVersionHistory> lstConVers = trackDocInfo(famAccId);
            system.debug('Activities lstConVers------'+lstConVers);
            if(lstConVers != null){
                    for(ContentVersionHistory cv : lstConVers){
                        allActions.add(new AllActionsInfoWrapper(cv.createdBy.Name,null,null,cv.Field,cv.CreatedDate,'File',cv.ContentVersion.Title,null,getDateFormat(cv.CreatedDate)));
                }
                }*/
               List<SNI_FL_Activity_History__c> lstHis = trackDocInfo(famAccId);
                if(lstHis != null){
                    for(SNI_FL_Activity_History__c cv : lstHis){
                        allActions.add(new AllActionsInfoWrapper(cv.createdBy.Name,null,cv.New_Value__c,cv.Old_Value__c,cv.CreatedDate,'File',cv.Name,null,getDateFormat(cv.CreatedDate),cv.Isdeleted__c,cv.createdBy.firstname,cv.createdBy.lastname));
            }
                }
                list<SNI_FL_Activity_History__c> casehis = trackCaseInfo(famAccId);
            system.debug('Activities CaseHistory------'+casehis);
            if(casehis != null){
                    for(SNI_FL_Activity_History__c ch : casehis){
                        allActions.add(new AllActionsInfoWrapper(ch.createdBy.Name,null,ch.New_Value__c,ch.Old_Value__c,ch.CreatedDate,'Case',ch.Name,null,getDateFormat(ch.CreatedDate),ch.Isdeleted__c,ch.createdBy.firstname,ch.createdBy.lastname));
                }
            }
            
            }
        }
        Catch(Exception e){
            AcetUtility.CreateAndRedirectToError('FamilyLink','SNI_FL_ActivitiesController',e);
            ErrorOccured = true;
        }
        system.debug('accActions::'+allActions);
        if(allActions.size()>0){
         allActions.Sort();
        }
        activtyWrapper.allActions = allActions;
        activtyWrapper.ErrorOccured = ErrorOccured;
        return activtyWrapper;
    }
    public static List<SNI_FL_Activity_History__c> trackDocInfo(string accId){
        List<SNI_FL_Activity_History__c> lstHis = new List<SNI_FL_Activity_History__c>();
      if(accId != null && string.isNotEmpty(accId) && string.isNotBlank(accId)){
          set<string> parIds = new set<string>();
          for(Family_Overview__c famRec : [select id from Family_Overview__c where Account__c =: accId]){
              parIds.add(famRec.id);
          }
          set<string> setPacIds = new set<string>();
            for(AccountContactRelation curAccConRel : [Select accountId,contact.accountId from AccountContactRelation where accountId =: accId]){
                setPacIds.add(curAccConRel.contact.accountId);
          }
          if(setPacIds.size()>0){
              for(Member_Information__c memRec : [select id from Member_Information__c where Account__c =: setPacIds]){
                  parIds.add(memRec.id);
              }
          }
          if(parIds.size()>0){
              lstHis = [select id,createddate,lastmodifieddate,createdby.name,createdby.firstname,createdby.lastname,lastmodifiedby.name,Name,New_Value__c,Old_Value__c,Isdeleted__c,ParentID__c from SNI_FL_Activity_History__c where ParentID__c IN : parIds];
          }
      }
        return lstHis;
    }
    /*
    public static List<ContentVersionHistory> trackDocInfo(string accId){
        
        if(accId != null && string.isNotEmpty(accId) && string.isNotBlank(accId)){
          //  accId = '001R000001ebyDwIAI';
            list<Family_Overview__c> lstFamOvr = [select id from Family_Overview__c where Account__c =: accId];
            system.debug('docs lstFamOvr--'+lstFamOvr);
            if(lstFamOvr != null && lstFamOvr.size()>0){
                string famId = lstFamOvr[0].id;
                set<string> docLinkIds = new set<string>();
                for(ContentDocumentLink curRec : [select id,ContentDocumentId from ContentDocumentLink where LinkedEntityId  =: famId ]){
                    docLinkIds.add(curRec.ContentDocumentId);
                }
                system.debug('docs lstConDocLink--'+lstConDocLink);
                if(docLinkIds != null && docLinkIds.size()>0){
                    //list<ContentVersion> lstConVers = [select id,createdBy.Name,CreatedDate,Title,PathOnClient from ContentVersion where ContentDocumentId =: lstConDocLink[0].ContentDocumentId ];
                    set<string> ids = new set<string>();
                    //list<ContentVersion> lstConVers = [select id,createdBy.Name,CreatedDate,Title,PathOnClient from ContentVersion where ContentDocumentId IN: docLinkIds ];
                    //select id,Field,CreatedDate,CreatedById,NewValue,oldvalue,ContentVersionId,ContentVersion.Title from ContentVersionHistory where ContentVersionId IN: (select id)
                    list<ContentVersion> lstConVers = [select id,createdBy.Name,CreatedDate,Title from ContentVersion where ContentDocumentId IN: docLinkIds ];
                    if(lstConVers != null && lstConVers.size()>0){
                    list<ContentVersionHistory> lstConverHis = [select id,Field,ContentVersion.Title,CreatedDate,createdBy.Name from ContentVersionHistory where ContentVersionId IN: lstConVers];
                    system.debug('docs lstConVers--'+lstConVers);
                    system.debug('docs lstConVers----'+lstConVers);
                    return lstConverHis;
                    }
                }
            }
        }
       
       
        return null;
    }
*/
    public static List<SNI_FL_Activity_History__c> trackCaseInfo(string accId){ 
         List<SNI_FL_Activity_History__c> casHistry = new List<SNI_FL_Activity_History__c>();
        if(accId != null && string.isNotEmpty(accId) && string.isNotBlank(accId)){
            set<string> setString = new set<string>();
            for(AccountContactRelation curAccConRel : [Select accountId,contact.accountId from AccountContactRelation where accountId =: accId]){
                setString.add(curAccConRel.contact.accountId);
            }
            if(! setString.isEmpty()) {
                List<Case> lstCase = [select id from case where AccountId IN: setString and (RecordType.name = 'ECM' or RecordType.name = 'Case Close') and Community__c =true order by createddate desc]; 
                if(lstCase.size()>0){
                    set<string> setCaseFilter = new set<String>();
                    for(Case c:lstCase){
                        setCaseFilter.add(c.Id);
                    }
              		casHistry = [select id,createddate,lastmodifieddate,createdby.name,createdby.firstname,createdby.lastname,lastmodifiedby.name,Name,New_Value__c,Old_Value__c,Isdeleted__c,ParentID__c from SNI_FL_Activity_History__c where ParentID__c IN: setCaseFilter ORDER BY CreatedDate DESC LIMIT 200];  
          		} 
                return casHistry;
            }
            
            }
        
        return null; 
    }
    
    public static List<User> getCommunityUsersOfFamily(string famAccId){ 
         set<string> setString = new set<string>();
         for(AccountContactRelation curAccConRel : [Select accountId,contactid from AccountContactRelation where accountId =: famAccId]){
             system.debug('UserList---contct ids---'+curAccConRel.contactid);   
             setString.add(curAccConRel.contactid);
         }
        if(setString.size()>0 ){
            list<User> UserList = [SELECT id,Name,CreatedDate,CreatedBy.Name FROM User WHERE Profile.Name = 'FamilyLink Community User' AND ContactId IN : setString];
            system.debug('UserList------'+UserList);
            return UserList;
            }
         return null;
    }
	/*
    public static List<User> getCommunityUser(string conid){
        system.debug('getCommunityUser---accId---'+conid);
        if(conid != null && string.isNotEmpty(conid) && string.isNotBlank(conid)){
            list<User> UserList = [SELECT id,Name,CreatedDate,CreatedBy.Name FROM User WHERE Profile.Name = 'FamilyLink Community User' AND ContactId =: conid];
            system.debug('UserList------'+UserList);
            return UserList;
        }
        else
            return null;
    } 
    @AuraEnabled
    public static User getUser(){
        
        //list<User> UserList = [SELECT id,Name,ContactId,CreatedBy.name,CreatedDate,Contact.AccountId FROM User where Id =: UserInfo.getUserId()  limit 1];
        list<User> UserList = [SELECT id,Name,ContactId,CreatedBy.name,CreatedDate,Contact.AccountId FROM User where Id = '005R0000006cp9P'  limit 1];
        if(UserList != null && !UserList.isEmpty()){
            system.debug('getUser---UserList----'+UserList);
            return UserList[0];
        }
        return null;
    }
	*/
    @AuraEnabled
    public static string getDateFormat(DateTime dT){  
        String dateString = '';
        Date myDate = date.newinstance(dT.year(), dT.month(), dT.day());
        integer totaldays =myDate.daysBetween(system.today()); 
        integer monthDate = Math.Round(totaldays/30);
        integer yearDate = Math.Round(totaldays/365);
        if(totaldays == 0){
            return 'today';
        }
        
        if(totaldays == 365)
            dateString = yearDate +'year'+String.valueOf((yearDate>1?' s':''))+' ago.'; 
        else if(totaldays >= 30)
            dateString = monthDate +'month'+String.valueOf((monthDate>1?' s':''))+' ago.'; 
        else
            dateString = totaldays+'days ago.';
        return dateString;
    }
    public class AllActionsInfoWrapper implements Comparable{
        @AuraEnabled
        public string createdBy{get;set;}
        @AuraEnabled
        public string oldValue{get;set;}
        @AuraEnabled
        public string newValue{get;set;}
        @AuraEnabled
        public string field {get;set;}
        @AuraEnabled
        public DateTime createdDate {get;set;}
        @AuraEnabled
        public String objectType {get;set;}
        @AuraEnabled
        
        public string attName {get;set;}
        @AuraEnabled
        public User usr {get;set;}
        @AuraEnabled
        public string formattedDate{get;set;}
        @AuraEnabled
        public boolean isDeleted{get;set;}
		@AuraEnabled
        public string createdByFirstName{get;set;}
        @AuraEnabled
        public string createdByLastNameInit{get;set;}
        public AllActionsInfoWrapper(string createdBy,string field,string newValue,string oldValue,DateTime createdDate,String objectType,string attName,User usr,string formattedDate,boolean isDeleted,string createdByFirstName, string createdByLastNameInit){
            this.createdBy = createdBy;
            this.field = field;
            this.oldValue = oldValue;
            this.newValue = newValue;
            this.createdDate = createdDate;
            this.objectType = objectType;
            this.attName = attName;
            this.usr = usr;
            this.formattedDate = formattedDate;
            this.isDeleted = isDeleted;
			this.createdByFirstName = createdByFirstName;
            this.createdByLastNameInit = createdByLastNameInit != null ? createdByLastNameInit.substring(0, 1).touppercase():createdByLastNameInit;
        }
        public integer compareTo(Object objToCompare){
            AllActionsInfoWrapper compareToEventTask = (AllActionsInfoWrapper)objToCompare;
            if (createdDate == compareToEventTask.createdDate) {
                return 0;
            }			
            if (createdDate > compareToEventTask.createdDate) {
                return -1;
            }			
            return 1; 
        }
    }
    public class activitiesWrapper {
        @AuraEnabled
        public list<AllActionsInfoWrapper> allActions{get;set;}
        @AuraEnabled
        public boolean ErrorOccured {get;set;}
    }
}