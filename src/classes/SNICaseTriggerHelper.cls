public without sharing class SNICaseTriggerHelper {
    
    Public static void prePopulateFieldValues(list<case> triggerNew){
        List<Id> cseOverViewId = new List<Id>();
        List<Id> accountId = new List<Id>();
        List<Id>  familyAccIds = new List<Id>();
        Map<id,List<AccountContactRelation>> acrMap = new Map<id,List<AccountContactRelation>>();
        Map<Id,Family_Overview__c> mapFamOvw = new Map<Id,Family_Overview__c>();
        Map<string,string> mpAfA = new map<string,string>();
        Map<String,contact> conMap = new Map<String,contact>();
        Map<string,string> cOpA = new map<string,string>();
        List<case> cseUpdateList = new List<case>();
        Map<Id,Member_Information__c> mapMemInfo = new Map<Id,Member_Information__c>();
        Id csRecordTypeID = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Case Overview').getRecordTypeId();
        Id recordTypeID = Schema.SObjectType.Case.getRecordTypeInfosByName().get('ECM').getRecordTypeId();
        /**Fetching the caseoverview from the case i.e; Parent caseId**/
        for(case cse : triggerNew){
            if(cse.RecordTypeId == recordTypeID){
            cseOverViewId.add(cse.ParentId);
            }
        }
        System.debug('cseOverViewId***'+cseOverViewId);
        /**Fetching the personAccount Id from the caseOverview Cases**/
        if(cseOverViewId.size()>0){
        for(case cse : [SELECT id,accountId from case where id IN :cseOverViewId AND recordTypeId =: csRecordTypeID ])
        {
            accountId.add(cse.accountId);
            cOpA.put(cse.id,cse.accountId);

        }
    	}
        /**Fetching the FamilyAccount Id from the ACR with the personAccount Id**/
       if(accountId.size()>0){
        for(AccountContactRelation curAccConRel : [Select accountId,contactid,account.policy_Id__c,account.member_Id__c,
                                                   contact.accountid,account.UHG_Restriction__c from AccountContactRelation where contact.accountId IN :accountId]){
            familyAccIds.add(curAccConRel.accountId);
            if(acrMap.size() > 0 && acrMap.containskey(curAccConRel.contact.accountid)){ 
                list<AccountContactRelation> acrtemp = acrMap.get(curAccConRel.contact.accountid);
                acrtemp.add(curAccConRel);
                acrMap.put(curAccConRel.contact.accountid, acrtemp);
            }else{
                list<AccountContactRelation> acrtempadd = new list<AccountContactRelation>();
                acrtempadd.add(curAccConRel);
                acrMap.put(curAccConRel.contact.accountid, acrtempadd);
            }
            mpAfA.put(curAccConRel.contact.accountid,curAccConRel.accountId);


        }
		}
        /**Fetching the dateofbirth and other fields from contact**/
        if(accountId.size()>0){
        for(Contact con : [Select Id,Birthdate,AccountID ,name from contact where contact.accountId in :accountId]){
            conMap.put(con.AccountId,con);
        }
        }
        
        // INSHAR [9/1/2020]
        /*
        map<id,account>  mapFamAcc = new map<id,account>();
        /**Fetching the memberID,policy fields from family account**/
	/*
        if(familyAccIds.size()>0){
            for(Account curAccConRel : [Select id,Member_ID__c,Policy_ID__c from Account where id in :familyAccIds]){
                mapFamAcc.put(curAccConRel.id,curAccConRel);
            }
        }
        */
        
        /**Fetching the family overview fields**/
         if(familyAccIds.size()>0){
        for(Family_Overview__c fmlyView : [Select id,Account__c,UHG_Restriction__c,Onshore_Restriction__c from Family_Overview__c where Account__c in :familyAccIds]){
            mapFamOvw.put(fmlyView.Account__c,fmlyView);
        }
         }
        /**Fetching the UHG Restriction from Member INformation**/
       if(accountId.size()>0){
        for(Member_Information__c memInfo : [Select id,Account__c,UHG_Restriction__c from Member_Information__c where Account__c in :accountId]){
            mapMemInfo.put(memInfo.Account__c,memInfo); 
        }
        }
       
        // INSHAR [9/1/2020]
        Boolean uhgAccess = ACETUtility.checkUserUhgAccess();
        
        for(case cse : triggerNew){
            if(cse.RecordTypeId == recordTypeID){
                string pAcId = '';
                if(cOpA.containskey(cse.parentId)){
                    pAcId = cOpA.get(cse.parentId);
                }
                if(!String.isBlank(pAcId)){
                    System.debug('***testdebug'+mpAfA.get(pAcId) +'****'+pAcId);
                    //cse.ID__c = mapFamAcc.get(mpAfA.get(pAcId)) != null ? mapFamAcc.get(mpAfA.get(pAcId)).Member_ID__c :'' ;
                    //cse.Subject_Group_ID__c =  mapFamAcc.get(mpAfA.get(pAcId)) != null ? mapFamAcc.get(mpAfA.get(pAcId)).Policy_ID__c : '';
                    System.debug('User UHG Restriction='+ACETUtility.checkUserUhgAccess());
                    for(AccountContactRelation accConR:acrMap.get(pAcId)){
                        if(accConR.account.Policy_Id__c == cse.Subject_Group_ID__c){
                            cse.Onshore_Restriction__c = 
                                mapFamOvw.get(accConR.AccountId) !=null ? mapFamOvw.get(accConR.AccountId).Onshore_Restriction__c : '';
                            cse.UHG_Restriction__c =
                                mapFamOvw.get(accConR.AccountId) !=null ? mapFamOvw.get(accConR.AccountId).UHG_Restriction__c : '';
                    		if(cse.UHG_Restriction__c.equalsignorecase('Yes') && !ACETUtility.checkUserUhgAccess()){
                        		cse.addError('You do not have access to create a UHG restricted SENS Case',false);
                    		}
                        }
                    }
                    
                    cse.Subject_Name__c = (conMap != null && conMap.get(pAcId) != null) ?conMap.get(pAcId).Name :'';
                    cse.birthdate__c =(conMap != null && conMap.get(pAcId) != null) ? conMap.get(pAcId).Birthdate : null;
                    cse.DOB__c = ((conMap!=null && conMap.get(pAcId) != null) ? conMap.get(pAcId).Birthdate != null : false) ?ACETUtility.formatDate(String.valueOf(conMap.get(pAcId).Birthdate)):'';
                    //cse.AccountId = conMap.get(pAcId) !=null ? conMap.get(pAcId).AccountId : null;
                    if(conMap!=null && conMap.get(pAcId)!=null && conMap.get(pAcId).Id != Null){
                    	cse.ContactId = conMap.get(pAcId).Id;
                    }
                    cse.Case_Type__c = 'Opportunity';
                    cse.Subject_Type__c = 'Member';
                }
            }
        }
    }
    
    public static void copyCaseTeamtoOpportunity(List<case> lsCase) {
 
              Map<Id, List<Id>> cseMap = new Map<Id, List<Id>>();
              List<CaseTeamMember> ctmList = new List<CaseTeamMember>();
              CaseTeamMember ctmadd;
             
              Id recordTypeID = Schema.SObjectType.Case.getRecordTypeInfosByName().get('ECM').getRecordTypeId();
             
              for(Case cs: lsCase) {
                             if(cs.RecordTypeId == recordTypeID) {
                                          
                                           if(cseMap.get(cs.ParentId) == null)
                                                          cseMap.put(cs.ParentId, new List<Id>());
                                          
                                           cseMap.get(cs.ParentId).add(cs.Id);
                             }
              }
             
              if(cseMap.keyset().size() > 0) {
                            
                             for(CaseTeamMember ctm :  [ SELECT TeamRoleId, MemberId, ParentId FROM CaseTeamMember WHERE parentId IN :cseMap.keyset() ]) {
                                           for(Id ecmID : cseMap.get(ctm.ParentId)) {
                                                          ctmadd = new CaseTeamMember();
                                                          ctmadd.ParentId = ecmID;
                                                          ctmadd.MemberId = ctm.MemberId;
                                                          ctmadd.TeamRoleId = ctm.TeamRoleId;
                                                          ctmList.add(ctmadd);
                                           }
                             }
                            
                             if(ctmList.size() > 0) {
                                          
                                           Database.SaveResult[] srList = Database.insert(ctmList, false);
                                          
                                           for (Database.SaveResult sr : srList) {
                                                          if (!sr.isSuccess()) {             
                                                                        for(Database.Error err : sr.getErrors()) {                 
                                                                                      System.debug('Error status ' + err.getStatusCode() + ': ' + err.getMessage());
                                                                                      System.debug('Fields that affected this error: ' + err.getFields());
                                                                        }
                                                          }
                                           }
                                          
                             }
              }            
    }
    
    /**
 	* Method : calculateActiveCount
 	* Author : Chandan
 	* Description: To calculate Active Cases
 	* Date: 02/01/2020
 	**/
   public static void calculateActiveCount(Map<Id,Case> CaseMap,boolean isInsert,boolean isDelete){

     set<id> conIdTempSet=new set<id>();
     set<String> sniRtSet = sniCaseRecordTypeSet();
     system.debug('CaseMap.keyset()='+CaseMap.keyset());
     for(Case c : [Select Id, ParentID,Parent.ContactiD From Case Where Id IN : CaseMap.keyset() and Case_Type__c = 'Opportunity' and RecordType.Name in:sniRtSet]) {
         if(c.Parent.ContactiD!=null){
              conIdTempSet.add(c.Parent.ContactiD);
          }

      }
     System.debug('conIdTempSet='+conIdTempSet);
    if(!isDelete)
      updateDetail(conIdTempSet,null);
    else
      updateDetail(conIdTempSet,CaseMap.keyset());
    }

    /**
 	* Method : UpdateDetail
 	* Author : Chandan
 	* Description: To Update the count on Family Account and status on Family Overview
 	* Date: 02/01/2020
 	**/

    public static void updateDetail(set<ID> conIdTempSet,set<id> delCaseRecords){
      map<id,Integer> conCaseCountMap=new map<id,Integer>();
     map<id,Integer> accCaseCountMap=new map<id,Integer>();
     set<id> conIdSet=new set<id>();
     set<String> sniRtSet = sniCaseRecordTypeSet();

      //U get related family account Id
      set<id> accIdTempset=new set<id>();
      for(AccountContactRelation ac: [select accountid,contactid from accountcontactrelation
          where contactid in :conIdTempSet]){
                 accIdTempset.add(ac.accountid);
      }
        system.debug('accIdTempset------'+accIdTempset);
      //For those account id,U need complete set of contact id
      Set<id> accIdCheckSet =new set<id>();
      map<id,Set<id>> famIndMap=new map<id,Set<id>>();
	  map<id,string> famMembPol = new map<id,string>();
        for(AccountContactRelation ac:
          [select accountid,contactid,account.member_Id__c,account.policy_Id__c from accountcontactrelation where accountid in :accIdTempset]){
           conIdset.add(ac.contactid);
		   famMembPol.put(ac.accountid,ac.account.member_Id__c+':'+ac.account.policy_Id__c );
           if(!accIdCheckSet.contains(ac.accountid)){
               accIdCheckSet.add(ac.accountid);
               famIndMap.put(ac.accountid,new set<id>{ac.contactid});
			   
           }
           else{
               set<id> conGetSet=famIndMap.get(ac.accountid);
               conGetSet.add(ac.contactid);
               famIndMap.put(ac.accountid,conGetSet);
           }
		}
        system.debug('conIdset------'+conIdset);
        system.debug('famMembPol------'+famMembPol);
        //For those contact id,now u count the case
        //And get corresponding person accountid and respective count of cases.
        //Assumption:
        //One Member - One Careteam
        //One Member - One FamilY
		map<string,integer> mapMemPolCnt = new map<string,integer>();
       set<string> conCheckSet=new set<string>();
        set<string> conCheckSet2=new set<string>();
       for(Case c:[SELECT id,parent.ContactID ,parent.accountId,status,ID__c,Subject_Group_ID__c FROM Case
                 Where parent.ContactID in:conIdSet and Case_Type__c = 'Opportunity' and RecordType.Name in:sniRtSet]){	
            system.debug('ID__c------'+c.ID__c);
                     system.debug('Subject_Group_ID__c------'+c.Subject_Group_ID__c);
			boolean deleteStatus=delCaseRecords!=null?delCaseRecords.contains(c.id)?false:true:true;
            if(!conCheckSet.contains(c.ID__c+':'+c.Subject_Group_ID__c)){
				 conCheckSet.add(c.ID__c+':'+c.Subject_Group_ID__c);
				 Integer totalCount=0;
				 if(c.Status!='Closed' && deleteStatus){
					totalCount+=1;
				 }
				 mapMemPolCnt.put(c.ID__c+':'+c.Subject_Group_ID__c,totalCount);
			}
            else{
				 Integer totalCount=  mapMemPolCnt.get(c.ID__c+':'+c.Subject_Group_ID__c);
				 if(c.Status!='Closed' && deleteStatus){
					totalCount+=1;
				 }
				 mapMemPolCnt.put(c.ID__c+':'+c.Subject_Group_ID__c,totalCount);
			}
              system.debug('mapMemPolCnt--------'+mapMemPolCnt);
            /* for person accounts */
		if(!conCheckSet2.contains(c.parent.ContactID)){
		 conCheckSet2.add(c.parent.ContactID);
		 Integer totalCnt=0;
		 if(c.Status!='Closed' && deleteStatus){
			totalCnt+=1;
		 }
		// conCaseCountMap.put(c.parent.contactId, totalCount);
		 accCaseCountMap.put(c.parent.accountId,totalCnt);

		}
		else{
			//Integer totalCnt =  conCaseCountMap.get(c.parent.contactId);
			Integer totalCnt = accCaseCountMap.containskey(c.parent.accountId)?accCaseCountMap.get(c.parent.accountId):null;
			if(c.Status!='Closed' && deleteStatus && totalCnt != null){
				totalCnt+=1;
			}
			//conCaseCountMap.put(c.parent.contactId, totalCount);
			accCaseCountMap.put(c.parent.accountId,totalCnt);
		}
		
        }
		List<Family_Overview__c> famOverViewList=[select id,Family_Status__c,Account__c from Family_Overview__c where Account__c in:accIdTempset];
        map<id,Family_Overview__c> accFamMap= new map<id,Family_Overview__c>();
        for(Family_Overview__c fam:famOverViewList){
            accFamMap.put(fam.Account__c,fam);
        }
        system.debug('accFamMap--------'+accFamMap);
        List<Account> accList=new List<Account>();
        for(Id accId:famMembPol.keyset()){
            string keyVal = famMembPol.get(accId);
			Integer totalCount= mapMemPolCnt.containskey(keyVal)?mapMemPolCnt.get(keyVal): 0;
            Account acc = new Account(
                 Id = accId,
                 //Family_Status__c = totalCount>0?'Active':'Inactive',
                 Open_Cases__c = totalCount
             );
               accList.add(acc);


        }
        for(Id accId:accCaseCountMap.keyset()){
            Integer totalCount= accCaseCountMap.get(accId);
            Account acc = new Account(
                 Id = accId,
                 //Family_Status__c = totalCount>0?'Active':'Inactive',
                 Open_Cases__c = totalCount
             );
               accList.add(acc);
		}
        system.debug('accList--------'+accList);
        if(accList!=null && accList.size()>0)
            update accList;


    }
    
    /**
 	* Method :sniCaseRecordTypeSet
 	* Author: Chandan
 	* Description: To get SNI specific record types
 	* Date: 02/01/2020
 	**/
    public static Set<String> sniCaseRecordTypeSet(){
       set<String> sniRtSet=new Set<String>() ;
        for(SNICaseRecordType__mdt st:[SELECT MasterLabel FROM SNICaseRecordType__mdt]){
            sniRtSet.add(st.MasterLabel);
            System.debug('Label='+st.MasterLabel);
        }

        return sniRtSet;
    }

}