/*------------------------------------------------------------
Author:        Manmeet Kaur
Description:   Controller for AssociatedCases Component  
               
Test Class:    AssociatedCasesControllerTest
History
Date            Author              Comments
-------------------------------------------------------------
09-02-2022      Manmeet Kaur        Created
------------------------------------------------------------*/
public class AssociatedCasesController{
    /*
     * Desc: To get all the existing cases for the member 
     * 		 and display on the datatable
     */
    @AuraEnabled
    public static List <Case> fetchMemberCases(Id caseId) {
        Id ecmRecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('ECM').getRecordTypeId();
        Id closedCaseRecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Case Close').getRecordTypeId();
        //fetching the AccountId of the Member
       
        Id accId = [SELECT 
                    AccountId
                    FROM 
                    Case WHERE Id =: caseId LIMIT 1][0].AccountId;
        //Fetching all the existing cases related to Member
        Map<Id,Case> caseMap = new Map<Id,Case>([SELECT 
                                                  Id,
                                                  CaseNumber,
                                                  Origin, 
                                                  status,
                                                  Case_Name__c  
                                                  FROM 
                                                  Case WHERE ((RecordtypeId =: ecmRecordTypeId AND Status ='Open') OR (RecordtypeId =: closedCaseRecordTypeId AND Status ='Closed'))
                                                  AND AccountId =: accId
                                                  AND Id !=: caseId]);
        system.debug('caseMap::' +caseMap);
        //Checking if any of the cases returned in caseMap has already been associated to the current case, if yes, then skip/remove those
        List<Associated_Cases__c> existingAssociatedCasesLst = [SELECT
                                                                 Id,
                                                                 case__c,
                                                                 Parent_case__c
                                                                 FROM
                                                                 Associated_Cases__c 
                                                                 WHERE (Case__c IN: caseMap.keySet() AND Parent_case__c =: caseId)
                                                                 OR (Parent_Case__c IN: caseMap.keySet() AND case__c =: caseId)];
        if(existingAssociatedCasesLst.size()>0){
            for(Associated_Cases__c associatedCase: existingAssociatedCasesLst){
                if(associatedCase.case__c !=null && associatedCase.Parent_case__c !=null){
                    caseMap.remove(associatedCase.case__c);
                    caseMap.remove(associatedCase.Parent_case__c);
                }
            }
        }
        return caseMap.values();
    }
    /*
     * Desc: To add the associated Case record to relate the cases together
     */
    @AuraEnabled
    public static string addAssociatedCase(List<Case> csLst, Id thisCaseId) {
        try{
            List<Associated_Cases__c> insertAsstdCaseLst = new List<Associated_Cases__c>();
            if(csLst.size()>0){
                for(Case cs: csLst){
                	insertAsstdCaseLst.add(new Associated_Cases__c( Case__c = cs.Id , Parent_case__c = thisCaseId));
                }
                insert insertAsstdCaseLst;
                return 'success';
            }
        }
        catch(Exception ex){
            system.debug('exception occured while creating associated cases : ' + ex.getMessage());
            return 'error';
        }
        return '';
    }
    
    /*
     * Desc: Show related Cases Related List
     */ 
    
	@AuraEnabled
    public static List<AssociatedCasesWrapper> showAssociatedCasesRelatedList(String thisCaseId) {
        List<AssociatedCasesWrapper> associatedCases = new List<AssociatedCasesWrapper>();
		List<Associated_Cases__c> associatedCasesLst = [SELECT 
                                                       Id,
                                                       Case__c,
                                                       Case__r.CaseNumber,
                                                       Case__r.Status,
                                                       Case__r.Origin,
                                                       Case__r.Case_Name__c,
                                                       Parent_Case__c,
                                                       Parent_Case__r.CaseNumber,
                                                       Parent_Case__r.Status,
                                                       Parent_Case__r.Origin,
                                                       Parent_Case__r.Case_Name__c
                                                       FROM
                                                       Associated_Cases__c
                                                       WHERE
                                                       Case__c =: thisCaseId 
                                                       OR Parent_Case__c =: thisCaseId]; 
        
        for(Associated_Cases__c asstCs : associatedCasesLst){
            if(asstCs.Parent_Case__c!=thisCaseId){
               associatedCases.add(new AssociatedCasesWrapper(asstCs.Id,asstCs.Parent_Case__c,asstCs.Parent_Case__r.CaseNumber,asstCs.Parent_Case__r.Case_Name__c,asstCs.Parent_Case__r.Status,asstCs.Parent_Case__r.Origin));
            }
            if(asstCs.Case__c!=thisCaseId){
               associatedCases.add(new AssociatedCasesWrapper(asstCs.Id,asstCs.Case__c,asstCs.Case__r.CaseNumber,asstCs.Case__r.Case_Name__c,asstCs.Case__r.Status,asstCs.Case__r.Origin));
            }
        }
        return associatedCases;
    }

    @AuraEnabled
    public static void delCase(Id AssosiateCaseId){
        delete (new Associated_Cases__c(Id = AssosiateCaseId));
    }
    
    public class AssociatedCasesWrapper{
        @AuraEnabled
        public Id AssosiateCaseId;
        @AuraEnabled
        public Id CaseId;
        @AuraEnabled
        public string CaseNumber;
        @AuraEnabled
        public string CaseName;
        @AuraEnabled
        public string CaseStatus;
        @AuraEnabled
        public string CaseOrigin;      

        public AssociatedCasesWrapper(id AssosiateCaseId,id AssCaseId, string AssCaseNumber, string AssCaseName, string AssCaseStatus, string AssCaseOrigin){
            this.AssosiateCaseId = AssosiateCaseId;
            this.CaseId = AssCaseId;
            this.CaseNumber = AssCaseNumber;
            this.CaseName = AssCaseName;  
            this.CaseStatus = AssCaseStatus;           
            this.CaseOrigin = AssCaseOrigin;
        }

    }
    //added by Ravi teja end
}