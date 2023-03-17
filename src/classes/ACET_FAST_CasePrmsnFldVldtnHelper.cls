/*****************************************************************************************************
ACET_FAST_CasePrmsnFldVldtnHelper 
Test Class Name:  ACET_FAST_CasePrmsnFldVldtnHelperTest
Author: Shaik Mohammad Yaseen
Description: This class is used asn handler for case trigger to handle the fast access roles on case. 
Reference:US2941823 - FAST Case Permissions and Fields Validations
11/06/2020 - Shaik Mohammad Yaseen - Initial
******************************************************************************************************/
public with sharing class ACET_FAST_CasePrmsnFldVldtnHelper {
    public static Boolean isFirstTime = true;
    
    public static final String IMPACT_SYSTEM = 'Impact System';
    public static final String CASE_ITEM_ERROR = 'Please resolve all the case items before closing the case.';
    
    public static Id fastRecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('Reactive_Resolution').getRecordTypeId();
    public static Id closedRecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('Reactive_Resolution_Closed').getRecordTypeId();
    //-- US2795005 - This If is used for PIP(E2E) close case Record type change ---
    public static Id e2eRecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('Proactive_Action').getRecordTypeId();
    public static Id e2eClosedRecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('Proactive_Action_Closed').getRecordTypeId();
    
    public static void handleCaseUpdate(List<Case> triggerNew, map<id,Case> triggerOldMap){
        ACET_FAST_Utility.LoggedInUserWrapper logInUser = new ACET_FAST_Utility.LoggedInUserWrapper();
        Set<String> excludeProfiles = new Set<String>{'Integration Only','PIR Support Cases Profile','Integration'};
            
            Set<Id> caseIds = (new Map<Id,Case>(triggerNew)).keySet();
        Map<id,set<id>> caseTeamMemberMap = ACET_FAST_Utility.getCaseTeamMemberMap(caseIds);

        Map<Id, List<id>> caseIdGrpMemMap = populateGroupMember(triggerNew);
        
        for(Case CaseRec: TriggerNew){
            
            string rectypeName = ACET_FAST_CasePrmsnFldVldtnHelper.getRecordTypeNameById('Case',caseRec.RecordTypeId);
            Boolean queueAccess = checkCaseOwnerQueue( caseRec, logInUser,caseIdGrpMemMap);
            
            if(ACET_FAST_Constants.validACETCaseRecordTypes.contains(rectypeName) && !excludeProfiles.contains(logInUser.loggedInUserProfile) && CaseRec.OwnerId == triggerOldMap.get(CaseRec.id).OwnerId){
                if( (logInUser.isValidUser || logInUser.loggedInUserId==CaseRec.OwnerId || queueAccess || (caseTeamMemberMap.containsKey(CaseRec.id) && caseTeamMemberMap.get(CaseRec.id).contains(logInUser.loggedInUserId)))){
                    system.debug('caseRec STatus -->'+CaseRec.Status );
                    if(CaseRec.Status=='Closed'){
                        ACET_FAST_CasePrmsnFldVldtnHelper.caseCloseFieldsValidations(triggerNew); 
                        ACET_FAST_CasePrmsnFldVldtnHelper.changeCaseRecordType(CaseRec,triggerOldMap);
                    } else {
                        ACET_FAST_CasePrmsnFldVldtnHelper.validateCaseFields(CaseRec);
                    }                
                } else{
                    CaseRec.addError(ACET_FAST_Constants.notaValiFastRoleError);
                }
            }
        }
    }

    public static boolean checkCaseOwnerQueue(case caseRec, ACET_FAST_Utility.LoggedInUserWrapper logInUser, Map<Id,List<Id>> caseIdGrpMemMap){
        if(string.valueOf(caseRec.OwnerId).startsWith('00G')){
            //Owner is Queue
            List<id> grpMemLst = new List<id>();
             grpMemLst = caseIdGrpMemMap.get(caseRec.Id);

            if(grpMemLst != null && grpMemLst.size()>0){
                for(id gm : grpMemLst){
                    if(gm == logInUser.loggedInUserId){
                        return true;
                    }
                }
                return false;
            }            
            return false;
        } else {
            return false;
        }
    }

    public static Map<Id,List<Id>> populateGroupMember(List<Case> caseRecs){
        
        map<id,id> caseGroupIdMap = new map<id,id>();
        for(case c : caseRecs){
            if(string.valueOf(c.OwnerId).startsWith('00G')){
                caseGroupIdMap.put(c.id,c.OwnerId);
            }
        }

        List<GroupMember> grpMemLst = [Select UserOrGroupId,GroupId From GroupMember where GroupId IN :caseGroupIdMap.values()];
        Map<Id, List<Id>> grpMap = new Map<Id, List<Id>>();
        for (GroupMember gm : grpMemLst) {
            if(!grpMap.containsKey(gm.GroupId)){
                grpMap.put(gm.GroupId,new List<Id>());
            }
            grpMap.get(gm.GroupId).add(gm.UserOrGroupId);
        }  

        return populateGroupMemberwithcase(caseRecs,grpMap);
    }

    public static Map<Id,List<Id>> populateGroupMemberwithcase(List<Case> caseRecs, Map<Id,List<Id>> grpMap){
        Map<Id,List<Id>> grpMemCaseMap = new Map<Id,List<Id>>();
        for(case c : caseRecs){
            for(id grpId : grpMap.keyset()){
                if(grpId == c.OwnerId){
                    if(!grpMemCaseMap.containsKey(c.id)){
                        grpMemCaseMap.put(c.id,new List<Id>());
                    }
                    grpMemCaseMap.get(c.id).addAll(grpMap.get(grpId));
                }
            }
        }
        return grpMemCaseMap;
    }

    public static void validateCaseFields(case caseToCheck){
        string errorMessage = ACET_FAST_Constants.mandatoryFieldError;
        system.debug('caseToCheck.PC_Provider_TIN__c==>'+caseToCheck.PC_Provider_TIN__c);
        if((caseToCheck.PC_Provider_TIN__c==null || caseToCheck.PC_Provider_TIN__c=='')&& caseToCheck.Origin != IMPACT_SYSTEM)
            caseToCheck.PC_Provider_TIN__c.addError(errorMessage);
        
        system.debug('caseToCheck.Origin==>'+caseToCheck.Origin);
        if(caseToCheck.Origin==null || caseToCheck.Origin=='')
            caseToCheck.Origin.addError(errorMessage);
        
        
        if(caseToCheck.FAST_PIP_Markets__c==null || caseToCheck.FAST_PIP_Markets__c=='')
            caseToCheck.FAST_PIP_Markets__c.addError(errorMessage);
        
        if(caseToCheck.Subject==null || caseToCheck.Subject=='')
            caseToCheck.Subject.addError(errorMessage);
        
        if(caseToCheck.Description==null || caseToCheck.Description=='')
            caseToCheck.Description.addError(errorMessage);
        
    }
    
    public static void validateProviderContactFields(case caseToCheck){
        string errorMessage = ACET_FAST_Constants.mandatoryFieldError;
        
        if((caseToCheck.PC_Internal_Contact_Name__c==null || caseToCheck.PC_Internal_Contact_Name__c==''))
            caseToCheck.PC_Internal_Contact_Name__c.addError(errorMessage);
        
        if((caseToCheck.PC_Internal_Contact_Phone__c==null || caseToCheck.PC_Internal_Contact_Phone__c==''))
            caseToCheck.PC_Internal_Contact_Phone__c.addError(errorMessage);
        
        if((caseToCheck.PC_Internal_Contact_Email__c==null || caseToCheck.PC_Internal_Contact_Email__c=='') )
            caseToCheck.PC_Internal_Contact_Email__c.addError(errorMessage);
        
        if(caseToCheck.Submitting_Department__c==null || caseToCheck.Submitting_Department__c=='')
            caseToCheck.Submitting_Department__c.addError(errorMessage);
        
        if(caseToCheck.Original_Received_Date__c==null && caseToCheck.Origin != IMPACT_SYSTEM)
            caseToCheck.Original_Received_Date__c.addError(errorMessage);
        
    }
    public static void validateExternalContactFields(case caseToCheck){
        string errorMessage = ACET_FAST_Constants.mandatoryFieldError;
        
      
        if(caseToCheck.RecordTypeId == fastRecordTypeId || caseToCheck.RecordTypeId == closedRecordTypeId ){
            if((caseToCheck.PC_External_Contact_Name__c==null || caseToCheck.PC_External_Contact_Name__c==''))
            caseToCheck.PC_External_Contact_Name__c.addError(errorMessage);
        
        if((caseToCheck.PC_External_Contact_Phone__c==null || caseToCheck.PC_External_Contact_Phone__c==''))
            caseToCheck.PC_External_Contact_Phone__c.addError(errorMessage);
        
        if((caseToCheck.PC_External_Contact_Email__c==null || caseToCheck.PC_External_Contact_Email__c=='') )
            caseToCheck.PC_External_Contact_Email__c.addError(errorMessage);
        }  
        
    }
    public static String getRecordTypeNameById(String objectName, Id strRecordTypeId){
        return Schema.getGlobalDescribe().get(objectName).getDescribe().getRecordTypeInfosById().get(strRecordTypeId).getName();
    }
    
    // #US2853357 Added by Santhosh K
    Public static void changeCaseRecordType(case caseRec,Map<id,Case> caseOldMap){
        if( caseRec.Status != caseOldMap.get(caseRec.id).status) {                       
            if(caseRec.RecordTypeId == fastRecordTypeId){
                caseRec.RecordTypeId = closedRecordTypeId;
            }
            if(caseRec.RecordTypeId == e2eRecordTypeId){
                caseRec.RecordTypeId = e2eClosedRecordTypeId;
            } 
        } 
    }
    
    public static void changeCaseOwner(List<Case> triggerNew){
        QueueSObject queueID = [Select Queue.Id, Queue.Name, Queue.Type from QueueSObject WHERE Queue.Type ='Queue' AND Queue.Name ='IMPACT FAST Integration Queue' Limit 1];
        for(case caseRec :triggerNew ){
            if(caseRec.RecordTypeId == fastRecordTypeId && caseRec.Origin == IMPACT_SYSTEM && queueID.id != null && caseRec.Is_Cloned__c == false){
                caseRec.OwnerId = queueID.Queue.Id;
                caseRec.Status = 'New';
            }
        }
    }
    
    Public static Map<String, PIR_Detail__c> fetchPIRDetailsForCases(Set<Id> setOfCaseIds){
		Map<String, PIR_Detail__c> csId_PIRObjectData = new Map<String, PIR_Detail__c>();
        List<Id> listOfCaseIds = new List<Id>(setOfCaseIds);
		for(PIR_Detail__c pir:[SELECT Id, Case__c, Case__r.CaseNumber, Case__r.Id, Case__r.RecordType.Name, Substatus__c, Data_Analysis__c, Measurement_System__c, Queries__c, Root_Cause_1_Key_Code__c, Root_Cause_1__c, Root_Cause_2_Key_Code__c, Root_Cause_2__c,Root_Cause_3_Key_Code__c, Root_Cause_3__c, Root_Cause_4_Key_Code__c, Root_Cause_4__c, Root_Cause_5_Key_Code__c, Root_Cause_5__c, Sources_of_Data__c,Provider_Was_contacted__c, Closure_Sub_Status__c,Submitter_to_Contact_Provider_at_Closure__c, Will_this_be_closed_in_Practice_Mgmt__c,Issue_Category__c, Issue_Subcategory__c FROM PIR_Detail__c WHERE Case__c=:listOfCaseIds]){
			csId_PIRObjectData.put(pir.Case__c, pir);
		}
		System.debug('csId_PIRObjectData-->'+csId_PIRObjectData);
        return csId_PIRObjectData;
    }
    Public static boolean validatePIRDetailsToClose(PIR_Detail__c pirDetailsData){
		boolean valid = true;
		System.debug('validatePIRDetailsToClose-->'+valid);
		PIR_Detail__c pirData = pirDetailsData;
		if(pirData.Case__r.RecordType.Name.equalsIgnoreCase(ACET_FAST_Constants.proactAction)){
			valid = validateProActiviePIRDetails(pirDetailsData);
		}else if(pirData.Case__r.RecordType.Name.equalsIgnoreCase(ACET_FAST_Constants.reactiveResolution)){
			valid = validateReactivePIRDetails(pirDetailsData);
		}
		System.debug('validatePIRDetailsToClose result-->'+valid);
		return valid;
	}
    
    Public static boolean validateProActiviePIRDetails(PIR_Detail__c pirData){
        boolean valid = true;
		System.debug('validateProActiviePIRDetails-->'+valid);
        if(String.isBlank(pirData.Data_Analysis__c) || String.isBlank(pirData.Measurement_System__c)
          || String.isBlank(pirData.Queries__c) || String.isBlank(pirData.Root_Cause_1__c) || String.isBlank(pirData.Root_Cause_2__c)
           || String.isBlank(pirData.Root_Cause_3__c) || String.isBlank(pirData.Root_Cause_4__c) || String.isBlank(pirData.Root_Cause_5__c)){
               valid = false;
           }
		System.debug('validateProActiviePIRDetails result-->'+valid);
        return valid;
    }
    
    Public static boolean validateReactivePIRDetails(PIR_Detail__c pirData){
        boolean valid = true;
		System.debug('validateReactivePIRDetails-->'+valid);
        if(String.isBlank(pirData.Provider_Was_contacted__c)
          || String.isBlank(pirData.Closure_Sub_Status__c) || String.isBlank(pirData.Submitter_to_Contact_Provider_at_Closure__c)
          || String.isBlank(pirData.Will_this_be_closed_in_Practice_Mgmt__c)){
            valid = false;
        }
		System.debug('validateReactivePIRDetails result-->'+valid);
        return valid;
    }
    Public static Map<Id,Case> processCaseItemError(List<Case> triggerNew){
		Map<Id,Case> closingCaseMap= new  Map<Id,Case>();
		for(case cas:triggerNew){
            if(cas.status=='closed'){
                closingCaseMap.Put(cas.id,cas);
                if(cas.Case_Items_Unresolved__c > 0){
                    cas.addError(CASE_ITEM_ERROR);
                }
            }                
        }
		return closingCaseMap;
	}
	
    Public static void caseCloseFieldsValidations(List<Case> triggerNew){
        System.debug('==Inside caseCloseFieldsValidations==');
		List<PIR_Detail__c> listOfPIRData = new List<PIR_Detail__c>();
        //Closing cases Ids
        Map<Id,Case> closingCaseMap= new  Map<Id,Case>();
		closingCaseMap = processCaseItemError(triggerNew);
        
        Map<String, PIR_Detail__c> csId_PIRObjectData = fetchPIRDetailsForCases(closingCaseMap.keySet());
        //Get Open tasks and PIR Details records
        Map<Id,Task> openTasksMap= new  Map<Id,Task>();
        for(Task tsk: [select id,status,whatId from task where status<>'Completed' and whatId IN :closingCaseMap.keyset()])
            openTasksMap.put(tsk.whatId,tsk);
        
        Map<Id,PIR_Detail__c> openPIRDetaisMap = new Map<Id,PIR_Detail__c>();
        for(PIR_Detail__c PirD: [select id,status__c,case__c,case__r.CaseNumber,case__r.RecordtypeId from PIR_Detail__c where status__c<>'Closed' and case__c IN :closingCaseMap.keyset()]){
            openPIRDetaisMap.put(PirD.case__c,PirD);
        	system.debug('PirD--->'+PirD.case__r.CaseNumber);
            system.debug('Case RecordtypeId--->'+PirD.case__r.RecordtypeId);
        }
            
        //Throw Error message if criteria met
        for(case cas:closingCaseMap.values()){
            if(openTasksMap.containsKey(cas.Id))
                cas.Status.addError(ACET_FAST_Constants.OpenTasksError); 
            
            if(openPIRDetaisMap.containsKey(cas.Id)){
                PIR_Detail__c pirData = csId_PIRObjectData.get(cas.Id);
                if(validatePIRDetailsToClose(pirData)==false){
                    cas.Status.addError(ACET_FAST_Constants.OpenPIRDetailsError);
                }else{
					pirData.Status__c = 'Closed';
                    listOfPIRData.add(pirData);
                }
            } 
        }
		system.debug('listOfPIRData--->'+listOfPIRData);
		if(listOfPIRData.size()>0)
			update listOfPIRData;
    }
    
    public static void accountNameUpdate(List<Case> triggerNew){
        list<Case> accNullList = new list<Case>();
        list<String> accTinlList = new list<String>();
        for(Case CaseRec: TriggerNew){
            
            if(caseRec.Origin == IMPACT_SYSTEM && caseRec.RecordTypeId == fastRecordTypeId){
                
                if(CaseRec.PC_Provider_TIN__c != null){
                    String tinNumber = '%'+CaseRec.PC_Provider_TIN__c;                   
                    accTinlList.add(tinNumber);
                }else{
                    accNullList.add(CaseRec);
                } 
            }            
            
        }
        system.debug('accTinlList----'+accTinlList.size()+'---'+accTinlList);
        
        map<string,id> accAccountMap = new map<string,id>();
        
        string recordTypeIDPA = ACET_Fast_ProviderContactCtrl.getRecordTypeIdbyDevName('Account','PersonAccount'); 
        if(accTinlList.size()>0){
            for(Account acc : [select id,Name,EID__c,Tax_Id__c from Account where RecordTypeId =: recordTypeIDPA AND EID__c LIKE :accTinlList LIMIT 1000]){
                accAccountMap.put(acc.Tax_Id__c,acc.Id);
            }
        }     
        system.debug('accAccountMap---->'+accAccountMap);
        if(accAccountMap.size()>0){
            for(Case CaseRec: TriggerNew){
                CaseRec.AccountId = accAccountMap.get(CaseRec.PC_Provider_TIN__c);
                system.debug('CaseRec----'+CaseRec.AccountId);
            }
        }
        
        
        
        List<Third_Party__C> thirdPartyList = new List<Third_Party__C>();
        
        for(Case CaseRec: accNullList){
            // insert the third party object record
            Third_Party__c thirdPartRec = new Third_Party__c();
            thirdPartRec.FullName__c = CaseRec.PC_Submitter_First_name__c + ' ' + CaseRec.PC_Submitter_Last_name__c;
            thirdPartRec.First_Name__c = CaseRec.PC_Submitter_First_name__c;
            thirdPartRec.LastName__c = CaseRec.PC_Submitter_Last_name__c;
            thirdPartRec.Tax_ID__c = CaseRec.TaxID__c;
            thirdPartRec.Provider_Type__c = CaseRec.Provider_Type__c;
            thirdPartRec.Case__c = CaseRec.Id;
            thirdPartyList.add(thirdPartRec);           
        }
        insert thirdPartyList;      
    }
    
        public static void handleAfterInsert(List<Case> triggerNew, map<id,Case> triggerOldMap){
        
        List<FeedItem> feedLst = new List<FeedItem>();
        
        for(case caseRec : triggerNew){
            string rectypeName = ACET_FAST_CasePrmsnFldVldtnHelper.getRecordTypeNameById('Case',caseRec.RecordTypeId);
            if(ACET_FAST_Constants.validACETCaseRecordTypes.contains(rectypeName) && caseRec.Comments__c != triggerOldMap.get(caseRec.id).Comments__c ){
                    String postBody;            
                    FeedItem post = new FeedItem();
                    post.ParentId = caseRec.id;
                    postBody = 'Case Updated' ;              
                    postBody += '\n' +'Comments : ' + caseRec.Comments__c; 
                    post.Body = postBody;
                    feedLst.add(post);  
            }
            
        }
        system.debug('Feed List-->'+ feedLst);
        if(feedLst.size()>0){
            Database.insert(feedLst,false);
        }
        
    }
}