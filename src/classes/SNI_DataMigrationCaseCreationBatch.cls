/**
 * US2720791 - Ranjit  
 * Include logic for ACR after 
 */
global class SNI_DataMigrationCaseCreationBatch implements Database.Batchable<sObject>{
    global Database.QueryLocator start(Database.BatchableContext BC) {
        // collect the batches of records or objects to be passed to execute
        
        // US2720791- by pass for the SNI data migration - Inshar - 08/07/2020
        List<String> lsSNImigrationUsers = Label.SNI_DataMigration_Users.split(',');
        String query = Label.SNI_DataMigration_Query;
        return Database.getQueryLocator(query);
    }
     
    global void execute(Database.BatchableContext BC, List<AccountContactRelation> acrList) {
        Set<Id> accountIdSet = new Set<Id>();
        Set<Id> contactIdSet = new Set<Id>();
        Map<Id, Account> accOwnerMap = new Map<Id, Account>();
        Id sniRTId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Case Overview').getRecordTypeId();
        Set<Id> cntWithCases = new Set<Id>();
        List<Case> newSNICases = new List<Case>();
        Map<Id, Set<Id>> accoConMap = new Map<Id, Set<Id>>();
        Map<Id, Set<Id>> contAccMap = new Map<Id, Set<Id>>();
        
        // Assuming that accounts related to one contact will have the same account owner
        Map<Id, Id> cntAccId = new Map<Id, Id>();
        try {
        // process each batch of records default size is 200
        // Get unique Account, Contact Ids
        for(AccountContactRelation acr: acrList) {
            accountIdSet.add(acr.AccountId);
            contactIdSet.add(acr.ContactId);
            
            if(!cntAccId.containsKey(acr.ContactId)) {
                cntAccId.put(acr.ContactId, acr.AccountId);
            }
            
        }
        for(Account acc : [ SELECT ownerId,Legacy_Member_ID__c FROM Account where Id IN: accountIdSet]) {
            if(!accOwnerMap.containsKey(acc.Id)) 
                accOwnerMap.put(acc.Id, acc);
        }
 
              
        // Check Case overview availability
        for(Case c : [ SELECT contactid FROM Case WHERE ContactId IN: contactIdSet AND RecordTypeId =: sniRTId ]) {
            cntWithCases.add(c.contactid);
        }
        
        // Create SNI cases
        Case sniCase;
        
        for(Id contactId: contactIdSet) {
            if(!cntWithCases.contains(contactId)) {
                sniCase = new case();
                sniCase.ownerid = accOwnerMap.get(cntAccId.get(contactId)).ownerId;
                sniCase.ContactId = contactid;
                sniCase.status = 'Open';
                sniCase.UHG_Restriction__c = 'No';
                sniCase.Onshore_Restriction__c = 'No';
                sniCase.recordtypeid = sniRTId;
                sniCase.Case_Type__c = 'Care Plan';
                sniCase.UHG_Restriction__c = 'No';
                sniCase.Subject_Type__c = 'Member';
                sniCase.Onshore_Restriction__c = 'No';
                sniCase.Legacy_Member_ID__c = accOwnerMap.get(cntAccId.get(contactId)).Legacy_Member_ID__c; 
                 
                newSNICases.add(sniCase);
            } 
        }
        if(newSNICases.size() > 0)
        insert newSNICases;
        
        // Create Case Team Member
        List<CaseTeamMember> ctmList = new List<CaseTeamMember>();
        
        if(newSNICases.size() > 0) { 
            
            Map<String, String> caseTeamRole = new Map<String, String>();
            for(CaseTeamRole ct : [ SELECT Id,Name FROM caseTeamRole WHERE Name = 'Advisor' OR Name = 'Family Member' ]) {
                caseTeamRole.put(ct.Name, ct.Id);
            }
        
            for(Case c : newSNICases) {                
                ctmList.add(createCaseTeamMember(c, caseTeamRole.get('Advisor'), 'Advisor'));
                ctmList.add(createCaseTeamMember(c, caseTeamRole.get('Family Member'), 'Family Member'));
            }
            if(ctmList.size() > 0)
            insert ctmList;
        }
         
        } catch(Exception e) {
            System.debug(e);
        }
         
    }   
    private static CaseTeamMember createCaseTeamMember(Case c, Id roleId, String roleType) {
        CaseTeamMember ctm = new CaseTeamMember();
        ctm.ParentId = c.Id;
        if(roleType == 'Advisor') {
            ctm.MemberId = c.ownerId;    
        } else {
            ctm.MemberId = c.ContactId;
        }
        
        ctm.TeamRoleId = roleId;        
        return ctm;
    } 
    global void finish(Database.BatchableContext BC) {
        // execute any post-processing operations like sending email
    }
}