@istest
private class ACETMemberEligibilityControllerTest{

    private static void setTestData(String flow){

        RecordType newRecord = [SELECT Id FROM RecordType WHERE Name = 'Person Account' and SObjectType = 'Account'];
        
        Account accountTest = new Account();
        accountTest.FirstName = 'Test';
        accountTest.LastName = 'Contact';
        accountTest.EID__c = 'PIN';
        accountTest.EID__pc = 'PIN';
        accountTest.RecordTypeId = newRecord.Id;
        insert accountTest;

    Account acc = [SELECT Id,personcontactid from Account where Id=:accountTest.Id];
        Contact con = [SELECT Id,LastName,FirstName,EID__c,AccountId from Contact where Id=:acc.personcontactid];
        //if(flow == 'Provider'){
        Interaction__c inte = TestDataFactory.createInteraction();
        ApexPages.currentPage().getParameters().put('interactionId',inte.id);
        //}
        ApexPages.currentPage().getParameters().put('contactId',con.id);
        ApexPages.currentPage().getParameters().put('Id','73452645');
        ApexPages.currentPage().getParameters().put('SRK','73452645');
        ApexPages.currentPage().getParameters().put('firstName','Connie');
        ApexPages.currentPage().getParameters().put('lastName','Reed');
        ApexPages.currentPage().getParameters().put('sourceOriginator','FAX');    
        ApexPages.currentPage().getParameters().put('CoverageGroupNumber','12345');    
        ACETMemberDetail md = new ACETMemberDetail();
        md.FirstName = 'Prakash';
        md.LastName = 'Swain';
        md.DOB = '1/1/1991';
        md.CoverageLines = null;
        ApexPages.currentPage().getParameters().put('additionalInfo', json.serialize(md));
        
        ACETRelationshipCodes__c r =  new ACETRelationshipCodes__c();
        r.Description__c = 'Relation';
        r.name = '18';
        insert r;

    }
    static testMethod void testACETMemberEligibilityController(){
        PageReference pageRef = Page.ACETMemberEligibility;
        Test.setCurrentPage(pageRef);
        ACETMemberEligibilityControllerTest.setTestData('');      
        ACETMemberDetail md = new ACETMemberDetail();
        md.FirstName = 'Prakash';
        md.LastName = 'Swain';
        md.DOB = '1/1/1991';
        md.CoverageLines = null;
        ACETMemberDetail.Address add = new ACETMemberDetail.Address();
        add.AddressLine1 = 'aaa';
        add.AddressLine2 = 'aaa';
        add.City = 'aaa';
        add.State = 'aaa';
        add.Zip = '12345';
        md.Addresses = new List<ACETMemberDetail.Address>();
        md.Addresses.add(add);
        md.ClaimAddressline1 = 'aaa';
        md.ClaimAddressline2 = 'aaa';
        md.ClaimAddresscity  = 'aaa';
        md.ClaimAddressstate = 'aaa';
        md.ClaimAddresspostalCode = '12345';
        md.ClaimAddresscountyCode = 'US';
        md.SurrogateKey = '73452645';
        ACETMemberDetail.CoverageLine cov = new ACETMemberDetail.CoverageLine();
        Date tod = Date.Today();
        cov.EffectiveDate = (tod.day()<10?'0'+tod.day():tod.day()+'')+'/'+
            (tod.month()<10?'0'+tod.month():tod.month()+'')+
            '/'+tod.year();
        cov.EndDate= '12/10/2017';
        cov.PolicyNumber= '12345';
        cov.Product= 'aaa';
        cov.ProductType= '12345';
        cov.BenefitPlanId = 'M000000833';
        cov.coverageMemberId = '96432336200';
        md.PreferredCoverage = new ACETMemberDetail.CoverageLine();
        md.PreferredCoverage = cov;
        List<ACETMemberDetail.CoverageLine> CoverageLines=new List<ACETMemberDetail.CoverageLine>();
        CoverageLines.add(cov);
        md.CoverageLines=CoverageLines;
        
        ACETMemberDetail.CoverageLineHistory covHisTest = new ACETMemberDetail.CoverageLineHistory();
        covHisTest.covLevelEffDate = Date.today().addDays(-3);
        covHisTest.covLevelExpDate= Date.today().addDays(3);
        covHisTest.covLevelCode= 'FAM';
        covHisTest.covLevelDesc= 'Family';
        List<ACETMemberDetail.CoverageLineHistory> lstCoverageLineHistory=new List<ACETMemberDetail.CoverageLineHistory>();
        lstCoverageLineHistory.add(covHisTest);
        md.lstCoverageLineHistory =  lstCoverageLineHistory;
        
        ACETMemberDetail.PCPAssignment  pcp =  new  ACETMemberDetail.PCPAssignment();
       // pcp.endDate = '12/31/2017';
        pcp.pcpAssignmentType = 'OBGYN';
        pcp.isActive = true;
        Date endDate = Date.today().addDays(3);
        pcp.endDate = AcetUtility.format(endDate);
        Date effectiveDate = Date.today().addDays(-3);
        pcp.effectiveDate = AcetUtility.format(effectiveDate); 
        pcp.FirstName = 'Prakash';
        pcp.LastName = 'Swain';
        List<ACETMemberDetail.PCPAssignment> pcpassignmentList = new  List<ACETMemberDetail.PCPAssignment>() ;
        pcpassignmentList.add(pcp);
        md.PCPAssignments =  pcpassignmentList;
        
        
        ACETMemberEligibilityController Controller  = new ACETMemberEligibilityController();
        Controller.MemberDetail = md;
        
        Controller.memberdetailresponse = JSON.serialize(md);
        controller.response='Success';
        controller.selectedSurrogateKey='73452645';
        controller.PCPName='test';
        controller.isClaim =true;
        controller.PrimaryAddress='test';
        controller.MailingAddress='test';
        controller.ClaimAddress='test';
        controller.ClaimAddress1='test';
        controller.preferredCoverage = cov;
        controller.ProferredCoverageGUID='test';
        controller.isResolved=true;
        controller.childconsolefunction();
        controller.toggleShowCoverages();
        controller.getMemberData();
        controller.callMemberServices();
        controller.renderCancelCaseSection();      
        controller.init();
        
        controller.showHoldCode();
        controller.hideHoldCode();

        controller.memberServicesCallback();
        
        controller.CallGetMembership();
        controller.MemberDetail = md;
        controller.GetMembershipCallback();
        
        controller.MemberDetail.PCPAssignments.clear();
        pcp.endDate = '12/31/9999';
        controller.MemberDetail.PCPAssignments.add(pcp);
        controller.GetMembershipCallback();
        
        controller.MemberDetail.PCPAssignments.clear();
        pcp.endDate = AcetUtility.format(date.today());
        pcp.pcpAssignmentType = 'PCP';
        controller.MemberDetail.PCPAssignments.add(pcp);
        controller.GetMembershipCallback();
        
        controller.MemberDetail.PCPAssignments.clear();
        pcp.endDate = '12/31/9999';
        controller.MemberDetail.PCPAssignments.add(pcp);
        controller.GetMembershipCallback();
        controller.init();
        controller.Save();
        
        ACETGetMembershipWebService ws = new ACETGetMembershipWebService();
        ws.getMembership(null,null,md);
        ws.ProcessResponse(null,md);
        ws.getAgeFromBirthday(String.valueOf(Date.Today()));
        ws.getMaskedSSN('123456789');
    }
    static testMethod void testACETMemberEligibilitySaveandClose(){
        PageReference pageRef = Page.ACETMemberEligibility;
        Test.setCurrentPage(pageRef);
        ACETMemberEligibilityControllerTest.setTestData('');       
        ACETMemberEligibilityController Controller  = new ACETMemberEligibilityController();
        controller.init();
        controller.SaveAndClose();
      } 
    static testMethod void testACETMemberEligibilityRouteCase(){
        PageReference pageRef = Page.ACETMemberEligibility;
        Test.setCurrentPage(pageRef);
        ACETMemberEligibilityControllerTest.setTestData('');       
        ACETMemberEligibilityController Controller  = new ACETMemberEligibilityController();
        controller.init();
        controller.routeCase();
      } 
     static testMethod void testACETMemberEligibilitySaveCase(){
        PageReference pageRef = Page.ACETMemberEligibility;
        Test.setCurrentPage(pageRef);
        ACETMemberEligibilityControllerTest.setTestData('');       
        ACETMemberEligibilityController Controller  = new ACETMemberEligibilityController();
        controller.init();
        controller.saveCase();
      }    
    
    static testMethod void testService(){
        
      }
    
    
}