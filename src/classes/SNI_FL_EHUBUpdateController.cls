/**
* Author: Team Eagles
* Description: An apex page controller fetches the accounts that were transferred via Mass Transfer Accounts functionality and synches the data with EHub
* Date Modified: 09/28/2020
*/
public class SNI_FL_EHUBUpdateController {
    @AuraEnabled
    public static user getUser(){
        User oUser = [select id,Name,Profile_Name__c,ProfileId,Role_Name__c FROM User Where id =: userInfo.getUserId()];
        return oUser;
    }
    public class AccountWrapper{
        @AuraEnabled public Account acctInfo {get;set;}
        @AuraEnabled public List<AccountContactRelation> acrInfoList {get;set;}
        @AuraEnabled public List<Account> famMemberList {get;set;}
    }
    public class AccountInfo {
    	@AuraEnabled public Id AccountId {get;set;}
    	@AuraEnabled public String FamilyID {get;set;}
    	@AuraEnabled public String Name {get;set;}
    	@AuraEnabled public String AssignedAdvisor {get;set;}
    	@AuraEnabled public String FamilyStatus {get;set;}
    }
    public class ReturnWrapper{
        @AuraEnabled public List<AccountInfo> famList {get;set;} 
        @AuraEnabled public Map<Id, AccountWrapper> accountMap {get;set;}
    }
    @AuraEnabled
    public static ReturnWrapper getAccountList(String userId){
    	ReturnWrapper retWrap = new ReturnWrapper();
    	Map<Id, AccountWrapper> acctMap = new Map<Id, AccountWrapper>();
        List<RecordType> familyRecord = [SELECT Id FROM RecordType WHERE Name = 'Family'];
		//get data
		list<Account> acctList = [select Id,Firstname,LastName, Name, PersonBirthdate,EHub_Update_Check__c,CreatedDate,Family_ID__c , Member_ID__c , Policy_ID__c , Assigned_Advisor__c,
									OwnerId, Owner.FederationIdentifier , Owner.Name,PersonContactId,(select id,EHub_Update_Check__c,Newly_Diagnosed_Date__c,Medical_Condition__c,Behavioral_Condition__c,
									Primary__c from Members_Information__r WHERE Primary__c = true),
                                    (Select Id,Designation__c from Family_Overview__r) from Account WHERE LastModifiedById =: userId AND EHub_Update_Check__c = true 
									AND RecordTypeId IN :familyRecord LIMIT 500];
		list<Family_Overview__c> famOverList = [select Id, Family_Status__c, Account__c from Family_Overview__c where Account__c IN :acctList];
		list<AccountContactRelation> acrList =[ SELECT AccountId, ContactId, Relationship__c FROM AccountContactRelation WHERE AccountId IN:acctList];
		set<Id> conItSet =  new set<Id>();
		Map<Id, Id> conAccId = new Map<Id, Id>();
		for(AccountContactRelation acr: acrList){
			conItSet.add(acr.ContactId);
			conAccId.put(acr.ContactId, acr.AccountId);
		}
		list<Account> memConList = [select id,Family_ID__c,PersonContactId,Firstname,LastName,PersonBirthdate, Relationship__pc,(select id,EHub_Update_Check__c,Newly_Diagnosed_Date__c,Medical_Condition__c,Behavioral_Condition__c,Primary__c from Members_Information__r WHERE Primary__c = true) from Account where PersonContactId IN:conItSet];
		List<AccountInfo> accountInfoList = new List<AccountInfo>();
		for(Account acct: acctList){
			//set UI variable
			AccountInfo acctInfo = new AccountInfo();
			acctInfo.AccountId = acct.Id;
			acctInfo.FamilyID = acct.Family_ID__c;
			acctInfo.Name = acct.Name;
			acctInfo.AssignedAdvisor = acct.Assigned_Advisor__c;
			acctInfo.FamilyStatus = '';
			accountInfoList.add(acctInfo);
			//set API variable
			AccountWrapper acctWrap = new AccountWrapper();
			acctWrap.acctInfo = acct;
			acctWrap.acrInfoList = new List<AccountContactRelation>();
			acctWrap.famMemberList = new List<Account>();
			acctMap.put(acct.Id, acctWrap);
		}
		for(Family_Overview__c famOver: famOverList){
			//set UI variable
			for(Integer i = 0; i < accountInfoList.size(); i++){
				if(accountInfoList[i].AccountId == famOver.Account__c){
					accountInfoList[i].FamilyStatus = famOver.Family_Status__c;
				}
			}
		}
		for(AccountContactRelation acr: acrList){
			//set API variable
			acctMap.get(acr.AccountId).acrInfoList.add(acr);
		}
		for(Account memCon: memConList){
			//set API variable
			Id acctId = conAccId.get(memCon.personContactId);
			acctMap.get(acctId).famMemberList.add(memCon);
		}
        retWrap.famList = accountInfoList;
		retWrap.accountMap = acctMap;
        return retWrap;
    }
    public class SearchResultWrapper{
        @AuraEnabled public ACETWSCalloutResult resultWrapper {get;set;} 
        @AuraEnabled public string message {get;set;}
        @AuraEnabled public integer statusCode {get;set;}
        @AuraEnabled public boolean elligHubCheck {get;set;}
    }
    @AuraEnabled
    public static SearchResultWrapper sendToEHUB(AccountWrapper acctWrap, String famOverDesignation){
    	SearchResultWrapper returnData = new SearchResultWrapper();
        returnData.elligHubCheck=false;
    	if(acctWrap!=null && acctWrap.acctInfo != null){
    		returnData.elligHubCheck=true;
    		if(acctWrap.acctInfo.Family_ID__c != null && acctWrap.acctInfo.personContactId == null){
    			Account famRec = acctWrap.acctInfo;
    			Map<string, string> relationMap = new Map<string, string>();
    			for(AccountContactRelation acr: acctWrap.acrInfoList){
    				string mapKey = acr.AccountId +'_'+acr.ContactId;
                    relationMap.put(mapKey, acr.Relationship__c);
    			}
    			list<Account> lstMemConInfo = acctWrap.famMemberList;
    			if(famRec.Family_ID__c != null){
                       List<Member_Information__c> memInfoList = new List<Member_Information__c>();
                       string famFamilyId = famRec.Family_ID__c;
                       ACETSNIEligibilityUpdAPIRequest.Family famObj = new ACETSNIEligibilityUpdAPIRequest.Family();
                       famObj.acetFamilyId = famFamilyId;
                       famObj.initialCallDate = string.valueOf(famRec.CreatedDate);
        			   famObj.policyID = famRec.Policy_ID__c;
        			   famObj.memberID= famRec.Member_ID__c;
                       famObj.adviserMsId = famRec.Owner.FederationIdentifier;
                       famObj.advisorFullName = famRec.Owner.Name;
                       //famObj.designation = famRec.Designation__c ; //Commented to resolve the defect-DE389067
                       //Added to resolve the defect-DE389067 -Begin
                       famObj.designation=' ';
                       if(famOverDesignation!=null && String.isNotBlank(famOverDesignation)){
                           famObj.designation= famOverDesignation;
                        }
                       //Added to resolve the defect-DE389067 -End
                       //famObj.designation = famRec.Designation__c ; //Commented to resolve the defect-DE389067
                       
                       list<ACETSNIEligibilityUpdAPIRequest.member> memList = new List<ACETSNIEligibilityUpdAPIRequest.member>();
                       for(Account mem:lstMemConInfo){
                           string personFamilyId = mem.Family_ID__c;
                           ACETSNIEligibilityUpdAPIRequest.member memObj = new ACETSNIEligibilityUpdAPIRequest.member();
                           memObj.acetIndividualId = personFamilyId;
                           memObj.firstName = mem.Firstname;
                           memObj.lastName = mem.LastName;
                           memObj.dob = string.valueOf(mem.PersonBirthdate);
                           string relMapKey = famRec.Id+'_'+mem.PersonContactId;
                           memObj.relationship = relationMap.get(relMapKey);
                           if(mem.Members_Information__r != null && mem.Members_Information__r.size()>0){
                               Member_Information__c  memInfo = mem.Members_Information__r[0];
                               memInfo.EHub_Update_Check__c=false;
                               memInfoList.add(memInfo);
                               if(memInfo.Newly_Diagnosed_Date__c == null)
                                 memObj.newlyDiagnosed = 0;
                               else
                                 memObj.newlyDiagnosed = 1;
                               memObj.medicalCondition = memInfo.Medical_Condition__c;
                               memObj.behavioralCondition = memInfo.Behavioral_Condition__c;
                               if(memInfo.Primary__c) 
                                   memObj.isPrimary = 1 ;
                                else
                                   memObj.isPrimary = 0;
                           }
                           memList.add(memObj);
                       }
                       ACETSNIEligibilityUpdAPI sniEliHubApi=new ACETSNIEligibilityUpdAPI();
                       ACETWSCalloutResult calloutResult = sniEliHubApi.callEligibilityService(famObj, memList);
                       if(calloutResult != null){
                            returnData.resultWrapper=calloutResult;
                            returnData.message=calloutResult.Message;
                            returnData.statusCode=calloutResult.StatusCode;
                            if(calloutResult.Success && (calloutResult.StatusCode ==200 || calloutResult.StatusCode ==201)){
                                update memInfoList;
                                Account accRec = new Account(
                                    Id= famRec.Id,
                                    EHub_Update_Check__c = false
                                );
                                update accRec;
                            }
                       }
                   }
    		}
    	}
        return returnData;
    }
}