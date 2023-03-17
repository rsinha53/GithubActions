public with sharing class ACETCaseActionsController {
    public String InteractionId {get;set;}
    public String SurrogateKey {get;set;}
    public boolean noCasesFlag {get;set;}
    public boolean noCompleteCaseFlag {get;set;}
    public String RedirectToPage { get; set; }
    public String CallTopic { get; set; }
    public ACETCallTopicsDataWrapper callTopicDataWrapper{get; set;}
    public Interaction__c AttrInteraction{get;set;} 
    Public ACETHighlightsPanelAdditionalInfo AdditionalInfo{get;set;}
    public boolean displayRelatedCasesBtn{get;set;}
    public boolean displayRelatedCases{get;set;}
    public String extval {get;set;}
    public Interaction__c Interaction{get;set;} 
    Public List<Case> AllRelatedCases{get;set;}
    Public List<Case> RelatedCases{get;set;}
    //Added by Pavan
    Public String Caseitemlist{get;set;}
    
    public ACETCaseActionsController(){
        noCasesFlag  = true;
        noCompleteCaseFlag = true; 
        displayRelatedCases=false;
    }

    Public void ViewRelatedCases(){
/*ViewRelatedCases Method is used to render Potential parent cases based on the flow .*/
      try{
        displayRelatedCases=true;
        Interaction=AttrInteraction;
        List<String> AllCaseitems = new List<String>();
        List<String> externalIds = new List<String>();
        String InteractionType = Label.Interaction_Type;
        
        if(callTopicDataWrapper.AutodocCaseItems != null && callTopicDataWrapper.AutodocCaseItems != '')
        {
                     AllCaseitems = callTopicDataWrapper.AutodocCaseItems.split('\\|\\|');
                                          system.debug('AllCaseitems'+AllCaseitems);
                        list<string> caseitems = new list<string>();                
                                          
                        for(string keyids:AllCaseitems ){
                          if(keyids.contains(';;')){
                           list<string> keyidsparts =keyids.split(';;');
                                 caseitems.add(keyidsparts[0]);
                                         }else{
                              caseitems.add(keyids);
                                 }
                                           }
         if(caseitems.size() >0 && caseitems != null){
                for(String item : caseitems)
                {
                    String[] str = item.split('::');
                    if(str.size()>0 && str[0] != null && str[0] != ''){
                        externalIds.add(str[0]);
                    }
                }
            }
          
        }
        
        List<Case> AllRelatedCasesstore = new List<Case>();
        if(AdditionalInfo == null)
        {
            string addInfo = ApexPages.currentPage().getParameters().get('additionalInfo');
                      if(addInfo != null){
                AdditionalInfo  = (ACETHighlightsPanelAdditionalInfo)JSON.deserialize(addInfo, ACETHighlightsPanelAdditionalInfo.class);
            }
        }
                /*Interaction Id from Current page highlights panel Info*/
        Interaction = ACETMemberQueryUtil.queryInteraction(ApexPages.currentPage().getParameters().get('InteractionId'));
        if(Interaction.Originator_Type__c == 'Member'){

            //Member only
            Set<Id> caseset = new Set<Id>();                       
            if(AdditionalInfo.MemberId != null){
                        for(case c : [SELECT Id  from case where  Status = 'Closed' and ID__c=:AdditionalInfo.MemberId and Topic__c = :Calltopic and Originator_Type__c =: Interaction.Originator_Type__c and Surrogate_Key__c =: callTopicDataWrapper.SurrogateKey and Interaction_Type__c =: InteractionType]){
                            caseset.add(c.Id);
                            
                        }
                        
                        for(case c : [SELECT Id, Status,parentId from case where parentId IN :caseset]){
                            if(c.Status!='Closed'){
                                if(caseset.contains(c.parentId)){
                                    caseset.remove(c.parentId);
                                }
                            }
                        }
                    
                AllRelatedCases = [Select Id,CaseNumber,Subject_Name__c,CreatedBy.Name,Parent.CaseNumber,CreatedDate,Topic__c,Status,Originator_Type__c,Interaction__c,Interaction_Type__c,Interaction__r.Name,(SELECT Id, Name, ExternalID__c  FROM Work_Items__r ) from Case where ( (Has_Child_Cases__c = TRUE and ID IN :caseset ) or (ParentID IN :caseset) or (Has_Child_Cases__c = TRUE and  IsClosed = False) or (IsClosed = FALSE and Parent.IsClosed = TRUE ) ) and  ID__c=:AdditionalInfo.MemberId and Topic__c = :Calltopic and Originator_Type__c =: Interaction.Originator_Type__c and Surrogate_Key__c =: callTopicDataWrapper.SurrogateKey and Interaction_Type__c =: InteractionType];
            }
            
        }
        else if(Interaction.Originator_Type__c == 'Group/Employer' || Interaction.Originator_Type__c == 'Broker' || Interaction.Originator_Type__c == 'General Agent' || Interaction.Originator_Type__c == 'UHG' || Interaction.Originator_Type__c == 'Third Party'){
            if(AdditionalInfo.isMember != null && AdditionalInfo.isMember.contains('false')){
                //Group Member in focus
                system.debug('Group Member in focus');
                if(AdditionalInfo.MemberId != null){
                    Set<Id> caseset2 = new Set<Id>();
                        for(case c : [SELECT Id from case where  Status = 'Closed' and ID__c=:AdditionalInfo.MemberId and Topic__c = :Calltopic and Originator_Type__c =: Interaction.Originator_Type__c and ID__c =:AdditionalInfo.MemberId and Surrogate_Key__c =: callTopicDataWrapper.SurrogateKey and Interaction_Type__c =:InteractionType]){
                            caseset2.add(c.Id);
                            
                        }
                        for(case c : [SELECT Id, Status,parentId from case where parentId IN :caseset2]){
                            if(c.Status!='Closed'){
                                if(caseset2.contains(c.parentId)){
                                    caseset2.remove(c.parentId);
                                }
                            }
                        }
                   
                    
                    AllRelatedCases = [Select CaseNumber,Parent.CaseNumber,Subject_Name__c,CreatedBy.Name,CreatedDate,Topic__c,Status,Originator_Type__c,Interaction_Type__c,Interaction__r.Name,(SELECT Id, Name, ExternalID__c  FROM Work_Items__r ) from Case where ( (Has_Child_Cases__c = TRUE and ID IN :caseset2 ) or (ParentID IN :caseset2) or (Has_Child_Cases__c = TRUE and  IsClosed = False) or (IsClosed = FALSE and Parent.IsClosed = TRUE ) ) and ID__c=:AdditionalInfo.MemberId and Topic__c = :Calltopic and Originator_Type__c =: Interaction.Originator_Type__c and Surrogate_Key__c =: callTopicDataWrapper.SurrogateKey and Interaction_Type__c =: InteractionType];
                }
            }
            else{
                //Group only
                system.debug('Group only');
                
                if(Interaction.Group_ID__c != null){
                    Set<Id> caseset3 = new Set<Id>();
                        for(case c : [SELECT Id from case where   Status = 'Closed' and  ID__c=:Interaction.Group_ID__c and Topic__c = :callTopicDataWrapper.CaseObj.Topic__c and Interaction_Type__c =: InteractionType]){
                            caseset3.add(c.Id);
                            
                        }
                        
                        for(case c : [SELECT Id, Status,parentId from case where parentId IN :caseset3]){
                            if(c.Status!='Closed'){
                                if(caseset3.contains(c.parentId)){
                                    caseset3.remove(c.parentId);
                                }
                            }
                        }
                    
                    
                    AllRelatedCases = [Select CaseNumber,Parent.CaseNumber,Subject_Name__c,CreatedBy.Name,CreatedDate,Topic__c,Status,Originator_Type__c,Interaction_Type__c,Interaction__r.Name,(SELECT Id, Name, ExternalID__c  FROM Work_Items__r) from Case where ( (Has_Child_Cases__c = TRUE and ID IN :caseset3 ) or (ParentID IN :caseset3) or  (Has_Child_Cases__c = TRUE and  IsClosed = False) or (IsClosed = FALSE and Parent.IsClosed = TRUE )   ) and ID__c=:Interaction.Group_ID__c and Topic__c = :callTopicDataWrapper.CaseObj.Topic__c and Originator_Type__c =: Interaction.Originator_Type__c and Interaction_Type__c =: InteractionType];
                    
                }
            }        
        }
        else if(Interaction.Originator_Type__c == 'Producer'){
            if(AdditionalInfo.isMember != null && AdditionalInfo.isMember.contains('false')){
                //Producer Member in focus
                system.debug('Producer Member in focus');
                if(AdditionalInfo.MemberId != null){
                    Set<Id> caseset4 = new Set<Id>();
                        for(case c : [SELECT Id from case where   Status = 'Closed' and ID__c=:AdditionalInfo.MemberId and Topic__c = :Calltopic and Originator_Type__c =: Interaction.Originator_Type__c and ID__c =:AdditionalInfo.MemberId and Surrogate_Key__c =: callTopicDataWrapper.SurrogateKey and Interaction_Type__c =: InteractionType]){
                            caseset4.add(c.Id);   
                    }
                    for(case c : [SELECT Id, Status,parentId from case where parentId IN :caseset4]){
                            if(c.Status!='Closed'){
                                if(caseset4.contains(c.parentId)){
                                    caseset4.remove(c.parentId);
                                }
                            }
                        }
                    AllRelatedCases = [Select CaseNumber,Parent.CaseNumber,Subject_Name__c,CreatedBy.Name,CreatedDate,Topic__c,Status,Originator_Type__c,Interaction_Type__c,Interaction__r.Name,(SELECT Id, Name, ExternalID__c  FROM Work_Items__r ) from Case where ( (Has_Child_Cases__c = TRUE and ID IN :caseset4 ) or (ParentID IN :caseset4) or (Has_Child_Cases__c = TRUE and  IsClosed = False) or (IsClosed = FALSE and Parent.IsClosed = TRUE ) ) and ID__c=:AdditionalInfo.MemberId and Topic__c = :Calltopic and Originator_Type__c =: Interaction.Originator_Type__c and Surrogate_Key__c =: callTopicDataWrapper.SurrogateKey and Interaction_Type__c = : InteractionType];
                    
                }
            }
            else if(AdditionalInfo.isGroup != null && AdditionalInfo.isGroup.contains('false')){
                //Producer Group in focus
                system.debug('Producer Group in focus');
                if(Interaction.Group_ID__c != null){
                    Set<Id> caseset5 = new Set<Id>();                        
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
                        for(case c : [SELECT Id from case where  Status = 'Closed' and ID__c=:AdditionalInfo.MemberId and Topic__c = :Calltopic and Originator_Type__c =: Interaction.Originator_Type__c and ID__c =:AdditionalInfo.MemberId and Surrogate_Key__c =: callTopicDataWrapper.SurrogateKey and Interaction_Type__c =: InteractionType]){
                            caseset7.add(c.Id);                            
                        }
                        
                        for(case c : [SELECT Id, Status,parentId from case where parentId IN :caseset7]){
                            if(c.Status!='Closed'){
                                if(caseset7.contains(c.parentId)){
                                    caseset7.remove(c.parentId);
                                }
                            }
                        }
                    
                    AllRelatedCases = [Select CaseNumber,Parent.CaseNumber,Subject_Name__c,CreatedBy.Name,CreatedDate,Topic__c,Status,Originator_Type__c,Interaction_Type__c,Interaction__r.Name,(SELECT Id, Name, ExternalID__c FROM Work_Items__r ) from Case where ( (Has_Child_Cases__c = TRUE and ID IN :caseset7 ) or (ParentID IN :caseset7) or (Has_Child_Cases__c = TRUE and  IsClosed = False) or (IsClosed = FALSE and Parent.IsClosed = TRUE ) ) and ID__c=:AdditionalInfo.MemberId and Topic__c = :Calltopic and Originator_Type__c =: Interaction.Originator_Type__c and Surrogate_Key__c =: callTopicDataWrapper.SurrogateKey and Interaction_Type__c =: InteractionType];
                    
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
        /*External ID filter on Related Cases */
        Set<Id> workitemset = new Set<Id>();        
        List<Case> AllRelatedCases1 = new List<case>();
        if(externalIds.size() >0 && AllRelatedCases != null && AllRelatedCases.size() > 0){
         Map<Id,Case> caseIdsMap = new Map<Id,Case>();
         for(case c : AllRelatedCases){
             caseIdsMap.put(c.id,c);
         }
            system.debug('externalIds  --->'+externalIds);
            for(Case_Item__c wi : [SELECT Id, Name, ExternalID__c,Case__c  FROM Case_Item__c where ExternalID__c  In: externalIds and Case__c  IN: caseIdsMap.Keyset()]){                
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
        }else if(workitemset.size()<=0 || workitemset==null ){
            if(AllRelatedCases != null)
           AllRelatedCases.clear();
        
        }       
        }else if(AllRelatedCases != null && AllRelatedCases.size() > 0){
         AllRelatedCases1.addAll(AllRelatedCases); 
         AllRelatedCases.clear();
         Set<case> AllRelatedCasesset = new Set<case>(); 
         Map<Id,Case> caseIds = new Map<Id,Case>();
         for(case c : AllRelatedCases1){
             caseIds.put(c.id,c);
         }
         for(Case_Item__c wi : [SELECT Id, Name, ExternalID__c,Case__c  FROM Case_Item__c where Case__c  IN: caseIds.Keyset()]){   
         if(wi.ExternalID__c == null)    {
           AllRelatedCasesset.add(caseids.get(wi.Case__c));

         }         
            }
         AllRelatedCases.addAll(AllRelatedCasesset); 

        }
        
        }
        catch(exception e){
        system.debug('Related Cases issue --->'+e);
        }
            } 
    
    public void wrapInteraction(){
        system.debug('callTopicDataWrapper in wrapInteraction :: '+callTopicDataWrapper);
        String SubjectId = ApexPages.currentPage().getParameters().get('subjectId');
        String SubjectTabsStr = ApexPages.currentPage().getParameters().get('subjectTabs');
        system.debug('SubjectId in wrapInteraction :: '+SubjectId);
        system.debug('SubjectTabs in wrapInteraction :: '+SubjectTabsStr);
        List<String> subjectTabArray;
        if(!String.isEmpty(SubjectTabsStr)){
            subjectTabArray = (List<String>)JSON.deserialize(SubjectTabsStr,List<String>.class);
        }
        
        noCasesFlag  = true;
        noCompleteCaseFlag = true;
        Map<String, List<Case>> subjectVsCaseListMap =  new Map<String, List<Case>>();
        List<Case> providerCaseList = new List<Case>();
        
        List<Case> caseList = [select id,iscomplete__c,isclosed,contactId from case where interaction__c =:InteractionId];
        
        if(caseList.size() > 0){
            for(Case caseObj : caseList){
                if(caseObj.contactId == null){
                    //belongs to provider call topic
                    providerCaseList.add(caseObj);
                }
                if(! subjectVsCaseListMap.containsKey(caseObj.contactId)){
                    subjectVsCaseListMap.put(caseObj.contactId,new List<Case>());
                }
                subjectVsCaseListMap.get(caseObj.contactId).add(caseObj);
            }
        }
        
        if(!String.isEmpty(SubjectId)){
            //Member detail wrap button clicked
            List<Case> currentSubjectCaseList = subjectVsCaseListMap.get(SubjectId);
            wrap(currentSubjectCaseList);
            system.debug('Member detail wrap button clicked');
            
        }else{
            //provider detail wrap button clicked.
            if(subjectVsCaseListMap.size() == 0 && subjectTabArray == null){
                system.debug('No Subject tab is opened yet');
            }
            if(subjectVsCaseListMap.size() == 0 && subjectTabArray != null && subjectTabArray.size() > 0){
                system.debug('Subject tab is opened but no cases are created under any subject');
            }
            if(subjectVsCaseListMap.size() > 0 && subjectTabArray != null && subjectTabArray.size() > 0 && subjectTabArray.size() > subjectVsCaseListMap.size()) {
                system.debug('Subject tab is opened and for few subject cases are not created');
            }           
            if(subjectVsCaseListMap.size() > 0){
                //few subjects detail tab has been opened
                for(String subId : subjectVsCaseListMap.keySet()){
                    system.debug('checkking subject '+subId);
                    wrap(subjectVsCaseListMap.get(subId));
                    if(noCasesFlag || noCompleteCaseFlag){
                        system.debug('subId '+subId +' cannot be wrapped');
                        break;
                    }
                }
            }
            
            
            if(!noCasesFlag && !noCompleteCaseFlag){
                if(providerCaseList.size() == 0){
                    system.debug('No call topics opened for provider');
                }else{
                    system.debug('Few call topics opened for provider');
                }
                wrap(providerCaseList);
            }
        }
        
        system.debug('noCasesFlag :: '+noCasesFlag + '  || noCompleteCaseFlag :: '+noCompleteCaseFlag);
    }
    private void wrap(List<Case> caseList){
        if(caseList != null && caseList.size() > 0){
            noCasesFlag = false;
            for(Case caseObj : caseList){
                if(caseObj.isComplete__c){ 
                    noCompleteCaseFlag = false;
                }else{
                    noCompleteCaseFlag = true;
                    break;
                }
            }
        }       
    }
    public pageReference Cancel() {
        if(CallTopic  == 'Enroll Subscriber' || CallTopic  == 'Enroll Family Member' || CallTopic  == 'Reinstate Subscriber/Family Member' || CallTopic  =='Terminate Subscriber/Family Member')
        {
            callTopicDataWrapper.saveAndClose();
        }
        return new pageReference('/apex/' + RedirectToPage);
    }
   
    public Boolean getIsComponentVisible(){
        User logUser = [Select Profile.Name from User where ID =: UserInfo.getUserID()];
        if(logUser.profile.name.contains('Research User')){
            return false;
        }
        else{
            return true;
        }
        
    }
}