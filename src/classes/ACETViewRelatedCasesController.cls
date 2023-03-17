public class ACETViewRelatedCasesController {   
    Public ACETHighlightsPanelAdditionalInfo AdditionalInfo{get;set;}
    Public String Calltopic {get;set;}
    public string Pagename {get;set;}
    Public String ExternalID{get;set;}
    public ACETCallTopicsDataWrapper callTopicDataWrapper{get; set;}
    public Interaction__c Interaction{get;set;} 
    Public List<Case> AllRelatedCases{get;set;}
    Public List<Case> AllRelatedCasesNew{get;set;}      
    public boolean DisplayBtn{get;set;}    
    Public boolean isShowPopup{get;set;}    
    Public void  ViewRelatedCases()
    {  
    /*ViewRelatedCases Method is used to render Potential parent cases based on the flow .*/
        try{
    AllRelatedCasesNew = new list<case>();  
        isShowPopup = true;
        Interaction = ACETMemberQueryUtil.queryInteraction(ApexPages.currentPage().getParameters().get('InteractionId'));
        if(AdditionalInfo == null)
        {
            string addInfo = ApexPages.currentPage().getParameters().get('additionalInfo');
            system.debug('addInfo is '+addInfo);
            if(addInfo != null){
                AdditionalInfo  = (ACETHighlightsPanelAdditionalInfo)JSON.deserialize(addInfo, ACETHighlightsPanelAdditionalInfo.class);
            }
        }
        
                        /*Interaction Id from Current page highlights panel Info*/
        Interaction = ACETMemberQueryUtil.queryInteraction(ApexPages.currentPage().getParameters().get('InteractionId'));
       system.debug(' Interaction.Originator_Type__c '+Interaction.Originator_Type__c);
        if(Interaction.Originator_Type__c == 'Member'){
            //Member only
                             Set<Id> caseset = new Set<Id>();
            
                                       system.debug(callTopicDataWrapper.SurrogateKey+ ' >>>testdata'+AdditionalInfo.MemberId  + Calltopic + Interaction.Originator_Type__c + 'srk' );
    
            if(AdditionalInfo.MemberId != null){
                   
                    
                        for(case c : [SELECT Id , (SELECT Id, Name, ExternalID__c  FROM Work_Items__r) from case where  Status = 'Closed' and ID__c=:AdditionalInfo.MemberId and Topic__c = :Calltopic and Originator_Type__c =: Interaction.Originator_Type__c and Surrogate_Key__c =: callTopicDataWrapper.SurrogateKey]){
                            caseset.add(c.Id);
                            
                        }
                        
                        for(case c : [SELECT Id, Status,parentId from case where parentId IN :caseset]){
                            if(c.Status!='Closed'){
                                if(caseset.contains(c.parentId)){
                                    caseset.remove(c.parentId);
                                }
                            }
                        }
                    
                AllRelatedCases = [Select Id,CaseNumber,Subject_Name__c,CreatedBy.Name,Parent.CaseNumber,CreatedDate,Topic__c,Status,Originator_Type__c,Interaction__c,Interaction_Type__c,Interaction__r.Name,(SELECT Id, Name, ExternalID__c  FROM Work_Items__r ) from Case where ( (Has_Child_Cases__c = TRUE and ID IN :caseset ) or (ParentID IN :caseset) or (Has_Child_Cases__c = TRUE and  IsClosed = False) or (IsClosed = FALSE and Parent.IsClosed = TRUE ) ) and  ID__c=:AdditionalInfo.MemberId and Topic__c = :Calltopic and Originator_Type__c =: Interaction.Originator_Type__c and Surrogate_Key__c =: callTopicDataWrapper.SurrogateKey];
           
            }
            
        }
        else if(Interaction.Originator_Type__c == 'Group/Employer' || Interaction.Originator_Type__c == 'Broker' || Interaction.Originator_Type__c == 'General Agent' || Interaction.Originator_Type__c == 'UHG' || Interaction.Originator_Type__c == 'Third Party')
        {
            if(AdditionalInfo.isMember != null && AdditionalInfo.isMember.contains('false')){
                //Group Member in focus
                  Set<Id> caseset2 = new Set<Id>();
                if(AdditionalInfo.MemberId != null){
                               
                        for(case c : [SELECT Id from case where  Status = 'Closed' and ID__c=:AdditionalInfo.MemberId and Topic__c = :Calltopic and Originator_Type__c =: Interaction.Originator_Type__c and Surrogate_Key__c =: callTopicDataWrapper.SurrogateKey]){
                            caseset2.add(c.Id);
                            
                        }
                        
                        for(case c : [SELECT Id, Status,parentId from case where parentId IN :caseset2]){
                            if(c.Status!='Closed'){
                                if(caseset2.contains(c.parentId)){
                                    caseset2.remove(c.parentId);
                                }
                            }
                        }
                    
                    
                    AllRelatedCases = [Select CaseNumber,Parent.CaseNumber,Subject_Name__c,CreatedBy.Name,CreatedDate,Topic__c,Status,Originator_Type__c,Interaction_Type__c,Interaction__r.Name,(SELECT Id, Name, ExternalID__c  FROM Work_Items__r ) from Case where ( (Has_Child_Cases__c = TRUE and ID IN :caseset2 ) or (ParentID IN :caseset2) or (Has_Child_Cases__c = TRUE and  IsClosed = False) or (IsClosed = FALSE and Parent.IsClosed = TRUE ) ) and ID__c=:AdditionalInfo.MemberId and Topic__c = :Calltopic  and Originator_Type__c =: Interaction.Originator_Type__c and Surrogate_Key__c =: callTopicDataWrapper.SurrogateKey ];
                
                }
                }
            
            else{
                //Group only
                if(Interaction.Group_ID__c != null){
                    Set<Id> caseset3 = new Set<Id>();
                        for(case c : [SELECT Id from case where   Status = 'Closed' and ID__c=:Interaction.Group_ID__c and Topic__c = :Calltopic and Originator_Type__c =: Interaction.Originator_Type__c]){
                            caseset3.add(c.Id);
                     }
                     
                     for(case c : [SELECT Id, Status,parentId from case where parentId IN :caseset3]){
                            if(c.Status!='Closed'){
                                if(caseset3.contains(c.parentId)){
                                    caseset3.remove(c.parentId);
                                }
                            }
                        }
                    
                    AllRelatedCases = [Select CaseNumber,Parent.CaseNumber,Subject_Name__c,CreatedBy.Name,CreatedDate,Topic__c,Status,Originator_Type__c,Interaction_Type__c,Interaction__r.Name,(SELECT Id, Name, ExternalID__c  FROM Work_Items__r) from Case where  ( (Has_Child_Cases__c = TRUE and ID IN :caseset3 ) or (ParentID IN :caseset3) or  (Has_Child_Cases__c = TRUE and  IsClosed = False) or (IsClosed = FALSE and Parent.IsClosed = TRUE )   ) and ID__c=:Interaction.Group_ID__c and Topic__c = :Calltopic and Originator_Type__c =: Interaction.Originator_Type__c];
                 
                }
            }      
        }   
        else if(Interaction.Originator_Type__c == 'Producer'){
            if(AdditionalInfo.isMember != null && AdditionalInfo.isMember.contains('false')){
                //Producer Member in focus
                if(AdditionalInfo.MemberId != null){
                    Set<Id> caseset4 = new Set<Id>();
                        for(case c : [SELECT Id from case where   Status = 'Closed' and ID__c=:AdditionalInfo.MemberId and Topic__c = :Calltopic  and Originator_Type__c =: Interaction.Originator_Type__c and Surrogate_Key__c =: callTopicDataWrapper.SurrogateKey]){
                            caseset4.add(c.Id);                        
                    }
                    for(case c : [SELECT Id, Status,parentId from case where parentId IN :caseset4]){
                            if(c.Status!='Closed'){
                                if(caseset4.contains(c.parentId)){
                                    caseset4.remove(c.parentId);
                                }
                            }
                        }
                    
                    AllRelatedCases = [Select CaseNumber,Parent.CaseNumber,Subject_Name__c,CreatedBy.Name,CreatedDate,Topic__c,Status,Originator_Type__c,Interaction_Type__c,Interaction__r.Name,(SELECT Id, Name, ExternalID__c  FROM Work_Items__r ) from Case where ( (Has_Child_Cases__c = TRUE and ID IN :caseset4 ) or (ParentID IN :caseset4) or (Has_Child_Cases__c = TRUE and  IsClosed = False) or (IsClosed = FALSE and Parent.IsClosed = TRUE ) ) and ID__c=:AdditionalInfo.MemberId and Topic__c = :Calltopic and Originator_Type__c =: Interaction.Originator_Type__c and Surrogate_Key__c =: callTopicDataWrapper.SurrogateKey];
                    
                }
            }
            }
            else if(AdditionalInfo.isGroup != null && AdditionalInfo.isGroup.contains('false')){
                //Producer Group in focus
                system.debug('Producer Group in focus'+Interaction.Group_ID__c);
                if(Interaction.Group_ID__c != null){
                    Set<Id> caseset5 = new Set<Id>();
                        for(case c : [SELECT Id from case where  Status = 'Closed' and ID__c=:Interaction.Group_ID__c and Topic__c = :Calltopic  and Originator_Type__c =: Interaction.Originator_Type__c and Surrogate_Key__c =: callTopicDataWrapper.SurrogateKey]){
                            caseset5.add(c.Id);
                           
                       
                    }
                     for(case c : [SELECT Id, Status,parentId from case where parentId IN :caseset5]){
                            if(c.Status!='Closed'){
                                if(caseset5.contains(c.parentId)){
                                    caseset5.remove(c.parentId);
                                }
                            }
                        }
                    AllRelatedCases = [Select CaseNumber,Parent.CaseNumber,Subject_Name__c,CreatedBy.Name,CreatedDate,Topic__c,Status,Originator_Type__c,Interaction_Type__c,Interaction__r.Name,(SELECT Id, Name, ExternalID__c  FROM Work_Items__r ) from Case where ( (Has_Child_Cases__c = TRUE and  ID IN :caseset5 ) or (ParentID IN :caseset5) or (Has_Child_Cases__c = TRUE and  IsClosed = False) or (IsClosed = FALSE and Parent.IsClosed = TRUE ) ) and ID__c=:Interaction.Group_ID__c and Topic__c = :Calltopic  and Originator_Type__c =: Interaction.Originator_Type__c and Surrogate_Key__c =: callTopicDataWrapper.SurrogateKey];
                    
                }
            
            
            else {
                //Producer only
                system.debug('Producer only');
                if(AdditionalInfo.producerId != null){
                    Set<Id> caseset6 = new Set<Id>();
                    
                        for(case c : [SELECT Id from case where  Status = 'Closed' and ID__c=:AdditionalInfo.producerId and Topic__c = :Calltopic and Originator_Type__c =: Interaction.Originator_Type__c]){
                            caseset6.add(c.Id);
                         
                    }
                      
                        for(case c : [SELECT Id, Status,parentId from case where parentId IN :caseset6]){
                            if(c.Status!='Closed'){
                                if(caseset6.contains(c.parentId)){
                                    caseset6.remove(c.parentId);
                                }
                            }
                        }
                    
                    AllRelatedCases = [Select CaseNumber,Parent.CaseNumber,Subject_Name__c,CreatedBy.Name,CreatedDate,Topic__c,Status,Originator_Type__c,Interaction_Type__c,Interaction__r.Name,(SELECT Id, Name, ExternalID__c  FROM Work_Items__r ) from Case where ( (Has_Child_Cases__c = TRUE and ID IN :caseset6 ) or (ParentID IN :caseset6)  or (Has_Child_Cases__c = TRUE and  IsClosed = False) or (IsClosed = FALSE and Parent.IsClosed = TRUE ) ) and ID__c=:AdditionalInfo.producerId and Topic__c = :Calltopic and Originator_Type__c =: Interaction.Originator_Type__c];
                    
                }
                
            }        
        }
        else if(Interaction.Originator_Type__c == 'Provider'){
            if(AdditionalInfo.isMember  != null && AdditionalInfo.isMember.contains('false')){
                //Provider Member in focus
                system.debug('Provider Member in focus');
                if(AdditionalInfo.MemberId != null){
                    Set<Id> caseset7 = new Set<Id>();
                        for(case c : [SELECT Id from case where  Status = 'Closed' and ID__c=:AdditionalInfo.MemberId and Topic__c = :Calltopic and Originator_Type__c =: Interaction.Originator_Type__c and ID__c =:AdditionalInfo.MemberId and Surrogate_Key__c =: callTopicDataWrapper.SurrogateKey]){
                            caseset7.add(c.Id);                            
                        
                       
                    }
                     for(case c : [SELECT Id, Status,parentId from case where parentId IN :caseset7]){
                            if(c.Status!='Closed'){
                                if(caseset7.contains(c.parentId)){
                                    caseset7.remove(c.parentId);
                                }
                            }
                        }
                    AllRelatedCases = [Select CaseNumber,Parent.CaseNumber,Subject_Name__c,CreatedBy.Name,CreatedDate,Topic__c,Status,Originator_Type__c,Interaction_Type__c,Interaction__r.Name,(SELECT Id, Name, ExternalID__c FROM Work_Items__r ) from Case where ( (Has_Child_Cases__c = TRUE and ID IN :caseset7 ) or (ParentID IN :caseset7) or (Has_Child_Cases__c = TRUE and  IsClosed = False) or (IsClosed = FALSE and Parent.IsClosed = TRUE ) ) and ID__c=:AdditionalInfo.MemberId and Topic__c = :Calltopic and Originator_Type__c =: Interaction.Originator_Type__c and Surrogate_Key__c =: callTopicDataWrapper.SurrogateKey];
                    
                }
            }
            
            else {
                //Provider only
                system.debug('Provider only');
                if(Interaction.Provider_ID__c != null){
                    Set<Id> caseset8 = new Set<Id>();
                        for(case c : [SELECT Id from case where   Status = 'Closed' and ID__c=:Interaction.Provider_ID__c and Topic__c = :Calltopic and Originator_Type__c =: Interaction.Originator_Type__c ]){
                            caseset8.add(c.Id);                            
                        
                      
                    }  
                      for(case c : [SELECT Id, Status,parentId from case where parentId IN :caseset8]){
                            if(c.Status!='Closed'){
                                if(caseset8.contains(c.parentId)){
                                    caseset8.remove(c.parentId);
                                }
                            }
                        }                  
                    AllRelatedCases = [Select Id,CaseNumber,Parent.CaseNumber,Subject_Name__c,CreatedBy.Name,CreatedDate,Topic__c,Status,Originator_Type__c,Interaction_Type__c,Interaction__r.Name,(SELECT Id, Name, ExternalID__c  FROM Work_Items__r ) from Case where ( (Has_Child_Cases__c = TRUE and ID IN :caseset8 ) or (ParentID IN :caseset8) or (Has_Child_Cases__c = TRUE and  IsClosed = False) or (IsClosed = FALSE and Parent.IsClosed = TRUE ) ) and ID__c=:Interaction.Provider_ID__c and Topic__c = :Calltopic and Originator_Type__c =: Interaction.Originator_Type__c];
                }
            }
        }
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
        
        system.debug('AllRelatedCases is '+AllRelatedCases);
        set<case> newCasesSet = new set<case>();
        //iteration on cases start
        if(AllRelatedCases != null && AllRelatedCases.size() > 0){
        for(case eachCase:AllRelatedCases){
            for(Case_Item__c eachItem:eachCase.work_items__r){
                    if(eachItem.Externalid__c==ExternalID){
                      newCasesSet.add(eachCase);
                        break;
                    }
            }
        
        }
        }
        AllRelatedCasesNew.addAll(newCasesSet);
        //case iteration end
        }
        Catch(exception ex)
        {
            system.debug('Exception is '+ex.getMessage()+'at line '+ex.getLineNumber());
        }
    }
       

}