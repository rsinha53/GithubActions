public without sharing class SNI_FL_CareTeamTriggerHandler {
    
    /** Author: Chandan
	    Created Date : 14th September 2020
	    Description : US2736623 :Care Team - Multi Policy Pop Up . 
		Summary: This code is designed for multiple policy 
		When Multi policy member calls to choose second family after he has choosen the first family in the pop up
    **/
    public static void updateCareTeam(Map<Id,SNI_FL_Care_Team_Member__c> newmap,
                                      map<id,SNI_FL_Care_Team_Member__c> oldMap){
    try{
       set<Id> famId= new set<Id>();
       set<Id> accIDs= new set<Id>();       
       //Need to analyse - can data be loaded with existing user to make them visible?                              
       for(SNI_FL_Care_Team_Member__c ctm: newmap.values()){
           if( ctm.SNI_FL_Status__c == 'Registered' 
              && ctm.SNI_FL_Status__c== oldMap.get(ctm.id).SNI_FL_Status__c //If status change -already process is there - This is only for multi policy 
              && oldMap.get(ctm.id).SNI_FL_Not_Visible_in_Familylink__c //Checking only member becomes visible for the family
              && !ctm.SNI_FL_Not_Visible_in_Familylink__c ){
                  famId.add(ctm.SNI_FL_Family__c);
              }                              
       }
                                  
       if(famId!=null && famId.size()>0){

           /** Logic to get existing care team member for that family - Start **/
           Map<Id,Set<Id>> existingMemberMap =new Map<Id,Set<Id>>();
           Map<Id,boolean> primaryCareGiverMap =new Map<Id,boolean>();
           List<SNI_FL_Care_Team_Member__c> ctmList=[Select id,SNI_FL_Family__c,SNI_FL_Member__c,SNI_FL_Status__c,
                                                     SNI_FL_Primary_Caregiver__c,SNI_FL_Not_Visible_in_Familylink__c
                                                     from SNI_FL_Care_Team_Member__c where SNI_FL_Family__c in :famId
                                                     ];  //and SNI_FL_Primary_Caregiver__c=false
           /** Do we need to extra check for non policy care giver too? 
             so No? as non policy should not exist if there is no Primary care giver
             But need to think on family reactivation situation ? - For now we are not considering this **/
                                                     
		      								 
              if(ctmList!=null && ctmList.size()>0){ 
                  for(SNI_FL_Care_Team_Member__c ctm: ctmList){ 
                   if((!primaryCareGiverMap.keySet().contains(ctm.SNI_FL_Family__c))||(!primaryCareGiverMap.get(ctm.SNI_FL_Family__c)))
                      primaryCareGiverMap.put(ctm.SNI_FL_Family__c,ctm.SNI_FL_Primary_Caregiver__c);
                  }
                  
                  for(SNI_FL_Care_Team_Member__c ctm: ctmList){
                   ctm.SNI_FL_Not_Visible_in_Familylink__c = false; //It might be another multi policy member - who is not visible yet for the family -Start
                   if(newmap.keyset().contains(ctm.id)){
                      boolean isPrimaryExist= primaryCareGiverMap.get(ctm.SNI_FL_Family__c);
                      ctm.SNI_FL_Primary_Caregiver__c=isPrimaryExist?false:true;//making that multi policy member as Family Account Owner if there is no existing Family account owner
                   }
                   //Adding Existing member per family -Start
                   if(!existingMemberMap.keySet().contains(ctm.SNI_FL_Family__c)){
                       existingMemberMap.put(ctm.SNI_FL_Family__c, new set<ID>{ctm.SNI_FL_Member__c});                                   
                   }
                   else{
                       set<ID> memIdSet=existingMemberMap.get(ctm.SNI_FL_Family__c);
                       memIdSet.add(ctm.SNI_FL_Member__c);
                       existingMemberMap.put(ctm.SNI_FL_Family__c, memIdSet);                                   
                   }
                   //end
               }
              } //End
           /** Logic to get all person account related to that family and add them to careteam if they are not already added -Start **/
           List<AccountContactRelation> acrList = [SELECT ID,AccountId,contact.accountId from AccountContactRelation where AccountId in :famId];
           if(acrList!=null && acrList.size()>0){
              for(AccountContactRelation acr:acrList){
                  set<id> existingMemId=existingMemberMap.get(acr.AccountId); 
                  if(!existingMemId.contains(acr.contact.accountId)){
                    SNI_FL_Care_Team_Member__c careTeam=  new  SNI_FL_Care_Team_Member__c();
                    careTeam.SNI_FL_Family__c =acr.AccountId;
                    careTeam.SNI_FL_Member__c = acr.contact.accountId;
                    careTeam.SNI_FL_Status__c = 'Added';
                    careTeam.SNI_FL_Not_Visible_in_Familylink__c=false;
                    careTeam.SNI_FL_Added_Date__c = system.today();
                    ctmList.add(careTeam);
                  }
              }
           }
           //End
           if(ctmList!=null && ctmList.size()>0)
              upsert ctmList;
       }
      }catch(Exception e){
         System.debug('Exception happened ='+e);
      }
    }
}