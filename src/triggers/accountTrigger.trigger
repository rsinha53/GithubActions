trigger accountTrigger on Account (before insert, after insert,
                                    before update, after update,
                                    before delete, after delete) {

    if (Trigger.isBefore) { 
        if (Trigger.isInsert) {
            ACETAccountTriggerHandler accHandler = new ACETAccountTriggerHandler(null, Trigger.newMap);
            accHandler.DuplicateNameCheckname(trigger.new);
            accHandler.updateEligibilyApiField(trigger.new); //added by Ranjit for eligibility..
        }
        if (Trigger.isUpdate) {
            ACETAccountTriggerHandler accHandler = new ACETAccountTriggerHandler(Trigger.oldMap, Trigger.newMap);
            accHandler.updateEligibilyApiField(trigger.new); //added by Ravi for eligibility..
            accHandler.nameChangeValidation(trigger.new,Trigger.oldMap);                 
        }
        if (Trigger.isDelete) {

        }
    }

    if (Trigger.isAfter) {
        if (Trigger.isInsert) {
            ACETAccountTriggerHandler accHandler = new ACETAccountTriggerHandler(null, Trigger.newMap);
        }
        Boolean chngOwnr = false;
        if (Trigger.isUpdate) {
            
            if(RecursiveTriggerHandler.HSIDAccTrigAftUpdtFlg != true){
            ACETAccountTriggerHandler accHandler = new ACETAccountTriggerHandler(Trigger.oldMap, Trigger.newMap);
            accHandler.updateComplexIndicator(trigger.new,Trigger.oldMap);
             
            //ACETAccountTriggerHandler accHandler = new ACETAccountTriggerHandler(Trigger.oldMap, Trigger.newMap);            
            for(Account acc: Trigger.new){
                Account oldAccount = Trigger.oldMap.get(acc.Id);      
                if(acc.OwnerId != oldAccount.OwnerId)
                chngOwnr = true;  
            system.debug('***'+acc.OwnerId+'***'+oldAccount.OwnerId) ;   
            }
            if(chngOwnr)
            ACETAccountTriggerHandler.changeOwnerValidation(trigger.newMap, trigger.oldMap);
                       
            accHandler.workorderStatusUpdate();

            //accHandler.workorderStatusUpdate();
            //ACETAccountTriggerHandler.changeOwnerValidation(trigger.newMap, trigger.oldMap);
            ACETAccountTriggerHandler.getEmail(Trigger.new , trigger.oldMap);
            //added by srilakshmi// 
            ACETAccountTriggerHandler.getEmailIdAndDob(Trigger.new , trigger.oldMap);
            /*US2732016: Care Team - Display Care Team on Family Page -Populated*/
            //ACETAccountTriggerHandler.createCareTeamMembers(Trigger.new , trigger.oldMap);
            /* US2736623: Care Team - Multi Policy Pop Up - Family Advisor select FLAO Families */
            ACETAccountTriggerHandler.createCareTeamList(Trigger.newMap , trigger.oldMap);
         
            //Sameera De Silva (ACDC) DE397810
           if(!SNI_FL_MessageStatusChecker.isExecuted && !System.isFuture()){      
                ACETAccountTriggerHandler.executeBatch(Trigger.newMap,Trigger.oldMap);  
                SNI_FL_MessageStatusChecker.isExecuted = true;
           }
           if(Test.isRunningTest() || RecursiveTriggerHandler.HSIDPlguinFlg)
           RecursiveTriggerHandler.HSIDAccTrigAftUpdtFlg = true;
        } 
        }
        if (Trigger.isDelete) {
    
        }
    }

}