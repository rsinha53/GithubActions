/********************************************************************************* 
Class Name     : SNI_FL_CaseToROIHelper.cls
Description    : This class is created to get ROI registered/active person
                 account and send email and sms
Created By     : Balakrishnan
Created Date   : 10/08/2020

Modification Log
---------------------------------------------------------------------------------- 
Developer                   Date                   Description
1.Srilakshmi                10/08/2020				Bulkified code                       
----------------------------------------------------------------------------------            

*********************************************************************************/
public class SNI_FL_CaseToROIHelper {
    
    public static void retriveROIMembersByCaseId(Case caseToRetrieveROI){
        String caseId = caseToRetrieveROI.Id;
        String contactId = caseToRetrieveROI.ContactId;
        String memberId = caseToRetrieveROI.ID__c;
        String policyId = caseToRetrieveROI.Subject_Group_ID__c;
        String caseAccountId = caseToRetrieveROI.AccountId;
        
        Map<id,String> signedAccountMap = new Map<id,String>();
        //Get ACR record (Family Account - AccountId) using the ContactId, Policy_Id (Subject Group Id), and MemberId (ID__c - subject Id) in first query
        List<AccountContactRelation> AccountconList = [SELECT Account.Member_ID__c, AccountId, ContactId, Account.Policy_ID__c 
                                                       FROM AccountContactRelation
                                                       WHERE ContactId = :contactId and Account.Policy_ID__c  =:policyId 
                                                       and Account.Member_ID__c =:memberId];
        
        if(!AccountconList.isEmpty()){
            List<Id> accountIds = new List<Id>();
            for(AccountContactRelation ac:AccountconList){
                accountIds.add(ac.AccountId);
            }
            if(!accountIds.isEmpty()){
                //Retrieve Case Team Member records using family account Id from above query
                //Filter the results by caseAccountId (person account Id) as we want to get the record only for member / person who owns the Case
                List<SNI_FL_Care_Team_Member__c> TeamMemList = [Select id,SNI_FL_Authorized__c,SNI_FL_Status__c,SNI_FL_Family__c,SNI_FL_Member__c,
                                                                SNI_FL_Member__r.name,SNI_FL_Primary_Caregiver__c,SNI_FL_Not_Visible_in_Familylink__c 
                                                                FROM SNI_FL_Care_Team_Member__c where SNI_FL_Family__c in :accountIds 
                                                                and SNI_FL_Status__c = 'Registered'];

                if(!TeamMemList.isEmpty()){
                    List<Id> memberIds = new List<Id>();
                    List<Id> teamMemIds = new List<Id>();
                    List<Id> retrieveROIByTeamMemberId = new List<Id>();
                    
                    for(SNI_FL_Care_Team_Member__c ctm : TeamMemList ){
                        Id personAccountId = ctm.SNI_FL_Member__c;
                        
                        //Check for the record in care team member that belongs to the person who owns given case
                        //This care team member Id will be used to retrieve member ROI records (for given person account)
                        if (personAccountId == caseAccountId && !memberIds.contains(personAccountId)) {
                            memberIds.add(personAccountId);
                            retrieveROIByTeamMemberId.add(ctm.Id);
                        }
                        teamMemIds.add(ctm.Id);
                        signedAccountMap.put(ctm.Id,ctm.SNI_FL_Member__c);
                    }
                    
                    if(!teamMemIds.isEmpty() ){
                        //Retrieve Member ROI data based on above query
                        List<SNI_FL_Members_ROI__c> RoiAccountList = [SELECT Id,SNI_FL_Status__c, SNI_FL_Account__c,SNI_FL_Account__r.isPersonAccount, SNI_FL_Signed_Email__c, SNI_FL_Type__c,
                                                                      SNI_FL_ROI_Signed_Date__c, SNI_FL_ROI_Signed_With__c, SNI_FL_Member__c
                                                                      FROM SNI_FL_Members_ROI__c where SNI_FL_Member__c IN :retrieveROIByTeamMemberId and SNI_FL_Status__c = 'Active'];
                        
                        try {
                            //If RoiAccountList is not empty then get SNI_FL_ROI_Signed_With__c (authorized Members)
                            //Else send notification only to SNI_FL_Member__c (Member)
                            if (!RoiAccountList.isEmpty()) {
                                for(SNI_FL_Members_ROI__c mr : RoiAccountList ){
                                    if(signedAccountMap.containsKey(mr.SNI_FL_ROI_Signed_With__c)){
                                        memberIds.add(signedAccountMap.get(mr.SNI_FL_ROI_Signed_With__c));
                                    }
                                }
                            }
                            
                            //Send Email/SMS notifications to member (person account) and to all members who signed ROIs with case owner
                            for (Id memId : memberIds) {
                                SNI_FL_Notification_Center.SendNotification(memId);
                            }
                        } catch (Exception e) {
                            //Handling exception gracefully because this shouldn't throw an exception on front-end/UI and shouldn't block other events
                            System.debug(LoggingLevel.WARN, 'Blinker Exception - Something went wrong while sending Email or SMS Notification: ' + e.getMessage());
                        }
                    }
                }
            }
        }
    }
    
    //For the given caseId, retrieve data if the case is SENS Case and visible in FamilyLink
    public static void handleNotificationsForCaseComment(List<Id> caseIds) {
        boolean SniFlUserPermission = checkForPermission();
        //check for SNI_FL_UserPermission
        if(SniFlUserPermission){
        	List<Id> caseIdList = New List<Id>();
        	List<Id> recordTypeIds = new List<Id>();
        	recordTypeIds.add(Schema.SObjectType.Case.getRecordTypeInfosByName().get('ECM').getRecordTypeId());
        	recordTypeIds.add(Schema.SObjectType.Case.getRecordTypeInfosByName().get('Case Close').getRecordTypeId());
        
        	List<Case> caseList = [select AccountId, ContactId, ID__c, Contact.EID__c, Member_Relationship__c, Policy_Number__c, Subject_Group_ID__c, Community__c, Case_Type__c from case
            	                   where Id =: caseIds and Community__c = true and Case_Type__c = 'Opportunity'
                	               and recordtypeid = :recordTypeIds];
        	for(Case caseToRetrieveROI : caseList){
            	SNI_FL_CaseToROIHelper.retriveROIMembersByCaseId(caseToRetrieveROI);
        	}   
        }
    }
    
    //Check for permission set
    public static Boolean checkForPermission() {
      boolean isActive = false; 
      List<PermissionSetAssignment> lstCurrentUserPerSet = [select Id, PermissionSet.Name, PermissionSet.label, AssigneeId 
                                                      FROM PermissionSetAssignment  
                                                      WHERE AssigneeId =:UserInfo.getUserId()  
                                                      AND PermissionSet.Name = 'FamilyLink_Manage_External_Users']; 
	 
	  if(!lstCurrentUserPerSet.isEmpty()){
          isActive = true; 
      } 
      return isActive;
    }
    
    
    
}