public with sharing class ACETMemberOpenTopicCancelController{
    public Case newCase{get;set;}
    public String prevCase{get;set;}
    public ACETHighlightsPanelAdditionalInfo additionalInfoWrapper{get;set;}
    public Boolean isCancelTyp{get;set;}
    public Boolean isMisDirectTyp{get;set;}
    
    public ACETMemberOpenTopicCancelController(){
        newCase = new Case();
        newCase.Status='Canceled';
        
        /*newCase.Interaction__c = ApexPages.currentPage().getParameters().get('interactionId');
        newCase.ContactId = ApexPages.currentPage().getParameters().get('contactId');
        newCase.Topic__c = ApexPages.currentPage().getParameters().get('callTopic');
        String originatorRelationship = apexpages.currentpage().getparameters().get('originatorRelationship');
        if(originatorRelationship !=null){
            newCase.Originator_Relationship__c = originatorRelationship;
        }*/
    }
    
    public void createCase(){
        try{
            if(additionalInfoWrapper!=null && additionalInfoWrapper.OriginatorRelationship!=null){
                newCase.Originator_Relationship__c = additionalInfoWrapper.OriginatorRelationship;
            }
            insert newCase;
        }catch(Exception e){
            system.debug('Errors Found'+e.getMessage());
            apexpages.addmessages(e);
        }
    }
    
    @remoteAction
    public static Boolean createCaseRA(String newJCase){
        Case newCase = new Case();
        newCase = (Case)JSON.Deserialize(newJCase,Case.class);
        newCase.Status='Canceled';
        
        system.debug('after des Case>>>>'+newCase);
        
        boolean status;
        try{
            insert newCase;
            status =true;
        }catch(Exception e){
            system.debug('Errors Found'+e.getMessage());
            apexpages.addmessages(e);
            status = false;
        }
        
        return status;
    }
}