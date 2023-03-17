public with sharing class ACETMemberNotFoundController {
    public String InteractionType { get; set; }
    public String EmployerName {get;set;}
    public String GroupNumber {get;set;}
    public Date dateOfBirth { get; set; }
    public String LastName { get; set; }
    public String FirstName { get; set; }
    public String memberId { get; set; }
    public String zipcode { get; set; }
    public String State {get;set;}
    public String PhoneNumber {get;set;}
    public Interaction__c StartDate{get;set;}
     
    public Interaction__c  Interaction{get;set;}
    Public string NotFoundFLowName {get;set;}
    public ACETMemberNotFoundController() {
        StartDate = new Interaction__c();
        String InteractionId = ApexPages.currentPage().getParameters().get('InteractionId');        
        system.debug('------Interaction id---->'+InteractionId);
        string addInfo = ApexPages.currentPage().getParameters().get('additionalInfo');
            system.debug('!!!@@@addInfo'+addInfo);
        NotFoundFLowName = 'MemberNotFoundFlow';                
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
        string dateString = ApexPages.currentPage().getParameters().get('DOB');
        if(dateString != '' && dateString != null){            
            StartDate.tst_Date_Field__c = date.parse(dateString);
            dateOfBirth = StartDate.tst_Date_Field__c;
        }
        memberId    = ApexPages.currentPage().getParameters().get('MID');
        zipcode     = ApexPages.currentPage().getParameters().get('zip');
        LastName    = ApexPages.currentPage().getParameters().get('LN');
        firstName   = ApexPages.currentPage().getParameters().get('FN');
        State       = ApexPages.currentPage().getParameters().get('ST');
        PhoneNumber = ApexPages.currentPage().getParameters().get('PH');
        EmployerName = ApexPages.currentPage().getParameters().get('EN');
        GroupNumber    = ApexPages.currentPage().getParameters().get('GN');
        
       /* system.debug(LoggingLevel.INFO, 'InteractionType: ' + InteractionType + ', ContactName: ' + ContactName + ', LastName: ' + LastName + ', FirstName: ' + FirstName);
        system.debug(LoggingLevel.INFO, ', TaxId: ' + TaxId + ', Npi: ' + Npi  + ', phoneNumber: ' + phoneNumber);*/
    }
    
    public PageReference RedirectFromMemberNotFound() {
        PageReference pageRef ;
        // logic for lastname + Phone number to be addded
        try {                        
            system.debug('all parameter : ' + InteractionType+memberId+zipcode+LastName+firstName+State+PhoneNumber+EmployerName+GroupNumber);   
            system.debug('------IN Pageref---->');
            String InteractionId = ApexPages.currentPage().getParameters().get('InteractionId');        
            string addInfo = ApexPages.currentPage().getParameters().get('additionalInfo');
            system.debug('!!!@@@addInfo'+addInfo);
            
            system.debug('!!!! Interaction'+InteractionId);  
            if(InteractionId == '' )
            {   
                system.debug('interaction !!!');
                Interaction =  ACETMemberQueryUtil.queryInteraction(InteractionType, Label.ACETProviderNotFoundOriginatorType,EmployerName, LastName, firstName, phoneNumber,StartDate.tst_Date_Field__c,state,zipcode,groupnumber,NotFoundFLowName);
                insert Interaction;
                system.debug('interaction !!!@@@'+Interaction);
            }
            else
           {
                Interaction = ACETMemberQueryUtil.queryInteractionMemInFocus(interactionId,InteractionType,Label.ACETProviderNotFoundOriginatorType,EmployerName, LastName, firstName, phoneNumber,StartDate.tst_Date_Field__c,state,zipcode,groupnumber,NotFoundFLowName);
           }
           
            //system.debug('------Pageref-Interaction--->'+ StartDate.tst_Date_Field__c);
            //system.debug(LoggingLevel.INFO, 'Interaction for Manual Member Created : ' + Interaction);            
            //string urlstr = '/apex/acetmemberdetail?lastName='+ Interaction.originator__r.Lastname + '&firstName=' + Interaction.originator__r.firstname + '&SRK=' + '&subjectdob=' +  Interaction.originator__r.birthdate + '&sourceOriginator= '+ Interaction.Originator_Type__c+ '&InteractionId='+ Interaction.Id +'&mnf=1&core.apexpages.devmode.url=1' ;
            //
            //pageRef = new PageReference(urlstr);
    
            pageRef = page.acetmemberdetail;
            pageRef.getParameters().put('mnf','1');
            pageRef.getParameters().put('mnfEmployerName',EmployerName);
            pageRef.getParameters().put('mnfzipcode',zipcode);
            pageRef.getParameters().put('mnfLastName',LastName);
            pageRef.getParameters().put('mnffirstName',firstName);
            pageRef.getParameters().put('mnfState',State);
            pageRef.getParameters().put('mnfPhoneNumber',PhoneNumber);
            pageRef.getParameters().put('mnfGroupNumber',GroupNumber);
            pageRef.getParameters().put('mnfDOB',String.valueOf(StartDate.tst_Date_Field__c));
            pageRef.getParameters().put('mnfMemberId', MemberId);
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