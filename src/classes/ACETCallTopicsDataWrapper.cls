public with sharing class ACETCallTopicsDataWrapper {
    public Interaction__c Interaction {get;set;}
    public Contact Subject {get;set;}
    public Contact Provider {get;set;}
    public Contact Originator {get;set;}
    public String SourceOriginator {get;set;} 
    public String SurrogateKey {get;set;}  
    public String Autodoc {get;set;}
    public String AutodocComment {get;set;}
    public String AutodocCaseItems {get;set;}    
    public String CallTopic {get;set;}
    public String CallTopicType {get;set;}
    public String CallTopicSubType {get;set;}
    public String selectedcaseid{get;set;}
    public static Boolean isIssueResolved{get;set;}
    public String issueResolvedReason{get;set;}
    public String NationalEpidemic{get;set;}
    
    public String EBcomments { get; set; }
    Public Boolean updategroupinfoSave{get; set;}//added by harish 02/13 US502373
    public string SubjectType{get;set;}
    public string topicType {get; set;}
    public String blockedCallTopic {get;set;}//added by Vishakha 12/02 US413581
    public String subjectId {get;set;}    
     
    public String CaseRecordTypeLabel { get; set; }    //Label for case record type
    public Boolean SkipCaseClosePage  { get; set; }
    public Case CaseObj {get;set;}
    public String Comments {get;set;}
    public ACETHighlightsPanelAdditionalInfo AdditionalInfo {get;set;} 
              
    public Boolean isSystemUnavailable {get;set;}   
    public String CancelReason{ get; set; } 
    public String MisdirectedReason {get;set;}
    public boolean saveActionFlag;
    
    //////////Added by Rupsa 12/02
    public string routeTo{get;set;} 
    //public String EID__c{get;set;}
    
    public String[] Topic {get;set;}            
    public String[] AccountType{ get; set; } 
    
     //Added for the poc
    public List<String> selectedCallType {get; set;}
    public List<String> selectedAccountType {get; set;}
    //public List<CallTypeWrapper> callTypeWrapList {get; set;} 
    //public List<CallTypeWrapper> accountTypeWrapList {get; set;}
    public boolean isPOC;
    public List<String> passValuetoURL {get; set;}
    public String resultJsonMap {get; set;}
    public List<Case> insertedCaseItemRecList {get; set;}
    public List<case> successCases {get; set;}
    public Map<String,String> caseItemListMap {get; set;}
    public String callTopicSytr {get; set;}
 
    //public List<callSubTypeWrapper> callSubTypeWrapList {get; set;}
    //public Map<String,List<callSubTypeWrapper>> callSubTypeWrapperMap {get; set;}
    public Map<String,String> callSubRecordTypeMapping {get; set;}
    public boolean MigrationIssue{get;set;}  //Added for US823059
    public boolean Escalated{get;set;}  //Added for US2357303
    public boolean Complaint{get;set;}  //Added for US2357303
    public boolean Iscreatetask{get;set;}
   
    public ACETCallTopicsDataWrapper(){

        CaseObj = new Case();
        
        //Added for the poc
        insertedCaseItemRecList = new List<Case>(); 
        
        Comments = '';
        topicType = '';
        
        init();
    }
    
    public void init(){
        saveActionFlag = true;
        AccountType = new String[]{};
        Topic  = new String[]{};
        
        isSystemUnavailable = false;
        SkipCaseClosePage  = false;
        MigrationIssue = false;
        Escalated = false;  //US2357303
        Complaint = false;   //US2357303
        //Added for Poc
        selectedCallType = new List<String>();
        selectedAccountType = new List<String>();
     
        
        //CaseObj = new Case();
        //getCallSubType();
        system.debug(LoggingLevel.INFO, 'Init. CaseRecordTypeLabel: ' + CaseRecordTypeLabel);
        //init interaction
        String interactionId = ApexPages.currentPage().getParameters().get('interactionId'); 
        system.debug('interactionId  >>> '+interactionId );
        if(!String.isEmpty(interactionId)){                        
            system.debug('InteractionId: ' + InteractionId);            
            //Query Provider Interaction details
            Interaction = ACETProviderUtility.GetInteractionByID(interactionId);
            //setup source originator
            SourceOriginator = Interaction.Interaction_Type__c;
            system.debug('Interaction: ' + Interaction + ', SourceOriginator: ' + SourceOriginator);
        }else{
            //interactionId = ApexPages.currentPage().getParameters().get('id'); 
            interactionId = ApexPages.currentPage().getParameters().get('interactionId');
            system.debug('InteractionId: ' + InteractionId);
            if(!String.isEmpty(interactionId)){
             system.debug('InteractionId: ' + InteractionId);
            Interaction = ACETProviderUtility.GetInteractionByID(interactionId);
            //setup source originator
            SourceOriginator = Interaction.Interaction_Type__c;             
                
            } else{
                Interaction = new Interaction__c();                
            }         
                                                                  
        }        
        //CaseObj.interaction__c = Interaction.Id;
        //init source originator
        SourceOriginator = ApexPages.currentPage().getParameters().get('sourceOriginator'); 
        if(!String.isEmpty(SourceOriginator)  && SourceOriginator != 'undefined') Interaction.Interaction_Type__c = SourceOriginator; 
        
        //init provider
        //todo: change id to providerId
        //String providerId = ApexPages.currentPage().getParameters().get('id');
        //if(!String.isEmpty(providerId)){
            //Provider = [select FirstName, LastName, Tax_ID__c, NPI__c from Contact where Id = :providerId];
        //}
        
        //init subject
        subjectId = Apexpages.currentPage().getParameters().get('contactId');
        if(!String.isEmpty(subjectId)){
            Subject = ACETProviderUtility.GetContactByID(subjectId); 
        }
        System.debug('Prakash::::Subject::::'+Subject);
        //init originator
        if(this.Interaction.Originator__c!=null)    
        this.Originator = ACETProviderUtility.GetContactByID(this.Interaction.Originator__c);
        
        //Autodoc = ApexPages.currentPage().getParameters().get('autodoc');
        CallTopic = ApexPages.currentPage().getParameters().get('callTopic');
        
        String strAdditionalInfo = ApexPages.currentPage().getParameters().get('additionalInfo');
        system.debug('strAdditionalInfo >> '+strAdditionalInfo );
        
        if(!String.isEmpty(strAdditionalInfo)){      
            AdditionalInfo = (ACETHighlightsPanelAdditionalInfo)json.deserialize(strAdditionalInfo, ACETHighlightsPanelAdditionalInfo.class); 
        }
       
        System.debug('AdditionalInfo^^^^^^^^^'+AdditionalInfo);
        System.debug('Misdirected Reason########'+MisdirectedReason); //added for Group Misdirect testing
        if(MisdirectedReason != ''){
            CaseObj.Misdirected_Reason__c = MisdirectedReason;
        }
        
        //Added for POC 
        //callSubTypeWrapperMap = getCallSubType();
        //callTypeList =  getCallTypesW();  
    }   
    
   public String getCallTopicDataWrapperStr(){
        return JSON.serialize(this);
    }
    
    public String getAdditionalInfoStr(){
        return JSON.serialize(AdditionalInfo);        
    }
        
    //get limited type and subtype based on profile and role, so these values will be filtered out on modal window    
    public String getTTSFilterStr(){
        return ACETCallTopicsPicklistUtility.getTTSFilter(CaseObj.Topic__c);
    }
    
    
    //todo: to remove it, changed name to saveCase()
    public PageReference createCase(){
    system.debug('CreateCase AdditionalInfo---->'+AdditionalInfo);
        if (String.isNotBlank(CaseRecordTypeLabel)) {
            CaseObj.RecordTypeId = ACETUtility.getRecordTypeID('Case', CaseRecordTypeLabel);
            system.debug(LoggingLevel.INFO, 'RecordTypeId: ' + CaseObj.RecordTypeId);
        }
        
        if(Interaction.Id == null) insert Interaction;
        CaseObj.Interaction__c = Interaction.Id;        
        if(SubjectType != Null && SubjectType != '')
        {
            CaseObj.Subject_Type__c = SubjectType;        
        }    
        if(Subject != null){
            CaseObj.ContactId = this.Subject.Id;
                        
        } 
                
        if(AdditionalInfo != null){
           // CaseObj.Originator_Relationship__c = AdditionalInfo.OriginatorRelationship; 
           CaseObj.Originator_Relationship__c = AdditionalInfo.RelationshipType; //Added by Harish to fix the defect DE109801   
            CaseObj.Situs_State__c = AdditionalInfo.SitusState; 
            CaseObj.Caller__c = AdditionalInfo.contactName;
            //CaseObj.Id__c = AdditionalInfo.MemberId;
            if(AdditionalInfo.MemberId != null ) {
                CaseObj.Id__c = AdditionalInfo.MemberId;
                CaseObj.Subject_Group_ID__c = AdditionalInfo.GroupNumber; //US1067143
            } 
            else if(AdditionalInfo.GroupN!= null) 
            {
                list<string> groupId = AdditionalInfo.GroupN.Split('-');
                CaseObj.Id__c = groupId[0];
                CaseObj.Subject_Group_ID__c = groupId[0];
            } 
             else if((Interaction.Originator_Type__c == 'Provider')&&(AdditionalInfo.MemberId == null) && (Interaction.Provider_ID__c != null ))
            {
                CaseObj.Id__c = Interaction.Provider_ID__c;
            } 
            else if((Interaction.Originator_Type__c == 'Producer')&&(AdditionalInfo.GroupN == null))
            {
                CaseObj.Id__c = Interaction.Originator__r.EID__c;
            }     
        }
          if(!String.isEmpty(Interaction.Third_Party__c)){
            List<Third_Party_Originator__c> tpOriginatorList = [select id,name from Third_Party_Originator__c where third_party__c =:Interaction.Third_Party__c and Subject__c =:Interaction.Originator__c limit 1];
            CaseObj.Originator_Relationship__c = tpOriginatorList[0].name;
        }
        if(SourceOriginator != null){
            this.CaseObj.Origin = SourceOriginator;
        }        
        if(!String.isEmpty(Comments)){
            CaseObj.Comments__c = Comments;    
        }
        if(CaseObj.Topic__c == null && !String.isEmpty(callTopic)){
           // CaseObj.Topic__c = callTopic;
        }        
        
        system.debug('isSystemUnavailable'+isSystemUnavailable);
        if(isSystemUnavailable){
            this.CaseObj.Status = 'Closed';
            this.CaseObj.New_Closed_Reason__c = 'System Unavailable';
        }  
        
        if(!String.isEmpty(MisdirectedReason)){
            CaseObj.Status = 'Canceled';
            CaseObj.Misdirected_Reason__c = MisdirectedReason;
        }
        
        if(!String.isEmpty(CancelReason)){
            CaseObj.Status = 'Canceled';
            CaseObj.Cancel_Reason__c = CancelReason;
        }
                
        if(!String.isEmpty(Autodoc)){
            //CaseObj.Autodoc__c = Autodoc;
        }
        if(saveActionFlag){
            CaseObj.isComplete__c = true;
        }            
         
        if(case.SObjectType.getDescribe().isCreateable()) {  //code added as per the Checkmarx improvement -Rahul   
          upsert CaseObj;        
        }        
        return new PageReference('/' + CaseObj.Id);
    }
    
  
    public PageReference saveCase() { 
        String strAdditionalInfo = ApexPages.currentPage().getParameters().get('additionalInfo');
        //if(callTopic != 'View Billing'){
            //system.debug('inside If Vlaues**********'+callTypeWrapList);
            string commentSting = '';
            system.debug('SaveCase AdditionalInfo---->'+AdditionalInfo);
            if(Subject != null){
                system.debug(Subject);
                system.debug(this.Subject);
            contact contactObj = [Select id,contact_type__c from contact where id = :this.Subject.Id];
            system.debug('ocase ---->'+contactObj );
                if(contactObj != null && contactObj.contact_type__c!=null){
                 SubjectType = contactObj.contact_type__c;
                }  
            } 
             system.debug('selectedcaseid in save is '+selectedcaseid);
        
        if(isIssueResolved == true){
            CaseObj.Status = 'Closed';
            
        }
        String accTypes =  ApexPages.currentPage().getParameters().get('accTypes');
        if (accTypes != null && accTypes != 'null') {
        CaseObj.Product_Type__c  = accTypes; 
        }
        String serviceGrp = ApexPages.currentPage().getParameters().get('serviceGrp');
        if (serviceGrp != null && serviceGrp != 'null') {
        CaseObj.Service_Group__c  = serviceGrp;
        }
        if(String.isNotBlank(selectedcaseid))
        {
            CaseObj.Parent = [Select Id, CaseNumber from Case where Id = :selectedcaseid];
            CaseObj.ParentId = selectedcaseid;
        }        
                                    
         //   system.debug('before save >>>>> ' + autodoc);
            system.debug(LoggingLevel.INFO, 'CaseRecordTypeLabel: ' + CaseRecordTypeLabel);
            if (String.isNotBlank(CaseRecordTypeLabel)) {
                //CaseObj.RecordTypeId = ACETUtility.getRecordTypeID('Case', CaseRecordTypeLabel);
                //system.debug(LoggingLevel.INFO, 'RecordTypeId: ' + CaseObj.RecordTypeId);
            }
            
            if(Interaction.Id == null) insert Interaction;        
            CaseObj.Interaction__c = Interaction.Id;        
            if(Subject != null){
                CaseObj.ContactId = this.Subject.Id;            
            }
            if(SubjectType != Null && SubjectType != '')
            {
            CaseObj.Subject_Type__c = SubjectType;
            
            }
            if(AdditionalInfo != null){
                // Dev @Ramadevi
                // @Purpose: Check the flow - If member search is from Provider or Provider Not Found
                //           the relationship field should be blank
                CaseObj.Originator_Relationship__c = (Interaction.Originator_Type__c == 'Provider' || Interaction.Originator_Type__c == 'Other') ? '' : AdditionalInfo.RelationshipType;//replaced OriginatorRelationship to RelationshipType by Harish to fix the defect DE109801
                CaseObj.Situs_State__c = AdditionalInfo.SitusState;
                CaseObj.Caller__c = AdditionalInfo.contactName;
                //CaseObj.Id__c = Interaction.Provider_ID__c ;
                if(AdditionalInfo.MemberId != null ) {
                    CaseObj.Id__c = AdditionalInfo.MemberId; 
                    CaseObj.Subject_Group_ID__c = AdditionalInfo.GroupNumber;
                    system.debug('###Inside Member AdditionalInfo.trackingGroupNumber '+AdditionalInfo.trackingGroupNumber );
                    CaseObj.Group_ID__c = AdditionalInfo.trackingGroupNumber ;
                } 
                else if((Interaction.Originator_Type__c == 'Provider')&&(AdditionalInfo.MemberId == null) && (Interaction.Provider_ID__c != null ))
                {
                    CaseObj.Id__c = Interaction.Provider_ID__c;
                }
                else if(AdditionalInfo.GroupN!= null && AdditionalInfo.isGroupNotFound != '1') 
                {
                    list<string> groupId = AdditionalInfo.GroupN.Split('-');
                    CaseObj.Id__c = groupId[0];
                    CaseObj.Subject_Group_ID__c = groupId[0];
                    system.debug('###Inside Group AdditionalInfo.trackingGroupNumber '+AdditionalInfo.trackingGroupNumber );
                    CaseObj.Group_ID__c = AdditionalInfo.trackingGroupNumber ;
                } 
                else if((Interaction.Originator_Type__c == 'Producer')&&(AdditionalInfo.GroupN == null))
                {
                    CaseObj.Id__c = Interaction.Originator__r.EID__c;
                }
               
            }
             if(!String.isEmpty(Interaction.Third_Party__c) && !String.isEmpty(Interaction.Originator__c)){
                List<Third_Party_Originator__c> tpOriginatorList = [select id,name from Third_Party_Originator__c where third_party__c =:Interaction.Third_Party__c and Subject__c =:Interaction.Originator__c limit 1];
                if (tpOriginatorList != null && tpOriginatorList.size() > 0 && tpOriginatorList[0] != null ){
                CaseObj.Originator_Relationship__c = tpOriginatorList[0].name;
                }
            }        
            system.debug('SourceOriginator >>> '+SourceOriginator);       
            system.debug('Interaction >>> '+JSON.serialize(Interaction));
            if(SourceOriginator != null){
                this.CaseObj.Origin = SourceOriginator; }
            if(Interaction.Interaction_Type__c != null){
                this.CaseObj.Origin = Interaction.Interaction_Type__c;
            }
            
            
             system.debug('@@ callTopic '+callTopic);
              system.debug('CaseObj.Topic__c '+CaseObj.Topic__c);
            if(String.isEmpty(CaseObj.Topic__c) && !String.isEmpty(callTopic)){
                system.debug('@@ callTopic '+callTopic);
                CaseObj.Topic__c = callTopic;
            }
            
            String onshoreCode = ApexPages.currentPage().getParameters().get('onshoreCode');
            system.debug('@@@onshoreCode '+onshoreCode );
            if(onshoreCode != 'undefined' && onshoreCode != null && !String.isEmpty(onshoreCode))
                CaseObj.Onshore_Restriction_Code__c = onshoreCode;      
            else
                CaseObj.Onshore_Restriction_Code__c = '00';
               
            system.debug('@@@callTopic '+callTopic );
            system.debug('@@@CaseObj.Topic__c '+CaseObj.Topic__c);
            
            String onshoreValue = ApexPages.currentPage().getParameters().get('onshoreRestriction');
            system.debug('###@@@onshoreValue '+onshoreValue );
            if(onshoreValue != 'undefined' && onshoreValue != null && !String.isEmpty(onshoreValue))
                CaseObj.Onshore_Restriction__c = onshoreValue ;      
            else
                CaseObj.Onshore_Restriction__c = 'No';
            
            system.debug('@@@ onshore boolean'+CaseObj.Onshore_Restriction__c);
            system.debug(CallTopicType);
            //standard subtype input field has a strange option value starting with __ upon option [--none--] when there is no other options
            if(!String.isEmpty(CallTopicType) && !CallTopicType.startsWith('_')){
                CaseObj.Type__c = CallTopicType;                
                if(!String.isEmpty(CallTopicSubType) && !CallTopicSubType.startsWith('_')){
                    Caseobj.SubType__c = CallTopicSubType;
                }
            }                    
            
            
            /*system.debug('isSystemUnavailable'+isSystemUnavailable);
            if(isSystemUnavailable){
                   if(updategroupinfoSave != null && updategroupinfoSave == true)// excutes only when Updategroupinformation, Enroll, Terminate,View Commission,Licensing And Credential,Medical Loss Ratio,New Business,Renewals,Off-Cycle Changes,Consumer Accounts and Reinstate Member calltopic is clicked on save if system unavailable is selected
                   {
                    this.CaseObj.Status = 'Open';
                   }
                   else{
                    this.CaseObj.Status = 'Closed';
                    this.CaseObj.New_Closed_Reason__c=label.ACETSystemUnavailable;
                    }
            }*/  
            
            if(!String.isEmpty(MisdirectedReason)){
                CaseObj.Status = 'Canceled';
                CaseObj.Misdirected_Reason__c = MisdirectedReason;
            }
            
            if(!String.isEmpty(CancelReason)){
                CaseObj.Status = 'Canceled';
                CaseObj.Cancel_Reason__c = CancelReason;
            }
                    
            if(!String.isEmpty(Autodoc)){
                //CaseObj.Autodoc__c = Autodoc;
                
            }
            if(!String.isEmpty(NationalEpidemic)){
                CaseObj.National_Disaster_Epidemic__c =  NationalEpidemic;
            }
            
            if(saveActionFlag){
                CaseObj.isComplete__c = true;
            }
            if(!String.isEmpty(SurrogateKey)){
                CaseObj.Surrogate_Key__c = SurrogateKey;
            } 
            if(MigrationIssue){
                CaseObj.Migration_Issue__c = true;
            }
        //US2357303 Begin
         if(Escalated){
                CaseObj.IsEscalated = true;
            }
         if(Complaint){
                CaseObj.Complaint__c = true;
            }
        //US2357303 End
            system.debug(CaseObj.isComplete__c);
            //system.debug('Comments before upsert in savecase'+Comments); 
            //system.debug(LoggingLevel.INFO, 'CaseObj JSON: ' + JSON.serialize(CaseObj));
            
            //copy type and subtype to original_type and original_subtype, it will be used in report, type and subtype may be changed later.
            CaseObj.Original_Type__c = CaseObj.Type__c;
            String strValue = CaseObj.SubType__c;
            
            if(AdditionalInfo != null && AdditionalInfo.isGroupNotFound == '1' ){
                CaseObj.Originator_Relationship__c =  AdditionalInfo.RelationshipType;
               // CaseObj.Id__c =  AdditionalInfo.GroupNumber;
            } else if(AdditionalInfo != null && AdditionalInfo.GroupN!= null && AdditionalInfo.MemberId == null) 
            {
                list<string> groupId = AdditionalInfo.GroupN.Split('-');
                CaseObj.Id__c = groupId[0];
                CaseObj.Subject_Group_ID__c = groupId[0];
            }
            if(AdditionalInfo != null && AdditionalInfo.isProducerNotFound == '1'){
                if(CaseObj.Id__c == null || CaseObj.Id__c == '')
                    CaseObj.Id__c = AdditionalInfo.producerIdPNF;
                if(CaseObj.Subject_Type__c == null || CaseObj.Subject_Type__c == '')
                    CaseObj.Subject_Type__c = 'Producer';
                if(AdditionalInfo.RelationshipType == null)
                    CaseObj.Originator_Relationship__c =  'Producer Contact';
                else
                    CaseObj.Originator_Relationship__c = AdditionalInfo.RelationshipType;
            }
            if(AdditionalInfo != null && AdditionalInfo.MemberId != null){
                CaseObj.Id__c =  AdditionalInfo.MemberId;
            }
            CaseObj.Original_Subtype__c = StrValue;
            system.debug(LoggingLevel.Info, 'CaseObj: '+CaseObj);
            system.debug(LoggingLevel.Info, 'CaseObj.Original_Type__c: '+CaseObj.Original_Type__c);     
           /* if(AdditionalInfo != null && AdditionalInfo.MemberId != null && SurrogateKey == null)  {
PageReference myVFPage = new PageReference('/apex/ACETErrorMessagePage');
     myVFPage.setRedirect(true);
    return myVFPage;

            }else{
                       upsert CaseObj;

            }*/
                                   upsert CaseObj;

            //add attachment autodoc to repective case
            if(!String.isEmpty(Autodoc)){
                addFilesToCase(CaseObj.Id , Autodoc);                
            }
            //add audodoc comment into case comment
            addCaseComment(caseObj.Id, AutodocComment);
            
            //add comment from call topic page
            addCaseComment(caseObj.Id, Comments);
            System.debug('Case Obj>>>>>>>>>>>'+AutodocCaseItems);
            //create case items with key id
            addCaseItems(caseObj.Id, AutodocCaseItems);
            
            //Set the flag to update to capture milestone iformation.
            updateInitalMilestonePerofmance(caseObj.Id);
            
            //display standard case page layout in a VF page to resolve cross domain issue  under IE in service console with multiple tabs   
            //standard page and VF page has different doamin in salesforce  
            //return new PageReference('/apex/ACETCaseDetail?id=' + CaseObj.Id);
            
          
           // return new PageReference('/' + CaseObj.Id);  
           return null;
    }
    
    //@Future
    public static void updateInitalMilestonePerofmance(Id caseId){
          system.debug('%%0508 caseid '+ caseid);
         Case cas = new case(Id = caseid,Trigger_Initial_MP_Record__c = true);
         update cas;
    }
    
    public void createBlankCase(){
        //CaseObj.Interaction__c = Interaction.Id;
        //if(Subject != null){
            //CaseObj.contactId = Subject.Id;
        //}        
        //system.debug('CaseObj >>>'+CaseObj);     
        //insert CaseObj;                                   
    }
    
    public PageReference saveAndClose(){
        system.debug('i am here >>>>>>>>>>>>>');
        string commentSting = '';
        saveActionFlag =false;
        CaseObj.Status='Closed'; 
        updategroupinfoSave = false;
         saveCase();
         if(!SkipCaseClosePage){
              system.debug(' isSystemUnavailable--->'+isSystemUnavailable); 
             /*****added by vishakha 12/02 for US413581 START*****/
             if((CaseObj.Topic__c == 'View Consumer Dashboard' || CaseObj.Topic__c == 'Create Authorization' || CaseObj.Topic__c == 'Create PCP Referral') && !isSystemUnavailable){
                  
                 return new PageReference('/apex/ACETCallTopicSaveAndClose?caseId=' + CaseObj.Id + '&blockedCallTopic ='+ blockedCallTopic); 
             }
             /*****added by vishakha 12/02 for US413581 END*****/
             else
             {
                 return new PageReference('/apex/ACETCallTopicSaveAndClose?caseId=' + CaseObj.Id);  
             }
         }
         else{
                 return new PageReference('/' + CaseObj.Id); 
         }
    }
    
    public PageReference saveCaseAndReturn(){
        saveActionFlag =true;
        saveCase();
        return new PageReference('/apex/ACETCancelCase?caseId=' + CaseObj.Id);
    }
    
    public PageReference cancelCase() {
        //saveActionFlag = false;
        CaseObj.Status='Canceled';
        updategroupinfoSave = false;
        saveCase();
        
        return new PageReference('/apex/ACETCancelCase?caseId=' + CaseObj.Id);                
    }
    
    public PageReference misdirect(){
        CaseObj.Status='Canceled';
        updategroupinfoSave = false;
        saveCase(); 
        if(SurrogateKey == null) SurrogateKey = '';
        return new PageReference('/apex/ACETMisdirectedCall?currentCaseId=' + CaseObj.Id+'&SRK='+SurrogateKey);    
    }
    
    //create case items based on external ids and other info from autodoc
    public static void addCaseItems(String caseId, String caseItemsInfo){
        System.debug('Entering.....'+caseItemsInfo+'>>>'+caseId); //debug added by divya for testing
        List<Case_Item__c> caseItems = new List<Case_Item__c>();
        
        if(!String.isEmpty(caseItemsInfo)){            
            List<String> keyIds = caseItemsInfo.split('\\|\\|');
            Map<String, String> keyIdMap = new Map<String,String>();
            
            //merge case item with same keyid, case item from sub tab overrides same case item from search page
            for(String keyId : keyIds){
                List<String> keyIdParts = keyId.split('::');
                keyIdMap.put(keyIdParts[0], keyIdParts[1]);     
            }
     
            for(String keyId : keyIdMap.keyset()){                
                Case_Item__c ci = new Case_Item__c();
                ci.Case__c = caseId;
                if(keyId.contains(';;')) 
                {
                    List<String> keyIdParts = keyId.split(';;');
                    ci.ExternalID__c = keyIdParts[0];
                    ci.tax_id__c = keyIdParts[1];
                    if(keyIdParts.size() >= 3) {
                        ci.Provider_Name__c = keyIdParts[2];
                    }
                }else{
                    ci.ExternalID__c = keyId;
                }
                if(isIssueResolved == true){
                    ci.Resolved__c = true;
                    ci.Resolved_Reason__c = 'Resolved';
                } else {
                    ci.Resolved__c = Boolean.valueOf(keyIdMap.get(keyId));  
                    //adding default resolved reason if Case Item is Resolved [Genesis:added10/19/2017- US793868]
                    if(Boolean.valueOf(keyIdMap.get(keyId))) {                  
                        ci.Resolved_Reason__c = 'Resolved';
                    }       
                }    
                caseItems.add(ci);
            }                        
        }else{
            //create a dummy case item
            Case_Item__c ci = new Case_Item__c();
            ci.Case__c = caseId; 
            ci.Resolved__c = true;
            //adding default resolved reason [Genesis:added10/19/2017- US793868]
            ci.Resolved_Reason__c = 'Resolved';
            caseItems.add(ci);
        } 
        if(Case_Item__c.SObjectType.getDescribe().isCreateable()) {  //code added as per the Checkmarx improvement -Rahul
          insert caseItems;    
      }         
    }
    
    public static void addCaseComment(String caseId, String cc){
        if(!String.isEmpty(cc)){
            CaseComment objcc = new CaseComment();
            objcc.CommentBody = cc;
            objcc.ParentId = caseId;
              if(CaseComment.SObjectType.getDescribe().isCreateable()) {  //code added as per the Checkmarx improvement -Rahul
                insert objcc;   
           }         
        }
    }
    
    //This method is used to convert autodoc field data to files
    public static void addFilesToCase(String caseId, String Autodoc){
        
        Case cId = [Select Id,CaseNumber from case where Id=:caseId];
        
        ContentVersion conVer = new ContentVersion();
        conVer.ContentLocation = 'S'; // S specify this document is in SF, use E for external files
        conVer.PathOnClient = 'autodoc.html'; // The files name, extension is very important here which will help the file in preview.
        conVer.Title = 'Autodoc '+cId.CaseNumber; // Display name of the files
        conVer.VersionData =  blob.valueof(Autodoc); // converting your binary string to Blog
        insert conVer;
        
        // First get the content document Id from ContentVersion
        Id conDoc = [SELECT ContentDocumentId FROM ContentVersion WHERE Id =:conVer.Id].ContentDocumentId;
         
        //Create ContentDocumentLink
        ContentDocumentLink cDe = new ContentDocumentLink();
        cDe.ContentDocumentId = conDoc;
        cDe.LinkedEntityId = caseId; // you can use objectId,GroupId etc
        cDe.ShareType = 'I'; 
        //cDe.Visibility = 'InternalUsers';
        insert cDe;
        
    }
    public List<SelectOption> getMisdirectedReasons(){
        List<SelectOption> options = new List<SelectOption>();
        
        options.add(new SelectOption('','--None--'));
        options.add(new SelectOption('Cosmos','Cosmos'));
        options.add(new SelectOption('CSP Facets','CSP Facets'));
        options.add(new SelectOption('Dental Plan','Dental Plan'));
        options.add(new SelectOption('Member Service','Member Service'));
        options.add(new SelectOption('Other','Other'));
        options.add(new SelectOption('Global Restricted','Global Restricted'));
        options.add(new SelectOption('UHG Restricted','UHG Restricted'));
        options.add(new SelectOption('Pharmacy RX Other','Pharmacy RX Other'));
        options.add(new SelectOption('Prime','Prime'));
        options.add(new SelectOption('Provider Relations','Provider Relations'));
        options.add(new SelectOption('Pulse','Pulse'));
        options.add(new SelectOption('UNET','UNET'));
        options.add(new SelectOption('Vision Plan','Vision Plan'));
        options.add(new SelectOption('Wrong Carrier','Wrong Carrier'));
        return options;     
    }
    
    public List<SelectOption> getCancelReasons(){
        List<SelectOption> options = new List<SelectOption>();        
        options.add(new SelectOption('','--None--'));
        options.add(new SelectOption('Caller Disconnected','Caller Disconnected'));
        options.add(new SelectOption('Created In Error','Created In Error'));        
        return options;     
    }   
    
    public void setNotFound(String subType, String subID) {
        CaseObj.Subject_Type__c = subType;
        CaseObj.Id__c = subID;
    }
}