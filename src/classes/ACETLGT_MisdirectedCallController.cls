public class ACETLGT_MisdirectedCallController {
    
    @AuraEnabled
    public static Case createMisdirectCase(Id intId,String intType,String srk, String callTopic,ACETLGT_HighlightPanelInfo highlightsPanelInfo){        
        system.debug('=====Create misdirect case controller'+highlightsPanelInfo);
        
        Case CaseObj = new Case();
        CaseObj.Status='Canceled';
        
        Interaction__c interaction = new Interaction__c();
        
        if(!String.isEmpty(intId)){
            interaction = [SELECT Id, Interaction_Type__c FROM Interaction__c where Id =: intId LIMIT 1];
        }
        else{
            //Interaction__c interaction = new Interaction__c();
            interaction.Interaction_Type__c= intType;
            insert interaction;
        }
        CaseObj.Topic__c = callTopic;
        CaseObj.Interaction__c = interaction.Id;
        CaseObj.Surrogate_Key__c = srk;
        CaseObj.Origin = interaction.Interaction_Type__c;
        //CaseObj.ContactId = '';
        //CaseObj.Subject_Type__c 
        //CaseObj.Origin = Interaction.Interaction_Type__c; or CaseObj.Origin = SourceOriginator;
        
        if(highlightsPanelInfo != null){
            CaseObj.Onshore_Restriction_Code__c = highlightsPanelInfo.onshoreCode != '' && highlightsPanelInfo.onshoreCode != null?highlightsPanelInfo.onshoreCode:'00';
            CaseObj.Onshore_Restriction__c = highlightsPanelInfo.onshoreValue != '' && highlightsPanelInfo.onshoreValue != null?highlightsPanelInfo.onshoreValue:'No';
            CaseObj.DOB__c	= highlightsPanelInfo.MemberDOB != '' && highlightsPanelInfo.MemberDOB != null?highlightsPanelInfo.MemberDOB:'';
            CaseObj.ID__c =  highlightsPanelInfo.MemberId != '' && highlightsPanelInfo.MemberId != null?highlightsPanelInfo.MemberId:'';
            CaseObj.Subject_Group_ID__c  = highlightsPanelInfo.GroupNumber != '' && highlightsPanelInfo.GroupNumber != null?highlightsPanelInfo.GroupNumber:'';
        	CaseObj.ContactId= highlightsPanelInfo.subjectID;
            CaseObj.Originator_Relationship__c= highlightsPanelInfo.originatorRel;
            CaseObj.Subject_Type__c = 'Member'; //
            CaseObj.Caller__c = highlightsPanelInfo.originatorName != '' && highlightsPanelInfo.originatorName != null?highlightsPanelInfo.originatorName:'';
        
        }
        else{
            CaseObj.Onshore_Restriction_Code__c = '00';
            CaseObj.Onshore_Restriction__c = 'No';
        }
        /*if(saveActionFlag){
CaseObj.isComplete__c = true;
}
*/
        
        upsert CaseObj;
        
        CaseObj = [SELECT Id, CaseNumber,Misdirected_Reason__c,Surrogate_Key__c,Origin  FROM Case where id =: CaseObj.Id LIMIT 1];
        
        return CaseObj;
    }
    
    @AuraEnabled
    public static Case upsertMisdirectedCase( Case caseObj, String reason,String comments){        
        CaseComment objcc = new CaseComment();
        if(caseObj != null){        
            caseObj.isComplete__c =true;
            caseObj.Misdirected_Reason__c = reason;
            upsert caseObj;   
            
            if(!String.isEmpty(comments)){
                system.debug('Case comment');
                objcc.CommentBody = comments;
                objcc.ParentId = caseObj.Id;
                insert objcc; 
                system.debug('Case comment'+objcc);
                
            }
        }
        
        return caseObj;
    }
    
}