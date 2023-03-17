trigger SNI_FL_MembersROI  on SNI_FL_Members_ROI__c (after update,before update) {
    /*if(trigger.isbefore){
        for(SNI_FL_Members_ROI__c memROI : trigger.new){
            string oldStatus = trigger.oldmap.get(memROI.id).SNI_FL_Status__c;
            if(oldStatus == 'Pending' && memROI.SNI_FL_Status__c == 'Active'){
                memROI.SNI_FL_ROI_Signed_Date__c = system.today();
            }
        }
    }*/
    //Code Added By Chandan -Start -US3008715: Family Link -Expired ROI
    if(trigger.isbefore){
      if(trigger.isUpdate){
       SNI_FL_MemberROI_TriggerHelper.updateExpirationDate(trigger.new,trigger.oldmap);
       SNI_FL_MemberROI_TriggerHelper.checkROIStatus(trigger.new,trigger.oldmap);
      }
    }
    //End
    if(trigger.isafter){
        set<string> setStr = new set<string>();
        List<SNI_FL_Members_ROI__c> lstActiveMemberROIs = new List<SNI_FL_Members_ROI__c>();//Added by ACDC for US3059977
        for(SNI_FL_Members_ROI__c memROI : trigger.new){
            string oldStatus = trigger.oldmap.get(memROI.id).SNI_FL_Status__c;
            if(oldStatus == 'Pending' && memROI.SNI_FL_Status__c == 'Active'){
                setStr.add(memROI.SNI_FL_Member__c);
                lstActiveMemberROIs.add(memROI);//Added by ACDC for US3059977
               
            }
        }
        if(setStr.size()>0){
            SNI_FL_MemberROI_TriggerHelper.changeCareTeamRecStatus(setStr);
        }
        string curMembrEmail ;
        set<Id> setPendingStr = new set<Id>();
        for(SNI_FL_Members_ROI__c memROI : trigger.new){
            string oldStatus = trigger.oldmap.get(memROI.id).SNI_FL_Status__c;
            if(oldStatus == 'InActive' && memROI.SNI_FL_Status__c == 'Pending'){
			    curMembrEmail = memROI.SNI_FL_Signed_Email__c;
                setPendingStr.add(memROI.SNI_FL_Member__c);
            }
        }
        if(setPendingStr.size()>0){
        
            SNI_FL_MemberROI_TriggerHelper.SendEmailtoROI(setPendingStr,curMembrEmail);
        }

        //Added by ACDC for US3059977
        for(SNI_FL_Members_ROI__c memberROI : Trigger.new){
            String oldStatus = Trigger.oldMap.get(memberROI.id).SNI_FL_Status__c;   
            if(oldStatus == 'InActive' && memberROI.SNI_FL_Status__c == 'Active'){
                lstActiveMemberROIs.add(memberROI);
            }
        }

        if(lstActiveMemberROIs.size()>0){

            if(!SNI_FL_MemberROI_TriggerHelper.isAuthorizedMemberAdded){
                SNI_FL_MemberROI_TriggerHelper.addAuthorizedMemberToCaseTeam(lstActiveMemberROIs);
                SNI_FL_MemberROI_TriggerHelper.isAuthorizedMemberAdded = true;
            }
        }
        //Added by ACDC end for US3059977
    }
    
    //  SNI_FL_MemberROI_TriggerHelper.SendEmailtoROI(trigger.old,trigger.new);
}