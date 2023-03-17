@isTest
private class ACET_InteractionOverviewCtrl_Test {
    
    @isTest static void createInteraction_Test() {
        
        Test.startTest();
        ACET_ExplorePageCtrl.FlowDetails fd = new ACET_ExplorePageCtrl.FlowDetails();
        fd.contactExt = '123';
        fd.contactName = 'cfn cln';
        fd.contactNumber = '1234567890';
        fd.interactionType = 'Email';
        fd.isGenesys = false;
        fd.IVRInfo = null;
        fd.GeneysysQuestionType = '';

        ACET_ProviderSearchCtrl.ProviderDetails pd = new ACET_ProviderSearchCtrl.ProviderDetails();
        pd.isAdvancedSearch = true;
        pd.isValidProvider = false;
        pd.isProviderNotFound = false;
        pd.isNoProviderToSearch = true;
        pd.isOther = false;
        pd.isPysician = true;
        pd.practicingStatus = 'Active';
        pd.taxId = '';
        pd.npi = '1234567891';
        pd.firstName = 'pfn';
        pd.lastName = 'pln ';
        pd.filterType = 'Facility';
        pd.state = 'TX';
        pd.zip = 'NY';
        pd.state = '100001';
        pd.interactionType = 'Email';
        pd.providerUniqueId = '12345';
        pd.providerId = '12345';
        pd.phoneNumber = '1234567890';
        pd.contactType = '';

        ACET_MemberSearchCtrl.ExplorePageMemberDetailsResponse md = new ACET_MemberSearchCtrl.ExplorePageMemberDetailsResponse();
        md.dob = '01/01/1999';
        md.firstName = 'mfn';
        md.lastName = 'mln';
        md.groupNumber = '1234';
        md.isAdvancedSearch = true;
        md.isFindIndividualSearch = false;
        md.isMemberNotFound = false;
        md.isNoMemberToSearch = false;
        md.isValidMember = true;
        md.memberId = '12345';
        md.memberUniqueId = '12345';
        md.payerId = '123456';
        md.phoneNumber = '1234567890';
        md.searchOption = 'MemberIdDOB';
        md.state = 'TX';
        md.zip = '100001';
        
        VCCD_Response__c VCCDRecord = new VCCD_Response__c();
        VCCDRecord.TaxId__c = '';
        VCCDRecord.ProductType__c = '';
        VCCDRecord.TFN__c = '';
        VCCDRecord.Ani__c = '';
        VCCDRecord.MemberId__c = '';
        VCCDRecord.NPI__c = '';
        VCCDRecord.QuestionType__c = '';
        VCCDRecord.ClaimId__c = '';
        VCCDRecord.SubjectDOB__c = System.today();
        Insert VCCDRecord;
        
        Interaction__c interactionRecord = TestDataFactory.createInteraction();
        
        ACET_InteractionOverviewCtrl.getHippaGuideLinesUrl();
        ACET_InteractionOverviewCtrl.createInteraction(fd, pd, md, false, VCCDRecord.Id);
        ACET_InteractionOverviewCtrl.createInteraction(fd, pd, md, true, VCCDRecord.Id);
        ACET_InteractionOverviewCtrl.updateInteraction(fd, pd, interactionRecord.Id, true, VCCDRecord.Id);
        
        md.isValidMember = false;
        md.isMemberNotFound = true;
        ACET_InteractionOverviewCtrl.createInteraction(fd, pd, md, true, VCCDRecord.Id);
        ACET_InteractionOverviewCtrl.updateInteraction(fd, pd, interactionRecord.Id, true, VCCDRecord.Id);
        
        pd.isNoProviderToSearch = false;
        pd.isValidProvider = true;
        ACET_InteractionOverviewCtrl.createInteraction(fd, pd, md, true, VCCDRecord.Id);
        ACET_InteractionOverviewCtrl.updateInteraction(fd, pd, interactionRecord.Id, true, VCCDRecord.Id);
        
        pd.isValidProvider = false;
        pd.isProviderNotFound = true;
        ACET_InteractionOverviewCtrl.createInteraction(fd, pd, md, true, VCCDRecord.Id);
        ACET_InteractionOverviewCtrl.updateInteraction(fd, pd, interactionRecord.Id, true, VCCDRecord.Id);
        
        pd.isProviderNotFound = false;
        pd.isOther = true;
        ACET_InteractionOverviewCtrl.createInteraction(fd, pd, md, true, VCCDRecord.Id);
        ACET_InteractionOverviewCtrl.updateInteraction(fd, pd, interactionRecord.Id, true, VCCDRecord.Id);
        //US2903847
        fd.isGenesys = true;
        Map<String,Object> IVRInfoMap = new Map<string,Object>{'QuestionType__c'=>'C1','SubjectDOB__c'=>'19660116'};
        fd.IVRinfo = IVRInfoMap;
        ACET_InteractionOverviewCtrl.createInteraction(fd, pd, md, false,'');
        Map<String,Object> IVRInfoMap2 = new Map<string,Object>{'QuestionType__c'=>'C1','SubjectDOB__c'=>'1966-01-16'};
        fd.IVRinfo = IVRInfoMap2;
        ACET_InteractionOverviewCtrl.createInteraction(fd, pd, md, false,'');

        Test.stopTest();
    }

}