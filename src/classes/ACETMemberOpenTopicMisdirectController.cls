public with sharing class ACETMemberOpenTopicMisdirectController{
    public Case newCase{get;set;}
    public ACETHighlightsPanelAdditionalInfo additionalInfoWrapper{get;set;}
    
    public ACETMemberOpenTopicMisdirectController(){
        newCase = new Case();
        newCase.Status='Canceled';
        
        /*newCase.Interaction__cnteraction__c = ApexPages.currentPage().getParameters().get('interactionId');
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
    public static Boolean createCaseRA(String newJCase,String prevCase){
        system.debug('Remote Prev Case>>>>'+prevCase);
        Case prevDTCase = new Case();
        
        Case newCase = new Case();
        newCase = (Case)JSON.Deserialize(newJCase,Case.class);
        newCase.Status='Canceled';
        
        //Assign Old page case fields
        if(prevCase!=null){
            prevDTCase = (Case)JSON.Deserialize(prevCase,Case.class);
            newCase.Topic__c = prevDTCase.Topic__c;
        }
        
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