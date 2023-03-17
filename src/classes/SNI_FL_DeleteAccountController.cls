public without sharing class SNI_FL_DeleteAccountController {
    
    @auraEnabled
    Public Static void authenticatePassword(String password){
        System.debug('password='+password);
        site.login(UserInfo.getUserName(), password,'');
       
    }
    @auraEnabled
    public static Boolean HSIDmemUrls() {
            User u = [select Id , AccountId, profile.name from User where Id = :UserInfo.getUserId()];             
            Account acc = [Select ID, PersonContactID    from Account where ID= :u.AccountId];            
            List<AccountContactRelation> lsacr = [ SELECT Member_ID__c, account.alternate_id__c  FROM AccountContactRelation WHERE  ContactID  = :acc.PersonContactID];            
            Boolean isMember = false;
            if (!lsacr.isEmpty() && lsacr.size() > 0) {
                for(AccountContactRelation acr : lsacr) {
                    if (acr.Member_ID__c != null || !String.isBlank(acr.Member_ID__c)) {
                        System.debug('mem id is ->'+acr.Member_ID__c);
                        
                        isMember = true;
                    }                
                   
                }
            }
     
            return isMember;
    }
    
    
    @auraEnabled
    /**This method is to update the careteam reocrds on the deactivation of user record**/
    Public static void careTeamUpdate(String familyId){
        List<Id> careTeamList= new List<Id>();
		User loginUser = [select id,IsActive,IsPortalEnabled,contactId,contact.accountId from User where id =:UserInfo.getUserId()];   
       Id personAccountId = loginUser.contact.accountId;
       System.debug('personAccountId='+personAccountId);
        boolean isPrimaryCaregiver = false;
        Map<Id,SNI_FL_Care_Team_Member__c> careTeamMap = new Map<Id,SNI_FL_Care_Team_Member__c>();
        List<Id> multiplecareTeam = new List<Id>();
        List<SNI_FL_Care_Team_Member__c> careTeamUpdateLst = new List<SNI_FL_Care_Team_Member__c>();
       //Below code need to be refractored once care team object is fully configured.
       //As Currently care team is not fully configured 
       //We need to manually load them into system
        try{
       if(personAccountId != null){
                //Check the current user is FAO or not
                List<SNI_FL_Care_Team_Member__c> fctm  = [SELECT Id,SNI_FL_Family__c,SNI_FL_Member__c,SNI_FL_Non_Policy_Member__c,SNI_FL_Not_Visible_in_Familylink__c,SNI_FL_Primary_Caregiver__c From SNI_FL_Care_Team_Member__c
                                                          WHERE SNI_FL_Member__c =:personAccountId and SNI_FL_Family__c =:familyId];
          
                if(fctm.size()>0 && fctm[0].SNI_FL_Primary_Caregiver__c==true){
                    isPrimaryCaregiver = true;
                    // If logged in User is FAO the updation of all the members
                    if(String.isNotBlank(familyId) && isPrimaryCaregiver){
                        //loop to fetch all the members of that family
                        for(SNI_FL_Care_Team_Member__c ctMembers : [SELECT Id,SNI_FL_Family__c,SNI_FL_Member__c From SNI_FL_Care_Team_Member__c
                                                                    WHERE SNI_FL_Family__c =:familyId]){
                             careTeamList.add(ctMembers.Id);
            }
              }
           }
                //if the user is not a account owner only single member delete
           else{
        
                    careTeamList.add(fctm[0].Id);
                  }
              }
                  
          
            if(careTeamList.size()>0){
                for(SNI_FL_Care_Team_Member__c careTeam : [SELECT ID,SNI_FL_Family__c,SNI_FL_Authorized__c,SNI_FL_Member__c,SNI_FL_Status__c,SNI_FL_Removed_Date__c,SNI_FL_Not_Visible_in_Familylink__c,SNI_FL_Non_Policy_Member__c FROM SNI_FL_Care_Team_Member__c WHERE Id in :careTeamList]){
                    //If the user is FAO the we shall mark the members are not visible to satisfy the Multiple policy conditions(only see the family they are active on)
                    if(isPrimaryCaregiver){
                        careTeam.SNI_FL_Not_Visible_in_Familylink__c = true;
                    }
                    careTeam.SNI_FL_Status__c = 'Removed';
                    careTeam.SNI_FL_Removed_Date__c = system.today();
                    careTeam.SNI_FL_Authorized__c=false;
                    careTeamUpdateLst.add(careTeam);
                }
                if(careTeamUpdateLst.size()>0){
                    update careTeamUpdateLst;
                }
            }
        }
        catch(Exception e){
            System.debug('Exception happened='+e);
            AcetUtility.CreateAndRedirectToError('FamilyLink','SNI_FL_DeleteAccountController',e);
        }
    }
    //As there is mixed dml and dependance on the dml action the apex is called twice from controller
    //to perform careteam updtion and the user deactivation in differnt transactions
    @auraEnabled
    Public static List<Id> deactivateUser(String familyId){
        List<Id> careTeamIds= new List<Id>();
        User loginUser = [select id,IsActive,IsPortalEnabled,contactId,contact.accountId from User where id =:UserInfo.getUserId()];
        Id personAccountId = loginUser.contact.accountId;
        System.debug('personAccountId='+familyId);
        boolean isPrimaryCaregiver = false;
        Map<Id,SNI_FL_Care_Team_Member__c> careTeamMap = new Map<Id,SNI_FL_Care_Team_Member__c>();
        List<Id> multiplecareTeam = new List<Id>();
        List<user> userDeactivateList = new List<User>();
        if(personAccountId != null){
            //Check the current user is FAO or not
            try{
                List<SNI_FL_Care_Team_Member__c> fctm  = [SELECT Id,SNI_FL_Family__c,SNI_FL_Member__c,SNI_FL_Not_Visible_in_Familylink__c,SNI_FL_Primary_Caregiver__c From SNI_FL_Care_Team_Member__c
                                                          WHERE SNI_FL_Member__c =:personAccountId and SNI_FL_Family__c =:familyId];
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
                                                               WHERE SNI_FL_Member__c =:personAccountId AND SNI_FL_Family__c != :familyId and SNI_FL_Status__c = 'Registered' and SNI_FL_Not_Visible_in_Familylink__c != true];
                    if(fctmLst.size()==0){
                        careTeamIds.add(fctm[0].SNI_FL_Member__c);
                    }
                }
                //if any of the condition not satisfied
                else{
                    careTeamIds.add(fctm[0].SNI_FL_Member__c);
                }
            
                if(careTeamIds.size()>0){
                    for(User userUpdateRec : [SELECT Id,isActive From user where contact.accountId in : careTeamIds]){
                        userUpdateRec.isActive = false;
                        userDeactivateList.add(userUpdateRec);
        }
                    if(userDeactivateList!=null && userDeactivateList.size()>0){
                        system.debug('userupdatelist'+ userDeactivateList);
                        update userDeactivateList;
                    }
                }
            }
        catch(Exception e){
            System.debug('Exception happened='+e);
            AcetUtility.CreateAndRedirectToError('FamilyLink','SNI_FL_DeleteAccountController',e);
            }
        }
        return careTeamIds;
    }
    
    /**This method is to update the careteam reocrds on the Removal of Non-Policy CareGiver */
    public static void careTeamUpdateStatus(List<String> careTeamId){
       try{
       System.debug('personAccountIds='+careTeamId);
        if(careTeamId!=null && careTeamId.size()>0){   
          List<SNI_FL_Care_Team_Member__c> careTeamUpdateLst = new List<SNI_FL_Care_Team_Member__c>();
                for(SNI_FL_Care_Team_Member__c careTeam : [SELECT ID,SNI_FL_Family__c,SNI_FL_Authorized__c,SNI_FL_Member__c,SNI_FL_Status__c,SNI_FL_Removed_Date__c,SNI_FL_Not_Visible_in_Familylink__c,SNI_FL_Non_Policy_Member__c FROM SNI_FL_Care_Team_Member__c WHERE Id in :careTeamId]){
                    if(careTeam.SNI_FL_Non_Policy_Member__c){
                        careTeam.SNI_FL_Not_Visible_in_Familylink__c = true;
                    }
                    careTeam.SNI_FL_Status__c = 'Removed';
                    careTeam.SNI_FL_Removed_Date__c = system.today();
                    careTeam.SNI_FL_Authorized__c=false;
                    careTeamUpdateLst.add(careTeam);
                }
                if(careTeamUpdateLst.size()>0){
                    update careTeamUpdateLst;
                }
            }
            
        }
        catch(Exception e){
            System.debug('Exception happened='+e);
            AcetUtility.CreateAndRedirectToError('FamilyLink','SNI_FL_DeleteAccountController',e);
        }
    }
    
    /**This method is to update the User reocrds on the Removal of Non-Policy CareGiver */
    public static boolean updateUserRec(List<String> careTeamId, String familyId){
         boolean result=false;
       try{
        List<user> userDeactivateList = new List<User>();
        System.debug('personAccountIds='+careTeamId);
          if(careTeamId!=null && careTeamId.size()>0){
                //check whether the user have anyother family associated with to inactivate the user
                List<SNI_FL_Care_Team_Member__c> careTeamRec = [Select SNI_FL_Member__c from SNI_FL_Care_Team_Member__c where SNI_FL_Member__c in :careTeamId and SNI_FL_Family__c != :familyId and SNI_FL_Status__c = 'Registered' and SNI_FL_Not_Visible_in_Familylink__c != true];
                if(careTeamRec.size() == 0){
                    for(User u: [Select id,IsActive,IsPortalEnabled from User where contact.accountId in  : careTeamId
                                 and IsActive=true]){
                      u.IsActive=false;
                      userDeactivateList.add(u);
                  }
              }
          }
       if(userDeactivateList!=null && userDeactivateList.size()>0){
           update userDeactivateList;
           result=true;
       }
      }
      catch(Exception e){
         System.debug('Exception happened='+e);
            AcetUtility.CreateAndRedirectToError('FamilyLink','SNI_FL_DeleteAccountController',e);        
      }
      System.debug('User deactivation Status='+result);
      return result;
    }
    
    public static boolean updateUserRecForFamily(List<String> careTeamId, String familyId){
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
      return result;
    }
}