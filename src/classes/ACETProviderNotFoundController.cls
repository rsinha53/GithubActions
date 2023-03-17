public class ACETProviderNotFoundController {
    public String InteractionType { get; set; }
    public String ContactName { get; set; }
    public String LastName { get; set; }
    public String FirstName { get; set; }
    public String TaxId { get; set; }
    public String Npi { get; set; }
    public String phoneNumber { get; set; }
    public String FilterBy { get; set; }
     Public string notfoundFlowname {get;set;}
    
    public Interaction__c  Interaction{get;set;}
    
    public ACETProviderNotFoundController() {
        Interaction = new Interaction__c();
        InteractionType = ApexPages.currentPage().getParameters().get('IT');
        ContactName = ApexPages.currentPage().getParameters().get('CN');
        TaxID       = ApexPages.currentPage().getParameters().get('TID');
        FilterBy    = ApexPages.currentPage().getParameters().get('FB');
        Npi         = ApexPages.currentPage().getParameters().get('NPI');
        LastName    = ApexPages.currentPage().getParameters().get('LN');
        firstName   = ApexPages.currentPage().getParameters().get('FN');
        notfoundFlowname = 'ProviderNotFoundFlow';
        phoneNumber = ApexPages.currentPage().getParameters().get('Phone');
        
        system.debug(LoggingLevel.INFO, 'InteractionType: ' + InteractionType + ', ContactName: ' + ContactName + ', LastName: ' + LastName + ', FirstName: ' + FirstName);
        system.debug(LoggingLevel.INFO, ', TaxId: ' + TaxId + ', Npi: ' + Npi  + ', phoneNumber: ' + phoneNumber);
    }
    
    public PageReference RedirectFromProviderNotFound() {
        PageReference pageRef = ApexPages.currentPage();
        
        try {
            
            Interaction = ACETProviderUtility.CreateInteraction(InteractionType, Label.ACETProviderNotFoundOriginatorType, ContactName, TaxId, Npi, LastName, FirstName, phoneNumber, notfoundFlowname);
            insert Interaction;
         //Added by Avish on 07072017 for highlightpanel name fix
            Interaction = ACETMemberQueryUtil.queryInteraction(Interaction.id);
            system.debug(LoggingLevel.INFO, 'Interaction for Manual Provider Created : ' + Interaction);
            pageRef = new PageReference('/apex/ACETProviderDetail?Id='+ Interaction.id + '&PNFNPI='+NPI +'&PNFContactName='+contactName + '&PNFFirstName='+FirstName + '&PNFLastName='+LastName + '&PNFPhoneNumber='+phoneNumber + '&PNFTaxId='+TaxId + '&PNFProviderTypeCode='+FilterBy + '&pnf=1');
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