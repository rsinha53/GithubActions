public without sharing class SNI_FL_MultiplePolicyPopUpController {


    /** Author: Chandan
	    Created Date : 10th September 2020
	    Description : US2736618: Care Team - Multi Policy Pop Up - UI 
		Summary: This code is designed for multiple policy Pop up so that agent the guide the user to bring that family to Family Link
    **/
	
    @AuraEnabled
    public static List<SNI_FL_Care_Team_Member__c> getFamilyInfo(ID recordId){
        System.debug('personAccountId='+recordId);
        List<String> statusCheck=new list<String>{('Added'),('Invited')};
        List<SNI_FL_Care_Team_Member__c> ctmList=new List<SNI_FL_Care_Team_Member__c>();
                                                  
        set<id> famIds=new set<id>();
        Map<Id,boolean> primaryCareGiverMap =new Map<Id,boolean>();
        Map<Id,SNI_FL_Care_Team_Member__c> famCareTeamMap=new Map<Id,SNI_FL_Care_Team_Member__c>();
        try{
        for(SNI_FL_Care_Team_Member__c ctm:[SELECT ID, SNI_FL_Member__c,SNI_FL_Member__r.Name,
                                              SNI_FL_Family__c,SNI_FL_Family__r.Name,SNI_FL_Family__r.Member_ID__c,
                                              SNI_FL_Family__r.Policy_ID__c,SNI_FL_Not_Visible_in_Familylink__c
                                              FROM SNI_FL_Care_Team_Member__c where 
                                              SNI_FL_Member__c =:recordId and SNI_FL_Family__c!=null 
                                              and SNI_FL_Member__r.MultiPolicyCheck__c =true //and SNI_FL_Not_Visible_in_Familylink__c=true
                                              and SNI_FL_Status__c in :statusCheck]){
                famCareTeamMap.put(ctm.SNI_FL_Family__c,ctm);  //As we have one same member for one family
            }
            
            for(SNI_FL_Care_Team_Member__c ctm:[SELECT ID, SNI_FL_Primary_Caregiver__c, SNI_FL_Family__c
                                                  FROM SNI_FL_Care_Team_Member__c where 
                                                  SNI_FL_Family__c in:famCareTeamMap.keyset()]){
               if((!primaryCareGiverMap.keySet().contains(ctm.SNI_FL_Family__c))||(!primaryCareGiverMap.get(ctm.SNI_FL_Family__c)))
                      primaryCareGiverMap.put(ctm.SNI_FL_Family__c,ctm.SNI_FL_Primary_Caregiver__c);
            }
            
            for(ID fam:famCareTeamMap.keyset()){
                 boolean isPrimaryExist= primaryCareGiverMap.get(fam);
                 System.debug('isPrimaryExist='+isPrimaryExist);
                 if(isPrimaryExist==null || !isPrimaryExist)
                    ctmList.add(famCareTeamMap.get(fam)); 
            }
        }catch(Exception e){
         System.debug('Exception happened ='+e);
        }
        return ctmList;
    }
    
    @AuraEnabled
    public static void updateCareTeam(list<Id> ctmIdSet, Id personAccountId){
        System.debug('ctmIdSet='+ctmIdSet);
        try{
        List<SNI_FL_Care_Team_Member__c> ctmList=[SELECT Id, SNI_FL_Not_Visible_in_Familylink__c FROM SNI_FL_Care_Team_Member__c where 
                                                  id not in :ctmIdSet and SNI_FL_Member__c =:personAccountId];
        System.debug('ctmList='+ctmList);
		/** Logic: As by default visiblility is given to careteam member
		So here those Care Team record would be updated not to visible ,which have not selected in the pop up by the agent **/
        if(ctmList!=null && ctmList.size()>0){
            for(SNI_FL_Care_Team_Member__c ct:ctmList){
                ct.SNI_FL_Not_Visible_in_Familylink__c =true;//
            }
		  update ctmList; 
		  
		  /** Logic: Multi policy status would be updated back ,so that pop up should not come **/
		  Account acct = new Account(Id=personAccountId,MultiPolicyCheck__c=false);
          update acct;
        }
       }catch(Exception e){
         System.debug('Exception happened ='+e);
       }
    }
}