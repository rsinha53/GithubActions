@istest
public class ACETCaseActionsControllerTest {
    
    @istest(SeeAllData=true)
    static void test1()
        
    {
        PageReference myVfPage = Page.ACETCommunicationSearchPage;
        Test.setCurrentPageReference(myVfPage); // use setCurrentPageReference, 
        // ApexPages.currentPage().getParameters().put('id',Opp.Id);
        ACETOrgNameToSwivelEndpointMap__c SwivelEndpoint = new ACETOrgNameToSwivelEndpointMap__c();
        SwivelEndpoint.name ='dev_ICUECreateAuthorization';
        SwivelEndpoint.Swivel_Endpoint__c = 'test';
        insert SwivelEndpoint;
        
        ACETOrgNameToSwivelEndpointMap__c SwivelEndpoint1 = new ACETOrgNameToSwivelEndpointMap__c();
        SwivelEndpoint1.name ='qa_ICUECreateAuthorization';
        SwivelEndpoint1.Swivel_Endpoint__c = 'test';
        insert SwivelEndpoint1;
        
        ACETOrgNameToSwivelEndpointMap__c SwivelEndpoint5 = new ACETOrgNameToSwivelEndpointMap__c();
        SwivelEndpoint5.name ='qa_ICUEPCPReferral';
        SwivelEndpoint5.Swivel_Endpoint__c = 'test';
        insert SwivelEndpoint5;
        
        ACETOrgNameToSwivelEndpointMap__c SwivelEndpoint9 = new ACETOrgNameToSwivelEndpointMap__c();
        SwivelEndpoint9.name ='prd_ICUEPCPReferral';
        SwivelEndpoint9.Swivel_Endpoint__c = 'test';
        insert SwivelEndpoint9;
        
        ACETOrgNameToSwivelEndpointMap__c SwivelEndpoint2 = new ACETOrgNameToSwivelEndpointMap__c();
        SwivelEndpoint2.name ='d1_ICUECreateAuthorization';
        SwivelEndpoint2.Swivel_Endpoint__c = 'test';
        insert SwivelEndpoint2;
        
        ACETOrgNameToSwivelEndpointMap__c swivel3 = new ACETOrgNameToSwivelEndpointMap__c();
        swivel3.Name = 'prd_ICUECreateAuthorization';
        swivel3.Swivel_Endpoint__c = 'ICUECreateAuthorization';
        insert swivel3;
        ACETWrapEncryptionKey__c encryptKey = new ACETWrapEncryptionKey__c();
        encryptKey.name ='dev_ICUEEncryptionKey';
        encryptKey.Algorithm_Name__c = 'AES256';
        encryptKey.Key__c= 'tbC2KA36qE1psxs9mozyfOmy7GdrI3I9';
        insert encryptKey ;
        
        
        ACETWrapEncryptionKey__c encryptKey1 = new ACETWrapEncryptionKey__c();
        encryptKey1.name ='qa_ICUEEncryptionKey';
        encryptKey1.Algorithm_Name__c = 'AES256';
        encryptKey1.Key__c= 'tbC2KA36qE1psxs9mozyfOmy7GdrI3I9';
        insert encryptKey1;
        
        ACETWrapEncryptionKey__c dev1key = new ACETWrapEncryptionKey__c();
        dev1key.Name = 'd1_ICUEEncryptionKey';
        dev1key.Algorithm_Name__c = 'AES256';
        dev1key.Key__c = 'tbC2KA36qE1psxs9mozyfOmy7GdrI3I9';
        insert dev1key;
        
        ACETWrapEncryptionKey__c prdkey = new ACETWrapEncryptionKey__c();
        prdkey.Name = 'prd_ICUEEncryptionKey';
        prdkey.Algorithm_Name__c = 'AES256';
        prdkey.Key__c = 'tbC2KA36qE1psxs9mozyfOmy7GdrI3I9';
        insert prdkey;
        Contact cont = createContactPA();
        Interaction__c InteractionId = new Interaction__c();
        InteractionId.Contact_Name__c = 'Text Iname';
        InteractionId.Originator__c = cont.id;
        InteractionId.Originator_Type__c = 'Member';
        InteractionId.Interaction_Type__c = 'Phone Call';
        
        Insert interactionId;
        
        case c = new
            case ();
        c.status = 'open';
        c.interaction__c = interactionId.id;
        insert c;
        Case_Item__c cs = new Case_Item__c();
        cs.case__c = c.id;
        cs.ExternalID__c = 'test1';
        insert cs;
        
        
        
        case ca = new
            case ();
        ca.status = 'Closed';
        ca.ID__c = '86796510400';
        ca.Topic__c = null;
        ca.Interaction__c = interactionid.ID;
        ca.Surrogate_Key__c = '12345';
        insert ca;
        
        
        
        case c1 = new
            case ();
        c1.status = 'Open';
        c1.parentid = ca.id;
        insert c1;
        
        string adddata = '{"Zip":null,"UHCBS":null,"surrogatekey":null,"State":null,"SitusState":"CT","ServiceTeam":null,"RiskManagement":null,"RenewalDate":null,"RelationshipType":"Self","Relationship":"Self","RatingMethod":null,"providerType":null,"providerPhoneNumber":null,"ProductType":"","Product":"","producerSubject":null,"producerOriginator":null,"producerName":null,"producerIDPNF":null,"producerId":null,"primarySpecialty":null,"PolicyNumber":null,"platinumProvider":null,"PhoneNumber":null,"OriginatorRelationship":null,"OriginatorDOB":null,"OnshoreIndicatorVerbiage":"No restriction; services allowed onshore and offshore.","OnshoreIndicator":"No","Network":"","MemberId":"86796510400","LastName":"Dolson","isProducerNotFound":null,"isMemNotFound":null,"isMember":" true","isGroupNotFound":null,"isGroup":null,"GroupStatus":null,"groupSName":null,"GroupNumber":"1078682","GroupName":"MICHAEL C. WEIGOLD INC","GroupN":null,"Gender":"F","FirstName":"Katie","EndDate":"12/31/9999","EmployerName":null,"EffectiveStartDate":null,"EffectiveDate":"1/1/2018","DOB":"11/11/1960","contactName":null,"ConsumerAccountIndicator":null,"BenefitPlanId":"PEDV000004","BenefitBundleOptionId":"1018478"}';
        myVfPage.getParameters().put('additionalInfo', adddata);
        myVfPage.getParameters().put('Id', InteractionId.Id);
        myVfPage.getParameters().put('InteractionId', InteractionId.Id);
        myVfPage.getParameters().put('subjectId', 'test');
        myVfPage.getParameters().put('subjectTabs', '["test"]');
        ACETCallTopicsDataWrapper acdatawrapper = new ACETCallTopicsDataWrapper();
        acdatawrapper.SurrogateKey = '12345';
        acdatawrapper.AutodocCaseItems = 'test1,test2,test3';
        ACETCaseActionsController acaseobj = new ACETCaseActionsController();
        acaseobj.callTopicDataWrapper = acdatawrapper;
        acaseobj.SurrogateKey = '';
        acaseobj.displayRelatedCasesBtn = true;
        acaseobj.extval = '';
        acaseobj.Caseitemlist = '';
        acaseobj.ViewRelatedCases();
        acaseobj.InteractionId = InteractionId.Id;
        acaseobj.wrapInteraction();
        acaseobj.Cancel();
        acaseobj.getIsComponentVisible();
        ACETLGT_CaseActionsController.PCPCreateURL('39045843900');
        
        
    }
    @istest static void test2()
        
    {
        PageReference myVfPage = Page.ACETCommunicationSearchPage;
        Test.setCurrentPageReference(myVfPage); // use setCurrentPageReference, 
        // ApexPages.currentPage().getParameters().put('id',Opp.Id);
        Contact cont = createContactPA();
        Interaction__c InteractionId = new Interaction__c();
        InteractionId.Contact_Name__c = 'Text Iname';
        InteractionId.Originator__c = cont.id;
        InteractionId.Originator_Type__c = 'Group/Employer';
        InteractionId.Interaction_Type__c = 'Phone Call';
        Insert interactionId;
        
        case c = new
            case ();
        c.status = 'open';
        c.interaction__c = interactionId.id;
        insert c;
        Case_Item__c cs = new Case_Item__c();
        cs.case__c = c.id;
        cs.ExternalID__c = 'test1';
        insert cs;
        
        
        
        case ca = new
            case ();
        ca.status = 'Closed';
        ca.ID__c = '86796510400';
        ca.Topic__c = null;
        ca.Interaction__c = interactionid.ID;
        ca.Surrogate_Key__c = '12345';
        insert ca;
        
        
        
        case c1 = new
            case ();
        c1.status = 'Open';
        c1.parentid = ca.id;
        insert c1;
        
        string adddata = '{"Zip":null,"UHCBS":null,"surrogatekey":null,"State":null,"SitusState":"CT","ServiceTeam":null,"RiskManagement":null,"RenewalDate":null,"RelationshipType":"Self","Relationship":"Self","RatingMethod":null,"providerType":null,"providerPhoneNumber":null,"ProductType":"","Product":"","producerSubject":null,"producerOriginator":null,"producerName":null,"producerIDPNF":null,"producerId":null,"primarySpecialty":null,"PolicyNumber":null,"platinumProvider":null,"PhoneNumber":null,"OriginatorRelationship":null,"OriginatorDOB":null,"OnshoreIndicatorVerbiage":"No restriction; services allowed onshore and offshore.","OnshoreIndicator":"No","Network":"","MemberId":"86796510400","LastName":"Dolson","isProducerNotFound":null,"isMemNotFound":null,"isMember":" false","isGroupNotFound":null,"isGroup":null,"GroupStatus":null,"groupSName":null,"GroupNumber":"1078682","GroupName":"MICHAEL C. WEIGOLD INC","GroupN":null,"Gender":"F","FirstName":"Katie","EndDate":"12/31/9999","EmployerName":null,"EffectiveStartDate":null,"EffectiveDate":"1/1/2018","DOB":"11/11/1960","contactName":null,"ConsumerAccountIndicator":null,"BenefitPlanId":"PEDV000004","BenefitBundleOptionId":"1018478"}';
        myVfPage.getParameters().put('additionalInfo', adddata);
        myVfPage.getParameters().put('Id', InteractionId.Id);
        myVfPage.getParameters().put('InteractionId', InteractionId.Id);
        myVfPage.getParameters().put('subjectId', 'test');
        myVfPage.getParameters().put('subjectTabs', '["test"]');
        ACETCallTopicsDataWrapper acdatawrapper = new ACETCallTopicsDataWrapper();
        acdatawrapper.SurrogateKey = '12345';
        acdatawrapper.AutodocCaseItems = 'test1,test2,test3';
        ACETCaseActionsController acaseobj = new ACETCaseActionsController();
        acaseobj.callTopicDataWrapper = acdatawrapper;
        // acaseobj.sortbyexternalid();
        acaseobj.ViewRelatedCases();
        acaseobj.InteractionId = InteractionId.Id;
        acaseobj.wrapInteraction();
        acaseobj.Cancel();
        acaseobj.getIsComponentVisible();
        
        
        
    }
    @istest static void test3()
        
    {
        PageReference myVfPage = Page.ACETCommunicationSearchPage;
        Test.setCurrentPageReference(myVfPage); // use setCurrentPageReference, 
        // ApexPages.currentPage().getParameters().put('id',Opp.Id);
        Contact cont = createContactPA();
        Interaction__c InteractionId = new Interaction__c();
        InteractionId.Contact_Name__c = 'Text Iname';
        InteractionId.Originator__c = cont.id;
        InteractionId.Originator_Type__c = 'Group/Employer';
        InteractionId.Group_ID__c = '12345';
        InteractionId.Interaction_Type__c = 'Phone Call';
        Insert interactionId;
        
        case c = new
            case ();
        c.status = 'open';
        c.interaction__c = interactionId.id;
        insert c;
        Case_Item__c cs = new Case_Item__c();
        cs.case__c = c.id;
        cs.ExternalID__c = 'test1';
        insert cs;
        
        
        
        case ca = new
            case ();
        ca.status = 'Closed';
        ca.ID__c = '12345';
        ca.Topic__c = null;
        ca.Interaction__c = interactionid.ID;
        ca.Surrogate_Key__c = '12345';
        insert ca;
        
        
        
        case c1 = new
            case ();
        c1.status = 'Open';
        c1.parentid = ca.id;
        insert c1;
        
        string adddata = '{"Zip":null,"UHCBS":null,"surrogatekey":null,"State":null,"SitusState":"CT","ServiceTeam":null,"RiskManagement":null,"RenewalDate":null,"RelationshipType":"Self","Relationship":"Self","RatingMethod":null,"providerType":null,"providerPhoneNumber":null,"ProductType":"","Product":"","producerSubject":null,"producerOriginator":null,"producerName":null,"producerIDPNF":null,"producerId":null,"primarySpecialty":null,"PolicyNumber":null,"platinumProvider":null,"PhoneNumber":null,"OriginatorRelationship":null,"OriginatorDOB":null,"OnshoreIndicatorVerbiage":"No restriction; services allowed onshore and offshore.","OnshoreIndicator":"No","Network":"","MemberId":"86796510400","LastName":"Dolson","isProducerNotFound":null,"isMemNotFound":null,"isMember":" true","isGroupNotFound":null,"isGroup":null,"GroupStatus":null,"groupSName":null,"GroupNumber":"1078682","GroupName":"MICHAEL C. WEIGOLD INC","GroupN":null,"Gender":"F","FirstName":"Katie","EndDate":"12/31/9999","EmployerName":null,"EffectiveStartDate":null,"EffectiveDate":"1/1/2018","DOB":"11/11/1960","contactName":null,"ConsumerAccountIndicator":null,"BenefitPlanId":"PEDV000004","BenefitBundleOptionId":"1018478"}';
        myVfPage.getParameters().put('additionalInfo', adddata);
        myVfPage.getParameters().put('Id', InteractionId.Id);
        myVfPage.getParameters().put('InteractionId', InteractionId.Id);
        myVfPage.getParameters().put('subjectId', 'test');
        myVfPage.getParameters().put('subjectTabs', '["test"]');
        ACETCallTopicsDataWrapper acdatawrapper = new ACETCallTopicsDataWrapper();
        acdatawrapper.SurrogateKey = '12345';
        acdatawrapper.AutodocCaseItems = 'test1,test2,test3';
        ACETCaseActionsController acaseobj = new ACETCaseActionsController();
        acaseobj.callTopicDataWrapper = acdatawrapper;
        // acaseobj.sortbyexternalid();
        acaseobj.ViewRelatedCases();
        acaseobj.InteractionId = InteractionId.Id;
        acaseobj.wrapInteraction();
        acaseobj.Cancel();
        acaseobj.getIsComponentVisible();
        
        
        
    }
    
    @istest static void test4()
        
    {
        PageReference myVfPage = Page.ACETCommunicationSearchPage;
        Test.setCurrentPageReference(myVfPage); // use setCurrentPageReference, 
        // ApexPages.currentPage().getParameters().put('id',Opp.Id);
        Contact cont = createContactPA();
        Interaction__c InteractionId = new Interaction__c();
        InteractionId.Contact_Name__c = 'Text Iname';
        InteractionId.Originator__c = cont.id;
        InteractionId.Originator_Type__c = 'Producer';
        InteractionId.Group_ID__c = '12345';
        InteractionId.Interaction_Type__c = 'Phone Call';
        Insert interactionId;
        
        case c = new
            case ();
        c.status = 'open';
        c.interaction__c = interactionId.id;
        insert c;
        Case_Item__c cs = new Case_Item__c();
        cs.case__c = c.id;
        cs.ExternalID__c = 'test1';
        insert cs;
        
        
        
        case ca = new
            case ();
        ca.status = 'Closed';
        ca.ID__c = '86796510400';
        ca.Topic__c = null;
        ca.Interaction__c = interactionid.ID;
        ca.Surrogate_Key__c = '12345';
        insert ca;
        
        
        
        case c1 = new
            case ();
        c1.status = 'Open';
        c1.parentid = ca.id;
        insert c1;
        
        string adddata = '{"Zip":null,"UHCBS":null,"surrogatekey":null,"State":null,"SitusState":"CT","ServiceTeam":null,"RiskManagement":null,"RenewalDate":null,"RelationshipType":"Self","Relationship":"Self","RatingMethod":null,"providerType":null,"providerPhoneNumber":null,"ProductType":"","Product":"","producerSubject":null,"producerOriginator":null,"producerName":null,"producerIDPNF":null,"producerId":"123456","primarySpecialty":null,"PolicyNumber":null,"platinumProvider":null,"PhoneNumber":null,"OriginatorRelationship":null,"OriginatorDOB":null,"OnshoreIndicatorVerbiage":"No restriction; services allowed onshore and offshore.","OnshoreIndicator":"No","Network":"","MemberId":"86796510400","LastName":"Dolson","isProducerNotFound":null,"isMemNotFound":null,"isMember":" false","isGroupNotFound":null,"isGroup":"false","GroupStatus":null,"groupSName":null,"GroupNumber":"1078682","GroupName":"MICHAEL C. WEIGOLD INC","GroupN":null,"Gender":"F","FirstName":"Katie","EndDate":"12/31/9999","EmployerName":null,"EffectiveStartDate":null,"EffectiveDate":"1/1/2018","DOB":"11/11/1960","contactName":null,"ConsumerAccountIndicator":null,"BenefitPlanId":"PEDV000004","BenefitBundleOptionId":"1018478"}';
        myVfPage.getParameters().put('additionalInfo', adddata);
        myVfPage.getParameters().put('Id', InteractionId.Id);
        myVfPage.getParameters().put('InteractionId', InteractionId.Id);
        myVfPage.getParameters().put('subjectId', 'test');
        myVfPage.getParameters().put('subjectTabs', '["test"]');
        ACETCallTopicsDataWrapper acdatawrapper = new ACETCallTopicsDataWrapper();
        acdatawrapper.SurrogateKey = '12345';
        acdatawrapper.AutodocCaseItems = 'test1,test2,test3';
        ACETCaseActionsController acaseobj = new ACETCaseActionsController();
        acaseobj.callTopicDataWrapper = acdatawrapper;
        // acaseobj.sortbyexternalid();
        acaseobj.ViewRelatedCases();
        acaseobj.InteractionId = InteractionId.Id;
        acaseobj.wrapInteraction();
        acaseobj.Cancel();
        acaseobj.getIsComponentVisible();
        
        
        
    }
    
    
    @istest static void test5()
        
    {
        PageReference myVfPage = Page.ACETCommunicationSearchPage;
        Test.setCurrentPageReference(myVfPage); // use setCurrentPageReference, 
        // ApexPages.currentPage().getParameters().put('id',Opp.Id);
        Contact cont = createContactPA();
        Interaction__c InteractionId = new Interaction__c();
        InteractionId.Contact_Name__c = 'Text Iname';
        InteractionId.Originator__c = cont.id;
        InteractionId.Originator_Type__c = 'Producer';
        InteractionId.Group_ID__c = '12345';
        InteractionId.Interaction_Type__c = 'Phone Call';
        Insert interactionId;
        
        case c = new
            case ();
        c.status = 'open';
        c.interaction__c = interactionId.id;
        insert c;
        Case_Item__c cs = new Case_Item__c();
        cs.case__c = c.id;
        cs.ExternalID__c = 'test1';
        insert cs;
        
        
        
        case ca = new
            case ();
        ca.status = 'Closed';
        ca.ID__c = '12345';
        ca.Topic__c = null;
        ca.Interaction__c = interactionid.ID;
        ca.Surrogate_Key__c = '12345';
        insert ca;
        
        
        
        case c1 = new
            case ();
        c1.status = 'Open';
        c1.parentid = ca.id;
        insert c1;
        string adddata = '{"Zip":null,"UHCBS":null,"surrogatekey":null,"State":null,"SitusState":"CT","ServiceTeam":null,"RiskManagement":null,"RenewalDate":null,"RelationshipType":"Self","Relationship":"Self","RatingMethod":null,"providerType":null,"providerPhoneNumber":null,"ProductType":"","Product":"","producerSubject":null,"producerOriginator":null,"producerName":null,"producerIDPNF":null,"producerId":null,"primarySpecialty":null,"PolicyNumber":null,"platinumProvider":null,"PhoneNumber":null,"OriginatorRelationship":null,"OriginatorDOB":null,"OnshoreIndicatorVerbiage":"No restriction; services allowed onshore and offshore.","OnshoreIndicator":"No","Network":"","MemberId":"86796510400","LastName":"Dolson","isProducerNotFound":null,"isMemNotFound":null,"isMember":" test","isGroupNotFound":null,"isGroup":"false","GroupStatus":null,"groupSName":null,"GroupNumber":"1078682","GroupName":"MICHAEL C. WEIGOLD INC","GroupN":null,"Gender":"F","FirstName":"Katie","EndDate":"12/31/9999","EmployerName":null,"EffectiveStartDate":null,"EffectiveDate":"1/1/2018","DOB":"11/11/1960","contactName":null,"ConsumerAccountIndicator":null,"BenefitPlanId":"PEDV000004","BenefitBundleOptionId":"1018478"}';
        
        
        myVfPage.getParameters().put('additionalInfo', adddata);
        myVfPage.getParameters().put('Id', InteractionId.Id);
        myVfPage.getParameters().put('InteractionId', InteractionId.Id);
        myVfPage.getParameters().put('subjectId', 'test');
        myVfPage.getParameters().put('subjectTabs', '["test"]');
        ACETCallTopicsDataWrapper acdatawrapper = new ACETCallTopicsDataWrapper();
        acdatawrapper.SurrogateKey = '12345';
        acdatawrapper.AutodocCaseItems = 'test1,test2,test3';
        ACETCaseActionsController acaseobj = new ACETCaseActionsController();
        acaseobj.callTopicDataWrapper = acdatawrapper;
        // acaseobj.sortbyexternalid();
        acaseobj.ViewRelatedCases();
        acaseobj.InteractionId = InteractionId.Id;
        acaseobj.wrapInteraction();
        acaseobj.Cancel();
        acaseobj.getIsComponentVisible();
        
        
        
    }
    
    
    
    @istest static void test6()
        
    {
        PageReference myVfPage = Page.ACETCommunicationSearchPage;
        Test.setCurrentPageReference(myVfPage); // use setCurrentPageReference, 
        // ApexPages.currentPage().getParameters().put('id',Opp.Id);
        Contact cont = createContactPA();
        Interaction__c InteractionId = new Interaction__c();
        InteractionId.Contact_Name__c = 'Text Iname';
        InteractionId.Originator__c = cont.id;
        InteractionId.Originator_Type__c = 'Producer';
        InteractionId.Group_ID__c = '12345';
        InteractionId.Interaction_Type__c = 'Phone Call';
        Insert interactionId;
        
        case c = new
            case ();
        c.status = 'open';
        c.interaction__c = interactionId.id;
        insert c;
        Case_Item__c cs = new Case_Item__c();
        cs.case__c = c.id;
        cs.ExternalID__c = 'test1';
        insert cs;
        
        
        
        case ca = new
            case ();
        ca.status = 'Closed';
        ca.ID__c = '123456';
        ca.Topic__c = null;
        ca.Interaction__c = interactionid.ID;
        ca.Surrogate_Key__c = '12345';
        insert ca;
        
        
        
        case c1 = new
            case ();
        c1.status = 'Open';
        c1.parentid = ca.id;
        insert c1;
        string adddata = '{"Zip":null,"UHCBS":null,"surrogatekey":null,"State":null,"SitusState":"CT","ServiceTeam":null,"RiskManagement":null,"RenewalDate":null,"RelationshipType":"Self","Relationship":"Self","RatingMethod":null,"providerType":null,"providerPhoneNumber":null,"ProductType":"","Product":"","producerSubject":null,"producerOriginator":null,"producerName":null,"producerIDPNF":null,"producerId":"123456","primarySpecialty":null,"PolicyNumber":null,"platinumProvider":null,"PhoneNumber":null,"OriginatorRelationship":null,"OriginatorDOB":null,"OnshoreIndicatorVerbiage":"No restriction; services allowed onshore and offshore.","OnshoreIndicator":"No","Network":"","MemberId":"86796510400","LastName":"Dolson","isProducerNotFound":null,"isMemNotFound":null,"isMember":" test","isGroupNotFound":null,"isGroup":"true","GroupStatus":null,"groupSName":null,"GroupNumber":"1078682","GroupName":"MICHAEL C. WEIGOLD INC","GroupN":null,"Gender":"F","FirstName":"Katie","EndDate":"12/31/9999","EmployerName":null,"EffectiveStartDate":null,"EffectiveDate":"1/1/2018","DOB":"11/11/1960","contactName":null,"ConsumerAccountIndicator":null,"BenefitPlanId":"PEDV000004","BenefitBundleOptionId":"1018478"}';
        
        
        myVfPage.getParameters().put('additionalInfo', adddata);
        myVfPage.getParameters().put('Id', InteractionId.Id);
        myVfPage.getParameters().put('InteractionId', InteractionId.Id);
        myVfPage.getParameters().put('subjectId', 'test');
        myVfPage.getParameters().put('subjectTabs', '["test"]');
        ACETCallTopicsDataWrapper acdatawrapper = new ACETCallTopicsDataWrapper();
        acdatawrapper.SurrogateKey = '12345';
        acdatawrapper.AutodocCaseItems = 'test1,test2,test3';
        ACETCaseActionsController acaseobj = new ACETCaseActionsController();
        acaseobj.callTopicDataWrapper = acdatawrapper;
        // acaseobj.sortbyexternalid();
        acaseobj.ViewRelatedCases();
        acaseobj.InteractionId = InteractionId.Id;
        acaseobj.wrapInteraction();
        acaseobj.Cancel();
        acaseobj.getIsComponentVisible();
        
        
        
    }
    
    
    
    
    
    @istest static void test7()
        
    {
        PageReference myVfPage = Page.ACETCommunicationSearchPage;
        Test.setCurrentPageReference(myVfPage); // use setCurrentPageReference, 
        // ApexPages.currentPage().getParameters().put('id',Opp.Id);
        Contact cont = createContactPA();
        Interaction__c InteractionId = new Interaction__c();
        InteractionId.Contact_Name__c = 'Text Iname';
        InteractionId.Originator__c = cont.id;
        InteractionId.Originator_Type__c = 'Provider';
        InteractionId.Group_ID__c = '12345';
        InteractionId.Interaction_Type__c = 'Phone Call';
        Insert interactionId;
        
        case c = new
            case ();
        c.status = 'open';
        c.interaction__c = interactionId.id;
        insert c;
        Case_Item__c cs = new Case_Item__c();
        cs.case__c = c.id;
        cs.ExternalID__c = 'test1';
        insert cs;
        
        
        
        case ca = new
            case ();
        ca.status = 'Closed';
        ca.ID__c = '786796510400';
        ca.Topic__c = null;
        ca.Interaction__c = interactionid.ID;
        ca.Surrogate_Key__c = '12345';
        insert ca;
        
        
        
        case c1 = new
            case ();
        c1.status = 'Open';
        c1.parentid = ca.id;
        insert c1;
        string adddata = '{"Zip":null,"UHCBS":null,"surrogatekey":null,"State":null,"SitusState":"CT","ServiceTeam":null,"RiskManagement":null,"RenewalDate":null,"RelationshipType":"Self","Relationship":"Self","RatingMethod":null,"providerType":null,"providerPhoneNumber":null,"ProductType":"","Product":"","producerSubject":null,"producerOriginator":null,"producerName":null,"producerIDPNF":null,"producerId":"123456","primarySpecialty":null,"PolicyNumber":null,"platinumProvider":null,"PhoneNumber":null,"OriginatorRelationship":null,"OriginatorDOB":null,"OnshoreIndicatorVerbiage":"No restriction; services allowed onshore and offshore.","OnshoreIndicator":"No","Network":"","MemberId":"786796510400","LastName":"Dolson","isProducerNotFound":null,"isMemNotFound":null,"isMember": "false","isGroupNotFound":null,"isGroup":"true","GroupStatus":null,"groupSName":null,"GroupNumber":"1078682","GroupName":"MICHAEL C. WEIGOLD INC","GroupN":null,"Gender":"F","FirstName":"Katie","EndDate":"12/31/9999","EmployerName":null,"EffectiveStartDate":null,"EffectiveDate":"1/1/2018","DOB":"11/11/1960","contactName":null,"ConsumerAccountIndicator":null,"BenefitPlanId":"PEDV000004","BenefitBundleOptionId":"1018478"}';
        
        
        myVfPage.getParameters().put('additionalInfo', adddata);
        myVfPage.getParameters().put('Id', InteractionId.Id);
        myVfPage.getParameters().put('InteractionId', InteractionId.Id);
        myVfPage.getParameters().put('subjectId', 'test');
        myVfPage.getParameters().put('subjectTabs', '["test"]');
        ACETCallTopicsDataWrapper acdatawrapper = new ACETCallTopicsDataWrapper();
        acdatawrapper.SurrogateKey = '12345';
        acdatawrapper.AutodocCaseItems = 'test1,test2,test3';
        ACETCaseActionsController acaseobj = new ACETCaseActionsController();
        acaseobj.callTopicDataWrapper = acdatawrapper;
        // acaseobj.sortbyexternalid();
        acaseobj.ViewRelatedCases();
        acaseobj.InteractionId = InteractionId.Id;
        acaseobj.wrapInteraction();
        acaseobj.Cancel();
        acaseobj.getIsComponentVisible();
        
        
        
    }
    
    @istest static void test8()
        
    {
        PageReference myVfPage = Page.ACETCommunicationSearchPage;
        Test.setCurrentPageReference(myVfPage); // use setCurrentPageReference, 
        // ApexPages.currentPage().getParameters().put('id',Opp.Id);
        Contact cont = createContactPA();
        Interaction__c InteractionId = new Interaction__c();
        InteractionId.Contact_Name__c = 'Text Iname';
        InteractionId.Originator__c = cont.id;
        InteractionId.Originator_Type__c = 'Provider';
        InteractionId.Provider_ID__c = '786796510400';
        InteractionId.Interaction_Type__c = 'Phone Call';
        Insert interactionId;
        
        case c = new
            case ();
        c.status = 'open';
        c.interaction__c = interactionId.id;
        insert c;
        Case_Item__c cs = new Case_Item__c();
        cs.case__c = c.id;
        cs.ExternalID__c = 'test1';
        insert cs;
        
        
        
        case ca = new
            case ();
        ca.status = 'Closed';
        ca.ID__c = '786796510400';
        ca.Topic__c = null;
        ca.Interaction__c = interactionid.ID;
        ca.Surrogate_Key__c = '12345';
        insert ca;
        
        
        
        case c1 = new
            case ();
        c1.status = 'Open';
        c1.parentid = ca.id;
        insert c1;
        
        string adddata = '{"Zip":null,"UHCBS":null,"surrogatekey":null,"State":null,"SitusState":"CT","ServiceTeam":null,"RiskManagement":null,"RenewalDate":null,"RelationshipType":"Self","Relationship":"Self","RatingMethod":null,"providerType":null,"providerPhoneNumber":null,"ProductType":"","Product":"","producerSubject":null,"producerOriginator":null,"producerName":null,"producerIDPNF":null,"producerId":null,"primarySpecialty":null,"PolicyNumber":null,"platinumProvider":null,"PhoneNumber":null,"OriginatorRelationship":null,"OriginatorDOB":null,"OnshoreIndicatorVerbiage":"No restriction; services allowed onshore and offshore.","OnshoreIndicator":"No","Network":"","MemberId":"786796510400","LastName":"Dolson","isProducerNotFound":null,"isMemNotFound":null,"isMember": null,"isGroupNotFound":null,"isGroup":"true","GroupStatus":null,"groupSName":null,"GroupNumber":"1078682","GroupName":"MICHAEL C. WEIGOLD INC","GroupN":null,"Gender":"F","FirstName":"Katie","EndDate":"12/31/9999","EmployerName":null,"EffectiveStartDate":null,"EffectiveDate":"1/1/2018","DOB":"11/11/1960","contactName":null,"ConsumerAccountIndicator":null,"BenefitPlanId":"PEDV000004","BenefitBundleOptionId":"1018478"}';
        
        myVfPage.getParameters().put('additionalInfo', adddata);
        myVfPage.getParameters().put('Id', InteractionId.Id);
        myVfPage.getParameters().put('InteractionId', InteractionId.Id);
        myVfPage.getParameters().put('subjectId', 'test');
        myVfPage.getParameters().put('subjectTabs', '["test"]');
        ACETCallTopicsDataWrapper acdatawrapper = new ACETCallTopicsDataWrapper();
        acdatawrapper.SurrogateKey = '12345';
        acdatawrapper.AutodocCaseItems = 'test1,test2,test3';
        ACETCaseActionsController acaseobj = new ACETCaseActionsController();
        acaseobj.callTopicDataWrapper = acdatawrapper;
        // acaseobj.sortbyexternalid();
        acaseobj.ViewRelatedCases();
        acaseobj.InteractionId = InteractionId.Id;
        acaseobj.wrapInteraction();
        acaseobj.Cancel();
        acaseobj.getIsComponentVisible();
        
        
    }
    
    @istest static void testone()
        
    {
        PageReference myVfPage = Page.ACETCommunicationSearchPage;
        Test.setCurrentPageReference(myVfPage); // use setCurrentPageReference, 
        // ApexPages.currentPage().getParameters().put('id',Opp.Id);
        Contact cont = createContactPA();
        Interaction__c InteractionId = new Interaction__c();
        InteractionId.Contact_Name__c = 'Text Iname';
        InteractionId.Originator__c = cont.id;
        InteractionId.Originator_Type__c = 'Provider';
        InteractionId.Provider_ID__c = '786796510400';
        InteractionId.Interaction_Type__c = 'Phone Call';
        Insert interactionId;
        
        case c = new
            case ();
        c.status = 'open';
        c.interaction__c = interactionId.id;
        insert c;
        Case_Item__c cs = new Case_Item__c();
        cs.case__c = c.id;
        cs.ExternalID__c = 'test1';
        insert cs;
        
        
        
        case ca = new
            case ();
        ca.status = 'Closed';
        ca.ID__c = '786796510400';
        ca.Topic__c = null;
        ca.Interaction__c = interactionid.ID;
        ca.Surrogate_Key__c = '12345';
        insert ca;
        
        
        /*
case c1 = new
case ();
c1.status = 'Open';
c1.parentid = ca.id;
insert c1;*/
        
        string adddata = '{"Zip":null,"UHCBS":null,"surrogatekey":null,"State":null,"SitusState":"CT","ServiceTeam":null,"RiskManagement":null,"RenewalDate":null,"RelationshipType":"Self","Relationship":"Self","RatingMethod":null,"providerType":null,"providerPhoneNumber":null,"ProductType":"","Product":"","producerSubject":null,"producerOriginator":null,"producerName":null,"producerIDPNF":null,"producerId":null,"primarySpecialty":null,"PolicyNumber":null,"platinumProvider":null,"PhoneNumber":null,"OriginatorRelationship":null,"OriginatorDOB":null,"OnshoreIndicatorVerbiage":"No restriction; services allowed onshore and offshore.","OnshoreIndicator":"No","Network":"","MemberId":"786796510400","LastName":"Dolson","isProducerNotFound":null,"isMemNotFound":null,"isMember": null,"isGroupNotFound":null,"isGroup":"true","GroupStatus":null,"groupSName":null,"GroupNumber":"1078682","GroupName":"MICHAEL C. WEIGOLD INC","GroupN":null,"Gender":"F","FirstName":"Katie","EndDate":"12/31/9999","EmployerName":null,"EffectiveStartDate":null,"EffectiveDate":"1/1/2018","DOB":"11/11/1960","contactName":null,"ConsumerAccountIndicator":null,"BenefitPlanId":"PEDV000004","BenefitBundleOptionId":"1018478"}';
        
        myVfPage.getParameters().put('additionalInfo', adddata);
        myVfPage.getParameters().put('Id', InteractionId.Id);
        myVfPage.getParameters().put('InteractionId', InteractionId.Id);
        myVfPage.getParameters().put('subjectId', 'test');
        myVfPage.getParameters().put('subjectTabs', '["test"]');
        ApexPages.currentPage().getParameters().put('SubjectId', '');
        ACETCallTopicsDataWrapper acdatawrapper = new ACETCallTopicsDataWrapper();
        acdatawrapper.SurrogateKey = '12345';
        acdatawrapper.CallTopic='Enroll Subscriber';
        acdatawrapper.AutodocCaseItems = 'test1,test2,test3';
        ACETCaseActionsController acaseobj = new ACETCaseActionsController();
        acaseobj.callTopicDataWrapper = acdatawrapper;
        // acaseobj.sortbyexternalid();
        acaseobj.ViewRelatedCases();
        acaseobj.InteractionId = InteractionId.Id;
        acaseobj.wrapInteraction();
        acaseobj.Cancel();
        acaseobj.getIsComponentVisible();
        
        
    }
    
    public static Contact createContactPA(){
        RecordType newRecord = [SELECT Id FROM RecordType WHERE Name = 'Person Account' and SObjectType = 'Account'];
        
        Account accountTest = new Account();
        accountTest.FirstName = 'TestFname';
        accountTest.LastName = 'TestLName';
        accountTest.EID__c = 'TestEID1';
        accountTest.EID__pc = 'TestEID1';
        accountTest.RecordTypeId = newRecord.Id;
        insert accountTest;
        
        Account acc = [SELECT Id,personcontactid from Account where Id=:accountTest.Id];
        Contact con = [SELECT Id,LastName,FirstName,EID__c,AccountId from Contact where Id=:acc.personcontactid];
        con.Tax_Id__c = '123456';
        con.NPI__c = '123457';
        return con;
    }
    
}