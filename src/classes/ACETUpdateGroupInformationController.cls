public with sharing class ACETUpdateGroupInformationController {

     public ACETCallTopicsDataWrapper wrapper { get; set; }   
     public string authorizedContact{get;set;}
     public string groupName{get;set;}   
     public string groupId{get;set;}   
     public string comments{get;set;} 
     public String swivelCirrus_URL{get;set;}
     public Interaction__c Interaction { get; set; } 
     public Contact Subject { get; set; } 
     public ACETHighlightsPanelAdditionalInfo AdditionalInfo {get;set;}
     public String hpAdditionInfoStr {get{
        return JSON.serialize(AdditionalInfo);
     }set;}      
         public ACETUpdateGroupInformationController(){
            string callTopic = apexpages.currentpage().getparameters().get('callTopic');
            groupId = apexpages.currentpage().getparameters().get('groupId');
            wrapper = new ACETCallTopicsDataWrapper();
            wrapper.updategroupinfoSave = true;
            wrapper.CaseObj.Topic__c = callTopic;
            if(groupId != Null && groupId != '')
	        wrapper.caseObj.ID__c =groupId;
	          
            String InteractionId = apexpages.currentpage().getparameters().get('InteractionId');
            if(InteractionId != null && InteractionId != '')
            Interaction = ACETProviderUtility.GetInteractionByID(InteractionId);
            initHighlightPanelAdditionalInfo();
         } 
         
        private void initHighlightPanelAdditionalInfo(){
        if(AdditionalInfo == null){
            AdditionalInfo = new ACETHighlightsPanelAdditionalInfo(); 
        }        
        string addInfo = ApexPages.currentPage().getParameters().get('additionalInfo');
        if(addInfo != null)
        {
            AdditionalInfo  = (ACETHighlightsPanelAdditionalInfo)JSON.deserialize(addInfo, ACETHighlightsPanelAdditionalInfo.class);
        }
        /******added by sourabh ****/
        if(Interaction != Null && Interaction.Highlight_Panel_GroupInfo__c != null)
        {
            ACETGroupDetailsWrapper deserializedExceptionData = (ACETGroupDetailsWrapper)JSON.deserialize(Interaction.Highlight_Panel_GroupInfo__c, ACETGroupDetailsWrapper.class);
            AdditionalInfo.UHCBS = deserializedExceptionData.UHCBS;    
            AdditionalInfo.GroupN = deserializedExceptionData.GroupName ;
            AdditionalInfo.GroupStatus = deserializedExceptionData.GroupStatus;
            AdditionalInfo.ServiceTeam = deserializedExceptionData.ServiceTeam;
            //AdditionalInfo.EffectiveStartDate = deserializedExceptionData.EffectiveStartDate;
            AdditionalInfo.RiskManagement = deserializedExceptionData.RiskManagement;
            AdditionalInfo.RatingMethod = '';
            AdditionalInfo.RenewalDate= deserializedExceptionData.RenewalDate; 
            AdditionalInfo.RelationshipType = deserializedExceptionData.RelationshipType ;
            AdditionalInfo.groupSName = deserializedExceptionData.groupSName;
        }
           
        hpAdditionInfoStr = JSON.serialize(AdditionalInfo);
     }
       
}