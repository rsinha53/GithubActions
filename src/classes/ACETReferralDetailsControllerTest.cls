@isTest

private class ACETReferralDetailsControllerTest {

    static testMethod void ACETReferralDetailControllerTest1() {


        //Interaction__c ProviderTestInteraction = ACETReferralDetailsController.RedirectToProviderDetail('Phone Call', 'Contact Name', 'EID1', '999999999', '9999999999', 'Group Name', 'Physician');


        /*contact c = new Contact();

        c.lastname = 'test';

        c.firstname = 'test1';

        c.EID__c = '1235';

        c.Tax_ID__c = '@@healthcareProfessionalId@@12312';

        insert c;*/
        
			 RecordType newRecord = [SELECT Id FROM RecordType WHERE Name = 'Person Account' and SObjectType = 'Account'];
        
        Account accountTest = new Account();
        accountTest.FirstName = 'Test Contact FN1';
        accountTest.LastName = 'Test Contact LN1';
        accountTest.EID__c = 'TestEID1';
        accountTest.EID__pc = 'TestEID1';
        accountTest.RecordTypeId = newRecord.Id;
        insert accountTest;

    Account oAccount = [SELECT Id,personcontactid from Account where Id=:accountTest.Id];
        Contact c = [SELECT Id,LastName,FirstName,EID__c,AccountId from Contact where Id=:oAccount.personcontactid];
        

        Interaction__c inta = new Interaction__c();

        inta.Originator__c = c.id;
        inta.Originator_Type__c = 'Provider';
        insert inta;




        //ApexPages.currentPage().getParameters().put('InteractionId', inta.Id);




       // ApexPages.currentPage().getParameters().put('ContactId', c.Id);




        string additional = '{"OriginatorRelationship":"Test","Relationship":"Test","SitusState":"Test","DOB":"Test","EndDate":"Test","EffectiveDate":"Test","PolicyNumber":"Test","GroupName":"Test","Product":"Test","ProductType":"Test","Network":"Test","ConsumerAccountIndicator":"Test"}';

        //ApexPages.currentpage().getparameters().put('additionalInfo', additional);

        //JSONParser parser = JSON.createParser(additional);
         String con = apexpages.currentpage().getparameters().put('ContactId', c.Id);
//apexpages.currentpage().getparameters().put('SRK', 'testkey'); 
        String wraprResults = '{"resultMembername": "Test","resultReferralnumber": "Test", "resultReferralstatus": "Test", "resultStartdate": "Test","resultEnddate": "Test","resultReferaltype": "Test", "resultRequestingtin": "Test","resultRequestingprovider": "Test","resultServicingtin": "Test", "resultServicingprovider": "Test",  "resultDxcode": "Test","resultDXDescription": "Test"}';
        ACETReferralWebservice ACETRW=new ACETReferralWebservice();
        ACETWSCalloutResult findReferralServiceCalloutResult = new ACETWSCalloutResult();
        findReferralServiceCalloutResult = ACETRW.findReferrals('Jacqueline','Henry','1969-06-17','890504607');
		findReferralServiceCalloutResult.Success = true;
        //ApexPages.currentpage().getparameters().put('additionalInfo', additional);

        //interaction and highlight panel       

        Test.StartTest();

        PageReference pageRef = Page.ACETReferalDetails; // Add your VF page Name here
        pageRef.getParameters().put('id', String.valueOf(inta.Id));
        pageRef.getparameters().put('wrapperresultsStr',wraprResults );
         pageRef.getParameters().put('InteractionId', inta.Id);
pageRef.getParameters().put('ContactId', c.Id);
 pageRef.getparameters().put('additionalInfo', additional);
//pageRef.getparameters().put('additionalInfo', additional);

        Test.setCurrentPage(pageRef);

        ACETReferralDetailsController detail = new ACETReferralDetailsController();
        detail.init();
        detail.notes = 'test';
        
        //ACETReferralSearchResult acetresult = new ACETReferralSearchResult();
        
        
        
        //detail.referralselMap = 
        list<ACETReferralSearchResult> referralsearchlist = new List<ACETReferralSearchResult>();
        ACETReferralSearchResult referralsearch = new ACETReferralSearchResult();
        List<ACETReferralSearchResult.Provider> providerlist = new List<ACETReferralSearchResult.Provider>();
        ACETReferralSearchResult.Provider referralsearchprovider = new ACETReferralSearchResult.Provider();
        
        List<ACETReferralSearchResult.Service> Servicelist = new List<ACETReferralSearchResult.Service>();
        ACETReferralSearchResult.Service referralsearchservice = new ACETReferralSearchResult.Service();        
        List<ACETReferralSearchResult.Diagnosis> Diagnosislist = new List<ACETReferralSearchResult.Diagnosis>();
        ACETReferralSearchResult.Diagnosis referralsearchDiagnosis = new ACETReferralSearchResult.Diagnosis();
        
        referralsearchprovider.resultAddress = 'Test';
        referralsearchprovider.resultCity = 'TX';
        referralsearchprovider.resultMPIN = '75039';
        referralsearchprovider.resultName = 'Test';
        referralsearchprovider.resultNetworkStatus = 'New';
        referralsearchprovider.resultProviderRole = 'Test';
        referralsearchprovider.resultState = 'Test';
        referralsearchprovider.resultTIN = 'Test';
        referralsearchprovider.resultZip = '75039';
        referralsearchprovider.speciality = 'Test';
        providerlist.add(referralsearchprovider);
        
        referralsearchservice.resultProcedureType = 'Test';
        referralsearchservice.resultProcedureCode = 'Test';
        referralsearchservice.resultDescription = 'Test';
        
        Servicelist.add(referralsearchservice);
        
        referralsearchDiagnosis.resultdiagCode = 'Test';
        referralsearchDiagnosis.resultdiadDesc = 'Test';
        Diagnosislist.add(referralsearchDiagnosis);
        
        referralsearch.resultMembername = 'Test';
        referralsearch.resultReferralnumber = '3423422';
        referralsearch.resultReferralstatus= 'New';
        referralsearch.resultStartdate = '12/16';
        referralsearch.resultEnddate = '14/16';
        referralsearch.resultReferaltype = 'Test';
        referralsearch.resultRequestingtin = 'Test';
        referralsearch.resultRequestingprovider = 'Test';
        referralsearch.resultServicingtin = 'Test';
        referralsearch.resultServicingprovider = 'Test';
        referralsearch.resultDxcode = 'Test';
        referralsearch.resultDXDescription = 'Test';
        referralsearch.selected = true;
        referralsearch.resultreferralExternalID = 'Test';
        referralsearch.resultCreatedDate = 'Test';
        referralsearch.numberofvisit = '10';
        referralsearch.noteText='Test';
        referralsearch.providerlst = providerlist;
        referralsearch.servicelst = Servicelist;
        referralsearch.diagnosisList = Diagnosislist;
        referralsearchlist.add(referralsearch);
        detail.lstreferrals = referralsearchlist;
        map<String,ACETReferralSearchResult> maps = new map<String,ACETReferralSearchResult>();
        detail.wrapperresults1 = referralsearch;
        detail.ACETRW = ACETRW;
        detail.refsearchvalues = referralsearchlist;
        maps.put(detail.lstreferrals[0].resultreferralExternalID, referralsearch);
        //maps.put(referralsearch, value)
        //testAccPlan.save(); call all your function here
        Test.StopTest();
        test.setCurrentPage(pageRef);



        ACETCallTopicsDataWrapper calldatwr = new ACETCallTopicsDataWrapper();
        ACETReferralDetailsController ref = new ACETReferralDetailsController();
    }

}