// Author - Thanish
// Date - 8th October 2019
// Purpose - Test class for the class SAEMemberProviderSearchCoverageResult

@isTest
public class SAEMemProvSearchCovResTest {

    @isTest
    static void testWrapper() {
        SAEMemberProviderSearchCoveragesResult MPSCR = new SAEMemberProviderSearchCoveragesResult();
        
        MPSCR.intType = 'intType'; System.assertEquals('intType', MPSCR.intType);
        MPSCR.IDs = new set<String>(); System.assertEquals(new set<String>(), MPSCR.IDs);
        MPSCR.Id = '1212121212'; System.assertEquals('1212121212', MPSCR.Id);
        MPSCR.individualIdentifier = 'individual'; System.assertEquals('individual', MPSCR.individualIdentifier);
        MPSCR.lastName = 'Wayne'; System.assertEquals('Wayne', MPSCR.lastName);
        MPSCR.firstName = 'Bruce'; System.assertEquals('Bruce', MPSCR.firstName);
        MPSCR.middleInitial = 'T'; System.assertEquals('T', MPSCR.middleInitial);
        MPSCR.middleName = 'Thomas'; System.assertEquals('Thomas', MPSCR.middleName);
        MPSCR.suffix = 'Jr'; System.assertEquals('Jr', MPSCR.suffix);
        MPSCR.fullName = 'Bruce Thomas Wayne Jr'; System.assertEquals('Bruce Thomas Wayne Jr', MPSCR.fullName);
        MPSCR.gender = 'Male'; System.assertEquals('Male', MPSCR.gender);
        MPSCR.dob = '12/12/1990'; System.assertEquals('12/12/1990', MPSCR.dob);
        MPSCR.SCRId = '1212121212'; System.assertEquals('1212121212', MPSCR.SCRId);
        MPSCR.SSNum = '1212121212'; System.assertEquals('1212121212', MPSCR.SSNum);
        MPSCR.ssn = '212121212'; System.assertEquals('212121212', MPSCR.ssn);
        MPSCR.Address = 'Gotham'; System.assertEquals('Gotham', MPSCR.Address);
        MPSCR.city = 'Gotham'; System.assertEquals('Gotham', MPSCR.city);
        MPSCR.state = 'NY'; System.assertEquals('NY', MPSCR.state);
        MPSCR.zip = '12345'; System.assertEquals('12345', MPSCR.zip);
        MPSCR.SurrogateKey = '101010101'; System.assertEquals('101010101', MPSCR.SurrogateKey);
        MPSCR.SurrogateKeys = new Set<String>(); System.assertEquals(new Set<String>(), MPSCR.SurrogateKeys);
        MPSCR.SurrogateKeysStr = '101010101'; System.assertEquals('101010101', MPSCR.SurrogateKeysStr);
        MPSCR.SourceCode = '101010101'; System.assertEquals('101010101', MPSCR.SourceCode);
        MPSCR.CoverageLines = new List<SAEMemberProviderSearchCoveragesResult.CoverageLine>(); System.assertEquals(new List<SAEMemberProviderSearchCoveragesResult.CoverageLine>(), MPSCR.CoverageLines);
        MPSCR.strCoverageLines = '3'; System.assertEquals('3', MPSCR.strCoverageLines);
        MPSCR.EID = '101010101'; System.assertEquals('101010101', MPSCR.EID);
        MPSCR.CPTIN = '101010101'; System.assertEquals('101010101', MPSCR.CPTIN);
        SAEMemberProviderSearchCoveragesResult.SortBy = 'LastName'; System.assertEquals('LastName', SAEMemberProviderSearchCoveragesResult.SortBy);
        SAEMemberProviderSearchCoveragesResult.SortOrder = 'Asc'; System.assertEquals('Asc', SAEMemberProviderSearchCoveragesResult.SortOrder);
        MPSCR.CoverageTypeValue = 'Cov'; System.assertEquals('Cov', MPSCR.CoverageTypeValue);
        MPSCR.CoverageTypeSet = new Set<String>(); System.assertEquals(new Set<String>(), MPSCR.CoverageTypeSet);
        MPSCR.groupNameValue = 'name'; System.assertEquals('name', MPSCR.groupNameValue);
        MPSCR.groupNameSet = new Set<String>(); System.assertEquals(new Set<String>(), MPSCR.groupNameSet);
        MPSCR.effectiveDateValue = Date.today(); System.assertEquals(Date.today(), MPSCR.effectiveDateValue);
        MPSCR.endDateValue = Date.today(); System.assertEquals(Date.today(), MPSCR.endDateValue);
        MPSCR.groupNumberValue = 'num'; System.assertEquals('num', MPSCR.groupNumberValue);
        MPSCR.groupNumberSet = new Set<String>(); System.assertEquals(new Set<String>(), MPSCR.groupNumberSet);
        MPSCR.sourceCodeValue = 'source'; System.assertEquals('source', MPSCR.sourceCodeValue);
        MPSCR.sourceCodeSet = new Set<String>(); System.assertEquals(new Set<String>(), MPSCR.sourceCodeSet);
        MPSCR.searchOnLoad = false; System.assertEquals(false, MPSCR.searchOnLoad);
        MPSCR.isAdvanceSearched = false; System.assertEquals(false, MPSCR.isAdvanceSearched);
        MPSCR.QMSCOIndicator = 'indicator'; System.assertEquals('indicator', MPSCR.QMSCOIndicator);
        MPSCR.isServiceError = false; System.assertEquals(false, MPSCR.isServiceError);
        MPSCR.MemberId = 'id'; System.assertEquals('id', MPSCR.MemberId);
		MPSCR.RelationShip = 'relationship'; System.assertEquals('relationship', MPSCR.RelationShip);
        MPSCR.RelationShipCode = 'relationship'; System.assertEquals('relationship', MPSCR.RelationShipCode);
        MPSCR.OriginatorRelationship = 'relationship'; System.assertEquals('relationship', MPSCR.OriginatorRelationship);
        MPSCR.Age = '10'; System.assertEquals('10', MPSCR.Age);
        MPSCR.FullSSN = '101010101010'; System.assertEquals('101010101010', MPSCR.FullSSN);
        MPSCR.SpokenLanguage = 'English'; System.assertEquals('English', MPSCR.SpokenLanguage);
        MPSCR.WrittenLanguage = 'English'; System.assertEquals('English', MPSCR.WrittenLanguage);
        MPSCR.Email = 'brucewayne@gmail.com'; System.assertEquals('brucewayne@gmail.com', MPSCR.Email);
        MPSCR.AsianInitiativeIndicator = 'asian'; System.assertEquals('asian', MPSCR.AsianInitiativeIndicator);
        MPSCR.WrittenLanguage = 'English'; System.assertEquals('English', MPSCR.WrittenLanguage);
        MPSCR.MigrationDate = '12/12/2020'; System.assertEquals('12/12/2020', MPSCR.MigrationDate);
        MPSCR.OriginalEffectiveDate = '12/12/2020'; System.assertEquals('12/12/2020', MPSCR.OriginalEffectiveDate);
        MPSCR.DeceasedDate = '12/12/2020'; System.assertEquals('12/12/2020', MPSCR.DeceasedDate);
        MPSCR.PCPRequired = 'true'; System.assertEquals('true', MPSCR.PCPRequired);
        MPSCR.PCPAssignment = 'true'; System.assertEquals('true', MPSCR.PCPAssignment);
        MPSCR.SitusState = 'true'; System.assertEquals('true', MPSCR.SitusState);
        MPSCR.PolicyNumber = '101010101010'; System.assertEquals('101010101010', MPSCR.PolicyNumber);
        MPSCR.FundingArragement = 'arrage'; System.assertEquals('arrage', MPSCR.FundingArragement);
        MPSCR.BenefitPlanId = '101010101010'; System.assertEquals('101010101010', MPSCR.BenefitPlanId);
        MPSCR.FundingArragementCode = 'arrage'; System.assertEquals('arrage', MPSCR.FundingArragementCode);
        MPSCR.MemberStatus = 'status'; System.assertEquals('status', MPSCR.MemberStatus);
        MPSCR.TerminationReason = 'dead'; System.assertEquals('dead', MPSCR.TerminationReason);
        MPSCR.HoldReason = 'arrage'; System.assertEquals('arrage', MPSCR.HoldReason);
        
        SAEMemberProviderSearchCoveragesResult.holdCodeInfo HCI = new SAEMemberProviderSearchCoveragesResult.holdCodeInfo();
        HCI.effectiveDate = '12/12/2020'; HCI.expirationDate = '12/12/2030'; HCI.holdCode = '12345'; 
        HCI.holdDescription = 'Description'; HCI.holdLevel = '2'; HCI.holdNote = 'Note'; HCI.holdRestriction = new List<String>();
        List<SAEMemberProviderSearchCoveragesResult.holdCodeInfo> HCIList = new List<SAEMemberProviderSearchCoveragesResult.holdCodeInfo>();
        HCIList.add(HCI);
        MPSCR.holdCodeList = HCIList; System.assertEquals(HCIList, MPSCR.holdCodeList);
        
        MPSCR.Network = 'OON'; System.assertEquals('OON', MPSCR.Network);
        MPSCR.gatedPlanIndicator = 'gated'; System.assertEquals('gated', MPSCR.gatedPlanIndicator);
        MPSCR.EffectiveDate = '12/12/2020'; System.assertEquals('12/12/2020', MPSCR.EffectiveDate);
        MPSCR.EndDate = '12/12/2030'; System.assertEquals('12/12/2030', MPSCR.EndDate);
        MPSCR.Product = 'product'; System.assertEquals('product', MPSCR.Product);
        MPSCR.ProductType = 'product'; System.assertEquals('product', MPSCR.ProductType);
        MPSCR.BundleOptionID = '1212121212'; System.assertEquals('1212121212', MPSCR.BundleOptionID);
        MPSCR.hsaAvailable = 'true'; System.assertEquals('true', MPSCR.hsaAvailable);
        MPSCR.CoverageLevelCode = '1212121212'; System.assertEquals('1212121212', MPSCR.CoverageLevelCode);
        MPSCR.benefitAdmin = 'admin'; System.assertEquals('admin', MPSCR.benefitAdmin);
        MPSCR.benefitAdminPhone = '1212121212'; System.assertEquals('1212121212', MPSCR.benefitAdminPhone);
        MPSCR.disability = 'blind'; System.assertEquals('blind', MPSCR.disability);
        
        SAEMemberProviderSearchCoveragesResult.DependentDisability DD = new SAEMemberProviderSearchCoveragesResult.DependentDisability();
        DD.diagnosisCode = '1232312'; DD.diagnosisCodeType = 'String'; DD.diagnosisDesc = 'Desc'; DD.disabilityType = 'Type';
        DD.effectiveDate = '12/12/2020'; DD.endDate = '12/12/2030';
        List<SAEMemberProviderSearchCoveragesResult.DependentDisability> ddList = new List<SAEMemberProviderSearchCoveragesResult.DependentDisability>();
        ddList.add(DD);
        MPSCR.disabilityInfo = ddList; System.assertEquals(ddList, MPSCR.disabilityInfo);
        
        SAEMemberProviderSearchCoveragesResult.FinancialsWrapper fw = new SAEMemberProviderSearchCoveragesResult.FinancialsWrapper();
        fw.displayYear = '12/12/2020'; fw.hraVal = 12.3; fw.inNetwork = new SAEMemberProviderSearchCoveragesResult.Financials();
        fw.isHra = false; fw.onNetwork = new SAEMemberProviderSearchCoveragesResult.Financials(); fw.yearType = 'calendar';
        
        SAEMemberProviderSearchCoveragesResult.Financials finance = new SAEMemberProviderSearchCoveragesResult.Financials();
        finance.dedFound = false; finance.deductible = 1.1; finance.dedAmountRem = 1.1; finance.dedSatisfied = 1.1; finance.dedPrecentage = 1.1;
        finance.dedFoundFam = false; finance.deductibleFam = 1.1; finance.dedAmountRemFam = 1.1; finance.dedSatisfiedFam = 1.1; finance.dedFamPrecentage = 1.1;
        finance.outOPFound = false; finance.outOP = 1.1; finance.outOPRemAmount = 1.1; finance.outOPSatisfied = 1.1; finance.oopPrecentage = 1.1;
        finance.outOPFoundFam = false; finance.outOPFam = 1.1; finance.outOPRemAmountFam = 1.1; finance.outOPSatisfiedFam = 1.1; finance.oopFamPrecentage = 1.1;
        finance.OOP_Limit_2_Found = false; finance.OOP_Limit_2 = 1.1; finance.OOP_Limit_2_Satisfied = 1.1; finance.OOP_Limit_2_Rem = 1.1; finance.OOP_Limit_2_Precentage = 1.1;
        finance.OOP_Limit_2_Found_Family = false; finance.OOP_Limit_2_Family = 1.1; finance.OOP_Limit_2_Precentage_Family = 1.1; finance.OOP_Limit_2_Satisfied_Family = 1.1; finance.OOP_Limit_2_Rem_Family = 1.1;
        finance.CopayMax_Found = false; finance.CopayMax = 1.1; finance.CopayMax_Satisfied = 1.1; finance.CopayMax_Remaining = 1.1; finance.CopayMax_Precentage = 1.1;
        finance.CopayMax_Found_Family = false; finance.CopayMax_Family = 1.1; finance.CopayMax_Satisfied_Family = 1.1; finance.CopayMax_Remaining_Family = 1.1; finance.CopayMax_Precentage_Family = 1.1;
        finance.DedCarryOverAmt = 1.1;finance.ComDED = 1.1;finance.ComOOP = 1.1;finance.CrossApplyOOP = 1.1;finance.OOP2Remaining = 1.1;
        finance.CrossApplyOOP2 = 1.1;finance.CopayMax_Satisfied = 1.1;finance.CopayMax_Remaining = 1.1;finance.CrossApplyCopayMax = 1.1;finance.DedCarryOverAmt_Family = 1.1;
        finance.ComDED_Family = 1.1;finance.ComOOP_Family = 1.1;finance.CrossApplyOOP_Family = 1.1;finance.OOP2Remaining_Family = 1.1;finance.CrossApplyOOP2_Family = 1.1;
        finance.CopayMaxSatisfied_Family = 1.1;finance.CopayMaxRemaining_Family = 1.1;finance.CrossApplyCopayMax_Family = 1.1;
        
        fw.tierOne = finance; 
        
        SAEMemberProviderSearchCoveragesResult.CoverageLine cl = new SAEMemberProviderSearchCoveragesResult.CoverageLine();
        cl.BenefitPlanId = '1212121212'; cl.concatAddress = 'USA'; cl.continuationResponsibilityType = 'type';
        cl.contractOptionId = '1212121212'; cl.CoverageLevel = 'level'; cl.CoverageType = 'type'; 
        cl.CoverageTypeCode = '1212121212'; cl.daysGap = 2; cl.EffectiveDate = '12/12/2020'; 
        cl.eligibleDates = '12/12/2020'; cl.EndDate = '12/12/2020'; cl.EnrolleeSurrogateKey = 'key';
        cl.financialWrapper = fw; cl.FundingArrangement = 'arrange'; cl.GroupName = 'name';
        cl.GroupNumber = 'number'; cl.GUID = 'guid'; cl.highlightedPolicy = false;
        cl.insuranceContinuationType = 'type'; cl.isActive = false; cl.isAdvanceSearched = false;
        cl.isFuture = false; cl.isPreferred = false; cl.isSubscriber = false; cl.Network = 'OON';
        cl.nonMedicalPolicyBoolean = false; cl.OnshoreRestriction = 'restrict'; cl.onshoreRestrictionCode = '12121212';
        cl.OnshoreRestrictionVerbiage = 'verbiage'; cl.PlanSitusState = 'state'; cl.planStatus = 'status';
        cl.PolicyName = 'name'; cl.PolicyNumber = '12121212'; cl.Product = 'product'; cl.ProductType = 'type';
        cl.referral = 'referral'; cl.relationShipCode = 'code'; cl.SourceCode = 'source'; cl.SurrogateKey = 'key';
        cl.transactionId = '121212121';
        MPSCR.PreferredCoverage = cl; System.assertEquals(cl, MPSCR.PreferredCoverage);
        //System.assertEquals(true, cl.getIsActive());
        
        MPSCR.GroupSize = '5'; System.assertEquals('5', MPSCR.GroupSize);
        MPSCR.responsibilityType = 'type'; System.assertEquals('type', MPSCR.responsibilityType);
        MPSCR.continuationType = 'type'; System.assertEquals('type', MPSCR.continuationType);
        MPSCR.enrollmentMethod = 'method'; System.assertEquals('method', MPSCR.enrollmentMethod);
        MPSCR.coverageGroupContractOptionId = 'id'; System.assertEquals('id', MPSCR.coverageGroupContractOptionId);
        MPSCR.coverageGroupContractOptionEffDate = 'date'; System.assertEquals('date', MPSCR.coverageGroupContractOptionEffDate);
        MPSCR.coverageGroupContractOptionStatus = 'status'; System.assertEquals('status', MPSCR.coverageGroupContractOptionStatus);
        MPSCR.coverageGroupContractOptionFilterStatus = 'status'; System.assertEquals('status', MPSCR.coverageGroupContractOptionFilterStatus);
        MPSCR.hasPopulation = false; System.assertEquals(false, MPSCR.hasPopulation);
        MPSCR.cobraAdministrativeIndicator = 'cobra'; System.assertEquals('cobra', MPSCR.cobraAdministrativeIndicator);
        MPSCR.onshoreRestriction = 'restrict'; System.assertEquals('restrict', MPSCR.onshoreRestriction);
        
        SAEMemberProviderSearchCoveragesResult.Address adrs = new SAEMemberProviderSearchCoveragesResult.Address();
        adrs.AddressLine1 = 'USA'; adrs.AddressLine2 = 'USA'; adrs.AddressType = 'type'; adrs.City = 'Queens';
        adrs.countryCode = '001'; adrs.State = 'NY'; adrs.Zip = '121212';
        List<SAEMemberProviderSearchCoveragesResult.Address> adrsList = new List<SAEMemberProviderSearchCoveragesResult.Address>();
        adrsList.add(adrs);
        MPSCR.Addresses = adrsList; System.assertEquals(adrsList, MPSCR.Addresses);
        
		SAEMemberProviderSearchCoveragesResult.Phone pn = new SAEMemberProviderSearchCoveragesResult.Phone();
		pn.PhoneNumber = '1234567890'; pn.PhoneNumberType = 'type'; 
        pn.primaryIndicator = 'indicator'; pn.WorkExt = 'work';  
        List<SAEMemberProviderSearchCoveragesResult.Phone> pnList = new List<SAEMemberProviderSearchCoveragesResult.Phone>();
        pnList.add(pn);
		MPSCR.Phones = pnList;
        
        SAEMemberProviderSearchCoveragesResult.PCPAssignment pcp = new SAEMemberProviderSearchCoveragesResult.PCPAssignment();
        pcp.effectiveDate = '12/12/2020'; pcp.endDate = '12/12/2020'; pcp.FirstName = 'Bruce'; pcp.fullName = 'Bruce Wayne';
        pcp.id = '1212121212'; pcp.identifiertype = 'type'; pcp.isActive = false; pcp.isChecked = false; pcp.LastName = 'Wayne';
        pcp.locationAffiliationID = '12121212'; pcp.middleName = 'Thomas'; pcp.NoPCPFlag = false; pcp.pcpAssignmentType = 'type';
        MPSCR.PCPAssignments = pcp; System.assertEquals(pcp, MPSCR.PCPAssignments);
        System.assertEquals(false, pcp.getIsActive());
        
        SAEMemberProviderSearchCoveragesResult.FamilyMember fMem = new SAEMemberProviderSearchCoveragesResult.FamilyMember();
        fMem.Addresses = adrsList; fMem.Age = '12'; fMem.benefitBundleOptionId = '21212121'; fMem.CoverageStatus = 'status';
        fMem.DOB = '12/12/2020'; fMem.effectiveDate = Date.today(); fMem.EID = '12212121'; fMem.FamilyId = '12121212';
        fMem.FirstName = 'Martha'; fMem.Gender = 'Female'; fMem.groupNumber = '12121212'; fMem.LastName = 'Wayne';
        fMem.memberStatus = 'status'; fMem.MiddleInitial = 'T'; fMem.reinstDate = Date.today(); fMem.Relationship = 'relate';
        fMem.selected = false; fMem.subscriberIndividualId = '1212121212'; fMem.suffix = 'madam'; fMem.termDate = Date.today();
        List<SAEMemberProviderSearchCoveragesResult.FamilyMember> fmList = new List<SAEMemberProviderSearchCoveragesResult.FamilyMember>();
        fmList.add(fMem);
        MPSCR.FamilyMembers = fmList;
        
        SAEMemberProviderSearchCoveragesResult.MemberEligibilityCoverage MECoverage = new SAEMemberProviderSearchCoveragesResult.MemberEligibilityCoverage();
        MECoverage.benefitPlanId = '12345'; MECoverage.coverageType = 'full'; MECoverage.effectivedate = '08/10/2019'; 
       	MECoverage.endDate = '12/12/2020'; MECoverage.groupNumber = '121212121';
        MPSCR.EligibilityCoverage = MECoverage; System.assertEquals(MECoverage, MPSCR.EligibilityCoverage);
        
        SAEMemberProviderSearchCoveragesResult.otherContact oCont = new SAEMemberProviderSearchCoveragesResult.otherContact();
        oCont.ContactStatus = false; oCont.docLink = 'link'; oCont.effectiveDate = '12/12/2020'; oCont.FirstName = 'Alfred';
        oCont.LastName = 'Pennyworth'; oCont.MiddleName = 'Awesome'; oCont.terminationDate = '12/12/2020';
        List<SAEMemberProviderSearchCoveragesResult.otherContact> oContList = new List<SAEMemberProviderSearchCoveragesResult.otherContact>();
        MPSCR.ROIcontacts = oContList; System.assertEquals(oContList, MPSCR.ROIcontacts);

        SAEMemberProviderSearchCoveragesResult.statusLog sLog = new SAEMemberProviderSearchCoveragesResult.statusLog();
        sLog.Changedby = 'Thomas'; sLog.ChangedOn = Date.today(); sLog.EffectiveDate = Date.today();
        sLog.OperationInitiatedby = 'op'; sLog.Reason = 'reason'; sLog.StatusAction = false;
        List<SAEMemberProviderSearchCoveragesResult.statusLog> sLogList = new List<SAEMemberProviderSearchCoveragesResult.statusLog>();
        MPSCR.MemberStatusLogs = sLogList; System.assertEquals(sLogList, MPSCR.MemberStatusLogs);
        
        MPSCR.GroupVsOnshoreIndicator = new Map<String,String>(); System.assertEquals(new Map<String,String>(), MPSCR.GroupVsOnshoreIndicator);
        
        SAEMemberProviderSearchCoveragesResult.COB cob = new SAEMemberProviderSearchCoveragesResult.COB();
        cob.Age = '12'; cob.BenefitType = 'type'; cob.COBTypeDesc = 'desc'; cob.CoverageTypeCode = 'code';
        cob.DateOfBirth = '12/12/2020'; cob.Enddt = Date.today(); cob.EntitlementReason = 'reason';
        cob.InsuranceType = 'type'; cob.IsMedicarePrimary = 'primary'; cob.IsOtherInsurancePrimary = 'primary';
        cob.LastUpdate = Date.today(); cob.medicareEntitlementType = 'type'; cob.MedicareType = 'type';
        cob.MemberId = '12121212'; cob.Name = 'name'; cob.OrderOfBenefit = 'benefit'; cob.otherInsuranceCardholderId = 'id';
        cob.OtherInsuranceCarrierName = 'name'; cob.PartAEnd = Date.today(); cob.PartAStart = Date.today();
        cob.PartBEnd = Date.today(); cob.PartBStart = Date.today(); cob.PartDEnd = Date.today(); cob.PartDStart = Date.today();
        cob.Relationship = 'relation'; cob.Startdt = Date.today();
        List<SAEMemberProviderSearchCoveragesResult.COB> cobList = new List<SAEMemberProviderSearchCoveragesResult.COB>();
        cobList.add(cob);
        MPSCR.lstCOB = cobList; System.assertEquals(cobList, MPSCR.lstCOB);
        
        MPSCR.EnrolleeSurrogateKey = 'key'; System.assertEquals('key', MPSCR.EnrolleeSurrogateKey);
        MPSCR.onshore = 'shore'; System.assertEquals('shore', MPSCR.onshore);
        
        SAEMemberProviderSearchCoveragesResult.CoverageLineHistory CLH = new SAEMemberProviderSearchCoveragesResult.CoverageLineHistory();
        CLH.covLevelCode = '123231'; CLH.covLevelDesc = 'Desc'; CLH.covLevelEffDate = Date.newInstance(2020, 12, 12); 
        CLH.covLevelExpDate = Date.newInstance(2030, 12, 12);
        List<SAEMemberProviderSearchCoveragesResult.CoverageLineHistory> clhList = new List<SAEMemberProviderSearchCoveragesResult.CoverageLineHistory>();
        clhList.add(CLH);
        MPSCR.lstCoverageLineHistory = clhList;
        
        SAEMemberProviderSearchCoveragesResult.MemberCard mCard = new SAEMemberProviderSearchCoveragesResult.MemberCard();
        mCard.address = 'America'; mCard.Age = '10'; mCard.dob = '23/04/2018'; mCard.gender = 'Other'; mCard.memberId = '12123231';
        mCard.name = 'Bruce'; mCard.pcpProvider = 'DHL'; mCard.pcpProviderhistory = 'DHL History'; mCard.phone = '1234567890';
        MPSCR.memberCardView = mCard; System.assertEquals(mCard, MPSCR.memberCardView);
        
        MPSCR.EligibilityStatus = 'status'; System.assertEquals('status', MPSCR.EligibilityStatus);
        MPSCR.TerminationDate = Date.today(); System.assertEquals(Date.today(), MPSCR.TerminationDate);
        MPSCR.DateOfEmployment = Date.today(); System.assertEquals(Date.today(), MPSCR.DateOfEmployment);
        MPSCR.EmploymentStatus = 'status'; System.assertEquals('status', MPSCR.EmploymentStatus);
        MPSCR.CoverageLevel = 'level'; System.assertEquals('level', MPSCR.CoverageLevel);
        MPSCR.GroupName = 'name'; System.assertEquals('name', MPSCR.GroupName);
        MPSCR.EmploymentStartDate = 'date'; System.assertEquals('date', MPSCR.EmploymentStartDate);
        MPSCR.ClaimAddressline1 = 'line'; System.assertEquals('line', MPSCR.ClaimAddressline1);
        MPSCR.ClaimAddressline2 = 'line'; System.assertEquals('line', MPSCR.ClaimAddressline2);
        MPSCR.ClaimAddresscity = 'city'; System.assertEquals('city', MPSCR.ClaimAddresscity);
        MPSCR.ClaimAddressstate = 'state'; System.assertEquals('state', MPSCR.ClaimAddressstate);
        MPSCR.ClaimAddresspostalCode = 'code'; System.assertEquals('code', MPSCR.ClaimAddresspostalCode);
        MPSCR.ClaimAddresscountyCode = 'code'; System.assertEquals('code', MPSCR.ClaimAddresscountyCode);
    }
    
}