public with sharing class ACETGroupNotFoundController {
    public String InteractionType { get; set; }
    public String EmployerName {get;set;}
    public String GroupNumber {get;set;}
    public Date dateOfBirth { get; set; }
    public String LastName { get; set; }
    public String FirstName { get; set; }
    public String GId { get; set; }
    public String GName { get; set; }
    public string ContactName { get; set; }                        //for group
    public String zipcode { get; set; }
    public String State {get;set;}
    public String PhoneNumber {get;set;} 
    public Case StartDate{get;set;}
    public String InteractionId;
    public string addInfo;
    Public String NotFoundFLowName {get;set;}
    public Interaction__c  Interaction{get;set;}
    
    public ACETGroupNotFoundController() {
        StartDate = new Case();
        InteractionId = ApexPages.currentPage().getParameters().get('InteractionId');        
        system.debug('------Interaction id---->'+InteractionId);
        addInfo = ApexPages.currentPage().getParameters().get('additionalInfo');
            system.debug('!!!@@@addInfo'+addInfo);
                
        if(InteractionId == '')
        {
            Interaction = new Interaction__c();
            InteractionType = ApexPages.currentPage().getParameters().get('IT');
            Interaction.Interaction_Type__c = InteractionType;
        }
        else
        {
            Interaction = ACETMemberQueryUtil.queryInteraction(interactionId);
        }
        //InteractionType = ApexPages.currentPage().getParameters().get('IT');        
        /*string dateString = ApexPages.currentPage().getParameters().get('DOB');
        if(dateString != '' && dateString != null){            
            StartDate.tst_Date_Field__c = date.parse(dateString);
            dateOfBirth = StartDate.tst_Date_Field__c;
        }*/
        GId = ApexPages.currentPage().getParameters().get('MID');        
        zipcode     = ApexPages.currentPage().getParameters().get('zip');
        GName    = ApexPages.currentPage().getParameters().get('GN');
        State       = ApexPages.currentPage().getParameters().get('ST');
        PhoneNumber = ApexPages.currentPage().getParameters().get('PH');
        NotFoundFLowName = 'GroupNotFoundFlow';
        
       /* system.debug(LoggingLevel.INFO, 'InteractionType: ' + InteractionType + ', ContactName: ' + ContactName + ', LastName: ' + LastName + ', FirstName: ' + FirstName);
        system.debug(LoggingLevel.INFO, ', TaxId: ' + TaxId + ', Npi: ' + Npi  + ', phoneNumber: ' + phoneNumber);*/
    }
    
    public PageReference RedirectFromGroupNotFound() {
        PageReference pageRef ;
        // logic for lastname + Phone number to be addded
        try {                        
            system.debug('all parameter : ' + InteractionType+GId +zipcode+LastName+firstName+State+PhoneNumber+EmployerName+GroupNumber);   
            system.debug('------IN Pageref---->');
            system.debug('!!!@@@addInfo'+addInfo);            
            system.debug('!!!! Interaction'+InteractionId);  
            if(InteractionId == '' )
            {   
                system.debug('interaction !!!');
                Interaction =  ACETMemberQueryUtil.queryInteraction(InteractionType, Label.ACETProviderNotFoundOriginatorType,GName, '', GName, phoneNumber,StartDate.tst_Date_Field__c,state,zipcode,GId,NotFoundFLowName);
                //US1008265 Checkmarx code
				if(Interaction__c.SObjectType.getDescribe().isCreateable()){
	                insert Interaction;
				}
                system.debug('interaction !!!@@@'+Interaction);
            }
            else
           {
                Interaction = ACETMemberQueryUtil.queryInteractionMemInFocus(interactionId,InteractionType,Label.ACETProviderNotFoundOriginatorType,GName, '', GName, phoneNumber,StartDate.tst_Date_Field__c,state,zipcode,GId,NotFoundFLowName);
           }
           
            //system.debug('------Pageref-Interaction--->'+ StartDate.tst_Date_Field__c);
            //system.debug(LoggingLevel.INFO, 'Interaction for Manual Member Created : ' + Interaction);            
            //string urlstr = '/apex/acetmemberdetail?lastName='+ Interaction.originator__r.Lastname + '&firstName=' + Interaction.originator__r.firstname + '&SRK=' + '&subjectdob=' +  Interaction.originator__r.birthdate + '&sourceOriginator= '+ Interaction.Originator_Type__c+ '&InteractionId='+ Interaction.Id +'&mnf=1&core.apexpages.devmode.url=1' ;
            //
            //pageRef = new PageReference(urlstr);
    
            pageRef = page.ACETViewEmployerGroup;
            pageRef.getParameters().put('gnf','1');
            pageRef.getParameters().put('gnfEmployerName',GName);
            pageRef.getParameters().put('gnfzipcode',zipcode);
            pageRef.getParameters().put('Id',GId);
            pageRef.getParameters().put('contactName',contactName);
            pageRef.getParameters().put('gnfState',State);
            pageRef.getParameters().put('gnfPhoneNumber',PhoneNumber);
            pageRef.getParameters().put('additionalInfo',addInfo);
            pageRef.getParameters().put('InteractionId',Interaction.Id);
            system.debug('------Pageref---->'+ pageRef);
            //pageRef.getParameters().put('lastName',Interaction.originator__r.Lastname);
            //pageRef.getParameters().put('firstName',Interaction.originator__r.firstname);
            //pageRef.getParameters().put('subjectdob',date.valueOf(Interaction.originator__r.birthdate));
            
            //+'&IT='+InteractionType+'&LN='+lastName+'&FN='+firstName+'&PH='+phoneNumber+'&MID='+memberId+'&DOB='+dateOfBirth);
            pageRef.setRedirect(True);
        }
        catch (Exception ex) {
            system.debug(LoggingLevel.INFO, 'Error creating Interaction. Details: ' + ex.getMessage());
            pageRef=null;
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, system.Label.ACETUnexpectedErrorMessage));
        }
       
        return pageRef;
    }
}