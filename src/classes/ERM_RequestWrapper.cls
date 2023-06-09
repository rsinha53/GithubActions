global without sharing class ERM_RequestWrapper {
    
    public Integer ElrID;
    public Integer ElrDualPlatformPolicy;
    public Integer ElrPlatform;
    public Integer ElrRequestType;
    public Integer ElrRequester;
    public Integer ElrPendedCount;
    public Boolean ElrMemberSeekingServices;
    public Boolean ElrPlatinumBroker;
    public Boolean ElrSRT;
    public String ElrRequestReceivedDate;
    public Boolean ElrDedicated;
    public String ElrQualifyingEventDate;
    public String ElrCustomerName;
    public String ElrDateOfHire;
    public String ElrCallerName;
    public String ElrCOBRAPaidThruDate;
    public String ElrCallerPhone;
    public String ElrPolicyId;
    public String ElrDeveloped;
    public integer ElrQualifyingEventReason;
    public Integer ElrActualTransactions;
    public String ElrQualifyingEventReasonNotes;
    public Integer ElrEstimatedTransactions;
    public String ElrETrackNbr;
    public String ElrExternalEmail;
    public Boolean ElrMajorPublicSector;
    public String elrDualMaintenancePlatform;
    public Integer ElrAddBy;
    public Boolean IsSpecialRequest;
    public String ElrAddDate;
    public Boolean ElrIsACETSystem;
    public Integer ElrChgBy;
    public Boolean ElrThresholdMailSendStatus;
    public String ElrChgDate;
    public Integer ElrDualResId;
    public String ElrRequesterName;
    public String ElrMedicalGroupNbr;
    public String ElrPeopleSoftID;
    public Integer ElrReportNeeded;
    public String ElrClassPlan;
    public Integer ElrCompanyCode;
    public String ElrRequesterDepartment;
    public Integer ElrTransactionsToDate;
    public Integer ElrClosedBy;
    public Boolean ElrIEX;
    public String ElrClosedDate;
    public Integer ElrIA;
    public Boolean ElrOnShoreFlag;
    public Boolean ElrSSNChecked;
    public Boolean ElrAutoClosed;
    public Integer ElrVendorId;
    public Integer ElrVendorReassign;
    public String ElrOrigElecTermEffDate;
    public Boolean ElrCompleteForm;
    public String ElrCQER;
    public Boolean ElrSubmitted;
    public String DenialReason;//Not present in Excel mapping List
    public String ElrEffectiveDate;
    public String ElrDeleteDate;
    public String ElrRowVersion;
    public String ElrTerminationDate;
    public list<Enrollees> Enrollees;
    public RequestDetails RequestDetails;
    
    public Products products;
    Public list<Notes> Notes;
    public list<Files> Files;
    public list<DualPlatformDetails> dualPlatformDetails;
    Public Dependents_CPTIN Dependents;
    Public ReportSelection ReportSelection;
    Public W2ReportSelection W2ReportSelection;
    Public EServiceSelection EServiceSelection;
    Public List<EServicePolicies>EServicePolicies;
    Public EServiceUserSelection EServiceUserSelection;
    Public class EServiceUserSelection{
        Public string eupPolicyID;
        Public string eupFirstName;
        Public string eupLastName;
        Public string eupEmail;
        Public string eupPhone;
        Public string eupUserID;
        Public string eupFirstNameNew;
        Public string eupLastNameNew;
        Public string eupEmailNew;
        Public string eupPhoneNew;
        Public string eupUserIDNew;
        Public boolean eupComminicationCenterOnly;
        Public boolean eupIsCMA;
        Public boolean eupSamePermissionAsPolicy;
        Public boolean eupVerification;
        Public boolean eupEligibilityUpdate;
        Public boolean eupEligibilityInquiry;
        Public boolean eupE3;
        Public boolean eupClaimView;
        Public boolean eupBillView;
        Public boolean eupBillPay;
        Public boolean eupReporting;
        Public boolean eupBanking;
        Public string eupBillGroupDes;
        Public string eupBillGroups;
        Public boolean eupAllowReporting;
        Public integer eupremoveReporting;
        Public boolean eupInactivate;
        Public boolean eupReactivate;
        Public boolean eupSubmited;
        Public integer eupReportingLevel;
        Public integer eupAccessLevel;
        Public integer eupReportingLevelInd;
        Public integer eupAccessLevelInd;
        Public string eupCustomerNumber;
        Public string eupPolicy;
        Public boolean eupFirstNameNewInd;
        Public boolean eupLastNameNewInd;
        Public boolean eupEmailNewInd;
        Public boolean eupPhoneNewInd;
        Public boolean eupUserIDNewInd;
        
    }
    Public class EServicePolicies{
        Public integer espPaperInvoice;
        Public string espEServicePlatform;
        Public string espUserID;
        Public integer espAccountType;
        Public integer espAccountTypeChange;
        Public string espPolicy;
        Public string espEmployerName;
        Public string espCustomerNumber;
        Public boolean espComminicationCenterOnly;
        Public boolean espSamePermissionAsPolicy;
        Public boolean espEligibilityUpdate;
        Public boolean espEligibilityInquiry;
        Public boolean espE3;
        Public boolean espClaimView;
        Public boolean espBillView;
        Public boolean espBillPay;
        Public boolean espBanking;
        Public boolean espWait48Hours;
        Public boolean espInactivatePolicy;
        Public boolean espReporting;
        Public string espBillGroupDes;
        Public string espBillGroups;
        Public boolean espAllowReporting;
        Public integer espReportingLevel;
        Public integer  espAccessLevel;
        Public boolean espAllUserHasSamePermission;
        Public boolean espVerification;
        Public boolean espEnrollment;
        Public boolean espsubmited; 
        Public List<EServiceUserSelection> EServicePolicyUsers;
    }
    
    Public class EServiceSelection{
        Public string esrName;
        Public string esrAddress;
        Public string esrAddress2;
        Public string esrCity;
        Public string esrState;
        Public string esrZip;
        Public string esrZipSub;
        Public boolean esrAddressChange;
        Public string  esrNameNew;
        Public string esrAddressNew;
        Public string esrAddress2New;
        Public string esrCityNew;
        Public string esrStateNew;
        Public string esrZipNew;
        Public string esrZipSubNew;
        Public string esrEmployerType;
        Public integer esrAccountType;
        Public integer esrAllowReporting;
        Public integer esrReporting;
        Public integer esrReportingInd;
        Public integer esrremoveReporting;
        Public integer esrAccessLevelInd;
        Public integer esrreportinglevelind;
        Public integer esrReportingLevel;
        Public integer esrAccessLevel;
        Public boolean esrClaimsEOBView;
        Public string esrKeyToSmall;
        Public string esrSmallToKey;
        Public string esrAddReporting;
        Public string esrUserID;
        Public string esrComments;
        Public boolean esrAcknowledgement;
    }
    public class RequestDetails {
        public Integer ErdLifeAmount;
        public Integer ErdID;
        public String ErdLifeSalary;
        public String ErdDifferExplanation;
        public Boolean ErdNonContributory;
        public String ErdDescription;
        public string ErdRequestId;
        public String ErdPrimaryPhysicianNbr;
        public String ErdPrimaryDentistNbr;
        public String ErdGrpPreviousNumber;
        public String ErdGrpNumber;
        public String ErdGroupPhoneNumber;
        public String ErdGroupFaxNumber;
        public String ErdGroupNewPhysicalAddress;
        public String ErdGroupNewPhysicalCity;
        public String ErdGroupNewPhysicalState;
        public String ErdGroupNewPhysicalZip;
        public String ErdGroupNewBillingAddress;
        public String ErdGroupNewBillingCity;
        public String ErdGroupNewBillingState;
        public String ErdGroupNewBillingZip;
        public String ErdApprovingChangeName;
        public String ErdApprovingChangeTitle;
        public Integer ErdTransferringUHG;
        public String ErdNewPolicyNumber;
        public String ErdPrimePolicyNumberTerm;
        public String ErdPrimeCustomerNumberTerm;
        public String ErdPeopleSoftIDTerm;
        public integer ErdRetroExclustionReason;
        public Integer ErdTerminationReason;
        public Integer ErdTerminationLevel;
        public String ErdTerminationNotes;
        public Integer ErdChgBy;
        public String ErdChgDate;
        public Integer ErdAddBy;
        public String ErdAddDate;
        Public String ElrRowVersion;
        public String ErdDeleteDate;
        public String ErdOriginalCOBRAStartDate;
        public Integer ErdSameForAll;
        public String ErdNewPlatform;
        public Integer ErdTermDependentCount;
        public String ErdPrimePolicyNumberReinstate;
        public String ErdPrimeCustomerNumberReinstate;
        public String ErdPeopleSoftIDReinstate;
        public Boolean ErdDolFinal;
        Public string ErdSubscriberFirstName;
    }
    
    public class Enrollees {
        public Integer EnrID;
        public string EnrRequestId;
        public String EnrName;
        public String EnrSSN;
        Public String EnrDateOfHire;
        public Integer EnrGender;
        public Integer EnrRelationshipToSubscriber;
        public String EnrAddress;
        public String EnrCity;
        public String EnrState;
        public String EnrZip;
        public String EnrDOB;
        public Integer EnrChgBy;
        public String EnrChgDate;
        public Integer EnrAddBy;
        public String EnrAddDate;
        public String EnrFirstName;
        public String EnrMiddleName;
        public String EnrLastName;
        public String EnrDeleteDate;
        public String EnrCOBBeginDate;
        public String EnrCOBEndDate;
        public String EnrPriorCoverageBeginDate;
        public String EnrPriorCoverageEndDate;
        public String EnrSalary;
        public String EnrMedicarePartAStart;
        public String EnrMedicarePartAEnd;
        public String EnrMedicarePartBStart;
        public String EnrMedicarePartBEnd;
        public String EnrMedicarePartDStart;
        public String EnrMedicarePartDEnd;
        public String EnrHomePhone;
        public String EnrRetirementDate;
        public String EnrDentist;
        public String EnrPhysician;
        public Boolean EnrExistingPatient;
        public String EnrEmployeeId;
        public String EnrEmail;
        public String EnrDeliveryPreference;
        public String EnrCorrectedSSN;
        public String EnrAddress2;
        public String EnrMaritalStatus;
        public String EnrAlternateID;
        public String EnrApproverName;
        public String EnrApproverTitle;
        public String EnrCPTIN;
        public Integer EnrRowVersion;
    }
    public class Products {
        public Integer prdID;
        Public Integer prdRequestId;
        public String prdEnrolleeId;
        public Boolean prdMedical;
        public Boolean prdDental;
        public Boolean prdVision;
        public Boolean prdRx;
        public Boolean prdMedicalCobraTY;
        public Boolean prdMedicalCobraTC;
        public Boolean prdDentalCobraTY;
        public Boolean prdDentalCobraTC;
        public Boolean prdVisionCobraTY;
        public Boolean prdVisionCobraTC;
        public Boolean prdRXCobraTY;
        public Boolean prdRXCobraTC;
        public Boolean prdSupplementalCobraTY;
        public Boolean prdSupplementalCobraTC;
        public Boolean prdStandAloneCobraTY;
        public Boolean prdStandAloneCobraTC;
        public Boolean prdHSA;
        public Boolean prdHMO;
        public Boolean prdPPO;
        public Boolean prdPOS;
        public Boolean prdBasicLife;
        public Boolean prdSTD;
        public Boolean prdSTDBuyUp;
        public Boolean prdLTD;
        public Boolean prdLTDBuyUp;
        public Boolean prdSDHP;
        public Boolean prdMedicalSupplemental;
        public Boolean prdSupplementalEE;
        public Boolean prdSupplementalCH;
        public Boolean prdSupplementalSP;
        public Boolean prdStandalone;
        public integer prdMedicalMarket;
        public integer prdVisionMarket;
        public integer prdDentalMarket;
        public integer prdMedicalSuppMarket;
        public integer prdRxMarket;
        public integer prdStandaloneMarket;
        public String prdMedicalPVRC;
        public String prdVisionPVRC;
        public String prdDentalPVRC;
        public String prdMedicalSuppPVRC;
        public String prdRxPVRC;
        public String prdStandalonePVRC;
        public String prdBasicLifePVRC;
        public Boolean prdSupplemental;
        public String prdSupplementalAmount;
        public String prdSupplementBenefitFactor;
        public String prdADnDAmount;
        public String prdADnDBenefitFactor;
        public String prdPlanCode;
        public String prdLocationCode;
        public String prdDentalPlan;
        public String prdSuppEEAmount;
        public String prdSuppSPAmount;
        public String prdSuppCHAmount;
        public String prdOHSB;
        public Integer prdAddBy;
        public String prdAddDate;
        public Integer prdChangeBy;
        public String prdChangeDate;
        public String prdRowVersion;
        public String prdDeleteDate;
        public String prdFamilySelection;
        public integer prdSupplementalLifeADnD;
        public Boolean prdFamilySelf;
        public Boolean prdFamilySpouse;
        public Boolean prdFamilyPartner;
        public Boolean prdFamilyDependents;
        public String prdFamilyChildCount;
        public String prdBLOC;
        public String prdBasicLifeAmount;
        public integer prdSupplementalADnD;
        public String prdBasicLifeBenefitFactor;
        public String prdStatus;
        public String prdProduct;
        public String prdBLADnDAmount;
        public String prdEEBaseAnnualSalary;
        public String prdBLHoursWorked;
        public Boolean prdDependentBasicLife;
        public String prdTransType;
        public String prdPoliyNo;
        public String prdQerCode;
        public String prdMedicalEffectiveDate;
        public String prdMedicalTermDate;
        public String prdBasicLifeEffectiveDate;
        public String prdBasicLifeTermDate;
        public String prdDependentBLEffectiveDate;
        public String prdDependentBLTermDate;
        public String prdSuppEEEffectiveDate;
        public String prdSuppEETermDate;
        public String prdSuppSPEffectiveDate;
        public String prdSuppSPTermDate;
        public String prdLTDEffectiveDate;
        public String prdLTDTermDate;
        public String prdSTDEffectiveDate;
        public String prdSTDTermDate;
    }
    
    public class Notes {
        public String HstDescription;
        public Integer hstID;
        public Integer hstLinkingID;
        public Integer hstLinkTypeID;
        public Integer hstSeverity;
        public Integer hstEventType;
        public Integer hstChgBy;
        public String hstChgDate;
        public Integer hstAddBy;
        public String hstAddDate;
    }
    public class Files {
        public String ErfDisplayName;
        public String ErfServerPath;
        public String ErfFileName;
        public String ErfNotes;
        public Integer ErfAddBy;
        public String ErfAddDate;
        public String ErfChgBy;
        public String ErfChgDate;
        public String ErfDeleteDate;
        public Integer ErfRequestID;
        public Integer erfID;
        Public String erfRowVersion;
    }
    public class DualPlatformDetails{
        public String dualPlanCode;
        public String dualAddDate;
        public Integer dualChgBy;
        public Integer dualAddBy;
        public String dualChgDate;
        public Integer dualPlatformId;
        public String dualPlatformDesc;
        public String dualPolicy;
        public Integer dualID;
        public Integer dualRequestId;
        
    }
    public class Assignments{
        public Integer eraID;
        public Integer eraRequestID;
        public Integer eraUserID;
        public Integer eraQueueID;
        public Integer eraStatusID;
        public Integer eraLastQueue;
        public String eraStatusLong;
        public Integer eraChgBy;
        Public String eraChgDate;
        Public Integer eraAddBy;
        Public String eraAddDate;
        public String eraRowVersion;
        public Integer eraVendorId;
        public String eraLatestUpdateDate;        
    }
    public class Dependents_CPTIN{
        public Integer depID;        
        public Integer depRequestId;
        public String dep1FirstName;
        public String dep1LastName;
        public string dep1DOB;
        public Integer dep1Relationship;
        public string dep1CPTIN;
        public string dep2FirstName; 
        public string dep2LastName;
        public string dep2DOB;
        public Integer dep2Relationship;
        public string dep2CPTIN;
        public string dep3FirstName;
        public string dep3LastName;
        public String dep3DOB;
        public Integer dep3Relationship;
        public String dep3CPTIN;
        public String dep4FirstName;
        public String dep4LastName;
        public String dep4DOB;
        public Integer dep4Relationship;
        public String dep4CPTIN;
        public String dep5FirstName;
        public String dep5LastName;
        public String dep5DOB;
        public Integer dep5Relationship;
        public String dep5CPTIN;
        public String dep6FirstName;
        public String dep6LastName;
        public String dep6DOB;
        public Integer dep6Relationship;
        public String dep6CPTIN;
        public String dep7FirstName;
        public String dep7LastName;
        public String dep7DOB;
        public Integer dep7Relationship;
        public String dep7CPTIN;
        public String dep8FirstName;
        public String dep8LastName;
        public String dep8DOB;
        public Integer dep8Relationship;
        public String dep8CPTIN;
        public String dep9FirstName;
        public String dep9LastName;
        public String dep9DOB;
        public Integer dep9Relationship;
        public String dep9CPTIN;
        public Integer depAddBy;
        public String depAddDate;
        public Integer depChgBy;
        public String depChgDate;     
    }
    public class ReportSelection{
        public Integer rptID;
        public Integer rptRequestId;
        public boolean rptMedical;
        public boolean rptDental;
        public boolean rptVision;
        public boolean rptRx;
        public boolean rptGx;
        public boolean rptStandAlone;
        public boolean rptLife;
        public String rptSystem;
        public String rptStartDate;
        public String rptStopDate;
        public boolean rptAddresses;
        public boolean rptCBIZ_VBP_Eligibility_Report;
        public boolean rptCES_Member_Master;
        public boolean rptDHP_Elig_Report;
        public boolean rptED_Count_by_Age_Range;
        public boolean rptED_Count_by_Age_Range_Variable;
        public boolean rptED_Count_by_Age_Range_Sex;
        public boolean rptED_Count_by_Mbrs_Covered;
        public boolean rptED_Count_by_Mkt_Site_Prod_Type;
        public boolean rptED_Count_by_PCP_MPIN;
        public boolean rptED_Count_by_Prod_Type;
        public boolean rptED_Count_by_Prod_Type_Mbrs_Cov;
        public boolean rptED_Count_by_Prod_Type_PVRC;
        public boolean rptED_Count_by_PV_RC;
        public boolean rptED_Count_by_PVRC_Mbrs_Covered;
        public boolean rptED_Count_by_PVRC_State;
        public boolean rptED_Count_by_Sex_Age;
        public boolean rptED_Count_by_State_ZIP;
        public boolean rptED_Count_by_Suffix_State;
        public boolean rptED_Count_by_Suffix_State_City;
        public boolean rptED_Count_by_UnderOver_65;
        public boolean rptED_Table_by_Mkt_Site;
        public boolean rptED_Table_by_PVRC_and_Cov_Type;
        public boolean rptEDCount_by_Age;
        public boolean rptHarvard_Pilgrim_Roster;
        public boolean rptMedicare_Report;
        public boolean rptMember_SSN_Collection_Report;
        public boolean rptName_and_Address_Report;
        public boolean rptNew_Business_Report;
        public boolean rptOne_Line_Edit_Report_Feedback_File;
        public boolean rptPassport_Membership_Standard_Report;
        public boolean rptPCP;
        public boolean rptPhone_Number_Report;
        public boolean rptRetirees;
        public boolean rptRoster_Report;
        public boolean rptSpreadsheet_Solutions_Template;
        public boolean rptSurviving_Spouses;
        public boolean rptAnnual_W2_Reporting;
        public boolean rptMarketplace_Census;
        public boolean rptPrivacyAttestation;
        public boolean rptUnmaskSSN;
        public String rptBusinessJustification;
        public Integer rptAddBy;
        public String rptAddDate;
        public Integer rptChangeBy;
        public String rptChangeDate;
        public String rptDeleteDate;
        public String rptRowVersion;
        public String rptPVRC;
        public String rptPVRCValues;
        public String rptEnvironment;
        
    }
    public class W2ReportSelection{
        Public Integer w2rptID;
        Public Integer w2rptRequestId;
        Public integer w2rptRequestYear;
        Public String w2rptInvoiceMonth;
        Public String w2rptReportDates1;
        Public String w2rptReportDates2;
        Public String w2rptReportDates3;
        Public String w2rptAdditionalNicePolicyNumbers;
        Public boolean w2rptUnmaskSSN;
        Public String w2rptBusinessJustification;
        Public boolean w2rptPrivacyAttestation;
        Public Integer w2rptAddBy;
        Public String w2rptAddDate;
        Public Integer w2rptChangeBy;
        Public String w2rptChangeDate;
        Public String w2rptRowVersion;
        Public String w2rptPVRC;
        Public String w2rptPVRCValues;
        
    }
    
}