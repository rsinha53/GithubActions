public class DeactivateUserToRemoveMember implements Queueable {

    public List<String> careTeamId;
    public String familyId;

    public DeactivateUserToRemoveMember(List<String> careTeamId, String familyId){
        this.careTeamId = careTeamId;
        this.familyId = familyId;
    }
    public void execute(QueueableContext context) {
        boolean result = false;
        boolean isPrimaryCaregiver = false;
        List<Id> careTeamIds= new List<Id>();
        List<Id> multiplecareTeam = new List<Id>();
        Map<Id,SNI_FL_Care_Team_Member__c> careTeamMap = new Map<Id,SNI_FL_Care_Team_Member__c>();
       try{
        List<user> userDeactivateList = new List<User>();
        System.debug('personAccountIds='+careTeamId);
          if(careTeamId!=null && careTeamId.size()>0){
                //check whether the user have anyother family associated with to inactivate the user
              List<SNI_FL_Care_Team_Member__c> fctm  = [SELECT Id,SNI_FL_Family__c,SNI_FL_Member__c,SNI_FL_Not_Visible_in_Familylink__c,SNI_FL_Primary_Caregiver__c From SNI_FL_Care_Team_Member__c
                                                          WHERE SNI_FL_Member__c =:careTeamId and SNI_FL_Family__c =:familyId];  
              if(fctm.size()>0 && fctm[0].SNI_FL_Primary_Caregiver__c==true){
                    isPrimaryCaregiver = true;
                    if(String.isNotBlank(familyId) && isPrimaryCaregiver){
                        //loop to fetch all the members of that family
                        for(SNI_FL_Care_Team_Member__c ctMembers : [SELECT Id,SNI_FL_Family__c,SNI_FL_Member__c From SNI_FL_Care_Team_Member__c
                                                                    WHERE SNI_FL_Family__c =:familyId]){
                            careTeamMap.put(ctMembers.SNI_FL_Member__c,ctMembers);
                                                                    }
                        //loop to check the each member for dual policy
                        for(SNI_FL_Care_Team_Member__c cTFamily : [SELECT Id,SNI_FL_Family__c,SNI_FL_Member__c From SNI_FL_Care_Team_Member__c
                                                                   WHERE SNI_FL_Member__c in :careTeamMap.keyset() AND SNI_FL_Family__c != :familyId and SNI_FL_Status__c = 'Registered' and SNI_FL_Not_Visible_in_Familylink__c != true]){
                            multiplecareTeam.add(cTFamily.SNI_FL_Member__c);
                                                                   }
                        //to get the list with non multiple policy members
                        for(Id ct :careTeamMap.keySet()){
                            if(!multiplecareTeam.contains(ct)){
                                careTeamIds.add(careTeamMap.get(ct).SNI_FL_Member__c);
                            }
                        }
                    }
                }
              //if the current user is not a FAO and have multiple policy
                else if(fctm.size()>0 && fctm[0].SNI_FL_Primary_Caregiver__c !=true){
                    List<SNI_FL_Care_Team_Member__c> fctmLst =[ SELECT Id,SNI_FL_Family__c,SNI_FL_Member__c,SNI_FL_Not_Visible_in_Familylink__c,SNI_FL_Primary_Caregiver__c From SNI_FL_Care_Team_Member__c
                                                               WHERE SNI_FL_Member__c =:careTeamId and SNI_FL_Family__c !=:familyId and SNI_FL_Status__c = 'Registered' and SNI_FL_Not_Visible_in_Familylink__c != true];
                    if(fctmLst.size()==0){
                        careTeamIds.add(fctm[0].SNI_FL_Member__c);
                    }
                }
              
           if(careTeamIds.size()>0){
                    for(User userUpdateRec : [SELECT Id,isActive From user where contact.accountId in : careTeamIds]){
                        userUpdateRec.isActive = false;
                        userDeactivateList.add(userUpdateRec);
                    }
                    if(userDeactivateList!=null && userDeactivateList.size()>0){
                        system.debug('userupdatelist'+ userDeactivateList);
                        update userDeactivateList;
                        result=true;
                    }
                }
      }
       }
      catch(Exception e){
         System.debug('Exception happened='+e);
            AcetUtility.CreateAndRedirectToError('FamilyLink','SNI_FL_DeleteAccountController',e);        
      }
      System.debug('User deactivation Status='+result);
    }
}