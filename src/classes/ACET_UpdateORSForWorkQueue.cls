/*
* @Desc: US3323348 - Request body formation class for  Update & Route ORS records in Work Queues.
* @Date: 10th of Mar 2021
* @Dev: S.T.Sarma
*/

public with sharing class ACET_UpdateORSForWorkQueue {
    

// Method to form the Update ORS request from ReadIssue Response & Other Details.
    public static ACET_UpdateORSRequest createUpdateRequest(ACET_WorkQueueController.OrsRequestDetails orsRequestDetails, ACET_ORSReadIssueWrapper readIssueResponse , List<String> commentList, ACET_UpdateORSRequest.OrsSourceSystemParameters userDetails){
    //Main object
    ACET_UpdateORSRequest returnObject = new ACET_UpdateORSRequest();
    try{
        //Meta
        ACET_UpdateORSRequest.Meta meta = new ACET_UpdateORSRequest.Meta();
        //ControlModifiers
        ACET_UpdateORSRequest.ControlModifiers controlModifiers = new ACET_UpdateORSRequest.ControlModifiers();
        // System Params
        ACET_UpdateORSRequest.OrsSourceSystemParameters orsSourceSystemParameters = new ACET_UpdateORSRequest.OrsSourceSystemParameters();
        orsSourceSystemParameters.logonId = userDetails.logonId;
        orsSourceSystemParameters.logonOffice = userDetails.logonOffice;

        controlModifiers.orsSourceSystemParameters = orsSourceSystemParameters;
        meta.controlModifiers = controlModifiers;
        returnObject.meta = meta;

        //Data
        ACET_UpdateORSRequest.Data data = new ACET_UpdateORSRequest.Data();
        data.modifiedByApplicationIndicator = 'H';
        data.updateType = 'O';

        //Issue 
        ACET_UpdateORSRequest.Issue issue = new ACET_UpdateORSRequest.Issue();
        issue.assignedPssId = '';
        issue.businessSegmentName = ACET_UpdateORSForWorkQueue.objStrOrBlank(readIssueResponse.issue.businessSegmentName);
        issue.callAttemptDetailText = '';
        issue.callbackPromisedDate = '';
        issue.callExceedsExpectationIndicator = '';
        issue.callMeetsExpectationIndicator = '';
        issue.callProgramName = '';
        issue.campaignReportText = '';
        issue.caseNumber = ACET_UpdateORSForWorkQueue.objStrOrBlank(readIssueResponse.issue.caseNumber);
        issue.checkNumber = '';
        //Drafts
        ACET_UpdateORSRequest.Drafts drafts = new ACET_UpdateORSRequest.Drafts();
        List<ACET_UpdateORSRequest.Drafts> draftsList = new List<ACET_UpdateORSRequest.Drafts> ();
        drafts.draftNumber = '';
        drafts.inventoryControlNumber = '';
        draftsList.add(drafts);
        //Atg
        ACET_UpdateORSRequest.Atg atg = new ACET_UpdateORSRequest.Atg();
        atg.sourceId = '';
        atg.drafts = draftsList;
        //Claim
        ACET_UpdateORSRequest.Claim claim = new ACET_UpdateORSRequest.Claim();
        claim.adjustedClaimIndicator = '';
        claim.atg = atg;
        claim.atgIndicator = '';
        claim.authorization = '';
        claim.claimApp = '';
        claim.claimAppSsn = '';
        claim.claimNumber = ACET_UpdateORSForWorkQueue.objStrOrBlank(readIssueResponse.issue.claim.claimNumber); // Claim Fix
        claim.claimOffice = '';
        claim.engineCode = '';
        claim.filmNumber = '';
        claim.filmOffice = '';
        claim.filmSystem = '';
        claim.fundingArrangement = '';
        claim.invoiceNumber = '';
        claim.payLocationNumber = '';
        claim.serviceDate = ACET_UpdateORSForWorkQueue.objStrOrBlank(readIssueResponse.issue.claim.serviceDate); // Claim Fix
        claim.substituteIndicator = '';
        claim.totalAmount = '';
        issue.claim = claim;
        // Comments
        issue.comments = commentList; // List of string with 71 chars

        issue.complaintCategoryText = '';
        issue.contactElapseTime = 0 ; // Integer
        issue.contactId = '';
        issue.contactMethodCode = ACET_UpdateORSForWorkQueue.objStrOrBlank(readIssueResponse.issue.contactMethodCode);
        issue.deleteRequestIndicator = '';
        issue.directionCode = ACET_UpdateORSForWorkQueue.objStrOrBlank(readIssueResponse.issue.directionCode);
        issue.disposition = '';
        issue.dispositionNotificationDate = '';
        //Employer
        ACET_UpdateORSRequest.Employer employer = new ACET_UpdateORSRequest.Employer();
        employer.employerName = '';
        employer.employerNumber = '';
        employer.employerState = '';
        issue.employer = employer;
        //FollowUp
        ACET_UpdateORSRequest.FollowUp followUp = new ACET_UpdateORSRequest.FollowUp();
        //FollowUp - Cellphone
        ACET_UpdateORSRequest.CellPhone cellPhone = new ACET_UpdateORSRequest.CellPhone();
        cellPhone.areaCode = '';
        cellPhone.number_Z = '';
        cellPhone.extension = '';
        cellPhone.extension2 = '';
        followUp.cellPhone = cellPhone;

        followUp.contactDate = '';
        //FollowUp - Creator
        ACET_UpdateORSRequest.Creator creator = new ACET_UpdateORSRequest.Creator();
        creator.associateId = '';
        creator.departmentCode = '';
        creator.officeId = '';
        creator.teamCode = '';
        followUp.creator = creator;
        
        followUp.email = '';
        followUp.estimatedCompletionDate = '';
        //FollowUp - Fax
        ACET_UpdateORSRequest.CellPhone fax = new ACET_UpdateORSRequest.CellPhone();
        fax.areaCode = '';
        fax.number_Z = '';
        fax.extension = '';
        fax.extension2 = '';
        followUp.fax = fax;

        followUp.followUpDate = ACET_UpdateORSForWorkQueue.objStrOrBlank(readIssueResponse.issue.followupDate);
        //FollowUp - HomePhone
        ACET_UpdateORSRequest.CellPhone homePhone = new ACET_UpdateORSRequest.CellPhone();
        homePhone.areaCode = '';
        homePhone.number_Z = '';
        homePhone.extension = '';
        homePhone.extension2 = '';
        followUp.homePhone = homePhone;

        followUp.nextAction = '';
        followUp.nextActionDueDate = '';
        //FollowUp - OtherPhone
        ACET_UpdateORSRequest.CellPhone otherPhone = new ACET_UpdateORSRequest.CellPhone();
        otherPhone.areaCode = '';
        otherPhone.number_Z = '';
        otherPhone.extension = '';
        otherPhone.extension2 = '';
        followUp.otherPhone = otherPhone;

        followUp.preferredContactTime = '';
        followUp.primaryContact = '';
        followUp.purposeCode = '';
        followUp.resolvedDate = '';
        followUp.statusCode = '';
        followUp.voiceMailIndicator = '';
        //FollowUp - WorkPhone
        ACET_UpdateORSRequest.CellPhone workPhone = new ACET_UpdateORSRequest.CellPhone();
        workPhone.areaCode = '';
        workPhone.number_Z = '';
        workPhone.extension = '';
        workPhone.extension2 = '';
        followUp.workPhone = workPhone;
        issue.followUp = followUp;
        //Grievance
        ACET_UpdateORSRequest.Grievance grievance = new ACET_UpdateORSRequest.Grievance();
        grievance.categoryText = '';
        grievance.dispositionText = '';
        grievance.reasonCode = '';
        grievance.reasonText = '';
        grievance.receiptDate = '';
        issue.grievance = grievance;

        issue.hipaaIndicator = ACET_UpdateORSForWorkQueue.objStrOrBlank(readIssueResponse.issue.hipaaIndicator);
        issue.issueElapseTime = 0 ; //Integer
        //IssueHandling
        ACET_UpdateORSRequest.IssueHandling issueHandling = new ACET_UpdateORSRequest.IssueHandling();
        //IssueHandling - CarbonCopies
        List<ACET_UpdateORSRequest.Creator> carbonCopiesList = new List<ACET_UpdateORSRequest.Creator> ();
        ACET_UpdateORSRequest.Creator carbonCopy = new ACET_UpdateORSRequest.Creator();
        carbonCopy.associateId = '';
        carbonCopy.departmentCode = '';
        carbonCopy.officeId = '';
        carbonCopy.teamCode = '';
        carbonCopiesList.add(carbonCopy);
        issueHandling.carbonCopies = carbonCopiesList;

        //IssueHandling - Resolved By
        ACET_UpdateORSRequest.Creator resolvedBy = new ACET_UpdateORSRequest.Creator();
        resolvedBy.associateId = '';
        resolvedBy.departmentCode = '';
        resolvedBy.officeId = '';
        resolvedBy.teamCode = '';
        issueHandling.resolvedBy = resolvedBy;
        //IssueHandling - Routed To
        ACET_UpdateORSRequest.Creator routedTo = new ACET_UpdateORSRequest.Creator();
        routedTo.associateId = '';
        routedTo.departmentCode = '';
        routedTo.officeId = '';
        routedTo.teamCode = '';
        if(orsRequestDetails.routeOrClose == 'routeCase'){
            routedTo.associateId = '' ; // need to check with Varsha
            routedTo.departmentCode = orsRequestDetails.departmentCode;
            routedTo.officeId = orsRequestDetails.officeId;
            routedTo.teamCode = orsRequestDetails.teamCode;
        }
        issueHandling.routedTo = routedTo;
        issue.issueHandling = issueHandling;

        issue.launchCategoryText = '';
        issue.launchReasonText = '';
        //LogoLookups
        List<ACET_UpdateORSRequest.LogoLookups> logoLookupList = new List<ACET_UpdateORSRequest.LogoLookups> ();
        ACET_UpdateORSRequest.LogoLookups logoLookups = new ACET_UpdateORSRequest.LogoLookups();
        logoLookups.bodyFontName = '';
        logoLookups.bodyFontNumber = '';
        logoLookups.bodyFontSizeNumber = '';
        logoLookups.constituentText = '';
        logoLookups.duncanImageNumber = '';
        logoLookups.rtnFontName = '';
        logoLookups.rtnFontNumber = '';
        logoLookups.rtnFontSizeNumber = '';
        logoLookupList.add(logoLookups);
        issue.logoLookups = logoLookupList;

        issue.manualRouteIndicator = ''; 
        //Member
        ACET_UpdateORSRequest.Member member = new ACET_UpdateORSRequest.Member();
        //Member - Address
        ACET_UpdateORSRequest.Address address = new ACET_UpdateORSRequest.Address();
        address.city = ACET_UpdateORSForWorkQueue.objStrOrBlank(readIssueResponse.issue.serviceRequest.memberCity);
        address.countryCode = ACET_UpdateORSForWorkQueue.objStrOrBlank(readIssueResponse.issue.member.countryCode);
        address.countryName = '';
        address.countyCode = '';
        address.countyName = '';
        address.state = '';
        address.street1 = ACET_UpdateORSForWorkQueue.objStrOrBlank(readIssueResponse.issue.serviceRequest.memberStreet1);
        address.street2 = ACET_UpdateORSForWorkQueue.objStrOrBlank(readIssueResponse.issue.serviceRequest.memberStreet2);
        address.zip = ACET_UpdateORSForWorkQueue.objStrOrBlank(readIssueResponse.issue.member.zipCode);
        address.zip4 = '';
        member.address =address;

        member.age = String.isNotBlank(readIssueResponse.issue.member.age)?Integer.valueOf(readIssueResponse.issue.member.age):null; // Integer
        member.alternateId = ACET_UpdateORSForWorkQueue.objStrOrBlank(readIssueResponse.issue.member.alternateId);
        member.ambulanceIndicator = '';
        member.assignedCsrName = '';
        member.benefitPackageCode = ACET_UpdateORSForWorkQueue.objStrOrBlank(readIssueResponse.issue.member.benefitPackageCode);
        member.clientCode = '';
        member.copayEffectiveDate = '';
        member.coverageIndicator = '';
        member.customerNumber = ACET_UpdateORSForWorkQueue.objStrOrBlank(readIssueResponse.issue.member.customerNumber);
        member.dateOfBirth = ACET_UpdateORSForWorkQueue.objStrOrBlank(readIssueResponse.issue.member.dateOfBirth);
        member.dateOfDeath = ACET_UpdateORSForWorkQueue.objStrOrBlank(readIssueResponse.issue.member.dateOfDeath);
        //Member - DependentName
        ACET_UpdateORSRequest.DependentName dependentName = new ACET_UpdateORSRequest.DependentName();
        dependentName.firstInitial = '';
        dependentName.firstName = ACET_UpdateORSForWorkQueue.objStrOrBlank(readIssueResponse.issue.member.dependentName.firstName);
        dependentName.lastName = ACET_UpdateORSForWorkQueue.objStrOrBlank(readIssueResponse.issue.member.dependentName.lastName);
        dependentName.middleInitial = '';
        member.dependentName = dependentName;

        member.dependentNumber = ACET_UpdateORSForWorkQueue.objStrOrBlank(readIssueResponse.issue.member.dependentNumber);
        member.division = '';
        member.dlEligIndicator = '';
        member.eligibilitySourceSystem = '';
        member.eligibilityValidatedFlag = ACET_UpdateORSForWorkQueue.objStrOrBlank(readIssueResponse.issue.member.eligibilityValidatedFlag);
        member.email = '';
        member.emailIndicator = '';
        member.enrollmentSourceCode = ACET_UpdateORSForWorkQueue.objStrOrBlank(readIssueResponse.issue.member.enrollmentSourceCode);
        member.facetPlanCode = '';
        //Member - FaxNumber
        ACET_UpdateORSRequest.CellPhone faxNumber = new ACET_UpdateORSRequest.CellPhone();
        faxNumber.areaCode = '';
        faxNumber.number_Z = '';
        faxNumber.extension = '';
        faxNumber.extension2 = '';
        member.faxNumber = faxNumber;

        member.fontIndicator = '';
        member.genderCode = ACET_UpdateORSForWorkQueue.objStrOrBlank(readIssueResponse.issue.member.genderCode);
        member.groupName = ACET_UpdateORSForWorkQueue.objStrOrBlank(readIssueResponse.issue.member.groupName);
        member.groupNumber = ACET_UpdateORSForWorkQueue.objStrOrBlank(readIssueResponse.issue.member.groupNumber);
        member.hippaEligibleFlag = '';
        member.ipaCode = '';
        member.iPlanIndicator = '';
        member.languageTranslationId = '';
        member.legalEntity = '';
        member.lisPctCode = '';
        member.logoIndicator = '';
        member.logonId = '';
        member.market = ACET_UpdateORSForWorkQueue.objStrOrBlank(readIssueResponse.issue.member.market);
        member.masterGroupNumber = '';
        member.medicaidId = '';
        member.medicareId = '';
        member.medicareStatusCode = '';
        member.meetingDate = '';
        member.meetingTypeName = '';
        //Member - MemberName
        ACET_UpdateORSRequest.DependentName memberName = new ACET_UpdateORSRequest.DependentName();
        memberName.firstInitial = '';
        memberName.firstName = ACET_UpdateORSForWorkQueue.objStrOrBlank(readIssueResponse.issue.member.memberName.firstName);
        memberName.lastName = ACET_UpdateORSForWorkQueue.objStrOrBlank(readIssueResponse.issue.member.memberName.lastName);
        memberName.middleInitial = '';

        member.memberName = memberName;
        member.memberNumber = ACET_UpdateORSForWorkQueue.objStrOrBlank(readIssueResponse.issue.member.memberNumber);
        member.memberVerifiedIndicator = '';
        member.militaryTreatmentFacilityLocation = '';
        member.neonIndicator = '';
        member.networkPrefixCode = '';
        member.obligorId = ACET_UpdateORSForWorkQueue.objStrOrBlank(readIssueResponse.issue.member.obligorId);
        member.optOutIndicator = '';
        member.originalEffectiveDate = '';
        member.otherGroupNumber = '';
        member.otherProduct = '';
        member.otherSubscriberId = '';
        member.panelCode = '';
        member.parentGroupName = '';
        member.passportIndicator = '';
        member.pcpOverrideIndicator = '';
        member.personalIdentificationNumber = ACET_UpdateORSForWorkQueue.objStrOrBlank(readIssueResponse.issue.member.personalIdentificationNumber);
        //Member - Phone
        ACET_UpdateORSRequest.CellPhone phone = new ACET_UpdateORSRequest.CellPhone();
        phone.areaCode = '';
        phone.number_Z = ACET_UpdateORSForWorkQueue.objStrOrBlank(readIssueResponse.issue.serviceRequest.memberPhoneNumber);
        phone.extension = '';
        phone.extension2 = '';
        member.phone = phone;

        member.planCode = ACET_UpdateORSForWorkQueue.objStrOrBlank(readIssueResponse.issue.member.planCode);
        member.planEffectiveDate = ACET_UpdateORSForWorkQueue.objStrOrBlank(readIssueResponse.issue.member.originalEffectiveDate);
        member.planEndDate = '';
        member.planVariationCode = '';
        member.policy = ACET_UpdateORSForWorkQueue.objStrOrBlank(readIssueResponse.issue.member.policy);
        member.premiumWithholdCode = '';
        member.primaryPolicyNumber = '';
        member.primeIndicator = '';
        member.product = ACET_UpdateORSForWorkQueue.objStrOrBlank(readIssueResponse.issue.member.product);
        member.raceEthnicityCode = '';
        member.rank = '';
        member.regionCode = '';
        member.relationshipCode = ACET_UpdateORSForWorkQueue.objStrOrBlank(readIssueResponse.issue.member.relationshipCode);
        member.relationshipSequenceNumber = ACET_UpdateORSForWorkQueue.objStrOrBlank(readIssueResponse.issue.member.relationshipSequenceNumber);
        member.reportingCode = '';
        member.riderCodeIndicator = '';

        List<String> riderCodes = new List<String> ();
        member.riderCodes = riderCodes;
        member.secondaryDrugInsuranceIndicator = '';
        //Member - ServicesQuoted
        ACET_UpdateORSRequest.ServicesQuoted servicesQuoted = new ACET_UpdateORSRequest.ServicesQuoted();
        servicesQuoted.alternativeAndHolisticMedicineServiceQuoted = '';
        servicesQuoted.bloodServiceQuoted = '';
        servicesQuoted.brandDrugsServiceQuoted = '';
        servicesQuoted.careManagementProgramServiceQuoted = '';
        servicesQuoted.cataractSurgeryBenefitsQuoted = '';
        servicesQuoted.chiropracticServiceQuoted = '';
        servicesQuoted.cosmeticServiceQuoted = '';
        servicesQuoted.csrProgramServiceQuoted = '';
        servicesQuoted.custodialCareServiceQuoted = '';
        servicesQuoted.deductibleServiceQuoted = '';
        servicesQuoted.dentalServiceQuoted = '';
        servicesQuoted.diabeticEducationServiceQuoted = '';
        servicesQuoted.diabeticMonitorAndSuppliesServiceQuoted = '';
        servicesQuoted.diagnosticAndRadiologyServiceQuoted = '';
        servicesQuoted.diagnosticLaboratoryServiceQuoted = '';
        servicesQuoted.durableMedicalEquipmentServiceQuoted = '';
        servicesQuoted.emergencyAndUrgentCareServiceQuoted = '';
        servicesQuoted.familyPlanningServiceQuoted = '';
        servicesQuoted.genericDrugsServiceQuoted = '';
        servicesQuoted.gymMembershipServiceQuoted = '';
        servicesQuoted.healthyLivingProgramsServiceQuoted = '';
        servicesQuoted.hearingExamServiceQuoted = '';
        servicesQuoted.hearingServiceQuoted = '';
        servicesQuoted.homeHealthServiceQuoted = '';
        servicesQuoted.immunizationsServiceQuoted = '';
        servicesQuoted.inpatientHospitalAndMedicalServiceQuoted = '';
        servicesQuoted.inpatientMentalHealthServiceQuoted = '';
        servicesQuoted.mailOrderServiceQuoted = '';
        servicesQuoted.maxLimitationsServiceQuoted = '';
        servicesQuoted.maxOutOfPocketQuoted = '';
        servicesQuoted.medicareCoveredDentalServiceQuoted = '';
        servicesQuoted.memberMeetingsServiceQuoted = '';
        servicesQuoted.nonRadiologyAndTherapeuticServiceQuoted = '';
        servicesQuoted.oonBenefitServiceQuoted = '';
        servicesQuoted.orthoticsAndProstheticsServiceQuoted = '';
        servicesQuoted.otcSuppliesServiceQuoted = '';
        servicesQuoted.outpatientMentalHealthServiceQuoted = '';
        servicesQuoted.outpatientRehabilitationServiceQuoted = '';
        servicesQuoted.outpatientSurgeryAndObservationServiceQuoted = '';
        servicesQuoted.partBDrugsServiceQuoted = '';
        servicesQuoted.pcpOfficeVisitServiceQuoted = '';
        servicesQuoted.pharmacyLocatorServiceQuoted = '';
        servicesQuoted.podiatryBenefitsServiceQuoted = '';
        servicesQuoted.preferredFormularyServiceQuoted = '';
        servicesQuoted.preventiveScreeningServiceQuoted = '';
        servicesQuoted.renalDialysisServiceQuoted = '';
        servicesQuoted.riderBenefitsServiceQuoted = '';
        servicesQuoted.skilledNursingServiceQuoted = '';
        servicesQuoted.specialistOfficeVisitServiceQuoted = '';
        servicesQuoted.transplantServiceQuoted = '';
        servicesQuoted.transportationServiceQuoted = '';
        servicesQuoted.trueOopServiceQuoted = '';
        servicesQuoted.unfundedProgramsServiceQuoted = '';
        servicesQuoted.valueAddedServiceServiceQuoted = '';
        servicesQuoted.visionBenefitServiceQuoted = '';
        member.servicesQuoted = servicesQuoted;

        member.sharedArrangementId = ACET_UpdateORSForWorkQueue.objStrOrBlank(readIssueResponse.issue.member.sharedArrangementId);
        member.site = '';
        member.ssaPaymentCode = '';
        member.statusCode = '';
        member.subsidyOverrideIndicator = '';
        member.totalNonCoverageCount = 0; // Integer
        member.verbalLanguageName = '';
        member.walkinTime = '';
        member.writtenLanguageName = '';
        issue.member = member; 

        issue.originalApplicationFileDate = '';
        //Originator
        ACET_UpdateORSRequest.Originator originator = new ACET_UpdateORSRequest.Originator();
        //Originator - Caller Address
        ACET_UpdateORSRequest.Address callerAddress = new ACET_UpdateORSRequest.Address();
        callerAddress.city = ACET_UpdateORSForWorkQueue.objStrOrBlank(readIssueResponse.issue.originator.callerAddress.city);
        callerAddress.countryCode = '';
        callerAddress.countryName = '';
        callerAddress.countyCode = '';
        callerAddress.countyName = '';
        callerAddress.state = ACET_UpdateORSForWorkQueue.objStrOrBlank(readIssueResponse.issue.originator.callerAddress.state);
        callerAddress.street1 = ACET_UpdateORSForWorkQueue.objStrOrBlank(readIssueResponse.issue.originator.callerAddress.street1);
        callerAddress.street2 = '';
        callerAddress.zip = ACET_UpdateORSForWorkQueue.objStrOrBlank(readIssueResponse.issue.originator.callerAddress.zip);
        callerAddress.zip4 = ACET_UpdateORSForWorkQueue.objStrOrBlank(readIssueResponse.issue.originator.callerAddress.zip4);
        originator.callerAddress = callerAddress;
        //Originator - Caller Name
        ACET_UpdateORSRequest.DependentName callerName = new ACET_UpdateORSRequest.DependentName();
        callerName.firstInitial = '';
        callerName.firstName = ACET_UpdateORSForWorkQueue.objStrOrBlank(readIssueResponse.issue.originator.callerName.firstName);
        callerName.lastName = ACET_UpdateORSForWorkQueue.objStrOrBlank(readIssueResponse.issue.originator.callerName.lastName);
        callerName.middleInitial = '';
        originator.callerName = callerName;
        //Originator - Cti
        ACET_UpdateORSRequest.Cti cti = new ACET_UpdateORSRequest.Cti();
        cti.autoId = ACET_UpdateORSForWorkQueue.objStrOrBlank(readIssueResponse.issue.originator.autoId);
        cti.dialedId = ACET_UpdateORSForWorkQueue.objStrOrBlank(readIssueResponse.issue.originator.dialedId);
        cti.icrCallLocationDay = ACET_UpdateORSForWorkQueue.objStrOrBlank(readIssueResponse.issue.originator.icrCallLocationDay);
        cti.icrCallLocationId = ACET_UpdateORSForWorkQueue.objStrOrBlank(readIssueResponse.issue.originator.icrCallLocationId);
        originator.cti = cti;
        //Originator - Day Phone
        ACET_UpdateORSRequest.CellPhone dayPhone = new ACET_UpdateORSRequest.CellPhone();
        dayPhone.areaCode = ACET_UpdateORSForWorkQueue.objStrOrBlank(readIssueResponse.issue.originator.dayPhone.areaCode);
        dayPhone.number_Z = ACET_UpdateORSForWorkQueue.objStrOrBlank(readIssueResponse.issue.originator.dayPhone.number_Z);
        dayPhone.extension = ACET_UpdateORSForWorkQueue.objStrOrBlank(readIssueResponse.issue.originator.dayPhone.extension);
        dayPhone.extension2 = '';
        originator.dayPhone = dayPhone;
        //Originator - Evening Phone
        ACET_UpdateORSRequest.CellPhone eveningPhone = new ACET_UpdateORSRequest.CellPhone();
        eveningPhone.areaCode = ACET_UpdateORSForWorkQueue.objStrOrBlank(readIssueResponse.issue.originator.eveningPhone.areaCode);
        eveningPhone.number_Z = ACET_UpdateORSForWorkQueue.objStrOrBlank(readIssueResponse.issue.originator.eveningPhone.number_Z);
        eveningPhone.extension = ACET_UpdateORSForWorkQueue.objStrOrBlank(readIssueResponse.issue.originator.eveningPhone.extension);
        eveningPhone.extension2 = '';
        originator.eveningPhone = eveningPhone;

        originator.originatorMpin = ACET_UpdateORSForWorkQueue.objStrOrBlank(readIssueResponse.issue.originator.originatorMpin);
        originator.originatorTin = ACET_UpdateORSForWorkQueue.objStrOrBlank(readIssueResponse.issue.originator.originatorTin);
        originator.originatorTinSuffix = ACET_UpdateORSForWorkQueue.objStrOrBlank(readIssueResponse.issue.originator.originatorTinSuffix);
        originator.originatorTypeCode = ACET_UpdateORSForWorkQueue.objStrOrBlank(readIssueResponse.issue.originatorTypeCode);
        originator.providerId = '';
        issue.originator = originator; 
        //Other Info
        ACET_UpdateORSRequest.OtherInfo otherInfo = new ACET_UpdateORSRequest.OtherInfo();
        otherInfo.agencyName = '';
        otherInfo.agencyTaxId = '';
        otherInfo.agencyUniqueId = '';
        otherInfo.company = ACET_UpdateORSForWorkQueue.objStrOrBlank(readIssueResponse.issue.other.company);
        otherInfo.complState = '';
        otherInfo.incompleteFlag = ACET_UpdateORSForWorkQueue.objStrOrBlank(readIssueResponse.issue.other.incompleteFlag);
        otherInfo.insuranceCompany = '';
        otherInfo.lineType = '';
        otherInfo.qaCategory = '';
        otherInfo.qaCodeType = '';
        otherInfo.qaSource = '';
        otherInfo.qitType = '';
        issue.otherInfo = otherInfo; 

        issue.overrideIndicator = '';
        issue.payer = ACET_UpdateORSForWorkQueue.objStrOrBlank(readIssueResponse.issue.payer);
        issue.pharmacyClaimNumber = '';
        issue.pharmacyClassText = '';
        issue.pharmacyId = '';
        issue.pharmacyName = '';
        issue.priority = ACET_UpdateORSForWorkQueue.objStrOrBlank(readIssueResponse.issue.priority);
        //Provider Info
        ACET_UpdateORSRequest.ProviderInfo providerInfo = new ACET_UpdateORSRequest.ProviderInfo();
        providerInfo.commonProviderID = ACET_UpdateORSForWorkQueue.objStrOrBlank(readIssueResponse.issue.serviceRequest.commonProviderId);
        providerInfo.contractNumber = ACET_UpdateORSForWorkQueue.objStrOrBlank(readIssueResponse.issue.provider.contractNumber);
        providerInfo.degreeName = '';
        providerInfo.emailIndicator = '';
        providerInfo.ipa = ACET_UpdateORSForWorkQueue.objStrOrBlank(readIssueResponse.issue.provider.ipa);
        providerInfo.languageCode = '';
        providerInfo.marketSegmentName = '';
        List<String> npis = new List<String> ();
        providerInfo.npis = npis;
        providerInfo.originalEffectiveDate = '';
        providerInfo.otherIpa = '';
        providerInfo.panelNumber = '';
        //Provider Info - Pcp
        ACET_UpdateORSRequest.Pcp pcp = new ACET_UpdateORSRequest.Pcp();
        //Provider Info - Pcp - Address
        ACET_UpdateORSRequest.Address pcpAddress = new ACET_UpdateORSRequest.Address();
        pcpAddress.city = '';
        pcpAddress.countryCode = '';
        pcpAddress.countryName = '';
        pcpAddress.countyCode = '';
        pcpAddress.countyName = '';
        pcpAddress.state = ACET_UpdateORSForWorkQueue.objStrOrBlank(readIssueResponse.issue.provider.pcp.state);
        pcpAddress.street1 = '';
        pcpAddress.street2 = '';
        pcpAddress.zip = ACET_UpdateORSForWorkQueue.objStrOrBlank(readIssueResponse.issue.provider.pcp.zip);// Added by Vishnu
        pcpAddress.zip4 = '';
        pcp.address = pcpAddress;

        pcp.mpin = ACET_UpdateORSForWorkQueue.objStrOrBlank(readIssueResponse.issue.provider.pcp.mpin);//Edited by Vishnu
        pcp.mpinSequenceNumber = ACET_UpdateORSForWorkQueue.objStrOrBlank(readIssueResponse.issue.provider.pcp.mpinSequenceNumber);
        //Provider Info - Pcp - Phone
        ACET_UpdateORSRequest.CellPhone pcpPhone = new ACET_UpdateORSRequest.CellPhone();
        pcpPhone.areaCode = '';
        pcpPhone.number_Z = ACET_UpdateORSForWorkQueue.objStrOrBlank(readIssueResponse.issue.serviceRequest.providerPhoneNumber);
        pcpPhone.extension = '';
        pcpPhone.extension2 = '';
        pcp.Phone = pcpPhone;

        pcp.providerId = '';
        //Provider Info - Pcp - Provider Name
        ACET_UpdateORSRequest.DependentName pcpProviderName = new ACET_UpdateORSRequest.DependentName();
        pcpProviderName.firstInitial = ACET_UpdateORSForWorkQueue.objStrOrBlank(readIssueResponse.issue.provider.pcp.firstInitial);
        pcpProviderName.firstName = ACET_UpdateORSForWorkQueue.objStrOrBlank(readIssueResponse.issue.serviceRequest.pcpFirstName);
        pcpProviderName.lastName = ACET_UpdateORSForWorkQueue.objStrOrBlank(readIssueResponse.issue.serviceRequest.pcpLastName);
        pcpProviderName.middleInitial = '';
        pcp.providerName = pcpProviderName;

        pcp.taxId = ACET_UpdateORSForWorkQueue.objStrOrBlank(readIssueResponse.issue.provider.pcp.taxId);
        pcp.taxPrefix = ACET_UpdateORSForWorkQueue.objStrOrBlank(readIssueResponse.issue.provider.pcp.taxPrefix);
        pcp.taxSuffix = ACET_UpdateORSForWorkQueue.objStrOrBlank(readIssueResponse.issue.provider.pcp.taxSuffix);
        providerInfo.pcp = pcp;

        providerInfo.pcpValidatedFlag = ACET_UpdateORSForWorkQueue.objStrOrBlank(readIssueResponse.issue.provider.pcpValidatedFlag);
        providerInfo.productCode = '';
        providerInfo.programSearchCode = '';
        //Provider Info - Provider
        ACET_UpdateORSRequest.Pcp provider = new ACET_UpdateORSRequest.Pcp();
        //Provider Info - Provider - Address
        ACET_UpdateORSRequest.Address providerAddress = new ACET_UpdateORSRequest.Address();
        providerAddress.city = ACET_UpdateORSForWorkQueue.objStrOrBlank(readIssueResponse.issue.serviceRequest.providerCity);
        providerAddress.countryCode = '';
        providerAddress.countryName = '';
        providerAddress.countyCode = '';
        providerAddress.countyName = '';
        providerAddress.state = ACET_UpdateORSForWorkQueue.objStrOrBlank(readIssueResponse.issue.provider.provider.state);
        providerAddress.street1 = ACET_UpdateORSForWorkQueue.objStrOrBlank(readIssueResponse.issue.serviceRequest.providerStreet1);
        providerAddress.street2 = ACET_UpdateORSForWorkQueue.objStrOrBlank(readIssueResponse.issue.serviceRequest.providerStreet2);
        providerAddress.zip = ACET_UpdateORSForWorkQueue.objStrOrBlank(readIssueResponse.issue.provider.provider.zip);
        providerAddress.zip4 = '';
        provider.address = providerAddress;

        provider.mpin = ACET_UpdateORSForWorkQueue.objStrOrBlank(readIssueResponse.issue.provider.provider.mpin);
        provider.mpinSequenceNumber = ACET_UpdateORSForWorkQueue.objStrOrBlank(readIssueResponse.issue.provider.provider.mpinSequenceNumber);
        //Provider Info - Provider - Phone
        ACET_UpdateORSRequest.CellPhone providerPhone = new ACET_UpdateORSRequest.CellPhone();
        providerPhone.areaCode = '';
        providerPhone.number_Z = ACET_UpdateORSForWorkQueue.objStrOrBlank(readIssueResponse.issue.serviceRequest.providerPhoneNumber);
        providerPhone.extension = '';
        providerPhone.extension2 = '';
        provider.Phone = providerPhone;

        provider.providerId = '';
        //Provider Info - Provider - Provider Name
        ACET_UpdateORSRequest.DependentName providerName = new ACET_UpdateORSRequest.DependentName();
        providerName.firstInitial = ACET_UpdateORSForWorkQueue.objStrOrBlank(readIssueResponse.issue.provider.provider.firstInitial);
        providerName.firstName = ACET_UpdateORSForWorkQueue.objStrOrBlank(readIssueResponse.issue.serviceRequest.providerFirstName);
        providerName.lastName = ACET_UpdateORSForWorkQueue.objStrOrBlank(readIssueResponse.issue.serviceRequest.providerLastName);
        providerName.middleInitial = '';
        provider.providerName = providerName;

        provider.taxId = ACET_UpdateORSForWorkQueue.objStrOrBlank(readIssueResponse.issue.provider.provider.taxId);
        provider.taxPrefix = ACET_UpdateORSForWorkQueue.objStrOrBlank(readIssueResponse.issue.provider.provider.taxPrefix);
        provider.taxSuffix = ACET_UpdateORSForWorkQueue.objStrOrBlank(readIssueResponse.issue.provider.provider.taxSuffix);
        providerInfo.provider = provider;

        providerInfo.providerSourceSystem = ACET_UpdateORSForWorkQueue.objStrOrBlank(readIssueResponse.issue.provider.providerSourceSystem);
        providerInfo.providerValidatedFlag = ACET_UpdateORSForWorkQueue.objStrOrBlank(readIssueResponse.issue.provider.providerValidatedFlag);
        providerInfo.serviceMarket = ACET_UpdateORSForWorkQueue.objStrOrBlank(readIssueResponse.issue.provider.serviceMarket);
        providerInfo.serviceZip = ACET_UpdateORSForWorkQueue.objStrOrBlank(readIssueResponse.issue.provider.serviceZip);
        providerInfo.specialtyText = '';
        providerInfo.stateIssuedID = '';
        providerInfo.statusCode = '';
        providerInfo.tpsmIndicator = '';
        issue.providerInfo = providerInfo;

        issue.pssActionTaken = '';
        issue.raplNoblxIndicator = '';
        issue.reasonCategory = ACET_UpdateORSForWorkQueue.objStrOrBlank(readIssueResponse.issue.reasonCategory);
        issue.reasonCode = ACET_UpdateORSForWorkQueue.objStrOrBlank(readIssueResponse.issue.reasonCode);
        issue.reasonHcnasType = '';
        issue.reasonType = '';
        issue.repeatIndicator = '';
        issue.routeConditionCode = '';
        issue.seriesDesignator = '';
        //Service Request
        ACET_UpdateORSRequest.ServiceRequest serviceRequest = new ACET_UpdateORSRequest.ServiceRequest();
        serviceRequest.addressUpdateRequiredIndicator = '';
        serviceRequest.bulkCheckIndicator = '';
        serviceRequest.checkPayee = '';
        serviceRequest.checkStockNumber = '';
        serviceRequest.claimAdjustmentRequiredIndicator = '';
        serviceRequest.clientId = '';
        serviceRequest.countyCode = '';
        serviceRequest.countyName = '';
        serviceRequest.diamondProviderLocationId = ACET_UpdateORSForWorkQueue.objStrOrBlank(readIssueResponse.issue.ServiceRequest.diamondProviderLocationId);
        serviceRequest.diamondProviderLocationName = ACET_UpdateORSForWorkQueue.objStrOrBlank(readIssueResponse.issue.ServiceRequest.diamondProviderLocationName);
        serviceRequest.documentControlNumber = '';
        serviceRequest.originatorLocationId = ACET_UpdateORSForWorkQueue.objStrOrBlank(readIssueResponse.issue.ServiceRequest.originatorLocationId);
        serviceRequest.policyNumber = '';
        serviceRequest.productId = '';
        serviceRequest.resolutionCode = '';
        serviceRequest.srProductType = '';
        serviceRequest.srSubType = '';
        serviceRequest.srType = '';
        serviceRequest.subCodeId = '';
        serviceRequest.wbxUpdateRequiredIndicator = '';
        issue.serviceRequest = serviceRequest;

        issue.status = 'C'; // C for closing, as same as read issue response for routing
        if(orsRequestDetails.routeOrClose == 'routeCase'){
            issue.status = ACET_UpdateORSForWorkQueue.objStrOrBlank(readIssueResponse.issue.status);
        }
        issue.subReasonText = '';
        issue.surveyCode = '';
        issue.updateDate = '';
        issue.updateTime = '';

        data.issue = issue;
        returnObject.data = data;

    }
    catch(Exception e){
        System.debug('@@@ HOME PAGE @@ createUpdateRequest METHOD :: ' + e.getMessage());
        System.debug('@@@ HOME PAGE @@ createUpdateRequest METHOD :: ' + e.getLineNumber());
    }
    return returnObject;
}
    Public static String objStrOrBlank(Object strObj)
    {

        return String.isNotBlank(String.valueOf(strObj))?String.valueOf(strObj):'';
    }
    Public Static Boolean strNotBlank(Object str)
    {
        return String.isNotBlank(String.valueOf(str));
    }
}