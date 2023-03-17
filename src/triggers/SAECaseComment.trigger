trigger SAECaseComment on CaseComment (before update,before insert, after update, after insert, before delete, after delete) {
    //Trigger to prevent a non SAE user from adding a case comment to an SAE case
    //US2493883
   
    if(trigger.isBefore){
        
        if(trigger.isInsert){
            
            SAECaseCommentTriggerHandler.handleBeforeInsert(trigger.new);
            
        }
        
    }
	
	//Trigger to prevent non FAST/E2E user from adding a case comment to FAST/E2E case
    if (Trigger.isBefore && (Trigger.isInsert || Trigger.isUpdate) && ACET_FAST_CasePrmsnFldVldtnHelper.isFirstTime) {
        ACET_FAST_CasePrmsnFldVldtnHelper.isFirstTime=false;    
        ACET_FAST_CaseCommentsTriggerHandler.caseCommentsValidation(trigger.new);
    }

    //Gets profile name of user creating case comment
   /* Id profileId= userinfo.getProfileId();
    String profileName=[SELECT Id,Name FROM Profile WHERE Id=:profileId].Name;
    system.debug('ProfileName: '+profileName);

    
    
    Set<Id> parentCase=new Set<Id>();
    Map<Id,Case> mapCase=new Map<Id,Case>();
    
    for (CaseComment t: Trigger.new)
    {
        parentCase.add(t.ParentId);
    }
    List<Case> lstCase=[Select Id,RecordType.Name from case where Id in :parentCase ];
    for(case c: lstCase)
    {
        mapCase.put(c.Id,c);
    }   
    for(CaseComment t: Trigger.new)
    {
        if(mapCase.containskey(t.ParentId))
        {
            if((mapCase.get(t.ParentId).RecordType.Name=='SAE Provider'  || mapCase.get(t.ParentId).RecordType.Name=='SAE Provider Closed') && profileName != 'Provider Service')
            {
                t.addError('Case comments on SAE cases are not allowed to be added by non SAE users.');       
            }
        }
    }*/
}