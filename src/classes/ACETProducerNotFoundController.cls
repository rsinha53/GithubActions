public with sharing class ACETProducerNotFoundController {
    
    public String producerName { get; set; }
    public String contactName { get; set; }
    public String State {get;set;}
    public String PhoneNumber {get;set;}
    public String temp {get;set;}   
    public String InteractionType {get;set;}
    public String PID {get;set;}
    Public string NotFoundFLowName {get;set;}
    
    public Interaction__c  Interaction{get;set;}
    
    public ACETProducerNotFoundController(){
         NotFoundFLowName = 'ProducerNotFoundFlow';      
        Interaction = new Interaction__c();
        InteractionType = ApexPages.currentPage().getParameters().get('InteractionType');
        PID = ApexPages.currentPage().getParameters().get('ProducerId');
    }
    
    public PageReference RedirectFromProducerNotFound() {
        PageReference pageRef = ApexPages.currentPage();
        try {
            Interaction =  ACETMemberQueryUtil.queryInteraction(InteractionType, Label.ACETProviderNotFoundOriginatorType,'', '', producerName, phoneNumber,null,State,'','',NotFoundFLowName);
            //US1008265 Checkmarx code
            if(Interaction__c.SObjectType.getDescribe().isCreateable()){
                insert Interaction;
			}
            Interaction = ACETMemberQueryUtil.queryInteraction(Interaction.id);
            Interaction.Producer_Name__c = producerName;
            Interaction.Originator_Name__c = producerName;
            update Interaction;
            
            Third_Party__c tp = [SELECT id,Producer_Name__c, Producer_ID__c FROM Third_party__c where id =: Interaction.Third_Party__c ];
            tp.Producer_Name__c = producerName;
            tp.Producer_ID__c = PID;
            update tp;
            system.debug(LoggingLevel.INFO, 'Interaction for Manual Producer Created : State @@' + State + 'Interaction :: ' + Interaction);

            pageRef = new PageReference('/apex/ACETProducerDetail?InteractionId='+ Interaction.id +'&PNFProducerName='+producerName + '&PNFContactName='+contactName + '&PNFPhoneNumber='+phoneNumber +'&pnf=1'+'&PNFProducerId='+PID);
            pageRef.setRedirect(true);
        }
        catch (Exception ex) {
            system.debug(LoggingLevel.INFO, 'Error creating Interaction. Details: ' + ex.getMessage());
            pageRef=null;
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, system.Label.ACETUnexpectedErrorMessage));
        }
        
        return pageRef;
    }
}