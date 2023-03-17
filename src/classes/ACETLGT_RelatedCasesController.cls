public  class ACETLGT_RelatedCasesController {
    
    
      public class resultswrap {
       @AuraEnabled
        public  list<case> AllRelatedCases {get; set;}
       @AuraEnabled
      Public list<CaseComment> AllRelatedCaseComments {get; set;}
    
    }
 @AuraEnabled
 Public static resultswrap getRelatedCases(string InteractionId , string interactiontype, string Calltopic,list<string> ExternalIDs,string SurrogateKey,string highlightPanel_String)
    {  
        system.debug('InteractionId'+InteractionId+''+interactiontype+''+Calltopic+''+SurrogateKey+''+highlightPanel_String);
        system.debug('ExternalIDs'+ExternalIDs);
        /*if(ExternalIDs != null){
        list<string> ExternalIDslst= ExternalIDs.split('@@**@@');
        }*/
                resultswrap rw = new resultswrap();
    List<Case>  AllRelatedCasesNew = new list<case>();  

    /*ViewRelatedCases Method is used to render Potential parent cases based on the flow .*/
      //  try{
          List<Case>  AllRelatedCases = new list<case>();  
      
            ACETLGT_HighlightPanelInfo HighlightPanelInfo= new ACETLGT_HighlightPanelInfo();
            ACETHighlightsPanelAdditionalInfo AdditionalInfo = new ACETHighlightsPanelAdditionalInfo();
       Interaction__c Interaction = ACETMemberQueryUtil.queryInteraction(InteractionId);
       if(highlightPanel_String != null){
                                HighlightPanelInfo  = (ACETLGT_HighlightPanelInfo)JSON.deserialize(highlightPanel_String, ACETLGT_HighlightPanelInfo.class);

            }
        system.debug('HighlightPanelInfo'+HighlightPanelInfo);
                /*Interaction Id from Current page highlights panel Info*/
        if(Interaction.Originator_Type__c == 'Member'){

            //Member only
            Set<Id> caseset = new Set<Id>();
            
                  
            if(HighlightPanelInfo != null && HighlightPanelInfo.MemberId != null){
                        for(case c : [SELECT Id  from case where  Status = 'Closed' and ID__c=:HighlightPanelInfo.MemberId and Topic__c = :Calltopic and Originator_Type__c =: Interaction.Originator_Type__c and Surrogate_Key__c =: SurrogateKey and Interaction_Type__c =: InteractionType]){
                            caseset.add(c.Id);
                            
                        }
                        
                        for(case c : [SELECT Id, Status,parentId from case where parentId IN :caseset]){
                            if(c.Status!='Closed'){
                                if(caseset.contains(c.parentId)){
                                    caseset.remove(c.parentId);
                                }
                            }
                        }
                        system.debug('caseset====>'+caseset);
                    
                AllRelatedCases = [Select Id,Original_Type__c,Original_Subtype__c,Owner.Name,CaseNumber,Subject_Name__c,CreatedBy.Name,Parent.ID,Parent.CaseNumber,CreatedDate,Topic__c,Status,Originator_Type__c,Interaction__c,Interaction_Type__c,Interaction__r.Name,(SELECT Id, Name, ExternalID__c,Resolved__c    FROM Work_Items__r ) from Case where ( (Has_Child_Cases__c = TRUE and ID IN :caseset ) or (ParentID IN :caseset) or (Has_Child_Cases__c = TRUE and  IsClosed = False) or (IsClosed = FALSE and Parent.IsClosed = TRUE ) ) and  ID__c=:HighlightPanelInfo.MemberId and Topic__c = :Calltopic and Originator_Type__c =: Interaction.Originator_Type__c and Surrogate_Key__c =: SurrogateKey and Interaction_Type__c =: InteractionType];
            }
            
        }
                system.debug('AllRelatedCases2 before id filter'+AllRelatedCases);

      /*  else if(Interaction.Originator_Type__c == 'Group/Employer' || Interaction.Originator_Type__c == 'Broker' || Interaction.Originator_Type__c == 'General Agent' || Interaction.Originator_Type__c == 'UHG' || Interaction.Originator_Type__c == 'Third Party'){
            if(HighlightPanelInfo.MemberId != null && AdditionalInfo.isMember.contains('false')){
                //Group Member in focus
                system.debug('Group Member in focus');
                if(HighlightPanelInfo.MemberId != null){
                    Set<Id> caseset2 = new Set<Id>();
                    //if(caseitemidset.size()>0){
                        for(case c : [SELECT Id from case where  Status = 'Closed' and ID__c=:HighlightPanelInfo.MemberId and Topic__c = :Calltopic and Originator_Type__c =: Interaction.Originator_Type__c and ID__c =:HighlightPanelInfo.MemberId and Surrogate_Key__c =: SurrogateKey and Interaction_Type__c =:InteractionType]){
                            caseset2.add(c.Id);
                            
                        }
                        
                        for(case c : [SELECT Id, Status,parentId from case where parentId IN :caseset2]){
                            if(c.Status!='Closed'){
                                if(caseset2.contains(c.parentId)){
                                    caseset2.remove(c.parentId);
                                }
                            }
                        }
                   // }
                    
                    AllRelatedCases = [Select CaseNumber,Parent.CaseNumber,Subject_Name__c,CreatedBy.Name,CreatedDate,Topic__c,Status,Originator_Type__c,Interaction_Type__c,Interaction__r.Name,(SELECT Id, Name, ExternalID__c  FROM Work_Items__r ) from Case where ( (Has_Child_Cases__c = TRUE and ID IN :caseset2 ) or (ParentID IN :caseset2) or (Has_Child_Cases__c = TRUE and  IsClosed = False) or (IsClosed = FALSE and Parent.IsClosed = TRUE ) ) and ID__c=:HighlightPanelInfo.MemberId and Topic__c = :Calltopic and Originator_Type__c =: Interaction.Originator_Type__c and Surrogate_Key__c =: SurrogateKey and Interaction_Type__c =: InteractionType];
                }
            }
            else{
                //Group only
                system.debug('Group only');
                
                if(Interaction.Group_ID__c != null){
                    Set<Id> caseset3 = new Set<Id>();
                        for(case c : [SELECT Id from case where   Status = 'Closed' and  ID__c=:Interaction.Group_ID__c and Topic__c = :Calltopic and Interaction_Type__c =: InteractionType]){
                            caseset3.add(c.Id);
                            
                        }
                        
                        for(case c : [SELECT Id, Status,parentId from case where parentId IN :caseset3]){
                            if(c.Status!='Closed'){
                                if(caseset3.contains(c.parentId)){
                                    caseset3.remove(c.parentId);
                                }
                            }
                        }
                    
                    
                    AllRelatedCases = [Select CaseNumber,Parent.CaseNumber,Subject_Name__c,CreatedBy.Name,CreatedDate,Topic__c,Status,Originator_Type__c,Interaction_Type__c,Interaction__r.Name,(SELECT Id, Name, ExternalID__c  FROM Work_Items__r) from Case where ( (Has_Child_Cases__c = TRUE and ID IN :caseset3 ) or (ParentID IN :caseset3) or  (Has_Child_Cases__c = TRUE and  IsClosed = False) or (IsClosed = FALSE and Parent.IsClosed = TRUE )   ) and ID__c=:Interaction.Group_ID__c and Topic__c = :Calltopic and Originator_Type__c =: Interaction.Originator_Type__c and Interaction_Type__c =: InteractionType];
                    
                }
            }        
        }
        else if(Interaction.Originator_Type__c == 'Producer'){
            if(AdditionalInfo.isMember != null && AdditionalInfo.isMember.contains('false')){
                //Producer Member in focus
                system.debug('Producer Member in focus');
                if(AdditionalInfo.MemberId != null){
                    Set<Id> caseset4 = new Set<Id>();
                        for(case c : [SELECT Id from case where   Status = 'Closed' and ID__c=:HighlightPanelInfo.MemberId and Topic__c = :Calltopic and Originator_Type__c =: Interaction.Originator_Type__c and ID__c =:HighlightPanelInfo.MemberId and Surrogate_Key__c =: SurrogateKey and Interaction_Type__c =: InteractionType]){
                            caseset4.add(c.Id);   
                    }
                    for(case c : [SELECT Id, Status,parentId from case where parentId IN :caseset4]){
                            if(c.Status!='Closed'){
                                if(caseset4.contains(c.parentId)){
                                    caseset4.remove(c.parentId);
                                }
                            }
                        }
                    AllRelatedCases = [Select CaseNumber,Parent.CaseNumber,Subject_Name__c,CreatedBy.Name,CreatedDate,Topic__c,Status,Originator_Type__c,Interaction_Type__c,Interaction__r.Name,(SELECT Id, Name, ExternalID__c  FROM Work_Items__r ) from Case where ( (Has_Child_Cases__c = TRUE and ID IN :caseset4 ) or (ParentID IN :caseset4) or (Has_Child_Cases__c = TRUE and  IsClosed = False) or (IsClosed = FALSE and Parent.IsClosed = TRUE ) ) and ID__c=:HighlightPanelInfo.MemberId and Topic__c = :Calltopic and Originator_Type__c =: Interaction.Originator_Type__c and Surrogate_Key__c =: SurrogateKey and Interaction_Type__c = : InteractionType];
                    
                }
            }
            else if(AdditionalInfo.isGroup != null && AdditionalInfo.isGroup.contains('false')){
                //Producer Group in focus
                system.debug('Producer Group in focus');
                if(Interaction.Group_ID__c != null){
                    Set<Id> caseset5 = new Set<Id>();
                    //if(caseitemidset.size()>0){
                        
                        for(case c : [SELECT Id from case where  Status = 'Closed' and ID__c=:Interaction.Group_ID__c and Topic__c = :Calltopic and Originator_Type__c =: Interaction.Originator_Type__c and Interaction_Type__c =: InteractionType]){
                            caseset5.add(c.Id);
                            
                        }
                        
                        for(case c : [SELECT Id, Status,parentId from case where parentId IN :caseset5]){
                            if(c.Status!='Closed'){
                                if(caseset5.contains(c.parentId)){
                                    caseset5.remove(c.parentId);
                                }
                            }
                        }
                    //}
                    
                    AllRelatedCases = [Select CaseNumber,Parent.CaseNumber,Subject_Name__c,CreatedBy.Name,CreatedDate,Topic__c,Status,Originator_Type__c,Interaction_Type__c,Interaction__r.Name,(SELECT Id, Name, ExternalID__c  FROM Work_Items__r ) from Case where ( (Has_Child_Cases__c = TRUE and  ID IN :caseset5 ) or (ParentID IN :caseset5) or (Has_Child_Cases__c = TRUE and  IsClosed = False) or (IsClosed = FALSE and Parent.IsClosed = TRUE ) ) and ID__c=:Interaction.Group_ID__c and Topic__c = :Calltopic and Originator_Type__c =: Interaction.Originator_Type__c and Interaction_Type__c =: InteractionType];
                    
                }
            }
            
            else {
                //Producer only
                system.debug('Producer only');
                if(AdditionalInfo.producerId != null){
                    Set<Id> caseset6 = new Set<Id>();
                    
                        for(case c : [SELECT Id from case where  Status = 'Closed' and ID__c=:AdditionalInfo.producerId and Topic__c = :Calltopic and Originator_Type__c =: Interaction.Originator_Type__c and Interaction_Type__c =: InteractionType]){
                            caseset6.add(c.Id);
                        
                    }
                    for(case c : [SELECT Id, Status,parentId from case where parentId IN :caseset6]){
                            if(c.Status!='Closed'){
                                if(caseset6.contains(c.parentId)){
                                    caseset6.remove(c.parentId);
                                }
                            }
                        }
                    AllRelatedCases = [Select CaseNumber,Parent.CaseNumber,Subject_Name__c,CreatedBy.Name,CreatedDate,Topic__c,Status,Originator_Type__c,Interaction_Type__c,Interaction__r.Name,(SELECT Id, Name, ExternalID__c  FROM Work_Items__r ) from Case where ( (Has_Child_Cases__c = TRUE and ID IN :caseset6 ) or (ParentID IN :caseset6)  or (Has_Child_Cases__c = TRUE and  IsClosed = False) or (IsClosed = FALSE and Parent.IsClosed = TRUE ) ) and ID__c=:AdditionalInfo.producerId and Topic__c = :Calltopic and Originator_Type__c =: Interaction.Originator_Type__c and Interaction_Type__c =: InteractionType];
                    
                }
                
            }        
        }
        else if(Interaction.Originator_Type__c == 'Provider'){
            if(AdditionalInfo.isMember  != null && AdditionalInfo.isMember.contains('false')){
                //Provider Member in focus
                system.debug('Provider Member in focus');
                if(AdditionalInfo.MemberId != null){
                    Set<Id> caseset7 = new Set<Id>();
                    //if(caseitemidset.size()>0){
                        for(case c : [SELECT Id from case where  Status = 'Closed' and ID__c=:AdditionalInfo.MemberId and Topic__c = :Calltopic and Originator_Type__c =: Interaction.Originator_Type__c and ID__c =:AdditionalInfo.MemberId and Surrogate_Key__c =: SurrogateKey and Interaction_Type__c =: InteractionType]){
                            caseset7.add(c.Id);                            
                        }
                        
                        for(case c : [SELECT Id, Status,parentId from case where parentId IN :caseset7]){
                            if(c.Status!='Closed'){
                                if(caseset7.contains(c.parentId)){
                                    caseset7.remove(c.parentId);
                                }
                            }
                        }
                    //}
                    
                    AllRelatedCases = [Select CaseNumber,Parent.CaseNumber,Subject_Name__c,CreatedBy.Name,CreatedDate,Topic__c,Status,Originator_Type__c,Interaction_Type__c,Interaction__r.Name,(SELECT Id, Name, ExternalID__c FROM Work_Items__r ) from Case where ( (Has_Child_Cases__c = TRUE and ID IN :caseset7 ) or (ParentID IN :caseset7) or (Has_Child_Cases__c = TRUE and  IsClosed = False) or (IsClosed = FALSE and Parent.IsClosed = TRUE ) ) and ID__c=:AdditionalInfo.MemberId and Topic__c = :Calltopic and Originator_Type__c =: Interaction.Originator_Type__c and Surrogate_Key__c =: SurrogateKey and Interaction_Type__c =: InteractionType];
                    
                }
            }
            else {
                //Provider only
                system.debug('Provider only');
                if(Interaction.Provider_ID__c != null){
                    Set<Id> caseset8 = new Set<Id>();
                        for(case c : [SELECT Id from case where   Status = 'Closed' and ID__c=:Interaction.Provider_ID__c and Topic__c = :Calltopic and Originator_Type__c =: Interaction.Originator_Type__c and Interaction_Type__c =: InteractionType]){
                            caseset8.add(c.Id);                            
                        }
                        
                        for(case c : [SELECT Id, Status,parentId from case where parentId IN :caseset8]){
                            if(c.Status!='Closed'){
                                if(caseset8.contains(c.parentId)){
                                    caseset8.remove(c.parentId);
                                }
                            }
                        }
                    AllRelatedCases = [Select Id,CaseNumber,Parent.CaseNumber,Subject_Name__c,CreatedBy.Name,CreatedDate,Topic__c,Status,Originator_Type__c,Interaction_Type__c,Interaction__r.Name,(SELECT Id, Name, ExternalID__c  FROM Work_Items__r ) from Case where ( (Has_Child_Cases__c = TRUE and ID IN :caseset8 ) or (ParentID IN :caseset8) or (Has_Child_Cases__c = TRUE and  IsClosed = False) or (IsClosed = FALSE and Parent.IsClosed = TRUE ) ) and ID__c=:Interaction.Provider_ID__c and Topic__c = :Calltopic and Originator_Type__c =: Interaction.Originator_Type__c and Interaction_Type__c =: InteractionType];
                }
            }
        }
*/
                 system.debug('AllRelatedCases==>'+AllRelatedCases);

        set<Id> finalcaseIds = new set<id>();
        if(AllRelatedCases != null && AllRelatedCases.size() > 0){
        for(case ca : AllRelatedCases){
            finalcaseIds.add(ca.Id);
        }
        }
        Set<Id> openCases = new Set<Id>();
        Set<Id> openCases1 = new Set<Id>();
        for(case c : [SELECT Id,parentId from case where Status = 'Open' and ID IN : finalcaseIds]){ 
            if(c.ParentId!=null)
                openCases.add(c.ParentId);                    
        }
        for(case c : [SELECT Id, Status, parentId  from case where Id IN :openCases]){
            if(c.Status=='Closed'){
                openCases1.add(c.Id);
            }
        }
           
        Set<case> AllRelatedCases2 = new Set<case>(); 
        if(AllRelatedCases != null && AllRelatedCases.size() > 0){
        for(case rmcases : AllRelatedCases){
            if(openCases1.contains(rmcases.id) ){
                continue;
            }else{
                AllRelatedCases2.add(rmcases);
            }
        }        
        AllRelatedCases.clear();
        AllRelatedCases.addAll(AllRelatedCases2);     
        }
        system.debug('AllRelatedCases2 before id filter'+AllRelatedCases);
        Set<Id> workitemset = new Set<Id>();        
        List<Case> AllRelatedCases1 = new List<case>();
        if( ExternalIDs.size() >0 && AllRelatedCases != null && AllRelatedCases.size() > 0){

            for(Case_Item__c wi : [SELECT Id, Name, ExternalID__c,Case__c  FROM Case_Item__c where ExternalID__c  In: ExternalIDs ]){                
                                               system.debug('ExternalIDs'+ExternalIDs);

                workitemset.add(wi.Case__c);  
            }        
        AllRelatedCases1.addAll(AllRelatedCases); 

            
        if(workitemset.size() >0){
            AllRelatedCases.clear();
            for(case c : AllRelatedCases1){
                if(workitemset.contains(c.Id)){
                    AllRelatedCases.add(c);
                }  
            }
          system.debug('AllRelatedCases ~~~'+AllRelatedCases);  
        }else if(workitemset.size()<=0 || workitemset==null ){
            if(AllRelatedCases != null)
           AllRelatedCases.clear();
        
        } 
         system.debug('AllRelatedCases !!!!'+AllRelatedCases);
        }else if(AllRelatedCases != null && AllRelatedCases.size() > 0){
         AllRelatedCases1.addAll(AllRelatedCases); 
             AllRelatedCases.clear();
                 Set<case> AllRelatedCasesset = new Set<case>(); 
         Map<Id,Case> caseIds = new Map<Id,Case>();
         system.debug('AllRelatedCases1 !!!!'+AllRelatedCases1);
         for(case c : AllRelatedCases1){
             caseIds.put(c.id,c);
         }
         system.debug('caseIds !!!!'+caseIds);
         for(Case_Item__c wi : [SELECT Id, Name, ExternalID__c,Case__c  FROM Case_Item__c where Case__c  IN: caseIds.Keyset()]){   
         if(wi.ExternalID__c == null)    {
           AllRelatedCasesset.add(caseids.get(wi.Case__c));

         }         
            }
         AllRelatedCases.addAll(AllRelatedCasesset); 

        }
    /*}
        Catch(exception ex)
        {
            system.debug('Exception is '+ex.getMessage()+'at line '+ex.getLineNumber());
        }*/
         system.debug('AllRelatedCases==>'+AllRelatedCases);
            rw.AllRelatedCases = AllRelatedCases;
        set<id> cseidsset = new set<id>();
        for(case cas : [select id from case where id in:AllRelatedCases]){
         cseidsset.add(cas.id);
                }
        
        List<CaseComment> cc = new List<CaseComment>(); 
        cc = [SELECT Id, ParentId, CreatedBy.Name, CommentBody, CreatedDate FROM CaseComment WHERE ParentId in: cseidsset order BY CreatedDate desc];
          system.debug('CaseComment'+ cc );
          rw.AllRelatedCaseComments = cc;
            return rw;
    }
       
    @AuraEnabled 
    public static user getProfileUser(){
     //query current user information  
        system.debug(userInfo.getUserId());

      User oUser = [select id,Name,Agent_Type__c,Profile.Name,Profile_Name__c,Role_Name__c FROM User Where id =: userInfo.getUserId()];
        system.debug('oUser:: '+oUser);
        return oUser;
    }
    
    @AuraEnabled 
    public static resultswrap getParentCaseInfo(string caseId ){
     List<Case>  AllCases = new list<case>();  
     List<CaseComment> cc = new List<CaseComment>(); 
      resultswrap rw = new resultswrap();
        if(caseId !=null){
           AllCases = [Select Id,Original_Type__c,Original_Subtype__c,Owner.Name,CaseNumber,Subject_Name__c,CreatedBy.Name,Parent.ID,Parent.CaseNumber,CreatedDate,Topic__c,Status,Originator_Type__c,Interaction__c,Interaction_Type__c,Interaction__r.Name,(SELECT Id, Name, ExternalID__c,Resolved__c    FROM Work_Items__r ) from Case where id=:caseId];
           cc = [SELECT Id, ParentId, CreatedBy.Name, CommentBody, CreatedDate FROM CaseComment WHERE ParentId =:caseId order BY CreatedDate desc];
           rw.AllRelatedCases = AllCases; 
           rw.AllRelatedCaseComments = cc; 
        }
       return rw;
    }

}