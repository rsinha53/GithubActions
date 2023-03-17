public with sharing class ACETSearchEmployerGroupController{  
    public ACETDatatableWrapper DTWrapper {get;set;}
    public ACETCallTopicsDataWrapper wrapper {get;set;}
    public String SourceOriginator {get;set;}   
    public Interaction__c Interaction { get; set; }  
    public List<ACETGroupSearchResult> Results {get;set;} 
    public ACETHighlightsPanelAdditionalInfo AdditionalInfo { get; set;} 
    public String hpAdditionInfoStr {get{
        return EncodingUtil.urlEncode(JSON.serialize(AdditionalInfo), 'UTF-8');
        //return JSON.serialize(AdditionalInfo);
    }set;}
    public String State {get;set;}
    public String detailTabName{get;set;}
    //Group search fields//
    public String groupId {get;set;}
    public String groupTaxId {get;set;}
    public String GName {get;set;}
    public Boolean IsGroup{get;set;}
    Public String interactionId {get; set;}
    public class applicationException extends Exception {}
    
    public ACETSearchEmployerGroupController(){
     string vccdParam = ApexPages.currentPage().getParameters().get('vccdParams');
            system.debug('------vccdParam------'+vccdParam );
            if(vccdParam != '' && vccdParam != null){
                ApexPages.currentPage().getParameters().put('vccdsearch','true');
            }else{
              ApexPages.currentPage().getParameters().put('vccdsearch','false');

            }
    IsGroup = true;
    interactionId = ApexPages.currentPage().getParameters().get('InteractionId');
    system.debug('interaction id '+interactionId);
     if (!String.isEmpty(interactionId))
     {                        
            system.debug('InteractionId: ' + InteractionId);
            system.debug('------------InteractionId--------- '+InteractionId);
            //Query Provider Interaction details
            Interaction = ACETMemberQueryUtil.queryInteraction(interactionId);          
            IsGroup = false;
            SourceOriginator = Interaction.Interaction_Type__c;
            system.debug('Interaction: ' + Interaction + ', SourceOriginator: ' + SourceOriginator);
            initHighlightPanelAdditionalInfo();
      
      }
      system.debug('------DTWrapper------'+DTWrapper);                                   
    }
    private void initHighlightPanelAdditionalInfo(){
        
        string addInfo = ApexPages.currentPage().getParameters().get('additionalInfo');
        if(!String.isEmpty(addInfo))
        {
            AdditionalInfo  = (ACETHighlightsPanelAdditionalInfo)JSON.deserialize(addInfo, ACETHighlightsPanelAdditionalInfo.class);
            AdditionalInfo.producerSubject = '';
            AdditionalInfo.isGroup = String.valueof(IsGroup);
        }else{
        if(AdditionalInfo == null){
            AdditionalInfo = new ACETHighlightsPanelAdditionalInfo(); 
        }        
        AdditionalInfo.producerSubject = Interaction.Originator__r.Name;
        AdditionalInfo.producerOriginator =  Interaction.Originator__r.Name;
        AdditionalInfo.producerId = Interaction.Originator__r.EID__c;
        AdditionalInfo.isGroup = String.valueof(IsGroup);//added by Vishakha  
        hpAdditionInfoStr = JSON.serialize(AdditionalInfo);
       }
        hpAdditionInfoStr = JSON.serialize(AdditionalInfo);
    }
     
    public void search(){
        try{
            Results = null;
            ApexPages.currentPage().getParameters().put('autosearch','0');
            
            groupId = groupId.trim();
            groupTaxId = groupTaxId.trim();
            
            ACETFindEmployerGroupSearchWebService FindGroupService = new ACETFindEmployerGroupSearchWebService();
            FindGroupService.init(groupId, groupTaxId, GName, state);  
                        
            DTWrapper = new ACETDatatableWrapper('ACETFindEmployerGroupSearchWebService', FindGroupService);         
            DTWrapper.Columns.add(new ACETDataTableWrapper.DataColumn('Group Name', 'groupName'));
            DTWrapper.Columns.add(new ACETDataTableWrapper.DataColumn('Renewal Date', 'renewalDate'));
            DTWrapper.Columns.add(new ACETDataTableWrapper.DataColumn('Group Number', 'groupId'));
            DTWrapper.Columns.add(new ACETDataTableWrapper.DataColumn('Tax ID', 'taxid'));
            DTWrapper.Columns.add(new ACETDataTableWrapper.DataColumn('Address', 'addresses'));
            DTWrapper.Columns.add(new ACETDataTableWrapper.DataColumn('City', 'city'));
            DTWrapper.Columns.add(new ACETDataTableWrapper.DataColumn('State', 'state'));
            DTWrapper.Columns.add(new ACETDataTableWrapper.DataColumn('Zip Code', 'zipcode'));
            DTWrapper.Columns.add(new ACETDataTableWrapper.DataColumn('Group Source Code', 'sourcesystem'));
            DTWrapper.PageSize = 15;
        
            string vccdParam = ApexPages.currentPage().getParameters().get('vccdParams');//added by swetha
   string groupnumber = ApexPages.currentPage().getParameters().get('groupnumber');
            system.debug('------vccdParam------'+vccdParam );
            if(vccdParam != '' && vccdParam != null){
                ApexPages.currentPage().getParameters().put('noAutoSearch','true');
            }else{
             ApexPages.currentPage().getParameters().put('noAutoSearch','false');
  
            }
            //added by swetha
            }catch(Exception ex){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, label.ACETOILNotAvailable));
        }
          
    }
     
        
    public void clear(){
            groupId = '';
            groupTaxId = '';
            GName    = '';
            SourceOriginator = '';   
            Results = null;
            DTWrapper = null;
        if(IsGroup == true){
           Interaction = null;
        }
        
    }
     public List<SelectOption> getSourceOriginators(){
        List<SelectOption> lstInteractionTypes = new List<SelectOption>();
        User currentUser = [select profile.Name from User where Id = :UserInfo.getUserId()];
        if(currentUser.profile.Name.contains('Research User')){
            lstInteractionTypes.add(new SelectOption('Research Only','Research Only')); 
        } 
     /******   else{
            options.add(new SelectOption('Phone Call','Phone Call'));
            options.add(new SelectOption('Chat','Chat'));
            options.add(new SelectOption('Email','Email'));
            options.add(new SelectOption('Fax','Fax'));
            options.add(new SelectOption('Inbound Correspondence','Inbound Correspondence'));        
            options.add(new SelectOption('Mail','Mail'));
            options.add(new SelectOption('Outbound Call','Outbound Call'));        
            options.add(new SelectOption('Portal','Portal'));
            options.add(new SelectOption('Text','Text'));
            options.add(new SelectOption('Walk-In','Walk-In'));
        }
        return options;     *****/
        else{
            for(String IntrType :Label.ACETGroupSearchInteractionTypes.split(','))
            {
                lstInteractionTypes.add(new SelectOption(IntrType, IntrType));
            }
            system.debug(LoggingLevel.INFO, 'lstInteractionTypes: ' + lstInteractionTypes);
        }
        return lstInteractionTypes;
    } 
    Cache.SessionPartition sessionPartition;
    //String partitionInput = 'acetdev'; Commented by Divya and passing the value from custom label
    String partitionInput = label.ACETPlatformCache;
    
/*    public void updateCache()
    {
        sessionPartition = getPartition();
        if (sessionPartition.contains('interactionId')) {
            getPartition().put('interactionId', '');   
        } 
    } 
    
    private Cache.SessionPartition getPartition() {
       if (sessionPartition == null) {
            sessionPartition = Cache.Session.getPartition(partitionInput);
       }
       return sessionPartition;
     } 
*/     
     @RemoteAction
    public static String createInteraction(String interactionType, String interactionId, String groupNumber){          
        Interaction__c interaction = new Interaction__c();  
        interaction.Interaction_Type__c = interactionType;
        Interaction.Originator_Type__c = 'Group/Employer';
        Interaction.Group_ID__c = groupNumber;
        //US1008265 Checkmarx code
        if(Interaction__c.SObjectType.getDescribe().isCreateable()){
            insert interaction;
        }
 
        return interaction.Id;    
           
    }
     
    /**
    public void createInteraction(){
      if(Interaction == null){
            interaction = new Interaction__c();
            interaction.Interaction_Type__c = SourceOriginator;
            Interaction.Originator_Type__c = 'Group/Employer';
            insert interaction; 
        }  
      
    } 
    */
    
    public List<SelectOption> getStateOptions(){                        
        List<SelectOption> stateOptions = new List<SelectOption>();   
             
        stateOptions.add(new SelectOption('', '--None--'));
        stateOptions.add(new SelectOption('AK', 'AK'));
        stateOptions.add(new SelectOption('AL', 'AL'));
        stateOptions.add(new SelectOption('AR', 'AR'));
        stateOptions.add(new SelectOption('AZ', 'AZ'));
        stateOptions.add(new SelectOption('CA', 'CA'));
        stateOptions.add(new SelectOption('CO', 'CO'));
        stateOptions.add(new SelectOption('CT', 'CT'));
        stateOptions.add(new SelectOption('DC', 'DC'));
        stateOptions.add(new SelectOption('DE', 'DE'));
        stateOptions.add(new SelectOption('FL', 'FL'));
        stateOptions.add(new SelectOption('GA', 'GA'));
        stateOptions.add(new SelectOption('HI', 'HI'));
        stateOptions.add(new SelectOption('IA', 'IA'));
        stateOptions.add(new SelectOption('ID', 'ID'));
        stateOptions.add(new SelectOption('IL', 'IL'));
        stateOptions.add(new SelectOption('IN', 'IN'));
        stateOptions.add(new SelectOption('KS', 'KS'));
        stateOptions.add(new SelectOption('KY', 'KY'));
        stateOptions.add(new SelectOption('LA', 'LA'));
        stateOptions.add(new SelectOption('MA', 'MA'));
        stateOptions.add(new SelectOption('MD', 'MD'));
        stateOptions.add(new SelectOption('ME', 'ME'));
        stateOptions.add(new SelectOption('MI', 'MI'));
        stateOptions.add(new SelectOption('MN', 'MN'));
        stateOptions.add(new SelectOption('MO', 'MO'));
        stateOptions.add(new SelectOption('MS', 'MS'));
        stateOptions.add(new SelectOption('MT', 'MT'));
        stateOptions.add(new SelectOption('NC', 'NC'));
        stateOptions.add(new SelectOption('ND', 'ND'));
        stateOptions.add(new SelectOption('NE', 'NE'));
        stateOptions.add(new SelectOption('NH', 'NH')); 
        stateOptions.add(new SelectOption('NJ', 'NJ'));
        stateOptions.add(new SelectOption('NM', 'NM'));
        stateOptions.add(new SelectOption('NV', 'NV'));
        stateOptions.add(new SelectOption('NY', 'NY'));
        stateOptions.add(new SelectOption('OH', 'OH'));
        stateOptions.add(new SelectOption('OK', 'OK'));
        stateOptions.add(new SelectOption('OR', 'OR'));
        stateOptions.add(new SelectOption('PA', 'PA'));
        stateOptions.add(new SelectOption('PR', 'PR'));
        stateOptions.add(new SelectOption('RI', 'RI'));
        stateOptions.add(new SelectOption('SC', 'SC'));
        stateOptions.add(new SelectOption('SD', 'SD'));
        stateOptions.add(new SelectOption('TN', 'TN'));
        stateOptions.add(new SelectOption('TX', 'TX'));
        stateOptions.add(new SelectOption('UT', 'UT'));
        stateOptions.add(new SelectOption('VA', 'VA'));
        stateOptions.add(new SelectOption('VT', 'VT'));
        stateOptions.add(new SelectOption('WA', 'WA'));
        stateOptions.add(new SelectOption('WI', 'WI'));
        stateOptions.add(new SelectOption('WV', 'WV'));
        stateOptions.add(new SelectOption('WY', 'WY'));        
        return stateOptions;
    }     
}