@isTest
public class ACETLGT_MemberSearchCoveragesResultTest {
    /*-- Test also covered by the following test classes:
     * ACETLGT_CoveragesControllerTest
     * ACETLGT_FamilyMemberControllerTest
     * ACETLGT_HoldRestrictionsControllerTest
     * ACETLGT_MemberSearchControllerTest
     * ACETLGT_ProviderLookupDetailTest
     * ACETLGT_SubjectDetailControllerTest	
     * ACETLGT_UpdateIndividualTest
     * ACETLGT_UpdateMemberDetailControllerTest
     * ACETLGT_createACETConstituentsTest
     * ACETLGT_getIndividualControllerTest
     * ACETLGT_getIndividualGeneralInfoTest
    --*/
    @isTest static void additionalCoverageMethod() {
        ACETLGT_MemberSearchCoveragesResult mscr = new ACETLGT_MemberSearchCoveragesResult();
        mscr.parentPEOId = 'teststring';
        mscr.SurrogateKeysStr = 'teststring2';
        mscr.strCoverageLines = 'teststring3';
        mscr.CPTIN = 'teststring4';
        mscr.fullCPTIN = 'teststring5';
        mscr.planType = 'teststring6';
        mscr.CoverageTypeValue = 'teststring7';
        mscr.groupNameValue = 'teststring10';
        mscr.CoverageTypeSet = new Set<String>{'teststring8', 'teststring9'};
        mscr.groupNameSet = new Set<String>{'teststring11', 'teststring12'};
        mscr.effectiveDateValue = Date.today();
        mscr.endDateValue = Date.today() + 1;
        mscr.groupNumberSet = new Set<String>{'teststring13', 'teststring14'};
        mscr.sourceCodeValue = 'teststring15';
        mscr.sourceCodeSet = new Set<String>{'teststring16', 'teststring17'};
        mscr.searchOnLoad = true;
        mscr.isAdvanceSearched = false;
		mscr.QMSCOIndicator = 'teststring18';
		mscr.isServiceError = true;
		mscr.MemberId = 'teststring19';
		mscr.RelationShip = 'teststring20';
		mscr.RelationShipCode = 'teststring21';
        mscr.OriginatorRelationship = 'teststring22';
        mscr.AsianInitiativeIndicator = 'teststring23';
        mscr.MigrationDate = 'teststring24';
        mscr.OriginalEffectiveDate = 'teststring25';
        mscr.PCPRequired = 'teststring26';
        mscr.PCPAssignment = 'teststring27';
        mscr.SitusState = 'teststring28';
        mscr.PolicyNumber = 'teststring29';
        mscr.FundingArragement = 'teststring30';
        mscr.FundingArragementCode = 'teststring31';
        mscr.MemberStatus = 'teststring32';
        mscr.TerminationReason = 'teststring33';
        mscr.HoldReason = 'teststring34';
        mscr.Network = 'teststring35';
        mscr.gatedPlanIndicator = 'teststring36';
        mscr.migrationSourceSystem = 'teststring37';
        mscr.EffectiveDate = 'teststring38';
        mscr.parentGroup = 'teststring39';
        mscr.alphaParentGroup = 'teststring40';
        mscr.EndDate = 'teststring41';
        mscr.Product = 'teststring42';
        mscr.ProductType = 'teststring43';
        mscr.hsaAvailable = 'teststring44';
        mscr.CoverageLevelCode = 'teststring45';
		//CoverageLine PreferredCoverage
		//CoverageLine PreferredCoverageInfo
		mscr.coverageGroupContractOptionFilterStatus = 'teststring46';
		//MemberElgibilityCoverage ElgibilityCoverage
		//List<statusLog> MemberStatusLogs
		//Map<String, String> GroupVsOnshoreIndicator
		mscr.onshore  = 'teststring47';
		//List<CoverageLineHistory> lstCoverageLineHistory;
        //mscr.compareTo(null);
        // create list and sort
        List<ACETLGT_MemberSearchCoveragesResult> listToSort = new List<ACETLGT_MemberSearchCoveragesResult>();
        ACETLGT_MemberSearchCoveragesResult mscr1 = new ACETLGT_MemberSearchCoveragesResult();
        mscr1.FirstName = 'ats1';
        mscr1.LastName = 'ats2';
        mscr1.MiddleInitial = 'a3';
        mscr1.Gender = 'ats4'; 
        mscr1.DOB = sTRING.ValueOf(Date.today());
        mscr1.SSN = 'ats5';
        mscr1.Address = 'ats6';
        mscr1.City = 'ats7';
        mscr1.State = 'ats8'; 
        mscr1.Zip = 'ats9';
        listToSort.add(mscr1);
        mscr.FirstName = 'ts1';
        mscr.LastName = 'ts2';
        mscr.MiddleInitial = '3';
        mscr.Gender = 'ts4'; 
        mscr.DOB = sTRING.ValueOf(Date.today());
        mscr.SSN = 'ts5';
        mscr.Address = 'ts6';
        mscr.City = 'ts7';
        mscr.State = 'ts8'; 
        mscr.Zip = 'ts9';
        listToSort.add(mscr);
        //ACETLGT_MemberSearchCoveragesResult.SortBy = 'ZIP';
        listToSort.sort();
        ACETLGT_MemberSearchCoveragesResult.SortBy = 'FirstName';
        listToSort.sort();
        ACETLGT_MemberSearchCoveragesResult.SortBy = 'MiddleInitial';
        listToSort.sort();
        ACETLGT_MemberSearchCoveragesResult.SortBy = 'Gender';
        listToSort.sort();
        ACETLGT_MemberSearchCoveragesResult.SortBy = 'DOB';
        listToSort.sort();
        ACETLGT_MemberSearchCoveragesResult.SortBy = 'SSN';
        listToSort.sort();
        ACETLGT_MemberSearchCoveragesResult.SortBy = 'Address';
        listToSort.sort();
        ACETLGT_MemberSearchCoveragesResult.SortBy = 'City';
        listToSort.sort();
        ACETLGT_MemberSearchCoveragesResult.SortBy = 'State';
        listToSort.sort();
        ACETLGT_MemberSearchCoveragesResult.SortBy = 'ZIP';
        listToSort.sort();
        
        ACETLGT_MemberSearchCoveragesResult.MemberEligibilityCoverage mec = new ACETLGT_MemberSearchCoveragesResult.MemberEligibilityCoverage();
        mec.coverageType = 'teststring48';
        mec.groupNumber = 'teststring49';
        mec.benefitPlanId = 'teststring50';
        mec.effectivedate = 'teststring51';
        mec.endDate = 'teststring52';
        
        ACETLGT_MemberSearchCoveragesResult.DependentDisability dd = new ACETLGT_MemberSearchCoveragesResult.DependentDisability();
        dd.diagnosisDesc = 'teststring53';
        
        ACETLGT_MemberSearchCoveragesResult.CoverageLineHistory clh = new ACETLGT_MemberSearchCoveragesResult.CoverageLineHistory();
        clh.covLevelCode = 'teststring54';
        clh.covLevelDesc = 'teststring55';
        clh.covLevelEffDate = 'teststring56';
        clh.covLevelExpDate = 'teststring57';
        
        ACETLGT_MemberSearchCoveragesResult.Address add = new ACETLGT_MemberSearchCoveragesResult.Address();
        add.countryCode = 'teststring58';
        
        ACETLGT_MemberSearchCoveragesResult.PCPAssignment pcpa = new ACETLGT_MemberSearchCoveragesResult.PCPAssignment();
        pcpa.isActive = true;
        pcpa.isChecked = false;
        pcpa.id = 'teststring59';
        pcpa.identifiertype = 'teststring60';
        
        Boolean boolType = pcpa.getIsActive();
        
        String strType = pcpa.getImage();
        
        ACETLGT_MemberSearchCoveragesResult.otherContact oC = new ACETLGT_MemberSearchCoveragesResult.otherContact();
        oC.ContactStatus = false;
        oC.docLink = 'teststring61';
        oC.effectiveDate = 'teststring62';
        oC.FirstName = 'teststring63';
        oC.LastName = 'teststring64';
        oC.MiddleName = 'teststring65';
        oC.relationshipType = 'teststring66';
        oC.terminationDate = 'teststring67';
        oC.Type = 'teststring68';
        
        ACETLGT_MemberSearchCoveragesResult.statusLog sl = new ACETLGT_MemberSearchCoveragesResult.statusLog();
        sl.Changedby = 'teststring69';
        sl.ChangedOn = Date.today();
        sl.EffectiveDate = Date.today() + 100;
        sl.OperationInitiatedby = 'teststring70';
        sl.Reason = 'teststring71';
        sl.StatusAction = true;
        
        
        
        ACETLGT_MemberSearchCoveragesResult.CoverageLine cline = new ACETLGT_MemberSearchCoveragesResult.CoverageLine();
        String getImageCLine = cline.getImage();
        Boolean getIsActiveCLine = cline.getIsActive();
        cline.Network = 'teststring72';
        cline.CoverageLevelCode = 'teststring73';
        cline.FundingArrangement = 'teststring74';
        cline.activeCPVersions = new ACETLGT_MemberSearchCoveragesResult.ActiveCPVersions();
        cline.PlanSitusState = 'teststring75';
		cline.OnshoreRestriction = 'teststring76';
		cline.onshoreRestrictionCode = 'teststring77';
		cline.OnshoreRestrictionVerbiage = 'teststring78';
		cline.isAdvanceSearched = true;
		cline.contractOptionId = 'teststring79';        
        cline.continuationResponsibilityType = 'teststring80';
        cline.insuranceContinuationType = 'teststring81';
        cline.benefitBundleOptionId = 'teststring82';
        cline.subscriberId = 'teststring83';
        cline.memberStatus = 'teststring84';
        cline.DOB = 'teststring85';
        cline.Age = 'teststring86';
        cline.subjectId = 'teststring87';
        cline.originatorId = 'teststring88';
        cline.subjectRelation = 'teststring89';
        cline.subjectRelationCode = 'teststring90';
        cline.hsaPlan = 'teststring91';
        cline.ContractOptionStartDate = 'teststring92';
        cline.ContractOptionEndDate = 'teststring93';
        ACETLGT_MemberSearchCoveragesResult.COB cob = new ACETLGT_MemberSearchCoveragesResult.COB();
        cob.medicareEntitlementType = 'teststring94';
        cob.OtherInsuranceCarrierName = 'teststring95';
        cob.COBTypeDesc = 'teststring96';
        cob.Startdt = 'teststring97';
        cob.Enddt = 'teststring98'; 
        cob.LastUpdate = 'teststring99';
        cob.EntitlementReason = 'teststring100';
        cob.PartAStart = Date.today()-100;
        cob.PartBStart = Date.today()-40;
        cob.PartDStart = Date.today()-10;
        cob.PartAEnd = Date.today();
        cob.PartBEnd = Date.today() + 10;
        cob.PartDEnd = Date.today() + 100;
        cob.otherInsuranceCardholderId = 'teststring101';
        cob.CoverageTypeCode = 'teststring102';
        cob.OrderOfBenefit = 'teststring103';
        cob.BenefitType = 'teststring104';
        
        mscr.EligibilityStatus = 'teststring105';
        mscr.TerminationDate = 'teststring106';
        mscr.DateOfEmployment = Date.today();
        mscr.ClaimAddressline1 = 'teststring107';
        mscr.ClaimAddressline2 = 'teststring108';
        mscr.ClaimAddresscity = 'teststring109';
        mscr.ClaimAddressstate = 'teststring110';
        mscr.ClaimAddresspostalCode = 'teststring111';
        mscr.ClaimAddresscountyCode = 'teststring112';
        mscr.customerPurchase = new List<ACETLGT_MemberSearchCoveragesResult.CustomerPurchase>();
        
        ACETLGT_MemberSearchCoveragesResult.CustomerPurchase cp = new ACETLGT_MemberSearchCoveragesResult.CustomerPurchase();
        cp.coverageStartDate = 'teststring113';
        cp.coverageExpirationDate = 'teststring114';
        cp.benefitBundleOptionID = 'teststring115';
        cp.memberGroupContractPlanOptionID = 'teststring116';
        
        ACETLGT_MemberSearchCoveragesResult.FamilyMember fmObj = new ACETLGT_MemberSearchCoveragesResult.FamilyMember();
        
                
    }
}